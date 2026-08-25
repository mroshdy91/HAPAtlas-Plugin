---
name: use-hapatlas
description: Operate explicitly selected, open Carrier HAP 6.3 or HAP 5.1 projects through HAPAtlas using the engineer-visible, library-first, revision-locked workflow. Use for project inspection, HVAC input, library reuse, native design sizing, reports, audit, diagnosis, or undo.
---

# Use HAPAtlas

HAPAtlas is the engineer's guarded hand inside Carrier HAP. Follow the same workflow the engineer recognizes, use Carrier-native inputs and calculations, and leave Save to the engineer.

## Absolute rules

- Start every professional run with `hapatlas_project_scout action=summary`, then select one exact session and call `action=project-baseline`.
- If more than one session exists, use only a returned `session_id`. Never infer the active window. The ID and opaque `process_generation` are scoped to one exact HAP process lifetime; after HAP closes/reopens, discard them and re-scout even if the PID/project appears unchanged.
- HAPAtlas does not inject HAP 6.3 merely because a startup window looks responsive. `project-baseline` or another selected live action performs the direct exact-session attachment. For `waiting_for_context` only, follow the returned actual-Space-editor recovery.
- Read `action=workflow-progress` before a write or whenever sequencing is uncertain.
- Treat each tool as one visible HAP workflow chapter and each `action` as one professional activity. Never omit, guess, or substitute the action.
- Follow `WORKFLOW_GATE_BLOCKED` literally: perform its corrective tool/action, complete the named readback, and continue only through an allowed successor.
- Inspect immediately before a stateful action and pass the exact `expected_revision`.
- Search and inspect exact current-project, Carrier, or authorized user-library items before custom input. A search result is a choice, not engineering data.
- If custom input is necessary, include a concise `engineering_basis` and optional `provenance` in the same tool call. An exact inspected `library_ref` satisfies this source gate instead. Never invent a number, enum, geometry, weather station, or equipment choice.
- Every write is inline and domain-owned: immutable dry run, identical live request, mandatory native readback, then carry the returned revision. Never create an external model/spec file.
- Never route around an unavailable action through another manager. Candidate, guarded, engineer-only and deferred actions are intentionally absent.
- Never call the retired `hapatlas_space_inputs_manage`. HAP 5.1 direct Spaces, HAP 6.3 reusable Space Types, and HAP 6.3 Space Models are separate engineer-visible chapters.
- Invoke Carrier-native sizing through Reports. Never replace HAP calculations or tune inputs just to force a desired answer.
- Never invoke or simulate HAP Save. Report `pending_user_save` and ask the engineer to review and Save.
- Stop all writes on `HAP_SESSION_TAINTED`; tell the engineer to close without saving and reopen.

## Contract and identity

The only public aggregate contract is `ProjectSpec` with `schema_version: "1.0"`. Normal work uses one inline typed object such as `schedule`, `wall`, `system`, or `chiller`. A collection appearing in the aggregate contract is not proof that its mutation chapter is callable; use the generated action inventory and adapter capabilities. Pre-Alpha contract revisions are unsupported.

Use `hapatlas_contract_get action=index document=index` to discover contracts. Read `action-gates`, the relevant workflow document, and adapter capabilities before an unfamiliar action.

Human titles use **HAPAtlas**. Lowercase `hapatlas_*` names are stable protocol IDs.

## Professional sequence

Use only chapters/actions returned as Available for the selected adapter:

1. Project Scout: summary, exact session, project baseline, workflow progress.
2. HAP 5.1 Project > Properties when applicable.
3. View > Preferences > Project; a standards migration requires preview and explicit engineer confirmation.
4. Weather: inspect the visible Design Parameters, exact station selection, then explicit overrides.
5. Libraries: list/verify trusted sources, search, inspect, compare.
6. Project Libraries in sidebar order: Schedules, Walls, Roofs, Windows, Doors, Shades, then required Chillers/Boilers and version-correct heat-rejection definitions.
7. HAP 5.1 direct Spaces when their exact action is advertised; HAP 6.3 reusable Space Types only after their separate definition actions are promoted.
8. Space Model/zoning for HAP 6.3; later direct Space tabs/surfaces for HAP 5.1 only through separately promoted actions.
9. Systems and controls.
10. Plants and exact System connections.
11. HAP 6.3 Alternatives when applicable.
12. Input audit, Carrier-native design sizing, report export, engineer review and Save.

HAP 6.x visual floor-plan/3D work is engineer-only. Do not interpret PDF/image underlays, author visual geometry, or import/repair BIM/gbXML.

Read [workflow-manual.md](references/workflow-manual.md) for the chapter sequence, [generated-tool-inventory.md](references/generated-tool-inventory.md) for the executable tool/action/path table, [tool-catalog.md](references/tool-catalog.md) for usage detail, [action-gates.md](references/action-gates.md) for dynamic gates, and [versions-and-capabilities.md](references/versions-and-capabilities.md) for exact adapter boundaries. Read [space-workflow.md](references/space-workflow.md) before creating/editing a HAP 5.1 Space or reasoning about HAP 6.3 Space Types.

## Library discipline

Within `hapatlas_library_manage`:

- `sources.list/register/verify/unregister` controls only HAPAtlas authorization of exact sources;
- `items.search/inspect/compare` resolves exact engineering items;
- `documentation.search/inspect` reads installed version-matched Carrier help and is never importable.

Resolution is exact identity/digest first, then unique exact normalized name and structured filters. Never auto-select a fuzzy/BM25 or distance-ranked hit. On `LIBRARY_SOURCE_CHANGED`, re-verify with the engineer; never accept a digest silently.

Keep native meanings version-correct. Examples: HAP 6.x Space Type is not HAP 5.1 Space Usage; HAP 6.3 Window SHGC is not HAP 5.1 native Shade Coefficient; HAP 5.1 Cooling Towers and HAP 6.3 Heat Rejection are distinct visible chapters.

Read [libraries-and-provenance.md](references/libraries-and-provenance.md) before import and [input-domains.md](references/input-domains.md) before cross-version work.

## Calculation, reports and diagnosis

Use `hapatlas_reports_manage`:

- `catalog` lists accepted report/calculation capabilities;
- `input.export` exports native input reports without sizing;
- `design.calculate` starts native sizing;
- `job.status/wait/cancel` controls its job;
- `design.export-current` exports current structured results;
- `design.calculate-and-export` performs both with revision-locked finalization.

Before sizing, require a complete input audit and resolve broken references, missing assignments, stale dependencies and blocking outliers. After sizing, verify native result identity/state before export.

For unexpected results, follow [engineering-diagnostics.md](references/engineering-diagnostics.md): establish input parity first, then trace Space → Zone → System coil/fan/OA → Plant. Never call a difference an engine-version effect while required input evidence differs or coverage is incomplete.

## Recovery and support

All errors must include a stable code, recovery and diagnostic ID, plus exact blocked-action/readback workflow context wherever public `ToolResult` can represent it. Manual close-without-save, package repair, Space-editor context fallback, and Building Floor Plan work remain named engineer actions rather than invented callable tools. Correct only the named problem, re-scout after revision changes, and never blindly replay a write after a broker/transport or terminal-job failure.

HAPAtlas silently refreshes a project/session-scoped `.hapatlasdiag` package after meaningful work. If support is needed, ask the engineer only for the relevant package under:

`%LOCALAPPDATA%\HAPAtlas\Support\Sessions\`

Do not ask for project files, payloads, Carrier binaries/data, or terminal logs unless a maintainer separately requests them. Read [errors-and-recovery.md](references/errors-and-recovery.md).
