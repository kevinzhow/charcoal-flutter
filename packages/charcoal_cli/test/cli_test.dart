import 'dart:convert';
import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('machine-readable commands', () {
    test('search returns a versioned JSON envelope', () async {
      final output = StringBuffer();
      final errors = StringBuffer();

      final code = await runCharcoalCli(
        <String>['search', 'single choice', '--limit', '2', '--json'],
        output: output,
        errorOutput: errors,
      );
      final response = jsonDecode(output.toString()) as Map<String, Object?>;

      expect(code, 0);
      expect(errors, isEmpty);
      expect(response['apiVersion'], 1);
      expect(response['type'], 'searchResults');
      final data = response['data']! as Map<String, Object?>;
      expect(data['count'], 2);
    });

    test('unknown components return a stable error and suggestions', () async {
      final output = StringBuffer();
      final errors = StringBuffer();

      final code = await runCharcoalCli(
        <String>['component', 'buton', '--json'],
        output: output,
        errorOutput: errors,
      );
      final response = jsonDecode(errors.toString()) as Map<String, Object?>;

      expect(code, 1);
      expect(output, isEmpty);
      expect(response['code'], 'ERR_UNKNOWN_COMPONENT');
      expect(response['suggestions'], contains('CharcoalButton'));
    });

    test('token search defaults to semantic roles and exposes exact accessors', () async {
      final output = StringBuffer();

      final code = await runCharcoalCli(
        <String>['token', 'layout spacing', '--kind', 'dimension', '--limit', '3', '--json'],
        output: output,
      );
      final response = jsonDecode(output.toString()) as Map<String, Object?>;
      final data = response['data']! as Map<String, Object?>;
      final results = (data['results']! as List<Object?>).cast<Map<String, Object?>>();

      expect(code, 0);
      expect(response['type'], 'tokenResults');
      expect(data['tier'], 'semantic');
      expect(results, isNotEmpty);
      expect(results.every((token) => token['tier'] == 'semantic'), isTrue);
      expect(results.every((token) => token['kind'] == 'dimension'), isTrue);
      expect(results.first['dartAccessor'], startsWith('theme.dimensions.'));
    });

    test('primitive token search requires explicit tier selection', () async {
      final semanticOutput = StringBuffer();
      final primitiveOutput = StringBuffer();

      await runCharcoalCli(
        <String>['token', 'blue 50', '--kind', 'color', '--json'],
        output: semanticOutput,
      );
      await runCharcoalCli(
        <String>[
          'token',
          'blue 50',
          '--kind',
          'color',
          '--tier',
          'primitive',
          '--json',
        ],
        output: primitiveOutput,
      );
      final semantic = jsonDecode(semanticOutput.toString()) as Map<String, Object?>;
      final primitive = jsonDecode(primitiveOutput.toString()) as Map<String, Object?>;

      expect((semantic['data']! as Map<String, Object?>)['count'], 0);
      expect((primitive['data']! as Map<String, Object?>)['count'], greaterThan(0));
    });

    test('pattern and design-rules expose page-level guidance', () async {
      final patternOutput = StringBuffer();
      final rulesOutput = StringBuffer();

      expect(
        await runCharcoalCli(
          <String>['pattern', 'daily checklist', '--json'],
          output: patternOutput,
        ),
        0,
      );
      expect(
        await runCharcoalCli(<String>['design-rules', '--json'], output: rulesOutput),
        0,
      );
      final pattern = jsonDecode(patternOutput.toString()) as Map<String, Object?>;
      final rules = jsonDecode(rulesOutput.toString()) as Map<String, Object?>;

      expect(pattern['type'], 'pattern');
      expect((pattern['data']! as Map<String, Object?>)['id'], 'daily-checklist');
      expect(((rules['data']! as Map<String, Object?>)['rules']! as List<Object?>), hasLength(7));
      expect(((rules['data']! as Map<String, Object?>)['process']! as List<Object?>), hasLength(5));
    });

    test('manifest declares mutations and response types', () async {
      final output = StringBuffer();

      expect(
        await runCharcoalCli(<String>['manifest', '--json'], output: output),
        0,
      );
      final response = jsonDecode(output.toString()) as Map<String, Object?>;
      final data = response['data']! as Map<String, Object?>;
      final commands = data['commands']! as List<Object?>;
      final commandRecords = commands.cast<Map<String, Object?>>();
      final init = commandRecords.firstWhere(
        (command) => command['name'] == 'init',
      );
      expect(init['mutatesFiles'], isTrue);
      expect(
        commandRecords.map((command) => command['name']),
        containsAll(<String>[
          'search',
          'pattern',
          'design-rules',
          'page-spec',
          'app-review',
          'component',
          'token',
          'benchmark',
          'benchmark-run',
          'doctor',
          'agent',
          'manifest',
        ]),
      );
      final benchmarkRun = commandRecords.firstWhere(
        (command) => command['name'] == 'benchmark-run',
      );
      expect(benchmarkRun['mutatesFiles'], isTrue);
    });

    test('benchmark-run reports all missing run inputs', () async {
      final errors = StringBuffer();

      final code = await runCharcoalCli(
        <String>['benchmark-run', '--json'],
        output: StringBuffer(),
        errorOutput: errors,
      );
      final response = jsonDecode(errors.toString()) as Map<String, Object?>;

      expect(code, 64);
      expect(response['code'], 'ERR_INVALID_ARGUMENT');
      expect(response['error'], contains('--configuration'));
      expect(response['error'], contains('--output'));
      expect(response['error'], isNot(contains('--grader-command')));
    });

    test('benchmark-run custom adapter requires both commands', () async {
      final errors = StringBuffer();

      final code = await runCharcoalCli(
        <String>[
          'benchmark-run',
          '--adapter',
          'custom',
          '--configuration',
          'baseline',
          '--model',
          'candidate',
          '--grader',
          'grader',
          '--output',
          'out',
          '--json',
        ],
        output: StringBuffer(),
        errorOutput: errors,
      );
      final response = jsonDecode(errors.toString()) as Map<String, Object?>;

      expect(code, 64);
      expect(response['code'], 'ERR_INVALID_ARGUMENT');
      expect(response['error'], contains('--executor'));
      expect(response['error'], contains('--grader-command'));
    });
  });

  group('init and doctor', () {
    late Directory project;

    setUp(() {
      project = Directory.systemTemp.createTempSync('charcoal_cli_test_');
      File(p.join(project.path, 'pubspec.yaml')).writeAsStringSync('''
name: sample
environment:
  sdk: ^3.13.0
dependencies:
  charcoal_ui:
    path: ../charcoal_ui
''');
      final packageRoot = Directory(p.join(project.path, 'charcoal_ui_stub'))..createSync();
      File(p.join(packageRoot.path, 'pubspec.yaml')).writeAsStringSync('''
name: charcoal_ui
version: 0.1.0
environment:
  sdk: ^3.13.0
''');
      final packageConfig = File(p.join(project.path, '.dart_tool', 'package_config.json'))
        ..parent.createSync();
      packageConfig.writeAsStringSync(
        jsonEncode(<String, Object?>{
          'configVersion': 2,
          'packages': <Map<String, Object?>>[
            <String, Object?>{
              'name': 'charcoal_ui',
              'rootUri': '../charcoal_ui_stub/',
              'packageUri': 'lib/',
              'languageVersion': '3.13',
            },
          ],
        }),
      );
    });

    tearDown(() => project.deleteSync(recursive: true));

    test('preserves hand-written instructions and refreshes one managed block', () async {
      final instructions = File(p.join(project.path, 'AGENTS.md'))
        ..writeAsStringSync('# Project rules\n\nKeep this sentence.\n');

      expect(
        await runCharcoalCli(
          <String>['init', '--agent', 'codex'],
          workingDirectory: project,
          output: StringBuffer(),
        ),
        0,
      );
      final first = instructions.readAsStringSync();
      expect(first, contains('Keep this sentence.'));
      expect(RegExp(r'charcoal-agent:start').allMatches(first), hasLength(1));

      final secondOutput = StringBuffer();
      expect(
        await runCharcoalCli(
          <String>['init', '--agent', 'codex'],
          workingDirectory: project,
          output: secondOutput,
        ),
        0,
      );
      expect(instructions.readAsStringSync(), first);
      expect(secondOutput.toString(), contains('Verified'));
    });

    test('doctor recognizes dependency and managed instructions', () async {
      await runCharcoalCli(
        <String>['agent', 'install'],
        workingDirectory: project,
        output: StringBuffer(),
      );
      final output = StringBuffer();

      final code = await runCharcoalCli(
        <String>['doctor', '--json'],
        workingDirectory: project,
        output: output,
      );
      final response = jsonDecode(output.toString()) as Map<String, Object?>;
      final data = response['data']! as Map<String, Object?>;

      expect(code, 0);
      expect(data['healthy'], isTrue);
      expect(data['warnings'], 0);
    });

    test('agent install and sync own a versioned project skill', () async {
      final output = StringBuffer();
      expect(
        await runCharcoalCli(
          <String>['agent', 'install', '--agent', 'all', '--json'],
          workingDirectory: project,
          output: output,
        ),
        0,
      );
      final standardSkill = Directory(
        p.join(project.path, '.agents', 'skills', charcoalPageDesignSkillName),
      );
      final claudeSkill = Directory(
        p.join(project.path, '.claude', 'skills', charcoalPageDesignSkillName),
      );
      final cursorSkill = Directory(
        p.join(project.path, '.cursor', 'skills', charcoalPageDesignSkillName),
      );
      expect(File(p.join(standardSkill.path, 'SKILL.md')).existsSync(), isTrue);
      expect(File(p.join(claudeSkill.path, 'SKILL.md')).existsSync(), isTrue);
      expect(File(p.join(cursorSkill.path, 'SKILL.md')).existsSync(), isTrue);
      expect(File(p.join(project.path, 'AGENTS.md')).existsSync(), isTrue);
      expect(File(p.join(project.path, 'CLAUDE.md')).existsSync(), isTrue);
      expect(File(p.join(project.path, '.cursor', 'rules', 'charcoal.mdc')).existsSync(), isTrue);

      File(p.join(standardSkill.path, 'SKILL.md'))
          .writeAsStringSync('\nmodified', mode: FileMode.append);
      final staleFile = File(p.join(standardSkill.path, 'references', 'removed-upstream.md'))
        ..writeAsStringSync('stale');
      final doctorOutput = StringBuffer();
      expect(
        await runCharcoalCli(
          <String>['doctor', '--json'],
          workingDirectory: project,
          output: doctorOutput,
        ),
        1,
      );
      expect(doctorOutput.toString(), contains('stale or modified'));

      expect(
        await runCharcoalCli(
          <String>['agent', 'sync', '--agent', 'all'],
          workingDirectory: project,
          output: StringBuffer(),
        ),
        0,
      );
      expect(staleFile.existsSync(), isFalse);
      final healthyOutput = StringBuffer();
      expect(
        await runCharcoalCli(
          <String>['doctor', '--json'],
          workingDirectory: project,
          output: healthyOutput,
        ),
        0,
      );
      final verifiedOutput = StringBuffer();
      expect(
        await runCharcoalCli(
          <String>['agent', 'sync', '--agent', 'all'],
          workingDirectory: project,
          output: verifiedOutput,
        ),
        0,
      );
      expect(verifiedOutput.toString(), contains('Verified'));
    });

    test('agent install preflights unmanaged skill directories before writing', () async {
      final unmanaged = File(
        p.join(
          project.path,
          '.agents',
          'skills',
          charcoalPageDesignSkillName,
          'SKILL.md',
        ),
      )..parent.createSync(recursive: true);
      unmanaged.writeAsStringSync('hand-written');
      final errors = StringBuffer();

      expect(
        await runCharcoalCli(
          <String>['agent', 'install', '--agent', 'all', '--json'],
          workingDirectory: project,
          output: StringBuffer(),
          errorOutput: errors,
        ),
        1,
      );
      expect(errors.toString(), contains('ERR_SKILL_INSTALL'));
      expect(unmanaged.readAsStringSync(), 'hand-written');
      expect(File(p.join(project.path, 'AGENTS.md')).existsSync(), isFalse);
      expect(File(p.join(project.path, 'CLAUDE.md')).existsSync(), isFalse);
      expect(Directory(p.join(project.path, '.cursor')).existsSync(), isFalse);
    });

    test('rejects paths outside the project', () async {
      final errors = StringBuffer();

      final code = await runCharcoalCli(
        <String>['init', '--path', '../outside.md', '--json'],
        workingDirectory: project,
        output: StringBuffer(),
        errorOutput: errors,
      );

      expect(code, 64);
      expect(errors.toString(), contains('ERR_UNSAFE_PATH'));
    });

    test('doctor fails when the catalog and resolved UI versions differ', () async {
      File(p.join(project.path, 'charcoal_ui_stub', 'pubspec.yaml')).writeAsStringSync('''
name: charcoal_ui
version: 0.2.0
environment:
  sdk: ^3.13.0
''');
      final output = StringBuffer();

      final code = await runCharcoalCli(
        <String>['doctor', '--json'],
        workingDirectory: project,
        output: output,
      );
      final response = jsonDecode(output.toString()) as Map<String, Object?>;
      final data = response['data']! as Map<String, Object?>;

      expect(code, 1);
      expect(data['healthy'], isFalse);
      expect(output.toString(), contains('does not match installed charcoal_ui'));
    });

    test('doctor rejects stale managed instructions', () async {
      await runCharcoalCli(
        <String>['init'],
        workingDirectory: project,
        output: StringBuffer(),
      );
      final instructions = File(p.join(project.path, 'AGENTS.md'));
      instructions.writeAsStringSync(
        instructions.readAsStringSync().replaceFirst(
          RegExp(r'version=[^\s]+'),
          'version=0.0.0',
        ),
      );
      final output = StringBuffer();

      final code = await runCharcoalCli(
        <String>['doctor', '--json'],
        workingDirectory: project,
        output: output,
      );
      final response = jsonDecode(output.toString()) as Map<String, Object?>;
      final data = response['data']! as Map<String, Object?>;

      expect(code, 1);
      expect(data['healthy'], isFalse);
      expect(output.toString(), contains('Run charcoal init'));
    });
  });
}
