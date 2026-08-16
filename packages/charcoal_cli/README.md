# Charcoal CLI

The Charcoal CLI gives coding agents and humans one deterministic interface to the component and
token Catalog shipped for the current `charcoal_ui` version.

```sh
dart run packages/charcoal_cli/bin/charcoal.dart search "single choice"
dart run packages/charcoal_cli/bin/charcoal.dart component CharcoalSegmentedControl --json
dart run packages/charcoal_cli/bin/charcoal.dart token "layout spacing" --kind dimension --json
dart run packages/charcoal_cli/bin/charcoal.dart doctor
dart run packages/charcoal_cli/bin/charcoal.dart init --agent codex
dart run packages/charcoal_cli/bin/charcoal.dart manifest --json
dart run packages/charcoal_cli/bin/charcoal.dart benchmark --results path/to/results.json
```

Every JSON response uses `apiVersion: 1`. Failed commands use stable error codes and a non-zero
process exit code. Token search defaults to semantic roles; primitive lookup requires an explicit
`--tier primitive`. The benchmark command validates exact package/catalog versions, complete case
coverage, score bounds, hard failures, and referenced evidence files before reporting a score.

When the package is available as a dev dependency, use the declared executable with
`dart run charcoal_cli:charcoal`. The workspace examples above use the source entry point so they
also work before publication.
