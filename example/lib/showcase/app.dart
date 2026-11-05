import 'dart:async';

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter/widgets.dart';

import '../showcase_window.dart';
import 'registry.dart';
import 'shell/showcase_shell.dart';
import 'theme.dart';

/// The showcase application: router-driven so every page has a `/#/<id>` URL.
final class CharcoalShowcaseApp extends StatefulWidget {
  const CharcoalShowcaseApp({super.key});

  @override
  State<CharcoalShowcaseApp> createState() => _CharcoalShowcaseAppState();
}

final class _CharcoalShowcaseAppState extends State<CharcoalShowcaseApp> {
  late final _ShowcaseRouterDelegate _delegate;
  late final RouterConfig<Object> _routerConfig;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _delegate = _ShowcaseRouterDelegate(
      darkMode: () => _darkMode,
      onDarkModeChanged: (value) {
        setState(() => _darkMode = value);
        _delegate.refresh();
      },
    );
    // Created once: a new provider would restart routing at the platform URL.
    _routerConfig = RouterConfig<Object>(
      backButtonDispatcher: RootBackButtonDispatcher(),
      routeInformationParser: const _ShowcaseRouteParser(),
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(
          uri: Uri.parse(
            WidgetsBinding.instance.platformDispatcher.defaultRouteName,
          ),
        ),
      ),
      routerDelegate: _delegate,
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CharcoalApp.router(
    title: 'Charcoal UI V2 Showcase',
    lightPack: buildShowcasePack(Brightness.light),
    darkPack: buildShowcasePack(Brightness.dark),
    themeMode: _darkMode ? CharcoalThemeMode.dark : CharcoalThemeMode.light,
    builder: (context, child) => Material(
      type: MaterialType.transparency,
      child: ShowcaseWindow(
        brightness: _darkMode ? Brightness.dark : Brightness.light,
        child: child!,
      ),
    ),
    routerConfig: _routerConfig,
  );
}

/// Maps `/<page-id>` to a registered page id; unknown paths show the overview.
final class _ShowcaseRouteParser extends RouteInformationParser<Object> {
  const _ShowcaseRouteParser();

  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) {
    final segments = routeInformation.uri.pathSegments;
    final id = segments.isEmpty ? showcaseHomeId : segments.first;
    return SynchronousFuture<Object>(
      showcasePageById(id) == null ? showcaseHomeId : id,
    );
  }

  @override
  RouteInformation restoreRouteInformation(Object configuration) =>
      RouteInformation(uri: Uri(path: '/$configuration'));
}

final class _ShowcaseRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  _ShowcaseRouterDelegate({
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final bool Function() darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _pageId = showcaseHomeId;

  void refresh() => notifyListeners();

  void _select(String id) {
    if (id == _pageId) return;
    _pageId = id;
    notifyListeners();
  }

  @override
  Object get currentConfiguration => _pageId;

  @override
  Future<void> setNewRoutePath(Object configuration) {
    _pageId = configuration as String;
    notifyListeners();
    return SynchronousFuture<void>(null);
  }

  Widget _buildShell(BuildContext context) => ListenableBuilder(
    listenable: this,
    builder: (context, _) => ShowcaseShell(
      darkMode: darkMode(),
      onDarkModeChanged: onDarkModeChanged,
      onPageSelected: _select,
      pageId: _pageId,
    ),
  );

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: <Page<void>>[_ShowcaseRoutePage(builder: _buildShell)],
    onDidRemovePage: (_) {},
  );
}

/// The single shell route; page changes happen inside the shell, not as
/// Navigator routes, so browser history comes from the Router alone.
final class _ShowcaseRoutePage extends Page<void> {
  const _ShowcaseRoutePage({required this.builder})
    : super(key: const ValueKey<String>('showcase-shell'));

  final WidgetBuilder builder;

  @override
  Route<void> createRoute(BuildContext context) => PageRouteBuilder<void>(
    settings: this,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  );
}
