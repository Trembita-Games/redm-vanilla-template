# Architecture

## Philosophy

This project follows a vanilla-first and framework-agnostic approach.

The template is intended to provide:

- clean infrastructure
- reproducible setup
- minimal dependencies
- modular resource organization

---

## Scope

Included:

- server configuration
- startup scripts
- txAdmin support
- infrastructure foundation

Not included:

- RP frameworks
- economy systems
- inventory systems
- jobs
- housing
- gameplay modifications

---

## Resource Organization

```txt
resources/
├── [system]
├── [standalone]
└── [local]
```

Future modules should remain standalone and composable whenever possible.