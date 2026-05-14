# Installation Guide

## Requirements

- RedM
- FXServer artifacts
- Git
- Windows or Linux
- Open ports:
  - TCP 30120
  - UDP 30120

---

## Repository Layout

Expected local runtime structure:

```txt
redm-vanilla-template/
├── server/
├── resources/
├── scripts/
├── server.cfg
├── permissions.cfg
├── local.example.cfg
└── local.cfg
```

The `server/` directory is used for FXServer runtime artifacts and is ignored by Git.

The `local.cfg` file is used for local secrets and is also ignored by Git.

---

## Download FXServer Artifacts

Download the latest recommended FXServer artifacts from:

```txt
https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
```

For the first setup, prefer the **latest recommended** build instead of the newest optional build.

Extract the artifacts into:

```txt
server/
```

Resulting structure:

```txt
redm-vanilla-template/
├── server/
│   ├── FXServer.exe
│   ├── citizen/
│   └── ...
├── resources/
├── scripts/
├── server.cfg
└── permissions.cfg
```

---

## Local Configuration

This repository does not store secrets in `server.cfg`.

Create a local configuration file:

```txt
local.cfg
```

You can copy the example file:

```bash
cp local.example.cfg local.cfg
```

On Windows PowerShell:

```powershell
Copy-Item local.example.cfg local.cfg
```

Then set your Cfx.re license key:

```cfg
sv_licenseKey "your_license_key"
```

You can create a license key at:

```txt
https://portal.cfx.re/keymaster
```

`local.cfg` is ignored by Git and must not be committed.

---

## Install Default Cfx.re Resources

This template does not store default Cfx.re resources directly in the repository.

Run the setup script to install them locally:

```powershell
./scripts/setup.ps1
```

The script temporarily downloads:

```txt
https://github.com/citizenfx/cfx-server-data
```

Then copies its default resources into:

```txt
resources/[system]/
```

The copied resources are ignored by Git and should not be committed.

After setup, the local structure should look similar to:

```txt
resources/
├── [system]/
│   ├── [gamemodes]/
│   ├── [gameplay]/
│   ├── [local]/
│   ├── [managers]/
│   └── [system]/
├── [standalone]/
└── [local]/
```

---

## Starting the Server

### Windows

```powershell
./scripts/start.ps1
```

### Linux

```bash
chmod +x ./scripts/start.sh
./scripts/start.sh
```

---

## Connecting to the Server

Open RedM and connect using:

```txt
connect 127.0.0.1:30120
```

For a remote server, use:

```txt
connect YOUR_SERVER_IP:30120
```

Or use the server browser.

---

## txAdmin

txAdmin should initialize during first startup.

Follow the web setup instructions displayed in the server console.

---

## Public Networking

For public access, make sure the following ports are open:

```txt
TCP 30120
UDP 30120
```

If running locally behind a router, configure port forwarding for both TCP and UDP.

If running on a VPS, configure the provider firewall/security group to allow both TCP and UDP traffic on port `30120`.

---

## Notes

This template intentionally does not include:

- RP frameworks
- inventory systems
- economy systems
- jobs
- housing
- custom gameplay scripts

It is a vanilla-first infrastructure baseline for RedM servers.