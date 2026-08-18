# App-wide final review

The App Experience Review is the release record for a multi-surface Charcoal experience. It prevents a polished primary flow from hiding neglected secondary destinations.

## Build the inventory first

Treat a surface as anything with its own user intent, hierarchy, state boundary, or escape behavior: a top-level destination, detail page, focused task, modal, sheet, overlay, or durable result. For each surface, record:

- its production widget, source path, and stable runtime key;
- the Page Experience Spec and exact intent IDs it serves;
- every meaningful visual or interaction state;
- deterministic Widget Preview evidence at compact and standard layouts;
- a verdict and concrete evidence for each of the seven design rules.

Transitions must make every surface reachable from the declared entry. Do not omit a surface because it is secondary, simple, or unchanged by the current task.

Connect the inventory to the application's actual Dart destination, route, and task enums through
`stateInventories`. Map every enum value to a surface or explicitly ignore structural values such
as `none` or `root` with a reason. Validation fails when source gains a new enum value without a
corresponding surface decision, or when an inventoried surface has no source state.

## Make evidence executable

Each runtime scenario references an exact test file and test name. Its listed surfaces must have their runtime keys in that test source. Scenarios collectively cover the complete inventory, while CI executes the referenced test suite. This connects the review record to production widgets and executable behavior instead of relying only on prose.

Widget Preview evidence uses the exact `AgentPagePreview` state name in the referenced source. Every declared surface state must cover every application layout class.

## Use verdicts honestly

`pass` means the cited evidence exists and the behavior has been reviewed. `changes-required` is allowed while work is in progress, but it blocks Agent Ready. Findings remain explicit until resolved; do not hide them in optimistic evidence text.

The final review must name every inventoried surface and pass five cross-surface checks:

- navigation: touch down and cancellation affect only transient feedback without moving target bounds or icon/label alignment, while the first painted frame after accepted activation keeps geometry, controlled selection, semantics, content, and route state atomic; reachability, back behavior, and state persistence are coherent; supported mobile pushed routes additionally prove in-progress interactive-back geometry, cancellation restoration, one committed pop, route guards, and active nested-Navigator ownership rather than only a final system-back callback;
- hierarchy: primary intents remain identifiable and secondary pages receive equal design care;
- product copy: labels describe real behavior and no developer-facing rationale leaks into the product;
- responsive: every state holds at all supported layout classes and relevant text scaling;
- accessibility: labels, state, focus order, announcements, contrast, and target sizes are coherent across flows.

## Completion command

Run `charcoal app-review --validate <path>`. A structurally valid file can still report `ready: false`; only exit code zero permits an Agent Ready claim.
