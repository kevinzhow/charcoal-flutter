import 'dart:convert';

import 'package:test/test.dart';

import '../tool/src/dart_token_generator.dart';
import '../tool/src/token_diff.dart';
import '../tool/src/token_model.dart';

void main() {
  group('TokenResolver', () {
    test('resolves references across categories', () {
      final resolved = TokenResolver(
        <String, Map<String, Object>>{
          'color': <String, Object>{
            'primitive': 'rgba(0, 150, 250, 1)',
            'semantic': '{color.primitive}',
          },
          'space': <String, Object>{
            '10': '4px',
            'component/10': '{space.10}',
          },
        },
        mode: 'light',
      ).resolveAll();

      expect(resolved['color']!['semantic'], 'rgba(0, 150, 250, 1)');
      expect(resolved['space']!['component/10'], '4px');
    });

    test('fails on a missing reference', () {
      final resolver = TokenResolver(
        <String, Map<String, Object>>{
          'color': <String, Object>{'semantic': '{color.missing}'},
        },
        mode: 'dark',
      );

      expect(
        resolver.resolveAll,
        throwsA(
          isA<TokenGenerationException>().having(
            (error) => error.message,
            'message',
            contains('Missing dark token reference: color.missing'),
          ),
        ),
      );
    });

    test('fails with the complete circular reference path', () {
      final resolver = TokenResolver(
        <String, Map<String, Object>>{
          'color': <String, Object>{
            'a': '{color.b}',
            'b': '{color.c}',
            'c': '{color.a}',
          },
        },
        mode: 'light',
      );

      expect(
        resolver.resolveAll,
        throwsA(
          isA<TokenGenerationException>().having(
            (error) => error.message,
            'message',
            contains('color.a -> color.b -> color.c -> color.a'),
          ),
        ),
      );
    });
  });

  group('TokenBundle', () {
    test('requires light and dark applied keys to match', () {
      final base = _json(<String, Object>{
        'color': _tokens(<String, Object>{'primitive': 'rgba(0, 0, 0, 1)'}),
      });
      final light = _json(<String, Object>{
        'color': _tokens(<String, Object>{'semantic': '{color.primitive}'}),
      });
      final dark = _json(<String, Object>{
        'color': _tokens(<String, Object>{'different': '{color.primitive}'}),
      });

      expect(
        () => TokenBundle.parse(baseJson: base, lightJson: light, darkJson: dark),
        throwsA(
          isA<TokenGenerationException>().having(
            (error) => error.message,
            'message',
            contains('Light/dark applied token keys do not match'),
          ),
        ),
      );
    });
  });

  group('value parsing', () {
    test('normalizes rgba alpha to an ARGB byte', () {
      expect(
        parseRgba('rgba(255, 43, 0, 0.32)', path: 'color.test'),
        (red: 255, green: 43, blue: 0, alpha: 82),
      );
    });

    test('rejects unsupported units', () {
      expect(
        () => parsePixels('1rem', path: 'space.test'),
        throwsA(isA<TokenGenerationException>()),
      );
    });

    test('creates stable Dart identifiers', () {
      expect(tokenIdentifier('container/on-img/default-a'), 'containerOnImgDefaultA');
      expect(tokenIdentifier('dark/blue/-10'), 'darkBlueMinus10');
      expect(tokenIdentifier('0'), 'value0');
    });
  });

  test('TokenDiff reports added, removed, and changed values', () {
    final diff = TokenDiff.between(
      <String, Object>{
        'light': <String, Object>{'color.a': 'red', 'color.old': 'black'},
        'dark': <String, Object>{'color.a': 'red'},
      },
      <String, Object>{
        'light': <String, Object>{'color.a': 'blue', 'color.new': 'white'},
        'dark': <String, Object>{'color.a': 'red'},
      },
    );

    expect(diff.added.single.path, 'light.color.new');
    expect(diff.removed.single.path, 'light.color.old');
    expect(diff.changed.single.path, 'light.color.a');
  });
}

Map<String, Object> _tokens(Map<String, Object> values) => <String, Object>{
  for (final entry in values.entries) entry.key: <String, Object>{'value': entry.value},
};

String _json(Map<String, Object> value) => jsonEncode(value);
