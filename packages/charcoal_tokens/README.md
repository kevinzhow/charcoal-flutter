# charcoal_tokens

Strongly typed Flutter representations of Charcoal V2 foundation tokens.

This package is generated from the pinned JSON sources in the workspace root. Run
`fvm dart run tool/tokens.dart update --ref <ref>` from the root to update it. Components should
consume semantic colors instead of `CharcoalPrimitiveColors`. Generated groups expose typed
catalogs and `copyWith` methods for controlled foundation overrides.
