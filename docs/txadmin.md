# txAdmin Setup

txAdmin is bundled with FXServer and stores runtime state under `txData/`.

This repository is txAdmin-compatible, but it does not track txAdmin runtime data.

---

## Runtime Layout

The setup script generates:

```txt
txData/
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

`txData/` is ignored by Git.

`txData/default/` is the stable txAdmin control directory for every script-managed profile. `dev` is the default runtime server profile. Passing `-Profile prod` still uses `txData/default/` and changes only the runtime server directory to `txData/prod.base/`.

---

## First Startup

Use the normal lifecycle:

```powershell
./scripts/windows/01-server-install.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
./scripts/windows/02-server-setup.ps1
./scripts/windows/03-server-run.ps1
```

During first startup, FXServer may print a txAdmin setup URL in the console.

Open it and use the existing server data/configuration flow when possible.

Main generated config:

```txt
txData/dev.base/server.cfg
```

---

## Runtime Working Directory

Standalone startup intentionally runs FXServer from:

```txt
txData/dev.base/
```

and executes:

```txt
server.cfg
```

This matches FXServer path resolution for same-folder config includes:

```cfg
exec resources.cfg
exec trembita-resources.cfg
exec permissions.cfg
exec secrets.cfg
```

---

## Configuration Sources

Tracked templates:

```txt
config/templates/server.cfg.example
config/templates/resources.cfg.example
config/templates/trembita-resources.cfg.example
config/templates/permissions.cfg.example
config/templates/secrets.cfg.example
config/server-icon.png
```

Generated runtime files:

```txt
txData/dev.base/server.cfg
txData/dev.base/resources.cfg
txData/dev.base/trembita-resources.cfg
txData/dev.base/permissions.cfg
txData/dev.base/secrets.cfg
txData/dev.base/server-icon.png
```

Secrets and permissions are generated locally and should not be committed.

The setup script creates `txData/default/config.json` if missing with:

```json
{
  "version": 2
}
```

It does not create `txData/admins.json`.

---

## Resource Layers

Setup installs resources into:

```txt
txData/dev.base/resources/
```

Layer order:

1. official/base resources from `Trembita-Games/redm-server-data-cfx`
2. Trembita standalone resources from `Trembita-Games/redm-server-data`

The generated `trembita-resources.cfg` currently ensures:

```cfg
ensure tg-static-data
```

---

## Admin Permissions

Edit local permissions in:

```txt
txData/dev.base/permissions.cfg
```

Example:

```cfg
add_ace group.admin command allow
add_ace group.admin command.quit deny
add_principal identifier.fivem:YOUR_ID group.admin
```

Do not commit real personal identifiers unless intentionally public.

---

## Runtime State

txAdmin and FXServer may generate additional runtime files under:

```txt
txData/
txData/dev.base/cache/
```

Those files are local runtime state and ignored by Git.

---

## Notes

This repository does not include txAdmin recipe automation, production txAdmin hardening or Dockerized txAdmin deployment.
