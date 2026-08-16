import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln('Expected one executor request path.');
    exitCode = 64;
    return;
  }
  final request = jsonDecode(File(arguments.single).readAsStringSync()) as Map<String, Object?>;
  final project = request['project']! as Map<String, Object?>;
  final root = project['root']! as String;
  File('$root/lib/candidate.dart').writeAsStringSync('''
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

Widget buildBenchmarkCandidate() {
  return LayoutBuilder(
    builder: (context, constraints) => CharcoalButton(
      fullWidth: constraints.maxWidth < 480,
      onPressed: () {},
      variant: CharcoalButtonVariant.primary,
      child: const Text('Continue'),
    ),
  );
}
''');
  stdout.writeln('fixture executor completed; verification is owned by the harness');
}
