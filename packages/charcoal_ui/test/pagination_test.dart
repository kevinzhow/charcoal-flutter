import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
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

  testWidgets('disables previous navigation on the first page', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalPagination(currentPage: 1, pageCount: 10, onPageChanged: (_) {}),
      ),
    );

    expect(
      tester.getSemantics(find.bySemanticsLabel('Previous page')),
      matchesSemantics(
        label: 'Previous page',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
  });
}
