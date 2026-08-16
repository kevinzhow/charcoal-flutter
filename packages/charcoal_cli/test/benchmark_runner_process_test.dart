import 'dart:convert';
import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test(
    'system runner builds and tests a disposable Flutter candidate end to end',
    () async {
      final root = _workspaceRoot(Directory.current);
      final temporary = Directory.systemTemp.createTempSync('charcoal_runner_process_test_');
      addTearDown(() => temporary.deleteSync(recursive: true));
      final suite = jsonDecode(
        File(p.join(root.path, 'agent', 'benchmarks', 'v1.json')).readAsStringSync(),
      ) as Map<String, Object?>;
      final dart = Platform.resolvedExecutable;
      final flutter = File(p.join(root.path, '.fvm', 'flutter_sdk', 'bin', 'flutter')).path;
      final fixtures = p.join(root.path, 'packages', 'charcoal_cli', 'test', 'fixtures');

      final execution = await const CharcoalBenchmarkRunner().run(
        CharcoalBenchmarkRunOptions(
          workspaceRoot: root,
          outputDirectory: Directory(p.join(temporary.path, 'run')),
          suite: suite,
          configuration: 'instructions',
          model: 'process-fixture-candidate-1',
          grader: 'process-fixture-grader-1',
          executorCommand: <String>[dart, p.join(fixtures, 'benchmark_executor.dart')],
          graderCommand: <String>[dart, p.join(fixtures, 'benchmark_grader.dart')],
          flutterCommand: <String>[flutter],
          caseIds: const <String>{'responsive-actions'},
        ),
      );

      expect(execution.report.evaluatedCases, 1);
      expect(execution.report.passedCases, 1);
      expect(execution.report.averageScore, 100);
      expect(execution.resultsFile.existsSync(), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'bundled Codex adapters execute through benchmark-run',
    () async {
      final root = _workspaceRoot(Directory.current);
      final temporary = Directory.systemTemp.createTempSync('charcoal_codex_process_test_');
      addTearDown(() => temporary.deleteSync(recursive: true));
      final fakeCodex = File(
        p.join(temporary.path, Platform.isWindows ? 'fake_codex.exe' : 'fake_codex'),
      );
      final fixture = p.join(
        root.path,
        'packages',
        'charcoal_cli',
        'test',
        'fixtures',
        'fake_codex.dart',
      );
      final compilation = await Process.run(
        Platform.resolvedExecutable,
        <String>['compile', 'exe', fixture, '-o', fakeCodex.path],
        workingDirectory: root.path,
      );
      expect(compilation.exitCode, 0, reason: '${compilation.stdout}\n${compilation.stderr}');

      final outputDirectory = p.join(temporary.path, 'codex-run');
      final output = StringBuffer();
      final errors = StringBuffer();
      final code = await runCharcoalCli(
        <String>[
          'benchmark-run',
          '--configuration',
          'protocol',
          '--model',
          'fixture-candidate',
          '--grader',
          'fixture-grader',
          '--codex',
          fakeCodex.path,
          '--case',
          'responsive-actions',
          '--output',
          outputDirectory,
          '--json',
        ],
        workingDirectory: root,
        output: output,
        errorOutput: errors,
      );

      expect(code, 0, reason: errors.toString());
      final response = jsonDecode(output.toString()) as Map<String, Object?>;
      final data = response['data']! as Map<String, Object?>;
      final report = data['report']! as Map<String, Object?>;
      expect(report['passedCases'], 1);
      final transcript = File(
        p.join(outputDirectory, 'responsive-actions', 'tools.txt'),
      ).readAsStringSync();
      expect(transcript, contains('charcoal.adapter.started'));
      expect(transcript, contains('turn.completed'));
      expect(File(p.join(outputDirectory, 'results.json')).existsSync(), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

Directory _workspaceRoot(Directory start) {
  var current = start.absolute;
  while (current.parent.path != current.path) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('charcoal_flutter_workspace')) {
      return current;
    }
    current = current.parent;
  }
  throw StateError('Workspace root not found.');
}
