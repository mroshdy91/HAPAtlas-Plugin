# Wall workflow

Walls are a separate Project Libraries chapter in both supported HAP versions. The public workflow is deliberately one Wall at a time:

1. Scout the selected session/model and retain its current revision.
2. Search `category: "wall"`; inspect the exact returned URI before import.
3. Call `hapatlas_walls_manage` with one action and one inline `wall`:
   - `create-custom`: unique name, no `hap_id` or `library_ref`, and complete typed assembly inputs.
   - `edit-existing`: exact current `hap_id`, no `library_ref`, and only the intended visible Wall fields.
   - `import-library`: exact inspected `category: wall` `library_ref`, no `hap_id`, and no custom overlay.
4. Dry-run, repeat the unchanged action live, then perform the returned mandatory Wall readback and carry the new revision.

Adapter boundary:

- HAP 5.1: exterior above-grade Wall only, using its native inside film, up to eight ordered material layers, outside film, and outside surface color/absorptivity. Interior, below-grade, and inside-surface controls are unavailable.
- HAP 6.3: exterior above-grade and interior Wall assemblies, with the typed surface/film/layer fields advertised by `wall-workflow-v1`. Below-grade remains unavailable.

`expected_u_value` is an assertion against the derived native assembly, not a value HAPAtlas uses to tune the layers. Library import must use exact identity/digest and cannot accept a generic construction, Roof, Floor, or Ceiling reference.

This chapter owns only reusable Wall definitions. It does not create geometry, assign a Wall to a Space/Space Model, or reapply assignments. Editing a Wall already assigned to a consumer remains guarded until consumer-scoped invalidation passes its live gate. Duplicate and delete are also guarded.

The promoted unassigned actions are Available on both supported adapters. Assigned edit remains guarded. Roofs, Windows, Doors, and exterior Shades each have separate sidebar-aligned managers; unassigned Shade definition actions are Available. Floor, Ceiling, placement, and assignment have no public fallback. Never route one chapter through another.
