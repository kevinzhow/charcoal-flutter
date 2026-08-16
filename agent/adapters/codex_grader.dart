import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';

Future<void> main(List<String> arguments) async {
  try {
    final options = parseCharcoalCodexAdapterArguments(arguments);
    final request = readCharcoalCodexRequest(options.requestFile);
    final repositoryRoot = File.fromUri(Platform.script).parent.parent.parent;
    final responseSchema = File(
      '${repositoryRoot.path}${Platform.pathSeparator}agent${Platform.pathSeparator}'
      'adapters${Platform.pathSeparator}codex-grader-response-v1.schema.json',
    );
    final invocation = buildCharcoalCodexGraderInvocation(
      request,
      options,
      responseSchema: responseSchema,
    );
    exitCode = await runCharcoalCodexProcess(invocation);
  } on CharcoalCodexAdapterException catch (error) {
    stderr.writeln('charcoal codex grader: ${error.message}');
    exitCode = 64;
  } on ProcessException catch (error) {
    stderr.writeln('charcoal codex grader: $error');
    exitCode = 127;
  }
}
