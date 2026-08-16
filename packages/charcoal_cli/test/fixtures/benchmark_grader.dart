import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln('Expected one grader request path.');
    exitCode = 64;
    return;
  }
  final request = jsonDecode(File(arguments.single).readAsStringSync()) as Map<String, Object?>;
  final benchmarkCase = request['case']! as Map<String, Object?>;
  final scores = <String, Object?>{
    'apiAccuracy': 20,
    'charcoalComposition': 15,
    'tokenAndLayout': 10,
    'accessibility': 10,
    'responsiveness': 10,
    'verification': 5,
  };
  File(request['responsePath']! as String).writeAsStringSync(
    jsonEncode(<String, Object?>{
      'schemaVersion': 1,
      'caseId': benchmarkCase['id'],
      'scores': scores,
      'hardFailures': <String>[],
      'rationale': <String, Object?>{
        for (final key in scores.keys) key: 'Deterministic process-fixture rationale for $key.',
      },
    }),
  );
}
