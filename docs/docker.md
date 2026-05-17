# Docker

Docker support is optional.

The validated RedM server runtime is local Windows FXServer through the PowerShell lifecycle:

```powershell
./scripts/windows/01-server-install.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
./scripts/windows/02-server-setup.ps1
./scripts/windows/03-server-run.ps1
```

Docker Compose currently provides only a local MariaDB service for future optional modules.

---

## Current Scope

Included:

- MariaDB database service
- persistent Docker volume
- environment-based configuration through `.env`

Not included:

- FXServer container runtime
- Linux artifact downloader
- production Docker deployment
- txAdmin container setup

---

## Files

Tracked Docker files:

```txt
docker-compose.yaml
config/.env.example
```

Local ignored file:

```txt
.env
```

---

## Configure Environment

Create `.env`:

```powershell
Copy-Item config/.env.example .env
```

Linux/macOS equivalent:

```bash
cp config/.env.example .env
```

Review the generated `.env` before using it outside local development.

---

## Start MariaDB

```bash
docker compose up -d database
```

Check status:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f database
```

Stop services:

```bash
docker compose down
```

Delete local database data:

```bash
docker compose down -v
```

`docker compose down -v` removes the local database volume.

---

## Connection Defaults

Values are controlled by `.env`.

Example:

```txt
Host: 127.0.0.1
Port: 3306
Database: redm
User: redm
Password: value from MARIADB_PASSWORD
```

Do not commit real passwords or production connection strings.

---

## Production Notes

The Compose database is a local development helper.

For production, review:

- database passwords
- exposed ports
- firewall rules
- backup strategy
- volume location
- monitoring
- update policy

Avoid exposing MariaDB publicly.

---

## FXServer and Docker

FXServer is not containerized in the current repository.

Windows local startup uses Windows FXServer artifacts in:

```txt
server/
```

A Dockerized FXServer runtime would require a separate Linux artifact and runtime validation path.
