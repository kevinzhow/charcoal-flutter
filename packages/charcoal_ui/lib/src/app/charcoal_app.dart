import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'charcoal_page_route.dart';
import 'charcoal_text_defaults.dart';

/// Selects which brightness variant [CharcoalApp] installs.
enum CharcoalThemeMode {
  /// Follow the platform brightness.
  system,

  /// Always the light pack.
  light,

  /// Always the dark pack.
  dark,
}

/// The application shell: a thin wrapper over [MaterialApp].
///
/// It installs the light and dark `ThemeData` built from [lightPack] and [darkPack], the ambient
/// text and icon defaults ([CharcoalTextDefaults]), and [CharcoalPageTransitionsBuilder] as the
/// page transition on every platform (so `home`, named routes and declarative routers all get
/// Charcoal motion, iOS edge-back and Android predictive back). Application code never touches
/// `ThemeData`.
///
/// Use the default constructor for an imperative [Navigator] and [CharcoalApp.router] for a
/// declarative [Router] such as `go_router`.
class CharcoalApp extends StatefulWidget {
  /// Creates an application backed by a [Navigator].
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
    this.lightPack,
    this.darkPack,
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
  }) : routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       routerConfig = null,
       backButtonDispatcher = null;

  /// Creates an application backed by a declarative [Router].
  const CharcoalApp.router({
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.lightPack,
    this.darkPack,
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
       navigatorObservers = const <NavigatorObserver>[];

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

  /// Inserts widgets above the root Navigator or Router, below the text defaults.
  ///
  /// The supplied context resolves `CharcoalTheme`, `Localizations` and the scroll configuration.
  final TransitionBuilder? builder;

  /// A one-line application description used by the host platform.
  final String title;

  /// Generates a localized application title.
  final GenerateAppTitle? onGenerateTitle;

  /// The light look. Defaults to the library's light pack; pass one only to change the look.
  final CharcoalThemePack? lightPack;

  /// The dark look. Defaults to the library's dark pack; pass one only to change the look.
  final CharcoalThemePack? darkPack;

  /// Selects the effective light or dark pack.
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

  @override
  State<CharcoalApp> createState() => _CharcoalAppState();
}

class _CharcoalAppState extends State<CharcoalApp> {
  late ThemeData _light;
  late ThemeData _dark;

  bool get _usesRouter => widget.routerDelegate != null || widget.routerConfig != null;

  @override
  void initState() {
    super.initState();
    _buildThemes();
  }

  @override
  void didUpdateWidget(CharcoalApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lightPack != widget.lightPack || oldWidget.darkPack != widget.darkPack) {
      _buildThemes();
    }
  }

  void _buildThemes() {
    _light = _withTransitions(
      buildCharcoalThemeData(widget.lightPack ?? charcoalLightPack),
    );
    _dark = _withTransitions(buildCharcoalThemeData(widget.darkPack ?? charcoalDarkPack));
  }

  ThemeData _withTransitions(ThemeData base) => base.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CharcoalPageTransitionsBuilder(),
        TargetPlatform.iOS: CharcoalPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CharcoalPageTransitionsBuilder(),
        TargetPlatform.linux: CharcoalPageTransitionsBuilder(),
        TargetPlatform.macOS: CharcoalPageTransitionsBuilder(),
        TargetPlatform.windows: CharcoalPageTransitionsBuilder(),
      },
    ),
  );

  ThemeMode get _themeMode => switch (widget.themeMode) {
    CharcoalThemeMode.system => ThemeMode.system,
    CharcoalThemeMode.light => ThemeMode.light,
    CharcoalThemeMode.dark => ThemeMode.dark,
  };

  /// The application's delegates followed by the framework's global ones, so any locale the
  /// application supports also has Material, Widgets and Cupertino strings.
  Iterable<LocalizationsDelegate<dynamic>> get _delegates => <LocalizationsDelegate<dynamic>>[
    ...?widget.localizationsDelegates,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  Widget _wrap(BuildContext context, Widget? child) {
    final defaults = CharcoalTextDefaults(child: child ?? const SizedBox.shrink());
    final builder = widget.builder;
    return builder == null ? defaults : builder(context, defaults);
  }

  @override
  Widget build(BuildContext context) {
    if (_usesRouter) {
      return MaterialApp.router(
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser,
        routerDelegate: widget.routerDelegate,
        routerConfig: widget.routerConfig,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: _wrap,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        theme: _light,
        darkTheme: _dark,
        themeMode: _themeMode,
        locale: widget.locale,
        localizationsDelegates: _delegates,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        localeResolutionCallback: widget.localeResolutionCallback,
        supportedLocales: widget.supportedLocales,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
        scrollBehavior: widget.scrollBehavior,
      );
    }
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      navigatorObservers: widget.navigatorObservers,
      builder: _wrap,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      theme: _light,
      darkTheme: _dark,
      themeMode: _themeMode,
      locale: widget.locale,
      localizationsDelegates: _delegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales: widget.supportedLocales,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
      scrollBehavior: widget.scrollBehavior,
    );
  }
}
