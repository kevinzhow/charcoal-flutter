# Charcoal Catalog

`charcoal_catalog` is the versioned, machine-readable description of the public `charcoal_ui` API
(`charcoal_ui.dart` and `admin.dart`) and its theme contract. It combines component declarations
extracted from Dart source with reviewed usage guidance (every public component is curated, in
per-family fragments under `tool/src/metadata/`) and executable examples, then indexes every public
token with its tier, kind, exact Dart accessor, and resolved light/dark values.

A token is `semantic` when `tokens/theme/charcoal.pack.json` gives it a theme role: its accessor is
that role (`CharcoalTheme.of(context).space.md`, read by library code) and its guidance names the
route an application takes (`CharcoalGap(CharcoalSpace.md)`, `CharcoalText(tone:)`). Palette values and
upstream tokens that no role references are `primitive`; they are for library and theme-pack work.
Shared deterministic search defaults to the semantic tier and callers must opt into the primitive
tier explicitly. CLI and MCP adapters both consume this package instead of maintaining their own
documentation inventories.

Supporting building blocks (`CharcoalEditableText`, `CharcoalFieldRing`, ...) are listed under the
`Supporting` category so their signatures are discoverable; their summaries say which parent
component an application should use instead. A component's `tokenRoles` may only cite roles of the
pack; the generator fails otherwise.

Regenerate it from the workspace root:

```sh
dart run packages/charcoal_catalog/tool/generate_catalog.dart
```

CI can detect stale output without changing files:

```sh
dart run packages/charcoal_catalog/tool/generate_catalog.dart --check
```
