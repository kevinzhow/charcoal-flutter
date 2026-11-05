# Theme contract

Status: frozen and in use. Every name below is **append-only**: add a role or a metric field in the
pull request that needs it (in `packages/charcoal_theme/lib/src/contract/`, plus the mapping in
`tokens/theme/charcoal.pack.json` and a `dart run tool/tokens.dart generate`), never rename or remove one.
`packages/charcoal_theme/test/frozen_names.txt` enforces this.

This contract is how the library is themed: `charcoal_ui` components read only these roles and metrics
through `CharcoalTheme.of(context)`, `buildCharcoalThemeData` fills Material's slots from the same pack,
and the extreme-theme test proves no component keeps a value of its own. Applications never read it; they
use `CharcoalTone`, `CharcoalTextTone`, `CharcoalTextRole`, `CharcoalSpace` and components (see
[Guards](guards.md)). Source revisions it was derived from: charcoal-flutter `de89016` (the pre-Material
library, see section 8) and the `myopay_theme` package of the first consumer. The architecture follows
`raft_theme`.

## 1. Shape

```
packages/charcoal_theme/
  lib/charcoal_theme.dart          public barrel
  lib/testing.dart                 extremePack(brightness): the pack the extreme-theme test mounts every scene under
  lib/src/theme.dart               CharcoalTheme extends ThemeExtension<CharcoalTheme>; .of(context); style(role); tone(tone)
  lib/src/pack.dart                CharcoalThemePack (name, brightness + the nine groups below)
  lib/src/contract/                colors space radius borders sizes motion elevation typography tones
  lib/src/contract/metrics/        one typed block per component family + metrics.dart (CharcoalMetrics)
  lib/src/packs/charcoal_pack.g.dart GENERATED from tokens/theme/charcoal.pack.json
  lib/src/packs/charcoal_metrics.dart hand-written per-family metrics shared by both packs
  lib/src/build/                   buildCharcoalThemeData, buildCharcoalTextTheme, buildCharcoalButtonStyle
  test/contract_test.dart          shape, packs, extremePack, CharcoalTheme, hygiene
  test/role_audit_test.dart        proves section 8 covers every read in charcoal_ui and targets exist
  test/frozen_names.txt            the 368 frozen names
```

Rules: values (colours, numbers, durations) exist only in `src/packs/`; `src/contract/` holds types and docs, no values (one exception: the constant `CharcoalColorRoles.transparent`).
`charcoal_theme` depends on `flutter` and `charcoal_tokens` only. `CharcoalTheme` lives in `ThemeData.extensions`; its `lerp` is discrete (as in `myopay_theme`).

Class names end in `Roles` / `Scale` / `Metrics`; `charcoal_ui` re-exports this package, so `package:charcoal_ui/charcoal_ui.dart`
is the single import for libraries and tests (applications do not use the theme classes at all).

| Group | Class | Access | Entries |
| --- | --- | --- | --- |
| colours | `CharcoalColorRoles` | `theme.colors.<role>` | 88 |
| spacing | `CharcoalSpaceScale` | `theme.space.<step>` | 8 |
| radii | `CharcoalRadiusScale` | `theme.radius.<step>` | 7 |
| line widths | `CharcoalBorderScale` | `theme.borders.<name>` | 4 |
| sizes | `CharcoalSizeScale` | `theme.sizes.<name>` | 36 |
| motion | `CharcoalMotionScale` | `theme.motion.<name>` | 8 |
| elevation | `CharcoalElevationScale` | `theme.elevation.<name>` | 2 |
| typography | `CharcoalTypeScale` + `CharcoalTextRole` + `CharcoalTextSpec` | `theme.style(role)`, `theme.typography.<role>` | 27 roles + 7 |
| tones | `CharcoalTone` + `CharcoalToneColors` | `theme.tone(tone)` | 5 (resolved from colour roles, not stored) |
| metrics | `CharcoalMetrics` + `Charcoal<Family>Metrics` | `theme.metrics.<family>.<field>` | 29 families, 127 fields |

## 2. Colour roles

88 roles: 55 kept from `MyoColors` under their myopay names (all of them), 33 added because the current `charcoal_ui` reads a colour myopay has no role for.
`CharcoalColorRoles.transparent` is a constant, not a role. Values below are the generated pack (`tokens/theme/charcoal.pack.json`): token references into `charcoal_tokens` (no copied hex), literals only where noted.

| Role | Origin | Upstream token (pack JSON) | Light | Dark | Meaning |
| --- | --- | --- | --- | --- | --- |
| `colors.background` | myopay | `backgroundDefault` | `#FFFFFFFF` | `#FF1F1F1F` | Page and dialog surface. |
| `colors.backgroundSecondary` | myopay | `backgroundSecondary` | `#FFF3F3F3` | `#FF151515` | Grey card / code-block surface. |
| `colors.backgroundTertiary` | myopay | `backgroundTertiary` | `#FFE8E8E8` | `#FF060606` | Deepest neutral surface. |
| `colors.scrim` | myopay | `backgroundOverlay` | `#53000000` | `#52000000` | Translucent layer over a page behind a floating surface. |
| `colors.barrier` | myopay | literal | `#99000000` | `#99000000` | Barrier behind a modal dialog. |
| `colors.pageBackdrop` | new | literal | `#FF000000` | `#FF000000` | Opaque colour under a page that is being covered or swiped away (faded by the route). |
| `colors.surface` | new | `containerDefault` | `#FFFFFFFF` | `#FF1F1F1F` | Opaque resting container fill (list rows, cards). |
| `colors.surfaceHover` | new | `containerHover` | `#FFF3F3F3` | `#FF292929` | Opaque container fill, hovered. |
| `colors.surfacePress` | new | `containerPress` | `#FFE8E8E8` | `#FF333333` | Opaque container fill, pressed. |
| `colors.surfaceSecondary` | myopay | `containerSecondaryDefault` | `#FFF3F3F3` | `#FF292929` | Opaque secondary container. |
| `colors.surfaceSecondaryHover` | new | `containerSecondaryHover` | `#FFE8E8E8` | `#FF333333` | Opaque secondary container, hovered. |
| `colors.surfaceSecondaryPress` | new | `containerSecondaryPress` | `#FFD9D9D9` | `#FF515151` | Opaque secondary container, pressed. |
| `colors.surfaceTertiary` | myopay | `containerTertiaryDefault` | `#FFE8E8E8` | `#FF333333` | Opaque tertiary container: avatar, meter track. |
| `colors.surfaceTertiaryPress` | new | `containerTertiaryPress` | `#FFC2C2C2` | `#FF707070` | Opaque tertiary container, pressed (pagination current page). |
| `colors.surfaceDisabled` | myopay | `containerDisable` | `#FFE8E8E8` | `#FF333333` | Disabled container fill. |
| `colors.fillSecondary` | myopay | `containerSecondaryDefaultA` | `#0C000000` | `#0BFFFFFF` | Translucent field / secondary button fill. |
| `colors.fillSecondaryHover` | myopay | `containerSecondaryHoverA` | `#17000000` | `#17FFFFFF` | Secondary fill, hovered. |
| `colors.fillSecondaryPress` | myopay | `containerSecondaryPressA` | `#26000000` | `#39FFFFFF` | Secondary fill, pressed. |
| `colors.restOverlay` | new | `containerDefaultA` | `#00000000` | `#00FFFFFF` | Row overlay at rest (fully transparent, but a real colour so it can cross-fade to the hover and press overlays). |
| `colors.hoverOverlay` | myopay | `containerHoverA` | `#0C000000` | `#0BFFFFFF` | Row hover overlay. |
| `colors.pressOverlay` | myopay | `containerPressA` | `#17000000` | `#17FFFFFF` | Row press overlay. |
| `colors.skeleton` | myopay | `containerSkeleton` | `#0C000000` | `#0BFFFFFF` | Loading placeholder fill. |
| `colors.fillOnImage` | new | `containerOnImgDefault` | `#53000000` | `#53000000` | Translucent control fill drawn over an image. |
| `colors.fillOnImageHover` | new | `containerOnImgHover` | `#6B000000` | `#6B000000` | Over-image control fill, hovered. |
| `colors.fillOnImagePress` | new | `containerOnImgPress` | `#8E000000` | `#8E000000` | Over-image control fill, pressed. |
| `colors.hud` | myopay | `containerHudDefault` | `#FF383838` | `#FFE4E4E4` | Toast / HUD fill. |
| `colors.hudHover` | new | `containerHudHover` | `#FF515151` | `#FFCACACA` | HUD fill, hovered. |
| `colors.hudPress` | new | `containerHudPress` | `#FF717171` | `#FFBCBCBC` | HUD fill, pressed. |
| `colors.border` | myopay | `borderDefault` | `#6B000000` | `#5CFFFFFF` | Control indicator outline (checkbox, radio). |
| `colors.borderSubtle` | myopay | `borderSecondary` | `#17000000` | `#17FFFFFF` | Structural separators: list rules, card outlines. |
| `colors.borderDisabled` | myopay | `borderDisable` | `#17000000` | `#0BFFFFFF` | Outline of a disabled control. |
| `colors.borderNegative` | myopay | `borderNegative` | `#FFFDCEC7` | `#FF88362E` | Outline of an invalid control. |
| `colors.borderSelected` | myopay | `borderSelected` | `#FF0096FA` | `#FF0872BE` | Outline of a selected control. |
| `colors.borderFocus` | myopay | `borderFocus1` | `#FF1F75BC` | `#FF72B5F5` | Keyboard focus outline on rows. |
| `colors.borderHud` | new | `borderHud` | `#FFFFFFFF` | `#FF1F1F1F` | Outline of a control drawn over an image or HUD (multi-select overlay variant). |
| `colors.focusRing` | myopay | `borderFocusLegacy` | `#520096FA` | `#520096FA` | Translucent ring (borders.focusHalo wide) around a focused field or button. |
| `colors.focusRingInner` | new | literal | `#FFFFFFFF` | `#FFFFFFFF` | Inner separator drawn between a control and its focus ring. |
| `colors.primary` | myopay | `containerPrimaryDefault` | `#FF0096FA` | `#FF0872BE` | Primary action fill. |
| `colors.primaryHover` | myopay | `containerPrimaryHover` | `#FF1F75BC` | `#FF3788D0` | Primary action fill, hovered. |
| `colors.primaryPress` | myopay | `containerPrimaryPress` | `#FF185182` | `#FF539CE0` | Primary action fill, pressed. |
| `colors.negative` | myopay | `containerNegativeDefault` | `#FFFD5B4E` | `#FFC53C33` | Destructive action fill. |
| `colors.negativeHover` | myopay | `containerNegativeHover` | `#FFCE362E` | `#FFD9584C` | Destructive action fill, hovered. |
| `colors.negativePress` | myopay | `containerNegativePress` | `#FF93211C` | `#FFE97266` | Destructive action fill, pressed. |
| `colors.positive` | myopay | `containerPositiveDefault` | `#FF25AA1C` | `#FF0D8105` | Positive status fill (dots, success toast). |
| `colors.notice` | myopay | `containerNoticeDefault` | `#FFFED63D` | `#FFEBB213` | Notice status fill. |
| `colors.neutral` | myopay | `containerNeutralDefault` | `#FF949494` | `#FF707070` | Neutral status fill (dots, switch track at rest). |
| `colors.neutralHover` | new | `containerNeutralHover` | `#FF717171` | `#FF828282` | Neutral fill, hovered. |
| `colors.neutralPress` | new | `containerNeutralPress` | `#FF515151` | `#FF979797` | Neutral fill, pressed. |
| `colors.positiveSurface` | myopay | literal | `#FFEAF8E8` | `#FF14301A` | Pale positive chip / banner surface (product tint, not an upstream token). |
| `colors.negativeSurface` | myopay | literal | `#FFFDF0ED` | `#FF3A1B1A` | Pale negative chip / banner surface (product tint). |
| `colors.infoSurface` | myopay | literal | `#FFECF4FD` | `#FF14273A` | Pale info chip / banner surface; selected row (product tint). |
| `colors.noticeSurface` | myopay | literal | `#FFFAF3DD` | `#FF33270D` | Pale notice chip / banner surface (product tint). |
| `colors.tagBackground` | new | literal | `#FF7ACCB1` | `#FF7ACCB1` | Tag fill when the caller passes no colour (authored by Charcoal iOS). |
| `colors.shadow` | new | literal | `#1A000000` | `#1A000000` | Soft drop shadow under a floating spinner. |
| `colors.text` | myopay | `textDefault` | `#FF1F1F1F` | `#FFE4E4E4` | Default text. |
| `colors.textHover` | new | `textHover` | `#FF383838` | `#FFCACACA` | Default text, hovered. |
| `colors.textPress` | new | `textPress` | `#FF515151` | `#FFBCBCBC` | Default text, pressed. |
| `colors.textSecondary` | myopay | `textSecondaryDefault` | `#FF515151` | `#FFAFAFAF` | Secondary text. |
| `colors.textSecondaryHover` | new | `textSecondaryHover` | `#FF383838` | `#FFBCBCBC` | Secondary text, hovered. |
| `colors.textSecondaryPress` | new | `textSecondaryPress` | `#FF1F1F1F` | `#FFCACACA` | Secondary text, pressed. |
| `colors.textTertiary` | myopay | `textTertiaryDefault` | `#FF717171` | `#FF828282` | Metadata and captions. |
| `colors.textTertiaryHover` | new | `textTertiaryHover` | `#FF515151` | `#FFAFAFAF` | Tertiary text, hovered. |
| `colors.textTertiaryPress` | new | `textTertiaryPress` | `#FF383838` | `#FFBCBCBC` | Tertiary text, pressed. |
| `colors.textPlaceholder` | myopay | `textPlaceholderDefault` | `#FF949494` | `#FF707070` | Field placeholder. |
| `colors.textDisabled` | myopay | `textDisable` | `#FFC2C2C2` | `#FF828282` | Disabled text. |
| `colors.textOnPrimary` | myopay | `textOnPrimaryDefault` | `#FFFFFFFF` | `#FFE4E4E4` | Text on a primary fill. |
| `colors.textOnNegative` | myopay | `textOnNegativeDefault` | `#FFFFFFFF` | `#FFE4E4E4` | Text on a negative fill. |
| `colors.textOnPositive` | new | `textOnPositiveDefault` | `#FFFFFFFF` | `#FFE4E4E4` | Text on a positive fill (success toast). |
| `colors.textOnHud` | myopay | `textOnHudDefault` | `#FFE4E4E4` | `#FF1F1F1F` | Text on a HUD fill. |
| `colors.textOnImage` | new | `textOnOnImgDefault` | `#FFFFFFFF` | `#FFE4E4E4` | Text on an over-image fill. |
| `colors.textPositive` | myopay | `textPositiveDefault` | `#FF118308` | `#FF78C271` | Positive status text. |
| `colors.textNegative` | myopay | `textNegativeDefault` | `#FFCE362E` | `#FFFC9386` | Negative status text and errors. |
| `colors.textNotice` | myopay | `textNoticeDefault` | `#FFA16309` | `#FFDEA71D` | Notice status text. |
| `colors.textInfo` | myopay | `textInfoDefault` | `#FF1F75BC` | `#FF72B5F5` | Info status text and links. |
| `colors.icon` | myopay | `iconDefault` | `#FF1F1F1F` | `#FFE4E4E4` | Default icon. |
| `colors.iconHover` | new | `iconHover` | `#FF383838` | `#FFCACACA` | Default icon, hovered. |
| `colors.iconPress` | new | `iconPress` | `#FF515151` | `#FFBCBCBC` | Default icon, pressed. |
| `colors.iconSecondary` | myopay | `iconSecondaryDefault` | `#FF515151` | `#FFAFAFAF` | Secondary icon. |
| `colors.iconTertiary` | myopay | `iconTertiaryDefault` | `#FF717171` | `#FF828282` | Tertiary icon: chevrons. |
| `colors.iconTertiaryHover` | new | `iconTertiaryHover` | `#FF515151` | `#FFAFAFAF` | Tertiary icon, hovered. |
| `colors.iconTertiaryPress` | new | `iconTertiaryPress` | `#FF383838` | `#FFBCBCBC` | Tertiary icon, pressed. |
| `colors.iconDisabled` | myopay | `iconDisable` | `#FFC2C2C2` | `#FF828282` | Disabled icon, empty-state art. |
| `colors.iconPositive` | myopay | `iconPositiveDefault` | `#FF118308` | `#FF78C271` | Positive icon. |
| `colors.iconNegative` | myopay | `iconNegativeDefault` | `#FFCE362E` | `#FFFC9386` | Negative icon. |
| `colors.iconNotice` | myopay | `iconNoticeDefault` | `#FFA16309` | `#FFDEA71D` | Notice icon. |
| `colors.iconOnPrimary` | myopay | `iconOnPrimaryDefault` | `#FFFFFFFF` | `#FFE4E4E4` | Icon or switch thumb on a primary fill. |
| `colors.iconOnImage` | new | `iconOnOnImgDefault` | `#FFFFFFFF` | `#FFE4E4E4` | Icon on an over-image fill. |
| `colors.iconHint` | new | literal | `#FF858585` | `#FF858585` | Fill of the hint-text info glyph (authored by Charcoal iOS 16/Info.pdf). |

## 3. Space, radius, borders, sizes, elevation

### 3.1 Space

| Name | Value | Source | Meaning |
| --- | --- | --- | --- |
| `space.xxs` | 2 | literal | Hairline gaps: between adjacent navigation items. |
| `space.xs` | 4 | `space.component10` | Tight gaps: icon and label, title and subtitle. |
| `space.sm` | 8 | `space.component20` | Gaps between sibling controls; inside chips and fields. |
| `space.md` | 12 | `space.component25` | Gaps between form fields; around banner content. |
| `space.lg` | 16 | `space.component30` | Card padding; viewport margin of floating surfaces. |
| `space.xl` | 24 | `space.component40` | Dialog padding; gaps between form sections. |
| `space.xxl` | 40 | `space.component50` | Section separation; empty-state padding. |
| `space.xxxl` | 64 | `space.layout60` | Page-level breathing room; tab-bar baseline height. |

## 3.2 Radius

| Name | Value | Source | Meaning |
| --- | --- | --- | --- |
| `radius.xs` | 2 | `radius.xs` | Meter tracks. |
| `radius.sm` | 4 | `radius.s` | Chips, fields and the selection box. |
| `radius.md` | 8 | `radius.m` | Cards, banners, tooltips and square avatars. |
| `radius.lg` | 12 | `radius.l` | Focus-ring corners of rounded controls. |
| `radius.xl` | 16 | `radius.xl` | Large surfaces. |
| `radius.xxl` | 24 | `radius.xxl` | Largest token radius. |
| `radius.pill` | 999999 | `radius.oval` | Fully rounded: buttons, circular avatars, switch tracks. |

## 3.3 Borders

| Name | Value | Source | Meaning |
| --- | --- | --- | --- |
| `borders.hairline` | 1 | `borderWidth.m` | List rules and card outlines. |
| `borders.thick` | 2 | `borderWidth.l` | Control indicator outlines. |
| `borders.focusRing` | 2 | `borderWidth.focus2` | Outline drawn around a focused or invalid field. |
| `borders.focusHalo` | 4 | literal | Width of the translucent halo (colors.focusRing) around a focused control. |

## 3.4 Sizes

| Name | Value | Source | Meaning |
| --- | --- | --- | --- |
| `sizes.iconSm` | 16 | literal | Inline icons: chevrons, button leading icons, field affordances. |
| `sizes.iconMd` | 20 | literal | Default icon size. |
| `sizes.iconLg` | 24 | literal | Banner icons. |
| `sizes.iconXl` | 48 | literal | Empty-state art. |
| `sizes.controlXs` | 24 | `space.targetXs` | Smallest hit target (selection box, indicator). |
| `sizes.controlSm` | 32 | `space.targetS` | Compact control height (small buttons). |
| `sizes.controlMd` | 40 | `space.targetM` | Standard control height (buttons, fields). |
| `sizes.controlLg` | 48 | `space.targetL` | Large hit target (dialog close button). |
| `sizes.fieldHeight` | 42 | literal | Minimum height of a text field. |
| `sizes.avatar` | 40 | literal | Default avatar edge. |
| `sizes.statusDot` | 10 | literal | Diameter of a status dot. |
| `sizes.indicatorSlot` | 20 | literal | Square slot shared by the status dot and the selection box. |
| `sizes.meterTrack` | 4 | literal | Height of a meter's track. |
| `sizes.rowMinHeight` | 56 | literal | Minimum height of a list row. |
| `sizes.contentMaxWidth` | 960 | literal | Maximum width of a page's content column. |
| `sizes.dialogMaxWidth` | 440 | `space.layout100` | Default dialog width. |
| `sizes.dialogInset` | 20 | literal | Padding around a dialog's content and actions. |
| `sizes.dialogTitleInset` | 48 | literal | Horizontal padding of a dialog's centred title, clearing the close button. |
| `sizes.dialogWideMaxWidth` | 560 | literal | Dialog width for code and log viewers. |
| `sizes.codeViewportMaxHeight` | 360 | literal | Height at which a code viewer starts scrolling. |
| `sizes.infoLabelWidth` | 96 | literal | Label column of a key/value table. |
| `sizes.toastMaxWidth` | 480 | literal | Maximum width of a toast. |
| `sizes.avatarSm` | 32 | literal | Compact avatar (account switcher, project rows). |
| `sizes.avatarLg` | 48 | literal | Large avatar (user header). |
| `sizes.rowMinHeightCompact` | 52 | literal | Minimum height of a compact action row. |
| `sizes.rowMinHeightTall` | 64 | literal | Minimum height of a two-line list row. |
| `sizes.formMaxWidth` | 392 | literal | Maximum width of the sign-in card. |
| `sizes.contentWideMaxWidth` | 1200 | literal | Maximum width of a wide page (tables, dense forms); never below `contentMaxWidth`. |
| `sizes.fieldWidthCompact` | 200 | literal | Width of a compact inline control. |
| `sizes.infoLabelWidthNarrow` | 72 | literal | Narrow label column of a key/value block. |
| `sizes.infoLabelWidthWide` | 112 | literal | Wide label column of a key/value block. |
| `sizes.brandMark` | 28 | literal | Edge of the product mark in the sidebar and sign-in. |
| `sizes.sidebarWidth` | 240 | literal | Width of the desktop sidebar. |
| `sizes.sidebarBreakpoint` | 900 | literal | Window width from which the sidebar replaces the tab bar. |
| `sizes.pageInsetWide` | 48 | literal | Horizontal page padding in the sidebar layout. |
| `sizes.sidebarInset` | 20 | literal | Padding of the sidebar header. |
| `sizes.infoLabelWidthExtraWide` | 128 | literal | Extra-wide label column of a key/value block. |

## 3.5 Elevation

| Name | Value | Source | Meaning |
| --- | --- | --- | --- |
| `elevation.surface` | 0 | literal | Cards and rows. |
| `elevation.overlay` | 0 | literal | Dialogs, menus and toasts. |

## 4. Motion

| Name | Value | Meaning |
| --- | --- | --- |
| `motion.fast` | `Duration(milliseconds: 120)` | Hover and press feedback. |
| `motion.standard` | `Duration(milliseconds: 200)` | Transitions of a control's state. |
| `motion.overlay` | `Duration(milliseconds: 250)` | Entrance and exit of dialogs, toasts and spinner overlays. |
| `motion.routeForward` | `Duration(milliseconds: 220)` | Page push transition. |
| `motion.routeReverse` | `Duration(milliseconds: 180)` | Page pop transition. |
| `motion.toastVisible` | `Duration(seconds: 2)` | How long a toast stays on screen. |
| `motion.curve` | `Cubic(0.2, 0, 0, 1)` | The one easing curve. |
| `motion.emphasizedCurve` | `Cubic(0.16, 1, 0.3, 1)` | Easing for entrances that should feel emphasised. |

## 5. Typography

`theme.style(role, {color, bold, mono})` builds the `TextStyle` (size + height multiplier only; never a text scaler). Default colour: `textTertiary` for `caption*`, else `text`.

| Role | Size / line | Weight | Source | Meaning |
| --- | --- | --- | --- | --- |
| `typography.pageTitle` | 25 / 32 | bold | console (myopay) | Page title. |
| `typography.modalTitle` | 20 / 28 | bold | console (myopay) | Dialog title and card values. |
| `typography.sectionTitle` | 16 / 24 | bold | console (myopay) | Section headings. |
| `typography.body` | 14 / 22 | regular | console (myopay) | Body text. |
| `typography.bodyBold` | 14 / 22 | bold | console (myopay) | Row titles and labels. |
| `typography.caption` | 12 / 18 | regular | console (myopay) | Metadata and sub-lines. |
| `typography.captionBold` | 12 / 18 | bold | console (myopay) | Chip labels and status text. |
| `typography.captionMono` | 12 / 18 | regular | console (myopay) | Identifiers and keys (monospace). |
| `typography.size10` | 10 / 18 | regular | numeric ladder | Numeric ladder 10/18 (CharcoalTypography size10). |
| `typography.size12` | 12 / 20 | regular | numeric ladder | Numeric ladder 12/20 (CharcoalTypography size12). |
| `typography.size14` | 14 / 22 | regular | numeric ladder | Numeric ladder 14/22 (CharcoalTypography size14). |
| `typography.size16` | 16 / 24 | regular | numeric ladder | Numeric ladder 16/24 (CharcoalTypography size16). |
| `typography.size20` | 20 / 28 | regular | numeric ladder | Numeric ladder 20/28 (CharcoalTypography size20). |
| `typography.bodyLarge` | token / token | regular | upstream token | Upstream body token, 16/24: the default text of an app. |
| `typography.bodyLargeBold` | token / token | bold | upstream token | Upstream bold body token, 16/24. |
| `typography.paragraph` | token / token | regular | upstream token | Long-form paragraph, 16/28. |
| `typography.captionMedium` | token / token | regular | upstream token | Upstream captionM token, 14/20. |
| `typography.captionMediumBold` | token / token | bold | upstream token | Upstream captionM token, bold: navigation-bar titles, checkbox labels. |
| `typography.headingXxxs` | token / token | bold | upstream token | Heading 14/20. |
| `typography.headingXxs` | token / token | bold | upstream token | Heading 18/24. |
| `typography.headingXs` | token / token | bold | upstream token | Heading 20/28. |
| `typography.headingS` | token / token | bold | upstream token | Heading 22/28. |
| `typography.headingM` | token / token | bold | upstream token | Heading 25/32. |
| `typography.headingL` | token / token | bold | upstream token | Heading 28/36. |
| `typography.headingXl` | token / token | bold | upstream token | Heading 32/40. |
| `typography.headingXxl` | token / token | bold | upstream token | Heading 36/44. |
| `typography.headingXxxl` | token / token | bold | upstream token | Heading 40/52. |

Also: `typography.weightRegular`, `typography.weightBold` (upstream `fontWeight`), `typography.sansFamily` (null = platform default), `typography.monoFamily`, `typography.appleTextFamily`, `typography.appleDisplayFamily`, `typography.appleDisplayFrom`.

## 6. Tones

| Tone | surface | foreground | dot | icon |
| --- | --- | --- | --- | --- |
| positive | positiveSurface | textPositive | positive | iconPositive |
| negative | negativeSurface | textNegative | negative | iconNegative |
| info | infoSurface | textInfo | primary | textInfo |
| notice | noticeSurface | textNotice | iconNotice | iconNotice |
| neutral | surfaceSecondary | textSecondary | neutral | iconSecondary |

## 7. Metrics (replace the private `_*Spec` constants)

Constants that became a shared role instead (all `animationDuration` -> `motion.standard`/`motion.overlay`, all `focusRingWidth` -> `borders.focusHalo`, colours -> colour roles, label sizes -> typography) are listed in section 8.4.

### 7.1 `metrics.button` (CharcoalButtonMetrics)

Geometry of the pill button beyond the shared control heights.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.button.iconSize` | double | 16 | `button:iconSize` | Leading and trailing icon edge. |
| `metrics.button.smallVerticalPadding` | double | 5 | `button:smallVerticalPadding` | Vertical padding of a small button. |
| `metrics.button.mediumVerticalPadding` | double | 9 | `button:mediumVerticalPadding` | Vertical padding of a medium button. |

### 7.2 `metrics.iconButton` (CharcoalIconButtonMetrics)

Icon-button hit areas and glyph sizes.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.iconButton.extraSmallSize` | double | 20 | `icon_button:extraSmallSize` | Edge of the extra-small icon button. |
| `metrics.iconButton.smallIconSize` | double | 16 | `icon_button:smallIconSize` | Glyph size of the small icon button. |
| `metrics.iconButton.regularIconSize` | double | 24 | `icon_button:regularIconSize` | Glyph size of the regular icon button. |

### 7.3 `metrics.switchToggle` (CharcoalSwitchMetrics)

The 51x31 switch (UISwitch geometry used by Charcoal SwiftUI).

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.switchToggle.trackWidth` | double | 51 | `switch:trackWidth` | Track width. |
| `metrics.switchToggle.trackHeight` | double | 31 | `switch:trackHeight` | Track height. |
| `metrics.switchToggle.trackInset` | double | 2 | `switch:trackInset` | Gap between track edge and thumb. |
| `metrics.switchToggle.thumbSize` | double | 27 | `switch:thumbSize` | Thumb diameter. |

### 7.4 `metrics.checkbox` (CharcoalCheckboxMetrics)

Checkbox box, check glyph and focus offsets.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.checkbox.controlSize` | double | 20 | `checkbox:controlSize` | Box edge. |
| `metrics.checkbox.roundedRadius` | double | 10 | `checkbox:roundedRadius` | Corner radius of the rounded variant. |
| `metrics.checkbox.checkSize` | double | 16 | `checkbox:checkSize` | Check glyph edge. |
| `metrics.checkbox.roundedFocusHaloWidth` | double | 6 | `checkbox:roundedFocusRingWidth` | Focus halo width of the rounded variant. |
| `metrics.checkbox.outerOffset` | double | 2 | `checkbox:outerOffset` | Distance from the box to the focus ring. |

### 7.5 `metrics.radio` (CharcoalRadioMetrics)

Radio button.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.radio.controlSize` | double | 20 | `radio:controlSize` | Outer circle diameter. |
| `metrics.radio.dotSize` | double | 8 | `radio:dotSize` | Selected dot diameter. |

### 7.6 `metrics.multiSelect` (CharcoalMultiSelectMetrics)

Multi-select selection box.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.multiSelect.controlSize` | double | 20 | `multi_select:controlSize` | Box edge. |
| `metrics.multiSelect.outerOffset` | double | 2 | `multi_select:outerOffset` | Distance from the box to the focus ring. |
| `metrics.multiSelect.checkSize` | double | 16 | `multi_select:checkSize` | Check glyph edge. |

### 7.7 `metrics.segmented` (CharcoalSegmentedMetrics)

Segmented control.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.segmented.uniformSegmentMinWidth` | double | 80 | `segmented_control:uniformSegmentMinWidth` | Minimum width of a segment in uniform layout. |

### 7.8 `metrics.tag` (CharcoalTagMetrics)

Tag item.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.tag.maxLabelWidth` | double | 152 | `tag_item:maxLabelWidth` | Label width at which the tag truncates. |
| `metrics.tag.iconSize` | double | 16 | `tag_item:iconSize` | Leading and trailing icon edge. |
| `metrics.tag.translatedLabelLineHeight` | double | 1.4 | `tag_item:translatedLabelLineHeight` | Line-height multiplier of a translated (non-Latin) label. |

### 7.9 `metrics.field` (CharcoalFieldMetrics)

Field label and secondary label.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.field.compactBreakpoint` | double | 240 | `field_label:compactBreakpoint` | Width below which the label stacks. |
| `metrics.field.lineHeight` | double | 22 | `field_label:lineHeight` | Label line height before text scaling. |
| `metrics.field.textScaleClampMax` | double | 2 | `field_label.dart:59` | Largest text-scale factor applied to label gaps. |
| `metrics.field.secondaryMaxWidthFraction` | double | 0.4 | `field_label.dart:121` | Share of the row the secondary label may take. |

### 7.10 `metrics.textField` (CharcoalTextFieldMetrics)

Single-line text field.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.textField.verticalPadding` | double | 10 | `text_field:verticalPadding` | Vertical padding inside the field. |
| `metrics.textField.contentGap` | double | 10 | `text_field:contentGap` | Gap between prefix, input and suffix. |
| `metrics.textField.iconSize` | double | 16 | `text_field:iconSize` | Affordance icon edge. |

### 7.11 `metrics.textArea` (CharcoalTextAreaMetrics)

Multi-line text area.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.textArea.horizontalInset` | double | 9 | `text_area:horizontalInset` | Horizontal padding. |
| `metrics.textArea.counterBottomInset` | double | 9 | `text_area:counterBottomInset` | Gap under the character counter. |
| `metrics.textArea.lineHeight` | double | 22 | `text_area:lineHeight` | Line height used to size the box before text scaling. |
| `metrics.textArea.verticalChrome` | double | 18 | `text_area:verticalChrome` | Vertical padding plus border around the lines. |
| `metrics.textArea.defaultRows` | int | 4 | `text_area.dart:47` | Rows shown when the caller passes none. |

### 7.12 `metrics.dropdown` (CharcoalDropdownMetrics)

Dropdown trigger and menu.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.dropdown.menuMaxHeight` | double | 280 | `dropdown:menuMaxHeight` | Menu height at which it starts scrolling. |
| `metrics.dropdown.iconSize` | double | 16 | `dropdown:iconSize` | Chevron icon edge. |

### 7.13 `metrics.hint` (CharcoalHintMetrics)

Hint text and its info glyph.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.hint.actionStackBreakpoint` | double | 240 | `hint_text:actionStackBreakpoint` | Width below which the action stacks under the text. |
| `metrics.hint.iconSize` | double | 16 | `hint_text:iconSize` | Info glyph edge (the vector art is drawn on this artboard). |

### 7.14 `metrics.spinner` (CharcoalSpinnerMetrics)

Loading spinner and its overlay.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.spinner.rotationDuration` | Duration | 1000 ms | `loading_spinner:animationDuration` | One revolution. |
| `metrics.spinner.shadowBlur` | double | 8 | `loading_spinner:shadowBlur` | Blur radius of the floating shadow. |

### 7.15 `metrics.modal` (CharcoalModalMetrics)

Dialog and bottom sheet.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.modal.initialScale` | double | 1.05 | `modal:initialScale` | Scale a dialog enters from. |
| `metrics.modal.minWidth` | double | 280 | `modal:minWidth` | Narrowest dialog. |
| `metrics.modal.cornerRadius` | double | 32 | `modal:cornerRadius` | Dialog corner radius. |
| `metrics.modal.titleHorizontalPadding` | double | 48 | `modal:titleHorizontalPadding` | Title padding that clears the close button. |
| `metrics.modal.actionPadding` | double | 20 | `modal:actionPadding` | Padding around the action row. |
| `metrics.modal.bottomSheetMinimumBottomPadding` | double | 30 | `modal:bottomSheetMinimumBottomPadding` | Least bottom padding of a bottom sheet. |
| `metrics.modal.closeIconSize` | double | 24 | `modal:closeIconSize` | Close glyph edge. |
| `metrics.modal.closeIconInset` | double | 6 | `modal:closeIconInset` | Inset of the close glyph within its hit area. |
| `metrics.modal.closeIconStrokeWidth` | double | 2 | `modal:closeIconStrokeWidth` | Stroke width of the close glyph. |
| `metrics.modal.exitFadeDuration` | Duration | 150 ms | `modal.dart:299` | Fade-out of a dismissed dialog. |
| `metrics.modal.smallWidth` | double | 320 | `dimensions.paragraphWidth.s` | Width of a small dialog. |
| `metrics.modal.mediumWidth` | double | 440 | `dimensions.space.layout100` | Width of a medium dialog. |
| `metrics.modal.largeWidth` | double | 672 | `dimensions.paragraphWidth.l` | Width of a large dialog. |

### 7.16 `metrics.toast` (CharcoalToastMetrics)

Toast and snack bar.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.toast.maxWidth` | double | 312 | `toast:maxWidth` | Widest toast. |
| `metrics.toast.cornerRadius` | double | 32 | `toast:cornerRadius` | Corner radius. |
| `metrics.toast.iconSize` | double | 16 | `toast:iconSize` | Leading icon edge. |
| `metrics.toast.toastScreenEdgeSpacing` | double | 96 | `toast:toastScreenEdgeSpacing` | Distance of a toast from the screen edge. |
| `metrics.toast.snackBarScreenEdgeSpacing` | double | 120 | `toast:snackBarScreenEdgeSpacing` | Distance of a snack bar from the screen edge. |
| `metrics.toast.dragDismissDistance` | double | 50 | `toast:dragDismissDistance` | Drag distance that dismisses. |
| `metrics.toast.dragDismissVelocity` | double | 100 | `toast:dragDismissVelocity` | Fling velocity that dismisses. |
| `metrics.toast.rubberBandLimit` | double | 60 | `toast:rubberBandLimit` | Asymptote of the rubber-band drag. |
| `metrics.toast.thumbnailSize` | double | 64 | `dimensions.space.layout60` | Edge of a snack bar's square thumbnail (appended in 2C). |

### 7.17 `metrics.tooltip` (CharcoalTooltipMetrics)

Tooltip bubble.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.tooltip.defaultWaitDuration` | Duration | 500 ms | `tooltip:defaultWaitDuration` | Hover time before the tooltip shows. |
| `metrics.tooltip.defaultMaxWidth` | double | 184 | `tooltip:defaultMaxWidth` | Widest tooltip. |
| `metrics.tooltip.arrowHeight` | double | 3 | `tooltip:arrowHeight` | Arrow height. |
| `metrics.tooltip.arrowHalfWidth` | double | 5 | `tooltip:arrowHalfWidth` | Half the arrow base. |

### 7.18 `metrics.balloon` (CharcoalBalloonMetrics)

Balloon (popover with arrow and close).

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.balloon.defaultMaxWidth` | double | 240 | `balloon:defaultMaxWidth` | Widest balloon. |
| `metrics.balloon.arrowHeight` | double | 4 | `balloon:arrowHeight` | Arrow height. |
| `metrics.balloon.arrowHalfWidth` | double | 7 | `balloon:arrowHalfWidth` | Half the arrow base. |
| `metrics.balloon.strokeWidth` | double | 2 | `balloon:strokeWidth` | Outline width. |
| `metrics.balloon.closeGap` | double | 5 | `balloon:closeGap` | Gap before the close button. |
| `metrics.balloon.closeVisualSize` | double | 22 | `balloon:closeVisualSize` | Close button visual edge. |
| `metrics.balloon.closeIconSize` | double | 16 | `balloon:closeIconSize` | Close glyph edge. |
| `metrics.balloon.closeIconInset` | double | 4 | `balloon:closeIconInset` | Inset of the close glyph. |
| `metrics.balloon.closeIconStrokeWidth` | double | 1.5 | `balloon:closeIconStrokeWidth` | Close glyph stroke. |
| `metrics.balloon.actionVerticalPadding` | double | 3 | `balloon:actionVerticalPadding` | Vertical padding of the action link. |

### 7.19 `metrics.carousel` (CharcoalCarouselMetrics)

Carousel.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.carousel.navigationFadeDuration` | Duration | 400 ms | `carousel:navigationFadeDuration` | Fade of the previous/next zones. |
| `metrics.carousel.scrollDuration` | Duration | 300 ms | `carousel:scrollDuration` | Animated page change. |
| `metrics.carousel.mediumViewportFraction` | double | 0.75 | `carousel:mediumViewportFraction` | Viewport fraction of the medium size. |
| `metrics.carousel.navigationZoneWidth` | double | 72 | `carousel:navigationZoneWidth` | Width of each navigation zone. |

### 7.20 `metrics.pagination` (CharcoalPaginationMetrics)

Pagination.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.pagination.cornerRadius` | double | 20 | `pagination:cornerRadius` | Page-button corner radius. |
| `metrics.pagination.defaultMaxVisiblePages` | int | 7 | `pagination.dart:37` | Pages shown when the caller passes no limit (odd, >= 3). |

### 7.21 `metrics.navigationItem` (CharcoalNavigationItemMetrics)

Navigation row.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.navigationItem.leadingIconSize` | double | 24 | `navigation_item:leadingIconSize` | Leading icon edge. |
| `metrics.navigationItem.trailingIconSize` | double | 16 | `navigation_item:trailingIconSize` | Trailing chevron edge. |

### 7.22 `metrics.tabBar` (CharcoalTabBarMetrics)

Bottom tab bar.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.tabBar.badgeFontSize` | double | 9 | `tab_bar:badgeFontSize` | Badge label size. |
| `metrics.tabBar.badgeMinExtent` | double | 16 | `tab_bar:badgeMinExtent` | Least badge edge. |
| `metrics.tabBar.iconSize` | double | 20 | `tab_bar:iconSize` | Tab icon edge. |
| `metrics.tabBar.labelFontSize` | double | 10 | `tab_bar:labelFontSize` | Tab label size. |
| `metrics.tabBar.badgeOffsetEnd` | double | -10 | `tab_bar.dart:253` | Badge position from the icon end edge (negative: outside). |
| `metrics.tabBar.badgeOffsetTop` | double | -7 | `tab_bar.dart:254` | Badge position from the icon top edge (negative: outside). |

### 7.23 `metrics.navigationBar` (CharcoalNavigationBarMetrics)

Top navigation bar.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.navigationBar.height` | double | 56 | `navigation_bar:height` | Bar height at text scale 1. |
| `metrics.navigationBar.minTitleExtent` | double | 96 | `navigation_bar:minTitleExtent` | Least title width. |
| `metrics.navigationBar.titleScaleBase` | double | 20 | `navigation_bar.dart:49` | Title size scaled by the text scaler to grow the bar. |
| `metrics.navigationBar.verticalChrome` | double | 24 | `navigation_bar.dart:49` | Padding added to the scaled title to get the bar height. |

### 7.24 `metrics.clickable` (CharcoalClickableMetrics)

Shared interaction behaviour.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.clickable.keyboardActivationDuration` | Duration | 100 ms | `clickable:keyboardActivationDuration` | How long a key activation shows the pressed state. |
| `metrics.clickable.disabledOpacity` | double | 0.32 | `interaction_state.dart:6` | Opacity of a disabled control. |

### 7.25 `metrics.popup` (CharcoalPopupMetrics)

Popup shape painter (tooltip and balloon outline).

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.popup.seamOverlap` | double | 0.5 | `popup_shape.dart:123` | Overlap that hides the seam between body and arrow. |

### 7.26 `metrics.textEditing` (CharcoalTextEditingMetrics)

Text editing chrome shared by fields: cursor, handles, magnifier.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.textEditing.scrollPadding` | double | 20 | `text_field.dart:33`, `text_area.dart:34`, `text_editing.dart:35` | Padding kept visible around the caret when scrolling into view. |
| `metrics.textEditing.cursorRadius` | double | 2 | `text_editing.dart:138` | Cursor corner radius on Apple platforms. |
| `metrics.textEditing.handleSize` | double | 22 | `text_editing.dart:159`, `text_editing.dart:178` | Selection handle edge. |
| `metrics.textEditing.handleAnchorX` | double | 11 | `text_editing.dart:163` | Horizontal anchor of the handle. |
| `metrics.textEditing.handleInnerSize` | double | 14 | `text_editing.dart:183` | Edge of the visible handle dot. |
| `metrics.textEditing.magnifierWidth` | double | 112 | `text_editing.dart:212` | Magnifier width. |
| `metrics.textEditing.magnifierHeight` | double | 48 | `text_editing.dart:212` | Magnifier height. |
| `metrics.textEditing.magnifierFocalOffset` | double | 76 | `text_editing.dart:216` | Distance of the magnifier above the touch point. |
| `metrics.textEditing.magnifierScale` | double | 1.3 | `text_editing.dart:223` | Magnification factor. |

### 7.27 `metrics.selectionToolbar` (CharcoalSelectionToolbarMetrics)

Text selection toolbar placement.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.selectionToolbar.edgeInset` | double | 8 | `text_selection_toolbar.dart:41` | Least distance from the screen edge. |
| `metrics.selectionToolbar.anchorAboveGap` | double | 8 | `text_selection_toolbar.dart:53` | Gap above the primary anchor. |
| `metrics.selectionToolbar.anchorBelowGap` | double | 16 | `text_selection_toolbar.dart:55` | Gap below the secondary anchor. |
| `metrics.selectionToolbar.padding` | double | 4 | `text_selection_toolbar.dart:66` | Padding inside the toolbar. |

### 7.28 `metrics.pageRoute` (CharcoalPageRouteMetrics)

Page transition and predictive back.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.pageRoute.edgeGestureWidth` | double | 20 | `charcoal_page_route:_edgeWidth` | Width of the edge swipe-back zone. |
| `metrics.pageRoute.horizontalEnterOffset` | double | 0.035 | `charcoal_page_route.dart:278` | Entering page slide (fraction of width). |
| `metrics.pageRoute.verticalEnterOffset` | double | 0.025 | `charcoal_page_route.dart:279` | Entering page slide, vertical axis (fraction of height). |
| `metrics.pageRoute.horizontalSecondaryOffset` | double | -0.012 | `charcoal_page_route.dart:282` | Covered page slide (fraction of width, sign flips in RTL). |
| `metrics.pageRoute.verticalSecondaryOffset` | double | -0.008 | `charcoal_page_route.dart:283` | Covered page slide, vertical axis. |
| `metrics.pageRoute.secondaryParallax` | double | -0.28 | `charcoal_page_route.dart:344` | Covered page parallax in the platform-style transition. |
| `metrics.pageRoute.secondaryScrimOpacity` | double | 0.1 | `charcoal_page_route.dart:345` | Opacity of colors.pageBackdrop over the covered page. |
| `metrics.pageRoute.commitThreshold` | double | 0.5 | `charcoal_page_route.dart:159` | Back-gesture progress past which the pop commits. |
| `metrics.pageRoute.flingVelocityThreshold` | double | 1.0 | `charcoal_page_route.dart:156` | Fling velocity that commits regardless of progress. |
| `metrics.pageRoute.predictiveShiftDivisor` | double | 20 | `charcoal_page_route.dart:662` | Window size divisor for the predictive-back drift. |
| `metrics.pageRoute.predictiveShiftInset` | double | 8 | `charcoal_page_route.dart:662` | Margin subtracted from the predictive-back drift. |
| `metrics.pageRoute.predictiveScaleDrop` | double | 0.1 | `charcoal_page_route.dart:682` | Scale lost at full predictive-back progress. |
| `metrics.pageRoute.predictiveCornerRadius` | double | 32 | `charcoal_page_route.dart:683` | Corner radius at full predictive-back progress. |
| `metrics.pageRoute.predictiveExitOffsetFraction` | double | 0.1 | `charcoal_page_route.dart:691` | Exit slide as a fraction of window height. |

### 7.29 `metrics.scaffold` (CharcoalScaffoldMetrics)

Scaffold and system chrome.

| Field | Type | Value | Replaces | Meaning |
| --- | --- | --- | --- | --- |
| `metrics.scaffold.darkLuminanceThreshold` | double | 0.179 | `charcoal_scaffold.dart:63` | Background luminance below which system icons turn light. |

## 8. Role audit (historical: every read in the pre-Material `charcoal_ui` at `de89016`)

This audit mapped each value the legacy components read to a contract entry before the components were rebuilt. The legacy
sources are deleted; the tables stay as the record of where each role and metric came from, and `test/role_audit_test.dart`
still checks that every mapping target is a real contract name. Row keys use the old spelling (`theme.colors.X`, `theme.dimensions.X`, `file.dart#CONST`); the last column is the contract entry. `test/role_audit_test.dart` re-scans the sources and fails when a read is missing from these tables or a target is not a contract name.

### 8.1 Colour accessors

74 distinct `colors.X` reads, all mapped (to 61 distinct roles).

| Read | Used by | Contract entry | Note |
| --- | --- | --- | --- |
| `theme.colors.backgroundDefault` | charcoal_scaffold, dropdown x2, loading_spinner, modal, navigation_bar, tab_bar x3, text_area, text_field, text_selection_toolbar, toast x2 | `colors.background` |  |
| `theme.colors.borderDefault` | checkbox, radio, toast | `colors.border` |  |
| `theme.colors.borderFocus1` | carousel | `colors.borderFocus` |  |
| `theme.colors.borderFocusLegacy` | balloon, button x2, carousel, checkbox, dropdown, icon_button, multi_select, navigation_item, pagination, radio, switch, tab_bar, tag_item, text_area x2, text_field x2 | `colors.focusRing` |  |
| `theme.colors.borderHud` | multi_select | `colors.borderHud` |  |
| `theme.colors.borderNegative` | checkbox, dropdown, multi_select x2, radio, text_area, text_field | `colors.borderNegative` |  |
| `theme.colors.borderSecondary` | dropdown, navigation_bar, tab_bar, text_editing, text_selection_toolbar | `colors.borderSubtle` |  |
| `theme.colors.containerDefault` | radio | `colors.surface` |  |
| `theme.colors.containerDefaultA` | checkbox, icon_button, navigation_item x2, pagination, tab_bar | `colors.restOverlay` |  |
| `theme.colors.containerHover` | radio | `colors.surfaceHover` |  |
| `theme.colors.containerHoverA` | button, icon_button, tag_item | `colors.hoverOverlay` |  |
| `theme.colors.containerHudDefault` | button, pagination, tooltip | `colors.hud` |  |
| `theme.colors.containerHudHover` | button | `colors.hudHover` |  |
| `theme.colors.containerHudPress` | button | `colors.hudPress` |  |
| `theme.colors.containerNegativeDefault` | button, tab_bar, toast | `colors.negative` |  |
| `theme.colors.containerNegativeHover` | button | `colors.negativeHover` |  |
| `theme.colors.containerNegativePress` | button | `colors.negativePress` |  |
| `theme.colors.containerNeutralDefault` | multi_select, switch | `colors.neutral` |  |
| `theme.colors.containerNeutralHover` | multi_select x2, switch | `colors.neutralHover` |  |
| `theme.colors.containerNeutralPress` | multi_select x2, switch | `colors.neutralPress` |  |
| `theme.colors.containerOnImgDefault` | balloon x2, button, icon_button, multi_select, tag_item | `colors.fillOnImage` |  |
| `theme.colors.containerOnImgHover` | balloon, button, icon_button, tag_item | `colors.fillOnImageHover` |  |
| `theme.colors.containerOnImgPress` | balloon, button, icon_button, tag_item | `colors.fillOnImagePress` |  |
| `theme.colors.containerPositiveDefault` | toast | `colors.positive` |  |
| `theme.colors.containerPress` | radio | `colors.surfacePress` |  |
| `theme.colors.containerPressA` | button, icon_button, tag_item | `colors.pressOverlay` |  |
| `theme.colors.containerPrimaryDefault` | balloon, button, charcoal_app, checkbox, multi_select, radio, segmented_control, switch, text_area, text_editing, text_field | `colors.primary` |  |
| `theme.colors.containerPrimaryHover` | button, checkbox, multi_select, radio, switch | `colors.primaryHover` |  |
| `theme.colors.containerPrimaryPress` | button, checkbox, multi_select, radio, switch | `colors.primaryPress` |  |
| `theme.colors.containerSecondaryDefault` | checkbox, dropdown, hint_text, navigation_item, pagination, tag_item | `colors.surfaceSecondary` |  |
| `theme.colors.containerSecondaryDefaultA` | button, dropdown x2, segmented_control, tab_bar, text_area, text_field | `colors.fillSecondary` |  |
| `theme.colors.containerSecondaryHover` | checkbox, tag_item | `colors.surfaceSecondaryHover` |  |
| `theme.colors.containerSecondaryHoverA` | button, dropdown, navigation_item, tab_bar, text_area | `colors.fillSecondaryHover` |  |
| `theme.colors.containerSecondaryPress` | checkbox, dropdown, tag_item | `colors.surfaceSecondaryPress` |  |
| `theme.colors.containerSecondaryPressA` | button, dropdown x2, navigation_item, tab_bar, text_area | `colors.fillSecondaryPress` |  |
| `theme.colors.containerTertiaryPress` | pagination | `colors.surfaceTertiaryPress` |  |
| `theme.colors.iconDefault` | hint_text, modal x2, navigation_item, tab_bar | `colors.icon` |  |
| `theme.colors.iconHover` | navigation_item | `colors.iconHover` |  |
| `theme.colors.iconOnOnImgDefault` | balloon, icon_button, tag_item | `colors.iconOnImage` |  |
| `theme.colors.iconOnOnImgHover` | balloon, icon_button, tag_item | `colors.iconOnImage` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.iconOnOnImgPress` | balloon, icon_button, tag_item | `colors.iconOnImage` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.iconOnPrimaryDefault` | balloon, checkbox, multi_select, radio, switch, tag_item | `colors.iconOnPrimary` |  |
| `theme.colors.iconOnPrimaryHover` | checkbox, radio, switch, tag_item | `colors.iconOnPrimary` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.iconOnPrimaryPress` | checkbox, radio, switch, tag_item | `colors.iconOnPrimary` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.iconPress` | navigation_item | `colors.iconPress` |  |
| `theme.colors.iconSecondaryDefault` | dropdown x2, navigation_item | `colors.iconSecondary` |  |
| `theme.colors.iconTertiaryDefault` | icon_button, loading_spinner, tab_bar | `colors.iconTertiary` |  |
| `theme.colors.iconTertiaryHover` | icon_button, tab_bar | `colors.iconTertiaryHover` |  |
| `theme.colors.iconTertiaryPress` | icon_button, tab_bar | `colors.iconTertiaryPress` |  |
| `theme.colors.textDefault` | button x2, carousel x2, charcoal_app, checkbox, dropdown, hint_text, multi_select, navigation_bar, navigation_item, radio, switch, tab_bar, toast | `colors.text` |  |
| `theme.colors.textDefaultText1` | field_label, modal, typography | `colors.text` | same value as textDefault in light and dark; the "Text1" name is a Figma leftover |
| `theme.colors.textHover` | button, navigation_item | `colors.textHover` |  |
| `theme.colors.textNegativeDefault` | dropdown, text_area, text_field x2 | `colors.textNegative` |  |
| `theme.colors.textOnHudDefault` | button, pagination, tooltip | `colors.textOnHud` |  |
| `theme.colors.textOnHudHover` | button | `colors.textOnHud` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnHudPress` | button | `colors.textOnHud` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnNegativeDefault` | button, tab_bar, toast | `colors.textOnNegative` |  |
| `theme.colors.textOnNegativeHover` | button | `colors.textOnNegative` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnNegativePress` | button | `colors.textOnNegative` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnOnImgDefault` | button, tag_item | `colors.textOnImage` |  |
| `theme.colors.textOnOnImgHover` | button, tag_item | `colors.textOnImage` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnOnImgPress` | button, tag_item | `colors.textOnImage` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnPositiveDefault` | toast | `colors.textOnPositive` |  |
| `theme.colors.textOnPrimaryDefault` | balloon, button, segmented_control, tag_item | `colors.textOnPrimary` |  |
| `theme.colors.textOnPrimaryHover` | button, tag_item | `colors.textOnPrimary` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textOnPrimaryPress` | button, tag_item | `colors.textOnPrimary` | upstream value is identical in every state and both brightnesses; collapsed to the default role |
| `theme.colors.textPlaceholderDefault` | dropdown, text_area, text_field | `colors.textPlaceholder` |  |
| `theme.colors.textPress` | navigation_item | `colors.textPress` |  |
| `theme.colors.textSecondaryDefault` | button, carousel, dropdown x2, field_label, navigation_item, segmented_control, tag_item, text_area x2, text_field x4 | `colors.textSecondary` |  |
| `theme.colors.textSecondaryHover` | button, tag_item | `colors.textSecondaryHover` |  |
| `theme.colors.textSecondaryPress` | button, tag_item | `colors.textSecondaryPress` |  |
| `theme.colors.textTertiaryDefault` | button, carousel x2, dropdown, field_label, pagination x2, tab_bar, text_area, text_field | `colors.textTertiary` |  |
| `theme.colors.textTertiaryHover` | tab_bar | `colors.textTertiaryHover` |  |
| `theme.colors.textTertiaryPress` | pagination, tab_bar | `colors.textTertiaryPress` |  |

### 8.2 Dimension accessors

23 distinct leaf accessors under `theme.dimensions` (the plan estimated 27; the rest were aliases such as `final space = theme.dimensions.space`), all mapped.

| Read | Used by | Contract entry | Note |
| --- | --- | --- | --- |
| `theme.dimensions.borderWidth.focus2` | balloon, tab_bar | `borders.focusRing` |  |
| `theme.dimensions.borderWidth.l` | carousel x2, checkbox x3, multi_select, radio, toast | `borders.thick` |  |
| `theme.dimensions.borderWidth.m` | dropdown, navigation_bar, tab_bar x2, toast | `borders.hairline` |  |
| `theme.dimensions.paragraphWidth.l` | modal | `metrics.modal.largeWidth` | large dialog width |
| `theme.dimensions.paragraphWidth.s` | modal | `metrics.modal.smallWidth` | small dialog width |
| `theme.dimensions.radius.l` | checkbox | `radius.lg` | focus-ring corner of the rounded checkbox |
| `theme.dimensions.radius.m` | dropdown, hint_text, loading_spinner, navigation_item x2 | `radius.md` |  |
| `theme.dimensions.radius.oval` | balloon, button, carousel x2, icon_button, multi_select x2, radio x2, switch, tab_bar | `radius.pill` |  |
| `theme.dimensions.radius.s` | button, checkbox, dropdown, tag_item, text_area, text_editing, text_field, text_selection_toolbar, tooltip | `radius.sm` |  |
| `theme.dimensions.radius.xl` | balloon, segmented_control x2 | `radius.xl` |  |
| `theme.dimensions.space.component10` | balloon x3, button, checkbox, dropdown x4, field_label, hint_text, multi_select, radio, switch, tab_bar x3, text_area, tooltip x3 | `space.xs` |  |
| `theme.dimensions.space.component20` | carousel x4, dropdown x3, field_label, modal, navigation_item x2, switch, tab_bar, tag_item x2, text_area, text_field x2, toast x2 | `space.sm` |  |
| `theme.dimensions.space.component25` | balloon, hint_text, navigation_item, toast, tooltip x2 | `space.md` |  |
| `theme.dimensions.space.component30` | balloon, button x2, dropdown x2, hint_text, loading_spinner, navigation_bar, segmented_control, tag_item x2, toast x2 | `space.lg` |  |
| `theme.dimensions.space.component40` | button, tag_item, toast | `space.xl` |  |
| `theme.dimensions.space.layout100` | modal | `metrics.modal.mediumWidth` | medium dialog width |
| `theme.dimensions.space.layout30` | balloon x2, dropdown, toast x2, tooltip | `space.lg` | viewport margin of floating surfaces (dropdown, tooltip, balloon, toast) |
| `theme.dimensions.space.layout40` | modal | `space.xl` | dialog centre padding |
| `theme.dimensions.space.layout60` | tab_bar, toast | `space.xxxl` | tab-bar baseline height; toast icon slot |
| `theme.dimensions.space.targetL` | loading_spinner, modal, navigation_bar x2 | `sizes.controlLg` |  |
| `theme.dimensions.space.targetM` | button x2, carousel, dropdown x3, icon_button, navigation_item, pagination x3, tag_item | `sizes.controlMd` |  |
| `theme.dimensions.space.targetS` | button, icon_button, pagination x3, segmented_control, tag_item | `sizes.controlSm` |  |
| `theme.dimensions.space.targetXs` | checkbox x2, multi_select x2, navigation_item | `sizes.controlXs` |  |

### 8.3 Typography accessors

| Read | Used by | Contract entry | Note |
| --- | --- | --- | --- |
| `theme.textStyles.body` | charcoal_app | `typography.bodyLarge` | upstream body token, 16/24 (not myopay `body`, which is 14/22) |
| `theme.textStyles.captionMediumBold` | navigation_bar | `typography.captionMediumBold` |  |
| `theme.textStyles.captionSmall` | tab_bar x2 | `typography.caption` | captionS token 12/18 equals myopay `caption` |
| `theme.typography.fontWeight.regular` | typography | `typography.weightRegular` |  |
| `theme.typography.fontWeight.bold` | typography | `typography.weightBold` |  |
| `theme.typography.fontFamily.sans (via resolveCharcoalSansFont)` | typography, charcoal_text_styles | `typography.sansFamily` | platform mapping moves to `typography.appleTextFamily/appleDisplayFamily/appleDisplayFrom` |
| `CharcoalTypographySize.size10..size20 ladder (10/18, 12/20, 14/22, 16/24, 20/28)` | typography | `typography.size10` | also `size12`, `size14`, `size16`, `size20` |
| `monospace family literal` | typography | `typography.monoFamily` |  |

The other 13 `CharcoalTextStyles` getters (`bodyBold`, `paragraph`, `captionMedium`, `captionMediumBold`, nine `heading*`) are not read by components but exist as roles so the showcase and apps lose nothing.

### 8.4 Private geometry constants

125 `static const` values in `components/` and `app/` (the plan counted 122 with an `= (Duration|EdgeInsets|Color|number)` pattern; three more are declared differently: `_edgeWidth`, `defaultConfiguration`, and the top-level `charcoalDisabledOpacity`). All mapped: 86 to `metrics.*` fields, 39 to shared roles.

| Read | Value | Contract entry | Note |
| --- | --- | --- | --- |
| `balloon.dart#actionVerticalPadding` | `3.0` | `metrics.balloon.actionVerticalPadding` | |
| `balloon.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `balloon.dart#arrowHalfWidth` | `7.0` | `metrics.balloon.arrowHalfWidth` | |
| `balloon.dart#arrowHeight` | `4.0` | `metrics.balloon.arrowHeight` | |
| `balloon.dart#closeGap` | `5.0` | `metrics.balloon.closeGap` | |
| `balloon.dart#closeIconInset` | `4.0` | `metrics.balloon.closeIconInset` | |
| `balloon.dart#closeIconSize` | `16.0` | `metrics.balloon.closeIconSize` | |
| `balloon.dart#closeIconStrokeWidth` | `1.5` | `metrics.balloon.closeIconStrokeWidth` | |
| `balloon.dart#closeVisualSize` | `22.0` | `metrics.balloon.closeVisualSize` | |
| `balloon.dart#defaultMaxWidth` | `240.0` | `metrics.balloon.defaultMaxWidth` | |
| `balloon.dart#strokeWidth` | `2.0` | `metrics.balloon.strokeWidth` | |
| `button.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `button.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `button.dart#iconSize` | `16.0` | `metrics.button.iconSize` | |
| `button.dart#mediumVerticalPadding` | `9.0` | `metrics.button.mediumVerticalPadding` | |
| `button.dart#smallVerticalPadding` | `5.0` | `metrics.button.smallVerticalPadding` | |
| `carousel.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `carousel.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `carousel.dart#mediumViewportFraction` | `0.75` | `metrics.carousel.mediumViewportFraction` | |
| `carousel.dart#navigationFadeDuration` | `Duration(milliseconds: 400)` | `metrics.carousel.navigationFadeDuration` | |
| `carousel.dart#navigationZoneWidth` | `72.0` | `metrics.carousel.navigationZoneWidth` | |
| `carousel.dart#scrollDuration` | `Duration(milliseconds: 300)` | `metrics.carousel.scrollDuration` | |
| `charcoal_page_route.dart#_edgeWidth` | `20.0` | `metrics.pageRoute.edgeGestureWidth` | |
| `checkbox.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `checkbox.dart#checkSize` | `16.0` | `metrics.checkbox.checkSize` | |
| `checkbox.dart#controlSize` | `20.0` | `metrics.checkbox.controlSize` | |
| `checkbox.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `checkbox.dart#labelFontSize` | `14.0` | `typography.captionMedium.fontSize` | |
| `checkbox.dart#labelLineHeight` | `20.0` | `typography.captionMedium.lineHeight` | |
| `checkbox.dart#outerOffset` | `2.0` | `metrics.checkbox.outerOffset` | |
| `checkbox.dart#roundedFocusRingWidth` | `6.0` | `metrics.checkbox.roundedFocusHaloWidth` | |
| `checkbox.dart#roundedRadius` | `10.0` | `metrics.checkbox.roundedRadius` | |
| `clickable.dart#keyboardActivationDuration` | `Duration(milliseconds: 100)` | `metrics.clickable.keyboardActivationDuration` | |
| `dropdown.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `dropdown.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `dropdown.dart#iconSize` | `16.0` | `metrics.dropdown.iconSize` | |
| `dropdown.dart#menuMaxHeight` | `280.0` | `metrics.dropdown.menuMaxHeight` | |
| `field_label.dart#compactBreakpoint` | `240.0` | `metrics.field.compactBreakpoint` | |
| `field_label.dart#lineHeight` | `22.0` | `metrics.field.lineHeight` | |
| `hint_text.dart#actionStackBreakpoint` | `240.0` | `metrics.hint.actionStackBreakpoint` | |
| `hint_text.dart#iconSize` | `16.0` | `metrics.hint.iconSize` | |
| `hint_text.dart#infoIconColor` | `Color(0xFF858585)` | `colors.iconHint` | |
| `hint_text.dart#textSize` | `14.0` | `typography.captionMedium.fontSize` | |
| `icon_button.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `icon_button.dart#extraSmallSize` | `20.0` | `metrics.iconButton.extraSmallSize` | |
| `icon_button.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `icon_button.dart#regularIconSize` | `24.0` | `metrics.iconButton.regularIconSize` | |
| `icon_button.dart#smallIconSize` | `16.0` | `metrics.iconButton.smallIconSize` | |
| `interaction_state.dart#charcoalDisabledOpacity` | `0.32` | `metrics.clickable.disabledOpacity` | |
| `loading_spinner.dart#animationDuration` | `Duration(seconds: 1)` | `metrics.spinner.rotationDuration` | |
| `loading_spinner.dart#overlayDuration` | `Duration(milliseconds: 250)` | `motion.overlay` | |
| `loading_spinner.dart#shadowBlur` | `8.0` | `metrics.spinner.shadowBlur` | |
| `modal.dart#actionPadding` | `20.0` | `metrics.modal.actionPadding` | |
| `modal.dart#animationDuration` | `Duration(milliseconds: 250)` | `motion.overlay` | |
| `modal.dart#barrierColor` | `Color(0x99000000)` | `colors.barrier` | |
| `modal.dart#bottomSheetMinimumBottomPadding` | `30.0` | `metrics.modal.bottomSheetMinimumBottomPadding` | |
| `modal.dart#closeIconInset` | `6.0` | `metrics.modal.closeIconInset` | |
| `modal.dart#closeIconSize` | `24.0` | `metrics.modal.closeIconSize` | |
| `modal.dart#closeIconStrokeWidth` | `2.0` | `metrics.modal.closeIconStrokeWidth` | |
| `modal.dart#cornerRadius` | `32.0` | `metrics.modal.cornerRadius` | |
| `modal.dart#initialScale` | `1.05` | `metrics.modal.initialScale` | |
| `modal.dart#minWidth` | `280.0` | `metrics.modal.minWidth` | |
| `modal.dart#titleHorizontalPadding` | `48.0` | `metrics.modal.titleHorizontalPadding` | |
| `multi_select.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `multi_select.dart#checkSize` | `16.0` | `metrics.multiSelect.checkSize` | |
| `multi_select.dart#controlSize` | `20.0` | `metrics.multiSelect.controlSize` | |
| `multi_select.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `multi_select.dart#outerOffset` | `2.0` | `metrics.multiSelect.outerOffset` | |
| `navigation_bar.dart#height` | `56.0` | `metrics.navigationBar.height` | |
| `navigation_bar.dart#minTitleExtent` | `96.0` | `metrics.navigationBar.minTitleExtent` | |
| `navigation_item.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `navigation_item.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `navigation_item.dart#leadingIconSize` | `24.0` | `metrics.navigationItem.leadingIconSize` | |
| `navigation_item.dart#trailingIconSize` | `16.0` | `metrics.navigationItem.trailingIconSize` | |
| `pagination.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `pagination.dart#cornerRadius` | `20.0` | `metrics.pagination.cornerRadius` | |
| `pagination.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `radio.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `radio.dart#controlSize` | `20.0` | `metrics.radio.controlSize` | |
| `radio.dart#dotSize` | `8.0` | `metrics.radio.dotSize` | |
| `radio.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `segmented_control.dart#uniformSegmentMinWidth` | `80.0` | `metrics.segmented.uniformSegmentMinWidth` | |
| `switch.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `switch.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `switch.dart#thumbSize` | `27.0` | `metrics.switchToggle.thumbSize` | |
| `switch.dart#trackHeight` | `31.0` | `metrics.switchToggle.trackHeight` | |
| `switch.dart#trackInset` | `2.0` | `metrics.switchToggle.trackInset` | |
| `switch.dart#trackWidth` | `51.0` | `metrics.switchToggle.trackWidth` | |
| `tab_bar.dart#badgeFontSize` | `9.0` | `metrics.tabBar.badgeFontSize` | |
| `tab_bar.dart#badgeMinExtent` | `16.0` | `metrics.tabBar.badgeMinExtent` | |
| `tab_bar.dart#iconSize` | `20.0` | `metrics.tabBar.iconSize` | |
| `tab_bar.dart#labelFontSize` | `10.0` | `metrics.tabBar.labelFontSize` | |
| `tag_item.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `tag_item.dart#defaultBackground` | `Color(0xFF7ACCB1)` | `colors.tagBackground` | |
| `tag_item.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `tag_item.dart#iconSize` | `16.0` | `metrics.tag.iconSize` | |
| `tag_item.dart#maxLabelWidth` | `152.0` | `metrics.tag.maxLabelWidth` | |
| `tag_item.dart#translatedLabelLineHeight` | `1.4` | `metrics.tag.translatedLabelLineHeight` | |
| `text_area.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `text_area.dart#counterBottomInset` | `9.0` | `metrics.textArea.counterBottomInset` | |
| `text_area.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `text_area.dart#horizontalInset` | `9.0` | `metrics.textArea.horizontalInset` | |
| `text_area.dart#lineHeight` | `22.0` | `metrics.textArea.lineHeight` | |
| `text_area.dart#verticalChrome` | `18.0` | `metrics.textArea.verticalChrome` | |
| `text_field.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `text_field.dart#contentGap` | `10.0` | `metrics.textField.contentGap` | |
| `text_field.dart#focusRingWidth` | `4.0` | `borders.focusHalo` | |
| `text_field.dart#iconSize` | `16.0` | `metrics.textField.iconSize` | |
| `text_field.dart#verticalPadding` | `10.0` | `metrics.textField.verticalPadding` | |
| `toast.dart#cornerRadius` | `32.0` | `metrics.toast.cornerRadius` | |
| `toast.dart#defaultConfiguration` | `CharcoalToastAnimationConfiguration()` | exempt | not a literal (const CharcoalToastAnimationConfiguration(), an API object) |
| `toast.dart#dismissDuration` | `Duration(seconds: 2)` | `motion.toastVisible` | |
| `toast.dart#dragDismissDistance` | `50.0` | `metrics.toast.dragDismissDistance` | |
| `toast.dart#dragDismissVelocity` | `100.0` | `metrics.toast.dragDismissVelocity` | |
| `toast.dart#iconSize` | `16.0` | `metrics.toast.iconSize` | |
| `toast.dart#maxWidth` | `312.0` | `metrics.toast.maxWidth` | |
| `toast.dart#rubberBandLimit` | `60.0` | `metrics.toast.rubberBandLimit` | |
| `toast.dart#snackBarScreenEdgeSpacing` | `120.0` | `metrics.toast.snackBarScreenEdgeSpacing` | |
| `toast.dart#toastScreenEdgeSpacing` | `96.0` | `metrics.toast.toastScreenEdgeSpacing` | |
| `toast.dart#transitionDuration` | `Duration(milliseconds: 250)` | `motion.overlay` | |
| `tooltip.dart#animationDuration` | `Duration(milliseconds: 200)` | `motion.standard` | |
| `tooltip.dart#arrowHalfWidth` | `5.0` | `metrics.tooltip.arrowHalfWidth` | |
| `tooltip.dart#arrowHeight` | `3.0` | `metrics.tooltip.arrowHeight` | |
| `tooltip.dart#defaultMaxWidth` | `184.0` | `metrics.tooltip.defaultMaxWidth` | |
| `tooltip.dart#defaultWaitDuration` | `Duration(milliseconds: 500)` | `metrics.tooltip.defaultWaitDuration` | |

### 8.5 Inline literals that are not `static const`

Line numbers are at `de89016` (the legacy files no longer exist); the targets are what matter. These are not machine-checked against the source (the checked tables are 8.1-8.4).

| Read | Value | Contract entry | Note |
| --- | --- | --- | --- |
| `loading_spinner.dart:176` | `Color(0x1A000000)` | `colors.shadow` | spinner drop shadow |
| `checkbox.dart:101` | `Color(0x00000000)` | `colors.transparent` | constant `CharcoalColorRoles.transparent` |
| `checkbox.dart:151` | `Color(0xFFFFFFFF)` | `colors.focusRingInner` | inner separator of the focus ring |
| `charcoal_page_route.dart:362` | `Color(0xFF000000)` | `colors.pageBackdrop` | faded by metrics.pageRoute.secondaryScrimOpacity |
| `charcoal_scaffold.dart:67-69` | `Color(0x00000000)` x3 | `colors.transparent` | system bar colours; constant `CharcoalColorRoles.transparent` |
| `tab_bar.dart:269` | `FontWeight.w700 / w400` | `typography.weightBold` | active label; inactive uses `typography.weightRegular` |
| `tab_bar.dart:315` | `FontWeight.w700` | `typography.weightBold` | badge label |
| `modal.dart:168-170` | dialog widths | `metrics.modal.smallWidth` | see 8.2 (`smallWidth`, `mediumWidth`, `largeWidth`) |
| `charcoal_page_route.dart:156` | | `metrics.pageRoute.flingVelocityThreshold` | |
| `charcoal_page_route.dart:159` | | `metrics.pageRoute.commitThreshold` | |
| `charcoal_page_route.dart:278` | | `metrics.pageRoute.horizontalEnterOffset` | |
| `charcoal_page_route.dart:279` | | `metrics.pageRoute.verticalEnterOffset` | |
| `charcoal_page_route.dart:282` | | `metrics.pageRoute.horizontalSecondaryOffset` | |
| `charcoal_page_route.dart:283` | | `metrics.pageRoute.verticalSecondaryOffset` | |
| `charcoal_page_route.dart:344` | | `metrics.pageRoute.secondaryParallax` | |
| `charcoal_page_route.dart:345` | | `metrics.pageRoute.secondaryScrimOpacity` | |
| `charcoal_page_route.dart:662` | | `metrics.pageRoute.predictiveShiftDivisor`, `metrics.pageRoute.predictiveShiftInset` | |
| `charcoal_page_route.dart:682` | | `metrics.pageRoute.predictiveScaleDrop` | |
| `charcoal_page_route.dart:683` | | `metrics.pageRoute.predictiveCornerRadius` | |
| `charcoal_page_route.dart:691` | | `metrics.pageRoute.predictiveExitOffsetFraction` | |
| `charcoal_scaffold.dart:63` | | `metrics.scaffold.darkLuminanceThreshold` | |
| `field_label.dart:121` | | `metrics.field.secondaryMaxWidthFraction` | |
| `field_label.dart:59` | | `metrics.field.textScaleClampMax` | |
| `interaction_state.dart:6` | | `metrics.clickable.disabledOpacity` | |
| `modal.dart:299` | | `metrics.modal.exitFadeDuration` | |
| `navigation_bar.dart:49` | | `metrics.navigationBar.titleScaleBase`, `metrics.navigationBar.verticalChrome` | |
| `pagination.dart:37` | | `metrics.pagination.defaultMaxVisiblePages` | |
| `popup_shape.dart:123` | | `metrics.popup.seamOverlap` | |
| `tab_bar.dart:253` | | `metrics.tabBar.badgeOffsetEnd` | |
| `tab_bar.dart:254` | | `metrics.tabBar.badgeOffsetTop` | |
| `text_area.dart:34` | | `metrics.textEditing.scrollPadding` | |
| `text_area.dart:47` | | `metrics.textArea.defaultRows` | |
| `text_editing.dart:138` | | `metrics.textEditing.cursorRadius` | |
| `text_editing.dart:159` | | `metrics.textEditing.handleSize` | |
| `text_editing.dart:163` | | `metrics.textEditing.handleAnchorX` | |
| `text_editing.dart:178` | | `metrics.textEditing.handleSize` | |
| `text_editing.dart:183` | | `metrics.textEditing.handleInnerSize` | |
| `text_editing.dart:212` | | `metrics.textEditing.magnifierWidth`, `metrics.textEditing.magnifierHeight` | |
| `text_editing.dart:216` | | `metrics.textEditing.magnifierFocalOffset` | |
| `text_editing.dart:223` | | `metrics.textEditing.magnifierScale` | |
| `text_editing.dart:35` | | `metrics.textEditing.scrollPadding` | |
| `text_field.dart:33` | | `metrics.textEditing.scrollPadding` | |
| `text_selection_toolbar.dart:41` | | `metrics.selectionToolbar.edgeInset` | |
| `text_selection_toolbar.dart:53` | | `metrics.selectionToolbar.anchorAboveGap` | |
| `text_selection_toolbar.dart:55` | | `metrics.selectionToolbar.anchorBelowGap` | |
| `text_selection_toolbar.dart:66` | | `metrics.selectionToolbar.padding` | |
| `hint_text.dart:34-41` | vector path of the 16x16 info glyph | exempt | artwork transcribed from Charcoal iOS `16/Info.pdf`; the artboard is `metrics.hint.iconSize`, the fill is `colors.iconHint`; path coordinates stay in the component (exemption E1) |

### 8.6 Exemptions (not theme values)

- **E1** hint-text info glyph path coordinates (artwork, see 8.5).
- **E2** structural values: `0`, `1`, `-1` as alignment, opacity end points, `maxLines`, list indices and `clamp` bounds.
- **E3** algorithm tolerances: `0.0001` division guard in the predictive-back commit, `assert` bounds (`maxVisiblePages >= 3`).
- **E4** curve choices inside the page route (`Curves.easeOut`, `Curves.easeInOutCubicEmphasized`); the contract carries the two named curves in `motion`, the page route keeps these two.
- **E5** `toast.dart#defaultConfiguration` is an API object, not a number.

### 8.7 Coverage

| Kind | Read in source | Mapped | Unmapped |
| --- | --- | --- | --- |
| `colors.X` accessors | 74 | 74 | 0 |
| dimension leaf accessors | 23 | 23 | 0 |
| typography accessors | 8 | 8 | 0 |
| `static const` geometry | 125 | 125 (86 metrics, 38 shared roles, 1 exempt) | 0 |
| inline literals listed in 8.5 | 47 | 47 (1 exempt) | 0 |

## 9. Naming decisions

1. **Class names.** `CharcoalColorRoles`, `CharcoalSpaceScale`, `CharcoalRadiusScale`, `CharcoalBorderScale`, `CharcoalSizeScale`, `CharcoalMotionScale`, `CharcoalElevationScale`, `CharcoalTypeScale` instead of myopay's `Myo*` or the obvious `CharcoalMotion` / `CharcoalTypography`, which already exist in `charcoal_ui` (the typography widget, the motion constants). Cost: slightly longer names.
2. **Role count.** `MyoColors` has 55 roles, not 53 as in the plan; all 55 are kept under their names. 33 roles are new, giving 88.
3. **`radius.lg`.** myopay `radius.lg` is 32 (dialog corner). Upstream `radius.l` is 12, which the checkbox focus ring reads. The scale follows upstream (`xs 2, sm 4, md 8, lg 12, xl 16, xxl 24, pill`); the 32 lives in `metrics.modal.cornerRadius` and `metrics.toast.cornerRadius`. myopay call sites of `radius.lg` must change in phase 4. Alternative: keep `lg = 32` and name the 12 something else.
4. **`motion.toastVisible`.** myopay 3 s, Charcoal `_ToastSpec.dismissDuration` 2 s. The pack uses 2 s (library look); myopay can pass its own duration.
5. **State-invariant roles collapsed.** 18 accessors (`textOnPrimary{Default,Hover,Press}`, `textOnNegative*`, `textOnHud*`, `textOnOnImg*`, `iconOnPrimary*`, `iconOnOnImg*`) have identical values in every state and both brightnesses upstream. They map to one role each (`textOnPrimary`, `textOnNegative`, `textOnHud`, `textOnImage`, `iconOnPrimary`, `iconOnImage`). Pixel-identical today; a pack cannot give them separate hover/press colours until a role is appended.
6. **`textDefaultText1`.** Maps to `text` (same value as `textDefault`; the name is a Figma leftover).
7. **Over-image naming.** Upstream `*OnImg*` becomes `fillOnImage*` (translucent container), `textOnImage`, `iconOnImage`. Upstream `borderHud` keeps its name as `borderHud` (it is the outline of the overlay multi-select, equal to the background colour).
8. **One halo width.** The 12 identical `focusRingWidth = 4` constants became `borders.focusHalo`; the checkbox's 6 px rounded halo is `metrics.checkbox.roundedFocusHaloWidth`. A pack cannot give one family a different halo until a metric is appended.
9. **Two shared durations.** 15 x 200 ms `animationDuration` -> `motion.standard`; 3 x 250 ms (dialog, spinner overlay, toast) -> `motion.overlay`. Same append-only caveat.
10. **Dialog widths.** In `metrics.modal` (`smallWidth 320`, `mediumWidth 440`, `largeWidth 672`), from `paragraphWidth.s`, `space.layout100`, `paragraphWidth.l`. myopay's `sizes.dialogMaxWidth` (440) is kept as well and is equal to `mediumWidth` by construction.
11. **Typography.** 27 roles because three vocabularies collide: console roles (`body` = 14/22), the iOS numeric ladder (`size12` = 12/20, not myopay `caption` 12/18), and upstream tokens (`bodyLarge` = 16/24 is upstream `body`). `bodyLarge` is the app default text.
12. **`switchToggle`.** `switch` is a reserved word, so the accessor is `metrics.switchToggle` (class `CharcoalSwitchMetrics`).
13. **Disabled opacity.** `charcoalDisabledOpacity` (0.32) is `metrics.clickable.disabledOpacity`.
14. **Tones.** Resolved from colour roles like `MyoTone`; `info` uses `primary` for its dot, as myopay does.
15. **Pack interpolation.** None: the theme switches at the animation midpoint (as `MyoTheme`).
16. **Pack (generated).** Reads `charcoal_tokens` by field name instead of copying hex; the 55 myopay roles resolve to exactly the values myopay carries today (checked light and dark). Literals only, as `extensions` in the pack JSON (both modes required), for the ten colour roles `barrier`, `pageBackdrop`, `focusRingInner`, `shadow`, `tagBackground`, `iconHint` and the four product tints; plain numbers (also in the JSON) for `space.xxs`, `borders.focusHalo` and the product sizes.
