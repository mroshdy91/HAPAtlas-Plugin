# Calculations and reports

## Ownership boundary

Carrier HAP owns load calculations, air-system sizing, plant sizing, energy simulation, and native calculated-result semantics. HAPAtlas prepares validated inputs, invokes a promoted native controller, verifies native results, and exports supported artifacts.

Never calculate an independent answer and inject it as a Carrier result.

## Pre-calculation checks

Before starting sizing, verify:

- design weather is present;
- schedules satisfy native ranges and required profile slots;
- building/space-model synchronization is valid;
- conditioned spaces are zoned;
- selected systems serve all intended zones;
- plant sources and equipment references are complete;
- no input transaction is pending verification;
- the caller holds the current revision.

Plant equipment-reference audit is adapter-specific. HAP 5.1 proves the native
numeric library category, selected ID, short label, and separately resolved full
name. HAP 6.3 proves the semantic Chiller/Boiler category, nonzero library ID,
and exact native label. Treat any request for unrelated definition fields as a domain-scope failure if a valid HAP 6.3 semantic manifest is
incorrectly rejected for lacking the HAP 5.1-only fields; never rewrite the
Plant merely to silence that false warning.

For the Available HAP 5.1 water-cooled portfolio, require exactly one native category-10 type-1 centrifugal Chiller, one valid `TowerIndex` using Cooling Tower model `2`, and only accepted VAV chilled-water AHU connections. Dry Cooler and Geo/Well/Surface-Water sizing are unavailable portfolios and must fail before Carrier calculation starts.

Treat the dry-run result-impact list as a mandatory scope proof. A System action may stale only the submitted System IDs. A Plant action may stale only the submitted Plant IDs and Systems explicitly connected by that Plant payload. If any unrelated current result appears, stop before live apply, retain the diagnostic, and repeat the same action only after HAPAtlas is corrected. Never recalculate or delete the unrelated result to hide a scope defect.

## Jobs

Calculation and large report batches are asynchronous. Retain the job ID. Use `hapatlas_reports_manage` actions `job.status` for quick reads, bounded `job.wait` for progress, and `job.cancel` only while the job advertises cancellation. Queued/running/completed polls retain the normal asynchronous shape. A `failed` or `cancelled` terminal record returns outer `ok: false` with its job/origin diagnostic context and blocked owning calculation action; do not treat the poll itself as successful. Run Project Scout project-baseline, then input-audit, resolve the terminal error, and start a new calculation only against the returned revision.

## Result acceptance

Treat a calculation as successful only when results exist in HAP's live native index, every alternative/building binding resolves, the native design status is `Calculated`, and retrieve/validation checks pass. Preserve unrelated results. Recalculation should replace selected referenced/orphan results without multiplying saved records. Typed schedule, geometry, infiltration-basis, or domain-payload errors are same-action `G18 action-payload` corrections; retain the exact session and action, repair only the named field path, and re-run dry-run.

When a result is nonphysical, unexpectedly high or low, or differs between alternatives or versions, follow [engineering-diagnostics.md](engineering-diagnostics.md). Diagnose the first diverging space/zone/system/plant component and run one justified controlled change; never tune several inputs to force a target total.

## Report boundary

Start with `hapatlas_reports_manage action=catalog`. Use `input.export` when no calculation is wanted, `design.calculate` for sizing only, `design.export-current` for current structured results, or `design.calculate-and-export` when both effects are explicitly requested. Use native Carrier report writers for promoted input reports and preserve PDF/RTF/HTML formatting. Export typed air/plant design results as JSON where private calculated-report renderers are unavailable. Do not present a reconstructed document as a native HAP template.

The dedicated Weather input report is currently an engineer-invoked native acceptance artifact on both exact builds. `hapatlas_reports_manage` does not advertise `weather-input`; a raw request fails with `REPORT_TEMPLATE_UNAVAILABLE` and names the exact manual recovery. Never use the Building Input report as Weather evidence.

Treat each output format as separate evidence. A successful Weather CSV notification does not validate a PDF created in the same batch. Count the CSV header plus 8,760 hourly rows, record its checksum, and inspect every PDF page. Reject any PDF accompanied by TER32 `Error creating font`; an observed HAP 6.3 file kept chart axes but lost all report text on later simulation pages.

Treat a HAP 5.1 Error `521` (`Can't open Clipboard`) from `SysReports.PsychAnalysisGraph` / `TERPT323` as a failed System-report graph render even when the report window opens. Reinspect native results and verification to separate renderer contention from project corruption, then retry only the same native report after a short pause. A clean Plant report and structured result JSON are independent evidence; neither makes the affected System report successful. Do not clear the engineer's clipboard or recalculate to work around the renderer.

For HAP 5.1, distinguish evidence from automation. A native input PDF that the engineer generates in HAP can verify persisted inputs, but HAPAtlas must not claim it produced that PDF unless `hapatlas_reports_manage` returns the artifact. The current accepted user-invoked `Space Input Data` report proves one saved/reopened no-opening benchmark; native HAP 5.1 input-report automation remains Candidate.

Every artifact should include absolute path, MIME type, byte size, checksum, source session, and revision provenance.

## User handoff

Summarize calculated alternatives/buildings, unique systems/plants, warnings, artifact paths, and `pending_user_save`. Ask the user to review HAP and click Save. Do not close HAP automatically.
