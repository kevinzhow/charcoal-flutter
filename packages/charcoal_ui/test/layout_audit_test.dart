import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/scenes.dart';

/// A layout sweep over every registered scene at both layout classes and four text scales.
///
/// Overflow and the Material text fallback are the failures that show up as "the layout is wrong",
/// and both are assertable without a screen: a RenderFlex overflow is reported as an exception,
/// and `MaterialApp`'s fallback style (48px, yellow double underline) shows up as an underlined
/// `DefaultTextStyle`.
void main() {
  const layouts = <String, Size>{'compact': Size(420, 900), 'standard': Size(1280, 900)};
  const scales = <double>[0.8, 1.0, 2.0, 3.0];

  for (final scene in charcoalScenes) {
    for (final layout in layouts.entries) {
      for (final scale in scales) {
        testWidgets('${scene.name} lays out at ${layout.key}, text x$scale', (tester) async {
          await pumpCharcoal(
            tester,
            Builder(builder: scene.build),
            size: layout.value,
            textScale: scale,
          );
          expect(tester.takeException(), isNull, reason: '${scene.name} overflows');
          for (final element in find.byType(Text).evaluate()) {
            expect(
              DefaultTextStyle.of(element).style.decoration,
              isNot(TextDecoration.underline),
              reason: '${scene.name} has fallback-styled text',
            );
          }
        });
      }
    }
  }

  testWidgets('the audit detects an overflow', (tester) async {
    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 100,
          child: Row(children: [SizedBox(width: 300, height: 10)]),
        ),
      ),
      size: const Size(420, 900),
    );
    expect(tester.takeException(), isNotNull);
  });

  testWidgets('the audit detects fallback-styled text', (tester) async {
    // Outside CharcoalApp's defaults a MaterialApp-less tree would show the fallback; a bare
    // WidgetsApp-free Text under an explicit underline style stands in for it.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTextStyle(
          style: TextStyle(decoration: TextDecoration.underline),
          child: Text('x'),
        ),
      ),
    );
    final element = find.byType(Text).evaluate().single;
    expect(DefaultTextStyle.of(element).style.decoration, TextDecoration.underline);
  });
}
