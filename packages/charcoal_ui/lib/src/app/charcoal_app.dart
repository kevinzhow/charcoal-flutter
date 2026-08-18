import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import '../theme/charcoal_theme_data.dart';
import 'charcoal_page_route.dart';

/// Selects which brightness variant [CharcoalApp] installs.
enum CharcoalThemeMode { system, light, dark }

/// A Widgets-layer application shell with Charcoal theming and no Material/Cupertino dependency.
///
/// Use the default constructor for an imperative [Navigator] and [CharcoalApp.router] for a
/// declarative [Router]. Both constructors install the same theme, localization, restoration,
/// shortcut, scrolling, and Hero infrastructure.
final class CharcoalApp extends StatefulWidget {
  /// Creates a Charcoal application backed by a [Navigator].
  const CharcoalApp({
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.theme,
    this.darkTheme,
    this.themeMode = CharcoalThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.pageRouteBuilder,
    super.key,
  }) : routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       routerConfig = null,
       backButtonDispatcher = null;

  /// Creates a Charcoal application backed by a declarative [Router].
  const CharcoalApp.router({
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.theme,
    this.darkTheme,
    this.themeMode = CharcoalThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    super.key,
  }) : assert(
         routerDelegate != null || routerConfig != null,
         'Either routerDelegate or routerConfig must be provided.',
       ),
       assert(
         routerConfig == null ||
             (routeInformationProvider == null &&
                 routeInformationParser == null &&
                 routerDelegate == null &&
                 backButtonDispatcher == null),
         'When routerConfig is provided, the individual router delegates must be null.',
       ),
       assert(
         routeInformationProvider == null || routeInformationParser != null,
         'A routeInformationProvider requires a routeInformationParser.',
       ),
       navigatorKey = null,
       home = null,
       routes = const <String, WidgetBuilder>{},
       initialRoute = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = const <NavigatorObserver>[],
       pageRouteBuilder = null;

  /// The key for the root [Navigator] created by the default constructor.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The widget for the default `/` route.
  final Widget? home;

  /// The named routes available to the root [Navigator].
  final Map<String, WidgetBuilder> routes;

  /// The first named route loaded by the root [Navigator].
  final String? initialRoute;

  /// Generates a route that is not present in [routes].
  final RouteFactory? onGenerateRoute;

  /// Generates the initial route stack for [initialRoute].
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// Generates a route when every other route lookup fails.
  final RouteFactory? onUnknownRoute;

  /// Observers installed on the root [Navigator].
  final List<NavigatorObserver> navigatorObservers;

  /// Provides route information to [CharcoalApp.router].
  final RouteInformationProvider? routeInformationProvider;

  /// Parses platform route information for [CharcoalApp.router].
  final RouteInformationParser<Object>? routeInformationParser;

  /// Builds the route hierarchy for [CharcoalApp.router].
  final RouterDelegate<Object>? routerDelegate;

  /// Bundles the declarative routing configuration for [CharcoalApp.router].
  final RouterConfig<Object>? routerConfig;

  /// Dispatches platform back requests to [CharcoalApp.router].
  final BackButtonDispatcher? backButtonDispatcher;

  /// Inserts widgets above the root Navigator or Router.
  ///
  /// The supplied context can resolve [CharcoalTheme], [Localizations], and the effective
  /// [ScrollConfiguration].
  final TransitionBuilder? builder;

  /// A one-line application description used by the host platform.
  final String title;

  /// Generates a localized application title.
  final GenerateAppTitle? onGenerateTitle;

  /// The light Charcoal theme.
  final CharcoalThemeData? theme;

  /// The dark Charcoal theme.
  final CharcoalThemeData? darkTheme;

  /// Selects the effective light or dark theme.
  final CharcoalThemeMode themeMode;

  /// Overrides the platform locale.
  final Locale? locale;

  /// Adds application localization delegates.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Resolves a locale from the platform's ordered locale preferences.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Resolves a locale when [localeListResolutionCallback] does not.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The locales supported by this application.
  final Iterable<Locale> supportedLocales;

  /// Shows the checked-mode banner in debug builds.
  final bool debugShowCheckedModeBanner;

  /// Overrides the root keyboard shortcut map.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Overrides the root intent action map.
  final Map<Type, Action<Intent>>? actions;

  /// Enables state restoration for the application and its root navigation hierarchy.
  final String? restorationScopeId;

  /// Overrides the platform-adaptive scrolling policy.
  final ScrollBehavior? scrollBehavior;

  /// Creates pages for named routes in the default constructor.
  ///
  /// Defaults to [CharcoalPageRoute].
  final PageRouteFactory? pageRouteBuilder;

  /// Creates the Hero controller shared by the root navigation hierarchy.
  static HeroController createCharcoalHeroController() => HeroController();

  @override
  State<CharcoalApp> createState() => _CharcoalAppState();
}

final class _CharcoalAppState extends State<CharcoalApp> {
  late final HeroController _heroController;

  bool get _usesRouter => widget.routerDelegate != null || widget.routerConfig != null;

  @override
  void initState() {
    super.initState();
    _heroController = CharcoalApp.createCharcoalHeroController();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  CharcoalThemeData _resolveTheme(
    BuildContext context, {
    required CharcoalThemeData light,
    required CharcoalThemeData dark,
  }) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final useDark = switch (widget.themeMode) {
      CharcoalThemeMode.light => false,
      CharcoalThemeMode.dark => true,
      CharcoalThemeMode.system => platformBrightness == Brightness.dark,
    };
    return useDark ? dark : light;
  }

  WidgetsApp _buildWidgetsApp({
    required CharcoalThemeData theme,
    required Color applicationColor,
  }) {
    final textStyle = theme.textStyles.body.copyWith(color: theme.colors.textDefault);
    if (_usesRouter) {
      return WidgetsApp.router(
        key: GlobalObjectKey(this),
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser,
        routerDelegate: widget.routerDelegate,
        routerConfig: widget.routerConfig,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: widget.builder,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        textStyle: textStyle,
        color: applicationColor,
        locale: widget.locale,
        localizationsDelegates: widget.localizationsDelegates,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        localeResolutionCallback: widget.localeResolutionCallback,
        supportedLocales: widget.supportedLocales,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
      );
    }

    return WidgetsApp(
      key: GlobalObjectKey(this),
      navigatorKey: widget.navigatorKey,
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      navigatorObservers: widget.navigatorObservers,
      pageRouteBuilder:
          widget.pageRouteBuilder ??
          <T>(RouteSettings settings, WidgetBuilder builder) =>
              CharcoalPageRoute<T>(builder: builder, settings: settings),
      builder: widget.builder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      textStyle: textStyle,
      color: applicationColor,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales: widget.supportedLocales,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = widget.theme ?? CharcoalThemeData.light();
    final dark = widget.darkTheme ?? CharcoalThemeData.dark();
    final effectiveTheme = _resolveTheme(context, light: light, dark: dark);
    final applicationColor = light.colors.containerPrimaryDefault;

    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? const ScrollBehavior(),
      child: CharcoalTheme(
        data: effectiveTheme,
        child: HeroControllerScope(
          controller: _heroController,
          child: _buildWidgetsApp(theme: effectiveTheme, applicationColor: applicationColor),
        ),
      ),
    );
  }
}
