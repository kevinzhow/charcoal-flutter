import 'package:flutter/widgets.dart';

import 'charcoal_theme_data.dart';

/// Injects one coherent [CharcoalThemeData] without depending on Material or
/// Cupertino.
///
/// Use [CharcoalThemeData.light] or [CharcoalThemeData.dark] for complete
/// generated token sets. Scoped overrides should preserve semantic token roles
/// and replace [data] atomically so every dependent rebuilds together.
final class CharcoalTheme extends InheritedTheme {
  const CharcoalTheme({required this.data, required super.child, super.key});

  final CharcoalThemeData data;

  static CharcoalThemeData of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No CharcoalTheme found in context. Wrap the tree in CharcoalTheme.');
    return result!;
  }

  static CharcoalThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CharcoalTheme>()?.data;

  @override
  bool updateShouldNotify(CharcoalTheme oldWidget) => !identical(data, oldWidget.data);

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestor = context.findAncestorWidgetOfExactType<CharcoalTheme>();
    return identical(this, ancestor) ? child : CharcoalTheme(data: data, child: child);
  }
}
