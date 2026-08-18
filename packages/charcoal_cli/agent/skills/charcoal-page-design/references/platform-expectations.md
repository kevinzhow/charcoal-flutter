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
- On native iOS, a horizontally pushed page supports a locale-aware leading-edge interactive return when the active route can pop; the page follows the pointer, cancellation restores it, and commit pops once. Full-screen dialog and non-horizontal routes may intentionally opt out.
- On native Android, an eligible pushed page participates in predictive back across start, update, cancellation, and commit. Both system-edge directions must drive the same route-owned progress, and cancellation must not alter route or application state.
- Android hosts set `android:enableOnBackInvokedCallback="true"` on the application or activity so the platform can deliver predictive-back progress.
- Keep `PopScope` and nested Navigator ownership authoritative. A blocked inner route must not let a root route pop, and a gesture must not begin when pop eligibility is already known to be false.
- Web and desktop retain their supported browser, keyboard, button, or system back paths; do not synthesize mobile edge gestures.

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
- On supported mobile platforms, route-stack evidence for the complete interactive-back lifecycle, including an in-progress frame, cancellation restoration, committed pop, blocked route, nested-route ownership, and RTL or opposite-edge behavior as applicable.

Use Widget Previewer for the first five checks. Use the full application only for route history, platform integration, and the final end-to-end path.
