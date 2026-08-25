# Versions and capabilities

## Supported exact builds

| Adapter | Exact build/project | Access |
|---|---|---|
| `hap63` | HAP 6.3 build `6.03.1378`, payload `6.3.0001` | live read/write through version-locked injected managed adapter |
| `hap51` | HAP 5.1 build `5.01.0014`, project format `AR002` | live read/write through version-locked COM/bridge adapter |

Executable, Carrier assembly, payload/project-format and adapter hashes are checked. No neighboring version is implied.

## Capability interpretation

- `Available`: callable and exact-build live accepted.
- `Mixed`: historical evidence that a domain contains accepted and unaccepted branches. Alpha registers only exact `Available` actions; a Mixed or Candidate label never makes a branch callable.
- Candidate, guarded, deferred, engineer-only and disproved: not present in the callable action enum.
- Not applicable: the selected HAP version exposes a different engineer workflow.

Always read the installed action schema and adapter-capabilities contract. Archived research may describe experiments that are deliberately absent from Alpha.

## Important version differences

- HAP 6.x uses Space Types and graphical Building/Space Model workflows; HAP 5.1 owns usage and many envelope inputs directly in Spaces.
- HAP 6.3 uses SHGC for visible Window/Door solar performance; HAP 5.1 exposes native Shade Coefficient. Do not assume a conversion.
- HAP 5.1 Cooling Towers and HAP 6.3 Heat Rejection are different visible chapters and native records.
- HAP 6.3 Alternatives are design-case composition. HAP 5.1 Buildings are a deferred annual-energy workflow, not an Alternative synonym.
- Design result values may differ across engines only after semantic input parity and coverage are proven.

## Excluded from Alpha v1

- unsupported HAP builds;
- automatic Save;
- visual/PDF/image/3D/BIM geometry work;
- annual energy simulation, economics and utility-rate modeling;
- private native calculated-report renderer hooking;
- external whole-model files and generic whole-model mutation;
- actions without complete exact-build acceptance.
