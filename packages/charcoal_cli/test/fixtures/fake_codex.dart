import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  await stdin.transform(utf8.decoder).join();
  final outputIndex = arguments.indexOf('--output-last-message');
  if (outputIndex >= 0) {
    final responsePath = arguments[outputIndex + 1];
    final scores = <String, Object?>{
      'apiAccuracy': 20,
      'charcoalComposition': 15,
      'tokenAndLayout': 10,
      'accessibility': 10,
      'responsiveness': 10,
      'verification': 5,
    };
    File(responsePath).writeAsStringSync(
      jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'caseId': 'responsive-actions',
        'scores': scores,
        'hardFailures': <String>[],
        'rationale': <String, Object?>{
          for (final key in scores.keys) key: 'Fake Codex evidence for $key.',
        },
      }),
    );
  } else {
    if (!arguments.contains('mcp_servers.charcoal.required=true')) {
      stderr.writeln('The protocol candidate did not receive required MCP configuration.');
      exitCode = 2;
      return;
    }
    File('lib/candidate.dart').writeAsStringSync('''
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

Widget buildBenchmarkCandidate() => CharcoalButton(
  onPressed: () {},
  variant: CharcoalButtonVariant.primary,
  child: const Text('Continue'),
);
''');
  }
  stdout.writeln(
    jsonEncode(<String, Object?>{
      'type': 'turn.completed',
      'usage': <String, Object?>{'input_tokens': 1, 'output_tokens': 1},
    }),
  );
}
