# Door workflow

Doors are one shared **Project Libraries > Doors** chapter, but HAP 5.1 and HAP 6.3 expose different engineer-visible definitions. `hapatlas_doors_manage` create, exact-ID unassigned edit, and exact-library import are Available on both exact builds.

## Shared sequence

1. Scout the exact session/model and retain the current revision.
2. Search `category: "door"`, then inspect the exact returned URI and every adapter-visible field. Never use the retired generic `opening-type` category.
3. Call `hapatlas_doors_manage` with one inline `door` whose `kind` is exactly `door`:
   - `create-custom`: unique name and complete adapter-visible fields; no `hap_id` or `library_ref`.
   - `edit-existing`: exact current unassigned `hap_id`; no `library_ref`.
   - `import-library`: exact inspected `category: "door"` `library_ref`; no `hap_id` and no custom overlay.
4. Dry-run first. Repeat the unchanged call live, execute its mandatory native Door readback, and carry the returned revision.

Every action manages one reusable, unassigned Door definition. It does not place an opening, set dimensions or quantity, select a host wall/edge/Space, assign a Door to a Space or Space Model, or author HAP 6.x graphical geometry.

## HAP 5.1 fields

HAP 5.1 has no visible Door Type selector. Composition follows absolute glass area versus gross area:

- `gross_area`: positive total reusable Door area; ft² for `units: "IP"` or m² for `units: "SI"`.
- `opaque_u_value`: visible Door U-value; Btu/(h·ft²·°F) in IP or W/(m²·K) in SI.
- `glass_area`: actual glass area in the same area units, from zero through `gross_area`.
- When `glass_area > 0`: `glass_u_value`, `glass_shade_coefficient` from `0.0–1.0`, and boolean `glass_shaded_all_day` are all required.
- When `glass_area = 0`: omit every glass-performance/shading field. Carrier may retain values behind the disabled glass controls; engineering inspection reports these under `inactive_glass_defaults` with `effective: false`. They are diagnostic evidence, not inputs or effective performance.

`glass_area = gross_area` represents a fully glazed Door. Native Shade Coefficient is not SHGC and HAPAtlas does not convert it. `AreaSpec`, width, and height are native calculator/support members, not separate public reusable-Door inputs.

## HAP 6.3 fields

HAP 6.3 requires one exact `door_type` and only the fields enabled by that visible form branch:

- `opaque`: `opaque_u_value` only.
- `glass`: `glass_u_value`, `glass_shgc`, and `glass_visible_transmittance`; omit opaque U and glass fraction.
- `opaque_with_lites`: `opaque_u_value`, `glass_u_value`, `glass_shgc`, `glass_visible_transmittance`, and `glass_fraction_percent` strictly greater than `0` and less than `100`.

`glass_shgc` and `glass_visible_transmittance` use `0.0–1.0`. `glass_fraction_percent` is the visible percentage on a `0–100` basis, not a decimal `0.0–1.0` fraction. HAP 6.3 reusable Door Assemblies have no gross area, glass area, width, or height; dimensions belong to Building openings.

## Verification and exclusions

Fresh readback must match identity/name and every enabled adapter-visible field. Import must preserve the exact native item, source digest, and provenance without a silent `(1)` duplicate. Create/import or an unassigned edit must leave consumers and design results unchanged; otherwise HAPAtlas rolls back with `DOMAIN_SCOPE_VIOLATION`.

Assigned edit, duplicate, delete, placement, quantity, host geometry, opening groups/tags, and assignment remain guarded. HAP 5.1 later assigns one Door type plus quantity through a separately promoted Space-surface action. HAP 6.3 graphical placement is engineer-only, and later Space Model assignment may reference an already accepted Door identity. Never route these actions through Window, Wall, the retired shared Space Inputs alias, a definition-only Space action, a retired envelope writer, or whole-model apply.

On `ACTION_PAYLOAD_MISMATCH`, keep the same Door action and remove only the named irrelevant/opposite-adapter field. On `INVALID_LIBRARY_REFERENCE`, search and inspect exact `category: "door"` again. On `NATIVE_INPUT_PERSISTENCE_FAILED`, do not calculate or Save; the transaction was rolled back, so preserve the diagnostic ID and reinspect the Door.
