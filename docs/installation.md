## Download FXServer Artifacts

Download the latest recommended FXServer artifacts from:

```txt
https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
```

For the first setup, prefer the **latest recommended** build instead of the newest optional build.

### Option A — Manual Installation

Download the artifact archive manually and extract it into:

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

### Option B — PowerShell Artifact Updater

You can also use the artifact updater script.

Copy the direct `.7z` artifact download URL from the recommended build page and run:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "PASTE_ARTIFACT_DOWNLOAD_URL_HERE"
```

Example:

```powershell
./scripts/update-artifacts.ps1 -ArtifactUrl "https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/BUILD_ID/server.7z"
```

The script will:

- download the artifact archive
- recreate the local `server/` directory
- extract FXServer artifacts into `server/`
- verify that `FXServer.exe` exists

The `server/` directory is ignored by Git and must not be committed.

The updater requires 7-Zip to be installed and available as `7z.exe`.