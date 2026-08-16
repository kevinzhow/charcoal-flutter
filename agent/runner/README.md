# Benchmark runner contracts

`charcoal benchmark-run` separates orchestration, candidate execution, objective verification, and
subjective grading. This keeps model-specific launch details outside the benchmark core and prevents
the candidate from supplying its own score.

## Execution sequence

1. Copy the minimum package set into a disposable workspace and run `flutter pub get`.
2. Give the executor one JSON request conforming to `executor-request-v1.schema.json`.
3. Permit only `lib/candidate.dart`; restore and hard-fail other detected fixture mutations.
4. Run harness-owned `flutter analyze --no-pub` and `flutter test --no-pub` at compact and desktop
   sizes.
5. Lock compile/test points and structural hard failures.
6. Give a separate grader the full private rubric and immutable evidence using
   `grader-request-v1.schema.json`.
7. Validate its `grader-response-v1.schema.json` response and emit `results/v2.schema.json`.

Run `fvm dart run tool/agent_ready.dart generate` after changing any runner contract. It derives the
Codex Structured Outputs subset from the canonical grader response schema and CI rejects drift.

The runner appends the request JSON path to each external command. Executors may read the project
and write only paths listed in `project.allowedWritePaths`; graders must write exactly
`responsePath`. A custom executor is still responsible for providing an OS-level sandbox if it is
not the bundled Codex adapter—the runner's snapshot check is a detection and evidence boundary, not
a security boundary for arbitrary native programs.

## Bundled Codex adapter

The default `--adapter codex` launches `agent/adapters/codex_executor.dart` and
`agent/adapters/codex_grader.dart`. It uses saved Codex CLI authentication and these fixed controls:

- ephemeral, non-interactive JSONL runs;
- ignored user config and exec-policy rules;
- disabled web search and subagents;
- explicit model and reasoning effort;
- `workspace-write` for the candidate and `read-only` for the grader;
- JSON Schema-constrained grader output;
- a required, invocation-scoped Charcoal MCP server only when the request exposes `tools.mcp`.

The default reasoning effort is `medium`. Override it explicitly with `--candidate-reasoning` and
`--grader-reasoning`. Use `--codex <path>` when the CLI is not on `PATH`.

## Custom adapters

Select `--adapter custom`, then pass `--executor` and `--grader-command`. Repeat `--executor-arg`
or `--grader-arg` for fixed arguments; the runner appends the corresponding request path last.
Commands receive these convenience environment variables:

- executor: `CHARCOAL_BENCHMARK_REQUEST`, `CHARCOAL_BENCHMARK_CASE_ID`, and
  `CHARCOAL_BENCHMARK_CONFIGURATION`;
- grader: `CHARCOAL_BENCHMARK_GRADER_REQUEST` and `CHARCOAL_BENCHMARK_CASE_ID`.

Never place credentials in adapter arguments because command metadata is retained in benchmark
evidence.
