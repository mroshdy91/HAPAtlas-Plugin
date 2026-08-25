# Schedule workflow

Schedules are a separate Project Libraries chapter in both supported HAP versions. The public workflow is deliberately small:

1. Scout `hapatlas_project_scout(action: "schedules")` and retain the exact session and revision.
2. When native data should be reused, call `hapatlas_library_manage(action: "sources.list")` and, for a registered source, `sources.verify`; then call `items.search` with `category: "schedule"` followed by `items.inspect` on the exact returned URI.
3. Retrieve `hapatlas_contract_get(action: "read-static", document: "schedule-workflow-v1")` when the shape is unfamiliar.
4. Call `hapatlas_schedules_manage` with exactly one inline `schedule`, first as a dry run and then live against the unchanged revision.
5. Re-scout `schedules`; verify native identity, type, all 24-hour profiles, every month/day/holiday/design-day assignment, stale-result scope, and `pending_user_save`.

Actions:

- `create-custom`: a new unique name, no `hap_id`, no `library_ref`, complete explicit semantic profiles and assignments.
- `edit-existing`: the exact current native `hap_id`, no `library_ref`, complete replacement values for the fields being managed.
- `import-library`: the exact inspected `library_ref`; optional explicit overlays remain provenance-tracked library overrides.

Fractions are always decimal `0.0–1.0`, never HAP's internal percentages. HAPAtlas hides native thermostat sentinels and profile-slot IDs. HAP 5.1 thermostat temperatures belong to the referencing System/zone workflow; its Schedule retains occupied state. HAP 6.3 thermostat profile temperatures use the declared IP/SI units.

Do not route Schedule mutation through Space Inputs, do not submit a whole ProjectSpec, and do not create an external JSON/model file. Duplicate, delete, and Utility Rate Time-of-Day are not advertised until their exact-build live gates pass. Only the user saves HAP.
