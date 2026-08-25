# HAPAtlas Plugin

HAPAtlas is the guarded hand of an HVAC engineer's agent inside Carrier HAP. This repository is the public universal plugin for the HAPAtlas private Alpha. It contains one shared workflow skill, shared references, thin client manifests, and an MCP launch declaration. It does not contain the HAPAtlas runtime, private source code, or Carrier software or licensed content.

## Status and prerequisites

This plugin release is `1.0.0-alpha.1-private.1`. It requires all of the following:

- Windows;
- authorized access to the private [HAPAtlas runtime prerelease](https://github.com/mroshdy91/HAPAtlas/releases/tag/v1.0.0-alpha.1-private.1);
- a separately installed unsigned HAPAtlas runtime;
- Carrier HAP 6.3 build `6.03.1378`, payload `6.3.0001`, or Carrier HAP 5.1 build `5.01.0014`, project format `AR002`.

Installing this repository alone installs the skill and MCP declaration, not the runtime. Without the separate runtime, the `hapatlas` MCP command cannot connect. Carrier HAP is a separate licensed prerequisite.

Follow [RUNTIME.md](RUNTIME.md) to verify and install the exact private runtime before adding this plugin.

## Installation

Choose either this product-specific marketplace or the umbrella [Atlas Marketplace](https://github.com/mroshdy91/Atlas-Marketplace). Do not install HAPAtlas from both sources in the same client profile, and do not add a separate standalone/global HAPAtlas MCP entry.

### Codex

```text
codex plugin marketplace add mroshdy91/HAPAtlas-Plugin
```

Open `/plugins`, select **HAPAtlas**, and install `hapatlas`. Restart Codex or start a new session after installation.

### Claude Code

```text
/plugin marketplace add mroshdy91/HAPAtlas-Plugin
/plugin install hapatlas@hapatlas-marketplace
```

### ZCode

Open **Settings → Plugins → Create → Add marketplace**, enter:

```text
https://github.com/mroshdy91/HAPAtlas-Plugin
```

Install and enable `hapatlas`, then restart or reload the Agent runtime.

### GitHub Copilot CLI

```text
copilot plugin marketplace add mroshdy91/HAPAtlas-Plugin
copilot plugin install hapatlas@hapatlas-marketplace
```

### Gemini CLI

```text
gemini extensions install https://github.com/mroshdy91/HAPAtlas-Plugin --ref v1.0.0-alpha.1-private.1
```

### Cursor and Agent Plugins clients

The repository root implements Agent Plugins 1.0 with `plugin.json`, `mcp.json`, and `skills/`. Import this repository through the client's plugin or team-marketplace workflow.

## Runtime and MCP boundary

Every client launches the same external runtime through:

```json
{
  "command": "hapatlas",
  "args": []
}
```

There is no repository working directory or versioned runtime path. The runtime installer owns command discovery; this plugin owns only the universal skill and client manifests. Detailed schemas and contracts remain discoverable from the running MCP server through `hapatlas_contract_get` and are not duplicated manually here.

## Safety boundary

HAPAtlas operates only explicitly selected, supported HAP sessions. It revalidates project identity and revision before stateful work, preflights writes on an immutable clone, limits mutations to the requested engineer-visible domain, and leaves Save to the engineer.

Never infer support for another HAP build. This plugin must not redistribute Carrier binaries, reference data, templates, projects, reports, licensed help content, working sets, or payload files.

## Unsigned private Alpha

The runtime is an unsigned private Alpha. Windows SmartScreen or endpoint-security software may warn or block it. Its published SHA-256 proves byte identity, not publisher identity. HAPAtlas is an independent hobby project and is not affiliated with, endorsed by, or supported by Carrier.

Compiled .NET runtime assemblies can be inspected or decompiled even though the private source repository, source files, and debug symbols are not distributed.

## Runtime privacy

HAPAtlas operates locally with no background upload, analytics, or telemetry. It maintains structurally redacted, project/session-scoped diagnostics under `%LOCALAPPDATA%\HAPAtlas\Support\Sessions`. Support data stays local unless the engineer deliberately sends it to the maintainer. The complete privacy notice is included in the private runtime package.

## Alpha use terms

The plugin is proprietary. Runtime evaluation is governed by `HAPATLAS-ALPHA-TERMS.txt` included in the private runtime package. Public visibility permits inspection of this plugin repository but does not publish the private HAPAtlas runtime source or grant open-source rights.

## Repository contents

- `skills/use-hapatlas/`: the one shared engineer workflow skill and references.
- `plugin.metadata.json`: canonical public plugin and runtime provenance metadata.
- `scripts/generate-client-manifests.ps1`: generator for all thin host manifests.
- `.codex-plugin/`, `.claude-plugin/`, `.zcode-plugin/`, `.github/plugin/`, and root manifests: generated client surfaces.
- `.mcp.json` and `mcp.json`: generated bare-command MCP declarations.
- `provenance.json`: generated immutable runtime, skill handoff, and client-neutral capability-guidance provenance.
