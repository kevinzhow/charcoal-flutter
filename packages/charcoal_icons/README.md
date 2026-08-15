# Charcoal Icons for Flutter

`charcoal_icons` packages the complete Charcoal V2 SVG catalog as typed Flutter constants. It is a
sibling of `charcoal_ui`: applications may use either package independently, while Charcoal UI uses
the same assets for built-in control affordances.

```dart
import 'package:charcoal_icons/charcoal_icons.dart';

const CharcoalIcon(CharcoalIcons.add);
const CharcoalIcon(CharcoalSolidIcons.check, semanticLabel: 'Selected');
```

The default `CharcoalIcons` and `CharcoalSolidIcons` catalogs contain the 24 px regular and solid
sets. Size-specific sources are available through `CharcoalIcons16`, `CharcoalSolidIcons16`,
`CharcoalIcons20`, and `CharcoalSolidIcons20`. `CharcoalColorIcons` contains authored multicolor
assets.

Regular and solid icons inherit `IconTheme`. Multicolor icons preserve their source colors unless a
`color` is passed directly to `CharcoalIcon`.

## Updating the catalog

From the workspace root:

```bash
fvm dart run tool/icons.dart update --repository pixiv/charcoal --ref main
fvm dart run tool/icons.dart check
```

The updater resolves the requested ref to an exact commit, copies only
`packages/icon-files/v2/svg`, validates its directory and SVG canvas structure, regenerates the Dart
catalog, and records one deterministic aggregate hash in `icons/manifest.json`.

The SVG artwork comes from [pixiv/charcoal](https://github.com/pixiv/charcoal) and is distributed
under the Apache License 2.0. See the workspace `NOTICE` for attribution.
