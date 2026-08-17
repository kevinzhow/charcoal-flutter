# Widget Preview workflow

Charcoal UI uses Flutter Widget Previewer as the primary visual feedback loop inside a five-gate process: surface inventory, component preview, page-state preview, integrated runtime, and app-wide final review.

## 0. Surface inventory

Before implementation, list every destination, detail, task, modal, sheet, overlay, and durable
result. Map each surface to its production widget, Page Experience intent IDs, meaningful states,
supported layouts, runtime key, and transitions. Every surface must be reachable from the entry;
secondary destinations are not implicitly covered by a primary-flow review.

Map the application's actual Dart destination, route, and task enums in `stateInventories`. A new
enum value must map to a reviewed surface or be explicitly ignored with a structural reason, so CI
detects route drift instead of trusting a hand-maintained list.

## Focus one preview

Keep the active review surface to the smallest relevant target instead of scanning every preview in the package:

- In VS Code, Android Studio, or IntelliJ, open the preview source file and enable `Filter previews by selected file`.
- In the command-line Previewer, enter the exact target name in `Search previews`, such as `Daylight habit states`.

The Previewer still discovers the owning package, but only the selected component or page state should remain on the working surface. Clear the filter only when comparing related targets deliberately.

## 1. Public components

Run the design-system previews:

```bash
cd packages/charcoal_ui
fvm flutter widget-preview start
```

`CharcoalComponentPreview` expands every target into light and dark previews inside a real `CharcoalApp`, so typography, themes, Navigator, and Overlay match consumer behavior. Public component previews live in `lib/src/previews/` and must use production widgets rather than preview-only copies.

Exit this gate when the relevant component states, wrapping, focus behavior, and semantic sizing are correct in isolation.

## 2. Shared compositions and page states

Run the Example previews:

```bash
cd example
fvm flutter widget-preview start
```

The Example previewer has two kinds of target:

- `AgentComponentPreview` checks application-shared compositions in light and dark mode.
- `AgentPagePreview` checks the real Nook, Lumen, and Daylight flows at 390×844 and 320×700. Initial states also receive one representative dark preview.

Page previews inject deterministic ViewModel factories into the production Demo widget. The Demo owns and disposes the model, and the preview remains interactive. Add scenarios for the initial state, the primary decision, an applicable empty/error/recovery state, and the durable success state. Do not create a second static page just for Previewer.

Keep page-private fragments private when they do not represent reusable behavior. Review those fragments through the page-state preview instead of promoting them to shared API merely for isolation.

## 3. Integrated runtime

Launch the full Showcase only for behavior Previewer cannot establish:

- route transitions, back behavior, and destination persistence;
- native input, platform services, and operating-system accessibility;
- cross-route overlays or plugin behavior;
- one final primary flow and one recovery or boundary flow.

Widget tests remain the repeatable interaction regression layer. A Preview proves a state can be reviewed under a known constraint; it does not replace behavioral assertions or platform integration checks.

Runtime scenarios in the App Experience Review reference the exact test file, test name, and keys
for the surfaces they visit. Together they must visit the whole inventory so CI can reject stale
claims when a page disappears from an executable journey.

Each cross-surface transition also records its stack effect, state preservation, and resulting back
behavior. Widget tests must prove top-level selection retains one stable root route, pushed details
pop through system back, and durable completion cannot reopen obsolete task steps.

## 4. App-wide final review

After integrated behavior is stable, revisit every inventoried surface against all seven design
rules. Then review navigation, hierarchy, product copy, responsive behavior, and accessibility
across the application. Record unresolved work as `changes-required`; it is valid review data but
does not pass the release gate.

```bash
fvm dart run packages/charcoal_cli/bin/charcoal.dart app-review \
  --validate agent/app-reviews/daylight.json
```

Only `ready: true` and exit code zero permit an Agent Ready claim.

## Change checklist

1. Update the complete surface inventory and Page Experience intent mapping.
2. Search the Catalog and decide whether the work belongs to a public component, shared application composition, or page-local composition.
3. Add or update the smallest component Preview first.
4. Add deterministic page-state Previews using the real state owner for every meaningful state and layout.
5. Run static analysis and relevant widget tests.
6. Start only the owning Previewer package, filter to the exact component or page-state target, and confirm it loads without runtime errors.
7. Launch the full app only when the change crosses a runtime boundary listed above.
8. Review every surface and validate the App Experience Review.
