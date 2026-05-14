$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "..")
$FxServerPath = Join-Path $RootPath "server/FXServer.exe"
$ServerConfigPath = Join-Path $RootPath "server.cfg"

Write-Host "Starting RedM Vanilla Server"
Write-Host "Root path: $RootPath"
Write-Host ""

if (-not (Test-Path -LiteralPath $FxServerPath)) {
    Write-Error "FXServer executable is missing. Please download and extract FXServer artifacts into the server/ directory."
}

if (-not (Test-Path -LiteralPath $ServerConfigPath)) {
    Write-Error "server.cfg was not found in the repository root."
}

Push-Location $RootPath

try {
    & $FxServerPath +exec "server.cfg"
}
finally {
    Pop-Location
}