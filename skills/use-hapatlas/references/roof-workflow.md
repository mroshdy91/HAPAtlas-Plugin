# Roof workflow

Roofs are a separate Project Libraries chapter in both supported HAP versions. The public workflow is deliberately one reusable Roof definition at a time:

1. Scout the selected session/model and retain its current revision.
2. Search `category: "roof"`; inspect the exact returned URI before import.
3. Call `hapatlas_roofs_manage` with one action and one inline `roof` whose `kind` is exactly `roof`:
   - `create-custom`: unique name, no `hap_id` or `library_ref`, and complete typed visible assembly inputs.
   - `edit-existing`: exact current `hap_id`, no `library_ref`, and only the intended visible Roof fields.
   - `import-library`: exact inspected `category: roof` `library_ref`, no `hap_id`, and no custom overlay.
4. Dry-run, repeat the unchanged action live, then perform the returned mandatory Roof readback and carry the new revision.

Public `layers` are always ordered **exterior-to-interior**, even though HAP 5.1 stores its fixed native material slots in the opposite direction. A custom direct layer uses visible thickness, density, specific heat, and thermal resistance. Do not submit conductivity as a Roof-form input. `expected_u_value` is a readback assertion against Carrier's derived native assembly; HAPAtlas never tunes layers to force it.

Adapter boundary:

- HAP 5.1: outside surface color/absorptivity, inside/outside films, and up to eight material layers. Individual material-library references are guarded; import a complete exact Roof definition instead.
- HAP 6.3: outside solar and inside long-wave surface properties, films, and variable ordered layers. Exact installed material references may be used only when the current contract advertises them.

This chapter owns only reusable Roof definitions. It does not create roof area, slope, exposure, orientation, skylights, visual geometry, or assignments to Spaces/Space Models. Editing an assigned Roof, duplicate, delete, native preset-dropdown selection, and any Roof assignment remain guarded until their separate consumer-scoped live gates pass. Current-project items are reused or adopted; they are not imported.

Both exact-build adapters passed native readback, engineer UI, result isolation, recalculation, result/report evidence, user Save/close/reopen, exact definition/result persistence, and clean audits. HAP 5.1 also verifies Carrier's live `ProjectDirty`/`AppDirty` notification without invoking Save. The three unassigned-definition actions are **Available**. Any unavailable action or field remains a stop condition, not permission to route a Roof through Wall, Space, or another manager.
