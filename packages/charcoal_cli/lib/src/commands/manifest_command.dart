import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../runner.dart';

final class ManifestCommand extends CharcoalCommand {
  ManifestCommand(super.environment);

  @override
  String get description => 'Describe CLI capabilities and machine-readable response contracts.';

  @override
  String get name => 'manifest';

  @override
  int run() {
    final manifest = <String, Object?>{
      'apiVersion': 1,
      'cliVersion': charcoalCliVersion,
      'catalogSchemaVersion': charcoalCatalog.schemaVersion,
      'catalogCoverage': charcoalCatalog.coverage.toJson(),
      'libraryName': charcoalCatalog.libraryName,
      'libraryVersion': charcoalCatalog.libraryVersion,
      'commands': <Map<String, Object?>>[
        <String, Object?>{
          'name': 'pattern',
          'usage': 'charcoal pattern <name-or-intent> [--limit 10] [--json]',
          'responseType': 'pattern|patternResults',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'design-rules',
          'usage': 'charcoal design-rules [--json]',
          'responseType': 'designRules',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'page-spec',
          'usage': 'charcoal page-spec [--output <path>|--validate <path>] [--json]',
          'responseType': 'pageSpecTemplate|pageSpecValidation',
          'mutatesFiles': true,
        },
        <String, Object?>{
          'name': 'search',
          'usage': 'charcoal search <query> [--limit 10] [--json]',
          'responseType': 'searchResults',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'component',
          'usage': 'charcoal component <name> [--json]',
          'responseType': 'component',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'token',
          'usage':
              'charcoal token <query> [--kind color|dimension|typography] '
              '[--tier semantic|primitive] [--limit 20] [--json]',
          'responseType': 'tokenResults',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'benchmark',
          'usage': 'charcoal benchmark --results <path> [--suite <path>] [--allow-partial]',
          'responseType': 'benchmark',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'benchmark-run',
          'usage':
              'charcoal benchmark-run --configuration <name> --model <id> --grader <id> '
              '--output <new-directory> [--adapter codex|custom]',
          'responseType': 'benchmarkRun',
          'mutatesFiles': true,
        },
        <String, Object?>{
          'name': 'doctor',
          'usage': 'charcoal doctor [--json]',
          'responseType': 'doctor',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'init',
          'usage': 'charcoal init --agent <codex|claude|cursor> [--profile consumer|contributor]',
          'responseType': 'init',
          'mutatesFiles': true,
        },
        <String, Object?>{
          'name': 'manifest',
          'usage': 'charcoal manifest [--json]',
          'responseType': 'manifest',
          'mutatesFiles': false,
        },
        <String, Object?>{
          'name': 'agent',
          'usage':
              'charcoal agent <install|sync> [--agent auto|all|codex|claude|cursor] '
              '[--scope project|user]',
          'responseType': 'agentInstall|agentSync',
          'mutatesFiles': true,
        },
      ],
      'errors': <String>[
        'ERR_INVALID_ARGUMENT',
        'ERR_BENCHMARK_INVALID',
        'ERR_BENCHMARK_RUN_FAILED',
        'ERR_INPUT_NOT_FOUND',
        'ERR_OUTPUT_EXISTS',
        'ERR_PAGE_SPEC_INVALID',
        'ERR_SKILL_INSTALL',
        'ERR_UNKNOWN_COMPONENT',
        'ERR_UNSAFE_PATH',
      ],
    };
    environment.result(
      'manifest',
      manifest,
      text:
          'Charcoal CLI $charcoalCliVersion for ${charcoalCatalog.libraryName} '
          '${charcoalCatalog.libraryVersion}\n'
          'Commands: search, pattern, design-rules, page-spec, component, token, benchmark, '
          'benchmark-run, doctor, init, agent, manifest',
    );
    return ExitCode.success.code;
  }
}
