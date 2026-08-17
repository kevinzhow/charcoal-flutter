import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../environment.dart';
import '../page_experience.dart';
import '../runner.dart';

const JsonEncoder _prettyJson = JsonEncoder.withIndent('  ');

final class PageSpecCommand extends CharcoalCommand {
  PageSpecCommand(super.environment) {
    argParser
      ..addOption('output', help: 'Write a new JSON template inside the current project.')
      ..addOption('validate', help: 'Validate an existing JSON spec inside the current project.')
      ..addOption('page-id', defaultsTo: 'replace-with-stable-page-id')
      ..addOption('title', defaultsTo: 'Replace with page title');
  }

  @override
  String get description => 'Create or validate a versioned Page Experience Spec.';

  @override
  String get name => 'page-spec';

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
    final template = buildCharcoalPageExperienceTemplate(
      pageId: argResults!.option('page-id')!,
      title: argResults!.option('title')!,
    );
    if (output == null) {
      environment.result('pageSpecTemplate', template, text: _prettyJson.convert(template));
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
      'pageSpecTemplate',
      <String, Object?>{'path': relative, 'created': true},
      text: 'Created $relative. Replace every template placeholder before validation.',
    );
    return ExitCode.success.code;
  }

  int _validate(String requestedPath) {
    final file = _projectFile(requestedPath);
    if (!file.existsSync()) {
      throw CharcoalCliFailure('ERR_INPUT_NOT_FOUND', 'No page spec exists at $requestedPath.');
    }
    late final Map<String, Object?> decoded;
    try {
      final value = jsonDecode(file.readAsStringSync());
      if (value is! Map<String, Object?>) throw const FormatException('root must be an object');
      decoded = value;
    } on FormatException catch (error) {
      throw CharcoalCliFailure(
        'ERR_PAGE_SPEC_INVALID',
        'Invalid page spec JSON: ${error.message}.',
      );
    }
    final report = validateCharcoalPageExperienceSpec(decoded);
    environment.result(
      'pageSpecValidation',
      report.toJson(),
      text: report.valid
          ? 'Page Experience Spec ${report.pageId} is valid.'
          : report.problems.map((problem) => '- $problem').join('\n'),
    );
    return report.valid ? ExitCode.success.code : 1;
  }

  File _projectFile(String requestedPath) {
    final root = p.normalize(environment.workingDirectory.absolute.path);
    final path = p.normalize(
      p.isAbsolute(requestedPath) ? requestedPath : p.join(root, requestedPath),
    );
    if (!p.isWithin(root, path)) {
      throw CharcoalCliFailure(
        'ERR_UNSAFE_PATH',
        'The page spec must stay inside the current project.',
        exitCode: ExitCode.usage.code,
      );
    }
    return File(path);
  }
}
