# charcoal_ui

Charcoal V2 components for Flutter, built on Material. The package includes controls, form fields,
dropdowns, overlays, navigation components, layout and status surfaces, and interaction primitives.
It owns all styling: every colour, size, radius, border, duration and text style is read from the
theme (`charcoal_theme`, re-exported from `charcoal_ui.dart`), never written in a component, and a
source guard plus an extreme-theme test enforce that. The package bundles no font assets. Apple
native targets use their system text and display families; Web and other targets defer to Flutter's
renderer default, and a brand font is set on the pack (`CharcoalTypeScale.sansFamily`).

Entry points: `package:charcoal_ui/charcoal_ui.dart` (components, `CharcoalApp`, theme contract),
`package:charcoal_ui/admin.dart` (admin-console shell, page frame, stat card, meter, info rows, batch
bar) and `package:charcoal_ui/testing.dart` (`extremePack` and `CharcoalScene` for guard tests).

`CharcoalApp` is a thin wrapper over `MaterialApp` and supports both Navigator-based named routes and
declarative `CharcoalApp.router` configuration. Both entry points install the pack-built light and
dark `ThemeData`, the application localization delegates (followed by the framework's global ones),
keyboard shortcuts, platform-adaptive scrolling, Hero controller, restoration scope and the Charcoal
page route. Application code never builds a `ThemeData`: it composes components, names spacing with
`CharcoalSpace`, text with `CharcoalText` roles and tones, and meaning with `CharcoalTone`. See
[Guards](../../docs/guards.md) for the consumer rules R1 to R9.

Each widget reads colours, scales and its family metrics from `CharcoalTheme.of(context)`. See the
workspace [README](../../README.md) for architecture, source contracts, setup, previews, and
testing, and [Theme contract](../../docs/theme-contract.md) for the roles and metrics.

Machine consumers should use `charcoal_catalog`, `charcoal_cli`, or the read-only `charcoal_mcp`
adapter. Those packages document this public API without adding a tooling or recipe dependency to
the `charcoal_ui` runtime package.

For visual development, run `fvm flutter widget-preview start` from this package before composing
pages. The previews in `lib/src/previews/` render production components in light and dark modes
inside a real `CharcoalApp`. Continue with the Example package's deterministic page previews, and
reserve a full Showcase launch for routing or platform integration. The workspace
[Widget Preview workflow](../../docs/widget-preview-workflow.md) defines the gates.
