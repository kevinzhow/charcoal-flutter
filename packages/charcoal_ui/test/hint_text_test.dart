import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('stacks its action below scaled copy at compact width', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 200,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: CharcoalHintText(
              action: CharcoalButton(
                onPressed: _noop,
                size: CharcoalButtonSize.small,
                variant: CharcoalButtonVariant.primary,
                child: Text('Review'),
              ),
              subtitle: Text('Editable later.'),
              child: Text('Changes saved.'),
            ),
          ),
        ),
      ),
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
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
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
      find.descendant(
        of: find.byType(CharcoalHintText),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect(tester.getRect(find.byKey(actionKey)).left, boxRect.left + 16);
    expect(tester.getRect(find.byKey(iconKey)).right, boxRect.right - 16);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps a horizontal action when scaled copy has enough room', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 640,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: CharcoalHintText(
              action: CharcoalButton(
                onPressed: _noop,
                size: CharcoalButtonSize.small,
                child: Text('Review'),
              ),
              child: Text('Changes saved.'),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Review')).dy,
      closeTo(tester.getCenter(find.text('Changes saved.')).dy, 0.01),
    );
    expect(tester.takeException(), isNull);
  });

  test('rejects a negative maximum width', () {
    expect(
      () => CharcoalHintText(
        maxWidth: -1,
        child: const Text('Invalid constraint'),
      ),
      throwsAssertionError,
    );
  });

  testWidgets('hidden hints remove copy and actions from the tree', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalHintText(
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
}

void _noop() {}
