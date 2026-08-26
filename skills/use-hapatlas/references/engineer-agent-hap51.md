# HAP 5.x engineer-to-agent workflow

Use this as the compact routing guide. Retrieve `hapatlas_contract_get(action: "read-static", document: "engineer-agent-map-hap51")` for the full field/action/dependency/coverage matrix and `document: "action-gates"` for the executable tool/action gates.

## Native order

1. Scout `action: summary`, explicitly select the project, then scout `action: project-baseline`.
2. Verify HAP 5.1 Project > Properties with `preview-change`/`apply-change`, then View > Preferences > Project with `verify-match` or the preview/confirmed migration actions; keep General/program preferences separate. A saved project-name change requires user Save As. Matching Project Preferences are no-ops; on a pristine project, a supported ASHRAE edition difference requires dry-run impact review and explicit engineer confirmation. A populated project returns guided native-dialog recovery.
3. Resolve Phase 1 design/simulation weather only after its separate workflow is promoted; do not route it through the whole-model tool.
4. Search and inspect current-project, Carrier, or registered template libraries.
5. Use `hapatlas_schedules_manage` for one Schedule at a time. Scout `spaces`, then use exactly one advertised `hapatlas_spaces_manage` action for General, one Internals group, Space Usage/OA, Infiltration, one Wall/Roof slot, Floor, or one Partition slot. Carry the returned revision and read back the exact tab before the next action.
6. Use `hapatlas_walls_manage` for one exterior above-grade Wall definition at a time. Exact import uses `category: wall`.
7. Use the Available `hapatlas_roofs_manage` for one reusable Roof definition at a time. Exact import uses `category: roof`; public layers remain exterior-to-interior even though the adapter reverses them into HAP 5.1's fixed native slots.
8. Use `hapatlas_windows_manage` for one unassigned Window definition at a time. Simple actions and Detailed create/edit are Available; Detailed complete-library import remains Candidate. Detailed work requires exact inspected frame, conditional gap, internal shade, and one-to-three outer-to-inner glazing items; Carrier derives U/native SC and HAPAtlas only checks an optional expected-performance assertion. Exact complete-Window import uses `category: window`. Do not substitute SHGC/VT or switch methods through edit.
9. Use the Available `hapatlas_doors_manage` for one unassigned reusable Door definition. Search/import uses `category: door`; require gross/absolute-glass areas plus every applicable active native thermal/shading field, and ignore zero-glass inactive defaults.
10. Use Available `hapatlas_shades_manage` for one unassigned reusable exterior Shade definition. Search/import uses exact `category: shade`; custom/edit requires all eleven reveal, overhang, and left/right fin dimensions. Do not use a Window internal-shade component or perform placement/assignment here.
11. Use the Space-owned exact slot actions for HAP 5.x surface orientation/area and opening/Shade quantity/reference assignments. Definition managers remain reusable-definition-only.
12. Use the matching system action for system type, zones, terminals/controls, sizing inputs, or source connection.
13. Define reusable central-equipment items only through callable dedicated managers: Chillers use `hapatlas_chillers_manage`; HAP 5.1 Cooling Towers use `hapatlas_cooling_towers_manage` and never the HAP 6.3 Heat Rejection manager; Hot Water Boilers use `hapatlas_boilers_manage`. Cooling Tower `create-default`/`edit-existing` and narrow Hot Water Boiler create/edit are Available. Dry Cooler, Geo/Well/Surface Water, definition imports, unlisted Boiler branches, and new Plant composition remain Candidate and are not callable. Existing accepted Plants can still be scouted, calculated, and reported. Do not call or invent `plants.upsert` or `systems.connect` while they are absent from adapter capabilities.
14. HAP 5.x Buildings are annual-energy containers and are deferred; `hap51-building.upsert` fails closed and must not be treated as physical geometry or a design-sizing prerequisite.
15. Run complete input audit, native design sizing, input/result export, engineer review, user Save, close/reopen, and verification.

For every professional action: dry run → live manage → mandatory native readback → carry forward the returned revision. Do not create an external whole-model file or attempt a generic whole-model shortcut.

HAP 5.1 routing is exact: use the dedicated Walls, Roofs, Windows, Doors, Shades, Chillers, Cooling Towers, and Boilers managers only for their one inline workflow definition. HAP 5.1 Door composition follows absolute `glass_area` versus `gross_area` and preserves native Shade Coefficient. Cooling Tower work accepts only inline `rejection_type: cooling_tower`; HAP 6.3 Heat Rejection is not an alias. Boiler create/edit are Available and import is Candidate. Exact Boiler readback is evidence for a future Plant-composition action, but new Plant composition is currently non-callable. Placement/quantity/assignment, Floor, ceiling Partition mutation, and Plant composition remain separate.

For direct HAP 5.1 Space input, submit one inline `space` and only the group owned by the selected action. General create omits `hap_id`; every edit uses the exact current native `hap_id`. General accepts name/area/height/optional weight. Internals references exact Fractional Schedules. Standards Usage references one exact installed `space-usage`; User-Defined OA is explicit. Surface slots reference exact existing definitions. Never manufacture a Building, Space Model, Level, polygon, dependency or hidden native field to satisfy object shape. Require immutable dry run, identical live request, Scout/readback proof and unchanged unowned groups. HAP 6.3 direct Space mutation is not applicable.

For a same-build oracle recreation, inspect a registered source project read-only and rebuild every Space and System through inline domain calls. Do not create external ProjectSpec scaffolding and do not use complete native Space/System cloning as recreation evidence.

## Library category lookup

Use the exact library categories documented in `libraries-and-provenance.md`. Available Chiller native-default create/exact-ID unassigned edit and Candidate import belong only to `hapatlas_chillers_manage`. HAP 5.1 Cooling Tower create/edit is Available only for `rejection_type: cooling_tower`; its other branches/import remain non-callable Candidate evidence. Boiler create/edit is Available and import remains Candidate. Plant management consumes verified identities and cannot write any reusable definition. A missing exact detail is a stop condition, not permission to guess a neighboring category.

## Engineer actions HAPAtlas must preserve

The workflow is more than scalar creation. Treat these as native actions within the owning domain: select/reuse, inspect, import dependencies, create, edit, duplicate, delete safely, replace references, rotate legacy Spaces, assign/unassign, calculate, and export category input reports.

Shared schedules, constructions, Spaces, Systems, Plants, and Buildings form a reference graph. Before changing a shared object, inspect consumers and result state. Report affected consumers and invalidated calculations after the change. Never allow HAP's native same-name `(1)` import behavior to become a silent duplicate.

## Important HAP 5.x distinctions

- Project standards affect downstream defaults and are not ordinary metadata.
- Design weather drives load/design sizing; simulation weather and annual calendar drive energy simulation.
- HAP 5.x physical geometry is held by Spaces and their surfaces; a Building is an energy-analysis case.
- HAP 5.1 Floor and Ceiling engineering inputs are not missing: Floor is `hapatlas_spaces_manage(action=floors.edit-existing)`, while a ceiling load is `partitions.edit-slot` with `type=ceiling`. Neither is a separate HAP 5.1 Project Library object.
- Plants are optional for some load/design workflows but required when system coil sources reference chilled water, hot water, or steam.
- Annual energy rates/economics are visible in full HAP but remain outside the current HAPAtlas design-sizing release.
