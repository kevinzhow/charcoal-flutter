import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/mobile_app_gallery.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tileKeys = <String>[
    'agent-app-tile-social',
    'agent-app-tile-commerce',
    'agent-app-tile-wallet',
    'agent-app-tile-habits',
  ];

  testWidgets('lays out independent Agent Ready tiles on desktop', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 1080, child: _tileCatalog()));

    final topEdges = <double>[];
    for (final key in tileKeys) {
      final tile = find.byKey(ValueKey<String>(key));
      expect(tile, findsOneWidget);
      topEdges.add(tester.getTopLeft(tile).dy);
      expect(tester.getSize(tile).width, lessThan(360));
    }
    expect(topEdges.take(3).toSet(), hasLength(1));
    expect(topEdges.last, greaterThan(topEdges.first));
    expect(find.text('MADE WITH AGENT READY'), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stacks all app tiles on a compact surface', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 320, child: _tileCatalog()));

    var previousTop = -1.0;
    for (final key in tileKeys) {
      final tile = find.byKey(ValueKey<String>(key));
      expect(tile, findsOneWidget);
      expect(tester.getSize(tile).width, 320);
      final top = tester.getTopLeft(tile).dy;
      expect(top, greaterThan(previousTop));
      previousTop = top;
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps each opened simulator interactive', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _testApp(
        width: 320,
        child: const AgentMobileAppSimulator(app: AgentMobileApp.social),
      ),
    );
    final like = find.byKey(const ValueKey<String>('agent-social-like'));
    await tester.tap(like);
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.widget<CharcoalIconButton>(like).selected, isTrue);
    expect(find.text('129'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _testApp(
        width: 320,
        child: const AgentMobileAppSimulator(app: AgentMobileApp.wallet),
      ),
    );
    final visibility = find.byKey(
      const ValueKey<String>('agent-wallet-visibility'),
    );
    await tester.tap(visibility);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('¥ ••••••'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _testApp(
        width: 320,
        child: const AgentMobileAppSimulator(app: AgentMobileApp.habits),
      ),
    );
    final walkRow = find.byKey(const ValueKey<String>('agent-habit-walk-row'));
    final walkCheckbox = find.descendant(
      of: walkRow,
      matching: find.byType(CharcoalCheckbox),
    );
    await tester.tap(walkCheckbox);
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.widget<CharcoalCheckbox>(walkCheckbox).value, isTrue);
    expect(find.text('2/3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _tileCatalog() => AgentExampleTileGrid(
  children: <Widget>[
    for (final app in AgentMobileApp.values)
      AgentMobileAppTile(app: app, onPressed: () {}),
  ],
);

Widget _testApp({required double width, required Widget child}) => CharcoalApp(
  themeMode: CharcoalThemeMode.light,
  home: SingleChildScrollView(
    child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(width: width, child: child),
    ),
  ),
);
