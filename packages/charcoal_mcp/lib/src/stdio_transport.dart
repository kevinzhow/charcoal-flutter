import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'server.dart';

/// Newline-delimited UTF-8 transport with a protocol-clean stdout channel.
final class CharcoalStdioTransport {
  const CharcoalStdioTransport(
    this.server, {
    required this.input,
    required this.output,
    required this.errorOutput,
  });

  final CharcoalMcpServer server;
  final Stream<List<int>> input;
  final IOSink output;
  final IOSink errorOutput;

  Future<void> run() async {
    try {
      await for (final line in input.transform(utf8.decoder).transform(const LineSplitter())) {
        if (line.trim().isEmpty) continue;
        late final Map<String, Object?>? response;
        try {
          response = server.handle(jsonDecode(line));
        } on FormatException {
          response = server.parseError();
        }
        if (response != null) {
          output.writeln(jsonEncode(response));
          await output.flush();
        }
      }
    } on Object catch (error) {
      errorOutput.writeln('charcoal-mcp transport error: $error');
      rethrow;
    }
  }
}
