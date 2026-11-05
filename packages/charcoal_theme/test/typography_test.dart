import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final theme = buildCharcoalThemeData(charcoalLightPack, platform: TargetPlatform.android);
  final charcoal = theme.extension<CharcoalTheme>()!;

  TextStyle role(CharcoalTextRole value) => charcoal.style(value);

  // `ThemeData` merges the text theme over Material's defaults (family, decoration), so slots
  // compare by what Charcoal sets: size, line-height multiplier, weight, colour.
  Matcher sameAs(TextStyle expected) => isA<TextStyle>()
      .having((s) => s.fontSize, 'fontSize', expected.fontSize)
      .having((s) => s.height, 'height', expected.height)
      .having((s) => s.fontWeight, 'fontWeight', expected.fontWeight)
      .having((s) => s.color, 'color', expected.color);

  test('all fifteen Material text slots read a Charcoal role', () {
    final t = theme.textTheme;
    expect(t.displayLarge, sameAs(role(CharcoalTextRole.headingXxxl)));
    expect(t.displayMedium, sameAs(role(CharcoalTextRole.headingXxl)));
    expect(t.displaySmall, sameAs(role(CharcoalTextRole.headingXl)));
    expect(t.headlineLarge, sameAs(role(CharcoalTextRole.headingL)));
    expect(t.headlineMedium, sameAs(role(CharcoalTextRole.headingM)));
    expect(t.headlineSmall, sameAs(role(CharcoalTextRole.pageTitle)));
    expect(t.titleLarge, sameAs(role(CharcoalTextRole.modalTitle)));
    expect(t.titleMedium, sameAs(role(CharcoalTextRole.sectionTitle)));
    expect(t.titleSmall, sameAs(role(CharcoalTextRole.bodyBold)));
    expect(t.bodyLarge, sameAs(role(CharcoalTextRole.body)));
    expect(t.bodyMedium, sameAs(role(CharcoalTextRole.body)));
    expect(t.bodySmall, sameAs(role(CharcoalTextRole.caption)));
    expect(t.labelLarge, sameAs(role(CharcoalTextRole.bodyBold)));
    expect(t.labelMedium, sameAs(role(CharcoalTextRole.captionBold)));
    expect(t.labelSmall, sameAs(role(CharcoalTextRole.caption)));
    expect(theme.primaryTextTheme.bodyMedium, sameAs(role(CharcoalTextRole.body)));
  });

  test('every text slot has a size, a height and a colour from the pack', () {
    final pack = charcoalLightPack;
    final slots = <TextStyle?>[
      theme.textTheme.displayLarge,
      theme.textTheme.displayMedium,
      theme.textTheme.displaySmall,
      theme.textTheme.headlineLarge,
      theme.textTheme.headlineMedium,
      theme.textTheme.headlineSmall,
      theme.textTheme.titleLarge,
      theme.textTheme.titleMedium,
      theme.textTheme.titleSmall,
      theme.textTheme.bodyLarge,
      theme.textTheme.bodyMedium,
      theme.textTheme.bodySmall,
      theme.textTheme.labelLarge,
      theme.textTheme.labelMedium,
      theme.textTheme.labelSmall,
    ];
    final colours = {pack.colors.text, pack.colors.textTertiary};
    for (final style in slots) {
      expect(style!.fontSize, isNotNull);
      expect(style.height, isNotNull);
      expect(colours, contains(style.color));
    }
  });

  test('a role style is size / line height / weight of its spec', () {
    for (final value in CharcoalTextRole.values) {
      final spec = charcoal.typography.spec(value);
      final style = role(value);
      expect(style.fontSize, spec.fontSize, reason: value.name);
      if (value != CharcoalTextRole.captionMono) {
        expect(style.height, closeTo(spec.lineHeight / spec.fontSize, 1e-9), reason: value.name);
      }
    }
  });

  test('Apple targets switch between text and display families at the threshold', () {
    final ios = CharcoalTheme(charcoalLightPack, platform: TargetPlatform.iOS);
    final scale = charcoalLightPack.typography;
    expect(ios.style(CharcoalTextRole.body).fontFamily, scale.appleTextFamily);
    expect(ios.style(CharcoalTextRole.size20).fontFamily, scale.appleDisplayFamily);
    final android = CharcoalTheme(charcoalLightPack, platform: TargetPlatform.android);
    expect(android.style(CharcoalTextRole.body).fontFamily, isNull);
  });

  test('a pack font override reaches every Material slot', () {
    final themed = charcoalLightPack.copyWith(
      typography: CharcoalTypeScale(
        pageTitle: charcoalLightPack.typography.pageTitle,
        modalTitle: charcoalLightPack.typography.modalTitle,
        sectionTitle: charcoalLightPack.typography.sectionTitle,
        body: charcoalLightPack.typography.body,
        bodyBold: charcoalLightPack.typography.bodyBold,
        caption: charcoalLightPack.typography.caption,
        captionBold: charcoalLightPack.typography.captionBold,
        captionMono: charcoalLightPack.typography.captionMono,
        size10: charcoalLightPack.typography.size10,
        size12: charcoalLightPack.typography.size12,
        size14: charcoalLightPack.typography.size14,
        size16: charcoalLightPack.typography.size16,
        size20: charcoalLightPack.typography.size20,
        bodyLarge: charcoalLightPack.typography.bodyLarge,
        bodyLargeBold: charcoalLightPack.typography.bodyLargeBold,
        paragraph: charcoalLightPack.typography.paragraph,
        captionMedium: charcoalLightPack.typography.captionMedium,
        captionMediumBold: charcoalLightPack.typography.captionMediumBold,
        headingXxxs: charcoalLightPack.typography.headingXxxs,
        headingXxs: charcoalLightPack.typography.headingXxs,
        headingXs: charcoalLightPack.typography.headingXs,
        headingS: charcoalLightPack.typography.headingS,
        headingM: charcoalLightPack.typography.headingM,
        headingL: charcoalLightPack.typography.headingL,
        headingXl: charcoalLightPack.typography.headingXl,
        headingXxl: charcoalLightPack.typography.headingXxl,
        headingXxxl: charcoalLightPack.typography.headingXxxl,
        weightRegular: charcoalLightPack.typography.weightRegular,
        weightBold: charcoalLightPack.typography.weightBold,
        monoFamily: charcoalLightPack.typography.monoFamily,
        appleTextFamily: charcoalLightPack.typography.appleTextFamily,
        appleDisplayFamily: charcoalLightPack.typography.appleDisplayFamily,
        appleDisplayFrom: charcoalLightPack.typography.appleDisplayFrom,
        sansFamily: 'Noto Sans',
      ),
    );
    final text = buildCharcoalThemeData(themed).textTheme;
    expect(text.bodyMedium!.fontFamily, 'Noto Sans');
    expect(text.displayLarge!.fontFamily, 'Noto Sans');
    expect(text.labelSmall!.fontFamily, 'Noto Sans');
  });

  test('bold forces the pack weight and mono switches family', () {
    expect(
      charcoal.style(CharcoalTextRole.body, bold: true).fontWeight,
      charcoalLightPack.typography.weightBold,
    );
    expect(
      charcoal.style(CharcoalTextRole.body, mono: true).fontFamily,
      charcoalLightPack.typography.monoFamily,
    );
  });

  test('type roles keep the pack weights of the upstream tokens', () {
    final scale = charcoalLightPack.typography;
    expect(scale.weightBold, FontWeight.w700);
    expect(scale.weightRegular, FontWeight.w400);
    expect(scale.pageTitle.weight, scale.weightBold);
    expect(scale.body.weight, scale.weightRegular);
  });
}
