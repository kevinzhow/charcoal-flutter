import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:path/path.dart' as p;

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
- For a new, redesigned, or multi-state page, load the installed `charcoal-page-design` skill and validate its Page Experience Spec with `$command page-spec --validate <path>`.
- For a multi-surface app or Agent Ready example, inventory every destination, detail, task, modal, overlay, and durable result before implementation; map real destination/route/task enums so new states cannot bypass review, then validate the final evidence with `$command app-review --validate <path>`.
- Model navigation effects explicitly: top-level destination selection keeps one stable root route, details and transient tasks push, durable completion replaces obsolete task history, and back pops or dismisses; bind every transition to executable evidence.
- Keep controlled selection atomic: one state owner must update the previous and next selected visuals, semantics, and controlled content in the same frame. Treat touch as `down → cancel or accepted tap`: down changes only an independent pressed layer, cancel has no persistent effect, and an accepted tap commits selection. State-only paint layers must preserve target bounds, icon and label centers, and text baselines; test geometry through every phase and assert the first post-activation frame before `pumpAndSettle` can hide a double highlight, stale-selection flash, or layout jump.
- Discover reviewed multi-component compositions before authoring local UI: `$command pattern <intent>`.
- Read exact installed APIs and examples: `$command component <name>`.
- Find exact semantic token accessors by role: `$command token <intent>`; use `--tier primitive` only for audited foundation work.
- Import `package:charcoal_ui/charcoal_ui.dart` and use Charcoal components where available.
- Compose layouts with Flutter primitives such as `Row`, `Column`, `Padding`, and `LayoutBuilder`.
- For UI work, use Flutter Widget Previewer before the full app: filter to the exact component or selected preview file, verify public/shared components in isolation, then deterministic page-state previews at compact and standard constraints; reserve full Showcase runs for navigation and platform integration.
- For Flutter UI runs, interaction, hot reload, screenshots, and end-to-end verification, prefer the Dart/Flutter skill tooling first; use `agent-device` only when platform-level automation is specifically required.
- Do not substitute Material or Cupertino controls for an existing Charcoal component.
- Use semantic Charcoal tokens only for roles they support; keep component-owned geometry internal.
- Preserve labels, semantics, focus behavior, text scaling, and compact/desktop layout behavior.
- Do not claim Agent Ready from a core flow alone. Executable runtime scenarios must collectively visit every inventoried surface, and every surface must pass all seven design rules plus the app-wide final review.
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

String charcoalInstructionPath(String agent) => switch (agent) {
  'codex' => 'AGENTS.md',
  'claude' => 'CLAUDE.md',
  'cursor' => p.join('.cursor', 'rules', 'charcoal.mdc'),
  _ => throw ArgumentError.value(agent, 'agent', 'Unsupported agent.'),
};

CharcoalInstructionWrite writeCharcoalManagedInstructions({
  required Directory projectRoot,
  required String agent,
  required String profile,
  String? requestedPath,
}) {
  final root = p.normalize(projectRoot.absolute.path);
  final relative = requestedPath ?? charcoalInstructionPath(agent);
  final targetPath = p.normalize(p.isAbsolute(relative) ? relative : p.join(root, relative));
  if (!p.isWithin(root, targetPath)) {
    throw const FileSystemException('The instruction file must stay inside the current project.');
  }
  final target = File(targetPath);
  final existing = target.existsSync() ? target.readAsStringSync() : '';
  final block = buildCharcoalManagedBlock(profile);
  final pattern = charcoalManagedBlockPattern();
  late final String next;
  if (pattern.hasMatch(existing)) {
    next = existing.replaceFirst(pattern, block);
  } else {
    final prefix = existing.trimRight();
    final cursorFrontMatter = agent == 'cursor' && prefix.isEmpty
        ? '---\ndescription: Charcoal UI component guidance\nalwaysApply: true\n---\n\n'
        : '';
    next = '$cursorFrontMatter${prefix.isEmpty ? '' : '$prefix\n\n'}$block\n';
  }
  target.parent.createSync(recursive: true);
  target.writeAsStringSync(next);
  return CharcoalInstructionWrite(
    changed: next != existing,
    path: p.relative(target.path, from: root),
  );
}

final class CharcoalInstructionWrite {
  const CharcoalInstructionWrite({required this.changed, required this.path});

  final bool changed;
  final String path;
}
