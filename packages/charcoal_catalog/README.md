# Charcoal Catalog

`charcoal_catalog` is the versioned, machine-readable description of the public
`charcoal_ui` API and generated foundations. It combines component declarations extracted from
Dart source with reviewed usage guidance and executable examples, then indexes every public token
with its tier, kind, exact Dart accessor, and resolved light/dark values.

Shared deterministic search defaults to semantic tokens. Primitive values remain queryable for
audited foundation work, but callers must opt into the primitive tier explicitly. CLI and MCP
adapters both consume this package instead of maintaining their own documentation inventories.

Regenerate it from the workspace root:

```sh
dart run packages/charcoal_catalog/tool/generate_catalog.dart
```

CI can detect stale output without changing files:

```sh
dart run packages/charcoal_catalog/tool/generate_catalog.dart --check
```
