# Interaction and feedback

## State ownership

- Components own their intrinsic hover, focus, pressed, selected, invalid, and disabled presentation when exposed by their public API.
- Pages own business progress, success, failure, optimistic updates, empty data, permissions, and recovery.
- Shared application compositions may own repeated orchestration, but must expose product-specific results to the page.

Do not recreate a component-owned state with opacity, raw colors, or an outer gesture detector.

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
