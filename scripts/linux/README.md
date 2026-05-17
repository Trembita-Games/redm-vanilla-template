# Linux Server Scripts

Linux Bash scripts are currently placeholders. They reserve the same three-step structure as the Windows flow, but they do not install artifacts, generate runtime files, or start FXServer yet.

---

## Scripts

| Script | Current behavior |
|---|---|
| `scripts/linux/01-server-install.sh` | Prints placeholder install status |
| `scripts/linux/02-server-setup.sh` | Prints placeholder setup status |
| `scripts/linux/03-server-run.sh` | Prints placeholder run status |

---

## Placeholder Commands

```bash
./scripts/linux/01-server-install.sh
./scripts/linux/02-server-setup.sh
./scripts/linux/03-server-run.sh
```

These commands currently only print status messages.

---

## Intended Future Runtime Model

Linux should match the Windows runtime model when implemented:

```text
server/                         -> shared FXServer artifacts
txData/default/                 -> stable txAdmin-compatible control directory
txData/default/logs/<profile>/  -> runtime logs
txData/<profile>.base/          -> script-managed runtime profile directory
```

Default profile:

```text
dev
```

Runtime profile example:

```text
txData/dev.base/
```

---

## Line Endings

Shell scripts must use LF line endings. The repository enforces this through `.gitattributes`:

```gitattributes
*.sh text eol=lf
```

If executable bits are lost on Linux, restore them:

```bash
chmod +x scripts/linux/01-server-install.sh
chmod +x scripts/linux/02-server-setup.sh
chmod +x scripts/linux/03-server-run.sh
```

---

## Current Status

Use the Windows scripts for the current working script-based runtime flow.
