# Model adapters

The included Codex adapters translate the vendor-neutral runner JSON contracts into `codex exec`
invocations. They are normally selected automatically by `charcoal benchmark-run`. The grader uses
`codex-grader-response-v1.schema.json`, which stays inside OpenAI Structured Outputs' supported JSON
Schema subset; the runner then applies the stricter canonical response contract.

For direct contract debugging, invoke either script with the repository package configuration:

```sh
fvm dart --packages=.dart_tool/package_config.json \
  agent/adapters/codex_executor.dart \
  --reasoning-effort high \
  path/to/executor-request.json
```

Both scripts accept `--codex <path>` and `--reasoning-effort
<minimal|low|medium|high|xhigh>`. The grader locates the repository's fixed response schema and
writes only the `responsePath` supplied by the harness.
