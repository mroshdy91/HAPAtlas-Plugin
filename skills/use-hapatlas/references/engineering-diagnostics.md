# HVAC engineering diagnostics

Use this sequence when a HAP result is nonphysical, unexpectedly high or low, changes after an input edit, differs between alternatives, or differs between HAP versions. Diagnose engineering cause and effect; do not debug HAPAtlas code with this manual.

## Governing rule

Treat the desired or expected output as a diagnostic hypothesis, never as permission to tune inputs until a number matches. Change an input only when an engineering assumption, source, drawing, standard, owner criterion, or native library choice justifies it. Record the provenance and the before/after result decomposition.

Use HAP's native sizing engine for every trial. Never substitute an independent load or sizing calculation for the HAP result.

## 1. Freeze and identify the baseline

1. Select the exact `session_id` and inspect its current revision.
2. Record project filename, HAP adapter/build, design weather, simulation weather, active Alternative or Building, space model, systems, plants, and result status.
3. Confirm the result belongs to the intended alternative/building, system, plant, and revision.
4. Export or retain a structured baseline result before changing inputs.
5. Do not mutate a project whose result is stale, whose references are broken, or whose session is ambiguous or tainted.

If comparing projects or versions, run `input-parity` first. `coverage_incomplete` means HAPAtlas has not proved that the difference is caused by the calculation engines. After both accepted models are calculated, run `result-decomposition`; do not estimate the missing layers yourself.

The native input gate includes active return-fan, ventilation damper/leak, economizer cutoff, preheat/precool, heat-recovery, envelope-surface, plant connection, fluid, and pump-loop evidence. Result layers bind through exact native owner IDs, never similar names. Do not assume an enabled component or similarly named result is equivalent merely because its headline system type matches.

## 2. Locate the layer where the symptom appears

Trace from the reported output toward its inputs:

1. **Space load:** envelope, solar, occupants, lighting, equipment, ventilation, infiltration, schedules, and design-day hour.
2. **Zone load and airflow:** thermostat, diversity/coincidence, supply temperature, terminal type, minimum airflow, reheat, and the air-distribution configuration/specification basis. With the ASHRAE 62.1 table basis, Carrier derives the active effectiveness; do not treat a dormant nominal enum as an engineer-entered value.
3. **Air-system coil:** outdoor air, fan heat, duct leakage, return plenum, economizer, heat recovery, preheat/precool, pull-down or warm-up, and safety/sizing factors.
4. **Plant:** connected coils, simultaneous peaks, plant sizing method, equipment staging, fluid temperatures, chilled-/hot-water delta-T, heat rejection, and equipment performance.

Do not start by changing plant capacity when the unexplained difference already exists at the space or zone layer.

## 3. Decompose the load

For cooling, separate at least:

- solar and opaque envelope conduction;
- glass, doors, roof, floor, partitions, and ceilings;
- people sensible and latent;
- lighting and equipment sensible gains;
- ventilation sensible and latent;
- infiltration sensible and latent;
- fan heat, duct/plenum effects, and heat recovery;
- safety factor, pull-down, thermal storage, and coincidence/diversity.

For heating, separate envelope transmission, outdoor-air/infiltration load, internal-gain credit, warm-up, fan/duct effects, safety factor, and terminal/reheat demand.

Use `hapatlas_project_scout` with `action: result-decomposition`, the first exact session, and `filter.compare_session_id` for the second. Compare the first layer whose components diverge. A higher system-coil result with identical space loads points to system inputs, not envelope inputs. `input_alignment_required` sends the investigation back to `action: input-parity`; `decomposition_incomplete` requires current native results or a completed native result mapping before any solver claim.

## 4. Check time, weather, and schedules

1. Confirm the selected design station identity and the actual cooling dry-bulb/wet-bulb, heating dry-bulb, daily range, elevation, and provenance.
2. Confirm the peak month, day type, and hour. Do not compare only the maximum number.
3. Inspect the hour before and after the peak.
4. Check occupancy, lighting, equipment, fan/thermostat, ventilation, holiday, and design-day assignments independently.
5. Look for startup pull-down or warm-up after a night setback. A peak at the occupied transition can be valid even when the steady occupied load is much lower.
6. For Middle East calendars, verify Monday through Sunday explicitly; never infer Friday/Saturday from a generic weekend label.

## 5. Check space geometry and load bases

1. Verify area, floor-to-ceiling height, floor-to-floor calculation height, calculation volume, level, orientation, and boundary conditions.
2. Verify every wall, roof, floor, ceiling, door, window, skylight, shade, and construction assignment.
3. Confirm units and input basis, not only the displayed total.
4. Convert densities to actual per-space totals and compare those totals with the report.
5. For infiltration, inspect the declared basis and effective CFM. ACH depends on the volume HAP actually uses; HAP 6.3 can use the level floor-to-floor volume where a load-space display shows floor-to-ceiling height.
6. For outdoor air, verify both per-person and per-area components and the actual occupancy used at design.

## 6. Check zone and air-system controls

Inspect the native values that drive calculation:

- cooling/heating enabled state and source;
- supply-air temperature mode, value, reset strategy, and reset bounds;
- coil bypass, autosizing, and cooling/heating sizing factors;
- ventilation control and ASHRAE sizing method;
- return-plenum and duct-leakage settings;
- supply/return fan type, power basis, static pressure, efficiency, configuration, and control;
- economizer, heat recovery, preheat, and precool;
- terminal type, minimum-airflow basis/value, terminal supply temperature, reheat, air-distribution configuration, and specification basis; compare a numeric effectiveness only when the basis is explicitly user-specified;
- airflow sizing method, chilled-water delta-T, hot-water delta-T, and sizing-data source.

Native defaults are inputs. Two systems with the same name and equipment class are not equivalent when these controls differ.

## 7. Check plant logic

1. Confirm every connected system and multiplier.
2. Confirm cooling/heating service, plant type, equipment sequence, quantity, autosizing, and minimum unloading.
3. Confirm chilled-water, hot-water, and condenser-water temperatures and delta-T.
4. Confirm pumps, fluid properties, heat-rejection configuration, and equipment performance basis.
5. Check whether the plant peak is coincident or a sum of connected peaks.
6. Remove no connection or result merely to make a capacity smaller; correct the underlying assignment or sizing assumption.

## 8. Run one controlled experiment

1. State one hypothesis: input, expected direction, and affected output component.
2. Inspect the current domain and retain the exact revision.
3. Apply one justified change through the appropriate HAPAtlas domain tool.
4. Reinspect verification and input audit.
5. Recalculate through HAP and export the same structured result fields.
6. Compare the component decomposition, peak time, airflow, coil, and plant effects.
7. Accept the change only when the evidence supports the hypothesis. Otherwise undo the unsaved transaction or restore the documented baseline.

Do not change weather, envelope, schedules, terminals, and sizing factors together. That destroys causal evidence.

## 9. Interpret common symptoms

| Symptom | Inspect first |
|---|---|
| Cooling peak occurs at occupied startup | Night setback, pull-down, thermal mass, schedule transition, sizing factor |
| Supply airflow is unexpectedly high | Cooling supply temperature, airflow sizing method, zone peak/coincidence, terminal minimum, ventilation |
| Latent load is unexpectedly high | Design wet-bulb, outdoor air, infiltration, people latent gain, schedules |
| Space load matches but coil load is high | Outdoor-air method, fan heat, duct/plenum, economizer, heat recovery, safety factor |
| CHW plant capacity is high | Connected coils, multipliers, coincidence, plant sizing factor, CHW delta-T, stale/extra systems |
| Heating result is zero | Heating enabled state, design weather, thermostat, heat source, monthly availability |
| Reheat is excessive | Minimum terminal airflow, supply reset, terminal type, reheat source, zone setpoint |
| One HAP version is much higher | Native input manifest and peak hour first; solver method only after parity is proven |
| UI and exported result disagree | Wrong alternative/building, stale result, missing binding, duplicate/orphan result, revision mismatch |

## 10. Cross-version comparison

Classify every difference before assigning a tolerance:

1. **Exact semantic input mismatch:** align or document it.
2. **Native catalog difference:** keep each Carrier value and record provenance.
3. **Representation boundary:** document what cannot be modeled one-to-one.
4. **Inspection coverage gap:** stop; do not claim an engine difference.
5. **Calculation-method difference:** evaluate only after the first four classes are resolved.

Compare peak timing and component breakdown as well as totals. A final percent difference alone cannot identify cause. Record the returned space, zone, coil, fan, outdoor-air, and plant deltas. `ready_for_solver_tolerance` only proves the input and decomposition gates are complete; establish a tolerance from repeated representative professional portfolios, never from one simplified benchmark.

## Stop conditions

Stop mutation or result attribution when any of these applies:

- ambiguous session or project identity;
- stale revision, stale result, concurrent edit, or pending unknown Save state;
- broken references, incomplete zoning, invalid geometry, duplicate/orphan results, or tainted session;
- unsupported or unproven native field;
- parity `coverage_incomplete`;
- missing source for a proposed engineering value.

Return the blocker and the exact inspection, selection, or engineer decision needed next.

## Diagnostic record

Report each investigation compactly:

```text
Project / HAP build:
Result and symptom:
Expected engineering basis:
Baseline revision and peak time:
Evidence by space / zone / system / plant:
Suspected input and provenance:
Controlled change:
Before / after component results:
Conclusion:
Remaining uncertainty or next test:
User Save required: yes/no
```

Keep session mechanics and raw payloads out of the engineer-facing summary unless they are required for recovery.
