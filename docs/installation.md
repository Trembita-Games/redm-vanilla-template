# Installation Guide

This guide explains how to set up and run `redm-vanilla-template` locally.

The currently validated flow is Windows-based and uses PowerShell scripts.

---

## Requirements

- RedM
- Red Dead Redemption 2
- FXServer artifacts
- Git
- PowerShell
- 7-Zip
- Windows
- Open ports:
  - TCP `30120`
  - UDP `30120`

Optional:

- Docker
- Docker Compose

Docker is only needed for the optional MariaDB service.

---

## Repository Layout

Expected local runtime structure:

```txt
redm-vanilla-template/
├── server/
├── resources/
├── scripts/
├── server.cfg
├── permissions.cfg
├── permissions.cfg.example
├── local.cfg
├── local.cfg.example
├── docker-compose.yaml
├── .env.example
└── .env
```

Runtime/local files ignored by Git:

```txt
server/
local.cfg
permissions.cfg
.env
cache/
txData/
resources/[system]/*
```

Tracked example files:

```txt
local.cfg.example
permissions.cfg.example
.env.example
```

---

## Download FXServer Artifacts

Download the latest recommended FXServer artifacts from:

```txt
https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
```

For the first setup, prefer the **latest recommended** build instead of the newest optional build.

---

### Option A — PowerShell Artifact Updater

Copy the direct `.7z` artifact download URL from the recommended build page and run:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

Example:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/BUILD_ID/server.7z"
```

The script will:

- download the artifact archive
- recreate the local `server/` directory
- extract FXServer artifacts into `server/`
- verify that `FXServer.exe` exists

The updater requires 7-Zip to be installed and available as `7z.exe`.

---

### Option B — Manual Installation

Download the artifact archive manually and extract it into:

```txt
server/
```

Resulting structure:

```txt
redm-vanilla-template/
├── server/
│   ├── FXServer.exe
│   ├── citizen/
│   └── ...
├── resources/
├── scripts/
├── server.cfg
└── permissions.cfg
```

The `server/` directory is ignored by Git and must not be committed.

---

## Install Default Cfx.re Resources

This template does not store default Cfx.re resources directly in the repository.

Run the setup script:

```powershell
./scripts/setup.ps1
```

The script temporarily downloads:

```txt
https://github.com/Trembita-Games/redm-server-data-cfx
```

Then copies default resources into:

```txt
resources/[system]/
```

After setup, the local structure should look similar to:

```txt
resources/
├── [system]/
│   ├── [gamemodes]/
│   ├── [gameplay]/
│   ├── [local]/
│   ├── [managers]/
│   ├── [system]/
│   └── [test]/
├── [standalone]/
└── [local]/
```

The copied resources are ignored by Git and should not be committed.

---

## Local Configuration

This repository does not store secrets in `server.cfg`.

The setup script creates:

```txt
local.cfg
```

from:

```txt
local.cfg.example
```

if `local.cfg` does not already exist.

You can also create it manually:

```powershell
Copy-Item local.cfg.example local.cfg
```

Then set your Cfx.re license key:

```cfg
sv_licenseKey "your_license_key"
```

You can create a license key at:

```txt
https://portal.cfx.re/keymaster
```

`local.cfg` is ignored by Git and must not be committed.

---

## Permissions Configuration

The setup script creates:

```txt
permissions.cfg
```

from:

```txt
permissions.cfg.example
```

if `permissions.cfg` does not already exist.

You can also create it manually:

```powershell
Copy-Item permissions.cfg.example permissions.cfg
```

`server.cfg` executes:

```cfg
exec permissions.cfg
```

`permissions.cfg` is ignored by Git because permissions may contain server-specific identifiers.

---

## Optional Docker Database

The vanilla server does not require a database.

However, optional future modules may require MariaDB/MySQL.

To start the optional local MariaDB service, create `.env`:

```powershell
Copy-Item .env.example .env
```

Then run:

```bash
docker compose up -d database
```

See:

- [Docker Guide](docker.md)

---

## Starting the Server

### Windows

```powershell
./scripts/start.ps1
```

The script starts:

```txt
server/FXServer.exe
```

with:

```txt
server.cfg
```

---

### Linux

```bash
chmod +x ./scripts/start.sh
./scripts/start.sh
```

Linux setup automation is not fully implemented yet.

---

## Connecting to the Server

Open RedM and connect using:

```txt
connect 127.0.0.1:30120
```

For a remote server, use:

```txt
connect YOUR_SERVER_IP:30120
```

Or use the server browser.

---

## txAdmin

txAdmin should initialize during first startup.

Follow the web setup instructions displayed in the server console.

This repository already provides the main server configuration:

```txt
server.cfg
```

When possible, use the existing configuration instead of generating a new one.

txAdmin runtime data is stored locally and ignored by Git:

```txt
txData/
```

See:

- [txAdmin Setup](txadmin.md)

---

## Public Networking

For public access, make sure the following ports are open:

```txt
TCP 30120
UDP 30120
```

If running locally behind a router, configure port forwarding for both TCP and UDP.

If running on a VPS, configure the provider firewall/security group to allow both TCP and UDP traffic on port `30120`.

Public server listing and remote player access should be validated separately from local startup.

---

## Expected First Startup Behavior

On first startup, some resources may run Yarn/Webpack build tasks.

You may temporarily see messages such as:

```txt
Running build tasks on resource webpack
Running build tasks on resource chat
Running build tasks on resource sessionmanager-rdr3
```

This can be normal.

The important part is that resources eventually start successfully.

See:

- [Troubleshooting](troubleshooting.md)

---

## Notes

This template intentionally does not include:

- RP frameworks
- inventory systems
- economy systems
- jobs
- housing
- custom gameplay scripts
- map fixes
- world streaming fixes

It is a vanilla-first infrastructure baseline for RedM/RDR2 servers.
