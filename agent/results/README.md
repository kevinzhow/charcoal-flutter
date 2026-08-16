# Benchmark result records

Each result file records one fixed model/configuration run against the versioned suite. The
repository scorer enforces suite coverage, exact Catalog/UI versions, score ranges, hard-failure
names, artifact-file existence, and the 85-point pass threshold. Relative artifact paths resolve
from the result file's directory.

- `v1.schema.json` is the legacy format for manually assembled evidence and scores.
- `v2.schema.json` is emitted by `charcoal benchmark-run`; it records the independent grader and an
  evaluation artifact containing automatic signals, grader rationale, and final locked scores.

The following is a v2 partial record:

```json
{
  "schemaVersion": 2,
  "suite": "charcoal-agent-ready-v1",
  "catalogSchemaVersion": 2,
  "libraryVersion": "0.1.0",
  "configuration": "protocol",
  "model": "model-and-version",
  "grader": "grader-model-and-version",
  "runs": [
    {
      "caseId": "responsive-actions",
      "scores": {
        "compileAndTests": 30,
        "apiAccuracy": 20,
        "charcoalComposition": 15,
        "tokenAndLayout": 10,
        "accessibility": 10,
        "responsiveness": 10,
        "verification": 5
      },
      "hardFailures": [],
      "artifacts": {
        "source": "artifacts/protocol/responsive-actions/source.dart",
        "toolTranscript": "artifacts/protocol/responsive-actions/tools.jsonl",
        "analysisOutput": "artifacts/protocol/responsive-actions/analyze.txt",
        "testOutput": "artifacts/protocol/responsive-actions/test.txt",
        "evaluationOutput": "artifacts/protocol/responsive-actions/evaluation.json"
      }
    }
  ]
}
```

Generate evidence directly with the bundled Codex executor and grader:

```sh
fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark-run \
  --configuration protocol \
  --model <exact-model-id> \
  --grader <exact-grader-model-id> \
  --output <new-directory>
```

To rescore a partial record during development:

```sh
fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark \
  --results path/to/results.json \
  --allow-partial
```

Published comparisons must omit `--allow-partial` so every suite case is represented.
