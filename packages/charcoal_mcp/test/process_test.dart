import 'dart:convert';
import 'dart:io';

import 'package:charcoal_mcp/charcoal_mcp.dart';
import 'package:test/test.dart';

void main() {
  test('stdio emits only newline-delimited JSON-RPC and exits on EOF', () async {
    final root = _workspaceRoot(Directory.current);
    final process = await Process.start(
      Platform.resolvedExecutable,
      <String>['packages/charcoal_mcp/bin/charcoal_mcp.dart'],
      workingDirectory: root.path,
    );
    process.stdin
      ..writeln(jsonEncode(_request(1, 'server/discover')))
      ..writeln(jsonEncode(_request(2, 'tools/list')))
      ..writeln('{not-json')
      ..writeln(
        jsonEncode(<String, Object?>{'jsonrpc': '2.0', 'method': 'notifications/initialized'}),
      );
    await process.stdin.close();

    final outputLines = await process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .toList();
    final errorText = await process.stderr.transform(utf8.decoder).join();
    final exitCode = await process.exitCode;

    expect(exitCode, 0);
    expect(errorText, isEmpty);
    expect(outputLines, hasLength(3));
    final responses = outputLines
        .map((line) => jsonDecode(line) as Map<String, Object?>)
        .toList(growable: false);
    expect(responses[0]['id'], 1);
    final discovery = responses[0]['result']! as Map<String, Object?>;
    final metadata = discovery['_meta']! as Map<String, Object?>;
    final serverInfo = metadata['io.modelcontextprotocol/serverInfo']! as Map<String, Object?>;
    final pubspec = File(
      '${root.path}/packages/charcoal_mcp/pubspec.yaml',
    ).readAsStringSync();
    final packageVersion = RegExp(
      r'^version:\s*([^\s]+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(serverInfo['version'], packageVersion);
    expect(responses[1]['id'], 2);
    expect((responses[2]['error']! as Map<String, Object?>)['code'], -32700);
  });
}

Map<String, Object?> _request(int id, String method) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'method': method,
  'params': <String, Object?>{
    '_meta': <String, Object?>{
      'io.modelcontextprotocol/protocolVersion': charcoalMcpProtocolVersion,
      'io.modelcontextprotocol/clientCapabilities': <String, Object?>{},
    },
  },
};

Directory _workspaceRoot(Directory start) {
  var current = start.absolute;
  while (current.parent.path != current.path) {
    final pubspec = File('${current.path}/pubspec.yaml');
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('charcoal_flutter_workspace')) {
      return current;
    }
    current = current.parent;
  }
  throw StateError('Workspace root not found.');
}
