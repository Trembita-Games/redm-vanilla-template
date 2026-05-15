param (
    [Parameter(Mandatory = $true)]
    [string] $ArtifactUrl,

    [switch] $KeepArchive
)

$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "..")
$ServerPath = Join-Path $RootPath "server"
$TempPath = Join-Path $RootPath ".tmp"
$ArchivePath = Join-Path $TempPath "fxserver-artifact.7z"

Write-Host "FXServer Artifact Update"
Write-Host "Root path: $RootPath"
Write-Host "Artifact URL: $ArtifactUrl"
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

Write-Host "Downloading FXServer artifact..."
Invoke-WebRequest -Uri $ArtifactUrl -OutFile $ArchivePath

if (-not (Test-Path -LiteralPath $ArchivePath)) {
    Write-Error "Artifact archive was not downloaded."
}

Write-Host "Preparing server directory..."

if (Test-Path -LiteralPath $ServerPath) {
    Remove-Item -LiteralPath $ServerPath -Recurse -Force
}

New-Item -ItemType Directory -Path $ServerPath -Force | Out-Null

Write-Host "Extracting artifact into server/..."
& $SevenZipPath x $ArchivePath "-o$ServerPath" -y | Out-Host

$FxServerPath = Join-Path $ServerPath "FXServer.exe"

if (-not (Test-Path -LiteralPath $FxServerPath)) {
    Write-Error "FXServer.exe was not found after extraction. Check that the artifact URL points to a valid Windows FXServer archive."
}

if (-not $KeepArchive) {
    Write-Host "Removing downloaded archive..."
    Remove-Item -LiteralPath $ArchivePath -Force

    if ((Get-ChildItem -LiteralPath $TempPath -Force | Measure-Object).Count -eq 0) {
        Remove-Item -LiteralPath $TempPath -Force
    }
}

Write-Host ""
Write-Host "FXServer artifacts updated successfully."
Write-Host "Installed into: $ServerPath"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Run scripts/setup.ps1 to install default Cfx.re resources."
Write-Host "2. Set your license key in local.cfg."
Write-Host "3. Start the server with scripts/start.ps1."