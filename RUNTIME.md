# Private runtime prerequisite

HAPAtlas Plugin `1.0.0-alpha.1-private.1` requires the separately installed private runtime release below.

| Field | Value |
|---|---|
| Release | `v1.0.0-alpha.1-private.1` |
| Source commit | `5a48e0f52f48f3bf3e4667a1ec5ee776b32fd563` |
| Distribution profile | `public-runtime` |
| Package implementation | `1.0.0-alpha.1+pkg.4101efa4e717e9bec65e41ac` |
| ZIP | `HAPAtlas-1.0.0-alpha.1-windows-unsigned.zip` |
| ZIP SHA-256 | `00f22c0daaa46513f4a3a1b39ccae80193c946dbabab1e923b18377075c75dca` |
| Client-neutral capability guidance | `87d1656cc18e22263c1e2599a3969cf866014d43` on `codex/client-neutral-evaluation` |

The capability-guidance commit records the generated client-neutral inventory and runtime-contract evidence consumed by the plugin, including Available HAP 5.1 Space General create/edit actions. It does not replace the packaged runtime source commit above. The immutable `private.1` package predates that promotion metadata, so its installed `input-coverage` contract can still report the Space General slice as Candidate; agents must fail closed until a runtime package containing the promoted contract is installed.

Authorized testers can download the ZIP, checksum sidecar, and 435-file inventory from the [private HAPAtlas prerelease](https://github.com/mroshdy91/HAPAtlas/releases/tag/v1.0.0-alpha.1-private.1). GitHub authorization for the private repository is required.

## Verify the download

In PowerShell, run:

```powershell
(Get-FileHash -Algorithm SHA256 -LiteralPath .\HAPAtlas-1.0.0-alpha.1-windows-unsigned.zip).Hash.ToLowerInvariant()
```

The result must exactly equal:

```text
00f22c0daaa46513f4a3a1b39ccae80193c946dbabab1e923b18377075c75dca
```

Stop if it does not match.

## Install

Extract the ZIP, open PowerShell in the extracted directory, and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1 -RuntimeOnly
```

Restart the terminal and agent, then verify:

```powershell
hapatlas --version
hapatlas --doctor
```

Only after both commands succeed should the user install the plugin from one marketplace. The runtime installer does not install an agent plugin and does not create a standalone/global MCP entry.

## Roll back or uninstall

From the extracted release directory:

```powershell
.\rollback.ps1 -RuntimeOnly
.\uninstall.ps1
```

Default uninstall preserves support, recovery, identity, and other HAPAtlas user data. Permanent removal is a separate confirmed action:

```powershell
.\uninstall.ps1 -PurgeUserData
```

## Warning

This runtime is unsigned. Windows SmartScreen or endpoint-security policy may warn or block it, particularly because the exact-build HAP 6.3 adapter loads a managed bridge into the licensed local HAP process. SHA-256 confirms downloaded bytes; it does not establish a verified publisher.

HAPAtlas is independent, unsupported by Carrier, and limited to the exact HAP builds documented above. Carrier software and data are not included.
