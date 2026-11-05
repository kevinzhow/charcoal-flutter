import 'package:charcoal_ui/charcoal_ui.dart' as legacy;
import 'package:charcoal_ui/next.dart'
    show buildCharcoalThemeData, charcoalDarkPack, charcoalLightPack;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme;

const _showcaseFont = 'Noto Sans';

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
    final pack = dark ? charcoalDarkPack : charcoalLightPack;
    return Theme(
      // The showcase bundles Noto Sans; the legacy shell sets it explicitly, so do the same.
      data: buildCharcoalThemeData(
        pack.copyWith(
          typography: pack.typography.copyWith(sansFamily: _showcaseFont),
        ),
      ),
      child: child,
    );
  }
}
