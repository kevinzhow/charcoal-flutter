// The generated pack against its JSON mapping and against `charcoal_tokens`, resolved by code
// that does not share anything with the generator.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:flutter/painting.dart' show FontWeight;
import 'package:flutter_test/flutter_test.dart';

/// The only colour roles that are not upstream tokens. Changing this list is a design decision.
const _extensionWhitelist = <String, (int, int)>{
  'barrier': (0x99000000, 0x99000000),
  'pageBackdrop': (0xFF000000, 0xFF000000),
  'focusRingInner': (0xFFFFFFFF, 0xFFFFFFFF),
  'shadow': (0x1A000000, 0x1A000000),
  'tagBackground': (0xFF7ACCB1, 0xFF7ACCB1),
  'iconHint': (0xFF858585, 0xFF858585),
  'positiveSurface': (0xFFEAF8E8, 0xFF14301A),
  'negativeSurface': (0xFFFDF0ED, 0xFF3A1B1A),
  'infoSurface': (0xFFECF4FD, 0xFF14273A),
  'noticeSurface': (0xFFFAF3DD, 0xFF33270D),
};

Map<String, dynamic> _readPack() {
  var dir = Directory.current;
  while (!File('${dir.path}/tokens/theme/charcoal.pack.json').existsSync()) {
    dir = dir.parent;
  }
  return jsonDecode(File('${dir.path}/tokens/theme/charcoal.pack.json').readAsStringSync())
      as Map<String, dynamic>;
}

String _refPath(Object? value) {
  final text = value! as String;
  expect(text, startsWith('{'));
  expect(text, endsWith('}'));
  return text.substring(1, text.length - 1);
}

void main() {
  final json = _readPack();
  final colors = json['colors'] as Map<String, dynamic>;
  final extensions = json['extensions'] as Map<String, dynamic>;

  final modes = <String, ({CharcoalThemePack pack, CharcoalGeneratedModeTokens tokens})>{
    'light': (pack: charcoalLightPack, tokens: _tokens(CharcoalGeneratedColorTokens.light, true)),
    'dark': (pack: charcoalDarkPack, tokens: _tokens(CharcoalGeneratedColorTokens.dark, false)),
  };

  test('the JSON maps exactly the contract colour roles, each once', () {
    final contract = charcoalLightPack.colors.toMap().keys.toSet();
    expect(colors.keys.toSet().intersection(extensions.keys.toSet()), isEmpty);
    expect({...colors.keys, ...extensions.keys}, contract);
    expect(contract, hasLength(88));
  });

  test('both packs carry the same names', () {
    expect(charcoalLightPack.toFlatMap().keys.toList(), charcoalDarkPack.toFlatMap().keys.toList());
  });

  test('extensions are an explicit whitelist with both modes', () {
    expect(extensions.keys.toSet(), _extensionWhitelist.keys.toSet());
    for (final entry in _extensionWhitelist.entries) {
      final role = entry.key;
      expect(charcoalLightPack.colors.toMap()[role], Color(entry.value.$1), reason: 'light $role');
      expect(charcoalDarkPack.colors.toMap()[role], Color(entry.value.$2), reason: 'dark $role');
    }
  });

  for (final mode in modes.entries) {
    final pack = mode.value.pack;
    final tokens = mode.value.tokens;

    group('${mode.key} pack equals charcoal_tokens', () {
      test('every mapped colour role equals its token', () {
        final actual = pack.colors.toMap();
        for (final entry in colors.entries) {
          final path = _refPath(entry.value);
          expect(tokens.colors[path], isNotNull, reason: 'token $path exists');
          expect(actual[entry.key], tokens.colors[path], reason: '${entry.key} <- $path');
        }
      });

      test('every mapped dimension equals its token', () {
        for (final group in <String, Map<String, Object?>>{
          'space': pack.space.toMap(),
          'radius': pack.radius.toMap(),
          'borders': pack.borders.toMap(),
          'sizes': pack.sizes.toMap(),
        }.entries) {
          final mapping = json[group.key] as Map<String, dynamic>;
          expect(group.value.keys.toSet(), mapping.keys.toSet(), reason: group.key);
          for (final entry in mapping.entries) {
            final actual = group.value[entry.key];
            if (entry.value is num) {
              expect(actual, (entry.value as num).toDouble(), reason: '${group.key}.${entry.key}');
            } else {
              final path = _refPath(entry.value);
              expect(tokens.dimensions[path], isNotNull, reason: 'token $path exists');
              expect(actual, tokens.dimensions[path], reason: '${group.key}.${entry.key} <- $path');
            }
          }
        }
      });

      test('every type role equals its tokens', () {
        final typography = json['typography'] as Map<String, dynamic>;
        final roles = typography['roles'] as Map<String, dynamic>;
        expect(roles.keys.toSet(), CharcoalTextRole.values.map((r) => r.name).toSet());
        for (final role in CharcoalTextRole.values) {
          final mapping = roles[role.name] as Map<String, dynamic>;
          final spec = pack.typography.spec(role);
          double size(Object? v) => v is num ? v.toDouble() : tokens.dimensions[_refPath(v)]!;
          expect(spec.fontSize, size(mapping['fontSize']), reason: '${role.name} fontSize');
          expect(spec.lineHeight, size(mapping['lineHeight']), reason: '${role.name} lineHeight');
          expect(spec.weight, tokens.weights[_refPath(mapping['weight'])], reason: role.name);
        }
        expect(
          pack.typography.weightRegular,
          tokens.weights[_refPath(typography['weightRegular'])],
        );
        expect(pack.typography.weightBold, tokens.weights[_refPath(typography['weightBold'])]);
      });
    });
  }

  test('light and dark differ where the tokens differ', () {
    expect(charcoalLightPack.colors.background, isNot(charcoalDarkPack.colors.background));
    expect(
      charcoalLightPack.colors.positiveSurface,
      isNot(charcoalDarkPack.colors.positiveSurface),
    );
  });
}

/// Token values by upstream path (`color.background/default`, `space.component/10`, ...).
class CharcoalGeneratedModeTokens {
  CharcoalGeneratedModeTokens(this.colors, this.dimensions, this.weights);

  final Map<String, Color> colors;
  final Map<String, double> dimensions;
  final Map<String, FontWeight> weights;
}

CharcoalGeneratedModeTokens _tokens(CharcoalColorTokens colors, bool light) {
  final dimensions = light
      ? CharcoalGeneratedDimensionTokens.light
      : CharcoalGeneratedDimensionTokens.dark;
  final typography = light
      ? CharcoalGeneratedTypographyTokens.light
      : CharcoalGeneratedTypographyTokens.dark;
  return CharcoalGeneratedModeTokens(
    <String, Color>{for (final e in colors.entries) e.path: e.value},
    <String, double>{
      for (final e in dimensions.space.entries) e.path: e.value,
      for (final e in dimensions.radius.entries) e.path: e.value,
      for (final e in dimensions.borderWidth.entries) e.path: e.value,
      for (final e in typography.fontSize.entries) e.path: e.value,
      for (final e in typography.lineHeight.entries) e.path: e.value,
    },
    <String, FontWeight>{for (final e in typography.fontWeight.entries) e.path: e.value},
  );
}
