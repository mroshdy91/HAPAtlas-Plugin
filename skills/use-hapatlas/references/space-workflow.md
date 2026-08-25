# Spaces and Space Types workflow

Read this before direct Space work or Space-Type reasoning. The installed action inventory remains authoritative; an acceptance-stage action is callable only when that exact package advertises it.

## HAP 5.1: Spaces > Space Properties > General

Before mutation, discover the runtime contracts with `hapatlas_contract_get`: read `space-workflow-v1`, `adapter-capabilities`, and `input-coverage` for the selected session/package. The generated client-neutral tool inventory lists `hapatlas_spaces_manage` with `general.create` and `general.edit-existing`; the live runtime contracts remain authoritative for the exact installed package and adapter.

1. Scout `summary`, select the exact HAP 5.1 session, establish `project-baseline`, then Scout `spaces`.
2. Choose exactly one action:
   - `general.create`: one new inline `space`, no `hap_id`;
   - `general.edit-existing`: one inline `space` with the exact current native `hap_id` from Scout.
3. Supply explicit `units`, `external_key`, a 1-to-24-character `name`, positive `floor_area`, positive `average_ceiling_height`, optional positive `building_weight`, required `engineering_basis`, and optional `provenance`. HAP 5.1 truncates longer Space names, so HAPAtlas rejects them before native dispatch.
4. Immutable dry run, identical live request, then Scout `spaces` again at the returned revision.
5. Verify native ID/name/area/height/weight, unchanged loads and surfaces, affected serving-System/Plant result staleness only, and pending user Save.

Do not add Building, Space Model, Level, polygon, zone, Space Type, usage, load, Schedule, ventilation, infiltration, or surface fields. The General action owns none of them. A same-name item is not an edit target; edit requires the exact ID. HAPAtlas never invokes Save.

This General slice is Available for HAP 5.1 in the client-neutral capability evidence at runtime commit `87d1656cc18e22263c1e2599a3969cf866014d43`. Exact-build create, IP/SI edit/readback, serving-System/Plant-only result invalidation, revision-locked native Undo with exact pre-transaction result-signature restoration, Carrier recalculation, structured JSON export, diagnostic reconstruction, engineer UI, native Space Input Data report, user Save/close-reopen persistence, and client-neutral constrained-agent semantic replay passed. Availability is determined by the generated inventory and installed runtime contracts, never by a Codex-, ZCode-, Claude-, or other client-specific gate. If an older immutable runtime package still reports the action as Candidate, fail closed until a package containing the promoted contract is installed.

## HAP 6.3: separate chapters

HAP 6.3 direct visual Space geometry is engineer-authored, so `hapatlas_spaces_manage` is not applicable.

- `hapatlas_space_types_manage` will own reusable Project Libraries > Space Types definition Save.
- `apply-to-all-space-models` is a separate broad propagation activity because it can reset copied row values and stale results.
- `hapatlas_space_model_manage` owns separately promoted nonvisual Space Model assignment/zoning activities.

Space Type definition create/edit remains Candidate and Apply to All remains guarded. Never use the retired `hapatlas_space_inputs_manage`, a whole-model writer, or another domain tool as a substitute.
