[CmdletBinding()]
param(
    [switch]$InstallOnly,
    [switch]$Offline,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$RuntimeArguments
)

# Windows PowerShell 5.1 is sufficient; no SDK, Python, Node, or global MCP entry.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
. (Join-Path $PSScriptRoot 'runtime-verification.ps1')

function Write-BootstrapStatus([string]$Message) {
    [Console]::Error.WriteLine('[HAPAtlas bootstrap] ' + $Message)
}

function Get-PinnedDownload([string]$Url, [string]$Destination, [long]$MaximumBytes) {
    if ($Offline) { throw 'BOOTSTRAP_OFFLINE: The pinned runtime is not cached. Reconnect to GitHub and restart the agent once.' }
    $uri = [Uri]$Url
    if ($uri.Scheme -cne 'https' -or $uri.Host -cne 'github.com' -or
        -not $uri.AbsolutePath.StartsWith('/mroshdy91/HAPAtlas-Plugin/releases/download/', [StringComparison]::Ordinal)) {
        throw 'BOOTSTRAP_PIN_INVALID: Runtime downloads must use the pinned public HAPAtlas release.'
    }
    Add-Type -AssemblyName System.Net.Http
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $http = [Net.Http.HttpClient]::new()
    $http.Timeout = [TimeSpan]::FromSeconds(180)
    $http.DefaultRequestHeaders.UserAgent.ParseAdd('HAPAtlas-Plugin/1.0')
    $response = $null
    $inputStream = $null
    $outputStream = $null
    try {
        $response = $http.GetAsync($uri, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
        [void]$response.EnsureSuccessStatusCode()
        if ($response.Content.Headers.ContentLength -gt $MaximumBytes) { throw 'Download exceeds the pinned size limit.' }
        $inputStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
        $outputStream = [IO.File]::Open($Destination, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
        $buffer = New-Object byte[] 81920
        $total = 0L
        $deadline = [DateTime]::UtcNow.AddSeconds(180)
        while ($true) {
            $read = $inputStream.ReadAsync($buffer, 0, $buffer.Length)
            if (-not $read.Wait(30000)) { throw 'Download stalled for 30 seconds.' }
            $count = $read.GetAwaiter().GetResult()
            if ($count -eq 0) { break }
            $total += $count
            if ($total -gt $MaximumBytes -or [DateTime]::UtcNow -gt $deadline) { throw 'Download exceeded its size or time limit.' }
            $outputStream.Write($buffer, 0, $count)
        }
    } catch {
        throw ('BOOTSTRAP_DOWNLOAD_FAILED: Could not download the pinned release. Check free disk space, proxy/firewall access to GitHub and release-assets.githubusercontent.com, then restart the agent. ' + $_.Exception.Message)
    } finally {
        if ($null -ne $outputStream) { $outputStream.Dispose() }
        if ($null -ne $inputStream) { $inputStream.Dispose() }
        if ($null -ne $response) { $response.Dispose() }
        $http.Dispose()
    }
}

function ConvertTo-NativeArgument([string]$Value) {
    # CommandLineToArgvW-compatible quoting, including trailing backslashes.
    return '"' + ([regex]::Replace([regex]::Replace($Value, '(\\*)"', '$1$1\"'), '(\\+)$', '$1$1')) + '"'
}

function Invoke-VerifiedInstaller([string]$Bundle) {
    $powershell = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $start = [Diagnostics.ProcessStartInfo]::new($powershell)
    $start.UseShellExecute = $false
    $start.CreateNoWindow = $true
    $start.WindowStyle = [Diagnostics.ProcessWindowStyle]::Hidden
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.Arguments = '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ' + (ConvertTo-NativeArgument (Join-Path $Bundle 'install.ps1')) + ' -RuntimeOnly'
    $process = [Diagnostics.Process]::Start($start)
    try {
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        $process.WaitForExit()
        Write-BootstrapStatus $stdout.GetAwaiter().GetResult().Trim()
        $errorText = $stderr.GetAwaiter().GetResult().Trim()
        if ($errorText.Length -gt 0) { Write-BootstrapStatus $errorText }
        if ($process.ExitCode -ne 0) {
            throw 'BOOTSTRAP_INSTALL_FAILED: The verified runtime installer did not complete. Follow its prerequisite or recovery message above, then restart the agent. Existing activation is retained or recoverable by its transaction journal.'
        }
    } finally { $process.Dispose() }
}

$lock = $null
try {
    if ($env:OS -cne 'Windows_NT' -or -not [Environment]::Is64BitOperatingSystem -or -not [Environment]::Is64BitProcess -or
        $env:PROCESSOR_ARCHITECTURE -notmatch '^(AMD64|x86_64)$') {
        throw 'BOOTSTRAP_PLATFORM: HAPAtlas requires an x64 Windows agent process. ARM and non-Windows hosts are not supported.'
    }
    $metadata = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\plugin.metadata.json') -Raw | ConvertFrom-Json
    $pin = $metadata.runtime.release
    Assert-HapAtlasPin $pin
    $cacheRoot = Join-Path $env:LOCALAPPDATA 'HAPAtlas\PluginCache'
    Assert-HapAtlasPlainPath $cacheRoot
    [void][IO.Directory]::CreateDirectory($cacheRoot)
    $deadline = [DateTime]::UtcNow.AddMinutes(5)
    $lockPath = Join-Path $cacheRoot 'bootstrap.lock'
    Assert-HapAtlasPlainPath $lockPath
    while ($null -eq $lock) {
        try { $lock = [IO.File]::Open($lockPath, [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None) }
        catch [IO.IOException] {
            if ([DateTime]::UtcNow -ge $deadline) { throw 'BOOTSTRAP_BUSY: Another HAPAtlas install is still running. Let it finish and restart the agent.' }
            Start-Sleep -Milliseconds 250
        }
    }
    $cache = Join-Path $cacheRoot $pin.zip_sha256
    if (Test-Path -LiteralPath $cache) {
        try { Assert-HapAtlasBundle (Join-Path $cache 'bundle') (Join-Path $cache 'inventory.json') $pin }
        catch {
            if ($Offline) { throw ('BOOTSTRAP_CACHE_INVALID: The cache failed verification. Reconnect and restart to redownload. ' + $_.Exception.Message) }
            Assert-HapAtlasPlainPath $cache
            $quarantine = Join-Path $cacheRoot ('quarantine-' + [Guid]::NewGuid().ToString('N'))
            [IO.Directory]::Move($cache, $quarantine)
            Write-BootstrapStatus ('Invalid cached download preserved at ' + $quarantine + '; downloading a verified copy.')
        }
    }
    if (-not (Test-Path -LiteralPath $cache)) {
        $stage = Join-Path $cacheRoot ('stage-' + [Guid]::NewGuid().ToString('N'))
        [void][IO.Directory]::CreateDirectory($stage)
        # Failed stages are retained for diagnosis; they are never treated as installed.
        Write-BootstrapStatus ('Downloading ' + $pin.tag + ' (first use of this pinned runtime).')
        $inventoryPath = Join-Path $stage 'inventory.json'
        Get-PinnedDownload $pin.inventory_url $inventoryPath 2097152
        Assert-HapAtlasHash $inventoryPath $pin.inventory_sha256
        $zipPath = Join-Path $stage 'runtime.zip'
        Get-PinnedDownload $pin.zip_url $zipPath $pin.zip_size
        Assert-HapAtlasHash $zipPath $pin.zip_sha256
        if ((Get-Item -LiteralPath $zipPath).Length -ne $pin.zip_size) { throw 'BOOTSTRAP_ZIP_SIZE: Download length differs from the release pin.' }
        Expand-HapAtlasBundle $zipPath (Join-Path $stage 'bundle') $inventoryPath
        Assert-HapAtlasBundle (Join-Path $stage 'bundle') $inventoryPath $pin
        [IO.Directory]::Move($stage, $cache)
    }
    $bundle = Join-Path $cache 'bundle'
    $installRoot = Join-Path $env:LOCALAPPDATA 'HAPAtlas\bin'
    Assert-HapAtlasPlainPath $installRoot
    $activeFile = Join-Path $installRoot 'active.txt'
    $activation = if (Test-Path -LiteralPath $activeFile -PathType Leaf) { (Get-Content -LiteralPath $activeFile -Raw).Trim() } else { '' }
    if ($activation -cne $pin.package_implementation) {
        Write-BootstrapStatus ('Installing exact runtime ' + $pin.package_implementation + '. No agent configuration will be written.')
        Invoke-VerifiedInstaller $bundle
    }
    Assert-HapAtlasInstalledRuntime $installRoot $bundle $pin
    # Preserve the runtime-owned launcher's revocation checks and routing.
    $runtimeExe = Join-Path $installRoot 'hapatlas.exe'
    $lock.Dispose()
    $lock = $null
    if ($InstallOnly) { Write-BootstrapStatus 'Pinned runtime verified and ready.'; exit 0 }
    # Explicit byte relay; never use PowerShell's text/object pipeline for MCP.
    . (Join-Path $PSScriptRoot 'stdio-relay.ps1')
    $arguments = (@($RuntimeArguments | ForEach-Object { ConvertTo-NativeArgument $_ }) -join ' ')
    $directory = Join-Path (Join-Path $installRoot 'versions') $pin.package_implementation
    $exitCode = [HapAtlasBootstrap.StdioRelay]::Run($runtimeExe, $arguments, $directory)
    exit $exitCode
} catch {
    Write-BootstrapStatus $_.Exception.Message
    exit 1
} finally {
    if ($null -ne $lock) { $lock.Dispose() }
}
