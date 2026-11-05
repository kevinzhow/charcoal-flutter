import 'dart:io';

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:charcoal_theme/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

List<String> _frozenNames() =>
    File('test/frozen_names.txt')
        .readAsLinesSync()
        .where((line) => line.isNotEmpty && !line.startsWith('#'))
        .toList();

void main() {
  group('contract shape', () {
    test('both packs define exactly the same names', () {
      expect(
        charcoalLightPack.toFlatMap().keys.toList(),
        charcoalDarkPack.toFlatMap().keys.toList(),
      );
    });

    test('contract size is what the review sees', () {
      final flat = charcoalLightPack.toFlatMap();
      expect(charcoalLightPack.colors.toMap(), hasLength(88));
      expect(flat.length, 369);
    });

    test('frozen names are append-only: every one still exists', () {
      final flat = charcoalLightPack.toFlatMap();
      final missing = _frozenNames().where((name) => !flat.containsKey(name)).toList();
      expect(missing, isEmpty, reason: 'contract names were removed or renamed: $missing');
    });

    test('names added after the freeze are appended to test/frozen_names.txt', () {
      final frozen = _frozenNames().toSet();
      final added = charcoalLightPack.toFlatMap().keys.where((k) => !frozen.contains(k)).toList();
      expect(added, isEmpty, reason: 'append these to test/frozen_names.txt: $added');
    });

    test('every value is non-null except the optional sans family', () {
      for (final entry in charcoalLightPack.toFlatMap().entries) {
        if (entry.key == 'typography.sansFamily') continue;
        expect(entry.value, isNotNull, reason: entry.key);
      }
    });

    test('colour role names are unique and camelCase', () {
      final names = charcoalLightPack.colors.toMap().keys.toList();
      expect(names.toSet(), hasLength(names.length));
      for (final name in names) {
        expect(RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(name), isTrue, reason: name);
      }
    });
  });

  group('packs', () {
    test('carry their brightness and the shared name', () {
      expect(charcoalLightPack.brightness, Brightness.light);
      expect(charcoalDarkPack.brightness, Brightness.dark);
      expect(charcoalLightPack.name, charcoalDarkPack.name);
    });

    test('light and dark differ on surfaces, text and borders', () {
      final light = charcoalLightPack.colors;
      final dark = charcoalDarkPack.colors;
      expect(light.background, isNot(dark.background));
      expect(light.text, isNot(dark.text));
      expect(light.borderSubtle, isNot(dark.borderSubtle));
      expect(light.primary, isNot(dark.primary));
    });

    test('light and dark share all geometry', () {
      final light = charcoalLightPack.toFlatMap()..removeWhere((k, _) => k.startsWith('colors.'));
      final dark = charcoalDarkPack.toFlatMap()..removeWhere((k, _) => k.startsWith('colors.'));
      expect(light, dark);
    });

    test('myopay roles keep their names and Charcoal values', () {
      final light = charcoalLightPack.colors;
      expect(light.background, const Color(0xFFFFFFFF));
      expect(light.primary, const Color(0xFF0096FA));
      expect(light.primaryHover, const Color(0xFF1F75BC));
      expect(light.negative, const Color(0xFFFD5B4E));
      expect(light.text, const Color(0xFF1F1F1F));
      expect(light.barrier, const Color(0x99000000));
      expect(charcoalDarkPack.colors.background, const Color(0xFF1F1F1F));
    });

    test('the old private geometry survives as metrics', () {
      final m = charcoalLightPack.metrics;
      expect(m.switchToggle.trackWidth, 51);
      expect(m.switchToggle.trackHeight, 31);
      expect(m.switchToggle.thumbSize, 27);
      expect(m.textArea.horizontalInset, 9);
      expect(m.tooltip.arrowHeight, 3);
      expect(m.clickable.disabledOpacity, 0.32);
      expect(charcoalLightPack.motion.standard, const Duration(milliseconds: 200));
      expect(charcoalLightPack.borders.focusHalo, 4);
    });

    test('toMap/fromMap/copyWith round-trip every group', () {
      final p = charcoalLightPack;
      expect(CharcoalColorRoles.fromMap(p.colors.toMap()), p.colors);
      expect(CharcoalSpaceScale.fromMap(p.space.toMap()), p.space);
      expect(CharcoalRadiusScale.fromMap(p.radius.toMap()), p.radius);
      expect(CharcoalBorderScale.fromMap(p.borders.toMap()), p.borders);
      expect(CharcoalSizeScale.fromMap(p.sizes.toMap()), p.sizes);
      expect(CharcoalMotionScale.fromMap(p.motion.toMap()), p.motion);
      expect(CharcoalElevationScale.fromMap(p.elevation.toMap()), p.elevation);
      expect(CharcoalMetrics.fromMap(p.metrics.toMap()), p.metrics);
      expect(p.copyWith(), p);
      expect(p.copyWith().hashCode, p.hashCode);
      expect(p.copyWith(colors: p.colors.copyWith(primary: const Color(0xFF123456))), isNot(p));
      expect(
        p.metrics.copyWith(button: p.metrics.button.copyWith(iconSize: 99)).button.iconSize,
        99,
      );
      expect(p, isNot(charcoalDarkPack));
    });

    test('transparent is a constant, not a role', () {
      expect(CharcoalColorRoles.transparent, const Color(0x00000000));
      expect(charcoalLightPack.colors.toMap().containsKey('transparent'), isFalse);
    });
  });

  group('typography', () {
    final scale = charcoalLightPack.typography;

    test('application roles keep the console values', () {
      expect(scale.pageTitle.fontSize, 25);
      expect(scale.pageTitle.lineHeight, 32);
      expect(scale.body.fontSize, 14);
      expect(scale.body.lineHeight, 22);
      expect(scale.caption.lineHeight, 18);
      expect(scale.bodyBold.weight, FontWeight.w700);
    });

    test('the numeric ladder matches the Charcoal typography widget', () {
      expect(
        <(double, double)>[
          for (final role in [
            CharcoalTextRole.size10,
            CharcoalTextRole.size12,
            CharcoalTextRole.size14,
            CharcoalTextRole.size16,
            CharcoalTextRole.size20,
          ])
            (scale.spec(role).fontSize, scale.spec(role).lineHeight),
        ],
        <(double, double)>[(10, 18), (12, 20), (14, 22), (16, 24), (20, 28)],
      );
    });

    test('every enum value has a spec', () {
      for (final role in CharcoalTextRole.values) {
        expect(scale.spec(role).fontSize, greaterThan(0));
        expect(scale.spec(role).lineHeight, greaterThanOrEqualTo(scale.spec(role).fontSize));
      }
    });

    test('Apple platforms switch to the display family from appleDisplayFrom', () {
      expect(scale.sansFamilyFor(14, TargetPlatform.iOS), 'CupertinoSystemText');
      expect(scale.sansFamilyFor(20, TargetPlatform.macOS), 'CupertinoSystemDisplay');
      expect(scale.sansFamilyFor(14, TargetPlatform.android), isNull);
      expect(scale.copyWith(sansFamily: 'Custom').sansFamilyFor(14, TargetPlatform.iOS), 'Custom');
    });
  });

  group('tones', () {
    test('resolve from roles only', () {
      final colors = charcoalLightPack.colors;
      final negative = resolveCharcoalTone(colors, CharcoalTone.negative);
      expect(negative.surface, colors.negativeSurface);
      expect(negative.foreground, colors.textNegative);
      expect(negative.dot, colors.negative);
      expect(negative.icon, colors.iconNegative);
      final info = resolveCharcoalTone(colors, CharcoalTone.info);
      expect(info.dot, colors.primary);
      expect(info.foreground, colors.textInfo);
      for (final tone in CharcoalTone.values) {
        expect(resolveCharcoalTone(colors, tone), isNotNull);
      }
    });
  });

  group('extremePack', () {
    for (final brightness in Brightness.values) {
      test('${brightness.name}: colours are distinct, opaque and foreign', () {
        final pack = extremePack(brightness);
        final base = brightness == Brightness.dark ? charcoalDarkPack : charcoalLightPack;
        final colors = pack.colors.toMap().values.cast<Color>().toList();
        expect(colors.toSet(), hasLength(colors.length));
        expect(colors.every((c) => c.a == 1), isTrue);
        final baseColors = base.colors.toMap().values.toSet();
        expect(colors.where(baseColors.contains), isEmpty);
        expect(pack.brightness, brightness);
      });

      test('${brightness.name}: every number moved', () {
        final pack = extremePack(brightness).toFlatMap();
        final base = (brightness == Brightness.dark ? charcoalDarkPack : charcoalLightPack)
            .toFlatMap();
        final unchanged = <String>[
          for (final entry in base.entries)
            if (!entry.key.startsWith('colors.') &&
                (entry.value is num || entry.value is Duration || entry.value is FontWeight) &&
                pack[entry.key] == entry.value)
              entry.key,
        ];
        expect(unchanged, isEmpty);
      });
    }
  });

  group('CharcoalTheme', () {
    Widget host(Widget child, {TargetPlatform platform = TargetPlatform.android}) => MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          CharcoalTheme(charcoalLightPack, platform: platform),
        ],
      ),
      home: child,
    );

    testWidgets('of() finds the extension', (tester) async {
      late CharcoalTheme found;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              found = CharcoalTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found.pack, charcoalLightPack);
      expect(found.colors.primary, charcoalLightPack.colors.primary);
      expect(found.brightness, Brightness.light);
    });

    testWidgets('maybeOf() is null without the extension', (tester) async {
      CharcoalTheme? found;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              found = CharcoalTheme.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found, isNull);
    });

    testWidgets('style() sets size and a height multiplier but never a text scaler', (
      tester,
    ) async {
      late CharcoalTheme theme;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              theme = CharcoalTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      final body = theme.style(CharcoalTextRole.body);
      expect(body.fontSize, 14);
      expect(body.height, closeTo(22 / 14, 1e-9));
      expect(body.color, charcoalLightPack.colors.text);
      expect(body.fontWeight, FontWeight.w400);
      expect(theme.style(CharcoalTextRole.body, bold: true).fontWeight, FontWeight.w700);
      final caption = theme.style(CharcoalTextRole.caption);
      expect(caption.color, charcoalLightPack.colors.textTertiary);
      final mono = theme.style(CharcoalTextRole.captionMono);
      expect(mono.fontFamily, 'monospace');
      expect(mono.height, isNull);
      expect(
        theme.style(CharcoalTextRole.body, color: const Color(0xFF010203)).color,
        const Color(0xFF010203),
      );
    });

    testWidgets('style() resolves the Apple system family on iOS', (tester) async {
      late CharcoalTheme theme;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              theme = CharcoalTheme.of(context);
              return const SizedBox();
            },
          ),
          platform: TargetPlatform.iOS,
        ),
      );
      expect(theme.style(CharcoalTextRole.body).fontFamily, 'CupertinoSystemText');
      expect(theme.style(CharcoalTextRole.modalTitle).fontFamily, 'CupertinoSystemDisplay');
    });

    testWidgets('duration() honours reduce motion', (tester) async {
      late CharcoalTheme theme;
      late BuildContext inner;
      await tester.pumpWidget(
        host(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
              builder: (context) {
                theme = CharcoalTheme.of(context);
                inner = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(theme.duration(inner, theme.motion.standard), Duration.zero);
    });

    test('lerp switches at the midpoint; copyWith replaces fields', () {
      final a = CharcoalTheme(charcoalLightPack);
      final b = CharcoalTheme(charcoalDarkPack);
      expect(a.lerp(b, 0.49), a);
      expect(a.lerp(b, 0.5), b);
      expect(a.lerp(null, 1), a);
      expect(a.copyWith(platform: TargetPlatform.iOS).platform, TargetPlatform.iOS);
      expect(b.tone(CharcoalTone.positive).dot, charcoalDarkPack.colors.positive);
    });
  });

  group('source hygiene', () {
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    test('no dart:io or dart:html in lib (Wasm-safe)', () {
      final bad = files.where((f) => RegExp(r'dart:(io|html)').hasMatch(f.readAsStringSync()));
      expect(bad.map((f) => f.path), isEmpty);
    });

    test('literal colours live only in the contract and packs directories', () {
      final bad = files
          .where((f) => !f.path.contains('/src/contract/') && !f.path.contains('/src/packs/'))
          .where((f) => RegExp(r'\bColor\(|0x[0-9A-Fa-f]{6,8}').hasMatch(f.readAsStringSync()));
      expect(bad.map((f) => f.path), isEmpty);
    });
  });
}
