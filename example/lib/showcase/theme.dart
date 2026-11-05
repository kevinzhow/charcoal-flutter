import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';

const _showcaseWebFontFamily = 'Noto Sans';

/// Builds the Showcase theme pack for [brightness]: the Charcoal pack, with the self-hosted Web
/// font on the Web.
CharcoalThemePack buildShowcasePack(
  Brightness brightness, {
  bool isWeb = kIsWeb,
}) {
  final base = switch (brightness) {
    Brightness.light => charcoalLightPack,
    Brightness.dark => charcoalDarkPack,
  };
  if (!isWeb) {
    return base;
  }
  return base.copyWith(
    typography: base.typography.copyWith(sansFamily: _showcaseWebFontFamily),
  );
}
