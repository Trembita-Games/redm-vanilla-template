# Troubleshooting

## FXServer Artifacts Missing

If startup reports that `server/FXServer.exe` is missing, install artifacts:

```powershell
./scripts/01-server-install.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

Expected local path:

```txt
server/FXServer.exe
```

`server/` is ignored by Git.

---

## Runtime Config Missing

If startup reports that `txData/<profile>.base/server.cfg` is missing, generate runtime data:

```powershell
./scripts/02-server-setup.ps1
```

Expected default `dev` config:

```txt
txData/dev.base/server.cfg
```

---

## License Key Missing

If FXServer reports that no license key is specified, edit:

```txt
txData/dev.base/secrets.cfg
```

Set:

```cfg
sv_licenseKey "your_license_key"
```

Create a key at:

```txt
https://portal.cfx.re/keymaster
```

Do not commit generated secrets.

---

## Resources Are Missing

If resources such as `mapmanager`, `chat`, `spawnmanager`, `sessionmanager-rdr3`, `basic-gamemode`, `hardcap`, `rconlog` or `tg-static-data` are missing, rerun setup:

```powershell
./scripts/02-server-setup.ps1
```

Resources should exist under:

```txt
txData/dev.base/resources/
```

Setup installs official/base resources first and Trembita standalone resources second.

---

## Nested Exec Files Are Missing

Errors such as these usually mean FXServer was started from the wrong working directory:

```txt
No such config file: resources.cfg
No such config file: trembita-resources.cfg
No such config file: permissions.cfg
No such config file: secrets.cfg
```

Use:

```powershell
./scripts/03-server-run.ps1
```

The run script starts FXServer from:

```txt
txData/dev.base/
```

and executes:

```txt
server.cfg
```

Do not start FXServer from the repository root with `+exec txData/dev.base/server.cfg` unless you also account for FXServer path resolution.

---

## Logs Are In the Wrong Location

The repository expects standalone logs under:

```txt
txData/default/logs/
```

Use `scripts/03-server-run.ps1` so logs are written there.

Repository-root `logs/` is ignored as a legacy/runtime safety net, but it is not the intended runtime log location.

---

## Server Icon Is Invalid

The tracked icon source is:

```txt
config/server-icon.png
```

Setup copies it to:

```txt
txData/dev.base/server-icon.png
```

The PNG must be exactly:

```txt
96x96
```

---

## Yarn or Webpack Messages on First Startup

Some base resources may run build tasks during first startup:

```txt
Running build tasks on resource webpack
Running build tasks on resource chat
Running build tasks on resource sessionmanager-rdr3
```

Temporary build-related messages can be normal. Later startups should usually be cleaner after dependencies are built.

---

## Public Server List Timeout

Messages about the public server list failing to query your server usually indicate networking problems, not local setup problems.

Check:

- Windows Firewall
- router port forwarding
- VPS firewall or security group
- TCP `30120`
- UDP `30120`
- NAT or CG-NAT limitations

Local testing can still work through:

```txt
connect 127.0.0.1:30120
```

---

## Cannot Connect Locally

Check:

- FXServer is still running
- `endpoint_add_tcp` uses `30120`
- `endpoint_add_udp` uses `30120`
- Windows Firewall allows `FXServer.exe`
- no other process uses port `30120`

Connect with:

```txt
connect 127.0.0.1:30120
```

---

## Client-Side RedM Issues

Some failures are client-side RedM/RDR2 issues rather than server configuration issues.

Examples:

- Rockstar Online Services entitlement or token errors
- Vulkan memory allocation errors
- crashes when exiting RedM
- local RedM cache corruption

Common recovery steps:

- restart RedM and Rockstar Games Launcher
- log in to Rockstar Games Launcher manually
- start regular Red Dead Redemption 2 once
- clear RedM cache under `%localappdata%/RedM/RedM.app/data/`
- update GPU drivers
- switch RDR2 graphics API from Vulkan to DirectX 12 if needed

---

## txAdmin Does Not Initialize

Check:

- `server/FXServer.exe` exists
- `txData/dev.base/server.cfg` exists
- the server is started with `scripts/03-server-run.ps1`
- the process working directory is `txData/dev.base/`
- console output does not show artifact or config errors

If needed, remove generated runtime state and rerun setup:

```txt
txData/
```

Then:

```powershell
./scripts/02-server-setup.ps1
./scripts/03-server-run.ps1
```

---

## Server Does Not Start

Verify:

- `server/FXServer.exe` exists
- `txData/dev.base/server.cfg` exists
- `txData/dev.base/resources.cfg` exists
- `txData/dev.base/trembita-resources.cfg` exists
- `txData/dev.base/permissions.cfg` exists
- `txData/dev.base/secrets.cfg` exists
- `sv_licenseKey` is set in `txData/dev.base/secrets.cfg`
- resources exist under `txData/dev.base/resources/`
- TCP `30120` and UDP `30120` are available

---

## Gameplay or World Issues

This repository is a vanilla-first infrastructure template.

It does not include map fixes, interiors, RP systems, economy, inventory, character systems or production gameplay resources.

Those should be implemented as separate optional modules.
