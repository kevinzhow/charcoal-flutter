# charcoal_ui

Charcoal V2 components implemented directly on Flutter Widgets. The package includes controls,
form fields, dropdowns, overlays, navigation components, themes, and interaction primitives. It is
an independent package with no Material or Cupertino dependency and no bundled font assets. Default
typography follows the host platform's system sans-serif family; applications can still provide a
font-family override through `CharcoalThemeData`.

The public theme contains generated foundations only. Each widget maps semantic foundation values
to a private component specification and keeps source-specific geometry beside its implementation.
See the workspace [README](../../README.md) for architecture, source contracts, setup, previews,
and testing.

Machine consumers should use `charcoal_catalog`, `charcoal_cli`, or the read-only `charcoal_mcp`
adapter. Those packages document this public API without adding a tooling or recipe dependency to
the `charcoal_ui` runtime package.

For visual development, run `fvm flutter widget-preview start` from this package before composing
pages. The previews in `lib/src/previews/` render production components in light and dark modes
inside a real `CharcoalApp`. Continue with the Example package's deterministic page previews, and
reserve a full Showcase launch for routing or platform integration. The workspace
[Widget Preview workflow](../../docs/widget-preview-workflow.md) defines the gates.
