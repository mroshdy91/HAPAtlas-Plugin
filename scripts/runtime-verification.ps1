# Shared by the first-use bootstrap and its offline tests. Never executes package code.
function Assert-HapAtlasPin($Pin) {
    foreach ($field in @('zip_sha256','inventory_sha256','runtime_manifest_sha256')) {
        if ([string]$Pin.$field -cnotmatch '^[0-9a-f]{64}$') { throw "BOOTSTRAP_PIN_INVALID: Invalid $field." }
    }
    if ([string]$Pin.source_commit -cnotmatch '^[0-9a-f]{40}$' -or
        [string]$Pin.package_implementation -cnotmatch '^1\.0\.0-alpha\.1\+pkg\.[0-9a-f]{24}$' -or
        $Pin.zip_size -le 0 -or $Pin.zip_size -gt 536870912 -or
        [string]$Pin.tag -cnotmatch '^runtime-v[0-9A-Za-z.+-]+$') { throw 'BOOTSTRAP_PIN_INVALID: Invalid source or package identity.' }
    $base = 'https://github.com/mroshdy91/HAPAtlas-Plugin/releases/download/' + $Pin.tag + '/'
    if ($Pin.zip_name -cne 'HAPAtlas-1.0.0-alpha.1-windows-unsigned.zip' -or
        $Pin.inventory_name -cne ($Pin.zip_name + '.inventory.json') -or
        $Pin.zip_url -cne ($base + $Pin.zip_name) -or $Pin.inventory_url -cne ($base + $Pin.inventory_name)) {
        throw 'BOOTSTRAP_PIN_INVALID: Release URLs and asset names do not agree.'
    }
}

function Assert-HapAtlasPlainPath([string]$Path) {
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($null -ne $cursor) {
        if (Test-Path -LiteralPath $cursor) {
            if (((Get-Item -LiteralPath $cursor -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw 'BOOTSTRAP_UNSAFE_PATH: A cache or installation path is a symlink/junction. Use an ordinary per-user directory.'
            }
        }
        $cursor = [IO.Path]::GetDirectoryName($cursor)
    }
}

function Assert-HapAtlasRelativePath([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path) -or $Path.Contains('\') -or $Path.StartsWith('/') -or $Path -match '[:"<>|?*\x00-\x1f]') {
        throw 'BOOTSTRAP_UNSAFE_PATH: Invalid archive or manifest path.'
    }
    foreach ($part in $Path.Split('/')) {
        if ($part -in @('', '.', '..') -or $part.EndsWith('.') -or $part.EndsWith(' ') -or
            $part -match '^(?i:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)') { throw 'BOOTSTRAP_UNSAFE_PATH: Invalid path segment.' }
    }
}

function Get-HapAtlasHash([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
}

function Assert-HapAtlasHash([string]$Path, [string]$Expected) {
    Assert-HapAtlasPlainPath $Path
    if ((Get-HapAtlasHash $Path) -cne $Expected) { throw ('BOOTSTRAP_HASH_MISMATCH: Integrity check failed for ' + [IO.Path]::GetFileName($Path) + '. Do not execute or bypass this check.') }
}

function Assert-HapAtlasFileInventory([string]$Root, $Entries, [string[]]$Excluded = @()) {
    Assert-HapAtlasPlainPath $Root
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $Entries) {
        $relative = [string]$entry.path
        Assert-HapAtlasRelativePath $relative
        if (-not $seen.Add($relative) -or [string]$entry.sha256 -cnotmatch '^[0-9a-f]{64}$' -or [long]$entry.size -lt 0) {
            throw 'BOOTSTRAP_INVENTORY_INVALID: Duplicate path, size or digest.'
        }
        $path = Join-Path $Root $relative
        Assert-HapAtlasPlainPath $path
        if (-not (Test-Path -LiteralPath $path -PathType Leaf) -or (Get-Item -LiteralPath $path).Length -ne [long]$entry.size) {
            throw ('BOOTSTRAP_INVENTORY_MISMATCH: Missing or wrong-size file: ' + $relative)
        }
        Assert-HapAtlasHash $path $entry.sha256
    }
    $files = @(Get-ChildItem -LiteralPath $Root -File -Force -Recurse)
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($Root.TrimEnd('\','/').Length + 1).Replace('\','/')
        if (-not $seen.Contains($relative) -and $relative -notin $Excluded) { throw ('BOOTSTRAP_UNEXPECTED_FILE: ' + $relative) }
    }
    if ($files.Count -ne $seen.Count + $Excluded.Count) { throw 'BOOTSTRAP_INVENTORY_MISMATCH: File coverage differs.' }
}

function Expand-HapAtlasBundle([string]$Zip, [string]$Destination, [string]$InventoryPath) {
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Assert-HapAtlasPlainPath $Destination
    if (Test-Path -LiteralPath $Destination) { throw 'BOOTSTRAP_STAGE_EXISTS: Refusing to overwrite extraction directory.' }
    $inventory = Get-Content -LiteralPath $InventoryPath -Raw | ConvertFrom-Json
    $expected = @{}
    foreach ($file in $inventory.files) {
        Assert-HapAtlasRelativePath $file.path
        if ($expected.ContainsKey($file.path)) { throw 'BOOTSTRAP_INVENTORY_INVALID: Duplicate file.' }
        $expected[$file.path] = $file
    }
    $archive = [IO.Compression.ZipFile]::OpenRead($Zip)
    try {
        $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($entry in $archive.Entries) {
            $path = $entry.FullName
            Assert-HapAtlasRelativePath $path.TrimEnd('/')
            if ((($entry.ExternalAttributes -shr 16) -band 61440) -eq 40960) { throw 'BOOTSTRAP_UNSAFE_PATH: ZIP symlink.' }
            if ($path.EndsWith('/')) { continue }
            if (-not $seen.Add($path) -or -not $expected.ContainsKey($path) -or
                $expected[$path].path -cne $path -or $entry.Length -ne [long]$expected[$path].size) {
                throw 'BOOTSTRAP_ZIP_INVENTORY_MISMATCH: Unexpected, duplicated or wrong-size ZIP entry.'
            }
        }
        if ($seen.Count -ne $expected.Count) { throw 'BOOTSTRAP_ZIP_INVENTORY_MISMATCH: Missing ZIP file.' }
        [void][IO.Directory]::CreateDirectory($Destination)
        foreach ($entry in $archive.Entries) {
            if ($entry.FullName.EndsWith('/')) { continue }
            $target = Join-Path $Destination $entry.FullName
            [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($target))
            $inputStream = $entry.Open()
            $outputStream = [IO.File]::Open($target, [IO.FileMode]::CreateNew)
            try { $inputStream.CopyTo($outputStream) } finally { $inputStream.Dispose(); $outputStream.Dispose() }
        }
    } finally { $archive.Dispose() }
}

function Assert-HapAtlasBundle([string]$Bundle, [string]$InventoryPath, $Pin) {
    Assert-HapAtlasHash $InventoryPath $Pin.inventory_sha256
    $inventory = Get-Content -LiteralPath $InventoryPath -Raw | ConvertFrom-Json
    if ($inventory.source_commit -cne $Pin.source_commit -or $inventory.package_implementation -cne $Pin.package_implementation -or
        $inventory.distribution_profile -cne 'public-runtime' -or $inventory.zip.sha256 -cne $Pin.zip_sha256 -or
        $inventory.zip.size -ne $Pin.zip_size -or $inventory.zip.name -cne $Pin.zip_name) { throw 'BOOTSTRAP_PROVENANCE_MISMATCH: Inventory does not match plugin pin.' }
    Assert-HapAtlasFileInventory $Bundle $inventory.files
    $runtimeManifest = Join-Path $Bundle 'runtime\package-manifest.json'
    Assert-HapAtlasHash $runtimeManifest $Pin.runtime_manifest_sha256
    $runtime = Get-Content -LiteralPath $runtimeManifest -Raw | ConvertFrom-Json
    $release = Get-Content -LiteralPath (Join-Path $Bundle 'release-manifest.json') -Raw | ConvertFrom-Json
    if ($runtime.source_commit -cne $Pin.source_commit -or $runtime.source_clean -ne $true -or
        $runtime.distribution_profile -cne 'public-runtime' -or
        $release.source_commit -cne $Pin.source_commit -or $release.package_implementation -cne $Pin.package_implementation -or
        $release.runtime_manifest_sha256 -cne $Pin.runtime_manifest_sha256 -or
        ($runtime.version + '+pkg.' + $Pin.runtime_manifest_sha256.Substring(0,24)) -cne $Pin.package_implementation) {
        throw 'BOOTSTRAP_PROVENANCE_MISMATCH: Runtime and release manifests disagree.'
    }
    Assert-HapAtlasFileInventory (Join-Path $Bundle 'runtime') $runtime.files @('package-manifest.json')
}

function Assert-HapAtlasInstalledRuntime([string]$InstallRoot, [string]$Bundle, $Pin) {
    $active = Join-Path $InstallRoot 'active.txt'
    Assert-HapAtlasPlainPath $active
    if (-not (Test-Path -LiteralPath $active) -or (Get-Content -LiteralPath $active -Raw).Trim() -cne $Pin.package_implementation) {
        throw 'BOOTSTRAP_ACTIVATION_MISMATCH: Another runtime is active. Close other HAPAtlas clients and restart this agent.'
    }
    $root = Join-Path (Join-Path $InstallRoot 'versions') $Pin.package_implementation
    Assert-HapAtlasHash (Join-Path $root 'package-manifest.json') $Pin.runtime_manifest_sha256
    $manifest = Get-Content -LiteralPath (Join-Path $Bundle 'runtime\package-manifest.json') -Raw | ConvertFrom-Json
    Assert-HapAtlasFileInventory $root $manifest.files @('package-manifest.json')
}
