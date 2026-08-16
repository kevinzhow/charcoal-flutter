# CharcoalSans runtime fonts

`CharcoalSans-Regular.ttf` and `CharcoalSans-Bold.ttf` are deployable subsets of
Sarasa UI J 1.0.40. The generated Charcoal V2 token still records the upstream
family name, while `charcoal_ui` maps that default to these assets on Web and
non-Apple platforms. Apple native builds use the system font, matching
Charcoal SwiftUI.

Source:
[`SarasaUiJ-TTF-Unhinted-1.0.40.7z`](https://github.com/be5invis/Sarasa-Gothic/releases/download/v1.0.40/SarasaUiJ-TTF-Unhinted-1.0.40.7z)

The subsets were generated with fonttools 4.42.0 and retain Latin, Latin
Extended, punctuation, currency, letter-like symbols, arrows, mathematical
operators, geometric shapes, and variation selectors:

```text
U+0000-024F,U+1E00-1EFF,U+2000-206F,U+20A0-20CF,U+2100-214F,
U+2190-21FF,U+2200-22FF,U+25A0-25FF,U+FE00-FE0F
```

SHA-256:

```text
ddf6261a0e9ae901a80cba24d5c1f95e0428e1f5e7c6401ac55e9d149ebed571  CharcoalSans-Regular.ttf
47fa1f8df6d8933408e7c9881737315a206711802cde9512b9f05fb70d31cefc  CharcoalSans-Bold.ttf
```

The fonts remain licensed under the SIL Open Font License 1.1 in `OFL.txt`.
Characters outside the subset use Flutter's normal script-aware fallback.
