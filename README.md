# redm-vanilla-template

Minimal vanilla-first RedM/RDR2 server infrastructure template focused on clean setup, reproducible local runtime and framework-agnostic architecture.

Created and maintained by members of the Oxbay community under Trembita Games.

---

## What Is This?

`redm-vanilla-template` is a clean infrastructure baseline for running a minimal RedM server for Red Dead Redemption 2.

It is designed as a starting point for:

- local RedM/RDR2 server testing
- open-source RedM infrastructure experiments
- future standalone RP/gameplay modules
- reproducible server setup
- framework-agnostic development

This repository is intentionally lightweight and does not try to be a full RP framework.

---

## Features

- Vanilla-first RedM/RDR2 server configuration
- Clean repository structure
- Windows PowerShell setup flow
- FXServer artifact updater
- Default Cfx.re resource installer
- Local config templates for secrets and permissions
- Optional Docker Compose MariaDB service
- txAdmin-compatible runtime layout
- Troubleshooting documentation based on real startup testing
- Framework-agnostic and open-source friendly structure

---

## What Is Not Included?

This repository does **not** include:

- RP frameworks
- inventory systems
- economy systems
- jobs
- housing
- character systems
- custom gameplay scripts
- map fixes
- world streaming fixes
- large resource packs

Gameplay, RP systems and world fixes should be implemented as separate optional modules.

---

## Quick Start

### 1. Clone the Repository

```bash
git clone git@github.com:Trembita-Games/redm-vanilla-template.git
cd redm-vanilla-template
```

---

### 2. Download FXServer Artifacts

Use the artifact updater script with a direct `.7z` artifact URL from the recommended Windows build:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

Or download and extract artifacts manually into:

```txt
server/
```

Expected structure:

```txt
redm-vanilla-template/
├── server/
│   ├── FXServer.exe
│   ├── citizen/
│   └── ...
├── server.cfg
└── scripts/
```

---

### 3. Install Default Cfx.re Resources

```powershell
./scripts/setup.ps1
```

This script installs default Cfx.re resources locally into:

```txt
resources/[system]/
```

It also creates local config files from examples if they do not exist:

```txt
local.cfg
permissions.cfg
```

---

### 4. Configure Local Secrets

Open:

```txt
local.cfg
```

Set your Cfx.re license key:

```cfg
sv_licenseKey "your_license_key"
```

You can create a key at:

```txt
https://portal.cfx.re/keymaster
```

Do not commit `local.cfg`.

---

### 5. Start the Server

```powershell
./scripts/start.ps1
```

Then connect from RedM:

```txt
connect 127.0.0.1:30120
```

---

## Optional Docker Database

This template includes optional Docker Compose support for a local MariaDB database.

The vanilla server does not require a database, but future modules may need one.

Create `.env` from `.env.example`:

```powershell
Copy-Item .env.example .env
```

Start MariaDB:

```bash
docker compose up -d database
```

See:

- [Docker Documentation](docs/docker.md)

---

## Repository Structure

```txt
redm-vanilla-template/
├── docs/                    -> Documentation and setup guides
├── resources/               -> Server resources and local modules
│   ├── [system]/            -> Runtime-installed default Cfx.re resources
│   ├── [standalone]/        -> Future standalone modules
│   └── [local]/             -> Local development resources
├── scripts/                 -> Setup, startup and maintenance scripts
├── server/                  -> FXServer artifacts, ignored by Git
├── docker-compose.yaml      -> Optional MariaDB service
├── .env.example             -> Example Docker environment variables
├── local.cfg.example        -> Example local secrets configuration
├── permissions.cfg.example  -> Example local permissions configuration
├── server.cfg               -> Main server configuration
└── server-icon.png          -> Server browser icon
```

---

## Scripts

| Script | Platform | Purpose |
|---|---|---|
| `scripts/update-artifacts.ps1` | Windows | Downloads and extracts FXServer artifacts |
| `scripts/setup.ps1` | Windows | Installs default Cfx.re resources and creates local configs |
| `scripts/start.ps1` | Windows | Starts FXServer with `server.cfg` |
| `scripts/start.sh` | Linux | Basic Linux startup script |

See:

- [Scripts Documentation](scripts/README.md)

---

## Documentation

- [Documentation Index](docs/README.md)
- [Installation Guide](docs/installation.md)
- [Docker Guide](docs/docker.md)
- [txAdmin Setup](docs/txadmin.md)
- [Architecture Overview](docs/architecture.md)
- [Development Guide](docs/development.md)
- [Troubleshooting](docs/troubleshooting.md)

---

## Current Validation Status

Validated locally:

- FXServer artifacts can be installed into `server/`
- default Cfx.re resources can be installed with `scripts/setup.ps1`
- license key works through `local.cfg`
- server starts with default resources
- `sessionmanager-rdr3`, `chat`, `webpack`, `mapmanager`, `spawnmanager`, `basic-gamemode`, `hardcap` and `rconlog` start successfully
- RedM client can connect locally
- known client-side startup issues are documented

Not yet covered by this repository:

- public server networking validation
- production hosting hardening
- full Dockerized FXServer runtime
- RP/world gameplay modules

---

## Philosophy

This project aims to provide a clean and minimal baseline for RedM/RDR2 servers without forcing heavy RP frameworks or large resource packs.

The setup should remain:

- vanilla-first
- modular
- reproducible
- infrastructure-oriented
- framework-agnostic
- open-source friendly

---

## Roadmap

Completed:

- [x] Repository initialization
- [x] Basic server configuration
- [x] Startup scripts
- [x] Default Cfx.re resources setup
- [x] FXServer artifact updater
- [x] Local config templates
- [x] Docker Compose MariaDB service
- [x] Troubleshooting documentation
- [x] Local vanilla startup validation

Planned:

- [ ] Improve Linux setup guide
- [ ] Expand txAdmin setup documentation
- [ ] Document public server networking
- [ ] Investigate FXServer Docker deployment
- [ ] Add optional standalone modules

---

## License

MIT License