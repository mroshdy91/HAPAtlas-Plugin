# Cooling Towers and Heat Rejection workflow

Use this reference for one unassigned reusable heat-rejection definition. The engineer-visible chapter is version-specific:

| Adapter | HAP chapter | HAPAtlas tool | Inline member |
|---|---|---|---|
| HAP 5.1 | Project Libraries > Cooling Towers | `hapatlas_cooling_towers_manage` | `cooling_tower` |
| HAP 6.3 | Project Libraries > Heat Rejection | `hapatlas_heat_rejection_manage` | `heat_rejection` |

The tools are not aliases. Calling the other version's chapter must return `DIFFERENT_ENGINEER_WORKFLOW`. On HAP 5.1, `cooling_tower` `create-default` and exact-ID unassigned `edit-existing` are **Available** after the complete Plant sizing/report/Save-reopen gate; Dry Cooler, Geo/Well/Surface Water, and exact import remain **Candidate**. All HAP 6.3 Heat Rejection branches/actions remain **Candidate**.

## Professional sequence

1. Scout the exact session with `hapatlas_project_scout(action: "plants", filter: {detail: "engineering"})` and retain its current revision.
2. Retrieve `cooling-tower-workflow-v1` for HAP 5.1 plus `adapter-capabilities` and `action-gates`. HAP 6.3 has no normal Heat Rejection workflow contract while every branch remains Candidate; stop instead of inventing a call.
3. HAP 5.1 Alpha accepts only `cooling_tower` create/edit; do not attempt import, Dry Cooler, or Geo/Well/Surface Water. HAP 6.3 Heat Rejection is Candidate evidence and has no callable manager.
4. For the accepted HAP 5.1 branch, call the manager with one inline definition, explicit `units`, the exact revision, and `dry_run: true`; repeat the unchanged action live only after the preview succeeds.
5. Re-scout `plants` and require the exact native ID, modeling method, every submitted active-branch field, target-only scope verification, and the returned mandatory readback before any Plant action.

## Identity actions

| Action | Required identity | Native meaning |
|---|---|---|
| `create-default` | no `hap_id` or `library_ref`; include `rejection_type` | Start from Carrier's exact native default, then overlay only supplied fields visible for that branch. |
| `edit-existing` | one exact current unassigned `hap_id`; include the unchanged `rejection_type` | Edit only that definition. A missing target never becomes create, and method conversion is guarded. |
| `import-library` | not callable in Alpha | Candidate evidence only; wait for its complete exact-build live acceptance gate. |

Every definition requires `external_key` and `name`. Do not invent values omitted from create/edit; Carrier's native default/current value remains in effect and must be read back.

## Conditional modeling branches

- `cooling_tower`: optional `water_flow`; design wet-bulb, range, and approach; full-load fan power; `fan_control` (`fan_cycling`, `water_bypass`, `two_speed_fan`, or `variable_speed_fan`); conditional fan electrical efficiency and two-speed low-speed airflow. Do not send dry-bulb, full-load airflow, or monthly source-water values.
- `dry_cooler`: Candidate evidence only; not callable in Alpha.
- `geo_well_surface_water`: Candidate evidence only; not callable in Alpha.

`water_flow.basis` is `total`, `per_capacity`, or `delta_t`. Airflow and fan-power bases are `total` or `per_capacity`. Values follow the call's IP/SI contract; never copy numbers between unit systems or infer an omitted basis.

## Boundary with Plants

This chapter defines the reusable equipment item only. New Plant composition and System connection are currently non-callable pending exact pre-native portfolio resolution. Existing accepted Plants remain inspectable/calculable/reportable, but no definition tool may be used to bypass the missing Plant action.

Undo remains an explicit recovery activity, not a definition action. Use the exact transaction and unchanged revision. HAP 5.1 replays an exact edit or deletes a just-created/imported unassigned item through Carrier's live `_TWR_CoolingTower` COM owner, then verifies the complete Cooling Tower/System/Plant/result checkpoint; it does not overwrite the active MDB/DAT files. If undo returns `HAP_SESSION_TAINTED`, stop all writes and ask the engineer to close without saving and reopen the affected HAP 5.1 project.

An unassigned definition-only action must not invalidate existing results. Assigned edit remains guarded because targeted consumer/result invalidation is not yet accepted.

## Fail-closed recovery

- `ACTION_PAYLOAD_MISMATCH`: keep the same version-specific tool/action, remove inactive-branch or import-overlay fields, and repeat its dry run.
- `DIFFERENT_ENGINEER_WORKFLOW`: keep the selected session and switch only to the chapter named for that adapter; do not transplant the wrapper name.
- `NATIVE_COOLING_TOWER_SAVE_FAILED` or `NATIVE_INPUT_PERSISTENCE_FAILED`: the transaction was rolled back. Do not calculate, Save, or retry blindly; re-scout `plants` and preserve the diagnostic/support logs.
- `LIVE_OPERATION_NOT_PROVEN`: stop on an unopened Candidate gate, assigned edit, method conversion, duplicate, delete, assignment, or another hidden/native-only field. Never bypass through another manager or a generic whole-model shortcut.
