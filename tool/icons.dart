import 'dart:io';

import 'src/icon_pipeline.dart';

Future<void> main(List<String> arguments) async {
  try {
    final options = _IconOptions.parse(arguments);
    final pipeline = IconPipeline(Directory.current);
    switch (options.command) {
      case 'sync':
        await pipeline.sync(repository: options.repository, ref: options.ref);
        break;
      case 'generate':
        await pipeline.generate();
        break;
      case 'update':
        await pipeline.sync(repository: options.repository, ref: options.ref);
        break;
      case 'check':
        final problems = await pipeline.check();
        if (problems.isEmpty) {
          stdout.writeln('Charcoal V2 icon assets and generated catalog are up to date.');
        } else {
          for (final problem in problems) {
            stderr.writeln('- $problem');
          }
          stderr.writeln('Run `dart run tool/icons.dart generate` to repair generated files.');
          exitCode = 1;
        }
        break;
      case 'help':
        stdout.write(_usage);
        break;
    }
  } on IconPipelineException catch (error) {
    stderr.writeln(error.message);
    exitCode = 2;
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    stderr.write(_usage);
    exitCode = 64;
  }
}

final class _IconOptions {
  const _IconOptions({
    required this.command,
    required this.repository,
    required this.ref,
  });

  factory _IconOptions.parse(List<String> arguments) {
    if (arguments.isEmpty || arguments.first == '--help' || arguments.first == '-h') {
      return const _IconOptions(command: 'help', repository: 'pixiv/charcoal', ref: 'main');
    }
    final command = arguments.first;
    if (!<String>{'sync', 'generate', 'update', 'check', 'help'}.contains(command)) {
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
    return _IconOptions(command: command, repository: repository, ref: ref);
  }

  final String command;
  final String repository;
  final String ref;
}

const _usage = '''Charcoal V2 icon pipeline

Usage:
  dart run tool/icons.dart sync [--repository owner/name] [--ref tag-or-commit]
  dart run tool/icons.dart generate
  dart run tool/icons.dart update [--repository owner/name] [--ref tag-or-commit]
  dart run tool/icons.dart check

Commands:
  sync      Pin and copy the complete upstream V2 SVG catalog, then generate Dart.
  generate  Validate local SVG assets and regenerate the typed catalog.
  update    Alias for sync; useful in update automation.
  check     Fail when assets, manifest metadata, or generated Dart drift.
''';
