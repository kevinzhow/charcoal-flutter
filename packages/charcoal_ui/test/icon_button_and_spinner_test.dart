import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('icon button resolves size and pressed recipe tokens', (tester) async {
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
    expect(container.constraints!.maxWidth, theme.components.iconButton.small.size);
    expect(decoration.color, theme.colors.containerPressA);

    final iconTheme = tester.widget<IconTheme>(
      find.ancestor(of: find.byKey(const Key('icon')), matching: find.byType(IconTheme)).first,
    );
    expect(iconTheme.data.size, theme.components.iconButton.small.iconSize);
    expect(iconTheme.data.color, theme.colors.iconTertiaryPress);
  });

  testWidgets('loading spinner uses recipe defaults and exposes a live-region label', (
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
          (widget) => widget.width == theme.components.loadingSpinner.size,
        );
    expect(square.height, theme.components.loadingSpinner.size);

    await tester.pump(
      Duration(
        microseconds: theme.components.loadingSpinner.animationDuration.inMicroseconds ~/ 2,
      ),
    );
    final animatedOpacity = tester.widgetList<Opacity>(find.byType(Opacity)).last;
    expect(animatedOpacity.opacity, inExclusiveRange(0, 1));
  });
}
