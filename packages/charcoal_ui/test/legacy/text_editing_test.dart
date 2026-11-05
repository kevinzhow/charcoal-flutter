import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? clipboard;
  setUp(() {
    clipboard = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        switch (call.method) {
          case 'Clipboard.setData':
            clipboard = (call.arguments as Map)['text'] as String;
            return null;
          case 'Clipboard.getData':
            return {'text': clipboard};
          case 'Clipboard.hasStrings':
            return {'value': clipboard?.isNotEmpty ?? false};
        }
        return null;
      },
    );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  for (final multiline in [false, true]) {
    final name = multiline ? 'area' : 'field';
    Future<TextEditingController> mount(
      WidgetTester tester, {
      bool readOnly = false,
      bool obscure = false,
      bool disabled = false,
    }) async {
      final controller = TextEditingController(text: 'alpha bravo charlie');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        CharcoalApp(
          home: CharcoalScaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: multiline
                    ? CharcoalTextArea(
                        controller: controller,
                        readOnly: readOnly,
                        disabled: disabled,
                      )
                    : CharcoalTextField(
                        controller: controller,
                        readOnly: readOnly,
                        obscureText: obscure,
                        disabled: disabled,
                      ),
              ),
            ),
          ),
        ),
      );
      return controller;
    }

    Offset caret(WidgetTester tester, int offset) {
      final render = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
      return render.localToGlobal(render.getLocalRectForCaret(TextPosition(offset: offset)).center);
    }

    testWidgets('$name Android long press drags selection and opens clipboard menu', (
      tester,
    ) async {
      final controller = await mount(tester);
      final gesture = await tester.startGesture(caret(tester, 2));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      expect(controller.selection.textInside(controller.text), 'alpha');
      expect(find.byType(RawMagnifier), findsOneWidget);
      await gesture.moveTo(caret(tester, 9));
      await tester.pump();
      expect(controller.selection.textInside(controller.text), 'alpha bravo');
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(RawMagnifier), findsNothing);
      expect(find.text('Copy'), findsOneWidget);
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();
      expect(clipboard, 'alpha bravo');
      expect(find.text('Copy'), findsNothing);
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('$name selection handle drag extends the selected range', (tester) async {
      final controller = await mount(tester);
      await tester.longPressAt(caret(tester, 2));
      await tester.pumpAndSettle();
      final handle = find.byKey(const ValueKey('charcoal-selection-handle-right'));
      expect(handle, findsOneWidget);
      final drag = await tester.startGesture(tester.getCenter(handle));
      await drag.moveBy(const Offset(24, 0));
      await tester.pump();
      await drag.moveBy(const Offset(65, 0));
      await tester.pump();
      await drag.up();
      await tester.pumpAndSettle();
      expect(controller.selection.end, greaterThan(5));
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('$name cancelled long press removes magnifier without opening menu', (
      tester,
    ) async {
      await mount(tester);
      final gesture = await tester.startGesture(caret(tester, 2));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      expect(find.byType(RawMagnifier), findsOneWidget);
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(find.byType(RawMagnifier), findsNothing);
      expect(find.text('Copy'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('$name keyboard selection, clipboard paste and undo remain available', (
      tester,
    ) async {
      final controller = await mount(tester);
      await tester.tapAt(caret(tester, 2));
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      expect(controller.selection.textInside(controller.text), controller.text);
      await tester.pump(const Duration(milliseconds: 600));
      clipboard = 'replacement';
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(controller.text, 'replacement');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(controller.text, 'alpha bravo charlie');
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('$name iOS focused long press moves the caret continuously', (tester) async {
      final controller = await mount(tester);
      await tester.tapAt(caret(tester, 1));
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(caret(tester, 2));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      expect(controller.selection.isCollapsed, isTrue);
      final start = controller.selection.extentOffset;
      await gesture.moveTo(caret(tester, 10));
      await tester.pump();
      expect(controller.selection.isCollapsed, isTrue);
      expect(controller.selection.extentOffset, greaterThan(start));
      expect(find.byType(RawMagnifier), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(RawMagnifier), findsNothing);
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('$name desktop double click and mouse drag select text without touch handles', (
      tester,
    ) async {
      final controller = await mount(tester);
      final point = caret(tester, 2);
      await tester.tapAt(point, kind: PointerDeviceKind.mouse);
      await tester.pump(const Duration(milliseconds: 60));
      await tester.tapAt(point, kind: PointerDeviceKind.mouse);
      await tester.pumpAndSettle();
      expect(controller.selection.textInside(controller.text), 'alpha');
      expect(tester.widget<EditableText>(find.byType(EditableText)).showSelectionHandles, isFalse);
      await tester.pump(const Duration(milliseconds: 600));
      final drag = await tester.startGesture(caret(tester, 0), kind: PointerDeviceKind.mouse);
      await drag.moveTo(caret(tester, 12));
      await drag.up();
      await tester.pumpAndSettle();
      expect(controller.selection.isCollapsed, isFalse);
      expect(find.byType(RawMagnifier), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('$name read-only selection exposes copy but cannot cut or paste', (tester) async {
      await mount(tester, readOnly: true);
      await tester.longPressAt(caret(tester, 2));
      await tester.pumpAndSettle();
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Cut'), findsNothing);
      expect(find.text('Paste'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('$name disabled input cannot focus through touch', (tester) async {
      final controller = await mount(tester, disabled: true);
      await tester.longPressAt(caret(tester, 2));
      await tester.pumpAndSettle();
      expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isFalse);
      expect(controller.selection.isValid, isFalse);
      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('$name counts grapheme clusters consistently with maxLength', (tester) async {
      await tester.pumpWidget(
        CharcoalApp(
          home: Center(
            child: SizedBox(
              width: 320,
              child: multiline
                  ? const CharcoalTextArea(maxLength: 2, showCount: true)
                  : const CharcoalTextField(maxLength: 2, showCount: true),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), '👨‍👩‍👧‍👦éX');
      await tester.pump();
      expect(find.text('2/2'), findsOneWidget);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        '👨‍👩‍👧‍👦é',
      );
    });
  }

  testWidgets('large editing menu uses the field theme and stays above the keyboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.reset);
    final controller = TextEditingController(text: 'one two');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      CharcoalApp(
        home: CharcoalTheme(
          data: CharcoalThemeData.dark(),
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 600),
              textScaler: TextScaler.linear(3),
              viewInsets: EdgeInsets.only(bottom: 220),
            ),
            child: CharcoalScaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: CharcoalTextField(controller: controller),
              ),
            ),
          ),
        ),
      ),
    );
    final render = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
    await tester.longPressAt(
      render.localToGlobal(render.getLocalRectForCaret(const TextPosition(offset: 1)).center),
    );
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    expect(CharcoalTheme.of(tester.element(find.text('Copy'))).brightness, Brightness.dark);
    for (final label in ['Copy', 'Cut', 'Select all']) {
      final rect = tester.getRect(find.text(label));
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThanOrEqualTo(380));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(320));
    }
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('password menu never exposes copy or cut', (tester) async {
    final controller = TextEditingController(text: 'secret');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      CharcoalApp(
        home: Center(
          child: SizedBox(
            width: 320,
            child: CharcoalTextField(controller: controller, obscureText: true),
          ),
        ),
      ),
    );
    await tester.longPress(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsNothing);
    expect(find.text('Cut'), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}
