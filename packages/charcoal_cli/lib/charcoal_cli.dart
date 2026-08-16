/// Command-line discovery and setup tools for Charcoal UI.
library;

import 'dart:io';

import 'src/runner.dart';

export 'package:charcoal_catalog/charcoal_catalog.dart'
    show CharcoalCatalogSearch, CharcoalSearchResult, CharcoalTokenSearchResult;

export 'src/benchmark.dart'
    show
        CharcoalBenchmarkFormatException,
        CharcoalBenchmarkReport,
        charcoalBenchmarkArtifactKeys,
        charcoalBenchmarkConfigurations,
        charcoalBenchmarkHardFailures,
        charcoalBenchmarkScoreLimits,
        evaluateCharcoalBenchmark;

/// Runs the Charcoal CLI without terminating the host process.
///
/// Supplying sinks and a working directory keeps this entry point straightforward to test and
/// embed in other Dart tools.
Future<int> runCharcoalCli(
  List<String> arguments, {
  StringSink? output,
  StringSink? errorOutput,
  Directory? workingDirectory,
}) {
  final machineReadable = arguments.contains('--json');
  final sanitizedArguments = arguments.where((argument) => argument != '--json').toList();
  final environment = CharcoalCliEnvironment(
    errorOutput: errorOutput ?? stderr,
    machineReadable: machineReadable,
    output: output ?? stdout,
    workingDirectory: workingDirectory ?? Directory.current,
  );
  return CharcoalCommandRunner(environment).execute(sanitizedArguments);
}
