import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/app_examples_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('compact app example exposes navigation and changes pages', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 320));

    expect(
      find.byKey(const ValueKey<String>('agent-app-catalog')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-example-studio')),
      findsNothing,
    );
    await _openAster(tester);

    expect(
      find.byKey(const ValueKey<String>('agent-example-studio')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-example-mobile-navigation')),
      findsNothing,
    );

    final menuButton = find.byKey(
      const ValueKey<String>('agent-example-menu-button'),
    );
    await tester.ensureVisible(menuButton);
    await tester.tap(menuButton);
    await tester.pump(const Duration(milliseconds: 250));

    expect(
      find.byKey(const ValueKey<String>('agent-example-mobile-navigation')),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('agent-example-nav-projects')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('agent-example-projects')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-example-mobile-navigation')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('project page filters from a controlled search field', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 1000));
    await _openAster(tester);
    final selector = find.byKey(
      const ValueKey<String>('agent-example-selector'),
    );
    await tester.ensureVisible(selector);
    await tester.tap(
      find.descendant(of: selector, matching: find.text('Projects')),
    );
    await tester.pump(const Duration(milliseconds: 250));

    final search = find.descendant(
      of: find.byKey(const ValueKey<String>('agent-project-search')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(search, 'not a project');
    await tester.pump();

    expect(find.text('No results for “not a project”'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings page keeps actions usable on a narrow surface', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 320));
    await _openAster(tester);
    final selector = find.byKey(
      const ValueKey<String>('agent-example-selector'),
    );
    await tester.ensureVisible(selector);
    await tester.tap(
      find.descendant(of: selector, matching: find.text('Settings')),
    );
    await tester.pump(const Duration(milliseconds: 250));

    final displayNameField = find.descendant(
      of: find.byWidgetPredicate(
        (widget) =>
            widget is CharcoalTextField && widget.label == 'Display name',
      ),
      matching: find.byType(EditableText),
    );
    await tester.ensureVisible(displayNameField);
    await tester.enterText(displayNameField, 'Mina Sato');
    await tester.pump();
    expect(find.text('Mina Sato'), findsNWidgets(2));

    final save = find.byKey(const ValueKey<String>('agent-settings-save'));
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pump();

    expect(
      find.descendant(of: save, matching: find.text('Saved')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Aster creates and archives a project through the visible flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 1000));
    await _openAster(tester);
    final selector = find.byKey(
      const ValueKey<String>('agent-example-selector'),
    );
    await tester.tap(
      find.descendant(of: selector, matching: find.text('Projects')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('agent-project-new')));
    await tester.pumpAndSettle();
    final nameField = find.descendant(
      of: find.byKey(const ValueKey<String>('agent-project-new-name')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(nameField, 'August light');
    await tester.pump();
    final create = find.byKey(const ValueKey<String>('agent-project-create'));
    await tester.ensureVisible(create);
    await tester.tap(create);
    await tester.pumpAndSettle();

    expect(find.text('August light'), findsOneWidget);
    expect(find.text('“August light” is ready to edit.'), findsOneWidget);

    final archive = find.bySemanticsLabel('Archive August light');
    await tester.ensureVisible(archive);
    await tester.tap(archive);
    await tester.pumpAndSettle();
    expect(find.text('“August light” moved to the archive.'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-project-filter')),
        matching: find.text('Archived'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('August light'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('app tiles open isolated interactive simulations and return', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 320));

    final persistentNavigation = find.byKey(
      const ValueKey<String>('agent-app-persistent-navigation'),
    );
    expect(persistentNavigation, findsOneWidget);
    final persistentElement = tester.element(persistentNavigation);

    final socialTile = find.byKey(
      const ValueKey<String>('agent-app-tile-social'),
    );
    await tester.ensureVisible(socialTile);
    await tester.tap(socialTile);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('agent-app-detail-social')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-app-simulator-social')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-app-tile-commerce')),
      findsNothing,
    );
    expect(tester.element(persistentNavigation), same(persistentElement));

    final like = find.byKey(
      const ValueKey<String>('agent-social-like-post-aki-rain'),
    );
    await tester.ensureVisible(like);
    await tester.tap(like);
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.widget<CharcoalIconButton>(like).selected, isTrue);

    final back = find.byKey(const ValueKey<String>('agent-app-back'));
    await tester.ensureVisible(back);
    await tester.tap(back);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('agent-app-catalog')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-app-tile-aster')),
      findsOneWidget,
    );
    expect(tester.element(persistentNavigation), same(persistentElement));
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openAster(WidgetTester tester) async {
  final tile = find.byKey(const ValueKey<String>('agent-app-tile-aster'));
  await tester.ensureVisible(tile);
  await tester.tap(tile);
  await tester.pumpAndSettle();
  expect(
    find.byKey(const ValueKey<String>('agent-app-detail-aster')),
    findsOneWidget,
  );
}

Widget _testApp({required double width}) => CharcoalApp(
  themeMode: CharcoalThemeMode.light,
  home: Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: width,
      child: const SingleChildScrollView(child: AgentAppExamplesPage()),
    ),
  ),
);
