import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';

const _showcaseWebFontFamily = 'Noto Sans';

/// Builds a Showcase theme with its self-hosted Web font when appropriate.
CharcoalThemeData buildShowcaseTheme(
  Brightness brightness, {
  bool isWeb = kIsWeb,
}) {
  final base = switch (brightness) {
    Brightness.light => CharcoalThemeData.light(),
    Brightness.dark => CharcoalThemeData.dark(),
  };
  if (!isWeb) {
    return base;
  }

  final typography = base.typography;
  return base.copyWith(
    typography: typography.copyWith(
      fontFamily: typography.fontFamily.copyWith(sans: _showcaseWebFontFamily),
    ),
  );
}
