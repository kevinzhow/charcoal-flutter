import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../environment.dart';
import '../runner.dart';

const String _startMarker = '<!-- charcoal-agent:start';
const String _endMarker = '<!-- charcoal-agent:end -->';

final class InitCommand extends CharcoalCommand {
  InitCommand(super.environment) {
    argParser
      ..addOption(
        'agent',
        allowed: <String>['codex', 'claude', 'cursor'],
        defaultsTo: 'codex',
        help: 'Agent whose project instruction file should be initialized.',
      )
      ..addOption(
        'profile',
        allowed: <String>['consumer', 'contributor'],
        defaultsTo: 'consumer',
        help: 'Consumer app rules or Charcoal repository contributor rules.',
      )
      ..addOption('path', help: 'Override the instruction file path inside this project.');
  }

  @override
  String get description => 'Add or refresh a versioned Charcoal block in agent instructions.';

  @override
  String get name => 'init';

  @override
  int run() {
    final agent = argResults!.option('agent')!;
    final profile = argResults!.option('profile')!;
    final requestedPath = argResults!.option('path') ?? _defaultPath(agent);
    final root = p.normalize(environment.workingDirectory.absolute.path);
    final targetPath = p.normalize(
      p.isAbsolute(requestedPath) ? requestedPath : p.join(root, requestedPath),
    );
    if (!p.isWithin(root, targetPath)) {
      throw CharcoalCliFailure(
        'ERR_UNSAFE_PATH',
        'The instruction file must stay inside the current project.',
        exitCode: ExitCode.usage.code,
      );
    }

    final target = File(targetPath);
    final existing = target.existsSync() ? target.readAsStringSync() : '';
    final block = _managedBlock(profile);
    final markerPattern = RegExp(
      '${RegExp.escape(_startMarker)}[^>]*-->.*?${RegExp.escape(_endMarker)}',
      dotAll: true,
    );
    late final String next;
    if (markerPattern.hasMatch(existing)) {
      next = existing.replaceFirst(markerPattern, block);
    } else {
      final prefix = existing.trimRight();
      final cursorFrontMatter = agent == 'cursor' && prefix.isEmpty
          ? '---\ndescription: Charcoal UI component guidance\nalwaysApply: true\n---\n\n'
          : '';
      next = '$cursorFrontMatter${prefix.isEmpty ? '' : '$prefix\n\n'}$block\n';
    }
    target.parent.createSync(recursive: true);
    target.writeAsStringSync(next);
    final relativePath = p.relative(target.path, from: root);
    environment.result(
      'init',
      <String, Object?>{
        'agent': agent,
        'profile': profile,
        'path': relativePath,
        'libraryVersion': charcoalCatalog.libraryVersion,
        'changed': next != existing,
      },
      text: '${next == existing ? 'Verified' : 'Updated'} $relativePath for $agent ($profile).',
    );
    return ExitCode.success.code;
  }
}

String _defaultPath(String agent) => switch (agent) {
  'codex' => 'AGENTS.md',
  'claude' => 'CLAUDE.md',
  'cursor' => p.join('.cursor', 'rules', 'charcoal.mdc'),
  _ => throw StateError('Unsupported agent: $agent'),
};

String _managedBlock(String profile) {
  final command = profile == 'contributor'
      ? 'fvm dart run packages/charcoal_cli/bin/charcoal.dart'
      : 'dart run charcoal_cli:charcoal';
  final common =
      '''$_startMarker version=${charcoalCatalog.libraryVersion} profile=$profile -->
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
- Score recorded Agent Ready evidence with `$command benchmark --results <path>`; complete comparisons may not use `--allow-partial`.
- Do not add runtime recipe abstractions. Catalog patterns and examples are documentation, not rendering code.
'''
      : '';
  return '$common$contributor$_endMarker';
}
