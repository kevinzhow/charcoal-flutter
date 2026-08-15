# Charcoal iOS component parity

This document records the Flutter implementation contract against the current
public Charcoal iOS library. The audited upstream baseline is
[`pixiv/charcoal-ios@8d96f2c`](https://github.com/pixiv/charcoal-ios/tree/8d96f2cef5be9e7983898e13cf45e0222f1aadda),
dated July 22, 2026. The public DocC catalog is available in the
[Charcoal iOS documentation](https://pixiv.github.io/charcoal-ios/documentation/charcoal/).

The Flutter library is V2-only. It uses current Charcoal V2 semantic colors,
typography, dimensions, and icons. It does not import Charcoal V1 token JSON,
aliases, or compatibility APIs. Where the iOS components still name older
surface roles, the Flutter recipe maps the behavior to the corresponding V2
semantic role.

## Coverage

| Charcoal iOS family | Flutter API | Status and scope |
| --- | --- | --- |
| Buttons | `CharcoalButton`, `CharcoalLinkButton`, `CharcoalSwitchingButton` | Complete. Primary, default, overlay, navigation, small/medium, fixed/full-width, custom primary color, link, disabled, and UIKit switching behavior are covered. `danger` is a V2 extension. |
| Text fields | `CharcoalTextField` | Complete. Label, placeholder, counter, assistive text, invalid state, disabled state, focus state, and Dynamic Type are covered. |
| Tooltips | `CharcoalTooltip` | Complete. Controlled and uncontrolled presentation, tap/hover/focus triggers, timeout, outside dismissal, anchor tracking, collision handling, and explicit positions are covered. |
| Balloons | `CharcoalBalloon`, `CharcoalAnchoredBalloon` | Complete. Continuous outlined shape, close control, action, timeout, pass-through/outside-dismiss interaction, anchor tracking, and automatic placement are covered. |
| Spinners | `CharcoalLoadingSpinner`, `CharcoalSpinnerOverlay` | Complete. Expanding/fading circle, custom size, transparent surface, blocking overlay, and interaction pass-through are covered. |
| Hints | `CharcoalHintText` | Complete. Icon slot, title, subtitle, action, visibility, width, and alignment are covered. |
| Switch | `CharcoalSwitch` | Complete. Native iOS dimensions, on/off colors, disabled state, label, semantics, and keyboard/pointer interaction are covered. |
| Toasts | `CharcoalToast`, `showCharcoalToast` | Complete. Success/error appearances, top/bottom edges, action slot, timeout, custom motion configuration, and imperative dismissal are covered. |
| Snackbars | `CharcoalSnackBar`, `showCharcoalSnackBar` | Complete. Border, optional 64 px thumbnail, action, top/bottom edges, timeout, drag dismissal, and imperative dismissal are covered. |
| Modals | `CharcoalDialog`, `showCharcoalDialog`, `showCharcoalModal` | Complete. Center and bottom-sheet styles, barrier dismissal, close control, title, actions, safe-area padding, custom duration, and custom maximum width are covered. |
| Typography | `CharcoalTypography`, `charcoalTypographyStyle`, `CharcoalTextStyles` | Complete. Numeric 10/12/14/16/20 regular, bold, mono, single-line, and Dynamic Type behavior are available alongside the primary V2 semantic typography API. |
| Dynamic Type | Ambient Flutter text scaling | Complete. Text uses `MediaQuery.textScaler`; buttons and fields grow instead of clipping at accessibility scales. |

The upstream sources used for this matrix are the public
[SwiftUI components](https://github.com/pixiv/charcoal-ios/tree/8d96f2cef5be9e7983898e13cf45e0222f1aadda/Sources/CharcoalSwiftUI/Components),
[UIKit components](https://github.com/pixiv/charcoal-ios/tree/8d96f2cef5be9e7983898e13cf45e0222f1aadda/Sources/CharcoalUIKit/Components),
and [modal implementation](https://github.com/pixiv/charcoal-ios/tree/8d96f2cef5be9e7983898e13cf45e0222f1aadda/Sources/CharcoalSwiftUI/Modal).

## Verified visual contracts

| Component | Flutter parity contract |
| --- | --- |
| Text field | The input surface remains the same V2 secondary-container color in normal, hover, pressed, focused, and invalid states. Focus or validation paints a separate 4 px ring entirely outside the 4 px input body; it never paints beneath the translucent background. The outer radius is 8 px. Label and assistive spacing are 8 px, content spacing is 10 px, and counters use a monospaced font. |
| Tooltip | Maximum width 184 px, radius 4 px, 12/4 px padding, 3 px arrow height with a 5 px half-width, 4 px anchor gap, 16 px screen inset, centered regular 12 typography, 200 ms fade, and outside tap/drag dismissal. Automatic placement prefers below, above, right, then left. |
| Balloon | Maximum width 240 px, radius 16 px, 16/12 px padding, 4 px arrow height with a 7 px half-width, 2 px light outline, bold 14 typography, close control, and optional capsule action. The body and triangle are a single path, eliminating anti-aliased seams. |
| Spinner | One circle grows from the center while fading over one second. Default diameter is 48 px with 16 px padding, an 8 px surface radius, V2 background surface, and a 10% black shadow with blur 8. Transparent mode removes the surface and shadow. |
| Hint | Radius 8 px, 16/12 px padding, 4 px icon/text gap, 16 px icon, regular 14 typography, and a V2 secondary container. |
| Switch | Native UISwitch geometry: 51 × 31 px track and 27 px thumb. The V2 primary role is used when on and the V2 neutral role when off. The label is before the trailing switch, matching the SwiftUI layout. |
| Toast | Maximum width 312 px, radius 32 px, 2 px background-colored outline, 24/8 px padding, 8 px content gap, bold single-line 14 typography, and 96 px default screen-edge spacing. |
| Snackbar | Maximum width 312 px, radius 32 px, 1 px border, optional 64 px thumbnail, 16/12 px content padding, 16 px content gap, bold single-line 14 typography, and 120 px default screen-edge spacing. Dragging away from its edge dismisses it. |
| Modal | 60% black barrier, 250 ms motion, 32 px radius, 280 px minimum width, and 440 px default maximum width. Center modals begin at scale 1.05; bottom sheets slide from below and only round their top corners. Titles use bold 20/28 typography with 48/20 px padding. Actions use 20 px padding and 8 px spacing. |
| Typography | Numeric parity sizes use 10/18, 12/20, 14/22, 16/24, and 20/28 font-size/line-height pairs. Mono variants are always single-line, matching the iOS modifiers. |

When SwiftUI and UIKit differ, the public SwiftUI component is the primary
reference. UIKit supplies capabilities not exposed by SwiftUI, such as the
switching button and imperative overlay handles. Platform-appropriate Flutter
behavior is added for keyboard focus, hover, semantics, reduced motion, and
oversized-viewport safety.

## Token-driven maintenance

All parity values above are component recipes in
[`tokens/components.json`](../tokens/components.json). Widgets consume typed
values from `CharcoalThemeData.components`; they do not duplicate those values
in their implementation.

Use the pipeline after any recipe or upstream V2 foundation change:

```bash
# Regenerate foundation tokens and every component recipe.
fvm dart run tool/tokens.dart generate

# Fail if source hashes, recipes, or generated Dart have drifted.
fvm dart run tool/tokens.dart check

# Pull and pin a new upstream V2 snapshot, then regenerate and write a diff.
fvm dart run tool/tokens.dart update --ref main
```

Do not edit generated Dart files. Change semantic mappings, geometry, motion,
or opacity in `tokens/components.json`; change the upstream snapshot only
through the update command. A single generation transaction updates the typed
theme and every consuming component.

## V2 Flutter extensions

The following components intentionally have no direct Charcoal iOS counterpart
in the audited public catalog. They remain part of this design system because
they are defined by Charcoal V2/Web needs:

- `CharcoalCheckbox`
- `CharcoalMultiSelect`
- `CharcoalRadio`
- `CharcoalDropdown`
- `CharcoalTextArea`
- `CharcoalSegmentedControl`
- `CharcoalPagination`
- `CharcoalCarousel`
- `CharcoalTagItem`
- `CharcoalIconButton`
- `CharcoalClickable`
- `CharcoalNavigationItem`
- `CharcoalTextEllipsis`

These extensions use the same generated V2 recipe pipeline and interaction
principles, but they are not described as iOS parity components.

## Icon dependency boundary

`charcoal_ui` and `charcoal_icons` are sibling packages. UI components accept
regular widget slots for icons so the UI package does not create a circular or
mandatory icon dependency. The Showcase fills those slots exclusively with
Charcoal Icons V2, including modal and balloon close controls. Applications can
do the same while retaining the option to inject product-specific artwork.
