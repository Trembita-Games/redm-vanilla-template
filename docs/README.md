# Documentation

Documentation for `redm-vanilla-template`.

This repository is a source/bootstrap repository. Generated runtime files belong under `server/` and `txData/` and should not be committed.

---

## Guides

- [Installation guide](installation.md)
- [Scripts overview](../scripts/README.md)
- [Windows scripts](../scripts/windows/README.md)
- [Linux scripts](../scripts/linux/README.md)
- [txAdmin notes](txadmin.md)
- [Docker notes](docker.md)
- [Troubleshooting](troubleshooting.md)

---

## Important Runtime Paths

```text
server/                         -> shared FXServer artifacts
txData/default/                 -> stable txAdmin-compatible control directory
txData/default/logs/<profile>/  -> runtime logs
txData/<profile>.base/          -> script-managed runtime profile directory
```

Default runtime profile:

```text
dev
```

Default runtime server directory:

```text
txData/dev.base/
```

---

## Source References

- [Server configuration template](../config/templates/server.cfg.example)
- [Resource startup template](../config/templates/resources.cfg.example)
- [Trembita resource startup template](../config/templates/trembita-resources.cfg.example)
- [Secrets template](../config/templates/secrets.cfg.example)
- [Permissions template](../config/templates/permissions.cfg.example)
- [Server icon source](../config/server-icon.png)
- [Docker environment example](../config/.env.example)
- [Docker Compose configuration](../docker-compose.yaml)
- [Repository validation workflow](../.github/workflows/validate.yaml)
