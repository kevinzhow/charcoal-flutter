import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('preserves all metadata at compact width and 2x text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 180,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: CharcoalFieldLabel(
              label: 'Project description',
              required: true,
              requiredText: 'Required',
              subLabel: Text('0/500'),
            ),
          ),
        ),
      ),
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

  testWidgets('keeps required and sub-label content on directional trailing edges', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
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

  testWidgets('keeps the compact row when scaled text still has room', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 640,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: CharcoalFieldLabel(
              label: 'Name',
              required: true,
              requiredText: 'Required',
              subLabel: Text('Public'),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.text('Name')).dy,
      tester.getTopLeft(find.text('Required')).dy,
    );
    expect(
      tester.getCenter(find.text('Public')).dy,
      closeTo(tester.getCenter(find.text('Name')).dy, 0.01),
    );
    expect(tester.takeException(), isNull);
  });
}
