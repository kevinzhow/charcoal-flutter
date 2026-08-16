import 'dart:io';

import 'src/token_diff.dart';
import 'src/token_model.dart';
import 'src/token_pipeline.dart';

Future<void> main(List<String> arguments) async {
  try {
    final options = _TokenOptions.parse(arguments);
    final pipeline = TokenPipeline(Directory.current);
    switch (options.command) {
      case 'sync':
        await pipeline.sync(repository: options.repository, ref: options.ref);
        break;
      case 'generate':
        await pipeline.generate();
        break;
      case 'update':
        final previous = await _readPreviousSnapshot();
        await pipeline.sync(repository: options.repository, ref: options.ref);
        await pipeline.generate(previousSnapshot: previous);
        break;
      case 'check':
        final problems = await pipeline.check();
        if (problems.isNotEmpty) {
          for (final problem in problems) {
            stderr.writeln('- $problem');
          }
          stderr.writeln('Run `dart run tool/tokens.dart generate` to repair generated files.');
          exitCode = 1;
        } else {
          stdout.writeln('Charcoal V2 token sources and generated files are up to date.');
        }
        break;
      case 'diff':
        final diff = await pipeline.diff();
        stdout.write(diff.renderMarkdown());
        break;
      case 'help':
        stdout.write(_usage);
        break;
    }
  } on TokenGenerationException catch (error) {
    stderr.writeln(error.message);
    exitCode = 2;
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    stderr.write(_usage);
    exitCode = 64;
  }
}

Future<Map<String, Object>?> _readPreviousSnapshot() async {
  final file = File('tokens/snapshot.json');
  if (!await file.exists()) {
    return null;
  }
  return decodeSnapshot(await file.readAsString());
}

final class _TokenOptions {
  const _TokenOptions({
    required this.command,
    required this.repository,
    required this.ref,
  });

  factory _TokenOptions.parse(List<String> arguments) {
    if (arguments.isEmpty || arguments.first == '--help' || arguments.first == '-h') {
      return const _TokenOptions(command: 'help', repository: 'pixiv/charcoal', ref: 'main');
    }
    final command = arguments.first;
    if (!<String>{'sync', 'generate', 'update', 'check', 'diff', 'help'}.contains(command)) {
      throw FormatException('Unknown command "$command".\n');
    }

    var repository = 'pixiv/charcoal';
    var ref = 'main';
    var index = 1;
    while (index < arguments.length) {
      final option = arguments[index];
      if (option != '--repository' && option != '--ref') {
        throw FormatException('Unknown option "$option".\n');
      }
      if (index + 1 >= arguments.length) {
        throw FormatException('Missing value for $option.\n');
      }
      final value = arguments[index + 1];
      if (option == '--repository') {
        repository = value;
      } else {
        ref = value;
      }
      index += 2;
    }
    return _TokenOptions(command: command, repository: repository, ref: ref);
  }

  final String command;
  final String repository;
  final String ref;
}

const _usage = '''Charcoal V2 token compiler

Usage:
  dart run tool/tokens.dart sync [--repository owner/name] [--ref tag-or-commit]
  dart run tool/tokens.dart generate
  dart run tool/tokens.dart update [--repository owner/name] [--ref tag-or-commit]
  dart run tool/tokens.dart check
  dart run tool/tokens.dart diff

Commands:
  sync      Download and validate pinned upstream V2 JSON files.
  generate  Generate strongly typed foundation tokens.
  update    Sync, generate, and write tokens/diff.md for an update PR.
  check     Fail when sources, hashes, snapshots, or generated Dart drift.
  diff      Compare current sources with the committed token snapshot.
''';
