# charcoal_ui

Charcoal V2 components implemented directly on Flutter Widgets. The package includes controls,
form fields, dropdowns, overlays, navigation components, themes, and interaction primitives. It is
an independent package with no Material or Cupertino dependency.

The public theme contains generated foundations only. Each widget maps semantic foundation values
to a private component specification and keeps source-specific geometry beside its implementation.
See the workspace [README](../../README.md) for architecture, source contracts, setup, previews,
and testing.

Machine consumers should use `charcoal_catalog`, `charcoal_cli`, or the read-only `charcoal_mcp`
adapter. Those packages document this public API without adding a tooling or recipe dependency to
the `charcoal_ui` runtime package.
