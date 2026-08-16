import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('segmented control reports selection and uses selected semantic colors', (
    tester,
  ) async {
    String? nextValue;
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalSegmentedControl<String>(
          value: 'grid',
          onChanged: (value) => nextValue = value,
          segments: const <CharcoalSegment<String>>[
            CharcoalSegment<String>(value: 'grid', child: Text('Grid')),
            CharcoalSegment<String>(value: 'list', child: Text('List')),
          ],
        ),
        theme: theme,
      ),
    );

    final selectedContainer = tester.widget<Container>(
      find.ancestor(of: find.text('Grid'), matching: find.byType(Container)).first,
    );
    expect(
      (selectedContainer.decoration! as BoxDecoration).color,
      theme.colors.containerPrimaryDefault,
    );
    expect(selectedContainer.constraints!.maxHeight, 32);
    expect(selectedContainer.padding, const EdgeInsets.symmetric(horizontal: 16));
    final selectedTextStyle = tester
        .widget<DefaultTextStyle>(
          find
              .ancestor(
                of: find.text('Grid'),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;
    expect(selectedTextStyle.fontSize, 14);
    expect(selectedTextStyle.height, 22 / 14);

    await tester.tap(find.text('List'));
    expect(nextValue, 'list');
  });

  testWidgets('hint text consumes semantic container and text tokens', (tester) async {
    final theme = CharcoalThemeData.dark();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalHintText(child: Text('Helpful information')),
        ),
        theme: theme,
      ),
    );

    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).first);
    expect((box.decoration as BoxDecoration).color, theme.colors.containerSecondaryDefault);
    final text = tester.widget<Text>(find.text('Helpful information'));
    expect(text.style, isNull, reason: 'The semantic style is inherited through DefaultTextStyle.');
  });

  testWidgets('showCharcoalDialog presents and dismisses a token-driven route', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) => CharcoalButton(
            onPressed: () => showCharcoalDialog<void>(
              context: context,
              builder: (context) => CharcoalDialog(
                title: 'Delete illustration?',
                actions: <Widget>[
                  CharcoalButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
                child: const Text('This action cannot be undone.'),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Delete illustration?'), findsOneWidget);
    expect(find.text('This action cannot be undone.'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Delete illustration?'), findsNothing);
  });

  testWidgets('bottom-sheet modal aligns to the bottom and exposes a close button', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        Builder(
          builder: (context) => CharcoalButton(
            onPressed: () => showCharcoalDialog<void>(
              context: context,
              style: CharcoalModalStyle.bottomSheet,
              builder: (dialogContext) => CharcoalDialog(
                onDismiss: () => Navigator.of(dialogContext).pop(),
                showCloseButton: true,
                style: CharcoalModalStyle.bottomSheet,
                title: 'Bottom sheet',
                child: const SizedBox(height: 80),
              ),
            ),
            child: const Text('Open sheet'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    final dialogRect = tester.getRect(find.byType(CharcoalDialog));
    expect(dialogRect.bottom, tester.view.physicalSize.height / tester.view.devicePixelRatio);
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
  });

  testWidgets('iOS typography family supports monospace and text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: CharcoalTypography(
            monospace: true,
            size: CharcoalTypographySize.size12,
            child: Text('012345'),
          ),
        ),
      ),
    );

    final typography = tester.widget<DefaultTextStyle>(
      find.byType(DefaultTextStyle).last,
    );
    final style = typography.style;
    expect(style.fontFamily, 'monospace');
    expect(typography.maxLines, 1);
    expect(MediaQuery.textScalerOf(tester.element(find.text('012345'))).scale(12), 18);
  });

  testWidgets('text ellipsis configures the underlying Text', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 40,
          child: CharcoalTextEllipsis('A long piece of text', maxLines: 2),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('A long piece of text'));
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
  });
}
