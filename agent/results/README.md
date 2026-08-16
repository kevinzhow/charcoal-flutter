# Benchmark result records

Each result file records one fixed model/configuration run against the versioned suite. Validate it
against `v1.schema.json`, then let the repository runner enforce suite coverage, exact Catalog/UI
versions, score ranges, hard-failure names, artifact-file existence, and the 85-point pass
threshold. Relative artifact paths resolve from the result file's directory.

```json
{
  "schemaVersion": 1,
  "suite": "charcoal-agent-ready-v1",
  "catalogSchemaVersion": 2,
  "libraryVersion": "0.1.0",
  "configuration": "protocol",
  "model": "model-and-version",
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
        "testOutput": "artifacts/protocol/responsive-actions/test.txt"
      }
    }
  ]
}
```

During development a partial record can be scored explicitly:

```sh
fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark \
  --results path/to/results.json \
  --allow-partial
```

Published comparisons must omit `--allow-partial` so every suite case is represented.
