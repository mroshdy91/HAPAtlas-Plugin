[CmdletBinding()]
param([string]$ZipPath, [string]$TemporaryRoot = [IO.Path]::GetTempPath())
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\scripts\runtime-verification.ps1')
$pin = (Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\plugin.metadata.json') -Raw | ConvertFrom-Json).runtime.release
$script:checks = 0
function Assert-Rejected([scriptblock]$Action, [string]$Code) {
    try { & $Action | Out-Null }
    catch {
        if ($_.Exception.Message -notlike ($Code + '*')) { throw }
        $script:checks++
        return
    }
    throw "Expected rejection: $Code"
}
Assert-HapAtlasPin $pin
$script:checks++
foreach ($path in @('../file','/file','C:/file','a\b','a//b','a/./b','a/../b','a/b.','a/b ','a/CON.txt','a/NUL','a/b:stream','a/*.txt')) {
    Assert-Rejected { Assert-HapAtlasRelativePath $path } 'BOOTSTRAP_UNSAFE_PATH'
}
Assert-HapAtlasRelativePath 'runtime/bridge51/HapAtlas.Bridge51.x86.dll'
$script:checks++
$badPin = $pin | ConvertTo-Json -Depth 8 | ConvertFrom-Json
$badPin.zip_url = 'https://example.com/changed.zip'
Assert-Rejected { Assert-HapAtlasPin $badPin } 'BOOTSTRAP_PIN_INVALID'
$badPin = $pin | ConvertTo-Json -Depth 8 | ConvertFrom-Json
$badPin.inventory_sha256 = 'bad'
Assert-Rejected { Assert-HapAtlasPin $badPin } 'BOOTSTRAP_PIN_INVALID'

$fixture = Join-Path ([IO.Path]::GetFullPath($TemporaryRoot)) ('hapatlas-verification-test-' + [Guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($fixture)
$root = Join-Path $fixture 'files'
[void][IO.Directory]::CreateDirectory($root)
$file = Join-Path $root 'sample.txt'
[IO.File]::WriteAllText($file, 'verified fixture', [Text.UTF8Encoding]::new($false))
$entry = [pscustomobject]@{ path='sample.txt'; size=(Get-Item -LiteralPath $file).Length; sha256=(Get-HapAtlasHash $file) }
Assert-HapAtlasFileInventory $root @($entry)
$script:checks++
Assert-Rejected { Assert-HapAtlasFileInventory $root @($entry,$entry) } 'BOOTSTRAP_INVENTORY_INVALID'
[IO.File]::WriteAllText((Join-Path $root 'unexpected.txt'), 'unexpected')
Assert-Rejected { Assert-HapAtlasFileInventory $root @($entry) } 'BOOTSTRAP_UNEXPECTED_FILE'
# Remove only this known test-owned file, not a recursive or computed root.
Remove-Item -LiteralPath (Join-Path $root 'unexpected.txt')
[IO.File]::WriteAllText($file, 'tampered fixture', [Text.UTF8Encoding]::new($false))
Assert-Rejected { Assert-HapAtlasFileInventory $root @($entry) } 'BOOTSTRAP_HASH_MISMATCH'

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$inventoryPath = Join-Path $fixture 'inventory.json'
[IO.File]::WriteAllText($inventoryPath, (@{files=@($entry)} | ConvertTo-Json -Depth 5))
foreach ($case in @('traversal','duplicate','missing','symlink')) {
    $zip = Join-Path $fixture ($case + '.zip')
    $archive = [IO.Compression.ZipFile]::Open($zip, [IO.Compression.ZipArchiveMode]::Create)
    try {
        if ($case -eq 'traversal') { [void]$archive.CreateEntry('../outside.txt') }
        if ($case -eq 'symlink') {
            $link = $archive.CreateEntry('sample.txt')
            $link.ExternalAttributes = -1577123840
        }
        if ($case -eq 'duplicate') {
            foreach ($index in 1..2) {
                $stream = $archive.CreateEntry('sample.txt').Open()
                try { $bytes=[Text.Encoding]::UTF8.GetBytes('verified fixture'); $stream.Write($bytes,0,$bytes.Length) }
                finally { $stream.Dispose() }
            }
        }
    } finally { $archive.Dispose() }
    $code = if ($case -in @('traversal','symlink')) { 'BOOTSTRAP_UNSAFE_PATH' } else { 'BOOTSTRAP_ZIP_INVENTORY_MISMATCH' }
    Assert-Rejected { Expand-HapAtlasBundle $zip (Join-Path $fixture $case) $inventoryPath } $code
}
if (-not [string]::IsNullOrWhiteSpace($ZipPath)) {
    Assert-HapAtlasHash $ZipPath $pin.zip_sha256
    $bundle = Join-Path $fixture 'real-bundle'
    Expand-HapAtlasBundle $ZipPath $bundle ($ZipPath + '.inventory.json')
    Assert-HapAtlasBundle $bundle ($ZipPath + '.inventory.json') $pin
    $script:checks++
}
[pscustomobject]@{result='PASS'; checks=$script:checks; powershell=$PSVersionTable.PSVersion.ToString()} | ConvertTo-Json
