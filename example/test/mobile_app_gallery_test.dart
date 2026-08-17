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

  testWidgets('Bloom completes feed, reaction, save, and message flows', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.social);

    final like = find.byKey(
      const ValueKey<String>('agent-social-like-post-aki-rain'),
    );
    await _tapVisible(tester, like);
    expect(tester.widget<CharcoalIconButton>(like).selected, isTrue);
    expect(find.text('129'), findsOneWidget);

    final save = find.byKey(
      const ValueKey<String>('agent-social-save-post-aki-rain'),
    );
    await _tapVisible(tester, save);
    expect(tester.widget<CharcoalIconButton>(save).selected, isTrue);

    await _tapVisible(
      tester,
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-social-feed-control')),
        matching: find.text('For you'),
      ),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-social-feed-forYou')),
      findsOneWidget,
    );
    expect(find.text('Noa Watanabe'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-nav-messages')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-social-messages-page')),
      findsOneWidget,
    );
    await _tapVisible(tester, find.text('Aki Kondo'));
    final messageField = find.descendant(
      of: find.byKey(const ValueKey<String>('agent-social-message-field')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(messageField, 'Love this palette');
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-send-message')),
    );
    expect(find.text('Love this palette'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Nook completes search, category, save, bag, and checkout flows',
    (tester) async {
      await _pumpSimulator(tester, AgentMobileApp.commerce);

      final search = find.descendant(
        of: find.byKey(const ValueKey<String>('agent-commerce-search')),
        matching: find.byType(EditableText),
      );
      await _tapVisible(tester, find.text('Home'));
      expect(find.text('Paper lamp'), findsOneWidget);
      expect(find.text('Ripple cup'), findsNothing);

      await tester.enterText(search, 'lamp');
      await tester.pump();
      expect(find.text('Paper lamp'), findsOneWidget);
      expect(find.text('Ripple cup'), findsNothing);

      await _tapVisible(tester, find.bySemanticsLabel('Open Paper lamp'));
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-product-detail')),
        findsOneWidget,
      );
      await _tapVisible(tester, find.text('Save for later'));
      expect(find.widgetWithText(CharcoalButton, 'Saved'), findsOneWidget);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-add-to-bag')),
      );
      expect(find.text('Added to bag'), findsOneWidget);

      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-nav-saved')),
      );
      expect(find.text('Paper lamp'), findsOneWidget);

      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-bag')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-bag-page')),
        findsOneWidget,
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-checkout')),
      );
      expect(find.text('Checkout is ready for 1 item.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Lumen completes privacy, top-up, and transfer flows', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.wallet);

    final visibility = find.byKey(
      const ValueKey<String>('agent-wallet-visibility'),
    );
    await _tapVisible(tester, visibility);
    expect(find.text('¥ ••••••'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-action-topUp')),
    );
    await _tapVisible(tester, find.text('Add ¥ 10,000'));
    await _tapVisible(tester, visibility);
    expect(find.text('¥ 1,294,600'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-action-send')),
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-wallet-recipient')),
        matching: find.byType(EditableText),
      ),
      'Hana',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-wallet-amount')),
        matching: find.byType(EditableText),
      ),
      '8000',
    );
    await _tapVisible(
      tester,
      find.widgetWithText(CharcoalButton, 'Send money').last,
    );
    expect(find.text('¥ 8,000 was sent to Hana.'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-nav-activity')),
    );
    expect(find.text('To Hana'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Daylight completes a day and continues into the journey', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.habits);

    final walkRow = find.byKey(const ValueKey<String>('agent-habit-walk-row'));
    final walkCheckbox = find.descendant(
      of: walkRow,
      matching: find.byType(CharcoalCheckbox),
    );
    await _tapVisible(tester, walkCheckbox);
    expect(tester.widget<CharcoalCheckbox>(walkCheckbox).value, isTrue);
    expect(find.text('2/3'), findsOneWidget);

    final readCheckbox = find.descendant(
      of: find.byKey(const ValueKey<String>('agent-habit-read-row')),
      matching: find.byType(CharcoalCheckbox),
    );
    await _tapVisible(tester, readCheckbox);
    expect(find.text('3/3'), findsOneWidget);
    expect(find.text('Everything is complete.'), findsOneWidget);

    await _tapVisible(tester, find.text('Plan tomorrow'));
    expect(
      find.byKey(const ValueKey<String>('agent-habits-journey-page')),
      findsOneWidget,
    );
    expect(find.text('Monday'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpSimulator(WidgetTester tester, AgentMobileApp app) async {
  await tester.binding.setSurfaceSize(const Size(320, 760));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    _testApp(width: 320, child: AgentMobileAppSimulator(app: app)),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
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
