import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/components/popup_shape.dart';
import 'package:flutter/services.dart';
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

  testWidgets('tooltip opens on tap and honors an explicit placement', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const Center(
          child: CharcoalTooltip(
            message: 'Above the anchor',
            position: CharcoalOverlayPosition.top,
            child: SizedBox.square(
              key: ValueKey<String>('tap-tooltip-trigger'),
              dimension: 40,
            ),
          ),
        ),
      ),
    );

    final trigger = find.byKey(const ValueKey<String>('tap-tooltip-trigger'));
    await tester.tapAt(tester.getCenter(trigger));
    await tester.pump(const Duration(milliseconds: 210));

    expect(find.text('Above the anchor'), findsOneWidget);
    expect(
      tester.getBottomLeft(find.text('Above the anchor')).dy,
      lessThan(tester.getTopLeft(trigger).dy),
    );

    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.text('Above the anchor'), findsNothing);
  });

  testWidgets('focused tooltip dismisses with Escape without moving focus', (
    tester,
  ) async {
    final focusNode = FocusNode();
    final visibilityChanges = <bool>[];
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTooltip(
          message: 'Keyboard context',
          onVisibilityChanged: visibilityChanges.add,
          waitDuration: Duration.zero,
          child: CharcoalButton(
            focusNode: focusNode,
            onPressed: () {},
            child: const Text('Focusable trigger'),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();

    expect(find.text('Keyboard context'), findsOneWidget);
    expect(focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Keyboard context'), findsNothing);
    expect(focusNode.hasFocus, isTrue);
    expect(visibilityChanges, <bool>[true, false]);
  });

  testWidgets('tooltip constrains long content and follows a scrolling anchor', (
    tester,
  ) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          height: 320,
          child: SingleChildScrollView(
            controller: scrollController,
            child: const Column(
              children: <Widget>[
                SizedBox(height: 120),
                CharcoalTooltip(
                  maxWidth: 120,
                  message: 'A long tooltip message that must wrap inside its maximum width.',
                  position: CharcoalOverlayPosition.bottom,
                  visible: true,
                  child: SizedBox.square(
                    key: ValueKey<String>('tracked-tooltip-anchor'),
                    dimension: 40,
                  ),
                ),
                SizedBox(height: 480),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final popupPaint = find.byWidgetPredicate(
      (widget) => widget is CustomPaint && widget.painter is CharcoalPopupShapePainter,
    );
    expect(tester.getSize(popupPaint).width, lessThanOrEqualTo(120));
    final initialTop = tester.getTopLeft(find.textContaining('A long tooltip'));

    scrollController.jumpTo(48);
    await tester.pump();
    await tester.pump();

    final movedTop = tester.getTopLeft(find.textContaining('A long tooltip'));
    expect(movedTop.dy, moreOrLessEquals(initialTop.dy - 48, epsilon: 1));
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

  testWidgets('balloon close affordance supports keyboard activation', (
    tester,
  ) async {
    var dismissCount = 0;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalBalloon(
          onDismiss: () => dismissCount += 1,
          child: const Text('Persistent context'),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(dismissCount, 1);
  });

  testWidgets('anchored balloon dismisses with Escape from its focused anchor', (
    tester,
  ) async {
    final focusNode = FocusNode();
    final visibilityChanges = <bool>[];
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalAnchoredBalloon(
          message: 'Persistent details',
          onVisibilityChanged: visibilityChanges.add,
          anchor: CharcoalButton(
            focusNode: focusNode,
            onPressed: () {},
            child: const Text('Balloon trigger'),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.tap(find.text('Balloon trigger'));
    await tester.pumpAndSettle();

    expect(find.text('Persistent details'), findsOneWidget);
    expect(focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Persistent details'), findsNothing);
    expect(focusNode.hasFocus, isTrue);
    expect(visibilityChanges, <bool>[true, false]);

    await tester.tap(find.text('Balloon trigger'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(find.text('Persistent details'), findsOneWidget);
    expect(focusNode.hasFocus, isFalse);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Persistent details'), findsNothing);
    expect(visibilityChanges, <bool>[true, false, true, false]);
  });

  testWidgets('anchored balloon points back to an edge-clamped anchor', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const Align(
          alignment: Alignment.topLeft,
          child: CharcoalAnchoredBalloon(
            message: 'Tracked balloon',
            visible: true,
            anchor: SizedBox.square(dimension: 24),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final popupPaint = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is CharcoalPopupShapePainter,
      ),
    );
    final painter = popupPaint.painter! as CharcoalPopupShapePainter;
    expect(painter.arrowCenter, isNotNull);
    expect(
      painter.arrowCenter!,
      lessThan(tester.getSize(find.byType(CharcoalBalloon)).width / 2),
    );
  });

  test('balloon body and arrow form one continuous path', () {
    for (final position in CharcoalOverlayPosition.values) {
      final path = charcoalPopupPath(
        arrowHalfWidth: 7,
        arrowHeight: 4,
        position: position,
        radius: 16,
        size: const Size(160, 64),
      );

      expect(path.computeMetrics().length, 1, reason: position.name);
    }
  });

  test('oversized overlays are centered without an invalid clamp range', () {
    expect(
      constrainCharcoalOverlayOrigin(
        desired: 100,
        inset: 16,
        popupExtent: 320,
        viewportExtent: 240,
      ),
      0,
    );
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
      variant: CharcoalToastVariant.error,
    );
    await tester.pump();
    expect(find.text('Temporary'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 101));
    expect(find.text('Temporary'), findsNothing);
  });

  testWidgets('toast and snackbar preserve the iOS outline and elevation contract', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();

    await tester.pumpWidget(
      charcoalTestApp(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalToast(message: 'Saved'),
            CharcoalSnackBar(message: 'Bookmarked'),
          ],
        ),
        theme: theme,
      ),
    );

    BoxDecoration surfaceDecoration(Finder surface) => tester
        .widgetList<DecoratedBox>(
          find.descendant(of: surface, matching: find.byType(DecoratedBox)),
        )
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .singleWhere((decoration) => decoration.border != null);

    final toast = surfaceDecoration(find.byType(CharcoalToast));
    final toastBorder = toast.border! as Border;
    expect(toastBorder.top.color, theme.colors.backgroundDefault);
    expect(toastBorder.top.width, theme.dimensions.borderWidth.l);
    expect(toast.boxShadow, isNull);

    final snackBar = surfaceDecoration(find.byType(CharcoalSnackBar));
    final snackBarBorder = snackBar.border! as Border;
    expect(snackBarBorder.top.color, theme.colors.borderDefault);
    expect(snackBarBorder.top.width, theme.dimensions.borderWidth.m);
    expect(snackBar.boxShadow, isNull);
  });

  testWidgets('snackbar renders a thumbnail and dismisses through its handle', (
    tester,
  ) async {
    late BuildContext popupContext;
    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) {
            popupContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final controller = showCharcoalSnackBar(
      context: popupContext,
      duration: Duration.zero,
      message: 'Bookmarked',
      thumbnail: const SizedBox(key: ValueKey<String>('thumbnail')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bookmarked'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('thumbnail')), findsOneWidget);
    controller.dismiss();
    await tester.pumpAndSettle();
    expect(find.text('Bookmarked'), findsNothing);
  });

  testWidgets('snackbar rubber-bands inward and dismisses outward', (
    tester,
  ) async {
    late BuildContext popupContext;
    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) {
            popupContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final controller = showCharcoalSnackBar(
      context: popupContext,
      duration: Duration.zero,
      message: 'Drag me',
    );
    await tester.pumpAndSettle();

    await tester.drag(find.text('Drag me'), const Offset(0, -120));
    await tester.pumpAndSettle();
    expect(controller.isShowing, isTrue);

    await tester.drag(find.text('Drag me'), const Offset(0, 60));
    await tester.pumpAndSettle();
    expect(controller.isShowing, isFalse);
  });
}
