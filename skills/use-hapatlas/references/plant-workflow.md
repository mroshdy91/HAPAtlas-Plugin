# Plant composition and System connections

Alpha currently exposes existing accepted Plants through `hapatlas_project_scout`, `hapatlas_reports_manage`, and native result/report workflows. It does **not** expose `hapatlas_plants_manage`, `plants.upsert`, `systems.connect`, or `plant-workflow-v1` in the normal callable surface.

Before attempting any new composition, read `adapter-capabilities.callable_actions` and `action-gates`. If the Plant action is absent, stop. Do not move Plant fields into Chiller, Boiler, System, Alternative, a generic model writer, or an external file.

This gate exists because the public request must be resolved before native dispatch against all exact live identities and accepted portfolio semantics: System, Chiller/Boiler, Cooling Tower/Heat Rejection, existing Plant, selected adapter, and reciprocal System-to-Plant connection. A late native rejection is not a sufficient safety boundary.

The separately accepted existing portfolios remain valid evidence and may still be calculated or reported:

- HAP 5.1 one-water-cooled-centrifugal-Chiller / one-Cooling-Tower / accepted VAV chilled-water portfolio;
- existing accepted air-cooled chilled-water portfolios;
- existing accepted one-Boiler hot-water portfolios.

Inspection or calculation availability never authorizes creating a new Plant. Preserve the diagnostic package when an agent attempts the hidden workflow; recovery is to re-scout Plants and choose only an action listed under the selected adapter's `callable_actions`.
