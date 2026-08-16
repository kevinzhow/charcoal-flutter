import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('bin entry point preserves machine output and process exit behavior', () async {
    final root = _workspaceRoot(Directory.current);
    final result = await Process.run(
      Platform.resolvedExecutable,
      <String>[
        p.join(root.path, 'packages', 'charcoal_cli', 'bin', 'charcoal.dart'),
        'manifest',
        '--json',
      ],
      workingDirectory: root.path,
    );

    expect(result.exitCode, 0, reason: result.stderr as String);
    expect(result.stderr, isEmpty);
    final response = jsonDecode(result.stdout as String) as Map<String, Object?>;
    expect(response['type'], 'manifest');
    final data = response['data']! as Map<String, Object?>;
    final pubspec = File(
      p.join(root.path, 'packages', 'charcoal_cli', 'pubspec.yaml'),
    ).readAsStringSync();
    final packageVersion = RegExp(
      r'^version:\s*([^\s]+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(data['cliVersion'], packageVersion);
  });
}

Directory _workspaceRoot(Directory start) {
  var current = start.absolute;
  while (current.parent.path != current.path) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('charcoal_flutter_workspace')) {
      return current;
    }
    current = current.parent;
  }
  throw StateError('Workspace root not found.');
}
