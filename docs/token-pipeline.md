# V2 token pipeline

Generated Dart is build output, not the component design source of truth. The pipeline acquires
Charcoal V2 JSON, validates and resolves its references, then emits platform-native foundation
types. The Flutter project has no V1 remapping step.

## Source model

The only token inputs are the pinned files under `tokens/upstream`:

- `base.json`: primitive values such as palette colors and spacing scales;
- `pixiv-light.json`: light semantic aliases and applied values; and
- `pixiv-dark.json`: dark semantic aliases and applied values.

`tokens/manifest.json` records the repository, requested ref, resolved commit, upstream paths, and
SHA-256 hashes. The current snapshot is pinned to
[`pixiv/charcoal@08995fa`](https://github.com/pixiv/charcoal/tree/08995fa5191fa918fc5afd2c5da08490ae307da7/packages/theme/src/json).

Reference resolution creates this dependency chain:

```text
base primitive → applied semantic token → private component mapping → Flutter layout
```

For example, the primitive `space.30 = 16px` resolves into `space.component/30`; a button then maps
that semantic value to its small horizontal padding. A source-specific value with no exact semantic
role stays in the component's private specification instead.

## Generated artifacts

One generation transaction writes:

- `charcoal_color_tokens.g.dart`;
- `charcoal_dimension_tokens.g.dart`;
- `charcoal_typography_tokens.g.dart`;
- `tokens/snapshot.json` for semantic diffs; and
- `tokens/diff.md` for upstream update reviews.

Each generated foundation group exposes typed fields, `copyWith` support, and typed `entries`
catalogs. Components never parse JSON at runtime. `CharcoalThemeData` carries only brightness,
colors, dimensions, and typography.

Component layout, state mapping, and motion are ordinary reviewed Dart source. This keeps exact
source behavior close to the widget, avoids pretending every platform measurement is a universal
token, and prevents application themes from replacing a component's structural contract.

## Updating tokens

Use the FVM-pinned toolchain from the workspace root:

```bash
# Download and pin compatible V2 JSON.
fvm dart run tool/tokens.dart sync --repository pixiv/charcoal --ref main

# Regenerate foundations, snapshot, and semantic diff without network access.
fvm dart run tool/tokens.dart generate

# Sync and generate as one update transaction.
fvm dart run tool/tokens.dart update --repository pixiv/charcoal --ref main

# Reproduce every generated file and fail on drift.
fvm dart run tool/tokens.dart check

# Print the semantic difference from the committed snapshot.
fvm dart run tool/tokens.dart diff
```

For an organization-specific theme, preserve the same V2 JSON shape in a fork and pass its
`owner/repository` to `sync` or `update`. Component changes do not belong in token JSON; edit the
component implementation and its source-contract tests directly.

`sync` validates all three files in a temporary directory before replacing checked-in sources.
When `GITHUB_TOKEN` is present, requests can also access an authorized private fork.

## Failure conditions

Generation or CI fails on:

- a missing or circular token reference;
- different light and dark applied-token keys;
- an unsupported category, value type, color format, unit, or font weight;
- Dart identifier collisions;
- a source file that differs from its manifest hash; or
- a snapshot or generated artifact that cannot be reproduced exactly.

The scheduled update workflow creates one reviewable change containing pinned sources, generated
foundations, and the semantic diff. The independent token check detects manual edits and stale
generation.
