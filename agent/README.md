# Charcoal Agent Readiness

Agent readiness means an agent can discover, understand, compose, and verify the exact installed
Charcoal UI version without guessing component names, constructor parameters, token roles, or
responsive behavior.

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

## Synchronization

After a public API, curated example, package version, managed instruction, or canonical grader
schema changes, refresh all derivable Agent Ready artifacts through one command:

```sh
fvm dart run tool/agent_ready.dart generate
```

CI runs the corresponding `check` command. The pipeline regenerates the Catalog, updates benchmark
Catalog/UI version pins, refreshes the managed contributor block, and derives the Codex-compatible
grader schema from the canonical schema. Benchmark prompts and their semantic assertions remain
reviewed source: they cannot be inferred safely from an API signature, so the checker validates
their IDs and component references instead of silently rewriting their intent.
