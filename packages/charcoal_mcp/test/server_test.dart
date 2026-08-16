import 'dart:convert';

import 'package:charcoal_mcp/charcoal_mcp.dart';
import 'package:test/test.dart';

void main() {
  late CharcoalMcpServer server;

  setUp(() => server = CharcoalMcpServer());

  group('modern protocol', () {
    test('discovers versions, identity, and tools capability', () {
      final response = server.handle(_modernRequest(1, 'server/discover'))!;
      final result = response['result']! as Map<String, Object?>;

      expect(result['resultType'], 'complete');
      expect(result['supportedVersions'], contains(charcoalMcpProtocolVersion));
      expect(result['capabilities'], containsPair('tools', <String, Object?>{}));
      expect(result['cacheScope'], 'public');
      expect(result['_meta'], isNotNull);
    });

    test('rejects missing or unsupported modern metadata', () {
      final missing = server.handle(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'server/discover',
        'params': <String, Object?>{},
      })!;
      final unsupported = server.handle(
        _modernRequest(2, 'tools/list', protocolVersion: '1900-01-01'),
      )!;

      expect((missing['error']! as Map<String, Object?>)['code'], -32602);
      final error = unsupported['error']! as Map<String, Object?>;
      expect(error['code'], -32022);
      expect(error['data'], containsPair('requested', '1900-01-01'));
    });

    test('rejects discovery parameters outside standard metadata', () {
      final response = server.handle(
        _modernRequest(
          1,
          'server/discover',
          params: <String, Object?>{'unexpected': true},
        ),
      )!;

      expect((response['error']! as Map<String, Object?>)['code'], -32602);
    });

    test('lists deterministic read-only tools with cache hints', () {
      final response = server.handle(_modernRequest(1, 'tools/list'))!;
      final result = response['result']! as Map<String, Object?>;
      final tools = (result['tools']! as List<Object?>).cast<Map<String, Object?>>();

      expect(result['resultType'], 'complete');
      expect(result['ttlMs'], 3600000);
      expect(
        tools.map((tool) => tool['name']),
        <String>[
          'charcoal.search_components',
          'charcoal.get_component',
          'charcoal.search_tokens',
          'charcoal.get_example',
          'charcoal.get_catalog_status',
        ],
      );
      for (final tool in tools) {
        final annotations = tool['annotations']! as Map<String, Object?>;
        expect(annotations['readOnlyHint'], isTrue);
        expect(annotations['destructiveHint'], isFalse);
        expect(tool['inputSchema'], containsPair('type', 'object'));
      }
    });

    test('returns matching text and structured component search content', () {
      final response = server.handle(
        _modernRequest(
          1,
          'tools/call',
          params: <String, Object?>{
            'name': 'charcoal.search_components',
            'arguments': <String, Object?>{'query': 'single choice', 'limit': 2},
          },
        ),
      )!;
      final result = response['result']! as Map<String, Object?>;
      final structured = result['structuredContent']! as Map<String, Object?>;
      final content = (result['content']! as List<Object?>).single as Map<String, Object?>;

      expect(result['resultType'], 'complete');
      expect(result['isError'], isFalse);
      expect(structured['count'], 2);
      final matches = (structured['results']! as List<Object?>).cast<Map<String, Object?>>();
      expect(matches.first['name'], 'CharcoalSegmentedControl');
      expect(jsonDecode(content['text']! as String), structured);
    });

    test('keeps component details compact until source is requested', () {
      final details = _call(server, 'charcoal.get_component', <String, Object?>{'name': 'button'});
      final examples = (details['examples']! as List<Object?>).cast<Map<String, Object?>>();
      final source = _call(
        server,
        'charcoal.get_example',
        <String, Object?>{'component': 'CharcoalButton'},
      );

      expect(examples.single, isNot(contains('source')));
      expect(source.toString(), contains('CharcoalButtonVariant.primary'));
    });

    test('searches semantic tokens and exposes exact Flutter accessors', () {
      final result = _call(
        server,
        'charcoal.search_tokens',
        <String, Object?>{'query': 'layout spacing', 'kind': 'dimension'},
      );
      final tokens = (result['results']! as List<Object?>).cast<Map<String, Object?>>();

      expect(result['tier'], 'semantic');
      expect(tokens, isNotEmpty);
      expect(tokens.every((token) => token['tier'] == 'semantic'), isTrue);
      expect(
        tokens.any((token) => (token['dartAccessor']! as String).contains('theme.dimensions')),
        isTrue,
      );
    });

    test('returns tool input failures inside a visible tool result', () {
      final response = server.handle(
        _modernRequest(
          1,
          'tools/call',
          params: <String, Object?>{
            'name': 'charcoal.search_tokens',
            'arguments': <String, Object?>{'query': 'blue', 'tier': 'secret'},
          },
        ),
      )!;
      final result = response['result']! as Map<String, Object?>;
      final content = (result['content']! as List<Object?>).single as Map<String, Object?>;

      expect(result['isError'], isTrue);
      expect(result, isNot(contains('structuredContent')));
      expect(content['text'], contains('ERR_INVALID_ARGUMENT'));
    });

    test('uses protocol errors for unknown tools', () {
      final response = server.handle(
        _modernRequest(
          1,
          'tools/call',
          params: <String, Object?>{'name': 'charcoal.missing'},
        ),
      )!;

      expect((response['error']! as Map<String, Object?>)['code'], -32602);
    });
  });

  group('legacy compatibility', () {
    test('supports initialize and legacy-shaped tool responses', () {
      final initialization = server.handle(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 'init',
        'method': 'initialize',
        'params': <String, Object?>{
          'protocolVersion': '2025-11-25',
          'capabilities': <String, Object?>{},
          'clientInfo': <String, Object?>{'name': 'test', 'version': '1'},
        },
      })!;
      final list = server.handle(<String, Object?>{
        'jsonrpc': '2.0',
        'id': 2,
        'method': 'tools/list',
        'params': <String, Object?>{},
      })!;

      expect(
        (initialization['result']! as Map<String, Object?>)['protocolVersion'],
        '2025-11-25',
      );
      expect((list['result']! as Map<String, Object?>), isNot(contains('resultType')));
    });

    test('does not answer initialized notifications', () {
      expect(
        server.handle(<String, Object?>{
          'jsonrpc': '2.0',
          'method': 'notifications/initialized',
        }),
        isNull,
      );
    });
  });

  test('validates JSON-RPC envelopes and creates parse errors', () {
    final invalid = server.handle(<String, Object?>{'jsonrpc': '1.0', 'id': true})!;

    expect(invalid['id'], isNull);
    expect((invalid['error']! as Map<String, Object?>)['code'], -32600);
    expect((server.parseError()['error']! as Map<String, Object?>)['code'], -32700);
  });
}

Map<String, Object?> _call(
  CharcoalMcpServer server,
  String name,
  Map<String, Object?> arguments,
) {
  final response = server.handle(
    _modernRequest(
      1,
      'tools/call',
      params: <String, Object?>{'name': name, 'arguments': arguments},
    ),
  )!;
  final result = response['result']! as Map<String, Object?>;
  expect(result['isError'], isFalse);
  return result['structuredContent']! as Map<String, Object?>;
}

Map<String, Object?> _modernRequest(
  Object id,
  String method, {
  Map<String, Object?> params = const <String, Object?>{},
  String protocolVersion = charcoalMcpProtocolVersion,
}) {
  return <String, Object?>{
    'jsonrpc': '2.0',
    'id': id,
    'method': method,
    'params': <String, Object?>{
      ...params,
      '_meta': <String, Object?>{
        'io.modelcontextprotocol/protocolVersion': protocolVersion,
        'io.modelcontextprotocol/clientInfo': <String, Object?>{
          'name': 'charcoal-mcp-test',
          'version': '1.0.0',
        },
        'io.modelcontextprotocol/clientCapabilities': <String, Object?>{},
      },
    },
  };
}
