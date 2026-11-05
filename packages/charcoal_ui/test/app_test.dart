import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('named routes get Charcoal transitions and notify observers', (tester) async {
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
        routes: <String, WidgetBuilder>{'/details': (_) => const Text('Account details')},
      ),
    );

    await tester.tap(find.text('Open details'));
    await tester.pumpAndSettle();

    expect(find.text('Account details'), findsOneWidget);
    expect(observer.pushed.last, isA<PageRoute<void>>());
    expect(find.byType(HeroControllerScope), findsWidgets);
    // Every platform's transition is Charcoal's, so routes Material creates behave like
    // CharcoalPageRoute.
    final context = tester.element(find.text('Account details'));
    final transitions = Theme.of(context).pageTransitionsTheme.builders;
    expect(transitions.keys, containsAll(TargetPlatform.values));
    expect(transitions.values.every((b) => b is CharcoalPageTransitionsBuilder), isTrue);
  });

  testWidgets('selects light and dark packs from the requested mode', (tester) async {
    final light = charcoalLightPack.copyWith(name: 'custom-light');
    final dark = charcoalDarkPack.copyWith(name: 'custom-dark');
    late CharcoalThemePack resolved;

    Widget buildApp(Brightness brightness, {CharcoalThemeMode mode = CharcoalThemeMode.system}) =>
        MediaQuery(
          data: MediaQueryData(platformBrightness: brightness),
          child: CharcoalApp(
            lightPack: light,
            darkPack: dark,
            themeMode: mode,
            home: Builder(
              builder: (context) {
                resolved = CharcoalTheme.of(context).pack;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

    await tester.pumpWidget(buildApp(Brightness.light));
    expect(resolved, same(light));

    await tester.pumpWidget(buildApp(Brightness.dark));
    await tester.pumpAndSettle();
    expect(resolved, same(dark));

    await tester.pumpWidget(buildApp(Brightness.dark, mode: CharcoalThemeMode.light));
    await tester.pumpAndSettle();
    expect(resolved, same(light));
  });

  testWidgets('defaults to the generated Charcoal packs and sets ambient text', (tester) async {
    late BuildContext inner;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(platformBrightness: Brightness.light),
        child: CharcoalApp(
          home: Builder(
            builder: (context) {
              inner = context;
              return const Text('x');
            },
          ),
        ),
      ),
    );
    expect(CharcoalTheme.of(inner).pack, same(charcoalLightPack));
    final style = DefaultTextStyle.of(inner).style;
    expect(style.decoration, isNot(TextDecoration.underline));
    expect(style.fontSize, charcoalLightPack.typography.spec(CharcoalTextRole.bodyLarge).fontSize);
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
    final pack = charcoalLightPack.copyWith(name: 'router-pack');
    const scrollBehavior = _TestScrollBehavior();
    CharcoalThemePack? builderPack;
    ScrollBehavior? builderScrollBehavior;

    await tester.pumpWidget(
      CharcoalApp.router(
        routerConfig: RouterConfig<Object>(routerDelegate: delegate),
        lightPack: pack,
        themeMode: CharcoalThemeMode.light,
        scrollBehavior: scrollBehavior,
        restorationScopeId: 'charcoal-app',
        builder: (context, child) {
          builderPack = CharcoalTheme.of(context).pack;
          builderScrollBehavior = ScrollConfiguration.of(context);
          return child!;
        },
      ),
    );
    await tester.pump();

    expect(find.text('Router destination'), findsOneWidget);
    expect(builderPack, same(pack));
    expect(builderScrollBehavior, same(scrollBehavior));
    expect(find.byType(HeroControllerScope), findsWidgets);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RootRestorationScope && widget.restorationId == 'charcoal-app',
      ),
      findsOneWidget,
    );
  });

  testWidgets('forwards shortcuts and actions to MaterialApp', (tester) async {
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

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.shortcuts, same(shortcuts));
    expect(app.actions, same(actions));
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
