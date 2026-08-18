# Component source contracts

This document records where each Flutter component obtains its visual and behavioral contract. The
public `charcoal_ui` API remains platform-neutral; source provenance is maintained only so changes
can be reviewed against a concrete implementation.

## Reference order

1. Use the public SwiftUI component when it exists.
2. Otherwise use the matching Charcoal component implementation.
3. Add Flutter-specific keyboard, hover, focus, semantics, text scaling, reduced motion, and
   viewport behavior without replacing the source visual contract.

Audited revisions:

- [`pixiv/charcoal-ios@8d96f2c`](https://github.com/pixiv/charcoal-ios/tree/8d96f2cef5be9e7983898e13cf45e0222f1aadda/Sources/CharcoalSwiftUI)
- [`pixiv/charcoal@08995fa`](https://github.com/pixiv/charcoal/tree/08995fa5191fa918fc5afd2c5da08490ae307da7/packages/react/src/components)

UIKit is consulted only for a capability absent from the public SwiftUI layer, such as switching
buttons. No upstream runtime code is embedded in the Flutter package.

## Source matrix

| Flutter family | Primary implementation reference | Notes |
| --- | --- | --- |
| Typography | Charcoal SwiftUI | Numeric 10/12/14/16/20 styles and Dynamic Type behavior. |
| Buttons, links, switching buttons | Charcoal SwiftUI; UIKit where needed | Default, primary, overlay, navigation, small/medium, disabled, and custom primary behavior. |
| Text field | Charcoal SwiftUI | Label, placeholder, count, invalid ring, assistive text, disabled state, and scaling. |
| Switch | Charcoal SwiftUI | Native geometry and label-before-control layout. |
| Spinner and hint | Charcoal SwiftUI | Surface, typography, spacing, animation, visibility, and action composition. |
| Tooltip and balloon | Charcoal SwiftUI | Shape, arrow, positioning priority, dismissal, anchor tracking, and motion. |
| Toast and snackbar | Charcoal SwiftUI | Appearance, screen-edge presentation, timeout, animation, and drag behavior. |
| Modal | Charcoal SwiftUI | Center and bottom-sheet presentation, barrier, title, actions, close control, and safe area. |
| Field label and text area | Charcoal | Form label hierarchy, textarea row sizing, counter, focus, invalid, and disabled states. |
| Checkbox, radio, multi-select | Charcoal | Indicator geometry and all semantic interaction colors. |
| Icon button and tag item | Charcoal | Size families, image treatment, translated labels, and state colors. |
| Dropdown | Charcoal | Trigger, menu, options, secondary labels, state colors, and keyboard adaptation. |
| Segmented control | Charcoal | Intrinsic, uniform, and full-width segment layouts. |
| Carousel and pagination | Charcoal | Navigation visibility, indicators, page states, and keyboard adaptation. |
| Clickable, field ring, overlay tracker, popup path | Flutter primitive | Shared input, accessibility, painting, and positioning infrastructure. |
| Navigation bar, tab bar, navigation item, and text ellipsis | Flutter composition | Platform-neutral components built from the same foundations and interaction rules. |

Components in the second source group are not branded differently in their public names. They are
regular `charcoal_ui` components and can graduate without API churn.

## Verified visual contracts

| Component | Contract |
| --- | --- |
| Theme | One coherent light or dark semantic token set per scope, atomic dependent updates, and exact propagation through captured framework overlays. |
| Typography | Numeric 10/18, 12/20, 14/22, 16/24, and 20/28 component styles retain ambient text scaling; semantic page hierarchy remains in `theme.textStyles`. |
| Text ellipsis | Positive one-or-more-line plain-text clamping, soft wrapping, directional alignment, and complete default spoken content without automatic tooltip behavior. |
| Buttons | Small 32 px and medium 40 px targets; 16/24 px horizontal padding; bold 14/22 text; capsule shape; 0.32 disabled opacity. |
| Switching button | Reserves the maximum geometry of two registered buttons while only the active branch paints, ticks, receives focus, and contributes semantics. |
| Field label | Bold or regular 14/22 label, regular required and trailing metadata, 4/8 px gaps, source-order RTL behavior, and width-relative multiline adaptation under text scaling. |
| Text field | 8/10 px padding, 10 px content gap, 4 px body radius, external 4 px ring, regular 14/22 text, and 8 px label/assistive gap. The invalid counter uses the negative semantic color. |
| Text area | `22 × rows + 18` px without a count and `22 × (rows + 1) + 18` px with one; 9 px horizontal inset, 8 px top inset, 4 px field gaps, and a 4 px external ring. |
| Switch | 51 × 31 px track, 27 px thumb, 4 px horizontal control wrapper padding, regular 14/22 label, and disabled opacity applied to the control rather than its label. |
| Spinner | One-second ease-out expansion/fade, 48 px default circle, 16 px padding, 8 px radius, a named loading-spinner live region, and a 10% black shadow with blur 8. Transparent mode removes the surface fill while retaining the source shadow; blocking overlays also exclude stale child focus and semantics. |
| Hint | 8 px radius, 16/12 px padding, 4 px icon gap, the exact iOS `16/Info.pdf` icon geometry and authored `#858585` fill, and regular 14/22 text. The default surface is intrinsic-width; an action or infinite maximum width expands it, keeping the action trailing until width-relative text scaling requires a stacked action. |
| Tooltip | 184 px maximum width, 4 px radius, 12/4 px padding, 3 px arrow height, 5 px arrow half-width, 4 px target gap, 16 px screen inset, regular centered 12/20 text, and 200 ms fade. Automatic placement tries below then above. |
| Balloon | 240 px maximum width, 16 px radius, 16/12 px padding, 4 px arrow height, 7 px arrow half-width, 2 px light outline, bold 14/22 text, close affordance, and capsule action. Placement priority is below, above, right, then left. |
| Toast | 312 px maximum width, 32 px radius, 2 px outline, 24/8 px padding, 8 px gap, bold single-line 14/22 text, 96 px edge spacing, and two-second default timeout. |
| Snackbar | 312 px maximum width, 32 px radius, 1 px border, optional 64 px thumbnail, 16/12 px padding, 16 px gap, and 120 px edge spacing. Outward drag dismisses at 50 px or 100 px/s; inward drag uses a 60 px rubber-band limit. |
| Modal | 60% black barrier, 250 ms motion, 280 px minimum and 440 px default maximum width, 32 px radius, 1.05 initial center scale, top-only bottom-sheet corners, and 20 px action padding. |
| Checkbox | 20 px control, 4 px square radius or 10 px rounded radius, 2 px border, 16 px check, and 4/6 px focus rings. |
| Radio | 20 px control, 8 px dot, 2 px border, 4 px focus ring, and regular 14/22 label. |
| Multi-select | 20 px input with a separate 24 px indicator overlay, 16 px check, 2 px HUD border for overlay mode, and 4 px ring. |
| Segmented control | 32 px height, 16 px horizontal padding/radius, regular 14/22 text, and 80 px minimum uniform column width. |
| Dropdown | 40 px trigger and option minimum height, 8 px trigger padding, 4 px field/menu gaps, 280 px menu maximum height, 8 px menu radius, and 200 ms state motion. |
| Carousel | Zero default gap, 72 px navigation zones, hover/focus navigation reveal, 40 px indicator area, 8 px dot/gap, and 200 ms indicator transition. |
| Pagination | 32/40 px sizes, bold 14/22 text, 20 px radius, 4 px focus ring, and hidden navigation at page boundaries. |
| Tab bar | Two to five equal-width destinations, 64 px baseline height that grows with text scaling, 20 px icons, 10 px labels, 4 px icon gap, and compact semantic badges. |
| Tag item | 32/40 px baseline sizes that grow with text scaling, 16/24 px horizontal padding, active 16/8 px asymmetric padding, 8 px gap, 4 px radius, 152 px label maximum, and one decorative 16 px remove affordance inside the selected tag action. |

## Outline and elevation contracts

Borders are selected from the component source contract, not from a global preference for one
border token. Checkbox and radio use `borderDefault` for their unselected indicators, matching
Charcoal Web. The dropdown popover uses `borderSecondary`. SwiftUI Snackbar uses the legacy
`border` color, mapped to `borderDefault`; SwiftUI Toast instead uses a 2 px `background1` outline.

Toast, Snackbar, Tooltip, Balloon, Hint, and Modal do not add a drop shadow. Balloon has its authored
2 px light outline. Spinner is the deliberate exception: it retains the source 10% black, blur-8
shadow, including on its transparent presentation. Showcase-only cards and structural separators
use `borderSecondary` and do not define component behavior.

## Foundation and component boundary

The generated foundation supplies semantic colors, typography families and weights, standard
spacing, target sizes, radii, and border widths. A component maps those values locally when they are
an exact match. Source-specific geometry and motion are private component constants.

This deliberately means not every number is a token. Promoting a value to a semantic foundation is
appropriate only when multiple consumers share a stable meaning; numerical coincidence alone is
not sufficient.

### Runtime font mapping

The generated `text.font-family/sans` token preserves Charcoal Web's `Sarasa UI J` source value.
Runtime availability is an implementation concern: Apple native targets use the system text/display
families used by Charcoal SwiftUI, while Web and other native targets defer to Flutter's renderer
default. Skwasm cannot resolve browser-installed fonts from CSS family names, so a Web application
that requires exact typography must provide a renderer-supported font asset through its theme.
Charcoal UI does not bundle font assets, so adopting the component package does not add a font
payload to release builds. Explicit application typography overrides bypass this mapping.

## Icon dependency boundary

`charcoal_ui` and `charcoal_icons` are sibling packages. UI controls accept regular widget slots so
the UI package does not create a circular or mandatory icon dependency. The Showcase uses Charcoal
Icons V2, while applications may inject product-specific artwork.
