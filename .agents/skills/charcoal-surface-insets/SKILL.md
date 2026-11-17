---
name: charcoal-surface-insets
description: Maintainer workflow for Charcoal components that draw a surface (dialog, bottom sheet, card, toast, popover) and the inset between that surface and the caller's content. Use when a consumer screenshot shows content flush with a surface edge while other parts (actions, title) are inset, when a component parameter defaults to EdgeInsets.zero and callers pad by hand, or when changing a surface default that consumers may already compensate for.
---

# Charcoal surface insets

A component that draws a surface owns the space between its edge and the content. Consumers must
not pad a Charcoal surface's content (R6 forbids `EdgeInsets` in application code anyway). If a
consumer page shows content touching a surface edge, fix the default in the library, not the page.

## Symptom → cause

- Label or field touches the dialog's left/right edge while the buttons below are inset:
  the component's content padding defaults to zero and only some callers pad.
- A library-internal caller (confirm, form, choice, code dialog) passing the same padding by hand
  is the tell: "default zero, every caller pads".

## Fix procedure

1. Find the reference value. Charcoal Flutter follows Charcoal SwiftUI for the Modal family
   (`docs/component-sources.md`); also read pixiv web (`pixiv/charcoal`
   `packages/react/src/components/<Component>`). Cite both commits in the PR.
   Modal: SwiftUI actions `leading/trailing 20`, every sample body pads `leading/trailing 20`;
   web `.charcoal-modal-align` and `.charcoal-modal-buttons` share one 16 px left/right inset.
2. Make the default come from the component's theme metrics (here `metrics.modal.actionPadding`),
   never a literal. Keep the parameter nullable: null = the default, `EdgeInsets.zero` = explicit
   full-bleed opt-out. Pass the parameter through every convenience API (`showCharcoalModal`).
3. Delete library-internal padding that equals the new default. Keep intentional differences
   (`showCharcoalChoiceDialog` keeps its bottom inset because it has no actions).
4. Remove the hand padding from previews, the Showcase, and test scenes.
5. Test geometry, not pixels: content and the first action share left and right edges, and both sit
   `inset` from the surface. Cover the direct widget, every `show*` helper, both modal styles, and
   the opt-out. Prove the test catches a regression by temporarily restoring the old default
   (the tests must fail), then restore.
6. Regenerate the Catalog (`dart run packages/charcoal_catalog/tool/generate_catalog.dart`), then
   run `--check`, `dart run tool/agent_ready.dart check`, `flutter analyze`, and the
   `charcoal_ui` and `example` tests.

## Consumer audit (before merging a default change)

Every consumer pins its own ref. A consumer that already pads by hand gets double padding when it
bumps. For each consumer, list in the DS PR: current pin, every call site, whether it pads, and
what to remove when it bumps. Do not change consumer repos in the DS PR.

```sh
grep -rn --include=*.dart -E "CharcoalDialog\(|showCharcoalModal|contentPadding" lib
```

Known consumers: `Myoland/myopay_manage_client` (admin console), `Myoland/RemoteSurface` (the local
`flutter_rdp_client` directory is an older checkout of it), `Myoland/runsee`.

## Landing order

Chained PRs: the DS PR first; each consumer PR pins the DS PR head commit, with every charcoal
package on the same ref, and removes its now-redundant padding. Screenshot each affected consumer
dialog before and after.

## Surfaces checked (2026-11)

| Component | Content inset | Status |
| --- | --- | --- |
| `CharcoalDialog` / `showCharcoalModal` (center and bottom sheet) | `metrics.modal.actionPadding` left/right | fixed: was zero |
| `CharcoalCard` | `CharcoalInset.all(lg)` default | ok |
| `CharcoalBottomBar`, toast, snack bar, balloon, tooltip, dropdown menu, message bubble | component-owned | ok |
