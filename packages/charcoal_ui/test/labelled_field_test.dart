import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

// CharcoalFormField is the one labelled-field wrapper: every control framed by it gets the label
// row, the required or optional marker, the help line and the error line of a text field with a
// visible label.

const _label = 'Visibility';
const _optional = '(optional)';
const _required = '*Required';
const _help = 'Who can read the value';

/// The controls that have no label row of their own, each with a key on the control itself.
Map<String, Widget> _controls() {
  void noop(Object? _) {}
  return <String, Widget>{
    'switch': CharcoalSwitch(key: const Key('control'), value: true, onChanged: noop),
    'radio group': Column(
      key: const Key('control'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final value in ['server', 'client'])
          CharcoalRadio<String>(
            value: value,
            groupValue: 'server',
            onChanged: noop,
            label: Text(value),
          ),
      ],
    ),
    'checkbox group': Column(
      key: const Key('control'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final value in ['iOS', 'Android'])
          CharcoalCheckbox(value: value == 'iOS', onChanged: noop, label: Text(value)),
      ],
    ),
    'segmented control': CharcoalSegmentedControl<String>(
      key: const Key('control'),
      value: 'server',
      onChanged: noop,
      segments: const [
        CharcoalSegment(value: 'server', child: Text('Server')),
        CharcoalSegment(value: 'client', child: Text('Client')),
      ],
    ),
  };
}

/// The rectangles of one labelled field, relative to the field's top left.
typedef _Geometry = ({Rect label, Rect marker, Rect control, Rect assistive});

_Geometry _measure(WidgetTester tester, Key field, Finder control, String marker) {
  final origin = tester.getTopLeft(find.byKey(field));
  Rect at(Finder finder) => tester.getRect(finder).shift(-origin);
  Finder inField(Finder finder) => find.descendant(of: find.byKey(field), matching: finder);
  return (
    label: at(inField(find.text(_label))),
    marker: at(inField(find.text(marker))),
    control: at(inField(control)),
    assistive: at(inField(find.text(_help))),
  );
}

Future<void> _mount(
  WidgetTester tester,
  Widget control, {
  required bool required,
  bool invalid = false,
}) {
  return pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 480,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CharcoalTextField(
              key: const Key('text'),
              label: _label,
              showLabel: true,
              assistiveText: _help,
              invalid: invalid,
              optionalText: required ? null : _optional,
              required: required,
              requiredText: _required,
            ),
            CharcoalFormField(
              key: const Key('framed'),
              label: _label,
              assistiveText: _help,
              invalid: invalid,
              optionalText: required ? null : _optional,
              required: required,
              requiredText: _required,
              child: control,
            ),
          ],
        ),
      ),
    ),
    size: const Size(600, 600),
  );
}

void main() {
  for (final MapEntry(key: name, value: control) in _controls().entries) {
    for (final required in [false, true]) {
      final marker = required ? _required : _optional;
      testWidgets('a $name in CharcoalFormField lines up with a text field ($marker)', (
        tester,
      ) async {
        await _mount(tester, control, required: required);
        final theme = CharcoalTheme.of(tester.element(find.byKey(const Key('framed'))));
        final gap = theme.space.sm;

        final text = _measure(
          tester,
          const Key('text'),
          find.byType(CharcoalFieldRing),
          marker,
        );
        final framed = _measure(
          tester,
          const Key('framed'),
          find.byKey(const Key('control')),
          marker,
        );

        expect(framed.label, text.label, reason: 'label row');
        expect(framed.marker, text.marker, reason: 'marker after the label');
        expect(framed.marker.left - framed.label.right, theme.space.xs);
        expect(framed.marker.bottom, framed.label.bottom, reason: 'one line with the label');
        expect(framed.control.top, text.control.top, reason: 'control below the label row');
        expect(framed.control.top - framed.label.bottom, gap);
        expect(framed.assistive.top - framed.control.bottom, gap, reason: 'help below');
        expect(framed.assistive.left, text.assistive.left);
      });
    }
  }

  testWidgets('the optional marker is tertiary text and the error replaces the help colour', (
    tester,
  ) async {
    await _mount(tester, _controls()['switch']!, required: false, invalid: true);
    final colors = CharcoalTheme.of(tester.element(find.byKey(const Key('framed')))).colors;
    Color? colorOf(Key field, String text) => tester
        .widget<Text>(find.descendant(of: find.byKey(field), matching: find.text(text)))
        .style
        ?.color;
    for (final field in [const Key('text'), const Key('framed')]) {
      expect(colorOf(field, _optional), colors.textTertiary);
      expect(colorOf(field, _help), colors.textNegative);
      expect(find.descendant(of: find.byKey(field), matching: find.text(_required)), findsNothing);
    }
  });

  testWidgets('text area and dropdown show the optional marker in the same label row', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      Column(
        children: [
          const CharcoalTextArea(label: 'Description', showLabel: true, optionalText: '(optional)'),
          CharcoalDropdown<String>(
            label: 'Region',
            showLabel: true,
            optionalText: '(optional)',
            value: 'eu',
            onChanged: (_) {},
            options: const [CharcoalDropdownOption(value: 'eu', label: 'EU')],
          ),
        ],
      ),
    );
    for (final label in ['Description', 'Region']) {
      final markers = find.descendant(
        of: find.ancestor(of: find.text(label), matching: find.byType(CharcoalFieldLabel)),
        matching: find.text('(optional)'),
      );
      expect(markers, findsOneWidget);
      expect(tester.getBottomLeft(markers).dy, tester.getBottomLeft(find.text(label)).dy);
    }
  });

  test('a field is required or optional, not both', () {
    expect(
      () => CharcoalFormField(
        label: _label,
        required: true,
        optionalText: _optional,
        child: const SizedBox(),
      ),
      throwsAssertionError,
    );
  });
}
