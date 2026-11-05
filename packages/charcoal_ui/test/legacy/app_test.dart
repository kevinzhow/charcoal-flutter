import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('named routes use CharcoalPageRoute and notify observers', (tester) async {
    final observer = _RecordingNavigatorObserver();

    await tester.pumpWidget(
      CharcoalApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Navigator.of(context).pushNamed<void>('/details'),
            child: const Text('Open details'),
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/details': (_) => const Text('Account details'),
        },
      ),
    );

    await tester.tap(find.text('Open details'));
    await tester.pumpAndSettle();

    expect(find.text('Account details'), findsOneWidget);
    expect(observer.pushed.last, isA<CharcoalPageRoute<void>>());
    expect(
      find.ancestor(
        of: find.byType(WidgetsApp),
        matching: find.byType(HeroControllerScope),
      ),
      findsOneWidget,
    );
  });

  testWidgets('selects light and dark themes from the requested mode', (tester) async {
    final light = CharcoalThemeData.light();
    final dark = CharcoalThemeData.dark();
    late CharcoalThemeData resolvedTheme;

    Widget buildApp(Brightness brightness, {CharcoalThemeMode mode = CharcoalThemeMode.system}) =>
        MediaQuery(
          data: MediaQueryData(platformBrightness: brightness),
          child: CharcoalApp(
            theme: light,
            darkTheme: dark,
            themeMode: mode,
            home: Builder(
              builder: (context) {
                resolvedTheme = CharcoalTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

    await tester.pumpWidget(buildApp(Brightness.light));
    expect(resolvedTheme, same(light));

    await tester.pumpWidget(buildApp(Brightness.dark));
    expect(resolvedTheme, same(dark));

    await tester.pumpWidget(
      buildApp(Brightness.dark, mode: CharcoalThemeMode.light),
    );
    expect(resolvedTheme, same(light));
  });

  testWidgets('propagates locale delegates and generates a localized title', (tester) async {
    Locale? resolvedLocale;
    String? resolvedValue;
    String? generatedTitle;

    await tester.pumpWidget(
      CharcoalApp(
        locale: const Locale('zh'),
        supportedLocales: const <Locale>[Locale('en'), Locale('zh')],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          _TestStringsDelegate(),
        ],
        onGenerateTitle: (context) {
          generatedTitle = _TestStrings.of(context).value;
          return generatedTitle!;
        },
        home: Builder(
          builder: (context) {
            resolvedLocale = Localizations.localeOf(context);
            resolvedValue = _TestStrings.of(context).value;
            return Text(resolvedValue!);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(resolvedLocale, const Locale('zh'));
    expect(resolvedValue, 'localized-zh');
    expect(generatedTitle, 'localized-zh');
    expect(find.text('localized-zh'), findsOneWidget);
  });

  testWidgets('router constructor installs the same app-level infrastructure', (tester) async {
    final delegate = _TestRouterDelegate();
    addTearDown(delegate.dispose);
    final theme = CharcoalThemeData.light();
    const scrollBehavior = _TestScrollBehavior();
    CharcoalThemeData? builderTheme;
    ScrollBehavior? builderScrollBehavior;

    await tester.pumpWidget(
      CharcoalApp.router(
        routerConfig: RouterConfig<Object>(routerDelegate: delegate),
        theme: theme,
        scrollBehavior: scrollBehavior,
        restorationScopeId: 'charcoal-app',
        builder: (context, child) {
          builderTheme = CharcoalTheme.of(context);
          builderScrollBehavior = ScrollConfiguration.of(context);
          return child!;
        },
      ),
    );
    await tester.pump();

    expect(find.text('Router destination'), findsOneWidget);
    expect(builderTheme, same(theme));
    expect(builderScrollBehavior, same(scrollBehavior));
    expect(find.byType(HeroControllerScope), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RootRestorationScope && widget.restorationId == 'charcoal-app',
      ),
      findsOneWidget,
    );
  });

  testWidgets('forwards shortcuts and actions to WidgetsApp', (tester) async {
    const shortcuts = <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyK, control: true): _TestIntent(),
    };
    final actions = <Type, Action<Intent>>{
      _TestIntent: CallbackAction<_TestIntent>(onInvoke: (_) => null),
    };

    await tester.pumpWidget(
      CharcoalApp(
        shortcuts: shortcuts,
        actions: actions,
        home: const SizedBox.shrink(),
      ),
    );

    final widgetsApp = tester.widget<WidgetsApp>(find.byType(WidgetsApp));
    expect(widgetsApp.shortcuts, same(shortcuts));
    expect(widgetsApp.actions, same(actions));
  });
}

final class _RecordingNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushed = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}

final class _TestStrings {
  const _TestStrings(this.value);

  final String value;

  static _TestStrings of(BuildContext context) =>
      Localizations.of<_TestStrings>(context, _TestStrings)!;
}

final class _TestStringsDelegate extends LocalizationsDelegate<_TestStrings> {
  const _TestStringsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en' || locale.languageCode == 'zh';

  @override
  Future<_TestStrings> load(Locale locale) async =>
      _TestStrings('localized-${locale.languageCode}');

  @override
  bool shouldReload(_TestStringsDelegate old) => false;
}

final class _TestRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  @override
  Widget build(BuildContext context) => const Text('Router destination');

  @override
  Future<bool> popRoute() async => false;

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

final class _TestScrollBehavior extends ScrollBehavior {
  const _TestScrollBehavior();
}

final class _TestIntent extends Intent {
  const _TestIntent();
}
