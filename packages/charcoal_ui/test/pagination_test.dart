import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('adapts the default page window to compact constraints', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 280,
          child: CharcoalPagination(
            currentPage: 50,
            pageCount: 100,
            onPageChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('49'), findsNothing);
    expect(find.text('51'), findsNothing);
    expect(find.text('…'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports a compact three-page mobile window', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 200,
          child: CharcoalPagination(
            currentPage: 50,
            maxVisiblePages: 3,
            pageCount: 100,
            onPageChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('…'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a centered page window and reports navigation', (tester) async {
    int? nextPage;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalPagination(
          currentPage: 50,
          pageCount: 100,
          onPageChanged: (page) => nextPage = page,
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('49'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
    expect(find.text('51'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('…'), findsNWidgets(2));

    await tester.tap(find.text('51'));
    expect(nextPage, 51);
  });

  testWidgets('announces one non-interactive current page and hides ellipses', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalPagination(
          currentPage: 50,
          pageCount: 100,
          onPageChanged: (_) {},
          semanticLabel: 'Search result pages',
        ),
      ),
    );

    expect(find.bySemanticsLabel('Search result pages'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('50')),
      matchesSemantics(
        label: 'Page 50',
        hasSelectedState: true,
        isSelected: true,
      ),
    );
    expect(find.bySemanticsLabel('…'), findsNothing);
  });

  testWidgets('hides previous navigation on the first page', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalPagination(currentPage: 1, pageCount: 10, onPageChanged: (_) {}),
      ),
    );

    expect(find.bySemanticsLabel('Previous page'), findsNothing);
    expect(find.bySemanticsLabel('Next page'), findsOneWidget);
  });

  testWidgets('keyboard traversal skips hidden boundary navigation', (
    tester,
  ) async {
    int? requestedPage;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalPagination(
          currentPage: 1,
          pageCount: 3,
          onPageChanged: (page) => requestedPage = page,
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(requestedPage, 2);
  });

  testWidgets('navigation chevrons follow text direction', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: CharcoalPagination(
            currentPage: 2,
            pageCount: 3,
            onPageChanged: (_) {},
          ),
        ),
      ),
    );

    final icons = tester
        .widgetList<CharcoalIcon>(
          find.descendant(
            of: find.byType(CharcoalPagination),
            matching: find.byType(CharcoalIcon),
          ),
        )
        .toList();
    expect(icons, hasLength(2));
    expect(icons.first.icon, CharcoalIcons16.chevronRight);
    expect(icons.last.icon, CharcoalIcons16.chevronLeft);
  });
}
