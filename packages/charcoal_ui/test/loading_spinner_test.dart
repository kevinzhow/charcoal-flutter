import 'dart:ui' show SemanticsRole;

import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/overlay_app.dart';

void main() {
  testWidgets('loading spinner uses source defaults and exposes a live-region label', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(const CharcoalLoadingSpinner(once: true)),
    );

    final semantics = tester.getSemantics(find.bySemanticsLabel('Loading'));
    expect(semantics.role, SemanticsRole.loadingSpinner);
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
    final square = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .firstWhere(
          (widget) => widget.width == charcoalLightPack.sizes.controlLg,
        );
    expect(square.height, charcoalLightPack.sizes.controlLg);

    await tester.pump(const Duration(milliseconds: 500));
    final animatedOpacity = tester.widgetList<Opacity>(find.byType(Opacity)).last;
    expect(animatedOpacity.opacity, inExclusiveRange(0, 1));

    final decorations = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(
      decorations.any((decoration) => decoration.shape == BoxShape.circle),
      isTrue,
    );
  });

  testWidgets('transparent spinner keeps the source shadow', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalLoadingSpinner(once: true, transparent: true),
      ),
    );

    final surface = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .singleWhere((decoration) => decoration.boxShadow?.isNotEmpty ?? false);
    expect(surface.color, isNull);
    expect(surface.borderRadius, BorderRadius.circular(charcoalLightPack.radius.md));
    expect(surface.boxShadow!.single.blurRadius, charcoalLightPack.metrics.spinner.shadowBlur);
    expect(surface.boxShadow!.single.color, charcoalLightPack.colors.shadow);
  });

  testWidgets('spinner overlay can block or pass through interaction', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalSpinnerOverlay(
          visible: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => taps++,
            child: const SizedBox.square(dimension: 120),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tapAt(tester.getCenter(find.byType(CharcoalSpinnerOverlay)));
    expect(taps, 0);
  });

  testWidgets('blocking spinner overlay removes child focus and semantics', (
    tester,
  ) async {
    final visible = ValueNotifier<bool>(false);
    final focusNode = FocusNode();
    var activations = 0;
    addTearDown(visible.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      charcoalTestApp(
        ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (context, isVisible, child) => CharcoalSpinnerOverlay(
            semanticLabel: 'Publishing draft',
            visible: isVisible,
            child: CharcoalButton(
              focusNode: focusNode,
              onPressed: () => activations++,
              child: const Text('Publish'),
            ),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasPrimaryFocus, isTrue);

    visible.value = true;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(focusNode.hasFocus, isFalse);
    expect(find.semantics.byLabel('Publish'), findsNothing);
    expect(find.semantics.byLabel('Publishing draft'), findsOne);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(activations, 0);
  });

  testWidgets('passthrough overlay preserves child input and semantics', (
    tester,
  ) async {
    final focusNode = FocusNode();
    var activations = 0;
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalSpinnerOverlay(
          interactionPassthrough: true,
          semanticLabel: 'Refreshing results',
          visible: true,
          child: CharcoalButton(
            focusNode: focusNode,
            onPressed: () => activations++,
            child: const Text('Keep editing'),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);

    expect(activations, 1);
    expect(find.semantics.byLabel('Keep editing'), findsOne);
    expect(find.semantics.byLabel('Refreshing results'), findsOne);
  });

  test('loading components reject invalid geometry and empty semantics', () {
    expect(
      () => CharcoalLoadingSpinner(size: 0),
      throwsAssertionError,
    );
    expect(
      () => CharcoalLoadingSpinner(padding: -1),
      throwsAssertionError,
    );
    expect(
      () => CharcoalLoadingSpinner(semanticLabel: ''),
      throwsAssertionError,
    );
    expect(
      () => CharcoalSpinnerOverlay(
        semanticLabel: 'Loading',
        spinnerSize: 0,
        visible: true,
        child: SizedBox(),
      ),
      throwsAssertionError,
    );
  });

  testWidgets('reduced motion freezes the spinner mid-way and still announces itself', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: charcoalTestApp(const CharcoalLoadingSpinner()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('dimmed overlay paints the scrim behind the spinner', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox.square(
          dimension: 120,
          child: CharcoalSpinnerOverlay(visible: true, dimBackground: true, child: SizedBox()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    final scrim = tester.widgetList<ColoredBox>(
      find.descendant(of: find.byType(CharcoalSpinnerOverlay), matching: find.byType(ColoredBox)),
    );
    expect(scrim.map((box) => box.color), contains(charcoalLightPack.colors.scrim));
  });
}
