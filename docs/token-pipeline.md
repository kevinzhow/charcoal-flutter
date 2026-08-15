# V2 token pipeline

This repository treats generated Dart as build output, not as a design source of truth. It follows
the same basic model as `charcoal-ios`: acquire design-token JSON, validate and transform it, then
generate platform-native types. The Flutter implementation consumes Charcoal V2 only; it has no V1
compatibility layer or V1 remapping step.

## Sources of truth

The pipeline has two inputs:

1. `tokens/upstream/*.json` contains the pinned V2 foundation tokens: primitives plus the light and
   dark applied themes.
2. `tokens/components.json` maps component properties and interaction states to semantic foundation
   tokens. This is the Flutter component recipe layer.

The resulting artifacts are:

- strongly typed light and dark color, dimension, and typography objects in `charcoal_tokens`;
- typed token-entry catalogs used by documentation, inspection tooling, and the Showcase;
- strongly typed component recipes in `charcoal_ui`;
- `tokens/snapshot.json`, used for semantic diffs; and
- `tokens/diff.md`, used as the body of an automated token update pull request.

Components never read JSON at runtime. A theme override is resolved through the generated recipe,
so changing a semantic foundation token also changes every component that references it.

Each generated foundation group exposes an `entries` getter containing its source path and typed
value. This is deliberately generated alongside the named Dart fields: consumers can build token
browsers without reflection, and a token update cannot leave the browser's inventory stale.

## Updating tokens

Use the FVM-pinned Flutter 3.47 toolchain from the workspace root:

```bash
# Pull V2 JSON from a Charcoal-compatible repository and pin the resolved commit.
fvm dart run tool/tokens.dart sync --repository pixiv/charcoal --ref main

# Regenerate Dart, the resolved snapshot, and the token diff without network access.
fvm dart run tool/tokens.dart generate

# Perform both operations as one update transaction.
fvm dart run tool/tokens.dart update --repository pixiv/charcoal --ref main

# Reproduce every generated file and fail on drift.
fvm dart run tool/tokens.dart check
```

For an organization-specific theme, keep the same V2 JSON paths in a fork and pass its
`owner/repository` name to `sync` or `update`. Component-only changes belong in
`tokens/components.json` and require only `generate`.

`sync` resolves a branch or tag to an exact commit before downloading anything. It validates the
three files together in a temporary directory and replaces the checked-in sources only after the
whole token bundle succeeds. The manifest records the repository, requested ref, resolved commit,
source paths, and SHA-256 hashes. When `GITHUB_TOKEN` is present, the downloader uses it for GitHub
API and source requests, which also supports private forks that the token is authorized to read.

## Failure conditions

Generation or CI fails when it detects any of the following:

- a missing or circular token reference;
- mismatched light and dark applied-token keys;
- an unsupported category, value type, color format, unit, or font weight;
- two token names that collide after conversion to Dart identifiers;
- a component color mapped to a primitive token instead of a semantic token;
- an unknown or unconsumed component recipe value;
- a source file that no longer matches its manifest hash; or
- a snapshot or generated Dart file that cannot be reproduced exactly.

This makes an upstream token change visible as a reviewed source, generated-code, and semantic-diff
change in one pull request. The scheduled `update-tokens.yml` workflow performs that transaction;
`tokens.yml` independently detects manual edits and stale generation.
