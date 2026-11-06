import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/admin_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/form_section_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/layout_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/social_content_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/status_example.dart';
import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The curated layout, status, form and admin examples the catalog points at: they must build
/// at compact and standard widths and text scales without layout errors, and keep working.
void main() {
  Future<void> show(
    WidgetTester tester,
    Widget child, {
    required Size size,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await tester.pumpWidget(
      CharcoalApp(
        home: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  const sizes = <Size>[Size(320, 700), Size(900, 900)];

  for (final size in sizes) {
    for (final scale in const <double>[1, 2]) {
      final label = '${size.width.round()}px at ${scale}x';
      testWidgets('layout example builds at $label', (tester) async {
        await show(
          tester,
          const AgentLayoutExample(),
          size: size,
          textScale: scale,
        );
        expect(find.text('Alice Chen'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
      testWidgets('status example builds at $label', (tester) async {
        await show(
          tester,
          const AgentStatusExample(),
          size: size,
          textScale: scale,
        );
        expect(find.text('Import paused'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
      testWidgets('social content example builds at $label', (tester) async {
        await show(
          tester,
          const AgentSocialContentExample(),
          size: size,
          textScale: scale,
        );
        expect(find.text('Yes, two left.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
      testWidgets('form example builds at $label', (tester) async {
        await show(
          tester,
          const AgentFormSectionExample(),
          size: size,
          textScale: scale,
        );
        expect(find.text('Public project'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('status example swaps the page-region state in one frame', (
    tester,
  ) async {
    await show(tester, const AgentStatusExample(), size: sizes.last);
    await tester.tap(find.text('empty'));
    await tester.pump();
    expect(find.text('No jobs yet'), findsOneWidget);
    expect(find.text('Everything is up to date.'), findsNothing);
    await tester.tap(find.text('failed'));
    await tester.pump();
    expect(find.text('Could not load jobs.'), findsOneWidget);
    expect(find.text('No jobs yet'), findsNothing);
  });

  testWidgets('social content example opens the author and sends a reply', (
    tester,
  ) async {
    await show(tester, const AgentSocialContentExample(), size: sizes.last);
    await tester.tap(find.bySemanticsLabel('Open Aki Kondo profile'));
    await tester.pump();
    expect(find.text('Aki Kondo opened'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Send saved reply'));
    await tester.pump();
    expect(find.text('I will take one.'), findsOneWidget);
  });

  testWidgets('form example flags an empty required name', (tester) async {
    await show(tester, const AgentFormSectionExample(), size: sizes.last);
    expect(find.text('Enter a project name.'), findsNothing);
    await tester.enterText(find.byType(EditableText).first, '');
    await tester.pump();
    expect(find.text('Enter a project name.'), findsOneWidget);
  });

  testWidgets(
    'admin example switches shell layout by width and keeps the selected page',
    (tester) async {
      await show(
        tester,
        const SizedBox(height: 700, child: AgentAdminExample()),
        size: sizes.last,
      );
      expect(find.byType(CharcoalSidebar), findsOneWidget);
      expect(find.byType(CharcoalTabBar<String>), findsNothing);
      await tester.tap(find.text('Keys').first);
      await tester.pump();
      expect(find.text('Last 30 days'), findsOneWidget);

      await show(
        tester,
        const SizedBox(height: 700, child: AgentAdminExample()),
        size: sizes.first,
      );
      expect(find.byType(CharcoalSidebar), findsNothing);
      expect(find.byType(CharcoalTabBar<String>), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
