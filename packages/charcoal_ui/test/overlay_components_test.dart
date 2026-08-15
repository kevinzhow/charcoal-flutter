import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('tooltip opens on hover and closes when the pointer leaves', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalTooltip(
          message: 'Helpful context',
          waitDuration: Duration.zero,
          child: SizedBox.square(
            key: ValueKey<String>('tooltip-trigger'),
            dimension: 40,
          ),
        ),
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byKey(const ValueKey<String>('tooltip-trigger'))),
    );
    await tester.pump();

    expect(find.text('Helpful context'), findsOneWidget);

    await mouse.moveTo(Offset.zero);
    await tester.pump();

    expect(find.text('Helpful context'), findsNothing);
  });

  testWidgets('balloon renders every directional tail', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        Wrap(
          children: <Widget>[
            for (final position in CharcoalOverlayPosition.values)
              CharcoalBalloon(
                position: position,
                child: Text(position.name),
              ),
          ],
        ),
      ),
    );

    expect(find.byType(CharcoalBalloon), findsNWidgets(4));
    for (final position in CharcoalOverlayPosition.values) {
      expect(find.text(position.name), findsOneWidget);
    }
  });

  testWidgets('toast can be dismissed and auto-dismissed', (tester) async {
    late BuildContext toastContext;
    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) {
            toastContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final controller = showCharcoalToast(
      context: toastContext,
      duration: Duration.zero,
      message: 'Saved',
    );
    await tester.pump();

    expect(controller.isShowing, isTrue);
    expect(find.text('Saved'), findsOneWidget);

    controller.dismiss();
    await tester.pump();

    expect(controller.isShowing, isFalse);
    expect(find.text('Saved'), findsNothing);

    showCharcoalToast(
      context: toastContext,
      duration: const Duration(milliseconds: 100),
      message: 'Temporary',
      variant: CharcoalToastVariant.negative,
    );
    await tester.pump();
    expect(find.text('Temporary'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 101));
    expect(find.text('Temporary'), findsNothing);
  });
}
