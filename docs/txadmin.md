# txAdmin Setup

txAdmin is the web-based management interface bundled with FXServer.

It is used to manage server startup, configuration, resources, players, logs and runtime administration.

---

## Current Scope

This template is txAdmin-compatible, but it does not store txAdmin runtime data in Git.

txAdmin runtime data is stored locally in:

```txt
txData/
```

The `txData/` directory is ignored by Git.

---

## First Startup

Start the server:

```powershell
./scripts/start.ps1
```

During the first startup, FXServer should print a txAdmin setup URL in the console.

Open the URL in your browser and follow the setup wizard.

---

## Recommended Setup Mode

When txAdmin asks how to configure the server, use an existing server data folder / existing configuration flow.

This repository already provides:

```txt
server.cfg
permissions.cfg
local.cfg
resources/
```

The main server configuration file is:

```txt
server.cfg
```

Do not let txAdmin overwrite the repository structure unless you intentionally want to regenerate the configuration.

---

## Configuration Files

This template uses the following configuration files:

```txt
server.cfg               -> tracked main server configuration
permissions.cfg          -> local permissions configuration, ignored by Git
permissions.cfg.example  -> tracked permissions template
local.cfg                -> local secrets and machine-specific settings, ignored by Git
local.cfg.example        -> tracked local configuration template
```

`server.cfg` executes:

```cfg
exec permissions.cfg
exec local.cfg
```

This keeps secrets and local server identifiers outside Git.

---

## Admin Permissions

By default, `permissions.cfg.example` contains minimal permission rules.

For local development, copy it to:

```txt
permissions.cfg
```

Then adjust it for your own Cfx.re identifiers if needed.

Example:

```cfg
add_ace group.admin command allow
add_ace group.admin command.quit deny
```

If you want to add yourself as an admin, add your real identifier to `permissions.cfg`.

Example format:

```cfg
add_principal identifier.fivem:YOUR_ID group.admin
```

Do not commit real personal identifiers unless they are intentionally public.

---

## Runtime State

txAdmin may generate runtime files and folders such as:

```txt
txData/
cache/
```

These are ignored by Git.

Do not commit txAdmin runtime state into this repository.

---

## Local Development Notes

For local development, the recommended flow is:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
./scripts/setup.ps1
./scripts/start.ps1
```

Then complete the txAdmin setup in the browser if prompted.

---

## Server Listing and Public Access

txAdmin can help monitor the server, but it does not automatically fix public networking.

If the Cfx.re server list cannot reach your server, check:

- Windows Firewall
- router port forwarding
- VPS firewall/security group
- TCP `30120`
- UDP `30120`
- NAT/CG-NAT limitations

See:

- [Troubleshooting](troubleshooting.md)

---

## Notes

txAdmin support in this repository is intentionally minimal.

This template does not currently include:

- txAdmin deployment automation
- production txAdmin hardening
- Dockerized txAdmin setup
- custom txAdmin recipes

Those may be added later if needed.