$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "..")

$TempServerDataPath = Join-Path $RootPath ".redm-server-data-cfx"
$SystemResourcesPath = Join-Path $RootPath "resources/[system]"

$LocalExamplePath = Join-Path $RootPath "local.cfg.example"
$LocalConfigPath = Join-Path $RootPath "local.cfg"

$PermissionsExamplePath = Join-Path $RootPath "permissions.cfg.example"
$PermissionsConfigPath = Join-Path $RootPath "permissions.cfg"

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

function Copy-ExampleConfigIfMissing {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ExamplePath,

        [Parameter(Mandatory = $true)]
        [string] $TargetPath,

        [Parameter(Mandatory = $true)]
        [string] $ConfigName
    )

    if ((Test-Path -LiteralPath $ExamplePath) -and (-not (Test-Path -LiteralPath $TargetPath))) {
        Write-Host "Creating $ConfigName from $(Split-Path -Leaf $ExamplePath)..."
        Copy-Item -LiteralPath $ExamplePath -Destination $TargetPath
        return
    }

    if (Test-Path -LiteralPath $TargetPath) {
        Write-Host "$ConfigName already exists. Skipping $ConfigName creation."
        return
    }

    Write-Host "$(Split-Path -Leaf $ExamplePath) was not found. Skipping $ConfigName creation."
}

if (-not (Test-Command "git")) {
    Write-Error "Git is required but was not found in PATH. Install Git and run setup again."
}

if (-not (Test-Path -LiteralPath $SystemResourcesPath)) {
    New-Item -ItemType Directory -Path $SystemResourcesPath -Force | Out-Null
}

if (Test-Path -LiteralPath $TempServerDataPath) {
    Write-Host "Removing existing temporary RedM server data clone..."
    Remove-Item -LiteralPath $TempServerDataPath -Recurse -Force
}

Write-Host "Cloning RedM default server data..."
git clone https://github.com/Trembita-Games/redm-server-data-cfx.git $TempServerDataPath

$SourceResourcesPath = Join-Path $TempServerDataPath "resources"

if (-not (Test-Path -LiteralPath $SourceResourcesPath)) {
    Write-Error "Default resources directory was not found in cloned redm-server-data-cfx repository."
}

Write-Host "Copying default resources into resources/[system]..."
Copy-Item -Path (Join-Path $SourceResourcesPath "*") -Destination $SystemResourcesPath -Recurse -Force

Write-Host "Removing temporary RedM server data clone..."
Remove-Item -LiteralPath $TempServerDataPath -Recurse -Force

Copy-ExampleConfigIfMissing `
    -ExamplePath $LocalExamplePath `
    -TargetPath $LocalConfigPath `
    -ConfigName "local.cfg"

Copy-ExampleConfigIfMissing `
    -ExamplePath $PermissionsExamplePath `
    -TargetPath $PermissionsConfigPath `
    -ConfigName "permissions.cfg"

Write-Host ""
Write-Host "Setup completed."
Write-Host "Next steps:"
Write-Host "1. Download FXServer artifacts into the server/ directory."
Write-Host "2. Set your license key in local.cfg."
Write-Host "3. Review permissions.cfg and adjust server permissions if needed."
Write-Host "4. Start the server with scripts/start.ps1."
