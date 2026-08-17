# Showcase Web font

`NotoSans-Variable.woff2` is a Web-only Showcase asset derived from the
[Google Fonts Noto Sans family](https://fonts.google.com/specimen/Noto+Sans).
It is kept in the application rather than `charcoal_ui`, so consumers do not
inherit a font payload. Native Showcase builds continue to use their platform
font.

The source is the normal variable font from the pinned
[Noto Sans 2.015 release](https://github.com/notofonts/latin-greek-cyrillic/releases/tag/NotoSans-v2.015).
The subset retains the same Unicode ranges that the previous Charcoal runtime
fonts covered:

```text
U+0000-024F,U+1E00-1EFF,U+2000-206F,U+20A0-20CF,U+2100-214F,
U+2190-21FF,U+2200-22FF,U+25A0-25FF,U+FE00-FE0F
```

It was generated with fonttools 4.42.0:

```sh
pyftsubset 'NotoSans[wdth,wght].ttf' \
  --output-file=NotoSans-Variable.woff2 \
  --flavor=woff2 \
  --unicodes='U+0000-024F,U+1E00-1EFF,U+2000-206F,U+20A0-20CF,U+2100-214F,U+2190-21FF,U+2200-22FF,U+25A0-25FF,U+FE00-FE0F' \
  --layout-features='*' \
  --glyph-names \
  --symbol-cmap \
  --legacy-cmap \
  --notdef-glyph \
  --notdef-outline \
  --recommended-glyphs \
  --name-IDs='*' \
  --name-legacy \
  --name-languages='*'
```

SHA-256:

```text
bfb7bb691513f12e734dc346c03a03f784912432d7e3fa8e56efcf906fe86b3d  NotoSans[wdth,wght].ttf
400affa735d8143639ae12ea54d2c3d4b3f2fb8ee59290cb1f09309852e37834  NotoSans-Variable.woff2
```

The font remains licensed under the SIL Open Font License 1.1 in `OFL.txt`.
