import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  test('default source font resolves to an available runtime family', () {
    final styles = CharcoalThemeData.light().textStyles;
    final isAppleNative =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);

    if (isAppleNative) {
      expect(styles.body.fontFamily, 'CupertinoSystemText');
      expect(styles.headingXs.fontFamily, 'CupertinoSystemDisplay');
    } else {
      expect(
        styles.body.fontFamily,
        'packages/charcoal_ui/CharcoalSans',
      );
      expect(
        styles.headingXs.fontFamily,
        'packages/charcoal_ui/CharcoalSans',
      );
    }
  });

  test('an explicit application font bypasses the default mapping', () {
    final generated = CharcoalGeneratedTypographyTokens.light;
    final custom = generated.copyWith(
      fontFamily: generated.fontFamily.copyWith(sans: 'Product Sans'),
    );
    final styles = CharcoalThemeData.light(typography: custom).textStyles;

    expect(styles.body.fontFamily, 'Product Sans');
    expect(styles.headingXs.fontFamily, 'Product Sans');
  });

  testWidgets('numeric component typography uses the same runtime font', (
    tester,
  ) async {
    late TextStyle componentStyle;
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) {
            componentStyle = charcoalTypographyStyle(
              context,
              size: CharcoalTypographySize.size20,
            );
            return const SizedBox.shrink();
          },
        ),
        theme: theme,
      ),
    );

    expect(componentStyle.fontFamily, theme.textStyles.headingXs.fontFamily);
  });
}
