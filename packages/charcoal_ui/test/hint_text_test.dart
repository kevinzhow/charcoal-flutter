import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('stacks its action below scaled copy at compact width', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 200,
          child: CharcoalHintText(
            action: Text('Review'),
            subtitle: Text('Editable later.'),
            child: Text('Changes saved.'),
          ),
        ),
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('Review')).dy,
      greaterThan(tester.getBottomLeft(find.text('Editable later.')).dy),
    );
  });

  testWidgets('keeps copy leading and action trailing in RTL', (tester) async {
    const iconKey = ValueKey<String>('hint-icon');
    const actionKey = ValueKey<String>('hint-action');
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 320,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: CharcoalHintText(
              action: SizedBox(key: actionKey, width: 64, height: 32),
              icon: SizedBox(key: iconKey),
              child: Text('Helpful information'),
            ),
          ),
        ),
      ),
    );

    final boxRect = tester.getRect(
      find.descendant(of: find.byType(CharcoalHintText), matching: find.byType(DecoratedBox)).first,
    );
    expect(tester.getRect(find.byKey(actionKey)).left, boxRect.left + 16);
    expect(tester.getRect(find.byKey(iconKey)).right, boxRect.right - 16);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps a horizontal action when scaled copy has enough room', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 640,
          child: CharcoalHintText(action: Text('Review'), child: Text('Changes saved.')),
        ),
      ),
      textScale: 2,
    );

    expect(
      tester.getCenter(find.text('Review')).dy,
      closeTo(tester.getCenter(find.text('Changes saved.')).dy, 0.01),
    );
    expect(tester.takeException(), isNull);
  });

  test('rejects a negative maximum width', () {
    expect(
      () => CharcoalHintText(maxWidth: -1, child: const Text('Invalid constraint')),
      throwsAssertionError,
    );
  });

  testWidgets('hidden hints remove copy and actions from the tree', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: CharcoalHintText(
          action: Text('Action'),
          visible: false,
          child: Text('Hidden guidance'),
        ),
      ),
    );

    expect(find.text('Hidden guidance'), findsNothing);
    expect(find.text('Action'), findsNothing);
    expect(tester.getSize(find.byType(CharcoalHintText)), Size.zero);
  });

  testWidgets('paints the info icon in the iconHint role on the secondary surface', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(child: CharcoalHintText(child: Text('Info'))),
    );
    final surface = tester
        .widgetList<DecoratedBox>(
          find.descendant(of: find.byType(CharcoalHintText), matching: find.byType(DecoratedBox)),
        )
        .map((b) => b.decoration)
        .whereType<BoxDecoration>()
        .first;
    expect(surface.color, charcoalLightPack.colors.surfaceSecondary);
    final painter = tester
        .widgetList<CustomPaint>(
          find.descendant(of: find.byType(CharcoalHintText), matching: find.byType(CustomPaint)),
        )
        .map((p) => p.painter)
        .whereType<CustomPainter>()
        .toList();
    expect(painter, isNotEmpty);
  });
}
