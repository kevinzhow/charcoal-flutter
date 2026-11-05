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
base primitive → applied semantic token → theme role (pack) → component reads the role → Flutter layout
```

For example, the primitive `space.30 = 16px` resolves into `space.component/30`; the pack maps it to
the `space.lg` step, and a card's padding or a `CharcoalGap(CharcoalSpace.lg)` reads that step from
the theme. A source-specific value with no exact semantic role stays a metric of its component
family in the theme contract (for example the 51 x 31 switch track) instead.

## Generated artifacts

One generation transaction writes:

- `charcoal_color_tokens.g.dart`;
- `charcoal_dimension_tokens.g.dart`;
- `charcoal_typography_tokens.g.dart`;
- `packages/charcoal_theme/lib/src/packs/charcoal_pack.g.dart` (the theme pack, see below);
- `tokens/snapshot.json` for semantic diffs; and
- `tokens/diff.md` for upstream update reviews.

Each generated foundation group exposes typed fields, `copyWith` support, and typed `entries`
catalogs. Components never parse JSON at runtime and never read these generated foundations
directly: they read the theme pack (`CharcoalTheme.of(context)`), whose roles the pack JSON maps
onto the foundations.

Component layout, state mapping, and motion are ordinary reviewed Dart source whose measurements are
typed metrics in `charcoal_theme`. This keeps exact source behavior close to the widget, avoids
pretending every platform measurement is a universal token, and keeps a pack from replacing a
component's structural contract: a pack changes values, never behavior. The library source guard
rejects any literal that bypasses this split, and the extreme-theme test proves components follow
the pack.

## Theme pack

`tokens/theme/charcoal.pack.json` is the one hand-edited input besides the pinned upstream files. It
maps the frozen `charcoal_theme` contract to tokens, and the same generation transaction turns it
into `const CharcoalThemePack charcoalLightPack` / `charcoalDarkPack`:

```json
{
  "colors": { "primary": "{color.container/primary/default}", "text": "{color.text/default}" },
  "extensions": { "positiveSurface": { "light": "#FFEAF8E8", "dark": "#FF14301A" } },
  "space": { "xxs": 2, "xs": "{space.component/10}" },
  "motion": { "fast": "120ms", "curve": "cubic(0.2, 0, 0, 1)" },
  "typography": { "roles": { "body": { "fontSize": 14, "lineHeight": 22, "weight": "{text.font-weight/regular}" } } }
}
```

- A `{category.key}` reference resolves per mode against the merged light and dark token trees.
- `extensions` is the only place for literal colours (product tints and artwork fills that have no
  upstream token). Each needs both modes, as `{ "light": ..., "dark": ... }`.
- Plain numbers are library-owned values (e.g. `space.xxs`, product sizes); durations are `"120ms"`,
  curves `"cubic(a, b, c, d)"`.
- The names to cover are read from the contract sources in `packages/charcoal_theme/lib/src/contract/`,
  so there is no second list. Per-family component metrics are not in the JSON; they are hand-written in
  `packs/charcoal_metrics.dart`.
- `tokens/manifest.json` carries the JSON's SHA-256 under `pack`, so editing it without running
  `generate` fails `check`.
- `tokens/diff.md` gains a "Pack roles affected" section listing the pack names that read a removed or
  changed token.

Adding a role: add the field to the contract class, add its mapping here, run `generate`.

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
- a pack mapping that references an unknown token;
- a contract role, scale entry, or text role without a pack mapping, or a mapping for one the contract
  does not have;
- a `light`/`dark` pair without exactly both keys, a literal colour outside `extensions`, or an
  extension that does not give both modes;
- a source file (including the pack JSON) that differs from its manifest hash; or
- a snapshot or generated artifact that cannot be reproduced exactly.

The scheduled update workflow creates one reviewable change containing pinned sources, generated
foundations, and the semantic diff. The independent token check detects manual edits and stale
generation.
