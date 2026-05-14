# Installation Guide

## Requirements

- RedM
- FXServer artifacts
- Windows or Linux
- Open ports:
  - TCP 30120
  - UDP 30120

---

## Download FXServer Artifacts

Download the latest recommended FXServer artifacts from:

https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/

Extract the artifacts into:

```txt
server/
```

Resulting structure:

```txt
redm-vanilla-template/
├── server/
├── resources/
├── scripts/
├── server.cfg
└── permissions.cfg
```

---

## Starting the Server

### Windows

```powershell
./scripts/start.cmd
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
connect YOUR_SERVER_IP:30120
```

Or use the server browser.

---

## txAdmin

txAdmin will automatically initialize during first startup.

Follow the web setup instructions displayed in the server console.