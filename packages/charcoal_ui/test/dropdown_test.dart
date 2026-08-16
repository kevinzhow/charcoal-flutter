import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  const options = <CharcoalDropdownOption<String>>[
    CharcoalDropdownOption<String>(value: 'illustration', label: 'Illustration'),
    CharcoalDropdownOption<String>(
      value: 'manga',
      label: 'Manga',
      secondary: 'Multiple pages',
    ),
    CharcoalDropdownOption<String>(value: 'novel', label: 'Novel'),
  ];

  testWidgets('semantic color overrides flow into the dropdown surface', (tester) async {
    const replacement = Color(0xFF9C27B0);
    final colors = CharcoalGeneratedColorTokens.light.copyWith(
      containerSecondaryDefaultA: replacement,
    );
    final theme = CharcoalThemeData.light(colors: colors);

    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            onChanged: _ignoreString,
            options: options,
            placeholder: 'Choose a type',
            value: null,
          ),
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    expect((container.decoration! as BoxDecoration).color, replacement);
  });

  testWidgets('opens an anchored menu and selects a value', (tester) async {
    String? selected;
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 320,
            child: CharcoalDropdown<String>(
              label: 'Work type',
              onChanged: (value) => setState(() => selected = value),
              options: options,
              placeholder: 'Choose a type',
              value: selected,
            ),
          ),
        ),
        theme: theme,
      ),
    );

    await tester.tap(find.text('Choose a type'));
    await tester.pump();
    expect(find.text('Illustration'), findsOneWidget);
    expect(find.text('Multiple pages'), findsOneWidget);
    final menuDecoration = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .singleWhere((decoration) {
          final border = decoration.border;
          return border is Border && border.top.color == theme.colors.borderSecondary;
        });
    final menuBorder = menuDecoration.border! as Border;
    expect(menuBorder.top.width, theme.dimensions.borderWidth.m);

    await tester.tap(find.text('Manga'));
    await tester.pump();
    expect(selected, 'manga');
    expect(find.text('Illustration'), findsNothing);
    expect(find.text('Manga'), findsOneWidget);
  });

  testWidgets('keyboard navigation skips disabled options', (tester) async {
    String? selected;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            focusNode: focusNode,
            onChanged: (value) => selected = value,
            options: const <CharcoalDropdownOption<String>>[
              CharcoalDropdownOption<String>(value: 'disabled', label: 'Disabled', enabled: false),
              CharcoalDropdownOption<String>(value: 'first', label: 'First'),
              CharcoalDropdownOption<String>(value: 'second', label: 'Second'),
            ],
            placeholder: 'Choose',
            value: null,
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('Disabled'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(selected, 'second');
    expect(find.text('Disabled'), findsNothing);
  });

  testWidgets('reports value, validation, and expansion semantics', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            invalid: true,
            label: 'Work type',
            onChanged: _ignoreString,
            options: options,
            value: 'illustration',
          ),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalClickable)),
      matchesSemantics(
        label: 'Work type',
        value: 'Illustration',
        validationResult: SemanticsValidationResult.invalid,
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('outside tap dismisses the menu', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 320,
            child: CharcoalDropdown<String>(
              onChanged: _ignoreString,
              options: options,
              placeholder: 'Choose',
              value: null,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(find.text('Illustration'), findsOneWidget);

    await tester.tapAt(const Offset(4, 590));
    await tester.pump();
    expect(find.text('Illustration'), findsNothing);
  });

  testWidgets('keeps an upward-opening menu compact and visible on mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      charcoalTestApp(
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: SizedBox(
              width: 320,
              child: CharcoalDropdown<String>(
                label: 'Work type',
                onChanged: _ignoreString,
                options: options,
                placeholder: 'Choose',
                value: null,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();

    final menuRect = tester.getRect(find.byType(SingleChildScrollView));
    expect(menuRect.width, 320);
    expect(menuRect.height, lessThanOrEqualTo(280));
    expect(menuRect.top, greaterThanOrEqualTo(0));
    expect(menuRect.bottom, lessThan(820));
    for (final label in <String>['Illustration', 'Manga', 'Novel']) {
      expect(tester.getRect(find.text(label)).overlaps(menuRect), isTrue);
    }
  });
}

void _ignoreString(String value) {}
