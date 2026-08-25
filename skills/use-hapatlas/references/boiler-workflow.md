# Project Libraries > Boilers workflow

Use this chapter only for one reusable Boiler definition. Read current truth with
`hapatlas_project_scout(action: "plants", filter: {detail: "engineering"})`,
discover an exact import candidate with
`hapatlas_library_manage(category: "boiler")`, and retrieve
`boiler-workflow-v1` plus `action-gates` before mutation.

Native-default create and exact-ID unassigned edit are **Available** on HAP 5.1
build `5.01.0014` and HAP 6.3 build `6.03.1378`. Exact-library import remains
**Candidate** and requires an explicit development acceptance gate.

## Actions

| Action | Identity shape | Meaning |
|---|---|---|
| `create-default` | no `hap_id` or `library_ref` | Start from Carrier's exact native object, then explicitly apply the submitted Hot Water type, fuel, user-defined curve, and supplied promoted visible fields. This is not an unchanged Carrier default. |
| `edit-existing` | one exact current unassigned `hap_id`; no `library_ref` | Edit one Boiler, including its visible fuel selection, without converting its native Boiler type or part-load model. A missing target never becomes create. |
| `import-library` | one exact inspected `category: boiler` `library_ref`; no `hap_id` | Import/reuse the complete native item unchanged. No notes, type, fuel, model, or design-input overlay is permitted. |

Every call requires `session_id`, current `expected_revision`, `units`, `dry_run`,
one action, and exactly one inline `boiler`. Dry-run first; repeat an Available
create/edit action unchanged against the same revision, or use Candidate import
only during its explicit development gate. Then perform the returned mandatory
engineering `plants` readback.

## Available create/edit fields

One Boiler contains:

- `kind: "boiler"`, `external_key`, optional `hap_id`, and `name`;
- `boiler_type: "hot_water"`;
- `fuel_type: "natural_gas" | "fuel_oil" | "propane" |
  "electric_resistance"`;
- `part_load_model: "user_defined_curve"`;
- optional `design_inputs`:
  - `capacity_mode: "autosize" | "fixed"`; fixed requires `gross_output`;
  - `design_hot_water_supply_temperature`;
  - `hot_water_flow: { basis: "total" | "delta_t", value: ... }`;
  - `overall_efficiency_percent`;
  - `accessory_power`;
  - `part_load_efficiencies`, with exact `load_percent` rows 90, 80, 70, 60,
    50, 40, 30, 20, 10, and 0 when the table is supplied. Each row carries
    `efficiency_percent`; the full-load 100-percent value is
    `overall_efficiency_percent`.

IP means Gross Output in MBH, direct flow in gpm, supply temperature in °F, and
`delta_t` in °F. SI means Gross Output in kW, direct flow in L/s, supply
temperature in °C, and `delta_t` in K. Accessory power is kW in both. HAPAtlas
converts once at the adapter boundary and returns semantic engineering units.

Omitted create/edit fields preserve the exact native default/current value and
must be independently read back. Never invent an omitted engineering value.

## Required readback and scope

The mandatory readback must prove the exact native ID/name, unassigned state,
Hot Water type, fuel, capacity mode/value, design HWST, flow value and basis,
overall efficiency, accessory kW, and every submitted part-load row. Boiler-only
scope must prove no System, Plant, Space, Alternative/Building, neighboring
equipment, or current result changed. A definition-only create/import must not
stale an unrelated result.

On HAP 5.1, native Plant equipment category `20` identifies the Boiler library;
it is not the selected Boiler ID. The selected project ID and full resolved name
must be verified separately. A blank or `<none>` equipment name is a broken
reference and blocks connection, calculation, and Save.

An exact Boiler library candidate must inspect as a Boiler-shaped engineering
record with native Boiler identity, type, fuel, and part-load model. Reject a
Plant-shaped candidate even when its name contains “Boiler”; search ranking or a
generic Plant `items` row is never category proof. The standalone
create/edit/undo/UI/user-Save/reopen gates passed on both adapters, so
`create-default` and exact-ID unassigned `edit-existing` are Available. Exact
import remains Candidate. Existing accepted Hot Water Plants may still be inspected, calculated, and reported on both supported builds.

## Boundary with Hot Water Plants

This tool defines the reusable Boiler only. New Plant composition and System connection are temporarily non-callable. After Boiler readback, inspect `adapter-capabilities.callable_actions`; if `hapatlas_plants_manage` is absent, stop. Do not move Plant configuration into the Boiler or System payload. An already existing accepted Hot Water Plant may be re-scouted, audited, calculated, and reported.

The first portfolio is one autosized Boiler at a 100-percent sizing split, one
Hot Water Plant, explicit capacity oversizing, equal unloading, constant HWST,
fresh water, primary-only constant-speed distribution, explicit coil delta-T,
pipe loss and head-based pump inputs, no Service Hot Water, and one compatible
System with a hot-water coil. This exact portfolio passed calculation, report,
Save/reopen, and native result persistence on both supported adapters. Adjacent
Plant branches remain guarded and do not inherit that acceptance.

## Guarded boundaries

Stop without mutation for:

- Steam Boiler;
- constant-efficiency or native condensing/non-condensing part-load models;
- another performance table or curve branch;
- type conversion or edit of a Boiler referenced by a Plant;
- duplicate or delete;
- import overlay;
- Boiler quantity, sequencing, Plant controls, pumps, loop configuration, or
  System connection in this definition tool;
- HAP 6.3 Plant Notes until a typed independent readback is promoted;
- Service Hot Water, pasteurization, auxiliary heat, or mixed/multi-Boiler Plant;
- calculation/report claims before the complete compatible System/Plant gate.

Never route these through Chillers, Cooling Towers/Heat Rejection,
`hapatlas_plants_manage`, or any generic whole-model shortcut as a definition fallback.

## Promotion and Save boundary

Promotion requires create/readback, exact edit/undo, real exact import when a
source exists, target-only scope, compatible System and Hot Water Plant
composition, Carrier native air/Plant sizing, structured and native reports,
engineer UI review, user Save, close/reopen, exact definition/reference/result
persistence, and a clean complete audit on each exact adapter independently.

Native System/Plant sizing proves references and persisted calculation state; it
does not prove that Boiler fuel or part-load efficiency changes affect design
sizing. Those values principally affect annual energy, which is outside this
release.

The engineer alone reviews HAP and clicks Save. HAPAtlas never invokes Save.
