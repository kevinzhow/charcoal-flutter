import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('numeric typography preserves the audited size and line scale', (
    tester,
  ) async {
    final expected = <CharcoalTypographySize, (double, double)>{
      CharcoalTypographySize.size10: (10, 18),
      CharcoalTypographySize.size12: (12, 20),
      CharcoalTypographySize.size14: (14, 22),
      CharcoalTypographySize.size16: (16, 24),
      CharcoalTypographySize.size20: (20, 28),
    };
    late Map<CharcoalTypographySize, TextStyle> styles;

    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) {
            styles = <CharcoalTypographySize, TextStyle>{
              for (final size in CharcoalTypographySize.values)
                size: charcoalTypographyStyle(context, size: size),
            };
            return const SizedBox.shrink();
          },
        ),
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

  testWidgets('typography scales and wraps without replacing its source size', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 180,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: CharcoalTypography(
              size: CharcoalTypographySize.size20,
              child: Text('Scaled typography wraps onto another line'),
            ),
          ),
        ),
      ),
    );

    final defaultStyle = tester.widget<DefaultTextStyle>(
      find.descendant(
        of: find.byType(CharcoalTypography),
        matching: find.byType(DefaultTextStyle),
      ),
    );
    expect(defaultStyle.style.fontSize, 20);
    expect(
      tester.getSize(find.text('Scaled typography wraps onto another line')).height,
      greaterThan(28),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('single-line typography inherits directional end alignment', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
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
      find.descendant(
        of: find.byType(CharcoalTypography),
        matching: find.byType(DefaultTextStyle),
      ),
    );
    expect(defaultStyle.maxLines, 1);
    expect(defaultStyle.overflow, TextOverflow.ellipsis);
    expect(defaultStyle.textAlign, TextAlign.end);
    expect(tester.takeException(), isNull);
  });
}
