import 'package:charcoal_catalog/charcoal_catalog.dart';

const String charcoalAgentStartMarker = '<!-- charcoal-agent:start';
const String charcoalAgentEndMarker = '<!-- charcoal-agent:end -->';

/// Matches the one generated block that `charcoal init` owns in an instruction file.
RegExp charcoalManagedBlockPattern() => RegExp(
  '${RegExp.escape(charcoalAgentStartMarker)}[^>]*-->'
  '.*?${RegExp.escape(charcoalAgentEndMarker)}',
  dotAll: true,
);

/// Builds the exact managed instruction block used by `charcoal init` and benchmark fixtures.
String buildCharcoalManagedBlock(String profile) {
  if (profile != 'consumer' && profile != 'contributor') {
    throw ArgumentError.value(profile, 'profile', 'Must be consumer or contributor.');
  }
  final command = profile == 'contributor'
      ? 'fvm dart run packages/charcoal_cli/bin/charcoal.dart'
      : 'dart run charcoal_cli:charcoal';
  final common =
      '''$charcoalAgentStartMarker version=${charcoalCatalog.libraryVersion} profile=$profile -->
## Charcoal UI agent workflow

- Discover components before coding: `$command search <intent>`.
- Read exact installed APIs and examples: `$command component <name>`.
- Find exact semantic token accessors by role: `$command token <intent>`; use `--tier primitive` only for audited foundation work.
- Import `package:charcoal_ui/charcoal_ui.dart` and use Charcoal components where available.
- Compose layouts with Flutter primitives such as `Row`, `Column`, `Padding`, and `LayoutBuilder`.
- Do not substitute Material or Cupertino controls for an existing Charcoal component.
- Use semantic Charcoal tokens only for roles they support; keep component-owned geometry internal.
- Preserve labels, semantics, focus behavior, text scaling, and compact/desktop layout behavior.
- Run `$command doctor`, static analysis, and relevant Flutter tests before handing off.
''';
  final contributor = profile == 'contributor'
      ? '''
- `charcoal_ui` remains an independent Widgets-layer package without Material/Cupertino dependencies.
- Public component APIs are platform-neutral; upstream provenance belongs in maintainer source contracts.
- After a public API or curated example changes, regenerate the catalog and run its `--check` mode.
- Generate isolated candidate/grader evidence with `$command benchmark-run`; never repair candidates manually.
- Score recorded Agent Ready evidence with `$command benchmark --results <path>`; complete comparisons may not use `--allow-partial`.
- Do not add runtime recipe abstractions. Catalog patterns and examples are documentation, not rendering code.
'''
      : '';
  return '$common$contributor$charcoalAgentEndMarker';
}
