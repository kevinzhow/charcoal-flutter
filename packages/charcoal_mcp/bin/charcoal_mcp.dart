import 'dart:io';

import 'package:charcoal_mcp/charcoal_mcp.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isNotEmpty) {
    stderr.writeln('charcoal-mcp does not accept command-line arguments.');
    exitCode = 64;
    return;
  }
  await runCharcoalMcp();
}
