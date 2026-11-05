import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  final pack = charcoalLightPack;
  const options = <CharcoalDropdownOption<String>>[
    CharcoalDropdownOption<String>(value: 'illustration', label: 'Illustration'),
    CharcoalDropdownOption<String>(value: 'manga', label: 'Manga', secondary: 'Multiple pages'),
    CharcoalDropdownOption<String>(value: 'novel', label: 'Novel'),
  ];

  testWidgets('a colour override in the pack flows into the dropdown surface', (tester) async {
    const replacement = Color(0xFF9C27B0);
    final custom = pack.copyWith(colors: pack.colors.copyWith(fillSecondary: replacement));
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            onChanged: _ignoreString,
            options: options,
            placeholder: 'Choose a type',
            value: null,
          ),
        ),
      ),
      pack: custom,
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    expect((container.decoration! as BoxDecoration).color, replacement);
  });

  testWidgets('opens an anchored menu and selects a value', (tester) async {
    String? selected;
    await pumpCharcoal(
      tester,
      Center(
        child: StatefulBuilder(
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
      ),
    );

    await tester.tap(find.text('Choose a type'));
    await tester.pump();
    expect(find.text('Illustration'), findsOneWidget);
    expect(find.text('Multiple pages'), findsOneWidget);
    final menuBorder =
        tester
                .widgetList<DecoratedBox>(find.byType(DecoratedBox))
                .map((widget) => widget.decoration)
                .whereType<BoxDecoration>()
                .singleWhere((decoration) {
                  final border = decoration.border;
                  return border is Border && border.top.color == pack.colors.borderSubtle;
                })
                .border!
            as Border;
    expect(menuBorder.top.width, pack.borders.hairline);

    await tester.tap(find.text('Manga'));
    await tester.pump();
    expect(selected, 'manga');
    expect(find.text('Illustration'), findsNothing);
    expect(find.text('Manga'), findsOneWidget);
  });

  testWidgets('selecting an option commits in the first frame after the tap', (tester) async {
    String? selected;
    await pumpCharcoal(
      tester,
      Center(
        child: StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 320,
            child: CharcoalDropdown<String>(
              onChanged: (value) => setState(() => selected = value),
              options: options,
              placeholder: 'Choose',
              value: selected,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Choose'));
    await tester.pump();
    await tester.tap(find.text('Novel'));
    await tester.pump(); // exactly one frame
    expect(find.text('Novel'), findsOneWidget); // trigger shows the value, menu is gone
    expect(find.text('Illustration'), findsNothing);
    expect(
      tester.getSemantics(find.byType(CharcoalClickable).first),
      matchesSemantics(
        value: 'Novel',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('keyboard navigation skips disabled options', (tester) async {
    String? selected;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpCharcoal(
      tester,
      Center(
        child: SizedBox(
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

  testWidgets('Escape closes the menu and keeps focus on the trigger', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpCharcoal(
      tester,
      Center(
        child: SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            focusNode: focusNode,
            onChanged: _ignoreString,
            options: options,
            placeholder: 'Choose',
            value: null,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(find.text('Illustration'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.text('Illustration'), findsNothing);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('reports value, validation and expansion semantics', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            assistiveText: 'Choose a work type',
            invalid: true,
            label: 'Work type',
            onChanged: _ignoreString,
            options: options,
            required: true,
            value: 'illustration',
          ),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalClickable)),
      matchesSemantics(
        label: 'Work type',
        hint: 'Choose a work type',
        value: 'Illustration',
        validationResult: SemanticsValidationResult.invalid,
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasRequiredState: true,
        isRequired: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('outside tap dismisses the menu', (tester) async {
    await pumpCharcoal(
      tester,
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
    );

    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(find.text('Illustration'), findsOneWidget);

    await tester.tapAt(const Offset(4, 590));
    await tester.pump();
    expect(find.text('Illustration'), findsNothing);
  });

  testWidgets('keeps an upward-opening menu compact and visible on mobile', (tester) async {
    await pumpCharcoal(
      tester,
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
      size: const Size(390, 844),
    );

    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();

    final menuRect = tester.getRect(find.byType(SingleChildScrollView));
    expect(menuRect.width, 320);
    expect(menuRect.height, lessThanOrEqualTo(pack.metrics.dropdown.menuMaxHeight));
    expect(menuRect.top, greaterThanOrEqualTo(0));
    expect(menuRect.bottom, lessThan(820));
    for (final label in <String>['Illustration', 'Manga', 'Novel']) {
      expect(tester.getRect(find.text(label)).overlaps(menuRect), isTrue);
    }
  });

  testWidgets('trigger geometry is stable through focus, press and open', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
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
    );
    final trigger = find.byType(AnimatedContainer).first;
    final rect = tester.getRect(trigger);
    final label = tester.getRect(find.text('Choose'));
    expect(rect.height, pack.sizes.controlMd);
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    expect(tester.getRect(trigger), rect);
    expect(tester.getRect(find.text('Choose')), label);
  });

  testWidgets('lays out at large text scale without overflow', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 320,
          child: CharcoalDropdown<String>(
            label: 'Work type',
            showLabel: true,
            assistiveText: 'Helper',
            onChanged: _ignoreString,
            options: options,
            value: 'manga',
          ),
        ),
      ),
      textScale: 3,
      size: const Size(420, 900),
    );
    expect(tester.takeException(), isNull);
  });
}

void _ignoreString(String value) {}
