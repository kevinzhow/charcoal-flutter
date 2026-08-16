import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runCharcoalCli(arguments);
}
