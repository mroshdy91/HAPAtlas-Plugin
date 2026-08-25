# HAPAtlas Plugin

HAPAtlas is the guarded hand of an HVAC engineer's agent inside Carrier HAP. This repository is the public, cross-agent plugin package for HAPAtlas Alpha v1. It contains the shared workflow skill, reference material, marketplace records, and MCP launch configuration. It does not contain the HAPAtlas runtime or any Carrier software or licensed content.

## Status and prerequisites

This is an Alpha package for Windows. It supports only:

- Carrier HAP 6.3 build `6.03.1378`, payload `6.3.0001`;
- Carrier HAP 5.1 build `5.01.0014`, project format `AR002`.

Install the signed HAPAtlas product package before installing this plugin. The product installer must make the stable `hapatlas` command available. Verify it before opening an agent:

```powershell
hapatlas --version
hapatlas --doctor
```

Installing this Git repository alone does not install the Windows runtime. Carrier HAP is also a separate licensed prerequisite.

## Installation

Choose either this product-specific marketplace or the umbrella [Atlas Marketplace](https://github.com/mroshdy91/Atlas-Marketplace). Do not install HAPAtlas from both sources in the same client profile.

### Codex

```text
codex plugin marketplace add mroshdy91/HAPAtlas-Plugin
```

Open `/plugins`, select the HAPAtlas marketplace, and install `hapatlas`. Start a new session after installation. Codex plugins are available in Codex CLI and Codex in the ChatGPT desktop app, not the Codex IDE extension.

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
gemini extensions install https://github.com/mroshdy91/HAPAtlas-Plugin --ref v1.0.0-alpha.1
```

### Cursor and Agent Plugins clients

The repository root implements Agent Plugins 1.0 with `plugin.json`, `mcp.json`, and `skills/`. Import the repository through the client's plugin or team-marketplace workflow. Cursor's public directory has a separate submission and review process.

## Safety boundary

HAPAtlas operates only explicitly selected, supported HAP sessions. It revalidates project identity and revision before stateful work, preflights writes on an immutable clone, limits mutations to the requested engineer-visible domain, and leaves Save to the engineer.

Never use this package to infer support for another HAP build. The plugin must not redistribute Carrier binaries, reference data, templates, projects, reports, licensed help content, working sets, or payload files.

## Repository contents

- `skills/use-hapatlas/`: shared engineer workflow skill and references.
- `.codex-plugin/` and `.agents/plugins/`: Codex package and marketplace.
- `.claude-plugin/`: Claude Code package and marketplace.
- `.zcode-plugin/` and `marketplace.json`: ZCode package and marketplace.
- `.github/plugin/`: GitHub Copilot CLI marketplace.
- `plugin.json` and `mcp.json`: Agent Plugins 1.0 package.
- `gemini-extension.json`: Gemini CLI extension manifest.
- `.mcp.json`: host-compatible local MCP declaration.
- `provenance.json`: exact source release lineage.

## Source and licensing

This distribution is generated from the private HAPAtlas product repository. The exact source release is recorded in `provenance.json`. The public visibility of this repository does not grant an open-source license; the package currently declares a proprietary license. Carrier and HAP are trademarks of their respective owner. HAPAtlas is not a redistribution of Carrier software.
