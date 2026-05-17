# Development

## Goals

- keep the repository infrastructure-oriented
- keep runtime state out of Git
- preserve deterministic setup and startup flows
- keep gameplay/RP modules separate from the template
- keep scripts and documentation aligned with the actual generated runtime layout

---

## Local Workflow

Use the numbered lifecycle:

```powershell
./scripts/01-server-install.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
./scripts/02-server-setup.ps1
./scripts/03-server-run.ps1
```

For most documentation or template changes, rerun:

```powershell
./scripts/02-server-setup.ps1 -Overwrite
```

This regenerates runtime configs from the tracked templates.

---

## Tracked vs Generated

Tracked source:

```txt
config/
docs/
scripts/
docker-compose.yaml
.github/workflows/validate.yaml
README.md
LICENSE
```

Generated local state:

```txt
server/
txData/
.env
cache/
logs/
```

Do not commit generated local state.

---

## Configuration Changes

Edit templates in:

```txt
config/templates/
```

Then regenerate runtime configs with:

```powershell
./scripts/02-server-setup.ps1 -Overwrite
```

Local secrets belong in:

```txt
txData/<profile>.base/secrets.cfg
```

Do not place real secrets in templates.

---

## Resource Changes

The setup script installs external resource layers into:

```txt
txData/<profile>.base/resources/
```

The repository should not track generated runtime resources.

Project-specific startup entries belong in:

```txt
config/templates/trembita-resources.cfg.example
```

---

## Validation

The GitHub Actions workflow checks:

- required tracked files and directories
- forbidden runtime paths are not tracked
- server icon dimensions
- template config expectations
- PowerShell syntax
- Docker Compose config

Run local script syntax checks when changing PowerShell:

```powershell
$tokens = $null
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile("scripts/02-server-setup.ps1", [ref] $tokens, [ref] $errors) | Out-Null
$errors
```

---

## Naming

Lifecycle scripts are intentionally numbered:

```txt
01-server-install.ps1
02-server-setup.ps1
03-server-run.ps1
```

Keep documentation examples in that order.
