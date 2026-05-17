param (
    [string] $Profile = "dev"
)

$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "../..")
$FxServerPath = Join-Path $RootPath "server/FXServer.exe"
$TxDataRoot = Join-Path $RootPath "txData"
$TxAdminControlName = "default"
$TxAdminControlPath = Join-Path $TxDataRoot $TxAdminControlName
$RuntimeLogsRootPath = Join-Path $TxAdminControlPath "logs"
$RuntimeLogPath = Join-Path $RuntimeLogsRootPath $Profile
$RuntimeProfileName = "$Profile.base"
$RuntimeBasePath = Join-Path $TxDataRoot $RuntimeProfileName
$RuntimeServerConfigName = "server.cfg"
$ServerConfigPath = Join-Path $RuntimeBasePath $RuntimeServerConfigName

Write-Host "Starting RedM Vanilla Server"
Write-Host "Root path: $RootPath"
Write-Host "Runtime profile: $Profile"
Write-Host "txAdmin control: txData/$TxAdminControlName/"
Write-Host "Runtime path: txData/$RuntimeProfileName/"
Write-Host "Runtime logs: txData/$TxAdminControlName/logs/$Profile/"
Write-Host ""

if (-not (Test-Path -LiteralPath $FxServerPath)) {
    Write-Error "FXServer executable is missing at server/FXServer.exe. Install artifacts with scripts/windows/01-server-install.ps1"
}

if (-not (Test-Path -LiteralPath $ServerConfigPath)) {
    Write-Error "txData/$RuntimeProfileName/$RuntimeServerConfigName was not found. Run scripts/windows/02-server-setup.ps1 -Profile $Profile first"
}

if (-not (Test-Path -LiteralPath $RuntimeLogPath)) {
    New-Item -ItemType Directory -Path $RuntimeLogPath -Force | Out-Null
}

$Timestamp = Get-Date -Format "yyyy.MM.dd-HH.mm.ss"
$LogFilePath = Join-Path $RuntimeLogPath "server-$Timestamp.log"

Write-Host "Runtime working directory: $RuntimeBasePath"
Write-Host "Server config: txData/$RuntimeProfileName/$RuntimeServerConfigName"
Write-Host "Log file: $LogFilePath"
Write-Host ""

Push-Location $RuntimeBasePath

try {
    & $FxServerPath +exec $RuntimeServerConfigName 2>&1 | Tee-Object -FilePath $LogFilePath
}
finally {
    Pop-Location
    Write-Host ""
    Write-Host "FXServer stopped"
    Write-Host "Log file: $LogFilePath"
}
