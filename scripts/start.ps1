$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "..")
$FxServerPath = Join-Path $RootPath "server/FXServer.exe"
$ServerConfigPath = Join-Path $RootPath "server.cfg"
$LogsPath = Join-Path $RootPath "logs"

Write-Host "Starting RedM Vanilla Server"
Write-Host "Root path: $RootPath"
Write-Host ""

if (-not (Test-Path -LiteralPath $FxServerPath)) {
    Write-Error "FXServer executable is missing. Please download and extract FXServer artifacts into the server/ directory."
}

if (-not (Test-Path -LiteralPath $ServerConfigPath)) {
    Write-Error "server.cfg was not found in the repository root."
}

if (-not (Test-Path -LiteralPath $LogsPath)) {
    New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$LogFilePath = Join-Path $LogsPath "server-$Timestamp.log"

Write-Host "Log file: $LogFilePath"
Write-Host ""

Push-Location $RootPath

try {
    & $FxServerPath +exec "server.cfg" 2>&1 | Tee-Object -FilePath $LogFilePath
}
finally {
    Pop-Location
}