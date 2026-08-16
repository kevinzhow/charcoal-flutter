# Charcoal MCP

`charcoal_mcp` is a thin, read-only Model Context Protocol adapter over `charcoal_catalog`. It does
not maintain component APIs, examples, or token descriptions of its own.

The stdio server implements MCP `2026-07-28`, including stateless per-request metadata,
`server/discover`, deterministic cacheable `tools/list` results, structured tool content, and
newline-delimited JSON-RPC. It also accepts legacy `initialize` clients through `2025-11-25` and
earlier tool-compatible revisions.

Run it from this workspace:

```sh
fvm dart run packages/charcoal_mcp/bin/charcoal_mcp.dart
```

Or, when consumed as a package executable:

```sh
dart run charcoal_mcp:charcoal-mcp
```

Available read-only tools:

- `charcoal.search_components`
- `charcoal.get_component`
- `charcoal.search_tokens`
- `charcoal.get_example`
- `charcoal.get_catalog_status`

Stdout is reserved exclusively for one JSON-RPC message per line. Logs and transport failures use
stderr.
