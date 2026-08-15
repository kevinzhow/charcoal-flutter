# Charcoal UI for Flutter

A Charcoal V2 UI library implemented directly on Flutter's Widgets layer. It does not depend on
`material_ui` or `cupertino_ui`. Upstream token synchronization, Dart code generation, component
recipes, light and dark themes, and drift detection form one reproducible pipeline.

This project is V2-only. It intentionally contains no Charcoal V1 tokens, remapping, or compatibility
API.

## Packages

- `packages/charcoal_icons`: the complete generated Charcoal Icons V2 SVG catalog and Flutter widget.
- `packages/charcoal_tokens`: strongly typed foundation tokens generated from Charcoal V2 JSON.
- `packages/charcoal_ui`: themes, interaction primitives, and Widgets-layer components.
- `tool/icons.dart`: the pinned icon sync, validation, generation, and drift-check entry point.
- `tool/tokens.dart`: the sync, validation, generation, diff, and CI entry point.
- `tokens/upstream`: original V2 JSON pinned to an exact upstream commit.
- `tokens/components.json`: mappings from Flutter component properties to semantic tokens.

Public components currently include:

- `CharcoalApp`, `CharcoalTheme`, and `CharcoalThemeData`
- `CharcoalMotion` and `CharcoalPageRoute`
- `CharcoalClickable`
- `CharcoalNavigationItem`
- `CharcoalButton` and `CharcoalIconButton`
- `CharcoalCheckbox`, `CharcoalMultiSelect`, `CharcoalRadio`, and `CharcoalSwitch`
- `CharcoalFieldLabel`, `CharcoalTextField`, and `CharcoalTextArea`
- `CharcoalDropdown`
- `CharcoalSegmentedControl`, `CharcoalPagination`, and `CharcoalCarousel`
- `CharcoalTagItem`
- `CharcoalHintText`, `CharcoalTextEllipsis`, and `CharcoalLoadingSpinner`
- `CharcoalTooltip`, `CharcoalBalloon`, `CharcoalToast`, and `showCharcoalToast`
- `CharcoalDialog` and `showCharcoalDialog`

The API follows Flutter conventions instead of reproducing React's DOM shape. Icon-bearing controls
accept a regular `Widget`; `charcoal_ui` uses the sibling `charcoal_icons` package for its default
affordances, while applications can still pass any widget when a product-specific mark is needed.

## Usage

```dart
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    CharcoalApp(
      home: Center(
        child: CharcoalButton(
          variant: CharcoalButtonVariant.primary,
          onPressed: () {},
          child: const Text('Create'),
        ),
      ),
    ),
  );
}
```

Import the icon package independently when composing icon-bearing controls:

```dart
import 'package:charcoal_icons/charcoal_icons.dart';

CharcoalIconButton(
  icon: const CharcoalIcon(CharcoalIcons.add),
  onPressed: () {},
  semanticLabel: 'Create',
);
```

Component recipes are resolved again when semantic foundation tokens are overridden. An override
therefore propagates to every component that references the token:

```dart
final colors = CharcoalGeneratedColorTokens.light.copyWith(
  containerPrimaryDefault: const Color(0xFF9C27B0),
);

final theme = CharcoalThemeData.light(colors: colors);

CharcoalTheme(
  data: theme,
  child: const MyScreen(),
);
```

## Motion and navigation

`CharcoalApp` uses `CharcoalPageRoute` as its default route factory. The transition uses a short
shared-axis movement, remains opaque for its entire lifetime, disables route snapshotting, and
honors the platform's reduced-motion preference. Push an explicit route when using imperative
navigation:

```dart
Navigator.of(context).push<void>(
  CharcoalPageRoute<void>(builder: (_) => const DetailPage()),
);
```

`CharcoalMotion` exposes the common composition-level curves and timings. Generated component
recipes continue to own component-specific durations.

## Updating V2 tokens

```bash
# Resolve a tag, branch, or commit to an exact SHA, then download and validate the V2 JSON.
fvm dart run tool/tokens.dart sync --ref main

# Generate strongly typed foundation tokens and component recipes without network access.
fvm dart run tool/tokens.dart generate

# Run sync and generate, then write tokens/diff.md for the update pull request.
fvm dart run tool/tokens.dart update --ref main

# Check source hashes, the resolved snapshot, and every generated artifact in CI.
fvm dart run tool/tokens.dart check

# Compare the current sources with the committed snapshot.
fvm dart run tool/tokens.dart diff
```

## Updating V2 icons

```bash
# Resolve and pin the upstream ref, copy only the V2 SVG source, and regenerate Dart.
fvm dart run tool/icons.dart update --ref main

# Reproduce the catalog and fail on asset, manifest, or generated-code drift.
fvm dart run tool/icons.dart check
```

Token sync metadata is stored in `tokens/manifest.json`, including the requested ref, resolved
commit, and SHA-256 of every source file. Icon sync records its resolved commit, group counts, and
aggregate asset hash in `icons/manifest.json`. Generation fails when:

- a token reference is missing or circular;
- light and dark applied token keys differ;
- a category, color, unit, or font weight is invalid;
- two token names produce the same Dart identifier;
- a component recipe references a primitive color instead of a semantic color; or
- a component recipe value is not consumed by the generator.

Do not edit generated Dart files. Change visual mappings in `tokens/components.json`, or run
`update` to move to another upstream revision. The scheduled CI workflow creates a source update
pull request with a token diff and regenerated icon catalog.

Generated foundation objects also expose typed `entries` catalogs for colors, typography, and
dimensions. Documentation and the Showcase iterate those catalogs instead of maintaining a second
hard-coded token list. Adding, removing, or changing a V2 foundation token therefore updates the
visual catalog in the same `generate` transaction.

See [V2 token pipeline](docs/token-pipeline.md) for the source-of-truth model, custom repository
workflow, guarantees, and its relationship to `charcoal-ios` generation.

## Development and previews

```bash
fvm flutter pub get
fvm dart analyze --fatal-infos
fvm dart test

(cd packages/charcoal_icons && fvm flutter test)
(cd packages/charcoal_ui && fvm flutter test)
(cd example && fvm flutter test)

cd packages/charcoal_ui
fvm flutter widget-preview start
```

Widget Preview contains light and dark configurations for the component set. In Flutter 3.47, the
generated preview scaffold does not inherit its parent pub workspace. During development,
`charcoal_ui` therefore uses local path dependencies and is marked `publish_to: none`. A release
workflow must replace those paths with published `charcoal_icons` and `charcoal_tokens` version
constraints.

## Origin and license

Foundation tokens and visual semantics come from pixiv's
[charcoal](https://github.com/pixiv/charcoal) and
[charcoal-ios](https://github.com/pixiv/charcoal-ios). This project and both upstream projects use
Apache-2.0. See `NOTICE` for attribution.
