import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/theme/charcoal_font_family.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  test('default source font resolves without a bundled asset', () {
    final styles = CharcoalThemeData.light().textStyles;

    if (kIsWeb) {
      expect(styles.body.fontFamily, isNull);
      expect(styles.headingXs.fontFamily, isNull);
      expect(styles.body.fontFamilyFallback, isNull);
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      expect(styles.body.fontFamily, 'CupertinoSystemText');
      expect(styles.headingXs.fontFamily, 'CupertinoSystemDisplay');
    } else {
      expect(styles.body.fontFamily, isNull);
      expect(styles.headingXs.fontFamily, isNull);
    }
  });

  test('Web defers to the renderer default font', () {
    final font = resolveCharcoalSansFontForTarget(
      CharcoalGeneratedTypographyTokens.light,
      fontSize: 14,
      isWeb: true,
      platform: TargetPlatform.windows,
    );

    expect(font.family, isNull);
    expect(font.familyFallback, isNull);
  });

  test('non-Apple native targets use Flutter platform defaults', () {
    final font = resolveCharcoalSansFontForTarget(
      CharcoalGeneratedTypographyTokens.light,
      fontSize: 14,
      isWeb: false,
      platform: TargetPlatform.linux,
    );

    expect(font.family, isNull);
    expect(font.familyFallback, isNull);
  });

  test('an explicit application font bypasses the default mapping', () {
    final generated = CharcoalGeneratedTypographyTokens.light;
    final custom = generated.copyWith(
      fontFamily: generated.fontFamily.copyWith(sans: 'Product Sans'),
    );
    final styles = CharcoalThemeData.light(typography: custom).textStyles;

    expect(styles.body.fontFamily, 'Product Sans');
    expect(styles.headingXs.fontFamily, 'Product Sans');
    expect(styles.body.fontFamilyFallback, isNull);
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
    expect(
      componentStyle.fontFamilyFallback,
      theme.textStyles.headingXs.fontFamilyFallback,
    );
  });
}
