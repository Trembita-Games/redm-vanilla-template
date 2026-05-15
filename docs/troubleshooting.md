# Troubleshooting

## FXServer Artifacts Missing

If startup fails with a message similar to:

```txt
FXServer executable is missing.
```

Make sure the `server/` directory contains extracted FXServer artifacts.

Expected Windows structure:

```txt
redm-vanilla-template/
├── server/
│   ├── FXServer.exe
│   ├── citizen/
│   └── ...
├── scripts/
├── server.cfg
└── local.cfg
```

The `server/` directory is ignored by Git and must be created locally.

---

## License Key Missing

If the server fails with:

```txt
This server does not have a license key specified.
```

Make sure `local.cfg` exists in the repository root:

```txt
redm-vanilla-template/local.cfg
```

It should contain:

```cfg
sv_licenseKey "your_license_key"
```

You can create a license key at:

```txt
https://portal.cfx.re/keymaster
```

Do not commit `local.cfg`. It is ignored by Git.

---

## Default Resources Are Missing

If the server logs show errors like:

```txt
Couldn't find resource mapmanager.
Couldn't find resource chat.
Couldn't find resource spawnmanager.
Couldn't find resource sessionmanager-rdr3.
Couldn't find resource basic-gamemode.
Couldn't find resource hardcap.
Couldn't find resource rconlog.
```

Run the setup script:

```powershell
./scripts/setup.ps1
```

The setup script temporarily clones `citizenfx/cfx-server-data` and copies default resources into:

```txt
resources/[system]/
```

After setup, the local structure should contain folders similar to:

```txt
resources/[system]/
├── [gamemodes]/
├── [gameplay]/
├── [local]/
├── [managers]/
├── [system]/
└── [test]/
```

These runtime-installed resources are ignored by Git and should not be committed.

---

## Yarn/Webpack Messages on First Startup

During the first startup, some resources may run build tasks:

```txt
Running build tasks on resource webpack
Running build tasks on resource chat
Running build tasks on resource sessionmanager-rdr3
```

You may also temporarily see:

```txt
Couldn't start resource chat.
Couldn't start resource sessionmanager-rdr3.
```

This can be normal during the first run while Yarn/Webpack dependencies are installed and built.

The important part is that the resources eventually start:

```txt
Started resource sessionmanager-rdr3
Started resource webpack
Started resource chat
```

After the first successful build, later startups should usually be faster and cleaner.

---

## `fsevents` Warnings on Windows

On Windows, Yarn may print warnings like:

```txt
fsevents: The platform "win32" is incompatible with this module.
```

This is expected.

`fsevents` is an optional dependency commonly used on macOS. It is skipped on Windows and does not block the server from starting.

---

## Server List Query Timeout

You may see logs like:

```txt
Server list query returned an error:
server request failed for endpoint https://YOUR_PUBLIC_IP:30120/players.json
context deadline exceeded
```

This means the public Cfx.re server list cannot reach your server from the internet.

This is usually related to networking, not local startup.

Check:

- Windows Firewall
- router port forwarding
- VPS firewall/security group
- TCP `30120`
- UDP `30120`
- NAT/CG-NAT limitations from your internet provider

For local testing, this does not block connecting through:

```txt
connect 127.0.0.1:30120
```

Public server listing and remote player access should be validated separately from local startup.

---

## Cannot Connect Locally

If the server starts but RedM cannot connect locally, try:

```txt
connect 127.0.0.1:30120
```

Check that:

- the server process is still running
- `endpoint_add_tcp` uses port `30120`
- `endpoint_add_udp` uses port `30120`
- Windows Firewall is not blocking `FXServer.exe`
- no other process is already using port `30120`

---

## RedM ROS Entitlement Token Error

RedM may fail to start with a Rockstar Online Services entitlement/token error.

This is a client-side RedM/Rockstar/RDR2 issue, not a server configuration problem.

Possible fixes:

- close RedM
- close Rockstar Games Launcher
- close Steam/Epic Games Launcher
- start Rockstar Games Launcher manually
- make sure you are logged in
- start regular Red Dead Redemption 2 once
- reach the main menu
- close the game
- start RedM again

Also check:

- the RDR2 copy is legitimate
- the correct Rockstar account is logged in
- VPN/proxy is disabled
- firewall/antivirus is not blocking Rockstar/RedM

---

## RedM Fails to Start with Vulkan Memory Error

Error example:

```txt
Failed to allocate memory for Vulkan.
VkResult: VK_ERROR_OUT_OF_DEVICE_MEMORY
A device memory allocation has failed.
```

This is a client-side RedM/RDR2 graphics issue, not a server configuration problem.

Possible fixes:

- close RedM, RDR2 and Rockstar Games Launcher
- clear RedM cache
- switch RDR2 graphics API from Vulkan to DirectX 12
- remove or reset Vulkan-related settings from:

```txt
Documents/Rockstar Games/Red Dead Redemption 2/Settings
```

- update GPU drivers
- restart the PC

After clearing Vulkan-related settings, RedM should recreate clean graphics configuration files on the next startup.

---

## Clearing RedM Cache

If RedM behaves incorrectly, close RedM and remove cache folders from:

```txt
%localappdata%/RedM/RedM.app/data/
```

Common folders to remove:

```txt
cache
server-cache
server-cache-priv
```

If you are unsure, rename the `data` folder to `data_backup` and let RedM recreate it.

Do not delete your RDR2 game installation.

---

## Crash on Exit

RedM/RDR2 may crash when exiting the client.

If the server works and the crash only happens on exit, this is most likely a client-side RedM/RDR2 issue.

This template does not currently provide a server-side fix for this behavior.

Recommended actions:

- keep RedM updated
- keep GPU drivers updated
- avoid overlays when testing
- check RedM/Cfx.re community reports for similar issues

---

## Missing Buildings, Glass or Collisions

On a minimal vanilla RedM server, some world assets, interiors, glass, doors or collisions may not behave exactly like in Red Dead Redemption 2 single-player.

Examples:

```txt
- missing glass on some buildings
- unloaded or partially loaded buildings
- missing collision on some world objects
- ability to walk through some structures
```

This is usually related to RedM world streaming, map resources, interiors, IPLs, YMAPs or game state differences between single-player RDR2 and a minimal RedM server.

This template intentionally does not include custom map fixes, interior loaders or RP world resources.

For a production RP server, these issues should be handled by optional standalone resources such as:

```txt
redm-world-baseline
redm-map-fixes
redm-world-streaming
```

These modules should remain separate from the vanilla template to keep this repository clean and framework-agnostic.

---

## Server Icon Is Invalid

If the server logs show:

```txt
The file server-icon.png must be a 96x96 PNG image to be used as icon.
```

Make sure `server-icon.png` exists in the repository root and has the exact size:

```txt
96x96
```

The file must be a PNG image.

Expected path:

```txt
redm-vanilla-template/server-icon.png
```

---

## txAdmin Does Not Initialize

If txAdmin does not initialize, check:

- FXServer artifacts are installed correctly
- the server is started from the repository root through `scripts/start.ps1`
- `server.cfg` exists in the repository root
- the console does not show artifact/runtime errors

If needed, remove local runtime state and restart:

```txt
txData/
cache/
```

Both folders are ignored by Git.

---

## Server Does Not Start

Check:

- `server.cfg` exists
- `permissions.cfg` exists
- `local.cfg` exists
- `sv_licenseKey` is set in `local.cfg`
- FXServer artifacts exist in `server/`
- default Cfx.re resources were installed with `scripts/setup.ps1`
- ports `30120` TCP/UDP are available

---

## Notes

This repository is a vanilla-first infrastructure template.

It intentionally does not try to solve every gameplay, world streaming, RP or client-side RedM/RDR2 issue directly.

Server infrastructure issues should be fixed in this repository.

Gameplay systems, world fixes and RP functionality should be implemented as separate optional modules.