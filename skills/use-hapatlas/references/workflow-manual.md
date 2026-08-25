# HAPAtlas professional workflow

## Start and select

1. Project Scout `summary`.
2. If several sessions exist, present the returned project/version candidates and select one exact `session_id`. Treat it as valid only for that exact HAP process lifetime; close/reopen always requires a fresh summary and ID.
3. Project Scout `project-baseline`.
4. Project Scout `workflow-progress`.

Do not write before the run holds exact session, adapter, revision and baseline checkpoints.
Automatic HAP 6.3 startup injection is guarded. The selected `project-baseline`
call performs direct attachment; only a returned `waiting_for_context` state
requires the engineer to open and close one actual Space editor.

## Establish project context

- HAP 5.1: preview/apply visible Project > Properties when needed.
- Both adapters: verify View > Preferences > Project.
- If standards differ, preview Carrier's dependent rewrite and result invalidation, explain it, obtain explicit engineer confirmation, apply the unchanged request, then complete baseline readback.
- Inspect Weather's visible Design Parameters, select an exact installed station and apply only explicit promoted overrides.

## Resolve reusable inputs

For each required sidebar library category:

1. list/verify trusted sources;
2. search a narrow category;
3. inspect exact candidate engineering detail and digest;
4. reuse/import the exact item, or provide a documented custom engineering basis;
5. immutable dry run;
6. identical live action;
7. mandatory native readback;
8. carry the returned revision.

Use the HAP sidebar order: Schedules, constructions/openings/shades, central equipment definitions, then project consumers. Never create a hidden whole-model document.

## Build consumers

- Apply Space usage/type and load inputs through Spaces.
- For HAP 6.3, the engineer authors/validates visual Building geometry; HAPAtlas handles only advertised nonvisual Space Model assignments and zoning.
- For HAP 5.1, use advertised direct Space/surface semantics; do not invent a graphical model.
- Define Systems, assign served Spaces/zones, then manage controls/sizing/source connections.
- Define reusable Chiller/Boiler/version-correct heat-rejection items through callable exact-build managers. Treat new Plant composition as a later Candidate checkpoint until adapter capabilities explicitly expose it; existing accepted Plants remain inspectable/calculable/reportable.
- Compose Plants from freshly verified identity stubs, read back, then connect Systems and read back both sides.
- Compose HAP 6.3 Alternatives only after System/Plant readback.

Each successor is blocked until the previous native readback passes.

## Verify, size and report

1. Project Scout `input-audit`; resolve blocking references, assignments, coverage and stale results.
2. Reports `catalog`.
3. Reports `design.calculate`, then bounded `job.status/wait`.
4. Project Scout `results` and `verification`.
5. Reports `design.export-current` and/or `input.export`.
6. Engineer reviews HAP UI/native View Design Reports and clicks Save.
7. After Save/reopen, Project Scout verifies persistence and clears pending-Save only from current native evidence.

## Manual change or failure

A manual HAP edit changes revision and invalidates affected checkpoints. Return to Project Scout and repeat only the impacted chain. A failed transaction is rolled back; if rollback is unproven, stop on tainted-session recovery.
