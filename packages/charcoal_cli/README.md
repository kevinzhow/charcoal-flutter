# Charcoal CLI

The Charcoal CLI gives coding agents and humans one deterministic interface to the component and
token Catalog shipped for the current `charcoal_ui` version.

```sh
dart run packages/charcoal_cli/bin/charcoal.dart search "single choice"
dart run packages/charcoal_cli/bin/charcoal.dart pattern "searchable collection"
dart run packages/charcoal_cli/bin/charcoal.dart design-rules
dart run packages/charcoal_cli/bin/charcoal.dart component CharcoalSegmentedControl --json
dart run packages/charcoal_cli/bin/charcoal.dart token "layout spacing" --kind dimension --json
dart run packages/charcoal_cli/bin/charcoal.dart page-spec \
  --output design/my-page.json --page-id my-page --title "My page"
dart run packages/charcoal_cli/bin/charcoal.dart page-spec --validate design/my-page.json
dart run packages/charcoal_cli/bin/charcoal.dart agent install --agent auto
dart run packages/charcoal_cli/bin/charcoal.dart agent sync --agent auto
dart run packages/charcoal_cli/bin/charcoal.dart doctor
dart run packages/charcoal_cli/bin/charcoal.dart init --agent codex
dart run packages/charcoal_cli/bin/charcoal.dart manifest --json
dart run packages/charcoal_cli/bin/charcoal.dart benchmark --results path/to/results.json
```

Every JSON response uses `apiVersion: 1`. Failed commands use stable error codes and a non-zero
process exit code. Token search defaults to semantic roles; primitive lookup requires an explicit
`--tier primitive`. The benchmark command validates exact package/catalog versions, complete case
coverage, score bounds, hard failures, and referenced evidence files before reporting a score.

`agent install` is the normal project bootstrap. It installs the version-matched
`charcoal-page-design` Skill into the detected agent directories and writes only the managed
Charcoal block in the relevant instruction files. Use `--agent all` for Codex, Claude, and Cursor,
or `--scope user` for a personal installation. `agent sync` replaces the managed Skill directory
exactly, so files removed by a later Charcoal release do not remain as stale guidance. `doctor`
checks the installed Skill hash, Catalog schema, package version, and managed instructions.

Patterns are reviewed page-level compositions, not runtime recipes. `page-spec` provides a
versioned contract for intent priority, information placement, reuse, interaction states,
feedback, best-practice decisions, and runtime verification. It validates component and pattern
references against the exact installed Catalog.

When the package is available as a dev dependency, use the declared executable with
`dart run charcoal_cli:charcoal`. The workspace examples above use the source entry point so they
also work before publication.
