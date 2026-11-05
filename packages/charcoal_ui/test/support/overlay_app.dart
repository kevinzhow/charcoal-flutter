import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';

/// Wraps [child] in a [CharcoalApp] with the light pack (or [pack]) and centres it, in the shape
/// of the old `charcoalTestApp` so overlay tests can keep their `pumpWidget(charcoalTestApp(..))`
/// form. A transparent [Material] gives ink-based widgets the ancestor a page would.
Widget charcoalTestApp(Widget child, {CharcoalThemePack? pack}) {
  final effective = pack ?? charcoalLightPack;
  return CharcoalApp(
    lightPack: effective,
    darkPack: effective,
    themeMode: effective.brightness == Brightness.dark
        ? CharcoalThemeMode.dark
        : CharcoalThemeMode.light,
    home: Material(
      type: MaterialType.transparency,
      child: Center(child: child),
    ),
  );
}
