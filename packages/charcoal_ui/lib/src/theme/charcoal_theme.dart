import 'package:flutter/widgets.dart';

import 'charcoal_theme_data.dart';

/// Injects [CharcoalThemeData] without depending on Material or Cupertino.
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
