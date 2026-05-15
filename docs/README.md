# Documentation

Project documentation and setup guides for `redm-vanilla-template`.

---

## Main Guides

- [Installation Guide](installation.md)
- [Development Guide](development.md)
- [Architecture Overview](architecture.md)
- [Troubleshooting](troubleshooting.md)

---

## Repository References

- [Root README](../README.md)
- [Scripts Documentation](../scripts/README.md)
- [Resources Documentation](../resources/README.md)
- [Example Local Configuration](../local.example.cfg)
- [Server Configuration](../server.cfg)
- [Permissions Configuration](../permissions.cfg)

---

## Common Workflows

### First Local Setup

1. Download or update FXServer artifacts.
2. Install default Cfx.re resources.
3. Create and configure `local.cfg`.
4. Start the server.

See:

- [Installation Guide](installation.md)
- [Scripts Documentation](../scripts/README.md)

### Troubleshooting Runtime Issues

If the server or RedM client fails to start, check:

- [Troubleshooting](troubleshooting.md)

### Understanding the Project Structure

If you want to understand why this repository is infrastructure-only and vanilla-first, check:

- [Architecture Overview](architecture.md)
- [Development Guide](development.md)

---

## Project Goals

This project focuses on:

- vanilla-first RedM/RDR2 infrastructure
- framework-agnostic architecture
- reproducible server setup
- modular resource organization
- minimal dependencies
- clean separation between template infrastructure and optional gameplay modules

---

## Philosophy

The repository is intentionally kept lightweight and infrastructure-oriented.

The goal is to provide a clean baseline for RedM/RDR2 servers without forcing heavy RP frameworks or large monolithic resource packs.

Gameplay systems, RP features, map fixes and world streaming helpers should be implemented as separate optional modules, not directly inside this template.