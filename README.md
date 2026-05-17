# redm-vanilla-template

[![Validate Repository](https://github.com/Trembita-Games/redm-vanilla-template/actions/workflows/validate.yaml/badge.svg)](https://github.com/Trembita-Games/redm-vanilla-template/actions/workflows/validate.yaml)

Infrastructure-first RedM/RDR2 server bootstrap repository for a deterministic, txAdmin-compatible local runtime.

This repository stores source templates, scripts, static config assets, and documentation. It does not store generated FXServer artifacts, runtime resources, local secrets, generated configs, cache, or logs.

---

## Current Model

Tracked source files live in:

```text
config/
docs/
scripts/
docker-compose.yaml
```

Generated runtime files live in:

```text
server/
txData/
```

Runtime layout:

```text
server/                         -> shared FXServer artifacts
txData/default/                 -> stable txAdmin-compatible control directory
txData/default/data/            -> txAdmin control data directory
txData/default/logs/<profile>/  -> script-managed runtime logs
txData/default/config.json      -> generated txAdmin control config
txData/<profile>.base/          -> script-managed runtime profile directory
```

The default runtime profile is:

```text
dev
```

So the default script-managed runtime profile is:

```text
txData/dev.base/
```

---

## Quick Start on Windows

Run commands from the repository root.

Install FXServer artifacts:

```powershell
./scripts/windows/01-server-install.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

Generate the default `dev` runtime and install resources:

```powershell
./scripts/windows/02-server-setup.ps1
```

Configure the generated secrets file:

```text
txData/dev.base/secrets.cfg
```

Start the server:

```powershell
./scripts/windows/03-server-run.ps1
```

Use another runtime profile:

```powershell
./scripts/windows/02-server-setup.ps1 -Profile test
./scripts/windows/03-server-run.ps1 -Profile test
```

That keeps `txData/default/` stable and uses:

```text
txData/test.base/
```

---

## Resource Layers

Setup installs runtime resources into:

```text
txData/<profile>.base/resources/
```

Layer order:

1. official/base resources from `https://github.com/Trembita-Games/redm-server-data-cfx.git`
2. standalone resources from `https://github.com/Trembita-Games/redm-server-data.git`

---

## Config Sources

Tracked templates:

```text
config/templates/server.cfg.example
config/templates/resources.cfg.example
config/templates/trembita-resources.cfg.example
config/templates/permissions.cfg.example
config/templates/secrets.cfg.example
```

Generated runtime configs:

```text
txData/<profile>.base/server.cfg
txData/<profile>.base/resources.cfg
txData/<profile>.base/trembita-resources.cfg
txData/<profile>.base/permissions.cfg
txData/<profile>.base/secrets.cfg
```

Server icon source:

```text
config/server-icon.png
```

Runtime server icon:

```text
txData/<profile>.base/server-icon.png
```

---

## Scripts

- [Scripts overview](scripts/README.md)
- [Windows scripts](scripts/windows/README.md)
- [Linux scripts](scripts/linux/README.md)

Windows scripts are the current working implementation. Linux scripts are placeholders.

---

## Documentation

- [Documentation index](docs/README.md)
- [Installation guide](docs/installation.md)
- [txAdmin notes](docs/txadmin.md)
- [Docker notes](docs/docker.md)
- [Troubleshooting](docs/troubleshooting.md)

---

## Do Not Commit Runtime Files

Generated runtime files are ignored by Git and should stay local:

```text
server/
txData/
.env
logs/
cache/
.redm-server-data-cfx/
.redm-server-data/
```

---

## License

MIT License
