import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

void main() {
  testWidgets('dragging reports values inside the range', (tester) async {
    var value = 0.0;
    late StateSetter setState;
    await pumpLoose(
      tester,
      SizedBox(
        width: 300,
        child: StatefulBuilder(
          builder: (context, update) {
            setState = update;
            return CharcoalSlider(value: value, onChanged: (v) => setState(() => value = v));
          },
        ),
      ),
    );
    await tester.drag(find.byType(Slider), const Offset(30, 0));
    await tester.pump();
    expect(value, inInclusiveRange(0.4, 0.8));
  });

  testWidgets('divisions snap and a null callback disables', (tester) async {
    double? reported;
    await pumpLoose(
      tester,
      SizedBox(
        width: 300,
        child: CharcoalSlider(value: 0, max: 10, divisions: 10, onChanged: (v) => reported = v),
      ),
    );
    await tester.tap(find.byType(Slider));
    await tester.pump();
    expect(reported, isNotNull);
    expect(reported! % 1, 0);

    await pumpLoose(
      tester,
      const SizedBox(width: 300, child: CharcoalSlider(value: 0.5, onChanged: null)),
    );
    expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
  });
}
