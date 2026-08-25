# Project Libraries > Chillers workflow

Use this chapter only for one reusable Chiller definition. Read current truth with `hapatlas_project_scout(action: "plants")`, discover exact candidates with `hapatlas_library_manage(category: "chiller")`, and retrieve `chiller-workflow-v1` plus `action-gates` before mutation.

`create-default` and exact-ID unassigned `edit-existing` are **Available** for the accepted air-cooled branch on both supported builds. They are also **Available** for water-cooled centrifugal on HAP 5.1. HAP 6.3 does not include water-cooled centrifugal in its adapter-specific accepted-type map, and `import-library` is not callable. Supported semantic types are:

- `function: "chilled_water_only"`
- `chiller_type: "air_cooled_packaged_scroll"`
- `chiller_type: "water_cooled_centrifugal"` — Available on HAP 5.1; absent/non-callable on HAP 6.3

## Actions

| Action | Identity shape | Meaning |
|---|---|---|
| `create-default` — Available | no `hap_id` or `library_ref` | Start from Carrier's exact native default for the selected type, then apply only supplied promoted visible fields. |
| `edit-existing` — Available | one exact current `hap_id`; no `library_ref` | Edit one unassigned Chiller without changing its type. |
| `import-library` — Candidate | one exact inspected `category: chiller` `library_ref`; no `hap_id` | Import/reuse the complete native item unchanged. No engineering overlay is permitted. |

Every call also requires the exact `session_id`, current `expected_revision`, `units`, `dry_run`, and one inline `chiller`. Dry-run first, apply only against the unchanged revision, then perform the returned mandatory `plants` readback.

On HAP 5.1, live Save is gated by the exact typed live `_COM_ProjectData` owner held by the version-locked main form. HAPAtlas validates its HAPDataHandler vtable, installed module, selected working path, prefix, index database, and Chiller backing file before use; the untouched heat-rejection checkpoint uses exact native `TowerIndex`. `BRIDGE_CONTEXT_UNAVAILABLE` means that owner could not be proven; restart/reopen/attach and reinspect once. `SESSION_CHANGED` means the owner no longer matches the selected project. `NATIVE_CHILLER_SAVE_FAILED` means Carrier rejected the native Save and HAPAtlas rolled back; do not calculate, Save, or retry the write, and preserve the diagnostic/support logs.

## Promoted create/edit fields

The Chiller may include `external_key`, `name`, optional `notes`, the fixed function and one type above, and `design_inputs` containing:

- `capacity_mode: "autosize" | "fixed"`; fixed requires `full_load_capacity`;
- `leaving_chilled_water_temperature`;
- `entering_source_temperature` — air-source design temperature for air-cooled or full-load ECWT for water-cooled;
- `chilled_water_flow: { basis: "total" | "per_capacity" | "delta_t", value: ... }`;
- `condenser_flow: { basis: "total" | "per_capacity" | "delta_t", value: ... }` — water-cooled only;
- `full_load_power: { basis: "total" | "per_capacity", value: ... }`;
- `average_operating_loss_percent`;
- `minimum_entering_source_temperature`;
- `minimum_load_percent`;
- `hot_gas_bypass` — air-cooled only.

Unit-neutral values follow the call's `units`. In IP, capacity is tons, temperatures are °F, total flow is gpm, per-capacity flow is gpm/ton, and `delta_t` is °F. In SI, capacity is kW cooling, temperatures are °C, total flow is L/s, per-capacity flow is L/s per kW cooling, and `delta_t` is K. Power is kW total or kW per ton/kW cooling according to units and basis. HAPAtlas converts once at the adapter boundary and reads back semantic values.

Omitted create/edit fields preserve the native default/current value. Do not invent an omitted engineering value or copy a similarly named Chiller's values without an exact inspected basis.

## Guarded boundaries

Stop without mutation for:

- another Chiller function or type;
- condenser flow on an air-cooled type or hot-gas bypass on the water-cooled type;
- heat recovery;
- native performance maps, Chiller Template selection, or performance-data import;
- type conversion;
- edit of an assigned Chiller;
- duplicate or delete;
- Plant composition, equipment assignment, loops, or System connections.

These are separate visible actions or dependency-sensitive workflows and require independent acceptance. Never route them through `hapatlas_plants_manage`, a generic whole-model shortcut, a Boiler, or a heat-rejection category.

## Verification and result impact

Create/import or an edit of an unassigned definition must read back the exact native ID, name, fixed function/type, every submitted Design Input, and exact flow basis while the Chiller-only scope checkpoint proves no Plant, System, Space, Alternative/Building, or result changed. Carrier's native performance content is preserved rather than authored by the agent. Assignment belongs to the Plant chapter. The retained HAP 5.1 water-cooled Chiller passed engineer UI, exact Plant/Cooling-Tower/VAV assignment, native sizing and structured results, user Save/close-reopen, exact result persistence, and clean native System/Plant reports. Other water-cooled compositions and HAP 6.3 remain independently guarded/Candidate.

The engineer alone reviews HAP and clicks Save. A successful HAPAtlas definition transaction may return `pending_user_save: true`; read-only search, audit, and report calls must preserve that state.

Undo remains an explicit recovery activity, not a Chiller-definition action. Use the exact transaction and unchanged revision. HAP 5.1 captures an exact edit inverse or deletes a just-created unassigned Chiller through Carrier's live `CHL_Chiller` owner, then verifies the complete Chiller/Plant/heat-rejection/System-result checkpoint and prior native Save state. It never copies recovery MDB/DAT files over the active project. `HAP_SESSION_TAINTED` requires immediate close-without-Save and reopen; do not retry or Save that process.

Before a Candidate Chiller write after installing an update, broker health must report the current exact implementation and the selected HAP process must have loaded the current worker/bridge protocol. `BROKER_UPGRADE_PENDING` is a package gate: restart the MCP client and close/reopen HAP; never continue through an older broker merely because it answers the same named pipe.
