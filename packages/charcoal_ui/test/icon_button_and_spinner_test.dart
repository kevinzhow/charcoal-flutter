import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
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

    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
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
}
