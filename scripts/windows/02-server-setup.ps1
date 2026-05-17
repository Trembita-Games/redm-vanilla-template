param (
    [string] $Profile = "dev",

    [switch] $Overwrite
)

$ErrorActionPreference = "Stop"

$RootPath = Resolve-Path (Join-Path $PSScriptRoot "../..")

$ServerPath = Join-Path $RootPath "server"
$FxServerPath = Join-Path $ServerPath "FXServer.exe"
$OfficialServerDataRepository = "https://github.com/Trembita-Games/redm-server-data-cfx.git"
$StandaloneServerDataRepository = "https://github.com/Trembita-Games/redm-server-data.git"
$TempOfficialServerDataPath = Join-Path $RootPath ".redm-server-data-cfx"
$TempStandaloneServerDataPath = Join-Path $RootPath ".redm-server-data"
$ConfigTemplatesPath = Join-Path $RootPath "config/templates"
$SourceServerIconPath = Join-Path $RootPath "config/server-icon.png"
$TxDataPath = Join-Path $RootPath "txData"
$TxAdminControlName = "default"
$TxAdminControlPath = Join-Path $TxDataPath $TxAdminControlName
$TxAdminDataPath = Join-Path $TxAdminControlPath "data"
$TxAdminLogsPath = Join-Path $TxAdminControlPath "logs"
$TxAdminConfigPath = Join-Path $TxAdminControlPath "config.json"
$RuntimeBaseName = "$Profile.base"
$RuntimeBasePath = Join-Path $TxDataPath $RuntimeBaseName
$RuntimeCachePath = Join-Path $RuntimeBasePath "cache"
$RuntimeResourcesPath = Join-Path $RuntimeBasePath "resources"

$ServerExamplePath = Join-Path $ConfigTemplatesPath "server.cfg.example"
$ServerConfigPath = Join-Path $RuntimeBasePath "server.cfg"

$SecretsExamplePath = Join-Path $ConfigTemplatesPath "secrets.cfg.example"
$SecretsConfigPath = Join-Path $RuntimeBasePath "secrets.cfg"
$RuntimeServerIconPath = Join-Path $RuntimeBasePath "server-icon.png"

$PermissionsExamplePath = Join-Path $ConfigTemplatesPath "permissions.cfg.example"
$PermissionsConfigPath = Join-Path $RuntimeBasePath "permissions.cfg"

$ResourcesExamplePath = Join-Path $ConfigTemplatesPath "resources.cfg.example"
$ResourcesConfigPath = Join-Path $RuntimeBasePath "resources.cfg"

$TrembitaResourcesExamplePath = Join-Path $ConfigTemplatesPath "trembita-resources.cfg.example"
$TrembitaResourcesConfigPath = Join-Path $RuntimeBasePath "trembita-resources.cfg"

Write-Host "RedM Vanilla Template Setup"
Write-Host "Root path: $RootPath"
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

function Write-TextFileIfMissing {
    param (
        [Parameter(Mandatory = $true)]
        [string] $TargetPath,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string] $Content,

        [Parameter(Mandatory = $true)]
        [string] $DisplayName
    )

    if ((Test-Path -LiteralPath $TargetPath) -and (-not $Overwrite)) {
        Write-Host "$DisplayName already exists; skipping creation"
        return
    }

    Write-Host "Creating $DisplayName"
    if ((Test-Path -LiteralPath $TargetPath) -and $Overwrite) {
        Remove-Item -LiteralPath $TargetPath -Force
    }

    [System.IO.File]::WriteAllText($TargetPath, $Content, [System.Text.UTF8Encoding]::new($false))
}

function Copy-TemplateConfig {
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplatePath,

        [Parameter(Mandatory = $true)]
        [string] $TargetPath,

        [Parameter(Mandatory = $true)]
        [string] $DisplayName
    )

    if (-not (Test-Path -LiteralPath $TemplatePath)) {
        Write-Host "$(Split-Path -Leaf $TemplatePath) was not found; skipping $DisplayName creation"
        return
    }

    if ((Test-Path -LiteralPath $TargetPath) -and (-not $Overwrite)) {
        Write-Host "$DisplayName already exists; skipping creation"
        return
    }

    Write-Host "Creating $DisplayName from $(Split-Path -Leaf $TemplatePath)"
    if ((Test-Path -LiteralPath $TargetPath) -and $Overwrite) {
        Remove-Item -LiteralPath $TargetPath -Force
    }

    $content = [System.IO.File]::ReadAllText($TemplatePath, [System.Text.UTF8Encoding]::new($false))
    $content = $content.Replace("{{PROFILE}}", $Profile)
    [System.IO.File]::WriteAllText($TargetPath, $content, [System.Text.UTF8Encoding]::new($false))
}

function Copy-RuntimeFileIfMissing {
    param (
        [Parameter(Mandatory = $true)]
        [string] $SourcePath,

        [Parameter(Mandatory = $true)]
        [string] $TargetPath,

        [Parameter(Mandatory = $true)]
        [string] $DisplayName
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        Write-Host "$(Split-Path -Leaf $SourcePath) was not found; skipping $DisplayName creation"
        return
    }

    if ((Test-Path -LiteralPath $TargetPath) -and (-not $Overwrite)) {
        Write-Host "$DisplayName already exists; skipping creation"
        return
    }

    Write-Host "Creating $DisplayName from $(Split-Path -Leaf $SourcePath)"
    Copy-Item -LiteralPath $SourcePath -Destination $TargetPath -Force
}

function Install-ResourceLayer {
    param (
        [Parameter(Mandatory = $true)]
        [string] $SourceResourcesPath,

        [Parameter(Mandatory = $true)]
        [string] $LayerName
    )

    if (-not (Test-Path -LiteralPath $SourceResourcesPath)) {
        Write-Error "$LayerName resources directory was not found at $SourceResourcesPath"
    }

    Write-Host "Installing $LayerName resources into txData/$RuntimeBaseName/resources/"

    Copy-ResourceTree -SourcePath $SourceResourcesPath -DestinationPath $RuntimeResourcesPath
}

function Test-ResourceDirectory {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    return (Test-Path -LiteralPath (Join-Path $Path "fxmanifest.lua")) -or (Test-Path -LiteralPath (Join-Path $Path "__resource.lua"))
}

function Copy-ResourceTree {
    param (
        [Parameter(Mandatory = $true)]
        [string] $SourcePath,

        [Parameter(Mandatory = $true)]
        [string] $DestinationPath
    )

    if (-not (Test-Path -LiteralPath $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }

    foreach ($item in Get-ChildItem -LiteralPath $SourcePath -Force) {
        $targetPath = Join-Path $DestinationPath $item.Name

        if (-not $item.PSIsContainer) {
            Copy-Item -LiteralPath $item.FullName -Destination $targetPath -Force
            continue
        }

        if (Test-ResourceDirectory -Path $item.FullName) {
            if (Test-Path -LiteralPath $targetPath) {
                Remove-Item -LiteralPath $targetPath -Recurse -Force
            }

            Copy-Item -LiteralPath $item.FullName -Destination $DestinationPath -Recurse -Force
            continue
        }

        Copy-ResourceTree -SourcePath $item.FullName -DestinationPath $targetPath
    }
}

if (-not (Test-Command "git")) {
    Write-Error "Git is required but was not found in PATH. Install Git and run setup again."
}

foreach ($path in @($ServerPath, $TxDataPath, $TxAdminControlPath, $TxAdminDataPath, $TxAdminLogsPath, $RuntimeBasePath, $RuntimeCachePath, $RuntimeResourcesPath)) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

foreach ($tempPath in @($TempOfficialServerDataPath, $TempStandaloneServerDataPath)) {
    if (Test-Path -LiteralPath $tempPath) {
        Write-Host "Removing existing temporary clone: $(Split-Path -Leaf $tempPath)"
        Remove-Item -LiteralPath $tempPath -Recurse -Force
    }
}

try {
    Write-Host "Cloning official RedM server data"
    git clone $OfficialServerDataRepository $TempOfficialServerDataPath

    Write-Host "Cloning Trembita standalone server resources"
    git clone $StandaloneServerDataRepository $TempStandaloneServerDataPath

    Install-ResourceLayer `
        -SourceResourcesPath (Join-Path $TempOfficialServerDataPath "resources") `
        -LayerName "official/base"

    Install-ResourceLayer `
        -SourceResourcesPath (Join-Path $TempStandaloneServerDataPath "resources") `
        -LayerName "standalone"
}
finally {
    foreach ($tempPath in @($TempOfficialServerDataPath, $TempStandaloneServerDataPath)) {
        if (Test-Path -LiteralPath $tempPath) {
            Write-Host "Removing temporary clone: $(Split-Path -Leaf $tempPath)"
            Remove-Item -LiteralPath $tempPath -Recurse -Force
        }
    }
}

Write-TextFileIfMissing `
    -TargetPath $TxAdminConfigPath `
    -Content "{`n  `"version`": 2`n}`n" `
    -DisplayName "txData/default/config.json"

Copy-TemplateConfig `
    -TemplatePath $ServerExamplePath `
    -TargetPath $ServerConfigPath `
    -DisplayName "txData/$RuntimeBaseName/server.cfg"

Copy-TemplateConfig `
    -TemplatePath $SecretsExamplePath `
    -TargetPath $SecretsConfigPath `
    -DisplayName "txData/$RuntimeBaseName/secrets.cfg"

Copy-RuntimeFileIfMissing `
    -SourcePath $SourceServerIconPath `
    -TargetPath $RuntimeServerIconPath `
    -DisplayName "txData/$RuntimeBaseName/server-icon.png"

Copy-TemplateConfig `
    -TemplatePath $PermissionsExamplePath `
    -TargetPath $PermissionsConfigPath `
    -DisplayName "txData/$RuntimeBaseName/permissions.cfg"

Copy-TemplateConfig `
    -TemplatePath $ResourcesExamplePath `
    -TargetPath $ResourcesConfigPath `
    -DisplayName "txData/$RuntimeBaseName/resources.cfg"

Copy-TemplateConfig `
    -TemplatePath $TrembitaResourcesExamplePath `
    -TargetPath $TrembitaResourcesConfigPath `
    -DisplayName "txData/$RuntimeBaseName/trembita-resources.cfg"

Write-Host ""
Write-Host "Setup completed successfully"
Write-Host ""
Write-Host "Runtime paths:"
Write-Host "- txData/default/"
Write-Host "- txData/$RuntimeBaseName/"
Write-Host ""

if (Test-Path -LiteralPath $FxServerPath) {
    Write-Host "Next steps:"
    Write-Host "1. Configure txData/$RuntimeBaseName/secrets.cfg"
    Write-Host "2. Start the server with scripts/windows/03-server-run.ps1 -Profile $Profile"
}
else {
    Write-Host "Next steps:"
    Write-Host "1. Install FXServer artifacts with scripts/windows/01-server-install.ps1"
    Write-Host "2. Configure txData/$RuntimeBaseName/secrets.cfg"
    Write-Host "3. Start the server with scripts/windows/03-server-run.ps1 -Profile $Profile"
}
