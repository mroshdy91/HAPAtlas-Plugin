# HAPAtlas Alpha v1 tool catalog

The visible title mirrors the engineer's HAP path. Lowercase names are protocol IDs.

| Visible chapter | Protocol ID | Available activity families |
|---|---|---|
| HAPAtlas · Project Scout | `hapatlas_project_scout` | session/model/health/weather/results/audit reads, project baseline, workflow progress |
| HAPAtlas · Contracts | `hapatlas_contract_get` | index, static/session/record contracts |
| HAPAtlas · Project Libraries · Search & Sources | `hapatlas_library_manage` | trusted-source authorization, exact item search/inspect/compare, installed-help search/inspect |
| HAPAtlas · Project · Properties | `hapatlas_project_properties_manage` | HAP 5.1 descriptive preview/apply |
| HAPAtlas · View · Preferences · Project | `hapatlas_project_preferences_manage` | verify match, standards impact preview, confirmed migration where adapter permits |
| HAPAtlas · Weather | `hapatlas_weather_manage` | design station, promoted Design Parameters, HAP 6.3 simulation station |
| HAPAtlas · Project Libraries · Schedules | `hapatlas_schedules_manage` | custom create, exact-ID edit, exact import |
| HAPAtlas · Spaces · Inputs | `hapatlas_space_inputs_manage` | adapter-available usage/type, loads, OA/exhaust/infiltration and legacy Space branches |
| HAPAtlas · Project Libraries · Walls | `hapatlas_walls_manage` | unassigned custom create, exact-ID edit, exact import |
| HAPAtlas · Project Libraries · Roofs | `hapatlas_roofs_manage` | unassigned custom create, exact-ID edit, exact import |
| HAPAtlas · Project Libraries · Windows | `hapatlas_windows_manage` | Simple create/edit/import; Detailed create/exact-ID edit |
| HAPAtlas · Project Libraries · Doors | `hapatlas_doors_manage` | unassigned custom create, exact-ID edit, exact import |
| HAPAtlas · Project Libraries · Shades | `hapatlas_shades_manage` | unassigned numeric exterior-Shade create/edit/import |
| HAPAtlas · Project Libraries · Chillers | `hapatlas_chillers_manage` | accepted native-default create and exact-ID edit branches |
| HAPAtlas · Project Libraries · Boilers | `hapatlas_boilers_manage` | accepted hot-water native-default create and exact-ID edit |
| HAPAtlas · Project Libraries · Cooling Towers | `hapatlas_cooling_towers_manage` | accepted HAP 5.1 cooling-tower create/edit branch |
| HAPAtlas · Space Models | `hapatlas_space_model_manage` | adapter-available nonvisual synchronization, assignments and zoning |
| HAPAtlas · Systems | `hapatlas_systems_manage` | accepted System definition, assignment, controls, sizing and source connections |
| HAPAtlas · Alternatives | `hapatlas_alternatives_manage` | accepted HAP 6.3 Alternative composition |
| HAPAtlas · Reports | `hapatlas_reports_manage` | catalog, input export, native design sizing, job control, structured result export |
| HAPAtlas · Undo | `hapatlas_undo` | exact unsaved transaction undo |

The installed schema is authoritative. Actions absent from its enum are not callable, even if archived research discusses them. New Plant composition/System connection is temporarily absent until exact pre-native portfolio resolution is proven; existing Plants remain available to Scout, calculation, and reports.

Project Scout attaches the selected exact-build adapter internally. There is no public attach tool, project-prepare tool, model-apply tool, generic patch tool, standalone calculation tool, standalone job tool, or standalone report-export tool.
