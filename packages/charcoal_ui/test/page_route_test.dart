import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CharcoalPageRoute uses opaque shared-axis motion', (tester) async {
    late BuildContext homeContext;
    late BuildContext detailContext;
    await tester.pumpWidget(
      CharcoalApp(
        home: Builder(
          builder: (context) {
            homeContext = context;
            return const ColoredBox(
              color: Color(0xFFFFFFFF),
              child: Center(child: Text('Home')),
            );
          },
        ),
      ),
    );

    final route = CharcoalPageRoute<void>(
      builder: (context) {
        detailContext = context;
        return const ColoredBox(
          color: Color(0xFFFFFFFF),
          child: Center(child: Text('Detail')),
        );
      },
    );
    expect(route.allowSnapshotting, isFalse);
    expect(route.transitionDuration, CharcoalMotion.routeForward);
    expect(route.reverseTransitionDuration, CharcoalMotion.routeReverse);

    Navigator.of(homeContext).push<void>(route);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Detail'), findsOneWidget);
    expect(find.byType(FadeTransition), findsNothing);
    expect(
      tester
          .widgetList<SlideTransition>(find.byType(SlideTransition))
          .any((transition) => transition.position.value != Offset.zero),
      isTrue,
    );

    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Detail'), findsOneWidget);

    Navigator.of(detailContext).pop();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Detail'), findsNothing);
  });
}
