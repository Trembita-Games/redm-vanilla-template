# Scripts

Utility scripts for setup, startup and maintenance.

---

## Windows

### Install default Cfx.re resources

```powershell
./scripts/setup.ps1
```

This script temporarily clones `citizenfx/cfx-server-data` and copies default resources into:

```txt
resources/[system]/
```

It also creates `local.cfg` from `local.cfg.example` if `local.cfg` does not already exist.

---

### Download or update FXServer artifacts

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

The artifact updater downloads and extracts FXServer artifacts into:

```txt
server/
```

The `server/` directory is ignored by Git.

This script requires 7-Zip.

---

### Start the server

```powershell
./scripts/start.ps1
```

This starts FXServer from:

```txt
server/FXServer.exe
```

using the root server configuration:

```txt
server.cfg
```

---

## Linux

### Start the server

```bash
chmod +x ./scripts/start.sh
./scripts/start.sh
```

Linux setup automation is not implemented yet.

---

## Script Overview

| Script | Platform | Status | Purpose |
|---|---|---|---|
| `setup.ps1` | Windows | Functional | Installs default Cfx.re resources and prepares `local.cfg` |
| `start.ps1` | Windows | Functional | Starts FXServer using `server.cfg` |
| `start.sh` | Linux | Basic | Starts FXServer on Linux |
| `update-artifacts.ps1` | Windows | Functional after Step 5 | Downloads and extracts FXServer artifacts |