# HAP 6.3 Alternative workflow

Use this workflow only for the engineer-visible HAP 6.3 **Alternatives** chapter.
HAP 5.1 Buildings are an annual-energy workflow and remain deferred.

## Required sequence

1. Scout `systems`, `plants`, `active`, and `results` for the exact selected
   session and retain the current revision.
2. Retrieve `alternative-workflow-v1`.
3. Resolve every retained System and Plant to its exact `external_key`, native
   `hap_id`, and native `name`.
4. Dry-run `hapatlas_alternatives_manage(action: "hap63-alternative.upsert")`
   with one inline Alternative and only those exact identity stubs.
5. Apply the unchanged request to the unchanged revision.
6. Re-scout `active`, `systems`, `plants`, `results`, and `input-audit` before
   calculation.

The Alternative contains `system_keys` and `plant_keys`. It does not own System
or Plant definitions. Never add System type, equipment, schedules, zones, fan,
coil, controls, sizing, Plant type, equipment schedule, loop, pump, or other
engineering fields merely to satisfy validation. Those inputs belong to their
dedicated manage tools and must already have passed exact native readback.

## Gates and result impact

- The selected HAP 6.3 Alternative identity is preserved; active-Alternative
  omission is rejected.
- Every reference must resolve uniquely in the current session.
- A composition change invalidates only results in the affected Alternative.
- Shared Systems and Plants remain single native objects and are calculated
  once even when referenced by more than one Alternative.
- After readback and a clean audit, use `hapatlas_reports_manage` for Carrier
  sizing and export. The engineer alone reviews and saves HAP.

If an installed package asks for `system_type`, `plant_type`, or another
dependency engineering field from an exact identity stub during dry run, live
apply, or native readback, stop with a domain-scope failure,
re-scout the same session, and retry the same immutable dry run. Do not broaden
the payload or use another writer.
