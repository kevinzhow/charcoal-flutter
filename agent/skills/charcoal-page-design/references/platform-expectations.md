# Platform and adaptive expectations

## Layout

- Base layout changes on available `BoxConstraints`, not hardware type or orientation labels.
- Keep primary content readable on large windows with appropriate width constraints.
- Preserve the same intent and state when crossing compact and large layout thresholds.
- Let Charcoal components own their internal geometry. Use semantic layout spacing for page and section composition.

## Navigation

- Use page-level navigation chrome only for a real destination or hierarchy. Do not put a navigation bar around a gallery section or decorative card.
- Keep top-level destination state stable while opening details, sheets, or transient tasks.
- Ensure back, close, and cancellation return to a predictable prior state without losing unrelated work.

## Input and accessibility

- Support touch targets, keyboard focus, pointer interaction, text scaling, and screen-reader labels relevant to the target platforms. Do not use hover as evidence for touch behavior; verify pressed acknowledgement, cancellation, and accepted activation separately, and confirm that feedback never reflows or misaligns the target's content.
- Keep validation and state changes understandable without relying only on color.
- Announce asynchronous completion or failure when focus does not naturally move to the changed content.

## Runtime evidence

Capture or inspect the smallest set of states that proves the experience contract:

- Isolated reusable components in relevant states and brightness modes.
- Initial page state at compact and standard widths.
- Primary decision and durable outcome page states.
- Error, empty, disabled, or recovery page state when applicable.
- Large-width page layout when supported.
- Semantics or focus evidence for non-obvious interaction behavior.

Use Widget Previewer for the first five checks. Use the full application only for route history, platform integration, and the final end-to-end path.
