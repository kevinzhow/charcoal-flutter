import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

Widget charcoalTestApp(Widget child, {CharcoalThemeData? theme}) {
  final data = theme ?? CharcoalThemeData.light();
  return WidgetsApp(
    color: data.colors.containerPrimaryDefault,
    home: CharcoalTheme(
      data: data,
      child: Center(child: child),
    ),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
  );
}
