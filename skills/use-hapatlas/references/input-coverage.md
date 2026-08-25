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
| Space inputs / Space Models | Mixed | Mixed direct Space workflow | Use the adapter-specific registered action. Never invent geometry, hidden fields, or a cross-version object that the HAP UI does not expose. |
| Systems / controls | Mixed | Mixed | Resolve verified Spaces/zones/schedules/sources first; call only exact accepted portfolios. |
| Plants / connections | Candidate, not callable for new composition | Candidate, not callable for new composition | Existing accepted Plants may be inspected/calculated/reported; never invent or bypass the missing pre-native portfolio resolver. |
| Alternatives / Buildings | Available HAP 6.3 Alternative | HAP 5.1 Building unavailable in design sizing | Never treat a HAP 5.1 Building as a HAP 6.3 Alternative. |
| Calculation / reports | Available accepted air/plant paths | Available accepted air/plant paths | Calculate explicitly under Reports, wait on its job there, then export only revision-matching results. |
| Visual geometry | Engineer-only | Not applicable | The engineer authors/repairs HAP 6.x graphical geometry in HAP; HAPAtlas performs read-only verification afterward. |

`hapatlas_undo` reverses one exact unsaved HAPAtlas transaction; it is not a generic model editor. Save remains user-only. A cross-version solver comparison is allowed only after parity and result-decomposition gates explicitly report readiness.
