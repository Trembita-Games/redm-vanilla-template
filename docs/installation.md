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

https://portal.cfx.re/keymaster

`local.cfg` is ignored by Git and must not be committed.