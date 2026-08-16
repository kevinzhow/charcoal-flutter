import 'dart:io';

import '../packages/charcoal_catalog/tool/src/catalog_generator.dart';
import 'src/agent_ready_pipeline.dart';

void main(List<String> arguments) {
  final command = arguments.isEmpty ? 'check' : arguments.singleOrNull;
  if (command == null || !<String>{'check', 'generate', 'help'}.contains(command)) {
    stderr.writeln('Usage: dart run tool/agent_ready.dart [check|generate|help]');
    exitCode = 64;
    return;
  }
  if (command == 'help') {
    stdout.write('''Usage: dart run tool/agent_ready.dart [check|generate]

  check      Fail when catalog, benchmark versions, instructions, or adapter schemas drift.
  generate   Refresh every Agent Ready artifact that can be derived from source.
''');
    return;
  }

  final root = findWorkspaceRoot(Directory.current);
  final pipeline = AgentReadyPipeline(root);
  try {
    if (command == 'generate') {
      pipeline.generate();
      stdout.writeln('Generated and validated synchronized Agent Ready artifacts.');
      return;
    }
    final problems = pipeline.check();
    if (problems.isEmpty) {
      stdout.writeln('Agent Ready artifacts are synchronized with the installed public API.');
      return;
    }
    for (final problem in problems) {
      stderr.writeln('- $problem');
    }
    stderr.writeln('Run `dart run tool/agent_ready.dart generate` to refresh derived artifacts.');
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 65;
  } on AgentReadyPipelineException catch (error) {
    for (final problem in error.problems) {
      stderr.writeln('- $problem');
    }
    exitCode = 1;
  }
}
