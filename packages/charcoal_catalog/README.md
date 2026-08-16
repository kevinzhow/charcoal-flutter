# Charcoal Catalog

`charcoal_catalog` is the versioned, machine-readable description of the public
`charcoal_ui` API. It combines API declarations extracted from Dart source with reviewed usage
guidance and executable examples.

Regenerate it from the workspace root:

```sh
dart run packages/charcoal_catalog/tool/generate_catalog.dart
```

CI can detect stale output without changing files:

```sh
dart run packages/charcoal_catalog/tool/generate_catalog.dart --check
```
