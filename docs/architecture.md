# Architecture

## Repository Role

This repository is an infrastructure/template repository.

Tracked content should be limited to:

- configuration templates
- source assets such as `config/server-icon.png`
- setup/start scripts
- documentation
- validation configuration

Generated runtime state belongs outside Git.

---

## Runtime Role

Runtime state is generated locally into:

```txt
server/
txData/
```

`server/` contains FXServer artifacts.

`txData/` contains txAdmin-compatible runtime data, generated configs, resources, cache, logs and local secrets.

The txAdmin control directory is stable:

```txt
txData/default/
```

Script-managed server profiles live under:

```txt
txData/<profile>.base/
```

---

## Runtime Execution Model

Standalone startup mirrors txAdmin-style path behavior by starting FXServer from:

```txt
txData/<profile>.base/
```

The run script executes:

```txt
server.cfg
```

from that working directory. This allows same-folder config includes to resolve deterministically:

```cfg
exec resources.cfg
exec trembita-resources.cfg
exec permissions.cfg
exec secrets.cfg
```

Logs are written to:

```txt
txData/default/logs/
```

---

## Configuration Model

Tracked templates live in:

```txt
config/templates/
```

Generated runtime configs live in:

```txt
txData/<profile>.base/
```

The setup script preserves existing generated configs unless `-Overwrite` is supplied.

---

## Resource Model

Runtime resources are installed into:

```txt
txData/<profile>.base/resources/
```

Layer order:

1. official/base resources
2. Trembita standalone resources

The current custom standalone resource startup list is tracked in:

```txt
config/templates/trembita-resources.cfg.example
```

---

## Project Boundaries

This repository intentionally does not include RP framework code, gameplay systems, inventory, economy, jobs, housing, map fixes or production hosting hardening.

Those should remain separate modules or operational layers.
