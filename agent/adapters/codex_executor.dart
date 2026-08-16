import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';

Future<void> main(List<String> arguments) async {
  try {
    final options = parseCharcoalCodexAdapterArguments(arguments);
    final request = readCharcoalCodexRequest(options.requestFile);
    final invocation = buildCharcoalCodexExecutorInvocation(request, options);
    exitCode = await runCharcoalCodexProcess(invocation);
  } on CharcoalCodexAdapterException catch (error) {
    stderr.writeln('charcoal codex executor: ${error.message}');
    exitCode = 64;
  } on ProcessException catch (error) {
    stderr.writeln('charcoal codex executor: $error');
    exitCode = 127;
  }
}
