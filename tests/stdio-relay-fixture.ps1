$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\scripts\stdio-relay.ps1')
$executable = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
$arguments = '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + (Join-Path $PSScriptRoot 'stdio-echo.ps1') + '"'
exit [HapAtlasBootstrap.StdioRelay]::Run($executable, $arguments, $PSScriptRoot)
