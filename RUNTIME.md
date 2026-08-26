# Pinned public runtime

The plugin installs this runtime automatically on first use. A new user should not download or unpack it manually.

| Field | Value |
|---|---|
| Plugin version | `1.0.0-alpha.1-public.1` |
| Runtime release | `runtime-v1.0.0-alpha.1-public.1` |
| Source commit | `1cc266986128e5e412c367bb702680f7c35f44e0` |
| Distribution | unsigned `public-runtime` |
| Implementation | `1.0.0-alpha.1+pkg.9928919c90935e37c9066f1e` |
| ZIP bytes | `60629387` |
| ZIP SHA-256 | `c8485d81f64b1385c1b72c894eca9db5142c62e12f0a756b74ec8346a01ca3fc` |
| Inventory SHA-256 | `3c2923d2374fcd6ff9f640909f07b7c42b147e67c9e394bb0de723105d667892` |
| Runtime manifest SHA-256 | `9928919c90935e37c9066f1e87e431091befaa839331c6446fb2c8b21b094bf6` |

The [public release](https://github.com/mroshdy91/HAPAtlas-Plugin/releases/tag/runtime-v1.0.0-alpha.1-public.1) contains only the compiled runtime ZIP, inventory, and checksum sidecar. Source remains private. The complete 435-file archive passed independent size/hash, manifest, path, forbidden-file, and private-marker checks after a clean detached build with 695 passing tests. Live HAP opt-in tests were not run by the publishing agent.

## First connection and later starts

The client invokes the plugin-owned PowerShell bootstrap from its installed plugin directory. No development path or repository working directory is declared.

Codex's `.mcp.json` uses a plugin-relative working directory and script path;
the client resolves that directory inside its installed plugin cache. Claude
and ZCode explicitly reference `mcp.portable.json`, while Gemini and Agent
Plugins use their own generated root-path variables. All invoke the same
bootstrap and read the same immutable runtime pin.
Codex additionally forwards only four non-secret Windows platform variables
needed by the runtime prerequisite check; it does not inherit credentials or
the full parent environment.

1. Acquire a per-user bootstrap lock.
2. Reuse the verified hash-addressed cache, or download the exact pinned inventory and ZIP over HTTPS.
3. Verify both pinned SHA-256 values, archive paths, every file's size/hash, source identity, and runtime manifest.
4. Activate through the verified package's `install.ps1 -RuntimeOnly` if the required implementation is not active.
5. Verify the installed implementation and stable launcher, then launch through that runtime-owned launcher with raw MCP stdio, preserving its revocation checks.

The installer owns transactional activation and rollback metadata, Companion registration, and the standard per-user PATH entry. No agent configuration is written. A failed download is never activated; an invalid cached bundle is quarantined before a verified replacement is downloaded. Installed-file integrity failures fail closed.

## Cache and updates

Downloads and extracted packages live under:

```text
%LOCALAPPDATA%\HAPAtlas\PluginCache\<zip-sha256>\
```

Installed versions live under:

```text
%LOCALAPPDATA%\HAPAtlas\bin\versions\<package-implementation>\
```

A changed plugin runtime pin gets a separate cache and implementation directory. Verified cached packages work offline. Old versions and failed/quarantined download stages are preserved rather than deleted automatically. Close other HAPAtlas clients before changing runtime versions.

## Recovery

- **Download failure:** check free disk space, network/proxy access to GitHub and its release-assets host, then restart the agent. No manual ZIP is required.
- **Missing Microsoft runtime:** follow the installer's specific .NET or Visual C++ prerequisite message, then restart.
- **Cache integrity failure:** reconnect and restart; the bootstrap preserves the failed cache and downloads a verified copy. Never bypass hashes.
- **Installed runtime corruption or interrupted activation:** close HAPAtlas clients and follow the installer's transaction-recovery message. The verified cached bundle retains `install.ps1`, `rollback.ps1`, and `uninstall.ps1` for maintainer-guided recovery.
- **Blocked unsigned executable:** follow your organization's endpoint-security policy; do not disable security controls merely to make a test pass.
- **No HAP session:** open a licensed exact supported HAP project, then re-scout.

Default runtime uninstall preserves support, recovery, identity, and project-related HAPAtlas state. Purging that data is a separate explicit decision. Removing the plugin does not silently erase runtime or engineer data.

## Acceptance scope

Runtime build/audit evidence is separate from plugin installation acceptance. See [the acceptance record](docs/acceptance.md). The marketplace pin must not advance until the matching runtime/plugin pair passes its clean-Windows test.
