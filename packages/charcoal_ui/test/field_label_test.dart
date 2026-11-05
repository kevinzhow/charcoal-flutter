import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('preserves all metadata at compact width and 2x text scaling', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 180,
          child: CharcoalFieldLabel(
            label: 'Project description',
            required: true,
            requiredText: 'Required',
            subLabel: Text('0/500'),
          ),
        ),
      ),
      textScale: 2,
    );

    expect(find.text('Project description'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    expect(find.text('0/500'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('Required')).dy,
      greaterThan(tester.getTopLeft(find.text('Project description')).dy),
    );
    expect(
      tester.getTopLeft(find.text('0/500')).dy,
      greaterThan(tester.getBottomLeft(find.text('Required')).dy),
    );
  });

  testWidgets('keeps required and sub-label content on directional trailing edges', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 360,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: CharcoalFieldLabel(
              label: 'Description',
              required: true,
              requiredText: 'Required',
              subLabel: Text('0/500'),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Description')).dx,
      greaterThan(tester.getCenter(find.text('Required')).dx),
    );
    expect(
      tester.getCenter(find.text('Required')).dx,
      greaterThan(tester.getCenter(find.text('0/500')).dx),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the row when scaled text still has room', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 640,
          child: CharcoalFieldLabel(
            label: 'Name',
            required: true,
            requiredText: 'Required',
            subLabel: Text('Public'),
          ),
        ),
      ),
      textScale: 2,
    );

    expect(tester.getTopLeft(find.text('Name')).dy, tester.getTopLeft(find.text('Required')).dy);
    expect(
      tester.getCenter(find.text('Public')).dy,
      closeTo(tester.getCenter(find.text('Name')).dy, 0.01),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the compact breakpoint and weight come from the pack', (tester) async {
    final pack = charcoalLightPack.copyWith(
      metrics: charcoalLightPack.metrics.copyWith(
        field: charcoalLightPack.metrics.field.copyWith(compactBreakpoint: 500),
      ),
    );
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 400,
          child: CharcoalFieldLabel(label: 'Name', required: true, requiredText: 'Required'),
        ),
      ),
      pack: pack,
    );
    // Below the (custom) breakpoint the marker wraps under the label only when it cannot share a
    // row; with room it stays on the label's line, so the breakpoint is observable through the
    // layout class: a compact label is a Column.
    expect(
      find.descendant(of: find.byType(CharcoalFieldLabel), matching: find.byType(Column)),
      findsOneWidget,
    );
    final bold = tester.widget<Text>(find.text('Name')).style!;
    expect(bold.fontWeight, pack.typography.weightBold);
  });
}
