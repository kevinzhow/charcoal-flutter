import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../benchmark.dart';
import '../environment.dart';
import '../runner.dart';

final class BenchmarkCommand extends CharcoalCommand {
  BenchmarkCommand(super.environment) {
    argParser
      ..addOption(
        'suite',
        defaultsTo: 'agent/benchmarks/v1.json',
        help: 'Benchmark suite JSON path.',
      )
      ..addOption('results', help: 'Recorded benchmark result JSON path.')
      ..addFlag(
        'allow-partial',
        help: 'Score recorded cases without requiring complete suite coverage.',
        negatable: false,
      );
  }

  @override
  String get description => 'Validate and score reproducible Agent Ready benchmark evidence.';

  @override
  String get name => 'benchmark';

  @override
  int run() {
    final resultsPath = argResults!.option('results');
    if (resultsPath == null) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        'benchmark requires --results <path>.',
        exitCode: ExitCode.usage.code,
      );
    }
    final suiteFile = _resolve(argResults!.option('suite')!);
    final resultsFile = _resolve(resultsPath);
    if (!suiteFile.existsSync()) {
      throw CharcoalCliFailure(
        'ERR_INPUT_NOT_FOUND',
        'Benchmark suite not found: ${suiteFile.path}',
        exitCode: ExitCode.noInput.code,
      );
    }
    if (!resultsFile.existsSync()) {
      throw CharcoalCliFailure(
        'ERR_INPUT_NOT_FOUND',
        'Benchmark results not found: ${resultsFile.path}',
        exitCode: ExitCode.noInput.code,
      );
    }
    try {
      final suite = _decodeObject(suiteFile);
      final results = _decodeObject(resultsFile);
      final report = evaluateCharcoalBenchmark(
        suite,
        results,
        allowPartial: argResults!.flag('allow-partial'),
      );
      _verifyArtifactFiles(results, relativeTo: resultsFile.parent);
      environment.result('benchmark', report.toJson(), text: _reportText(report));
      return report.failedCases == 0 ? ExitCode.success.code : 1;
    } on FormatException catch (error) {
      throw CharcoalCliFailure(
        'ERR_BENCHMARK_INVALID',
        'Invalid benchmark JSON: ${error.message}',
        exitCode: ExitCode.data.code,
      );
    } on CharcoalBenchmarkFormatException catch (error) {
      throw CharcoalCliFailure(
        'ERR_BENCHMARK_INVALID',
        error.message,
        exitCode: ExitCode.data.code,
      );
    }
  }

  File _resolve(String path) {
    return File(
      p.normalize(
        p.isAbsolute(path) ? path : p.join(environment.workingDirectory.absolute.path, path),
      ),
    );
  }
}

Map<String, Object?> _decodeObject(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('${file.path} must contain a JSON object.');
  }
  return decoded;
}

void _verifyArtifactFiles(Map<String, Object?> results, {required Directory relativeTo}) {
  final runs = (results['runs']! as List<Object?>).cast<Map<String, Object?>>();
  for (final run in runs) {
    final caseId = run['caseId']! as String;
    final artifacts = run['artifacts']! as Map<String, Object?>;
    for (final entry in artifacts.entries) {
      final path = entry.value! as String;
      final file = File(p.normalize(p.isAbsolute(path) ? path : p.join(relativeTo.path, path)));
      if (!file.existsSync()) {
        throw CharcoalBenchmarkFormatException(
          'Artifact "${entry.key}" for $caseId does not exist: ${file.path}.',
        );
      }
    }
  }
}

String _reportText(CharcoalBenchmarkReport report) {
  final buffer = StringBuffer()
    ..writeln('${report.suite} — ${report.configuration} / ${report.model}')
    ..writeln(
      '${report.passedCases}/${report.evaluatedCases} passed; '
      'average ${report.averageScore.toStringAsFixed(2)}/100',
    );
  if (report.missingCases.isNotEmpty) {
    buffer.writeln('Missing: ${report.missingCases.join(', ')}');
  }
  for (final benchmarkCase in report.cases.where((value) => value['passed'] == false)) {
    buffer.writeln(
      '[FAIL] ${benchmarkCase['caseId']}: ${benchmarkCase['score']} '
      '${(benchmarkCase['hardFailures']! as List<Object?>).join(', ')}',
    );
  }
  return buffer.toString().trimRight();
}
