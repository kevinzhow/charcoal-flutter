import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import '../theme/charcoal_theme_data.dart';
import 'charcoal_page_route.dart';

enum CharcoalThemeMode { system, light, dark }

/// A Widgets-layer application shell with Charcoal theming and no Material/Cupertino dependency.
final class CharcoalApp extends StatelessWidget {
  const CharcoalApp({
    required this.home,
    this.theme,
    this.darkTheme,
    this.themeMode = CharcoalThemeMode.system,
    this.title = '',
    this.debugShowCheckedModeBanner = false,
    this.pageRouteBuilder,
    super.key,
  });

  final Widget home;
  final CharcoalThemeData? theme;
  final CharcoalThemeData? darkTheme;
  final CharcoalThemeMode themeMode;
  final String title;
  final bool debugShowCheckedModeBanner;
  final PageRouteFactory? pageRouteBuilder;

  @override
  Widget build(BuildContext context) {
    final light = theme ?? CharcoalThemeData.light();
    final dark = darkTheme ?? CharcoalThemeData.dark();
    return WidgetsApp(
      color: light.colors.containerPrimaryDefault,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      home: home,
      pageRouteBuilder:
          pageRouteBuilder ??
          <T>(RouteSettings settings, WidgetBuilder builder) =>
              CharcoalPageRoute<T>(builder: builder, settings: settings),
      textStyle: light.textStyles.body.copyWith(color: light.colors.textDefault),
      title: title,
      builder: (context, child) {
        final platformBrightness = MediaQuery.platformBrightnessOf(context);
        final data = switch (themeMode) {
          CharcoalThemeMode.light => light,
          CharcoalThemeMode.dark => dark,
          CharcoalThemeMode.system => platformBrightness == Brightness.dark ? dark : light,
        };
        return CharcoalTheme(
          data: data,
          child: DefaultTextStyle(
            style: data.textStyles.body.copyWith(color: data.colors.textDefault),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
