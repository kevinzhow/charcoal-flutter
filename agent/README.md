# Charcoal Agent Readiness

Agent readiness means an agent can discover, understand, compose, and verify the exact installed
Charcoal UI version without guessing component names, constructor parameters, token roles, or
responsive behavior.

## Evaluation matrix

Run every case in `benchmarks/v1.json` in a clean Flutter fixture under these configurations:

1. `baseline`: repository code only; no injected Charcoal instructions or tools.
2. `instructions`: the managed block emitted by `charcoal init`.
3. `cli`: managed instructions plus `search`, `component`, `manifest`, and `doctor`.
4. `protocol`: the future MCP adapter over the same Catalog and search implementation.

Keep the model, prompt, Flutter SDK, package version, fixture, and retry policy fixed. Store the
generated source, tool transcript, analyzer output, test output, score, and failure reason for each
run. Do not repair a candidate manually.

## Rubric (100 points)

- 30: the result compiles and relevant tests pass.
- 20: component choice and public API match the installed catalog.
- 15: existing Charcoal controls are used instead of Material/Cupertino substitutes.
- 10: Flutter layout primitives and semantic token roles respect ownership boundaries.
- 10: labels, semantics, focus, disabled state, and text scaling are preserved.
- 10: compact and desktop constraints behave as requested.
- 5: the agent runs proportionate verification and reports it accurately.

A case passes at 85 points with no hard failure. Compilation errors, fabricated Charcoal APIs,
silent Material/Cupertino substitutions, and unsafe file mutations are hard failures regardless of
score.

The benchmark is deliberately independent from Showcase screenshots. Visual parity can be added as
another verifier, while this suite measures whether an agent can make a correct implementation from
the package's public contract.
