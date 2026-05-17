param (
    [Parameter(Mandatory = $true)]
    [string] $ArtifactUrl,

    [string] $Profile = "dev",

    [switch] $KeepArchive
)

$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "../..")
$ServerPath = Join-Path $RootPath "server"
$FxServerPath = Join-Path $ServerPath "FXServer.exe"
$TxDataRoot = Join-Path $RootPath "txData"
$TxAdminControlName = "default"
$RuntimeBaseName = "$Profile.base"
$RuntimeBasePath = Join-Path $TxDataRoot $RuntimeBaseName
$RuntimeConfigPath = Join-Path $RuntimeBasePath "server.cfg"
$TempPath = Join-Path $RootPath ".tmp"
$ArchivePath = Join-Path $TempPath "fxserver-artifact.7z"

Write-Host "FXServer Artifact Update"
Write-Host "Root path: $RootPath"
Write-Host "Artifact URL: $ArtifactUrl"
Write-Host "Install path: server/"
Write-Host "Runtime profile: $Profile"
Write-Host ""

function Test-Command {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Command
    )

    $commandInfo = Get-Command $Command -ErrorAction SilentlyContinue
    return $null -ne $commandInfo
}

function Get-SevenZipPath {
    if (Test-Command "7z") {
        return "7z"
    }

    if (Test-Command "7za") {
        return "7za"
    }

    $commonPaths = @(
        "C:\Program Files\7-Zip\7z.exe",
        "C:\Program Files (x86)\7-Zip\7z.exe"
    )

    foreach ($path in $commonPaths) {
        if (Test-Path -LiteralPath $path) {
            return $path
        }
    }

    return $null
}

$SevenZipPath = Get-SevenZipPath

if ($null -eq $SevenZipPath) {
    Write-Error "7-Zip was not found. Install 7-Zip and make sure 7z.exe is available in PATH."
}

if (-not (Test-Path -LiteralPath $TempPath)) {
    New-Item -ItemType Directory -Path $TempPath -Force | Out-Null
}

if (Test-Path -LiteralPath $ArchivePath) {
    Remove-Item -LiteralPath $ArchivePath -Force
}

Write-Host "Downloading FXServer artifact"
Invoke-WebRequest -Uri $ArtifactUrl -OutFile $ArchivePath

if (-not (Test-Path -LiteralPath $ArchivePath)) {
    Write-Error "Artifact archive was not downloaded."
}

Write-Host "Preparing server directory"

if (Test-Path -LiteralPath $ServerPath) {
    Remove-Item -LiteralPath $ServerPath -Recurse -Force
}

New-Item -ItemType Directory -Path $ServerPath -Force | Out-Null

Write-Host "Extracting FXServer artifacts into server/"
& $SevenZipPath x $ArchivePath "-o$ServerPath" -y | Out-Host

if (-not (Test-Path -LiteralPath $FxServerPath)) {
    Write-Error "FXServer.exe was not found after extraction. Check that the artifact URL points to a valid Windows FXServer archive."
}

if (-not $KeepArchive) {
    Write-Host "Removing downloaded archive"
    Remove-Item -LiteralPath $ArchivePath -Force

    if ((Get-ChildItem -LiteralPath $TempPath -Force | Measure-Object).Count -eq 0) {
        Remove-Item -LiteralPath $TempPath -Force
    }
}

Write-Host ""
Write-Host "FXServer artifacts updated successfully"
Write-Host ""
Write-Host "Installed:"
Write-Host "- FXServer runtime artifacts"
Write-Host "- server/"
Write-Host ""

if (Test-Path -LiteralPath $RuntimeConfigPath) {
    Write-Host "Detected existing runtime environment:"
    Write-Host "- txData/$TxAdminControlName/"
    Write-Host "- txData/$RuntimeBaseName/"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Start the server with scripts/windows/03-server-run.ps1 -Profile $Profile"
}
else {
    Write-Host "Runtime environment has not been generated yet"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Run scripts/windows/02-server-setup.ps1 to generate the default development runtime"
    Write-Host ""
    Write-Host "Profile usage:"
    Write-Host "- Without -Profile: uses dev"
    Write-Host "- With -Profile: uses the selected runtime profile"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "- scripts/windows/02-server-setup.ps1"
    Write-Host "- scripts/windows/02-server-setup.ps1 -Profile dev"
    Write-Host "- scripts/windows/02-server-setup.ps1 -Profile test"
}
