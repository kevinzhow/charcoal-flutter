# Interaction and feedback

## State ownership

- Components own their intrinsic hover, focus, pressed, selected, invalid, and disabled presentation when exposed by their public API.
- Pages own business progress, success, failure, optimistic updates, empty data, permissions, and recovery.
- Shared application compositions may own repeated orchestration, but must expose product-specific results to the page.

Do not recreate a component-owned state with opacity, raw colors, or an outer gesture detector.

## Persistent and transient interaction state

- Keep one owner for a controlled value and derive its selected, checked, or expanded presentation directly from that value.
- Commit a persistent value, its visual and semantic state, and the content it controls in one frame. Do not mirror it in local component state or repair it from route state after paint.
- Animate transient hover, focus, and press feedback independently. An implicit animation must not reuse a decoration or color tween across a persistent value change; separate the layers or reset/key the animation boundary when the controlled value changes.
- Treat input modalities explicitly. Touch has no required hover phase: pointer down adds pressed feedback to the target while the current controlled selection, semantics, content, and route remain authoritative.
- Pointer cancellation clears pressed feedback without invoking the action or changing persistent state. Do not commit selection on pointer down because the gesture can still lose or cancel.
- An accepted tap may fade its pressed overlay while the app-shell owner atomically commits the new selected visual, semantics, and content without pushing, replacing, or re-keying the root route. The previous destination must not remain visibly selected during that first post-activation frame.
- Keep pressed feedback visually distinct from selected state. Prefer an independently animated state layer over the persistent selected layer so a held touch does not resemble two selected destinations.
- Treat a state layer as paint-only unless the interaction explicitly changes layout. It must preserve the interactive target rectangle, sibling allocation, icon and label centers, and text baselines across idle, hover, focus, press, cancellation, and selection. Do not wrap normal content in a loose `Stack` merely to paint an overlay; retain the component's original constraint chain or use a positioned paint-only child without changing the content constraints.

For Flutter regression evidence, use a real `TestGesture` rather than collapsing the lifecycle into `tester.tap`. Record target rectangles, icon and label centers, and relevant text baselines before input. Hold the pointer down long enough for press recognition and paint, then assert that only the target's transient pressed layer changed while geometry, the previous selection, semantics, content, root route, and stable page key remain unchanged. Cancel once and assert that pressed feedback clears with no persistent or geometric effect. Start a fresh gesture, release it, and call `await tester.pump()` exactly once; at that frame, assert that geometry is still stable, the previous item paints and exposes unselected state, the target paints and exposes selected state, the controlled content agrees, and route identity is unchanged. Run `pumpAndSettle` only after those assertions; a tap-only, color-only, or settled-only test can miss a press-down double highlight, stale-selection flash, or layout jump.

## Feedback selection

- Use inline feedback beside the relevant control when the user must correct or retain it.
- Use a persistent status surface when the result changes the page or remains relevant.
- Use a toast for brief, self-contained acknowledgement that requires no action.
- Use a snackbar when transient feedback has one useful follow-up action.
- Use a blocking modal only when the current task cannot safely continue without a decision.

## Minimum transition record

For each meaningful interaction, record:

1. Trigger and precondition.
2. State before the action.
3. Immediate acknowledgement.
4. In-progress or optimistic state when applicable.
5. Success result and where it remains visible.
6. Failure message, retained user input, and recovery action.
7. Cancellation or escape behavior.
8. Accessibility announcement when visual feedback alone is insufficient.

An interaction may mark a step not applicable, but it must not silently omit an expected failure or recovery path.

## Cross-surface navigation record

Every App Experience Review transition must also declare:

1. A stable transition ID.
2. Its route-stack effect: `none`, `push`, `replace`, `pop`, `present`, or `dismiss`.
3. The user or application state that survives the transition.
4. The resulting platform-back behavior.
5. One or more executable runtime scenarios that visit both endpoints and prove the contract.

Top-level destination selection always has a `none` stack effect. It atomically updates one app-shell
state owner, selected presentation and semantics, and destination content without pushing, replacing,
or re-keying the root route. Details and transient tasks normally push; durable results may replace
obsolete task history; back and close pop or dismiss through the active Navigator or overlay owner.
