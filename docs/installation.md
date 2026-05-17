# Installation Guide

This guide describes the current local Windows setup flow.

The repository stores source templates and scripts. Runtime files are generated locally and ignored by Git.

---

## Requirements

- Windows
- PowerShell
- Git
- 7-Zip
- RedM
- Red Dead Redemption 2
- Windows FXServer artifacts
- TCP `30120` and UDP `30120` available

Optional:

- Docker
- Docker Compose

Docker is only used for the optional MariaDB service.

---

## Tracked Source Layout

```txt
redm-vanilla-template/
+-- config/
|   +-- .env.example
|   +-- server-icon.png
|   +-- templates/
|       +-- permissions.cfg.example
|       +-- resources.cfg.example
|       +-- secrets.cfg.example
|       +-- server.cfg.example
|       +-- trembita-resources.cfg.example
+-- docs/
+-- scripts/
|   +-- windows/
|   |   +-- 01-server-install.ps1
|   |   +-- 02-server-setup.ps1
|   |   +-- 03-server-run.ps1
|   +-- linux/
|   |   +-- 01-server-install.sh
|   |   +-- 02-server-setup.sh
|   |   +-- 03-server-run.sh
|   +-- README.md
+-- docker-compose.yaml
+-- README.md
```

---

## Generated Runtime Layout

After installation and setup, local runtime files are generated under:

```txt
redm-vanilla-template/
+-- server/
|   +-- FXServer.exe
|   +-- citizen/
+-- txData/
    +-- default/
    |   +-- data/
    |   +-- logs/
    |   |   +-- dev/
    |   +-- config.json
    +-- dev.base/
        +-- cache/
        +-- resources/
        +-- permissions.cfg
        +-- resources.cfg
        +-- secrets.cfg
        +-- server.cfg
        +-- server-icon.png
        +-- trembita-resources.cfg
```

These paths are generated runtime state and are ignored by Git:

```txt
server/
txData/
.env
cache/
logs/
```

---

## 1. Install FXServer Artifacts

Download or copy a direct Windows FXServer `.7z` artifact URL from:

```txt
https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
```

Run:

```powershell
./scripts/windows/01-server-install.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

The script recreates:

```txt
server/
```

and verifies:

```txt
server/FXServer.exe
```

Manual installation is also valid if the extracted artifact layout produces `server/FXServer.exe`.

---

## 2. Generate Runtime Data and Install Resources

Run:

```powershell
./scripts/windows/02-server-setup.ps1
```

The setup script creates the txAdmin-compatible runtime layout and copies templates from:

```txt
config/templates/
```

into:

```txt
txData/dev.base/
```

It also copies:

```txt
config/server-icon.png
```

to:

```txt
txData/dev.base/server-icon.png
```

Resource layers are installed into:

```txt
txData/dev.base/resources/
```

Layer order:

1. official/base resources from `https://github.com/Trembita-Games/redm-server-data-cfx.git`
2. Trembita standalone resources from `https://github.com/Trembita-Games/redm-server-data.git`

Existing generated config files are preserved unless `-Overwrite` is used.

---

## 3. Configure Secrets

Edit:

```txt
txData/dev.base/secrets.cfg
```

Set:

```cfg
sv_licenseKey "your_license_key"
```

Create a license key at:

```txt
https://portal.cfx.re/keymaster
```

Do not commit `txData/dev.base/secrets.cfg`.

---

## 4. Review Permissions

Optional local permissions live at:

```txt
txData/dev.base/permissions.cfg
```

This file is generated from:

```txt
config/templates/permissions.cfg.example
```

Use it for local admin identifiers or server-specific permission changes.

---

## 5. Start the Server

Run:

```powershell
./scripts/windows/03-server-run.ps1
```

The script starts:

```txt
server/FXServer.exe
```

from this working directory:

```txt
txData/dev.base/
```

and executes:

```txt
server.cfg
```

This working-directory behavior is important because FXServer resolves nested `exec` paths relative to the process working directory.

Equivalent direct command:

```powershell
Push-Location txData/dev.base
../../server/FXServer.exe +exec server.cfg
Pop-Location
```

Logs are written to:

```txt
txData/default/logs/dev/
```

---

## Custom Runtime Profile

The default profile is `dev`.

To generate and run another profile:

```powershell
./scripts/windows/02-server-setup.ps1 -Profile prod
./scripts/windows/03-server-run.ps1 -Profile prod
```

This uses:

```txt
txData/default/
txData/prod.base/
```

`txData/default/` is the stable txAdmin control directory for every profile. `-Profile` only changes the runtime server directory under `txData/<profile>.base/`.

---

## Connect

Open RedM and connect locally:

```txt
connect 127.0.0.1:30120
```

For remote access, open TCP `30120` and UDP `30120` on the host firewall and network edge.

---

## Optional Database

The vanilla server does not require a database.

To start the optional MariaDB service:

```powershell
Copy-Item config/.env.example .env
docker compose up -d database
```

See [Docker Guide](docker.md).

---

## txAdmin

txAdmin runtime data is stored in:

```txt
txData/
```

The stable txAdmin control directory is:

```txt
txData/default/
```

If txAdmin prompts for setup, use the existing server data/configuration flow and point it at the generated runtime configuration:

```txt
txData/dev.base/server.cfg
```

See [txAdmin Setup](txadmin.md).
