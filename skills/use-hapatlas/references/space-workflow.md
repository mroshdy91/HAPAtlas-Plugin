# Spaces and Space Types workflow

Read this before direct Space work or Space-Type reasoning. The installed exact-build action inventory remains authoritative; never substitute an unadvertised action through another manager.

## HAP 5.1: Spaces > Space Properties > General

1. Scout `summary`, select the exact HAP 5.1 session, establish `project-baseline`, then Scout `spaces`.
2. Choose exactly one action:
   - `general.create`: one new inline `space`, no `hap_id`;
   - `general.edit-existing`: one inline `space` with the exact current native `hap_id` from Scout.
3. Supply explicit `units`, `external_key`, a 1-to-24-character `name`, positive `floor_area`, positive `average_ceiling_height`, optional positive `building_weight`, and an engineering basis/provenance. HAP 5.1 truncates longer Space names, so HAPAtlas rejects them before native dispatch.
4. Immutable dry run, identical live request, then Scout `spaces` again at the returned revision.
5. Verify native ID/name/area/height/weight, unchanged loads and surfaces, affected serving-System/Plant result staleness only, and pending user Save.

Do not add Building, Space Model, Level, polygon, zone, Space Type, usage, load, Schedule, ventilation, infiltration, or surface fields. The General action owns none of them. A same-name item is not an edit target; edit requires the exact ID. HAPAtlas never invokes Save.

General create and exact-ID edit are Available. IP/SI readback, serving-System/Plant-only result invalidation, revision-locked native Undo with exact pre-transaction result-signature restoration, Carrier recalculation, structured JSON, diagnostics, engineer UI, native Space Input Data report, user Save/close-reopen persistence, and client-neutral constrained-agent replay passed.

## HAP 5.1: Spaces > Space Properties > Internals

Scout the exact Space and existing Fractional Schedule identities first. Choose exactly one action and send only its owned visible group:

- `internals.people.edit-existing`: occupancy basis/value, Carrier activity and Schedule; sensible/latent heat are accepted only with `USER_DEFINED` activity.
- `internals.overhead-lighting.edit-existing`: power basis/value, fixture type, ballast multiplier and Schedule.
- `internals.task-lighting.edit-existing`: power basis/value and Schedule.
- `internals.electrical-equipment.edit-existing`: power basis/value and Schedule.
- `internals.miscellaneous-loads.edit-existing`: sensible and latent heat with their independent optional Schedules.

Every action requires the exact current `hap_id`, immutable dry run, identical live request, independent native readback, and proof that all other Internals and every Space surface group are unchanged. A nonzero scheduled load must resolve one exact current-project Fractional Schedule; Spaces never edits the Schedule definition. Re-run `input-audit` after every changed revision before the next dependent action. Only serving Systems and connected Plants may become stale.

Do not add Space Usage/OA, infiltration/direct exhaust, Walls/Windows/Doors,
Roofs/Skylights, Floors or Partitions to an Internals payload. When the installed
inventory advertises the corresponding action, each is a separate exact-tab
activity and still requires its own dry run and native readback.

## HAP 5.1: Usage/OA, Infiltration and surface tabs

These six actions are Available after exact-build native readback, scope, sizing,
Undo, user Save/reopen and native input/design-report acceptance.

- `usage-and-outdoor-air.edit-existing`: select one exact digest-bound installed
  `space-usage` matching Project Preferences, or supply both explicit
  User-Defined OA requirements. Never treat this as a HAP 6.x Space Type.
- `infiltration.edit-existing`: submit Cooling, Heating and Energy Analysis
  bases/values, fan occurrence and Direct Exhaust as one complete tab.
- `walls-windows-doors.edit-slot`: edit or clear one exact exposure slot using
  explicit orientation/area basis and exact reusable definition identities.
- `roofs-skylights.edit-slot`: edit or clear one exact roof slot using explicit
  orientation/slope/area basis and exact Roof/Skylight identities.
- `floors.edit-existing`: select exactly one visible Floor branch and supply
  only the conditional fields shown for that branch.
- `partitions.edit-slot`: edit or clear one of two exact ceiling/wall slots with
  its visible area, U-value and four temperatures.

Never combine these actions, edit a reusable definition through Spaces, or use
the retired shared Space Inputs alias. After every live call, Scout the same
Space/input audit and carry forward the returned revision.

Before calculation, compare each edition-specific System ventilation-sizing
method with the ASHRAE 62.1 Space Usage/OA edition of every assigned Space.
`sum_space_requirements` consumes the visible Space OA inputs and does not
require one shared edition. Any exact mismatch returns
`STANDARDS_DEPENDENCY_MISMATCH`; do not retry calculation or change a number to
force a result. Align the System and Space through their matching workflow
chapters, or ask the engineer to use **View > Preferences > Project** and press
OK so HAP 5.1 performs its native populated dependency update, then re-scout
Project Baseline, Systems, Spaces and Input Audit.

## HAP 6.3: separate chapters

HAP 6.3 direct visual Space geometry is engineer-authored, so `hapatlas_spaces_manage` is not applicable.

- `hapatlas_space_types_manage` will own reusable Project Libraries > Space Types definition Save.
- `apply-to-all-space-models` is a separate broad propagation activity because it can reset copied row values and stale results.
- `hapatlas_space_model_manage` owns separately promoted nonvisual Space Model assignment/zoning activities.

Space Type definition create/edit remains Candidate and Apply to All remains guarded. Never use the retired `hapatlas_space_inputs_manage`, a whole-model writer, or another domain tool as a substitute.
