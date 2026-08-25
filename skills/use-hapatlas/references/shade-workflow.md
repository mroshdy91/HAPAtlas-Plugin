# Exterior Shade workflow

Exterior Shades are one shared **Project Libraries > Shades** definition chapter on HAP 5.1 and HAP 6.3. Unassigned `create-custom`, exact-ID `edit-existing`, and exact `category: shade` `import-library` are Available on both supported exact builds.

## Required sequence

1. Scout `action: model` with engineering detail and retain the exact session/revision.
2. Search `category: shade`, then inspect the exact returned URI. Never use `category: window-internal-shade`.
3. Call `hapatlas_shades_manage` with exactly one inline `shade` whose `kind` is `shade`:
   - `create-custom`: no `hap_id` or `library_ref`; submit all eleven dimensions.
   - `edit-existing`: exact current unassigned `hap_id`, no `library_ref`; submit all eleven dimensions.
   - `import-library`: exact inspected `category: shade` `library_ref`, no `hap_id`, and no geometry overlay.
4. Dry-run first. For a live success, perform the returned model readback and input audit, then carry forward the new revision.
5. Only the engineer saves HAP.

## Complete visible input

Custom create/edit requires every field below. IP uses feet; SI uses metres. Both exact HAP adapters store these form values natively in inches; HAPAtlas performs the conversion once and returns engineering feet from readback. Zero is explicit and means that component is absent:

- `reveal_depth`
- `overhang_projection`
- `overhang_height_above_opening`
- `overhang_extension_right`
- `overhang_extension_left`
- `right_fin_distance_from_opening`
- `right_fin_projection`
- `right_fin_height_above_opening`
- `left_fin_distance_from_opening`
- `left_fin_projection`
- `left_fin_height_above_opening`

HAP 5.1's exact `ShadeIndex.szName` storage is limited to 30 characters. HAPAtlas rejects a longer HAP 5.1 target name before native dispatch and guides the agent to shorten only `shade.name`. HAP 6.3 is not restricted by this legacy 30-character boundary.

Do not invent omitted values. If the engineer/source did not define a component, submit zero only when that is the intended visible form value.

## Boundaries

- A Detailed Window `window-internal-shade` is a selectable Window component, not this exterior geometry.
- HAP 6.x graphical shading surfaces belong to visual Building geometry and are engineer-only.
- Shade placement/assignment, assigned edit, duplicate, and delete remain separate guarded actions; promotion of the reusable definition does not promote a consumer workflow.
- An unassigned definition create/import/edit must not change Space/Space Model consumers or design results.

On `ACTION_PAYLOAD_MISMATCH`, keep the same action and correct only the named identity/field problem. On `INVALID_LIBRARY_REFERENCE`, search and inspect exact `category: shade` again. On `NATIVE_INPUT_PERSISTENCE_FAILED` or `DOMAIN_SCOPE_VIOLATION`, do not calculate or Save; preserve the diagnostic ID and reinspect because HAPAtlas rolled the transaction back.
