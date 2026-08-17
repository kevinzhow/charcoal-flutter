# Preview-led verification

Use five gates in order. A later gate does not replace an earlier one, and a full app launch is not the default feedback loop for local layout work.

Keep the active Previewer surface focused on one target. In a supported IDE, open the owning preview file and enable `Filter previews by selected file`; in the command-line Previewer, search for the exact preview name. Expand the working set only for an intentional comparison.

## Gate 0: complete surface inventory

- List every destination, detail, task, modal, sheet, overlay, and durable result that users can see.
- Name the production widget and runtime key, meaningful states, supported layouts, Page Experience Spec, and intent IDs for each surface.
- Map transitions and prove every surface is reachable from the app entry.

Gate exit: the inventory covers the whole product surface, not only the primary journey.

## Gate 1: reusable components

- Preview public Charcoal components and application-shared compositions before placing them on a page.
- Use the production widget, semantic tokens, and real callbacks. Cover relevant selected, disabled, invalid, empty, or completed states rather than drawing lookalikes.
- Check light and dark brightness when the component owns color or elevation behavior.
- Keep the preview narrowly constrained so spacing, text wrapping, focus, and target size are inspectable.
- Do not extract a page-private fragment into shared API solely to give it an isolated preview. Review that fragment in its owning page state.

Gate exit: the reused building blocks are visually coherent, interactive, and have explicit state ownership.

## Gate 2: deterministic page states

- Preview the real page or flow shell with its real state owner. Inject state through a deterministic factory that the previewed widget owns and disposes.
- Include the initial state, the primary decision state, an applicable empty/error/recovery state, and the durable success state.
- Preview compact and standard constraints. Add a representative dark preview without multiplying every scenario when component previews already cover brightness behavior.
- Keep previews interactive so a reviewer can move forward or recover from the seeded state.
- Never maintain a second static “preview-only” implementation of the page.

Gate exit: information hierarchy, reuse, state-specific copy, feedback placement, and responsive layout are reviewable without opening the Showcase.

## Gate 3: integrated runtime

Launch the full app only to verify behavior that isolated previews cannot prove:

- route transitions, back behavior, and destination persistence;
- platform input, native plugins, accessibility services, and operating-system surfaces;
- overlays whose ownership crosses the preview boundary;
- the complete primary flow and one recovery or boundary flow.

Gate exit: the Page Experience Spec has both preview evidence and the smallest sufficient integrated-runtime evidence.

Executable runtime scenarios must collectively visit every inventoried surface. The App Experience Review links each scenario to an exact test file, test name, and the runtime keys it exercises so CI can reject stale claims.

## Gate 4: app-wide final review

- Revisit every inventoried surface after integrated behavior is stable.
- Record a verdict and concrete evidence for each of the seven design rules on every surface.
- Review navigation, hierarchy, product copy, responsive behavior, and accessibility across the application rather than one route at a time.
- Keep findings open as `changes-required`; never convert an unresolved issue into a passing narrative.

Gate exit: all surfaces, design rules, runtime scenarios, and cross-surface checks pass; no finding remains; `charcoal app-review --validate <path>` exits successfully.

## Flutter commands

Run `flutter widget-preview start` from the package that owns the preview targets. In the Charcoal contributor workspace, public component previews live under `packages/charcoal_ui`, while Agent Ready component and page previews live under `example`.
