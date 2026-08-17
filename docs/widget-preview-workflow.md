# Widget Preview workflow

Charcoal UI uses Flutter Widget Previewer as the primary visual feedback loop. Work moves through component, page-state, and integrated-runtime gates in that order.

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

## Change checklist

1. Search the Catalog and decide whether the work belongs to a public component, shared application composition, or page-local composition.
2. Add or update the smallest component Preview first.
3. Add deterministic page-state Previews using the real state owner.
4. Run static analysis and relevant widget tests.
5. Start only the owning Previewer package, filter to the exact component or page-state target, and confirm it loads without runtime errors.
6. Launch the full app only when the change crosses a runtime boundary listed above.
