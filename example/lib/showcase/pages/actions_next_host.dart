import 'package:charcoal_ui/charcoal_ui.dart' as legacy;
import 'package:charcoal_ui/next.dart'
    show buildCharcoalThemeData, charcoalDarkPack, charcoalLightPack;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme;

/// Gives the Material-based Charcoal components a `ThemeData` below the legacy showcase shell.
///
/// The shell still runs on the pre-Material `CharcoalApp`; until it switches (end of phase 2) the
/// pages of migrated families mount this host so `CharcoalTheme.of` finds the pack that matches
/// the shell's brightness. It adds no `Material`, so the page chrome's text styles are untouched.
final class ActionsNextHost extends StatelessWidget {
  /// Creates a host around [child].
  const ActionsNextHost({required this.child, super.key});

  /// The page.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = legacy.CharcoalTheme.of(context).brightness == Brightness.dark;
    return Theme(
      data: buildCharcoalThemeData(dark ? charcoalDarkPack : charcoalLightPack),
      child: child,
    );
  }
}
