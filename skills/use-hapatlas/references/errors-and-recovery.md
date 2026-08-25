# HAPAtlas errors and recovery

Every error must include a stable code, engineer-readable message, retryability, recovery instruction and diagnostic ID. Public tool/action failures also carry the exact blocked action, unsatisfied gate, mandatory readback and allowed next action when `ToolResult` can represent them. Manual HAP/package work is named as an engineer action, never a fake callable tool.

| Error family | Agent behavior |
|---|---|
| `WORKFLOW_GATE_BLOCKED` | Perform the returned corrective action/readback in the same session. Continue only through an allowed successor. |
| `AMBIGUOUS_SESSION` | Select one returned session ID; never use window focus. |
| `STALE_REVISION` / `SESSION_CHANGED` | Discard the old preview and session ID, re-scout, and rebuild from current readback. A close/reopen or PID reuse always creates a new lifetime-scoped `session_id`; never retry the old one. |
| `HAP_BUSY` | Wait for Save/modal/calculation/lease to finish, then re-scout before retry. |
| `CONTRACT_VERSION_UNSUPPORTED` | Retrieve `hapatlas://contracts/project-spec/current`; use `schema_version: "1.0"`. |
| `ACTION_PAYLOAD_MISMATCH` / `INVALID_*` | Correct only the named typed field in the same action, then dry-run again. |
| `LIBRARY_SOURCE_CHANGED` / `LIBRARY_NAME_CONFLICT` | Re-verify/inspect the exact source and obtain an explicit choice. Never accept or rename silently. |
| `ADAPTER_CAPABILITY_UNAVAILABLE` / `LIVE_OPERATION_NOT_PROVEN` | Stop. Use an advertised branch or the returned engineer-visible manual workflow. |
| `DOMAIN_SCOPE_VIOLATION` | The transaction was rolled back. Preserve diagnostics and do not broaden the payload. |
| `RESULT_IMPORT_CONFLICT` | HAP inputs changed during calculation; recalculate the new revision. |
| terminal `job.status` / `job.wait` failure | Treat the outer `ok: false` as the operation outcome, not as a successful poll. Preserve the job/origin diagnostic context, run project-baseline then input-audit, resolve the terminal error, and start a new calculation on the returned revision. |
| `NATIVE_VERIFICATION_EVIDENCE_MISSING` | Stop writes. Run the exact returned mandatory owning-chapter readback, preserve the diagnostic ID, refresh project-baseline, and begin a new dry run. Never promote the unverified checkpoint. |
| `BROKER_UPGRADE_PENDING` | Finish active jobs and close the affected client normally. The current-user HAPAtlas handoff watcher completes any verified pending launcher replacement after the old launcher exits. Reopen the client and re-scout; if the error survives one full restart, provide the session `.hapatlasdiag` instead of deleting install metadata. |
| `BROKER_PROTOCOL_ERROR` / transport failure | Do not replay a write blindly. Follow the structured blocked action/recheck, run doctor/restart as directed, and re-scout the exact revision before retrying. |
| `BRIDGE_REQUIRED` / `BRIDGE_CONTEXT_NOT_READY` / `BRIDGE_ATTACH_TIMEOUT` | Retry selected-session context readiness. For HAP 6.3 `waiting_for_context` only, engineer opens and closes one actual Space editor; never substitute a Space Model, System, or Plant. |
| `BRIDGE_COMPONENT_MISSING` / `BRIDGE_INJECT_FAILED` / `BRIDGE_START_FAILED` | Exact package, target image/build/hash, or process-creation identity failed before readiness; HAP may have exited or the PID may have been replaced. Do not use the Space-editor fallback or loop attachment. Run doctor, repair/reinstall when directed, restart/reopen HAP, then project-baseline. |
| `BRIDGE_PROTOCOL_ERROR` / `BRIDGE_PROTOCOL_MISMATCH` / `BRIDGE_RESTART_REQUIRED` | Restart HAP/reopen the project, run doctor if mismatch persists, then project-baseline before a write. HAPAtlas ignores evidence from an older exact process-creation identity and never reinjects an already-loaded bridge; a repeated error therefore refers to the current HAP process. |
| `HAP_SESSION_TAINTED` | Stop all writes/reports. Engineer closes the selected project without saving and reopens it; run project-baseline then the returned owning-chapter mandatory readback. |
| `ENGINEER_ACTION_REQUIRED` for HAP 6.3 geometry | Engineer creates/imports/repairs and visually validates the Building Floor Plan in HAP; then run Project Scout model and verification. No native dispatch. |

Do not loop errors, switch tools to evade a gate, clear data to make a request pass, or Save a possibly tainted session.

Routine evidence is automatic. If a failure persists, ask the engineer for the most recently refreshed `.hapatlasdiag` for the exact process-lifetime session from `%LOCALAPPDATA%\HAPAtlas\Support\Sessions` and its diagnostic ID. A resolved project package includes earlier attachment events from the same session even when they were first recorded before HAP exposed the project path. The package contains public requests/readbacks and classified native evidence, not private agent reasoning or every manual click.
