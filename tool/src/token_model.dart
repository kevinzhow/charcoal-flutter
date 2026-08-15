import 'dart:convert';

typedef TokenTree = Map<String, Map<String, Object>>;

final class TokenGenerationException implements Exception {
  const TokenGenerationException(this.message);

  final String message;

  @override
  String toString() => 'TokenGenerationException: $message';
}

final class TokenReference {
  const TokenReference({required this.category, required this.key});

  final String category;
  final String key;

  String get path => '$category.$key';

  static TokenReference? tryParse(Object value) {
    if (value is! String || !value.startsWith('{') || !value.endsWith('}')) {
      return null;
    }
    final body = value.substring(1, value.length - 1);
    if (body.contains('{') || body.contains('}')) {
      throw TokenGenerationException('Malformed token reference: $value');
    }
    final separator = body.indexOf('.');
    if (separator <= 0 || separator == body.length - 1) {
      throw TokenGenerationException('Malformed token reference: $value');
    }
    return TokenReference(
      category: body.substring(0, separator),
      key: body.substring(separator + 1),
    );
  }
}

final class TokenBundle {
  TokenBundle._({
    required this.base,
    required this.lightApplied,
    required this.darkApplied,
    required this.light,
    required this.dark,
  });

  factory TokenBundle.parse({
    required String baseJson,
    required String lightJson,
    required String darkJson,
  }) {
    final base = decodeTokenTree(baseJson, sourceName: 'base.json');
    final lightApplied = decodeTokenTree(lightJson, sourceName: 'pixiv-light.json');
    final darkApplied = decodeTokenTree(darkJson, sourceName: 'pixiv-dark.json');

    _validateModeParity(lightApplied, darkApplied);

    final lightMerged = mergeTokenTrees(base, lightApplied);
    final darkMerged = mergeTokenTrees(base, darkApplied);
    final light = TokenResolver(lightMerged, mode: 'light').resolveAll();
    final dark = TokenResolver(darkMerged, mode: 'dark').resolveAll();

    _validateResolvedTree(light, mode: 'light');
    _validateResolvedTree(dark, mode: 'dark');

    return TokenBundle._(
      base: base,
      lightApplied: lightApplied,
      darkApplied: darkApplied,
      light: light,
      dark: dark,
    );
  }

  final TokenTree base;
  final TokenTree lightApplied;
  final TokenTree darkApplied;
  final TokenTree light;
  final TokenTree dark;

  Map<String, Object> snapshot() => <String, Object>{
    'schemaVersion': 1,
    'light': flattenTokenTree(light),
    'dark': flattenTokenTree(dark),
  };
}

TokenTree decodeTokenTree(String source, {required String sourceName}) {
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException catch (error) {
    throw TokenGenerationException('$sourceName is not valid JSON: ${error.message}');
  }
  if (decoded is! Map<String, dynamic>) {
    throw TokenGenerationException('$sourceName must contain a JSON object at its root.');
  }

  final result = <String, Map<String, Object>>{};
  final categories = decoded.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  for (final categoryEntry in categories) {
    final categoryValue = categoryEntry.value;
    if (categoryValue is! Map<String, dynamic>) {
      throw TokenGenerationException(
        '$sourceName category "${categoryEntry.key}" must be an object.',
      );
    }
    final tokens = <String, Object>{};
    final entries = categoryValue.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    for (final tokenEntry in entries) {
      final definition = tokenEntry.value;
      if (definition is! Map<String, dynamic> || !definition.containsKey('value')) {
        throw TokenGenerationException(
          '$sourceName token "${categoryEntry.key}.${tokenEntry.key}" must contain a value.',
        );
      }
      final value = definition['value'];
      if (value is! String && value is! num) {
        throw TokenGenerationException(
          '$sourceName token "${categoryEntry.key}.${tokenEntry.key}" has unsupported '
          'value type ${value.runtimeType}.',
        );
      }
      tokens[tokenEntry.key] = value as Object;
    }
    result[categoryEntry.key] = tokens;
  }
  return result;
}

TokenTree mergeTokenTrees(TokenTree base, TokenTree applied) {
  final categories = <String>{...base.keys, ...applied.keys}.toList()..sort();
  return <String, Map<String, Object>>{
    for (final category in categories)
      category: <String, Object>{
        ...?base[category],
        ...?applied[category],
      },
  };
}

final class TokenResolver {
  TokenResolver(this.source, {required this.mode});

  final TokenTree source;
  final String mode;
  final Map<String, Object> _cache = <String, Object>{};

  TokenTree resolveAll() {
    final result = <String, Map<String, Object>>{};
    final categories = source.keys.toList()..sort();
    for (final category in categories) {
      final resolvedCategory = <String, Object>{};
      final keys = source[category]!.keys.toList()..sort();
      for (final key in keys) {
        resolvedCategory[key] = _resolve(category, key, <String>[]);
      }
      result[category] = resolvedCategory;
    }
    return result;
  }

  Object _resolve(String category, String key, List<String> stack) {
    final path = '$category.$key';
    final cached = _cache[path];
    if (cached != null) {
      return cached;
    }
    if (stack.contains(path)) {
      throw TokenGenerationException(
        'Circular $mode token reference: ${<String>[...stack, path].join(' -> ')}',
      );
    }

    final categoryTokens = source[category];
    final value = categoryTokens?[key];
    if (value == null) {
      throw TokenGenerationException('Missing $mode token reference: $path');
    }

    final reference = TokenReference.tryParse(value);
    final Object resolved;
    if (reference == null) {
      if (value is String && (value.contains('{') || value.contains('}'))) {
        throw TokenGenerationException(
          'Embedded references are not supported at $mode token $path: $value',
        );
      }
      resolved = value;
    } else {
      resolved = _resolve(reference.category, reference.key, <String>[...stack, path]);
    }
    _cache[path] = resolved;
    return resolved;
  }
}

Map<String, Object> flattenTokenTree(TokenTree tree) {
  final flattened = <String, Object>{};
  final categories = tree.keys.toList()..sort();
  for (final category in categories) {
    final keys = tree[category]!.keys.toList()..sort();
    for (final key in keys) {
      flattened['$category.$key'] = tree[category]![key]!;
    }
  }
  return flattened;
}

void _validateModeParity(TokenTree light, TokenTree dark) {
  final lightPaths = flattenTokenTree(light).keys.toSet();
  final darkPaths = flattenTokenTree(dark).keys.toSet();
  final lightOnly = lightPaths.difference(darkPaths).toList()..sort();
  final darkOnly = darkPaths.difference(lightPaths).toList()..sort();
  if (lightOnly.isEmpty && darkOnly.isEmpty) {
    return;
  }
  throw TokenGenerationException(
    'Light/dark applied token keys do not match.'
    '${lightOnly.isEmpty ? '' : ' Light only: ${lightOnly.join(', ')}.'}'
    '${darkOnly.isEmpty ? '' : ' Dark only: ${darkOnly.join(', ')}.'}',
  );
}

void _validateResolvedTree(TokenTree tree, {required String mode}) {
  const allowedCategories = <String>{
    'border-width',
    'brand-color',
    'color',
    'paragraph-width',
    'radius',
    'space',
    'text',
  };
  final unsupported = tree.keys.where((category) => !allowedCategories.contains(category)).toList();
  if (unsupported.isNotEmpty) {
    throw TokenGenerationException(
      'Unsupported $mode token categories: ${unsupported.join(', ')}.',
    );
  }

  for (final categoryEntry in tree.entries) {
    for (final tokenEntry in categoryEntry.value.entries) {
      final path = '${categoryEntry.key}.${tokenEntry.key}';
      final value = tokenEntry.value;
      switch (categoryEntry.key) {
        case 'brand-color':
        case 'color':
          parseRgba(value, path: '$mode.$path');
        case 'border-width':
        case 'paragraph-width':
        case 'radius':
        case 'space':
          parsePixels(value, path: '$mode.$path');
        case 'text':
          if (tokenEntry.key.startsWith('font-family/')) {
            if (value is! String || value.isEmpty) {
              throw TokenGenerationException('$mode.$path must be a non-empty font family.');
            }
          } else if (tokenEntry.key.startsWith('font-weight/')) {
            parseFontWeight(value, path: '$mode.$path');
          } else if (tokenEntry.key.startsWith('font-size/') ||
              tokenEntry.key.startsWith('line-height/')) {
            parsePixels(value, path: '$mode.$path');
          } else {
            throw TokenGenerationException('Unsupported text token $mode.$path.');
          }
      }
    }
  }
}

({int red, int green, int blue, int alpha}) parseRgba(Object value, {required String path}) {
  if (value is! String) {
    throw TokenGenerationException('$path must be an rgba() string, got $value.');
  }
  final match = RegExp(
    r'^rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})(?:\s*,\s*(0|1|0?\.\d+))?\s*\)$',
  ).firstMatch(value);
  if (match == null) {
    throw TokenGenerationException('$path has unsupported color value "$value".');
  }
  final red = int.parse(match.group(1)!);
  final green = int.parse(match.group(2)!);
  final blue = int.parse(match.group(3)!);
  final alphaValue = double.parse(match.group(4) ?? '1');
  if (red > 255 || green > 255 || blue > 255 || alphaValue < 0 || alphaValue > 1) {
    throw TokenGenerationException('$path has out-of-range color value "$value".');
  }
  return (red: red, green: green, blue: blue, alpha: (alphaValue * 255).round());
}

double parsePixels(Object value, {required String path}) {
  if (value is! String) {
    throw TokenGenerationException('$path must be a px value, got $value.');
  }
  final match = RegExp(r'^(-?(?:\d+\.?\d*|\.\d+))px$').firstMatch(value);
  if (match == null) {
    throw TokenGenerationException('$path has unsupported dimension "$value".');
  }
  return double.parse(match.group(1)!);
}

int parseFontWeight(Object value, {required String path}) {
  final int? weight;
  if (value is int) {
    weight = value;
  } else if (value is double && value == value.roundToDouble()) {
    weight = value.toInt();
  } else if (value is String) {
    weight = int.tryParse(value);
  } else {
    weight = null;
  }
  if (weight == null || weight < 100 || weight > 900 || weight % 100 != 0) {
    throw TokenGenerationException('$path has unsupported font weight "$value".');
  }
  return weight;
}
