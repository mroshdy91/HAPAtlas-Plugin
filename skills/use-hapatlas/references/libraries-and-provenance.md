# Libraries and provenance

## Professional local ranking

Use `scope: libraries` for project/Carrier/user data and `scope: documentation` only for the selected adapter's installed `hap.chm`. Library ranking is deterministic: exact native ID/WMO/catalog-city identity, exact normalized name, name prefix, fielded BM25, then optional geographic distance evidence for Weather. Every hit reports its strategy, score, exactness, and distance when available. BM25 and distance help discover candidates; they never authorize an ambiguous engineering selection.

Documentation search decompiles/indexes the locally licensed CHM in a digest-keyed `%LOCALAPPDATA%\HAPAtlas\knowledge-cache` directory. A `hapatlas-knowledge://` result is guidance only, cannot be used as `library_ref`, is invalidated when the CHM digest changes, and is not included in packages or default support bundles.

## Resolution order

Resolve engineering inputs in this order:

1. Explicit `library_ref` URI and digest.
2. Existing project item with matching recorded provenance and digest.
3. Unique exact normalized name/category match.
4. One candidate satisfying all structured filters.
5. Otherwise return exact choices.

Never choose a fuzzy match automatically.

`search` is deliberately compact. Call `inspect` on the exact returned URI before recreating or overriding an item. Exact inspection must return native engineering detail; `LIBRARY_ENGINEERING_DETAIL_UNAVAILABLE` is a stop condition, not permission to infer values from the item name. For schedules, use the returned profiles, all month/day assignments, and semantic digest. HAP thermostat schedules carry occupied/unoccupied state while zone heating/cooling setpoints are system inputs, so inspect the referencing systems before constructing a thermostat ProjectSpec schedule.

## Source classes

- Current project items.
- Installed Carrier reference repositories.
- Installed Carrier templates and example projects.
- User template projects registered explicitly with HAPAtlas.

Do not scan arbitrary drives. Do not modify a source template.

Source authorization is a separate professional chapter from item search:

1. `hapatlas_library_manage(action: sources.list)` for one exact session/adapter.
2. For a user-chosen template only, `sources.register` with the explicit adapter and exact path.
3. `sources.verify` the returned source URI. HAPAtlas checks HAP 6.3 payload `6.3.0001` or HAP 5.1 archive `AR002` and the immutable digest.
4. Use `hapatlas_library_manage(action: items.search, source_uri: <verified source uri>)` and then `items.inspect` with the exact returned item `uri`.

`changed`, `missing`, `incompatible`, and `invalid` sources are not searchable. A changed digest requires deliberate re-registration; it is never updated silently. `unregister` removes only future HAPAtlas authorization and never deletes the file or already imported HAP items. Installed Carrier catalogs, templates, and help are fixed sources and cannot be registered or unregistered.

The current-project source URI is session-scoped and dynamic; it is valid only with the session that returned it and is inspected directly rather than treated as an external registered archive. An unscoped browse may continue past an unreadable optional project/template archive and returns `LIBRARY_SOURCE_UNAVAILABLE:<source>:<code>` as an explicit warning. Direct installed catalogs (Weather, materials, Space Usage, and Window components) are never traversed as project archives; query them only through their matching category. A search scoped to an exact unreadable archive still fails closed. Inspect and import only a candidate returned from a ready exact source; never suppress or reinterpret the warning.

## Reuse and import

Reuse an exact current-project match. Import an external native item through the adapter's typed import/clone APIs and bring dependencies first. Preserve native IDs for reused/adopted items and allocate native IDs only for imported or new items.

Do not create automatic `(1)` duplicates. Return `LIBRARY_NAME_CONFLICT` when the same name has different content and provide candidate target names.

HAP 5.1 native Space/system cloning from a registered `.E3A` is a separate transport capability. It can prove dependency and backing-file safety, but it does not prove that an ordinary agent can recreate the inputs through typed HAPAtlas tools. For workflow reliability tests, keep the registered project read-only, inspect its exact engineering details, and rebuild the destination through the normal domain tools without attaching source `library_ref` values to complete Spaces or systems. A user-modified source design weather appears as stable `project-design`; selecting it is acceptable only when the test explicitly permits native weather reuse.

## HAP 5.1 UI category lookup

Use the exact public category, not a guessed spelling of the HAP tree label:

| HAP 5.1 UI item | Search category | Apply owner |
|---|---|---|
| Design Weather | `design-weather` | `hapatlas_weather_manage` (Candidate until the exact live gate passes) |
| Simulation Weather | `simulation-weather` | HAP 5.1 search/mutation Guarded; never substitute the design catalog |
| Schedules | `schedule` | `hapatlas_schedules_manage` |
| Standards Space Usage choice | `space-usage`, exact installed choices for the selected project ventilation edition | Search/inspect now; later Space action selects the exact standards choice or User-Defined values |
| Exact registered source Space detail | `source-space` | Read-only template/oracle evidence; full Space clone is not a standards usage and is not oracle recreation evidence |
| Walls | `wall` | `hapatlas_walls_manage`; one exact item; promoted unassigned actions Available on both supported adapters |
| Roofs | `roof` | Available `hapatlas_roofs_manage` for one exact unassigned reusable definition; no geometry/assignment |
| Windows | `window` | Available Simple plus Detailed create/edit actions; Detailed complete-Window import remains Candidate in `hapatlas_windows_manage`; one exact unassigned definition, no placement or assignment |
| Detailed Window frames | `window-frame` | Exact select-only component for HAP 5.1 and HAP 6.3; inspect exact native ID/name before Available create/edit |
| Detailed Window gaps | `window-gap` | Exact select-only component for HAP 5.1 and HAP 6.3 when pane count is greater than one |
| Detailed Window internal shades | `window-internal-shade` | Exact select-only component for HAP 5.1 and HAP 6.3; this is not exterior Shade geometry |
| Detailed Window glazing | `window-glazing` | HAP 5.1 exact select-only catalog component; HAP 6.3 has no public glazing-item catalog and uses validated visible direct pane fields |
| Doors | `door` | Available `hapatlas_doors_manage` for one exact unassigned reusable definition; complete engineering inspect is mandatory, no placement/assignment |
| Exterior Shades | `shade` | Available `hapatlas_shades_manage` for one exact unassigned reusable reveal/overhang/fin definition; distinct from `window-internal-shade`, no placement/assignment |
| Systems | `system` | system |
| Chillers | `chiller` | `hapatlas_chillers_manage`; air-cooled create/edit Available on both adapters, HAP 5.1 exact-portfolio water-cooled create/edit Available, HAP 6.3 water-cooled and exact import Candidate. Plant management only assigns the verified identity. |
| HAP 5.1 Cooling Towers / HAP 6.3 Heat Rejection | `heat-rejection` | Version-specific manager. HAP 5.1 `cooling_tower` create/edit is Available while Dry Cooler, Geo/Well/Surface Water, and import remain Candidate; HAP 6.3 branches remain Candidate. Plant composition only assigns the verified identity. |
| Boilers | `boiler` | Available create/exact-ID unassigned edit through `hapatlas_boilers_manage`; exact inspected Boiler import Candidate, no overlay. Plant composition consumes the verified identity and never writes the definition. |
| Plants | `plant` | plant |

Reserve `space-type` for the real HAP 6.x Project Library object. HAP 5.1 has no such object: search `space-usage` for the exact selected-edition ASHRAE ventilation choice, and search `source-space` only for complete registered source evidence. The runtime guides an incorrect category call before native dispatch. HAP 5.1 Floors and ceiling Partitions are direct Space-owned actions, not missing library categories.

HAP 5.1 Simple Window and Detailed create/edit mutation are Available; Detailed creation/edit requires inspected `window-frame`, conditional `window-gap`, `window-internal-shade`, and ordered `window-glazing` identities. Detailed complete-library import remains Candidate. Component items are selections, not complete-Window imports. HAP 6.3 Detailed uses the first three component categories, but its panes are visible direct values; `window-glazing` is intentionally unavailable. Available Door and exterior Shade imports require their exact categories. Candidate Chiller import requires exact `category: chiller`, preserves native performance content, and permits no overlay; a Plant, Boiler, or heat-rejection URI is never a Chiller. Candidate Cooling Tower/Heat Rejection import requires exact `category: heat-rejection`, preserves the complete native item, permits no overlay, and routes to the selected adapter's version-specific manager. Candidate Boiler import requires exact `category: boiler`, preserves the complete native item, permits no overlay, and routes only to `hapatlas_boilers_manage`. Placement/assignment, electric/fuel-rate, zone, Building, and physical-Space mutation remains separately guarded. A current-project item is reused/adopted rather than imported. If exact engineering detail is unavailable under the mapped category, stop with `LIBRARY_ENGINEERING_DETAIL_UNAVAILABLE` rather than trying adjacent categories.

Detailed component search/inspect results are selection-only and report `importable: false`. Use their exact identity only in the corresponding component field of `create-detailed` or `edit-detailed-existing`; never send one to `import-detailed-library`, which requires one inspected complete Detailed `category: window` item. A Door is likewise a separate complete `category: door` identity; never reuse a Window, `opening-type`, or Detailed component URI as a Door reference.

## Overrides and custom values

Overlay explicit ProjectSpec fields on the selected library item. Record source URI, source digest, imported identity, and field-level differences. Emit `LIBRARY_OVERRIDE` for differences.

Under `prefer_library`, accept valid custom data and emit `CUSTOM_INPUT`. Under `library_only`, reject unresolved custom engineering data. Structural and HAP validity checks apply to both policies.

## Source changes

Bind prepared plans to library digests. If a source changes, return `LIBRARY_SOURCE_CHANGED`; search and prepare again. Never silently apply a plan generated from a different native template revision.

## Agent behavior

Search before creating. Compare exact candidates when more than one match exists. Present names, categories, native source, key properties, and digests compactly. Ask the user only for the selection that materially changes the model.
