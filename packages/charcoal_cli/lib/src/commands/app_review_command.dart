import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../app_experience_review.dart';
import '../environment.dart';
import '../runner.dart';

const JsonEncoder _prettyJson = JsonEncoder.withIndent('  ');

final class AppReviewCommand extends CharcoalCommand {
  AppReviewCommand(super.environment) {
    argParser
      ..addOption('output', help: 'Write a new JSON review template inside the current project.')
      ..addOption('validate', help: 'Validate an existing JSON review inside the current project.')
      ..addOption('app-id', defaultsTo: 'replace-with-stable-app-id')
      ..addOption('title', defaultsTo: 'Replace with app title');
  }

  @override
  String get description => 'Create or validate an app-wide Agent Ready review.';

  @override
  String get name => 'app-review';

  @override
  int run() {
    final output = argResults!.option('output');
    final validate = argResults!.option('validate');
    if (output != null && validate != null) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        '--output and --validate cannot be used together.',
        exitCode: ExitCode.usage.code,
      );
    }
    if (validate != null) return _validate(validate);
    final template = buildCharcoalAppExperienceReviewTemplate(
      appId: argResults!.option('app-id')!,
      title: argResults!.option('title')!,
    );
    if (output == null) {
      environment.result('appReviewTemplate', template, text: _prettyJson.convert(template));
      return ExitCode.success.code;
    }
    final target = _projectFile(output);
    if (target.existsSync()) {
      throw CharcoalCliFailure(
        'ERR_OUTPUT_EXISTS',
        '${p.relative(target.path, from: environment.workingDirectory.path)} already exists.',
      );
    }
    target.parent.createSync(recursive: true);
    target.writeAsStringSync('${_prettyJson.convert(template)}\n');
    final relative = p.relative(target.path, from: environment.workingDirectory.path);
    environment.result(
      'appReviewTemplate',
      <String, Object?>{'path': relative, 'created': true},
      text: 'Created $relative. Resolve every placeholder and finding before validation.',
    );
    return ExitCode.success.code;
  }

  int _validate(String requestedPath) {
    final file = _projectFile(requestedPath);
    if (!file.existsSync()) {
      throw CharcoalCliFailure('ERR_INPUT_NOT_FOUND', 'No app review exists at $requestedPath.');
    }
    late final Map<String, Object?> decoded;
    try {
      final value = jsonDecode(file.readAsStringSync());
      if (value is! Map<String, Object?>) throw const FormatException('root must be an object');
      decoded = value;
    } on FormatException catch (error) {
      throw CharcoalCliFailure(
        'ERR_APP_REVIEW_INVALID',
        'Invalid app review JSON: ${error.message}.',
      );
    }
    final report = validateCharcoalAppExperienceReview(
      decoded,
      projectRoot: environment.workingDirectory,
    );
    final messages = <String>[
      for (final problem in report.problems) '- Invalid: $problem',
      for (final blocker in report.blockers) '- Blocked: $blocker',
    ];
    environment.result(
      'appReviewValidation',
      report.toJson(),
      text: report.ready
          ? 'App Experience Review ${report.appId} is Agent Ready.'
          : messages.join('\n'),
    );
    return report.ready ? ExitCode.success.code : 1;
  }

  File _projectFile(String requestedPath) {
    final root = p.normalize(environment.workingDirectory.absolute.path);
    final path = p.normalize(
      p.isAbsolute(requestedPath) ? requestedPath : p.join(root, requestedPath),
    );
    if (!p.isWithin(root, path)) {
      throw CharcoalCliFailure(
        'ERR_UNSAFE_PATH',
        'The app review must stay inside the current project.',
        exitCode: ExitCode.usage.code,
      );
    }
    return File(path);
  }
}
