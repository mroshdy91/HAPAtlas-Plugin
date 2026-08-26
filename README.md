# HAPAtlas Plugin

HAPAtlas helps an HVAC engineer's agent work inside an explicitly selected, licensed Carrier HAP project. This universal plugin contains one shared workflow skill, thin client manifests, and a verified first-use runtime bootstrap. The HAPAtlas runtime source stays private; Carrier software and data are never included.

## Install through Atlas Marketplace

Add [Atlas Marketplace](https://github.com/mroshdy91/Atlas-Marketplace), install **HAPAtlas**, then restart the agent. On first connection, the plugin downloads its exact public runtime, verifies the archive and complete inventory, installs it per-user, and starts the MCP. No manual runtime ZIP, SDK, repository checkout, or global MCP configuration is required.

For Codex, add the marketplace using the app's Plugins interface or:

```text
codex plugin marketplace add mroshdy91/Atlas-Marketplace
```

Install `hapatlas` from that marketplace and restart Codex. For Claude Code:

```text
/plugin marketplace add mroshdy91/Atlas-Marketplace
/plugin install hapatlas@atlas-marketplace
```

ZCode and Copilot clients can use the same marketplace through their plugin installation interface. Gemini CLI can install the pinned plugin repository:

```text
gemini extensions install https://github.com/mroshdy91/HAPAtlas-Plugin --ref v1.0.0-alpha.1-public.1
```

Do not install HAPAtlas from two marketplaces in one client profile, or add a separate HAPAtlas MCP entry. Existing users need to update the plugin and restart; pushing runtime source alone does not update a pinned installation.

Client-specific manifests are generated from one source. See [acceptance](docs/acceptance.md) for what has actually been tested; a generated manifest alone is not evidence that a client passed end-to-end acceptance.

## Requirements

- Windows x64 with an x64 agent process and Windows PowerShell 5.1 or later.
- Microsoft .NET 8 Runtime (x64), .NET Framework 4.8, and Visual C++ 2015–2022 Redistributable (x86). No SDK is needed. Missing prerequisites produce an explicit recovery message; the plugin does not silently install elevated system prerequisites.
- Internet access to GitHub release downloads on first use of a new pinned runtime.
- For live project work, lawfully licensed HAP 6.3 build `6.03.1378`, payload `6.3.0001`, or HAP 5.1 build `5.01.0014`, format `AR002`.

Without HAP installed/open, MCP tool and static contract discovery should work, and Project Scout should report `NO_HAP_SESSION`. Never infer support for another HAP build.

## Runtime boundary

Plugin version: `1.0.0-alpha.1-public.1`. The exact runtime source, release URLs, hashes, and implementation identity are pinned in [plugin.metadata.json](plugin.metadata.json) and [RUNTIME.md](RUNTIME.md).

The bootstrap writes progress only to stderr and passes raw MCP streams to the verified runtime. Downloads are cached by archive hash; every reuse verifies the pinned inventory and installed files. Activation uses the runtime's transactional per-user installer, which retains rollback evidence, registers its Companion, and adds the standard HAPAtlas user PATH entry. It never creates an agent plugin or global MCP entry.

## Safety boundary

Start with Project Scout, select one exact session, and follow installed contracts and revision gates. Reuse exact native-library definitions before custom inputs. Every engineering write requires the appropriate scope, preflight, and native readback. Only the engineer may Save.

HAP 6.x visual geometry remains engineer-only. The plugin must not redistribute Carrier binaries, reference data, templates, projects, reports, help, working sets, or payloads.

## Unsigned Alpha

This is a free, unsigned evaluation Alpha. Endpoint security may warn or block it; hashes establish byte identity, not a verified publisher. HAPAtlas is independent and is not affiliated with, endorsed by, or supported by Carrier. Compiled .NET assemblies can be inspected or decompiled even though source and debug symbols are not distributed.

## Runtime privacy

The first-use bootstrap contacts GitHub to download the pinned public assets. It sends no HAP project data. Runtime operations and structurally redacted diagnostics remain local, with no background upload, analytics, or telemetry. Support packages stay under `%LOCALAPPDATA%\HAPAtlas\Support\Sessions` unless the engineer deliberately shares one.

## Alpha use terms

Runtime use is governed by the finalized `HAPATLAS-ALPHA-TERMS.txt` inside the [public runtime release](https://github.com/mroshdy91/HAPAtlas-Plugin/releases/tag/runtime-v1.0.0-alpha.1-public.1). Licensed HAP is required; cracked or pirated installations are not supported. Public visibility and free evaluation do not grant open-source rights to the proprietary plugin or private runtime source.

## Maintaining this repository

- `skills/use-hapatlas/`: shared workflow guidance from the exact runtime handoff.
- `plugin.metadata.json`: canonical plugin metadata and immutable runtime pin.
- `scripts/generate-client-manifests.ps1`: generates client surfaces and provenance.
- `scripts/runtime-bootstrap.ps1` and `runtime-verification.ps1`: first-use installation and integrity checks.
- `tests/`: bootstrap integrity and clean-Windows marketplace acceptance.
