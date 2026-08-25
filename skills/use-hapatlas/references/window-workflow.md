# Window workflow

Windows are one shared Project Libraries chapter. The public workflow manages one unassigned reusable definition at a time and preserves the engineer-visible Simple or Detailed input method.

## Shared sequence

1. Scout the selected model and retain its current revision.
2. Search `category: "window"`, then inspect the exact returned URI and `input_method`.
3. Choose the action that exactly matches that method and intent. Never convert an existing Window from Simple to Detailed or Detailed to Simple.
4. For Detailed work, search and inspect each exact component category before constructing the inline Window. Search hits are choices; only inspected, digest-bound identities are selections.
5. Dry-run first. When the exact action is advertised for the selected adapter, repeat the unchanged call, perform the returned mandatory native Window readback, and carry the new revision.

Every call contains one inline `window` with `kind: "window"`. This chapter does not place or assign a Window, set quantity or host surface, author visual geometry, turn a Window into a Door or Skylight, or manage exterior Shade geometry.

## Simple actions — Available

- `create-custom`: `input_method: "simple"`, unique name, no `hap_id` or `library_ref`, and every adapter-required visible rating.
- `edit-existing`: `input_method: "simple"`, exact current unassigned `hap_id`, no `library_ref`, and only intended visible Simple fields.
- `import-library`: exact inspected Simple `category: "window"` `library_ref`, no `hap_id`, and no custom overlay.

HAP 6.3 Simple uses `u_value`, `shgc`, and `visible_transmittance`; reusable-definition dimensions are not visible inputs. HAP 5.1 Simple uses `u_value`, native `shade_coefficient`, `width`, and `height`; it has no Simple-form VT. Never convert or relabel native Shade Coefficient and SHGC.

## Detailed create/edit — Available

- `create-detailed`: `input_method: "detailed"`, unique name, no Window `hap_id` or complete-Window `library_ref`, and every required adapter-specific visible component input.
- `edit-detailed-existing`: `input_method: "detailed"`, exact current unassigned Detailed Window `hap_id`, no complete-Window `library_ref`, and only intended visible Detailed fields.

## Detailed library import — Candidate

- `import-detailed-library`: exact inspected Detailed `category: "window"` `library_ref`, no `hap_id`, and no custom overlay. Do not perform a live import until the selected runtime advertises this exact Candidate action.

These actions are Candidate on both exact builds. Query runtime capabilities and stop with `LIVE_OPERATION_NOT_PROVEN` unless the selected action/adapter combination is advertised. Candidate does not mean permission to use lower-level native paths.

### HAP 5.1 Detailed

Select exact installed/current-project items from:

- `window-frame`;
- `window-gap` when more than one pane is used;
- `window-internal-shade`;
- one to three ordered outer-to-inner `window-glazing` items.

HAPAtlas writes the complete native glass tuple behind each exact glazing identity, invokes Carrier performance calculation, and freshly reads back the Window. `u_value` and native `shade_coefficient` in `expected_performance` are assertions only. They are never written as Detailed inputs.

### HAP 6.3 Detailed

Select exact `window-frame`, conditional `window-gap`, and `window-internal-shade` items. For one to three ordered outer-to-inner panes, supply only the visible direct fields: name, thickness, conductivity, `low_e`, transmissivity, and reflectivity. Thickness uses inches for `units=IP` or metres for `units=SI`; conductivity uses Btu/(h ft F) or W/(m K), respectively. Absorptivity is Carrier-derived and must not be supplied. HAP 6.3 has no public `window-glazing` item catalog; do not invent a glazing reference.

Carrier derives U-value, SHGC, and visible transmittance. Values in `expected_performance` are assertions only and never become written ratings. Under `prefer_library`, valid direct pane data is permitted with `CUSTOM_INPUT`; under `library_only`, it is rejected because no exact HAP 6.3 glazing-library identity resolves it.

## Verification and recovery

After a Detailed write, verify input method, dimensions, component identities/visible pane values, pane order/count, and every adapter-native derived rating. `WINDOW_PERFORMANCE_MISMATCH` rolls the transaction back; correct the component inputs or assertion and repeat the same dry run. `INVALID_WINDOW_COMPONENT` means search/inspect the exact named component category again rather than guessing an enum or adjacent category.

The three unassigned Simple actions and Detailed custom create/exact-ID edit are **Available** on both exact builds. Complete Detailed library import remains **Candidate**. Door definitions belong to `hapatlas_doors_manage`; exterior reusable Shade definitions belong to Available `hapatlas_shades_manage`. Door/Window/Shade placement/assignment, assigned Window edit, implicit mode conversion, duplicate, delete, and Skylight behavior remain guarded. Never route one chapter through another or whole-model apply.
