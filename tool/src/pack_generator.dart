import 'dart:convert';
import 'dart:io';

import 'dart_source.dart';
import 'dart_token_generator.dart';
import 'token_model.dart';

/// Where the hand-edited role mapping lives, relative to the repository root.
const packSourcePath = 'tokens/theme/charcoal.pack.json';

/// Where the generated pack is written, relative to the repository root.
const packOutputPath = 'packages/charcoal_theme/lib/src/packs/charcoal_pack.g.dart';

const _contractDirectory = 'packages/charcoal_theme/lib/src/contract';

/// One field of a contract class: `final <type> <name>;`.
final class ContractField {
  const ContractField(this.type, this.name);

  final String type;
  final String name;
}

/// The names the pack must cover, read from the contract sources (`charcoal_theme` is the
/// single source of truth; there is no second list to keep in sync).
final class PackContract {
  const PackContract({
    required this.colors,
    required this.groups,
    required this.textRoles,
    required this.typographyScalars,
  });

  /// Colour role names, in declaration order.
  final List<String> colors;

  /// Scale groups other than colours and typography: group name to fields.
  final Map<String, List<ContractField>> groups;

  /// `CharcoalTextRole` values.
  final List<String> textRoles;

  /// Non-role fields of `CharcoalTypeScale` that the pack must provide.
  final List<ContractField> typographyScalars;

  static const _groupClasses = <String, (String, String)>{
    'space': ('space.dart', 'CharcoalSpaceScale'),
    'radius': ('radius.dart', 'CharcoalRadiusScale'),
    'borders': ('borders.dart', 'CharcoalBorderScale'),
    'sizes': ('sizes.dart', 'CharcoalSizeScale'),
    'motion': ('motion.dart', 'CharcoalMotionScale'),
    'elevation': ('elevation.dart', 'CharcoalElevationScale'),
  };

  static PackContract load(Directory root) {
    String read(String name) {
      final file = File('${root.path}/$_contractDirectory/$name');
      if (!file.existsSync()) {
        throw TokenGenerationException('Missing contract source ${file.path}.');
      }
      return file.readAsStringSync();
    }

    final colors = _fields(read('colors.dart'), 'CharcoalColorRoles').map((f) => f.name).toList();
    final groups = <String, List<ContractField>>{
      for (final entry in _groupClasses.entries)
        entry.key: _fields(read(entry.value.$1), entry.value.$2),
    };
    final typography = read('typography.dart');
    final textRoles = _enumValues(typography, 'CharcoalTextRole');
    final scaleFields = _fields(typography, 'CharcoalTypeScale');
    final roleSet = textRoles.toSet();
    final scalars = scaleFields
        .where((f) => !roleSet.contains(f.name) && !f.type.endsWith('?'))
        .toList();
    return PackContract(
      colors: colors,
      groups: groups,
      textRoles: textRoles,
      typographyScalars: scalars,
    );
  }
}

String _classBody(String source, String className) {
  final start = RegExp(
    '^(?:final |abstract |base )?class $className\\b',
    multiLine: true,
  ).firstMatch(source);
  if (start == null) {
    throw TokenGenerationException('Contract class $className not found.');
  }
  final end = source.indexOf(RegExp(r'^}', multiLine: true), start.start);
  return source.substring(start.start, end < 0 ? source.length : end);
}

List<ContractField> _fields(String source, String className) => <ContractField>[
  for (final match in RegExp(
    r'^  final ([A-Za-z<>?]+) (\w+);',
    multiLine: true,
  ).allMatches(_classBody(source, className)))
    ContractField(match.group(1)!, match.group(2)!),
];

List<String> _enumValues(String source, String enumName) {
  final start = source.indexOf('enum $enumName');
  if (start < 0) {
    throw TokenGenerationException('Contract enum $enumName not found.');
  }
  final end = source.indexOf(RegExp(r'^}', multiLine: true), start);
  return <String>[
    for (final match in RegExp(
      r'^  (\w+),$',
      multiLine: true,
    ).allMatches(source.substring(start, end)))
      match.group(1)!,
  ];
}

/// Generates `charcoal_pack.g.dart` from `charcoal.pack.json` and the resolved token bundle.
final class PackGenerator {
  PackGenerator({required this.bundle, required this.packJson, required this.contract});

  final TokenBundle bundle;
  final String packJson;
  final PackContract contract;

  /// Token path (`color.container/primary/default`) to the pack names that read it.
  ///
  /// Valid only after [render] has run (it validates while collecting).
  final Map<String, Set<String>> references = <String, Set<String>>{};

  GeneratedArtifact render() {
    references.clear();
    final spec = _decode();
    final output = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln('// Generated from tokens/theme/charcoal.pack.json and the Charcoal V2 tokens by')
      ..writeln('// `dart run tool/tokens.dart generate`.')
      ..writeln()
      ..writeln("import 'dart:ui' show Brightness, Color;")
      ..writeln()
      ..writeln("import 'package:flutter/animation.dart' show Cubic;")
      ..writeln("import 'package:flutter/painting.dart' show FontWeight;")
      ..writeln()
      ..writeln("import '../contract/borders.dart';")
      ..writeln("import '../contract/colors.dart';")
      ..writeln("import '../contract/elevation.dart';")
      ..writeln("import '../contract/motion.dart';")
      ..writeln("import '../contract/radius.dart';")
      ..writeln("import '../contract/sizes.dart';")
      ..writeln("import '../contract/space.dart';")
      ..writeln("import '../contract/typography.dart';")
      ..writeln("import '../pack.dart';")
      ..writeln("import 'charcoal_metrics.dart';");
    for (final mode in const <String>['light', 'dark']) {
      output
        ..writeln()
        ..writeln('/// The Charcoal look in $mode mode. Generated; edit the pack JSON instead.')
        ..writeln(
          'const CharcoalThemePack charcoal${mode == 'light' ? 'Light' : 'Dark'}Pack = '
          'CharcoalThemePack(',
        )
        ..writeln('  name: ${dartStringLiteral(spec.name)},')
        ..writeln('  brightness: Brightness.$mode,');
      _writeColors(output, spec, mode);
      for (final entry in contract.groups.entries) {
        _writeGroup(output, spec, entry.key, entry.value, mode);
      }
      _writeTypography(output, spec, mode);
      output
        ..writeln('  metrics: charcoalMetrics,')
        ..writeln(');');
    }
    return GeneratedArtifact(relativePath: packOutputPath, contents: output.toString());
  }

  // --- decoding and validation -------------------------------------------------------------

  _PackSpec _decode() {
    final Object? decoded;
    try {
      decoded = jsonDecode(packJson);
    } on FormatException catch (error) {
      throw TokenGenerationException('$packSourcePath is not valid JSON: ${error.message}');
    }
    final root = _asMap(decoded, packSourcePath);
    const known = <String>{
      'schemaVersion',
      'name',
      'colors',
      'extensions',
      'space',
      'radius',
      'borders',
      'sizes',
      'motion',
      'elevation',
      'typography',
    };
    final unknownKeys = root.keys.where((key) => !known.contains(key)).toList()..sort();
    if (unknownKeys.isNotEmpty) {
      throw TokenGenerationException(
        '$packSourcePath has unknown top-level keys: ${unknownKeys.join(', ')}.',
      );
    }
    if (root['schemaVersion'] != 1) {
      throw const TokenGenerationException('$packSourcePath needs "schemaVersion": 1.');
    }
    final name = root['name'];
    if (name is! String || name.isEmpty) {
      throw const TokenGenerationException('$packSourcePath needs a non-empty "name".');
    }

    final colors = _asMap(root['colors'], '$packSourcePath colors');
    final extensions = _asMap(root['extensions'], '$packSourcePath extensions');
    final contractColors = contract.colors.toSet();

    final unknownColors = <String>[
      ...colors.keys.where((key) => !contractColors.contains(key)),
      ...extensions.keys.where((key) => !contractColors.contains(key)),
    ]..sort();
    if (unknownColors.isNotEmpty) {
      throw TokenGenerationException(
        'Pack maps colour roles the contract does not have: ${unknownColors.join(', ')}.',
      );
    }
    final both = colors.keys.where(extensions.containsKey).toList()..sort();
    if (both.isNotEmpty) {
      throw TokenGenerationException(
        'Colour roles mapped in both "colors" and "extensions": ${both.join(', ')}.',
      );
    }
    final missing = contract.colors
        .where((role) => !colors.containsKey(role) && !extensions.containsKey(role))
        .toList();
    if (missing.isNotEmpty) {
      throw TokenGenerationException(
        'Contract colour roles without a mapping: ${missing.join(', ')}.',
      );
    }

    final colorValues = <String, _ModeValue>{};
    for (final role in contract.colors) {
      final isExtension = extensions.containsKey(role);
      final raw = isExtension ? extensions[role] : colors[role];
      colorValues[role] = _colorValue(role, raw, isExtension: isExtension);
    }

    final groupValues = <String, Map<String, _ModeValue>>{};
    for (final entry in contract.groups.entries) {
      groupValues[entry.key] = _groupValues(entry.key, entry.value, root[entry.key]);
    }
    return _PackSpec(
      name: name,
      colors: colorValues,
      groups: groupValues,
      typography: _typographyValues(_asMap(root['typography'], '$packSourcePath typography')),
    );
  }

  _ModeValue _colorValue(String role, Object? raw, {required bool isExtension}) {
    final where = 'colour role "$role"';
    if (raw is Map<String, dynamic>) {
      return _perMode(raw, where, (value, mode) => _colorSource(value, mode, where, isExtension));
    }
    if (isExtension) {
      throw TokenGenerationException(
        'Extension $where must give both modes as {"light": ..., "dark": ...}.',
      );
    }
    return _ModeValue.shared(
      (mode) => _colorSource(raw, mode, where, false),
      raw is String ? raw : null,
    );
  }

  /// Returns the Dart expression for a colour and records the token reference it reads.
  String _colorSource(Object? value, String mode, String where, bool allowLiteral) {
    if (value is! String) {
      throw TokenGenerationException('$where must be a token reference string, got $value.');
    }
    final reference = TokenReference.tryParse(value);
    if (reference != null) {
      final resolved = _resolve(reference, mode, where);
      return _colorLiteral(resolved, '$where -> ${reference.path}');
    }
    if (!allowLiteral) {
      throw TokenGenerationException(
        '$where is the literal "$value"; literal colours belong in "extensions", '
        'mapped for both modes.',
      );
    }
    return _hexColor(value, where);
  }

  Object _resolve(TokenReference reference, String mode, String where) {
    final tree = mode == 'light' ? bundle.light : bundle.dark;
    final value = tree[reference.category]?[reference.key];
    if (value == null) {
      throw TokenGenerationException(
        'Unknown token reference {${reference.path}} in $where ($mode).',
      );
    }
    return value;
  }

  _ModeValue _perMode(
    Map<String, dynamic> raw,
    String where,
    String Function(Object? value, String mode) build,
  ) {
    final keys = raw.keys.toSet();
    if (keys.length != 2 || !keys.containsAll(const <String>['light', 'dark'])) {
      throw TokenGenerationException(
        'Light/dark key mismatch in $where: expected exactly "light" and "dark", '
        'got ${(keys.toList()..sort()).join(', ')}.',
      );
    }
    return _ModeValue.perMode(
      light: build(raw['light'], 'light'),
      dark: build(raw['dark'], 'dark'),
      lightSource: raw['light'] is String ? raw['light'] as String : null,
      darkSource: raw['dark'] is String ? raw['dark'] as String : null,
    );
  }

  Map<String, _ModeValue> _groupValues(String group, List<ContractField> fields, Object? raw) {
    final map = _asMap(raw, '$packSourcePath $group');
    final names = fields.map((f) => f.name).toSet();
    final unknown = map.keys.where((key) => !names.contains(key)).toList()..sort();
    if (unknown.isNotEmpty) {
      throw TokenGenerationException(
        'Pack maps $group entries the contract does not have: ${unknown.join(', ')}.',
      );
    }
    final missing = fields.where((f) => !map.containsKey(f.name)).map((f) => f.name).toList();
    if (missing.isNotEmpty) {
      throw TokenGenerationException(
        'Contract $group entries without a mapping: ${missing.join(', ')}.',
      );
    }
    return <String, _ModeValue>{
      for (final field in fields)
        field.name: _scalarValue('$group.${field.name}', field.type, map[field.name]),
    };
  }

  _ModeValue _scalarValue(String where, String type, Object? raw) {
    if (raw is Map<String, dynamic>) {
      return _perMode(raw, where, (value, mode) => _scalarSource(where, type, value, mode));
    }
    return _ModeValue.shared(
      (mode) => _scalarSource(where, type, raw, mode),
      raw is String ? raw : null,
    );
  }

  String _scalarSource(String where, String type, Object? value, String mode) {
    switch (type) {
      case 'double':
        if (value is num) {
          return _double(value.toDouble());
        }
        if (value is String) {
          final reference = TokenReference.tryParse(value);
          if (reference != null) {
            final resolved = _resolve(reference, mode, where);
            if (reference.category == 'text') {
              return _double(_pixelsOrNumber(resolved, '$where -> ${reference.path}'));
            }
            return _double(parsePixels(resolved, path: '$where -> ${reference.path}'));
          }
        }
        throw TokenGenerationException('$where must be a number or a token reference, got $value.');
      case 'Duration':
        final match = value is String ? RegExp(r'^(\d+)ms$').firstMatch(value) : null;
        if (match == null) {
          throw TokenGenerationException('$where must be a duration like "120ms", got $value.');
        }
        return 'Duration(milliseconds: ${match.group(1)})';
      case 'Curve':
        final match = value is String
            ? RegExp(
                r'^cubic\(\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\)$',
              ).firstMatch(value)
            : null;
        if (match == null) {
          throw TokenGenerationException(
            '$where must be a curve like "cubic(0.2, 0, 0, 1)", got $value.',
          );
        }
        return 'Cubic(${<String>[for (var i = 1; i <= 4; i++) _number(match.group(i)!)].join(', ')})';
      default:
        throw TokenGenerationException('$where has contract type $type the generator cannot emit.');
    }
  }

  double _pixelsOrNumber(Object resolved, String path) {
    if (resolved is num) {
      return resolved.toDouble();
    }
    return parsePixels(resolved, path: path);
  }

  Map<String, Object?> _typographyValues(Map<String, dynamic> raw) {
    final unknownKeys =
        raw.keys
            .where(
              (key) => key != 'roles' && !contract.typographyScalars.any((f) => f.name == key),
            )
            .toList()
          ..sort();
    if (unknownKeys.isNotEmpty) {
      throw TokenGenerationException(
        'Pack maps typography entries the contract does not have: ${unknownKeys.join(', ')}.',
      );
    }
    final roles = _asMap(raw['roles'], '$packSourcePath typography.roles');
    final unknownRoles = roles.keys.where((key) => !contract.textRoles.contains(key)).toList()
      ..sort();
    if (unknownRoles.isNotEmpty) {
      throw TokenGenerationException(
        'Pack maps text roles the contract does not have: ${unknownRoles.join(', ')}.',
      );
    }
    final missingRoles = contract.textRoles.where((role) => !roles.containsKey(role)).toList();
    if (missingRoles.isNotEmpty) {
      throw TokenGenerationException(
        'Contract text roles without a mapping: ${missingRoles.join(', ')}.',
      );
    }
    final missingScalars = contract.typographyScalars
        .where((f) => !raw.containsKey(f.name))
        .map((f) => f.name)
        .toList();
    if (missingScalars.isNotEmpty) {
      throw TokenGenerationException(
        'Contract typography entries without a mapping: ${missingScalars.join(', ')}.',
      );
    }

    final values = <String, Object?>{};
    for (final role in contract.textRoles) {
      final spec = _asMap(roles[role], '$packSourcePath typography.roles.$role');
      final specKeys = spec.keys.toSet();
      if (specKeys.length != 3 ||
          !specKeys.containsAll(const <String>['fontSize', 'lineHeight', 'weight'])) {
        throw TokenGenerationException(
          'typography.roles.$role needs exactly fontSize, lineHeight and weight.',
        );
      }
      values[role] = <String, _ModeValue>{
        'fontSize': _scalarValue('typography.$role.fontSize', 'double', spec['fontSize']),
        'lineHeight': _scalarValue('typography.$role.lineHeight', 'double', spec['lineHeight']),
        'weight': _weightValue('typography.$role.weight', spec['weight']),
      };
    }
    for (final field in contract.typographyScalars) {
      final where = 'typography.${field.name}';
      values[field.name] = switch (field.type) {
        'FontWeight' => _weightValue(where, raw[field.name]),
        'String' => _stringValue(where, raw[field.name]),
        _ => _scalarValue(where, field.type, raw[field.name]),
      };
    }
    return values;
  }

  _ModeValue _weightValue(String where, Object? raw) {
    String build(Object? value, String mode) {
      if (value is String) {
        final reference = TokenReference.tryParse(value);
        if (reference != null) {
          final resolved = _resolve(reference, mode, where);
          return 'FontWeight.w${parseFontWeight(resolved, path: '$where -> ${reference.path}')}';
        }
      }
      if (value is int) {
        return 'FontWeight.w${parseFontWeight(value, path: where)}';
      }
      throw TokenGenerationException('$where must be a font-weight token reference, got $value.');
    }

    return _ModeValue.shared((mode) => build(raw, mode), raw is String ? raw : null);
  }

  _ModeValue _stringValue(String where, Object? raw) {
    if (raw is! String || raw.isEmpty) {
      throw TokenGenerationException('$where must be a non-empty string.');
    }
    return _ModeValue.shared((_) => dartStringLiteral(raw), null);
  }

  // --- emitting ---------------------------------------------------------------------------

  void _note(_ModeValue value, String mode, String owner) {
    final source = mode == 'light' ? value.lightSource : value.darkSource;
    if (source == null) {
      return;
    }
    final reference = TokenReference.tryParse(source);
    if (reference != null) {
      references.putIfAbsent(reference.path, () => <String>{}).add(owner);
    }
  }

  void _writeColors(StringBuffer output, _PackSpec spec, String mode) {
    output.writeln('  colors: CharcoalColorRoles(');
    for (final role in contract.colors) {
      final value = spec.colors[role]!;
      _note(value, mode, 'colors.$role');
      final source = mode == 'light' ? value.lightSource : value.darkSource;
      final reference = source == null ? null : TokenReference.tryParse(source);
      final comment = reference == null ? '' : ' // ${reference.path}';
      output.writeln('    $role: ${value.expression(mode)},$comment');
    }
    output.writeln('  ),');
  }

  void _writeGroup(
    StringBuffer output,
    _PackSpec spec,
    String group,
    List<ContractField> fields,
    String mode,
  ) {
    final className = switch (group) {
      'space' => 'CharcoalSpaceScale',
      'radius' => 'CharcoalRadiusScale',
      'borders' => 'CharcoalBorderScale',
      'sizes' => 'CharcoalSizeScale',
      'motion' => 'CharcoalMotionScale',
      _ => 'CharcoalElevationScale',
    };
    output.writeln('  $group: $className(');
    for (final field in fields) {
      final value = spec.groups[group]![field.name]!;
      _note(value, mode, '$group.${field.name}');
      output.writeln('    ${field.name}: ${value.expression(mode)},');
    }
    output.writeln('  ),');
  }

  void _writeTypography(StringBuffer output, _PackSpec spec, String mode) {
    output.writeln('  typography: CharcoalTypeScale(');
    for (final role in contract.textRoles) {
      final parts = spec.typography[role]! as Map<String, _ModeValue>;
      for (final entry in parts.entries) {
        _note(entry.value, mode, 'typography.$role.${entry.key}');
      }
      output.writeln(
        '    $role: CharcoalTextSpec('
        'fontSize: ${parts['fontSize']!.expression(mode)}, '
        'lineHeight: ${parts['lineHeight']!.expression(mode)}, '
        'weight: ${parts['weight']!.expression(mode)}),',
      );
    }
    for (final field in contract.typographyScalars) {
      final value = spec.typography[field.name]! as _ModeValue;
      _note(value, mode, 'typography.${field.name}');
      output.writeln('    ${field.name}: ${value.expression(mode)},');
    }
    output.writeln('  ),');
  }
}

final class _PackSpec {
  const _PackSpec({
    required this.name,
    required this.colors,
    required this.groups,
    required this.typography,
  });

  final String name;
  final Map<String, _ModeValue> colors;
  final Map<String, Map<String, _ModeValue>> groups;
  final Map<String, Object?> typography;
}

/// A value that may differ per mode. Expressions are computed eagerly so that every
/// validation error surfaces during decoding, not during emission.
final class _ModeValue {
  _ModeValue.shared(String Function(String mode) build, String? source)
    : light = build('light'),
      dark = build('dark'),
      lightSource = source,
      darkSource = source;

  _ModeValue.perMode({
    required this.light,
    required this.dark,
    required this.lightSource,
    required this.darkSource,
  });

  final String light;
  final String dark;
  final String? lightSource;
  final String? darkSource;

  String expression(String mode) => mode == 'light' ? light : dark;
}

Map<String, dynamic> _asMap(Object? value, String where) {
  if (value is! Map<String, dynamic>) {
    throw TokenGenerationException('$where must be a JSON object.');
  }
  return value;
}

String _colorLiteral(Object value, String path) {
  final rgba = parseRgba(value, path: path);
  final argb = (rgba.alpha << 24) | (rgba.red << 16) | (rgba.green << 8) | rgba.blue;
  return 'Color(0x${argb.toRadixString(16).padLeft(8, '0').toUpperCase()})';
}

String _hexColor(String value, String where) {
  final match = RegExp(r'^#([0-9A-Fa-f]{8})$').firstMatch(value);
  if (match == null) {
    throw TokenGenerationException(
      '$where has literal "$value"; use a token reference or #AARRGGBB.',
    );
  }
  return 'Color(0x${match.group(1)!.toUpperCase()})';
}

String _double(double value) =>
    value == value.roundToDouble() ? '${value.toInt()}' : value.toString();

String _number(String text) {
  final value = double.parse(text);
  return value == value.roundToDouble() ? '${value.toInt()}' : value.toString();
}

/// Looks up which pack names read the tokens in [paths] (`color.x` without the mode prefix).
Map<String, List<String>> packRolesForTokens(
  Map<String, Set<String>> references,
  Iterable<String> paths,
) => <String, List<String>>{
  for (final path in paths)
    if (references[path] != null) path: (references[path]!.toList()..sort()),
};
