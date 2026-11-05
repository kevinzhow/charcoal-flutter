import 'package:charcoal_ui/charcoal_ui.dart' as legacy show CharcoalTheme;
import 'package:charcoal_ui/next.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show DefaultMaterialLocalizations, Material, MaterialType, Theme;
import 'package:flutter/widgets.dart';

const _showcaseWebFontFamily = 'Noto Sans';

/// The pack the island installs for [brightness], with the self-hosted Web font on Web.
CharcoalThemePack showcaseNextPack(Brightness brightness, {bool isWeb = kIsWeb}) {
  final base = brightness == Brightness.dark ? charcoalDarkPack : charcoalLightPack;
  if (!isWeb) return base;
  return base.copyWith(typography: base.typography.copyWith(sansFamily: _showcaseWebFontFamily));
}

// TODO(P2 end): the showcase shell still runs on the legacy CharcoalApp, so pages that show
// next.dart components mount them in this island: a Material theme built from the pack that
// matches the shell's brightness, a transparent Material, and the pack's text defaults. Delete it
// when the shell switches to next.dart's CharcoalApp.

/// Mounts [child] with the Material-based Charcoal theme inside the legacy showcase shell.
class NextThemeIsland extends StatelessWidget {
  /// Wraps [child] in the island.
  const NextThemeIsland({required this.child, super.key});

  /// The content built from `package:charcoal_ui/next.dart`.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = legacy.CharcoalTheme.of(context).brightness;
    final data = buildCharcoalThemeData(showcaseNextPack(brightness));
    return Localizations.override(
      context: context,
      delegates: const <LocalizationsDelegate<dynamic>>[DefaultMaterialLocalizations.delegate],
      child: Theme(
        data: data,
        child: Material(
          type: MaterialType.transparency,
          child: CharcoalTextDefaults(child: child),
        ),
      ),
    );
  }
}
