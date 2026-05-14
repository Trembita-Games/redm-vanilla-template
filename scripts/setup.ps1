$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "..")
$TempServerDataPath = Join-Path $RootPath ".cfx-server-data"
$SystemResourcesPath = Join-Path $RootPath "resources/[system]"
$LocalExamplePath = Join-Path $RootPath "local.example.cfg"
$LocalConfigPath = Join-Path $RootPath "local.cfg"

Write-Host "RedM Vanilla Template Setup"
Write-Host "Root path: $RootPath"
Write-Host ""

function Test-Command {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Command
    )

    $commandInfo = Get-Command $Command -ErrorAction SilentlyContinue
    return $null -ne $commandInfo
}

if (-not (Test-Command "git")) {
    Write-Error "Git is required but was not found in PATH. Install Git and run setup again."
}

if (-not (Test-Path -LiteralPath $SystemResourcesPath)) {
    New-Item -ItemType Directory -Path $SystemResourcesPath -Force | Out-Null
}

if (Test-Path -LiteralPath $TempServerDataPath) {
    Write-Host "Removing existing temporary Cfx.re server data clone..."
    Remove-Item -LiteralPath $TempServerDataPath -Recurse -Force
}

Write-Host "Cloning Cfx.re default server data..."
git clone https://github.com/citizenfx/cfx-server-data.git $TempServerDataPath

$SourceResourcesPath = Join-Path $TempServerDataPath "resources"

if (-not (Test-Path -LiteralPath $SourceResourcesPath)) {
    Write-Error "Default resources directory was not found in cloned cfx-server-data repository."
}

Write-Host "Copying default resources into resources/[system]..."
Copy-Item -Path (Join-Path $SourceResourcesPath "*") -Destination $SystemResourcesPath -Recurse -Force

Write-Host "Removing temporary Cfx.re server data clone..."
Remove-Item -LiteralPath $TempServerDataPath -Recurse -Force

if ((Test-Path -LiteralPath $LocalExamplePath) -and (-not (Test-Path -LiteralPath $LocalConfigPath))) {
    Write-Host "Creating local.cfg from local.example.cfg..."
    Copy-Item -LiteralPath $LocalExamplePath -Destination $LocalConfigPath
    Write-Host "Please edit local.cfg and set your sv_licenseKey value."
}
elseif (Test-Path -LiteralPath $LocalConfigPath) {
    Write-Host "local.cfg already exists. Skipping local configuration creation."
}
else {
    Write-Host "local.example.cfg was not found. Skipping local configuration creation."
}

Write-Host ""
Write-Host "Setup completed."
Write-Host "Next steps:"
Write-Host "1. Download FXServer artifacts into the server/ directory."
Write-Host "2. Set your license key in local.cfg."
Write-Host "3. Start the server with scripts/start.ps1."