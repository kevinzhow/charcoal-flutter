# charcoal_theme

Theme contract for Charcoal UI on Flutter Material: colour roles, scales, per-family metrics,
`CharcoalThemePack` and `CharcoalTheme` (a `ThemeExtension`).

Batch 1.1 froze the names; see `docs/theme-contract.md` in the repository root. The packs
`charcoalLightPack` / `charcoalDarkPack` are generated from `tokens/theme/charcoal.pack.json` by
`dart run tool/tokens.dart generate` (see `docs/token-pipeline.md`); `buildCharcoalThemeData(pack)` turns a
pack into a Material `ThemeData`.
