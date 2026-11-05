import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('numeric roles preserve the audited size and line scale', (tester) async {
    const expected = <CharcoalTextRole, (double, double)>{
      CharcoalTextRole.size10: (10, 18),
      CharcoalTextRole.size12: (12, 20),
      CharcoalTextRole.size14: (14, 22),
      CharcoalTextRole.size16: (16, 24),
      CharcoalTextRole.size20: (20, 28),
    };
    late Map<CharcoalTextRole, TextStyle> styles;
    await pumpCharcoal(
      tester,
      Builder(
        builder: (context) {
          final theme = CharcoalTheme.of(context);
          styles = {for (final role in expected.keys) role: theme.style(role)};
          return const SizedBox.shrink();
        },
      ),
    );
    for (final entry in expected.entries) {
      final style = styles[entry.key]!;
      final (fontSize, lineHeight) = entry.value;
      expect(style.fontSize, fontSize);
      expect(style.height, lineHeight / fontSize);
      expect(style.leadingDistribution, TextLeadingDistribution.even);
    }
  });

  testWidgets('typography scales and wraps without replacing its source size', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 180,
          child: CharcoalTypography(
            role: CharcoalTextRole.size20,
            child: Text('Scaled typography wraps onto another line'),
          ),
        ),
      ),
      textScale: 2,
    );
    final defaultStyle = tester.widget<DefaultTextStyle>(
      find
          .descendant(of: find.byType(CharcoalTypography), matching: find.byType(DefaultTextStyle))
          .first,
    );
    expect(defaultStyle.style.fontSize, 20);
    expect(
      tester.getSize(find.text('Scaled typography wraps onto another line')).height,
      greaterThan(28),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('single-line typography inherits directional end alignment', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 160,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: CharcoalTypography(
              singleLine: true,
              textAlign: TextAlign.end,
              child: Text('A deliberately long directional label'),
            ),
          ),
        ),
      ),
    );
    final defaultStyle = tester.widget<DefaultTextStyle>(
      find
          .descendant(of: find.byType(CharcoalTypography), matching: find.byType(DefaultTextStyle))
          .first,
    );
    expect(defaultStyle.maxLines, 1);
    expect(defaultStyle.overflow, TextOverflow.ellipsis);
    expect(defaultStyle.textAlign, TextAlign.end);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CharcoalText resolves role, bold and colour from the pack', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: CharcoalText('Hello', role: CharcoalTextRole.size16, bold: true, maxLines: 1),
      ),
    );
    final style = tester.widget<Text>(find.text('Hello')).style!;
    expect(style.fontSize, 16);
    expect(style.fontWeight, charcoalLightPack.typography.weightBold);
    expect(style.color, charcoalLightPack.colors.text);
  });

  testWidgets('monospace typography uses the pack monospace family and one line', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: CharcoalTypography(monospace: true, child: Text('id_0123')),
      ),
    );
    final defaultStyle = tester.widget<DefaultTextStyle>(
      find
          .descendant(of: find.byType(CharcoalTypography), matching: find.byType(DefaultTextStyle))
          .first,
    );
    expect(defaultStyle.style.fontFamily, charcoalLightPack.typography.monoFamily);
    expect(defaultStyle.maxLines, 1);
  });

  group('font resolution', () {
    test('default source font resolves without a bundled asset', () {
      final theme = CharcoalTheme(charcoalLightPack, platform: defaultTargetPlatform);
      final body = theme.style(CharcoalTextRole.bodyLarge);
      final heading = theme.style(CharcoalTextRole.headingXs);
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        expect(body.fontFamily, isNotNull);
        expect(heading.fontFamily, isNotNull);
      } else {
        expect(body.fontFamily, isNull);
        expect(heading.fontFamily, isNull);
      }
    });

    test('an explicit application font bypasses the default mapping', () {
      final pack = charcoalLightPack.copyWith(
        typography: charcoalLightPack.typography.copyWith(sansFamily: 'Product Sans'),
      );
      final theme = CharcoalTheme(pack);
      expect(theme.style(CharcoalTextRole.bodyLarge).fontFamily, 'Product Sans');
      expect(theme.style(CharcoalTextRole.headingXs).fontFamily, 'Product Sans');
    });

    test('numeric roles use the same runtime font as the named roles of that size', () {
      for (final platform in TargetPlatform.values) {
        final theme = CharcoalTheme(charcoalLightPack, platform: platform);
        expect(
          theme.style(CharcoalTextRole.size20).fontFamily,
          theme.style(CharcoalTextRole.headingXs).fontFamily,
          reason: '$platform',
        );
      }
    });
  });
}
