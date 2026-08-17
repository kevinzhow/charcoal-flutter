const String charcoalMcpProtocolVersion = '2026-07-28';
const String charcoalMcpVersion = '0.1.0';
const String charcoalMcpServerName = 'charcoal-flutter';

const List<String> charcoalMcpSupportedVersions = <String>[
  charcoalMcpProtocolVersion,
  '2025-11-25',
  '2025-06-18',
  '2025-03-26',
  '2024-11-05',
];

const Map<String, Object?> charcoalMcpServerInfo = <String, Object?>{
  'name': charcoalMcpServerName,
  'version': charcoalMcpVersion,
};

const String charcoalMcpInstructions =
    'For page work, read the design rules and search reusable patterns before selecting components. '
    'Read the exact component API, then fetch an example only '
    'when implementation source is useful. Search semantic tokens by role; primitive tokens are '
    'excluded unless explicitly requested. Existing Charcoal components own their internal geometry.';

final class McpProtocolException implements Exception {
  const McpProtocolException(this.code, this.message, {this.data});

  final int code;
  final String message;
  final Object? data;
}
