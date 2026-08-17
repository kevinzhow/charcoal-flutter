# Charcoal Agent Readiness

Agent readiness means an agent can discover, understand, compose, and verify the exact installed
Charcoal UI version without guessing component names, constructor parameters, token roles, or
responsive behavior.

For complete applications, readiness has six synchronized layers:

1. `skills/charcoal-page-design` is the canonical source for the intent → information → reuse →
   state → feedback → best-practice → verification workflow. The repository exposes that same
   source at `.agents/skills/charcoal-page-design` for local Codex discovery.
2. The generated Catalog publishes the seven rules, five required design-process stages, reviewed
   composition patterns, component interaction states, and feedback ownership.
3. CLI and MCP adapters expose those contracts without maintaining separate prose inventories.
4. A versioned Page Experience Spec records page-specific decisions and validates exact component
   and pattern references before implementation handoff.
5. A versioned App Experience Review inventories every surface and links page reviews, Widget
   Previews, cross-surface checks, and executable runtime keys into one release gate.
6. Real Flutter flows and the page-experience benchmark verify that the resulting UI behaves at
   the required constraints.

## Install into an agent

From a consuming Flutter project that has `charcoal_cli` available as a dev dependency:

```sh
dart run charcoal_cli:charcoal agent install --agent auto
dart run charcoal_cli:charcoal doctor
```

Project scope is the default. Codex uses `.agents/skills/charcoal-page-design`, Claude uses
`.claude/skills/charcoal-page-design`, and Cursor uses `.cursor/skills/charcoal-page-design`.
`--agent all` installs every target and `--scope user` installs a personal copy. The installer also
adds a versioned managed block to the corresponding project instruction file without replacing
unrelated user content.

After updating Charcoal UI and `charcoal_cli`, run:

```sh
dart run charcoal_cli:charcoal agent sync --agent auto
dart run charcoal_cli:charcoal doctor
```

The install manifest stores the library version, Catalog schema, Skill version, and source hash.
Sync replaces only an installer-owned Skill directory, including removing files that no longer
exist upstream. `doctor` fails for modified or stale content.

## Page Experience Specs

Use a persisted spec for new pages, substantial redesigns, task-bearing modals/sheets, and
multi-state flows. Small visual fixes use the compact audit in the Skill instead.

```sh
dart run charcoal_cli:charcoal page-spec \
  --output design/account-transfer.json \
  --page-id account-transfer \
  --title "Account transfer"
dart run charcoal_cli:charcoal page-spec --validate design/account-transfer.json
```

The canonical JSON Schema and template live in `contracts/`. Checked-in reference specs for Nook,
Lumen, and Daylight live in `page-specs/` and are validated by the synchronization pipeline.

## App Experience Reviews

Use an App Experience Review for multi-surface applications, cross-page redesigns, and every Agent
Ready example. The review begins with a complete surface inventory and ends only after each surface
passes all seven design rules and the app passes navigation, hierarchy, product-copy, responsive,
and accessibility checks.

```sh
dart run charcoal_cli:charcoal app-review \
  --output design/app-experience.json \
  --app-id my-app \
  --title "My app"
dart run charcoal_cli:charcoal app-review --validate design/app-experience.json
```

`valid: true` means the review record is structurally coherent. Only `ready: true` and exit code
zero mean every verdict passes and no finding remains. Runtime scenarios reference exact test files,
test names, and surface keys, while preview evidence references exact `AgentPagePreview` states.
State inventories compare the manifest with the application's real Dart destination, route, and task
enums, so a new enum value cannot enter the product without an explicit reviewed-surface mapping.
Checked-in passing reviews for Nook, Lumen, and Daylight live in `app-reviews/`.

## Evaluation matrix

Run every case in `benchmarks/v1.json` (defined by `benchmarks/v1.schema.json`) in a clean Flutter
fixture under these configurations:

1. `baseline`: repository code only; no injected Charcoal instructions or tools.
2. `instructions`: the managed block emitted by `charcoal init`.
3. `cli`: managed instructions plus `search`, `component`, `token`, `manifest`, and `doctor`.
4. `protocol`: the read-only MCP adapter over the same Catalog and search implementation.

Keep the model, reasoning effort, prompt, Flutter SDK, package version, fixture, timeout, and retry
policy fixed. Store the generated source, tool transcript, analyzer output, test output, independent
grader output, score, and failure reason for each run. Do not repair a candidate manually. The
executor request deliberately contains only the case ID and user prompt; expected components,
assertions, and forbidden patterns remain private to the grader.

## Rubric (100 points)

- 30: the result compiles and relevant tests pass.
- 20: component choice and public API match the installed catalog.
- 15: existing Charcoal controls are used instead of Material/Cupertino substitutes.
- 10: Flutter layout primitives and semantic token roles respect ownership boundaries.
- 10: labels, semantics, focus, disabled state, and text scaling are preserved.
- 10: compact and desktop constraints behave as requested.
- 5: the agent runs proportionate verification and reports it accurately.

A case passes at 85 points with no hard failure. Compilation errors, fabricated Charcoal APIs,
silent Material/Cupertino substitutions, unsafe file mutations, and agent execution failures are
hard failures regardless of score.

## Executable runner

`benchmark-run` creates a disposable Flutter workspace, runs one untouched candidate agent, locks
analyzer/test outcomes and structural hard failures, then invokes a separate grader. The bundled
Codex adapter uses ephemeral non-interactive sessions, ignores user config and rules, disables web
search and subagents, and gives the candidate a workspace-write sandbox while the grader remains
read-only. Only the `protocol` configuration receives the Charcoal MCP server.

Run a one-case pilot from the repository root:

```sh
fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark-run \
  --configuration protocol \
  --model gpt-5.6-sol \
  --grader gpt-5.6-sol \
  --candidate-reasoning high \
  --grader-reasoning high \
  --case exact-version-api \
  --output .artifacts/agent-ready/protocol-pilot
```

Omit `--case` for the complete current suite. A complete comparison runs every case once under each
of the four configurations, with one independent grader call per candidate. Use a new output
directory for every configuration. See [runner contracts and adapters](runner/README.md) before
publishing a comparison.

The executable runner emits the automated [v2 result format](results/README.md). Existing manually
recorded v1 files remain scoreable. Validate and rescore either format from the repository root:

```sh
fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark --results path/to/results.json
```

The runner rejects stale Catalog/UI versions, incomplete suites, malformed scores, unknown or
duplicate hard failures, and missing evidence files. `--allow-partial` is only for developing a
result record and must not be used for a published comparison.

The benchmark is deliberately independent from Showcase screenshots. Visual parity can be added as
another verifier, while this suite measures whether an agent can make a correct implementation from
the package's public contract.

The component/API suite remains `benchmarks/v1.json`. The separate
`benchmarks/page-experience-v1.json` suite evaluates complete stateful page decisions modeled after
Nook, Lumen, and Daylight:

```sh
fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark-run \
  --suite agent/benchmarks/page-experience-v1.json \
  --configuration cli \
  --model gpt-5.6-sol \
  --grader gpt-5.6-sol \
  --candidate-reasoning high \
  --grader-reasoning high \
  --output .artifacts/agent-ready/page-experience-cli
```

Run the page suite separately under the configurations being compared. Its hidden assertions cover
intent hierarchy, information placement, reuse, explicit state transitions, immediate and durable
feedback, recovery, accessibility, and compact layout—not visual imitation of the Showcase apps.

## Synchronization

After a public API, curated example, package version, managed instruction, or canonical grader
schema changes, refresh all derivable Agent Ready artifacts through one command:

```sh
fvm dart run tool/agent_ready.dart generate
```

CI runs the corresponding `check` command. The pipeline regenerates the Catalog, derives the CLI
Skill bundle from the canonical Skill, validates every checked-in Page Experience Spec and App
Experience Review, updates all benchmark Catalog/UI version pins, refreshes the managed contributor block, and derives the
Codex-compatible grader schema from the canonical schema. Skill instructions, page specs, benchmark
prompts, and semantic assertions remain reviewed source: they cannot be inferred safely from an API
signature, so the checker validates and synchronizes only the parts with a deterministic owner.
