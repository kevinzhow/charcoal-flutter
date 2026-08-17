import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:flutter/foundation.dart';

const _sourceSansFamily = 'Sarasa UI J';
const _appleSystemText = 'CupertinoSystemText';
const _appleSystemDisplay = 'CupertinoSystemDisplay';

/// Maps the generated source family to a font that is available at runtime.
///
/// Charcoal SwiftUI uses the Apple system font. Web and other native targets
/// defer to Flutter's renderer default because Skwasm cannot resolve browser
/// system fonts from CSS family names. Explicit application overrides are left
/// untouched, allowing an app to provide a renderer-supported Web font asset.
({String? family, List<String>? familyFallback}) resolveCharcoalSansFont(
  CharcoalTypographyTokens tokens, {
  required double fontSize,
}) => resolveCharcoalSansFontForTarget(
  tokens,
  fontSize: fontSize,
  isWeb: kIsWeb,
  platform: defaultTargetPlatform,
);

/// Resolves the runtime font for explicit platform properties.
///
/// This pure variant keeps the Web and native mappings independently testable.
({String? family, List<String>? familyFallback}) resolveCharcoalSansFontForTarget(
  CharcoalTypographyTokens tokens, {
  required double fontSize,
  required bool isWeb,
  required TargetPlatform platform,
}) {
  final sourceFamily = tokens.fontFamily.sans;
  if (sourceFamily != _sourceSansFamily) {
    return (family: sourceFamily, familyFallback: null);
  }

  if (isWeb) {
    return (family: null, familyFallback: null);
  }

  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return (
      family: fontSize >= 20 ? _appleSystemDisplay : _appleSystemText,
      familyFallback: null,
    );
  }

  return (family: null, familyFallback: null);
}
