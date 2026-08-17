<!-- charcoal-agent:start version=0.1.0 profile=contributor -->
## Charcoal UI agent workflow

- Discover components before coding: `fvm dart run packages/charcoal_cli/bin/charcoal.dart search <intent>`.
- Read exact installed APIs and examples: `fvm dart run packages/charcoal_cli/bin/charcoal.dart component <name>`.
- Find exact semantic token accessors by role: `fvm dart run packages/charcoal_cli/bin/charcoal.dart token <intent>`; use `--tier primitive` only for audited foundation work.
- Import `package:charcoal_ui/charcoal_ui.dart` and use Charcoal components where available.
- Compose layouts with Flutter primitives such as `Row`, `Column`, `Padding`, and `LayoutBuilder`.
- For Flutter UI runs, interaction, hot reload, screenshots, and end-to-end verification, prefer the Dart/Flutter skill tooling first; use `agent-device` only when platform-level automation is specifically required.
- Do not substitute Material or Cupertino controls for an existing Charcoal component.
- Use semantic Charcoal tokens only for roles they support; keep component-owned geometry internal.
- Preserve labels, semantics, focus behavior, text scaling, and compact/desktop layout behavior.
- Run `fvm dart run packages/charcoal_cli/bin/charcoal.dart doctor`, static analysis, and relevant Flutter tests before handing off.
- `charcoal_ui` remains an independent Widgets-layer package without Material/Cupertino dependencies.
- Public component APIs are platform-neutral; upstream provenance belongs in maintainer source contracts.
- After a public API or curated example changes, regenerate the catalog and run its `--check` mode.
- Generate isolated candidate/grader evidence with `fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark-run`; never repair candidates manually.
- Score recorded Agent Ready evidence with `fvm dart run packages/charcoal_cli/bin/charcoal.dart benchmark --results <path>`; complete comparisons may not use `--allow-partial`.
- Do not add runtime recipe abstractions. Catalog patterns and examples are documentation, not rendering code.
<!-- charcoal-agent:end -->
