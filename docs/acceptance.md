# Public Alpha installation acceptance

Runtime candidate: `1cc266986128e5e412c367bb702680f7c35f44e0`.
Plugin candidate: `1.0.0-alpha.1-public.1`.

## Verified runtime evidence

- Clean detached Release build: all 695 tests passed.
- Client-neutral validation: 62 cases, 21 tools, 100 actions, three accepted workflow replays.
- Complete 435-file ZIP: inventory, nested manifests, sizes, hashes, safe paths, forbidden files, known Carrier hashes and configured sensitive-marker checks passed.
- Public release asset digests match; anonymous inventory download verified.
- Live HAP opt-in tests were not run by the publishing agent; native acceptance remains the development handoff's evidence.

## Plugin release gate

Pending: clean Windows marketplace-only first-use installation, startup, static
contracts including `input-coverage`, `NO_HAP_SESSION`, warm/offline reuse,
reinstall/idempotency and cache-integrity recovery. The marketplace remains on
the prior pin until this gate passes.

The automated test uses a fresh hosted Windows runner without a preinstalled
HAPAtlas runtime. It stages the existing Atlas Marketplace catalog with the
candidate plugin commit, installs through Codex's marketplace/plugin service,
restarts that service, and verifies the loaded MCP and skill. It never calls a
HAP mutation tool or an LLM model. No Carrier installation is distributed to CI.

Generated Claude, Gemini, ZCode and Agent Plugins manifests are not claims of
end-to-end acceptance in those hosts. Their host-specific runtime acceptance
must be reported separately.
