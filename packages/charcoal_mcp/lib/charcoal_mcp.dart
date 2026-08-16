/// Model Context Protocol access to the Charcoal UI catalog.
library;

import 'dart:io';

import 'src/server.dart';
import 'src/stdio_transport.dart';

export 'src/protocol.dart';
export 'src/server.dart' show CharcoalMcpServer;

/// Runs a newline-delimited MCP server until the input stream closes.
Future<void> runCharcoalMcp({
  Stream<List<int>>? input,
  IOSink? output,
  IOSink? errorOutput,
}) {
  return CharcoalStdioTransport(
    CharcoalMcpServer(),
    input: input ?? stdin,
    output: output ?? stdout,
    errorOutput: errorOutput ?? stderr,
  ).run();
}
