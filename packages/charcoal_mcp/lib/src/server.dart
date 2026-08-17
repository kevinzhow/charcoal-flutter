import 'dart:convert';

import 'package:charcoal_catalog/charcoal_catalog.dart';

import 'protocol.dart';

const JsonEncoder _prettyJson = JsonEncoder.withIndent('  ');

/// Stateless JSON-RPC handler over the shared Charcoal Catalog.
final class CharcoalMcpServer {
  CharcoalMcpServer({CharcoalCatalog? catalog})
    : catalog = catalog ?? charcoalCatalog,
      _search = CharcoalCatalogSearch(catalog ?? charcoalCatalog);

  final CharcoalCatalog catalog;
  final CharcoalCatalogSearch _search;

  /// Handles one decoded JSON-RPC message. Notifications intentionally return `null`.
  Map<String, Object?>? handle(Object? decoded) {
    Object? requestId;
    try {
      if (decoded is! Map<String, Object?>) {
        throw const McpProtocolException(-32600, 'Invalid Request');
      }
      if (decoded['jsonrpc'] != '2.0') {
        throw const McpProtocolException(-32600, 'Invalid Request');
      }
      final method = decoded['method'];
      if (method is! String || method.isEmpty) {
        throw const McpProtocolException(-32600, 'Invalid Request');
      }
      final hasId = decoded.containsKey('id');
      final decodedId = decoded['id'];
      if (hasId && decodedId is! String && decodedId is! int) {
        throw const McpProtocolException(-32600, 'Invalid Request');
      }
      requestId = decodedId;
      final rawParams = decoded['params'];
      if (rawParams != null && rawParams is! Map<String, Object?>) {
        throw const McpProtocolException(-32602, 'Invalid params');
      }
      final params = rawParams as Map<String, Object?>? ?? const <String, Object?>{};
      if (!hasId) {
        _handleNotification(method);
        return null;
      }
      final modern = _hasModernMetadata(params);
      if (method == 'server/discover') {
        _validateModernMetadata(params);
        _rejectUnknownParams(params, const <String>{'_meta'});
        return _success(requestId, _discoverResult());
      }
      if (method == 'initialize') {
        return _success(requestId, _initializeResult(params));
      }
      if (modern) _validateModernMetadata(params);
      return switch (method) {
        'ping' => _success(requestId, _withEra(<String, Object?>{}, modern: modern)),
        'tools/list' => _success(requestId, _listToolsResult(modern: modern)),
        'tools/call' => _success(requestId, _callTool(params, modern: modern)),
        _ => throw const McpProtocolException(-32601, 'Method not found'),
      };
    } on McpProtocolException catch (error) {
      return _error(requestId, error);
    } catch (_) {
      return _error(requestId, const McpProtocolException(-32603, 'Internal error'));
    }
  }

  /// Creates the JSON-RPC parse-error response used by transports.
  Map<String, Object?> parseError() =>
      _error(null, const McpProtocolException(-32700, 'Parse error'));

  Map<String, Object?> _discoverResult() => <String, Object?>{
    'resultType': 'complete',
    'supportedVersions': charcoalMcpSupportedVersions,
    'capabilities': <String, Object?>{
      'tools': <String, Object?>{},
    },
    '_meta': _serverMeta,
    'instructions': charcoalMcpInstructions,
    'ttlMs': 3600000,
    'cacheScope': 'public',
  };

  Map<String, Object?> _initializeResult(Map<String, Object?> params) {
    final requested = params['protocolVersion'];
    if (requested is! String) {
      throw const McpProtocolException(-32602, 'initialize requires protocolVersion.');
    }
    final selected = charcoalMcpSupportedVersions.skip(1).contains(requested)
        ? requested
        : charcoalMcpSupportedVersions[1];
    return <String, Object?>{
      'protocolVersion': selected,
      'capabilities': <String, Object?>{
        'tools': <String, Object?>{'listChanged': false},
      },
      'serverInfo': charcoalMcpServerInfo,
      'instructions': charcoalMcpInstructions,
    };
  }

  Map<String, Object?> _listToolsResult({required bool modern}) {
    final result = <String, Object?>{'tools': _toolDefinitions};
    if (modern) {
      result
        ..['resultType'] = 'complete'
        ..['ttlMs'] = 3600000
        ..['cacheScope'] = 'public'
        ..['_meta'] = _serverMeta;
    }
    return result;
  }

  Map<String, Object?> _callTool(Map<String, Object?> params, {required bool modern}) {
    final name = params['name'];
    if (name is! String) throw const McpProtocolException(-32602, 'tools/call requires name.');
    final rawArguments = params['arguments'];
    if (rawArguments != null && rawArguments is! Map<String, Object?>) {
      throw const McpProtocolException(-32602, 'tools/call arguments must be an object.');
    }
    final arguments = rawArguments as Map<String, Object?>? ?? const <String, Object?>{};
    if (!_toolNames.contains(name)) {
      throw McpProtocolException(-32602, 'Unknown tool: $name');
    }
    try {
      final structured = switch (name) {
        'charcoal.get_design_rules' => _getDesignRules(arguments),
        'charcoal.search_patterns' => _searchPatterns(arguments),
        'charcoal.get_pattern' => _getPattern(arguments),
        'charcoal.search_components' => _searchComponents(arguments),
        'charcoal.get_component' => _getComponent(arguments),
        'charcoal.search_tokens' => _searchTokens(arguments),
        'charcoal.get_example' => _getExample(arguments),
        'charcoal.get_catalog_status' => _catalogStatus(arguments),
        _ => throw StateError('Unreachable tool: $name'),
      };
      return _toolResult(structured, modern: modern);
    } on _ToolInputException catch (error) {
      return _toolError(error, modern: modern);
    }
  }

  Map<String, Object?> _getDesignRules(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{});
    return <String, Object?>{
      'catalogSchemaVersion': catalog.schemaVersion,
      'libraryVersion': catalog.libraryVersion,
      'rules': catalog.designRules.map((rule) => rule.toJson()).toList(growable: false),
      'process': catalog.designProcess.map((stage) => stage.toJson()).toList(growable: false),
    };
  }

  Map<String, Object?> _searchPatterns(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{'query', 'limit'});
    final query = _requiredString(arguments, 'query');
    final limit = _limit(arguments, fallback: 10, maximum: 50);
    final results = _search.searchPatterns(query, limit: limit);
    return <String, Object?>{
      'query': query,
      'count': results.length,
      'results': results
          .map(
            (result) => <String, Object?>{
              'id': result.pattern.id,
              'category': result.pattern.category,
              'summary': result.pattern.summary,
              'components': result.pattern.components,
              'score': result.score,
            },
          )
          .toList(growable: false),
    };
  }

  Map<String, Object?> _getPattern(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{'name'});
    final name = _requiredString(arguments, 'name');
    final pattern = _search.exactPattern(name);
    if (pattern == null) {
      throw _ToolInputException('ERR_UNKNOWN_PATTERN', 'No pattern named "$name" exists.');
    }
    return pattern.toJson();
  }

  Map<String, Object?> _searchComponents(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{'query', 'limit'});
    final query = _requiredString(arguments, 'query');
    final limit = _limit(arguments, fallback: 10, maximum: 50);
    final results = _search.search(query, limit: limit);
    return <String, Object?>{
      'query': query,
      'count': results.length,
      'results': results
          .map(
            (result) => <String, Object?>{
              'name': result.component.name,
              'category': result.component.category,
              'summary': result.component.summary,
              'documentationLevel': result.component.documentationLevel.name,
              'relatedComponents': result.component.relatedComponents,
              'score': result.score,
            },
          )
          .toList(growable: false),
    };
  }

  Map<String, Object?> _getComponent(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{'name', 'includeExampleSource'});
    final name = _requiredString(arguments, 'name');
    final includeSource = _optionalBool(arguments, 'includeExampleSource', fallback: false);
    final component = _search.exact(name);
    if (component == null) {
      throw _ToolInputException(
        'ERR_UNKNOWN_COMPONENT',
        'No component named "$name" exists. Suggestions: ${_search.suggestions(name).join(', ')}.',
      );
    }
    final result = Map<String, Object?>.from(component.toJson());
    if (!includeSource) {
      result['examples'] = component.examples
          .map(
            (example) => <String, Object?>{
              'id': example.id,
              'title': example.title,
              'description': example.description,
              'sourcePath': example.sourcePath,
            },
          )
          .toList(growable: false);
    }
    return result;
  }

  Map<String, Object?> _searchTokens(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{'query', 'kind', 'tier', 'limit'});
    final query = _requiredString(arguments, 'query');
    final limit = _limit(arguments, fallback: 20, maximum: 100);
    final rawKind = arguments['kind'];
    final kind = rawKind == null
        ? null
        : CharcoalTokenKind.values.where((value) => value.name == rawKind).firstOrNull;
    if (rawKind != null && kind == null) {
      throw const _ToolInputException(
        'ERR_INVALID_ARGUMENT',
        'kind must be color, dimension, or typography.',
      );
    }
    final rawTier = arguments['tier'] ?? 'semantic';
    final tier = CharcoalTokenTier.values.where((value) => value.name == rawTier).firstOrNull;
    if (tier == null) {
      throw const _ToolInputException(
        'ERR_INVALID_ARGUMENT',
        'tier must be semantic or primitive.',
      );
    }
    final results = _search.searchTokens(query, limit: limit, kind: kind, tier: tier);
    return <String, Object?>{
      'query': query,
      'kind': kind?.name,
      'tier': tier.name,
      'count': results.length,
      'results': results
          .map(
            (result) => <String, Object?>{
              ...result.token.toJson(),
              'score': result.score,
            },
          )
          .toList(growable: false),
    };
  }

  Map<String, Object?> _getExample(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{'component', 'id'});
    final componentName = _requiredString(arguments, 'component');
    final component = _search.exact(componentName);
    if (component == null) {
      throw _ToolInputException(
        'ERR_UNKNOWN_COMPONENT',
        'No component named "$componentName" exists.',
      );
    }
    final rawId = arguments['id'];
    if (rawId != null && rawId is! String) {
      throw const _ToolInputException('ERR_INVALID_ARGUMENT', 'id must be a string.');
    }
    final examples = rawId == null
        ? component.examples
        : component.examples.where((example) => example.id == rawId).toList(growable: false);
    if (examples.isEmpty) {
      throw _ToolInputException(
        'ERR_EXAMPLE_NOT_FOUND',
        rawId == null
            ? '${component.name} does not have a curated executable example yet.'
            : '${component.name} does not have an example named "$rawId".',
      );
    }
    return <String, Object?>{
      'component': component.name,
      'examples': examples.map((example) => example.toJson()).toList(growable: false),
    };
  }

  Map<String, Object?> _catalogStatus(Map<String, Object?> arguments) {
    _rejectUnknown(arguments, const <String>{});
    return <String, Object?>{
      'schemaVersion': catalog.schemaVersion,
      'libraryName': catalog.libraryName,
      'libraryVersion': catalog.libraryVersion,
      'coverage': catalog.coverage.toJson(),
      'mcpProtocolVersion': charcoalMcpProtocolVersion,
      'mcpServerVersion': charcoalMcpVersion,
      'supportedProtocolVersions': charcoalMcpSupportedVersions,
    };
  }

  Map<String, Object?> _toolResult(
    Map<String, Object?> structured, {
    required bool modern,
  }) {
    final result = <String, Object?>{
      'content': <Map<String, Object?>>[
        <String, Object?>{'type': 'text', 'text': _prettyJson.convert(structured)},
      ],
      'structuredContent': structured,
      'isError': false,
    };
    return _withEra(result, modern: modern);
  }

  Map<String, Object?> _toolError(_ToolInputException error, {required bool modern}) {
    final result = <String, Object?>{
      'content': <Map<String, Object?>>[
        <String, Object?>{'type': 'text', 'text': '${error.code}: ${error.message}'},
      ],
      'isError': true,
    };
    return _withEra(result, modern: modern);
  }

  Map<String, Object?> _withEra(Map<String, Object?> result, {required bool modern}) {
    if (modern) {
      result
        ..['resultType'] = 'complete'
        ..['_meta'] = _serverMeta;
    }
    return result;
  }

  void _handleNotification(String method) {
    if (method == 'notifications/initialized' || method == 'notifications/cancelled') return;
  }

  bool _hasModernMetadata(Map<String, Object?> params) {
    final meta = params['_meta'];
    return meta is Map<String, Object?> &&
        meta.containsKey('io.modelcontextprotocol/protocolVersion');
  }

  void _validateModernMetadata(Map<String, Object?> params) {
    final meta = params['_meta'];
    if (meta is! Map<String, Object?>) {
      throw const McpProtocolException(-32602, 'Missing required request _meta.');
    }
    final requested = meta['io.modelcontextprotocol/protocolVersion'];
    if (requested is! String) {
      throw const McpProtocolException(-32602, 'Missing protocol version in request _meta.');
    }
    if (requested != charcoalMcpProtocolVersion) {
      throw McpProtocolException(
        -32022,
        'Unsupported protocol version',
        data: <String, Object?>{
          'supported': charcoalMcpSupportedVersions,
          'requested': requested,
        },
      );
    }
    if (meta['io.modelcontextprotocol/clientCapabilities'] is! Map<String, Object?>) {
      throw const McpProtocolException(-32602, 'Missing client capabilities in request _meta.');
    }
  }
}

void _rejectUnknownParams(Map<String, Object?> params, Set<String> allowed) {
  final unknown = params.keys.where((key) => !allowed.contains(key)).toList(growable: false);
  if (unknown.isNotEmpty) {
    throw McpProtocolException(
      -32602,
      'Unknown request param${unknown.length == 1 ? '' : 's'}: ${unknown.join(', ')}.',
    );
  }
}

const Set<String> _toolNames = <String>{
  'charcoal.get_design_rules',
  'charcoal.search_patterns',
  'charcoal.get_pattern',
  'charcoal.search_components',
  'charcoal.get_component',
  'charcoal.search_tokens',
  'charcoal.get_example',
  'charcoal.get_catalog_status',
};

const Map<String, Object?> _serverMeta = <String, Object?>{
  'io.modelcontextprotocol/serverInfo': charcoalMcpServerInfo,
};

const List<Map<String, Object?>> _toolDefinitions = <Map<String, Object?>>[
  <String, Object?>{
    'name': 'charcoal.get_design_rules',
    'title': 'Read Charcoal page-design rules and process',
    'description':
        'Return the versioned intent, hierarchy, reuse, state, and feedback questions plus the '
        'surface-inventory, preview, runtime, and app-wide final-review process.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['catalogSchemaVersion', 'libraryVersion', 'rules', 'process'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.search_patterns',
    'title': 'Search Charcoal composition patterns',
    'description':
        'Find reviewed multi-component composition and state-ownership guidance by page intent.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'query': <String, Object?>{'type': 'string', 'minLength': 1},
        'limit': <String, Object?>{'type': 'integer', 'minimum': 1, 'maximum': 50},
      },
      'required': <String>['query'],
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['query', 'count', 'results'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.get_pattern',
    'title': 'Read a Charcoal composition pattern',
    'description':
        'Return exact component composition, states, feedback ownership, accessibility, and '
        'responsive guidance for one reviewed pattern.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'name': <String, Object?>{'type': 'string', 'minLength': 1},
      },
      'required': <String>['name'],
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['id', 'summary', 'components', 'interactionStates', 'feedback'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.search_components',
    'title': 'Search Charcoal components',
    'description':
        'Find public charcoal_ui components by product intent, name, category, or keyword. Call '
        'this before inventing a component or substituting Material/Cupertino UI.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'query': <String, Object?>{'type': 'string', 'minLength': 1},
        'limit': <String, Object?>{'type': 'integer', 'minimum': 1, 'maximum': 50},
      },
      'required': <String>['query'],
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['query', 'count', 'results'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.get_component',
    'title': 'Read a Charcoal component',
    'description':
        'Return the exact installed constructor and companion APIs, usage boundaries, accessibility '
        'rules, responsive behavior, token roles, and curated example metadata.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'name': <String, Object?>{'type': 'string', 'minLength': 1},
        'includeExampleSource': <String, Object?>{
          'type': 'boolean',
          'default': false,
          'description': 'Include full executable Dart source. Prefer get_example when possible.',
        },
      },
      'required': <String>['name'],
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['name', 'summary', 'apis', 'examples'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.search_tokens',
    'title': 'Search Charcoal tokens',
    'description':
        'Find generated token accessors by semantic role. Defaults to semantic tokens; request '
        'primitive tier only for audited foundation work.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'query': <String, Object?>{'type': 'string', 'minLength': 1},
        'kind': <String, Object?>{
          'type': 'string',
          'enum': <String>['color', 'dimension', 'typography'],
        },
        'tier': <String, Object?>{
          'type': 'string',
          'enum': <String>['semantic', 'primitive'],
          'default': 'semantic',
        },
        'limit': <String, Object?>{'type': 'integer', 'minimum': 1, 'maximum': 100},
      },
      'required': <String>['query'],
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['query', 'tier', 'count', 'results'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.get_example',
    'title': 'Read a Charcoal example',
    'description': 'Return compiling Flutter source for a curated component example.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'component': <String, Object?>{'type': 'string', 'minLength': 1},
        'id': <String, Object?>{'type': 'string', 'minLength': 1},
      },
      'required': <String>['component'],
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['component', 'examples'],
    },
    'annotations': _readOnlyAnnotations,
  },
  <String, Object?>{
    'name': 'charcoal.get_catalog_status',
    'title': 'Inspect Charcoal catalog status',
    'description': 'Return exact library, schema, coverage, token, and MCP protocol versions.',
    'inputSchema': <String, Object?>{
      'type': 'object',
      'additionalProperties': false,
    },
    'outputSchema': <String, Object?>{
      'type': 'object',
      'required': <String>['schemaVersion', 'libraryVersion', 'coverage'],
    },
    'annotations': _readOnlyAnnotations,
  },
];

const Map<String, Object?> _readOnlyAnnotations = <String, Object?>{
  'readOnlyHint': true,
  'destructiveHint': false,
  'idempotentHint': true,
  'openWorldHint': false,
};

Map<String, Object?> _success(Object? id, Map<String, Object?> result) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'result': result,
};

Map<String, Object?> _error(Object? id, McpProtocolException error) => <String, Object?>{
  'jsonrpc': '2.0',
  'id': id,
  'error': <String, Object?>{
    'code': error.code,
    'message': error.message,
    if (error.data != null) 'data': error.data,
  },
};

String _requiredString(Map<String, Object?> arguments, String name) {
  final value = arguments[name];
  if (value is! String || value.trim().isEmpty) {
    throw _ToolInputException('ERR_INVALID_ARGUMENT', '$name must be a non-empty string.');
  }
  return value.trim();
}

bool _optionalBool(Map<String, Object?> arguments, String name, {required bool fallback}) {
  final value = arguments[name];
  if (value == null) return fallback;
  if (value is! bool) throw _ToolInputException('ERR_INVALID_ARGUMENT', '$name must be a boolean.');
  return value;
}

int _limit(Map<String, Object?> arguments, {required int fallback, required int maximum}) {
  final value = arguments['limit'];
  if (value == null) return fallback;
  if (value is! int || value < 1 || value > maximum) {
    throw _ToolInputException(
      'ERR_INVALID_ARGUMENT',
      'limit must be an integer from 1 to $maximum.',
    );
  }
  return value;
}

void _rejectUnknown(Map<String, Object?> arguments, Set<String> allowed) {
  final unknown = arguments.keys.where((key) => !allowed.contains(key)).toList(growable: false);
  if (unknown.isNotEmpty) {
    throw _ToolInputException(
      'ERR_INVALID_ARGUMENT',
      'Unknown argument${unknown.length == 1 ? '' : 's'}: ${unknown.join(', ')}.',
    );
  }
}

final class _ToolInputException implements Exception {
  const _ToolInputException(this.code, this.message);

  final String code;
  final String message;
}
