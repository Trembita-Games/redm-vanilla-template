# Docker

Docker support is optional.

The default and validated startup flow for this repository is still the local FXServer runtime flow:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
./scripts/setup.ps1
./scripts/start.ps1
```

Docker is used as an optional infrastructure helper, primarily for services that future gameplay/RP modules may need.

---

## Current Docker Scope

Current scope:

- MariaDB database service for local development
- persistent database volume
- environment-based configuration through `.env`

Not included yet:

- FXServer container runtime
- Linux artifact downloader
- production Docker deployment
- txAdmin container setup
- full RP stack

---

## Why Database Only?

The vanilla RedM/RDR2 server template does not currently require a database.

However, future optional modules may need one, for example:

- character system
- inventory
- economy
- jobs
- housing
- persistence

For this reason, Docker Compose provides an optional local MariaDB service without making the vanilla server depend on it.

---

## Required Files

Expected Docker-related files:

```txt
redm-vanilla-template/
├── docker-compose.yaml
├── .env.example
└── docs/
    └── docker.md
```

Local runtime file:

```txt
.env
```

The `.env` file is ignored by Git and must not be committed.

---

## Environment Configuration

Create a local `.env` file from `.env.example`:

```powershell
Copy-Item .env.example .env
```

On Linux/macOS:

```bash
cp .env.example .env
```

Then edit `.env` and set your local values.

Example:

```env
MARIADB_DATABASE=redm
MARIADB_USER=redm
MARIADB_PASSWORD=change_me
MARIADB_ROOT_PASSWORD=change_me_root
MARIADB_PORT=3306
```

For a real server, replace all placeholder passwords.

---

## Starting the Database

Start MariaDB:

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

Stop the database:

```bash
docker compose down
```

Stop and remove the database volume:

```bash
docker compose down -v
```

Warning: `docker compose down -v` deletes the local database data.

---

## Database Connection

Default local connection values are controlled by `.env`.

Example connection:

```txt
Host: 127.0.0.1
Port: 3306
Database: redm
User: redm
Password: value from MARIADB_PASSWORD
```

Example connection string:

```txt
mysql://redm:YOUR_PASSWORD@127.0.0.1:3306/redm
```

Do not commit real passwords or production connection strings.

---

## Data Persistence

MariaDB data is stored in a Docker volume:

```txt
redm-db-data
```

This keeps database data between container restarts.

To delete all local database data:

```bash
docker compose down -v
```

---

## Production Notes

The provided Docker Compose database service is suitable for local development and testing.

For production use, review and adjust:

- database passwords
- exposed ports
- firewall rules
- backup strategy
- volume location
- monitoring
- update policy
- server resource limits

Avoid exposing the database port publicly unless you fully understand the security implications.

For production servers, it is usually safer to:

- keep MariaDB private
- allow access only from the game server host/network
- use strong passwords
- configure regular backups

---

## FXServer Docker Runtime

FXServer is not containerized in this template yet.

Important distinction:

- Windows local startup uses Windows FXServer artifacts
- Docker containers generally require Linux FXServer artifacts

A future Docker-based FXServer runtime should be handled as a separate implementation step and validated independently.

Potential future work:

```txt
Investigate FXServer Docker deployment
Add Linux artifact updater
Add txAdmin Docker persistence
Add production Docker deployment guide
```

Until then, use Docker only for optional infrastructure services such as MariaDB.

---

## Recommended Local Workflow

For local development on Windows:

```powershell
Copy-Item .env.example .env
docker compose up -d database

./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
./scripts/setup.ps1
./scripts/start.ps1
```

The database can stay running independently while the RedM server is started and stopped locally.

---

## Notes

Docker support should not make this repository a full RP framework.

This repository remains:

- vanilla-first
- framework-agnostic
- infrastructure-oriented
- minimal by default

Database usage should be introduced only by optional standalone modules that actually need persistence.