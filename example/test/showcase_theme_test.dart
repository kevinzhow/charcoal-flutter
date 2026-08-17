import 'package:charcoal_ui_showcase/showcase_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Web Showcase uses its bundled Noto Sans family', () {
    final theme = buildShowcaseTheme(Brightness.light, isWeb: true);

    expect(theme.typography.fontFamily.sans, 'Noto Sans');
    expect(theme.textStyles.body.fontFamily, 'Noto Sans');
    expect(theme.textStyles.bodyBold.fontFamily, 'Noto Sans');
  });

  test('native Showcase preserves Charcoal platform font resolution', () {
    final theme = buildShowcaseTheme(Brightness.light, isWeb: false);

    expect(theme.typography.fontFamily.sans, 'Sarasa UI J');
  });
}
