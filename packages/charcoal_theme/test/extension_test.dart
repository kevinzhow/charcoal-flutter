import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final light = buildCharcoalThemeData(charcoalLightPack);
  final dark = buildCharcoalThemeData(charcoalDarkPack);

  testWidgets('CharcoalTheme.of reads the extension from the nearest Theme', (tester) async {
    late CharcoalTheme found;
    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        darkTheme: dark,
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            found = CharcoalTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(found.pack, charcoalDarkPack);
    expect(found.colors.background, charcoalDarkPack.colors.background);
    expect(found.brightness, Brightness.dark);
  });

  testWidgets('maybeOf is null without the extension', (tester) async {
    CharcoalTheme? found = CharcoalTheme(charcoalLightPack);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(),
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

  testWidgets('switching theme mode swaps the pack (discrete) and cross-fades Material colours', (
    tester,
  ) async {
    final mode = ValueNotifier(ThemeMode.light);
    late CharcoalTheme seen;
    await tester.pumpWidget(
      ValueListenableBuilder<ThemeMode>(
        valueListenable: mode,
        builder: (_, value, _) => MaterialApp(
          theme: light,
          darkTheme: dark,
          themeMode: value,
          home: Builder(
            builder: (context) {
              seen = CharcoalTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(seen.pack, charcoalLightPack);
    mode.value = ThemeMode.dark;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();
    expect(seen.pack, charcoalDarkPack);
  });

  test('lerp is discrete at the midpoint', () {
    final a = CharcoalTheme(charcoalLightPack);
    final b = CharcoalTheme(charcoalDarkPack);
    expect(a.lerp(b, 0.49).pack, charcoalLightPack);
    expect(a.lerp(b, 0.5).pack, charcoalDarkPack);
    expect(a.lerp(null, 0.9).pack, charcoalLightPack);
  });

  test('ThemeData.lerp keeps working with the extension', () {
    final mid = ThemeData.lerp(light, dark, 0.5);
    expect(mid.extension<CharcoalTheme>(), isNotNull);
    expect(ThemeData.lerp(light, dark, 0).extension<CharcoalTheme>()!.pack, charcoalLightPack);
    expect(ThemeData.lerp(light, dark, 1).extension<CharcoalTheme>()!.pack, charcoalDarkPack);
  });

  test('copyWith swaps the pack or the platform', () {
    final base = CharcoalTheme(charcoalLightPack);
    expect(base.copyWith(pack: charcoalDarkPack).pack, charcoalDarkPack);
    expect(base.copyWith(platform: TargetPlatform.iOS).platform, TargetPlatform.iOS);
    expect(base.copyWith().pack, charcoalLightPack);
  });

  test('copying ThemeData keeps the extension', () {
    final copy = light.copyWith(scaffoldBackgroundColor: const Color(0xFF123456));
    expect(copy.extension<CharcoalTheme>()!.pack, charcoalLightPack);
  });

  test('tones resolve from the pack', () {
    final theme = CharcoalTheme(charcoalLightPack);
    expect(theme.tone(CharcoalTone.positive).surface, charcoalLightPack.colors.positiveSurface);
    expect(theme.tone(CharcoalTone.negative).dot, charcoalLightPack.colors.negative);
  });
}
