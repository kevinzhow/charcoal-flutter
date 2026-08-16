# Charcoal UI for Flutter

An independent Charcoal V2 UI library implemented directly on Flutter's Widgets layer. It does not
depend on Material or Cupertino. The package combines generated Charcoal foundations with
source-backed Flutter components, light and dark themes, accessibility behavior, and reproducible
drift checks.

This project is V2-only. It intentionally contains no Charcoal V1 aliases or compatibility API.

Explore the [Charcoal UI V2 Showcase](https://kevinzhow.github.io/charcoal-flutter/) in a browser.

## Packages

- `packages/charcoal_tokens`: generated color, dimension, and typography foundations.
- `packages/charcoal_icons`: the generated Charcoal Icons V2 SVG catalog and Flutter widget.
- `packages/charcoal_ui`: independent Widgets-layer components, themes, and interaction primitives.
- `packages/charcoal_catalog`: versioned component API, usage guidance, and executable examples.
- `packages/charcoal_cli`: deterministic discovery, diagnostics, and agent-instruction setup.
- `example`: the exhaustive Showcase used for visual development and regression checks.
- `agent`: versioned agent-readiness benchmark prompts and scoring contract.
- `tool/tokens.dart`: pinned token sync, validation, generation, semantic diff, and drift checking.
- `tool/icons.dart`: pinned icon sync, validation, generation, and drift checking.
- `tokens/upstream`: the original V2 token JSON pinned to an exact upstream commit.

Public components include:

- `CharcoalApp`, `CharcoalTheme`, `CharcoalThemeData`, `CharcoalMotion`, and `CharcoalPageRoute`
- `CharcoalButton`, `CharcoalLinkButton`, `CharcoalSwitchingButton`, and `CharcoalIconButton`
- `CharcoalCheckbox`, `CharcoalMultiSelect`, `CharcoalRadio`, and `CharcoalSwitch`
- `CharcoalFieldLabel`, `CharcoalTextField`, `CharcoalTextArea`, and `CharcoalDropdown`
- `CharcoalSegmentedControl`, `CharcoalPagination`, `CharcoalCarousel`, and `CharcoalNavigationItem`
- `CharcoalTagItem`, `CharcoalHintText`, `CharcoalTextEllipsis`, and loading surfaces
- tooltip, balloon, toast, snackbar, and modal surfaces and presentation APIs
- `CharcoalTypography`, `charcoalTypographyStyle`, and `CharcoalTextStyles`

The API follows Flutter conventions instead of reproducing another platform's view hierarchy.
Icon-bearing controls accept regular widgets; applications can use `charcoal_icons` or inject
product-specific artwork without coupling the two packages.

## Architecture

Component layout follows a four-stage relationship:

```text
Primitive JSON
  space.10 = 4, space.20 = 8, space.25 = 12, space.30 = 16
        ↓ reference resolution
Semantic foundation
  space.component/10, space.component/20, space.layout/30, space.target/s
        ↓ component-owned mapping
Private component specification
  button.iconGap, textArea.fieldGap, dialog.pageInset
        ↓
Flutter Widgets implementation
```

Colors, font families and weights, standard spacing, target sizes, radii, and border widths use the
generated semantic foundation when an exact role exists. Measurements specific to one upstream
implementation—such as the 51 × 31 switch track, 9 px text-area inset, or 3 px tooltip arrow—remain
private constants beside that component. Values are never forced onto a nearby token merely to
remove a literal.

`CharcoalThemeData` contains only foundations: brightness, colors, dimensions, and typography.
Component geometry and behavior are not a public theme surface or a generated configuration file.

Component behavior is audited against two pinned sources:

1. A public SwiftUI implementation is the primary reference when one exists:
   [`pixiv/charcoal-ios@8d96f2c`](https://github.com/pixiv/charcoal-ios/tree/8d96f2cef5be9e7983898e13cf45e0222f1aadda/Sources/CharcoalSwiftUI/Components).
2. Otherwise the corresponding Charcoal implementation is used:
   [`pixiv/charcoal@08995fa`](https://github.com/pixiv/charcoal/tree/08995fa5191fa918fc5afd2c5da08490ae307da7/packages/react/src/components).
3. Flutter adds keyboard, pointer, semantics, text-scaling, reduced-motion, and viewport adaptations.

Source provenance is an implementation concern. Public component names remain platform-neutral so
components can mature without API renaming.

See [Component source contracts](docs/component-sources.md) for the complete source matrix and
verified measurements.

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

Semantic overrides propagate through every component that consumes that foundation role:

```dart
final baseColors = CharcoalGeneratedColorTokens.light;
final baseDimensions = CharcoalGeneratedDimensionTokens.light;

final theme = CharcoalThemeData.light(
  colors: baseColors.copyWith(
    containerPrimaryDefault: const Color(0xFF9C27B0),
  ),
  dimensions: baseDimensions.copyWith(
    space: baseDimensions.space.copyWith(
      targetS: 36,
      component30: 20,
    ),
  ),
);

CharcoalTheme(data: theme, child: const MyScreen());
```

## Agent-ready tooling

The catalog is generated from the real exported Dart API. Every discovered public Widget receives
constructor data and source documentation; reviewed components additionally include use/avoid
guidance, accessibility and responsive rules, token roles, related components, and source copied
from a compiling example. `generated` and `curated` coverage are reported separately so tools never
mistake partial guidance for a complete contract.

The CLI exposes that same versioned catalog to people, scripts, and coding agents:

```bash
# Find a component from product intent.
fvm dart run packages/charcoal_cli/bin/charcoal.dart search "single choice"

# Read the exact constructor, companion APIs, guidance, and executable source.
fvm dart run packages/charcoal_cli/bin/charcoal.dart component CharcoalSegmentedControl

# Use stable JSON envelopes for automation.
fvm dart run packages/charcoal_cli/bin/charcoal.dart manifest --json

# Inspect a project, then add or refresh only the managed instruction block.
fvm dart run packages/charcoal_cli/bin/charcoal.dart doctor
fvm dart run packages/charcoal_cli/bin/charcoal.dart init --agent codex
```

Regenerate after changing a public component API or a curated example:

```bash
fvm dart run packages/charcoal_catalog/tool/generate_catalog.dart
fvm dart run packages/charcoal_catalog/tool/generate_catalog.dart --check
```

The CLI and a future MCP server are adapters over the Catalog, not separate documentation sources.
Executable examples remain ordinary Flutter code; they are reference compositions rather than a
runtime recipe layer. See [Agent readiness](agent/README.md) for the benchmark and rubric.

## Motion and navigation

`CharcoalApp` uses `CharcoalPageRoute` as its default route factory. The transition remains opaque,
disables route snapshotting, and honors reduced motion. Push an explicit route when using
imperative navigation:

```dart
Navigator.of(context).push<void>(
  CharcoalPageRoute<void>(builder: (_) => const DetailPage()),
);
```

`CharcoalMotion` exposes shared composition curves. Component-specific durations stay beside the
component whose source contract defines them.

## Updating V2 tokens

```bash
# Resolve a tag, branch, or commit to an exact SHA, then download and validate V2 JSON.
fvm dart run tool/tokens.dart sync --ref main

# Generate strongly typed color, dimension, and typography foundations offline.
fvm dart run tool/tokens.dart generate

# Sync, generate, and write tokens/diff.md for an update pull request.
fvm dart run tool/tokens.dart update --ref main

# Check source hashes, the resolved snapshot, and all generated artifacts.
fvm dart run tool/tokens.dart check

# Compare current sources with the committed semantic snapshot.
fvm dart run tool/tokens.dart diff
```

Generation fails for missing or circular references, mismatched light/dark keys, invalid values,
identifier collisions, manifest drift, or non-reproducible output. Component-only changes are made
in component source and verified by component tests; they do not run through token generation.

Do not edit generated Dart files. Move the pinned upstream revision with `sync` or `update`, then
regenerate. Generated foundation groups expose typed `entries` catalogs so documentation and the
Showcase never maintain a second token inventory.

See [V2 token pipeline](docs/token-pipeline.md) for the full source-of-truth and CI model.

## Updating V2 icons

```bash
fvm dart run tool/icons.dart update --ref main
fvm dart run tool/icons.dart check
```

Token sync metadata lives in `tokens/manifest.json`; icon sync metadata lives in
`icons/manifest.json`. Both record exact upstream commits and source hashes.

## Development and previews

```bash
fvm flutter pub get
fvm flutter analyze
fvm dart test
fvm dart test packages/charcoal_catalog
fvm dart test packages/charcoal_cli
fvm flutter test packages/charcoal_ui/test example/test
fvm dart run tool/tokens.dart check
fvm dart run packages/charcoal_catalog/tool/generate_catalog.dart --check

cd packages/charcoal_ui
fvm flutter widget-preview start
```

Every push to `main` builds the Showcase for the `/charcoal-flutter/` base path and deploys it to
GitHub Pages. The package uses local workspace dependencies and is currently `publish_to: none`.

## Origin and license

Foundation tokens and component behavior come from pixiv's
[charcoal](https://github.com/pixiv/charcoal) and
[charcoal-ios](https://github.com/pixiv/charcoal-ios). This project and both upstream projects use
Apache-2.0. See `NOTICE` for attribution.
