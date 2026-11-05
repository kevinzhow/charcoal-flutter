import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/showcase/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Web Showcase uses its bundled Noto Sans family', () {
    final theme = CharcoalTheme(
      buildShowcasePack(Brightness.light, isWeb: true),
    );

    expect(theme.style(CharcoalTextRole.bodyLarge).fontFamily, 'Noto Sans');
    expect(theme.style(CharcoalTextRole.bodyLargeBold).fontFamily, 'Noto Sans');
  });

  test('native Showcase preserves Charcoal platform font resolution', () {
    expect(
      buildShowcasePack(Brightness.light, isWeb: false),
      charcoalLightPack,
    );
  });
}
