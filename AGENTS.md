<!-- charcoal-agent:start version=0.1.0 profile=contributor -->
## Charcoal UI agent workflow

- Discover components before coding: `fvm dart run packages/charcoal_cli/bin/charcoal.dart search <intent>`.
- For a new, redesigned, or multi-state page, load the installed `charcoal-page-design` skill and validate its Page Experience Spec with `fvm dart run packages/charcoal_cli/bin/charcoal.dart page-spec --validate <path>`.
- For a multi-surface app or Agent Ready example, inventory every destination, detail, task, modal, overlay, and durable result before implementation; map real destination/route/task enums so new states cannot bypass review, then validate the final evidence with `fvm dart run packages/charcoal_cli/bin/charcoal.dart app-review --validate <path>`.
- Model navigation effects explicitly: top-level destination selection keeps one stable root route, details and transient tasks push, durable completion replaces obsolete task history, and back pops or dismisses; bind every transition to executable evidence.
- Keep controlled selection atomic: one state owner must update the previous and next selected visuals, semantics, and controlled content in the same frame. Treat touch as `down → cancel or accepted tap`: down changes only an independent pressed layer, cancel has no persistent effect, and an accepted tap commits selection. State-only paint layers must preserve target bounds, icon and label centers, and text baselines; test geometry through every phase and assert the first post-activation frame before `pumpAndSettle` can hide a double highlight, stale-selection flash, or layout jump.
- Discover reviewed multi-component compositions before authoring local UI: `fvm dart run packages/charcoal_cli/bin/charcoal.dart pattern <intent>`.
- Read exact installed APIs and examples: `fvm dart run packages/charcoal_cli/bin/charcoal.dart component <name>`.
- Find theme roles by meaning: `fvm dart run packages/charcoal_cli/bin/charcoal.dart token <intent>`. Roles are read by library code only; application code never reads or passes a colour, size, or type value. Use `--tier primitive` only for library and theme-pack work.
- Import `package:charcoal_ui/charcoal_ui.dart` (and `package:charcoal_ui/admin.dart` for admin-console pieces) and use Charcoal components where available.
- Compose layouts with Flutter primitives such as `Row`, `Column`, `Padding`, and `LayoutBuilder`.
- For UI work, use Flutter Widget Previewer before the full app: filter to the exact component or selected preview file, verify public/shared components in isolation, then deterministic page-state previews at compact and standard constraints; reserve full Showcase runs for navigation and platform integration.
- For Flutter UI runs, interaction, hot reload, screenshots, and end-to-end verification, prefer the Dart/Flutter skill tooling first; use `agent-device` only when platform-level automation is specifically required.
- `charcoal_ui` is built on Material (`CharcoalApp` is a `MaterialApp`) and owns all styling. Applications compose Charcoal components and never construct visual values.
- Composition versus styling: visual values (colour, type, size, radius, border, shadow, spacing) always come from the library; composition of library components, product logic, strings, and data are the application's own extension. When a needed visual value or component is missing, ask for it in the library instead of styling locally.
- Consumer rules for application code (enforce them with a source guard):
  - R1 Imports: UI code imports only `package:charcoal_ui/charcoal_ui.dart`, `package:charcoal_ui/admin.dart`, `package:charcoal_icons/charcoal_icons.dart`, `flutter/widgets.dart`, and `flutter/services.dart`; never `flutter/material.dart`, `flutter/cupertino.dart`, `charcoal_theme`, or `charcoal_tokens`.
  - R2 No theme work: never build or read `ThemeData`, `ColorScheme`, `TextTheme`, `Theme.of`, `DefaultTextStyle`, `IconTheme`, `InputDecoration`, `ButtonStyle`, `WidgetStateProperty`, `CharcoalThemePack`, `buildCharcoalThemeData`, or `CharcoalTheme.of`; the look is changed in the library, not in the app.
  - R3 Text: no `TextStyle`, `FontWeight`, or font size, family, weight, or spacing parameters; show text with `CharcoalText(role:, tone:)`.
  - R4 Colour: no `Color(...)`, `Colors.*`, `CupertinoColors.*`, opacity helpers, or colour parameters such as `color:` and `backgroundColor:`; express meaning with `CharcoalTone`, `CharcoalTextTone`, and `CharcoalIconTone`.
  - R5 Decoration: no `BoxDecoration`, `ShapeDecoration`, `BoxShadow`, `Border`, `BorderRadius`, `RoundedRectangleBorder`, gradients, or `CustomPainter`; surfaces come from `CharcoalCard`, `CharcoalList`, and other components.
  - R6 Size and spacing: no numeric sizes, `EdgeInsets`, `Duration` literals, or `const double` dimensions; use `CharcoalGap(CharcoalSpace.md)`, `CharcoalInset`, `CharcoalPadding`, and `CharcoalWrap`.
  - R7 Controls: never construct a raw Material or Cupertino control or helper (`ElevatedButton`, `TextField`, `Switch`, `AlertDialog`, `Scaffold`, `Card`, `showDialog`, and so on); use the Charcoal counterpart.
  - R8 Dependencies: depend on `charcoal_ui` pinned to a tag or commit, and not on `charcoal_theme` or `charcoal_tokens` directly.
  - R9 No escape hatches: a `theme-guard: allow` pragma is never acceptable.
- Preserve labels, semantics, focus behavior, text scaling, and compact/desktop layout behavior.
- Do not claim Agent Ready from a core flow alone. Executable runtime scenarios must collectively visit every inventoried surface, and every surface must pass all seven design rules plus the app-wide final review.
- Run `fvm dart run packages/charcoal_cli/bin/charcoal.dart doctor`, static analysis, and relevant Flutter tests before handing off.
- Architecture: `charcoal_theme` owns the theme contract and generated packs (Material `ThemeData` plus the `CharcoalTheme` extension); `charcoal_ui` is hosted by Material (`CharcoalApp` wraps `MaterialApp`), wraps Material widgets only where Material supplies the behaviour, and re-exports the theme; `admin.dart` holds admin-console pieces.
- Inside `charcoal_ui` the library source guard applies instead of R1-R9: no colour, size, duration, or text-style literals and no `Theme.of`, `ColorScheme`, or `TextTheme` reads; read values with `CharcoalTheme.of(context)`, keep one implementation per component family, and extend the theme contract (`tokens/theme/charcoal.pack.json`) rather than adding a literal.
- Public component APIs are platform-neutral; upstream provenance belongs in maintainer source contracts.
- After a public API or curated example changes, regenerate the catalog and run its `--check` mode.
- Generate isolated candidate/grader evidence with `fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark-run`; never repair candidates manually.
- Score recorded Agent Ready evidence with `fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark --results <path>`; complete comparisons may not use `--allow-partial`.
- Do not add runtime recipe abstractions. Catalog patterns and examples are documentation, not rendering code.
<!-- charcoal-agent:end -->
