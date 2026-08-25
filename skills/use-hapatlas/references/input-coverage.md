# HAPAtlas input coverage quick reference

Treat the live `input-coverage` contract and generated tool inventory as authoritative. Never call a Candidate, guarded, deferred, engineer-only, or not-applicable action through a neighboring manager.

| Chapter | HAP 6.3 | HAP 5.1 | Agent rule |
|---|---|---|---|
| Project Scout | Available | Available | Start every professional run and retain its exact `session_id` and revision. |
| Project > Properties | Not applicable | Available | HAP 5.1 descriptive metadata only; file/name changes are user Save As. |
| Project Preferences | Mixed | Mixed | Verify first; migrate only through preview plus required explicit confirmation and exact accepted dependency scope. |
| Weather | Available, including separate simulation station | Available design Weather | Select an exact inspected station or provide documented custom basis; never invent climate values. |
| Trusted libraries | Available | Available | Search returns candidates; inspect the exact item before import or reuse. Help content is non-importable. |
| Schedules | Available | Available | Use one inline Fractional Schedule with `create-custom`, `edit-existing`, or `import-library`. |
| Walls / Roofs / simple Windows / Doors / exterior Shades | Available accepted unassigned subsets | Available accepted unassigned subsets | Use only the exact manager action and adapter-visible fields; assignment is a later consuming-domain action. |
| Detailed Windows | Mixed | Mixed | `create-detailed` and `edit-detailed-existing` only; complete import and placement are unavailable. |
| Chillers | Mixed | Mixed | Use only the runtime-advertised exact equipment branch; preserve native performance content. |
| Boilers | Available accepted Hot Water subset | Available accepted Hot Water subset | One accepted definition; Plant composition and System connection are separate actions. |
| Heat Rejection / Cooling Towers | Candidate, not callable | Mixed: accepted Cooling Tower branch only | Do not use HAP 6.3 Heat Rejection mutation; reject HAP 5.1 Dry Cooler/geo/import until separately promoted. |
| Spaces | Not applicable as a direct manager | Available General slice at capability commit `87d1656…` | Use `general.create` or exact-ID `general.edit-existing` only; require Scout `spaces` readback and never invent model/geometry/load/surface context. Exact-build create, IP/SI edit/readback, scoped result invalidation, native Undo, Carrier recalculation, structured results, diagnostics, engineer UI, native input report, Save/reopen, and client-neutral constrained-agent semantic replay passed. Confirm the exact installed inventory and runtime contracts; no client-specific gate applies, and an older package that still reports Candidate must fail closed. |
| Space Types / Space Models | Candidate definition; Space Models Mixed | Not applicable | Definition Save, Apply to All Space Models, and Space Model assignment are three distinct HAP 6.3 activities. Never route them through HAP 5.1 Spaces or the retired shared alias. |
| Systems / controls | Mixed | Mixed | Resolve verified Spaces/zones/schedules/sources first; call only exact accepted portfolios. |
| Plants / connections | Candidate, not callable for new composition | Candidate, not callable for new composition | Existing accepted Plants may be inspected/calculated/reported; never invent or bypass the missing pre-native portfolio resolver. |
| Alternatives / Buildings | Available HAP 6.3 Alternative | HAP 5.1 Building unavailable in design sizing | Never treat a HAP 5.1 Building as a HAP 6.3 Alternative. |
| Calculation / reports | Available accepted air/plant paths | Available accepted air/plant paths | Calculate explicitly under Reports, wait on its job there, then export only revision-matching results. |
| Visual geometry | Engineer-only | Not applicable | The engineer authors/repairs HAP 6.x graphical geometry in HAP; HAPAtlas performs read-only verification afterward. |

`hapatlas_undo` reverses one exact unsaved HAPAtlas transaction; it is not a generic model editor. Save remains user-only. A cross-version solver comparison is allowed only after parity and result-decomposition gates explicitly report readiness.
