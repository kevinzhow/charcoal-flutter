import 'dart:ui' show Tristate;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsRole;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('distinguishes regular actions from controlled toggles', (
    tester,
  ) async {
    const actionKey = ValueKey<String>('icon-action');
    const offKey = ValueKey<String>('icon-toggle-off');
    const onKey = ValueKey<String>('icon-toggle-on');
    await tester.pumpWidget(
      charcoalTestApp(
        Column(
          children: <Widget>[
            CharcoalIconButton(
              key: actionKey,
              icon: const SizedBox.square(dimension: 16),
              onPressed: () {},
              semanticLabel: 'More actions',
            ),
            CharcoalIconButton(
              key: offKey,
              icon: const SizedBox.square(dimension: 16),
              onPressed: () {},
              selected: false,
              semanticLabel: 'Save item',
            ),
            CharcoalIconButton(
              key: onKey,
              icon: const SizedBox.square(dimension: 16),
              onPressed: () {},
              selected: true,
              semanticLabel: 'Remove saved item',
            ),
          ],
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byKey(actionKey)).flagsCollection.isSelected,
      Tristate.none,
    );
    expect(
      tester.getSemantics(find.byKey(offKey)).flagsCollection.isSelected,
      Tristate.isFalse,
    );
    expect(
      tester.getSemantics(find.byKey(onKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('icon button supports keyboard activation and disabled state', (
    tester,
  ) async {
    var activations = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        Row(
          children: <Widget>[
            CharcoalIconButton(
              icon: const SizedBox.square(dimension: 16),
              focusNode: focusNode,
              onPressed: () => activations++,
              semanticLabel: 'Search',
            ),
            const CharcoalIconButton(
              icon: SizedBox.square(dimension: 16),
              onPressed: null,
              semanticLabel: 'Unavailable action',
            ),
          ],
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);

    expect(activations, 1);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Unavailable action')).flagsCollection.isEnabled,
      Tristate.isFalse,
    );
  });

  testWidgets('icon button resolves its size and pressed semantic colors', (tester) async {
    final states = WidgetStatesController(<WidgetState>{WidgetState.pressed});
    addTearDown(states.dispose);
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalIconButton(
          icon: const SizedBox(key: Key('icon')),
          onPressed: () {},
          semanticLabel: 'More',
          size: CharcoalIconButtonSize.small,
          statesController: states,
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(container.constraints!.maxWidth, 32);
    expect(decoration.color, theme.colors.containerPressA);

    final iconTheme = tester.widget<IconTheme>(
      find.ancestor(of: find.byKey(const Key('icon')), matching: find.byType(IconTheme)).first,
    );
    expect(iconTheme.data.size, 24);
    expect(iconTheme.data.color, theme.colors.iconTertiaryPress);
  });

  testWidgets('loading spinner uses source defaults and exposes a live-region label', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(const CharcoalLoadingSpinner(once: true), theme: theme),
    );

    final semantics = tester.getSemantics(find.bySemanticsLabel('Loading'));
    expect(semantics.role, SemanticsRole.loadingSpinner);
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
    final square = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .firstWhere(
          (widget) => widget.width == 48,
        );
    expect(square.height, 48);

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
    expect(surface.borderRadius, BorderRadius.circular(8));
    expect(surface.boxShadow!.single.blurRadius, 8);
    expect(surface.boxShadow!.single.color, const Color(0x1A000000));
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
}
