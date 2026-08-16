import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:flutter/foundation.dart';

const _sourceSansFamily = 'Sarasa UI J';
const _bundledSansFamily = 'CharcoalSans';
const _bundledSansPackage = 'charcoal_ui';
const _appleSystemText = 'CupertinoSystemText';
const _appleSystemDisplay = 'CupertinoSystemDisplay';

/// Maps the generated source family to a font that is available at runtime.
///
/// Charcoal SwiftUI uses the Apple system font. Web renderers cannot use that
/// native font reliably, so the package carries a compact Sarasa UI J subset
/// for deterministic Latin text. Missing scripts continue through Flutter's
/// normal fallback resolver. Explicit theme overrides are left untouched.
({String family, String? fontPackage}) resolveCharcoalSansFont(
  CharcoalTypographyTokens tokens, {
  required double fontSize,
}) {
  final sourceFamily = tokens.fontFamily.sans;
  if (sourceFamily != _sourceSansFamily) {
    return (family: sourceFamily, fontPackage: null);
  }

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    return (
      family: fontSize >= 20 ? _appleSystemDisplay : _appleSystemText,
      fontPackage: null,
    );
  }

  return (
    family: _bundledSansFamily,
    fontPackage: _bundledSansPackage,
  );
}
