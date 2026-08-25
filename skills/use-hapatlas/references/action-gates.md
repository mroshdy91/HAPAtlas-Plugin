# HAPAtlas workflow gates

Every public action carries dynamic gates. The broker ledger evaluates them for the exact project lineage, path branch, session, revision and agent run before native dispatch.

| Gate | Requirement | Typical corrective action |
|---|---|---|
| exact session | One supported session and exact HAP process lifetime are explicitly selected. | Project Scout summary, then reuse a returned `session_id` only until that HAP process closes. Re-scout after reopen/PID reuse. |
| exact capability | Action and typed branch are Available for the installed exact build. | Read adapter capabilities and choose an advertised branch. |
| live context | The version-locked live adapter matches the selected process lifetime/project. Automatic startup injection is guarded; a selected live action performs direct attachment. | Retry Project Scout with the current lifetime-scoped session ID. For HAP 6.3 `waiting_for_context` only, engineer opens and closes one actual Space editor; never substitute a Space Model, System, or Plant. Protocol/component/injection failures require restart or package repair instead. |
| current revision | Request revision equals live HAP state. | Re-scout and rebuild the inline request. |
| project baseline | This run has verified project identity/preferences. | Project Scout project-baseline. |
| design weather | The relevant design station/parameters are verified. | Project Scout weather and Weather manage/readback. |
| exact library choice | Exact URI, digest and native engineering detail—or a documented custom basis—exist. | Library search then exact inspect, or submit `engineering_basis` plus optional `provenance` in the same manage call. |
| dependencies | Referenced consumers/sources exist and passed readback. | Inspect and complete the named predecessor chapter. |
| impact confirmed | Broad Carrier dependency rewrite/deletion was previewed and explicitly approved. | Repeat identical preview, explain impact, obtain engineer confirmation. |
| native readback | Prior write survived fresh native retrieval and untouched-domain verification. | Perform the returned scout/readback action. |
| complete input audit | Blocking references/assignments/coverage issues are resolved. | Project Scout input-audit and repair owning domains. |
| current results | Native results belong to the current revision and selected cases. | Reports design.calculate and bounded job wait. |
| job state | Exact job exists and supports requested status/wait/cancel. | Reports job.status. |
| undo window | Named transaction is latest compatible unsaved state. | Reinspect revision/Save state; otherwise undo is unavailable. |
| engineer only | The engineer has created/imported/repaired and visually validated native HAP 6.3 Building Floor Plan geometry. | No native dispatch. Engineer completes the Building Floor Plan work in HAP; then Project Scout model followed by verification. |
| report support | Exact adapter report kind/format is advertised. | Reports catalog. |
| trusted source | External source is exact-build compatible and current digest is authorized. | Library sources.verify. |
| action payload | Action and conditional typed object agree. | Correct the named field in the same action and repeat dry run. |

A write adds two automatic gates:

1. immutable dry run with canonical request and plan hashes;
2. identical live request before expiry.

After native apply, the action remains `readback_required` until canonical retrieval and scope verification pass. Successor writes stay blocked. A manual HAP revision change invalidates affected checkpoints and returns the run to Project Scout.

`WORKFLOW_GATE_BLOCKED` always returns why the gate matters, exact corrective tool/action, required readback and allowed successors. Do not bypass it.
