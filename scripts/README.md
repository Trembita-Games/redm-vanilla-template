# Server Scripts

Platform-specific script entrypoints live under `scripts/windows/` and `scripts/linux/`.

| Platform | Status | Guide |
|---|---|---|
| Windows | Implemented | [Windows scripts](windows/README.md) |
| Linux | Placeholder | [Linux scripts](linux/README.md) |

---

## Lifecycle

The script-based workflow is organized into three numbered steps:

| Step | Purpose |
|---|---|
| `01` | Install FXServer artifacts into `server/` |
| `02` | Generate runtime structure and install resource layers |
| `03` | Start FXServer from `txData/<profile>.base/` |

---

## Runtime Model

All platform flows should preserve this layout:

```text
server/                         -> shared FXServer artifacts
txData/default/                 -> stable txAdmin-compatible control directory
txData/default/logs/<profile>/  -> runtime logs
txData/<profile>.base/          -> script-managed runtime profile directory
```

The default runtime profile is:

```text
dev
```

Use the platform-specific README for commands and current implementation status.
