import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// Opacity the nearest [AnimatedOpacity] above [finder] is heading to.
double targetOpacity(WidgetTester tester, Finder finder) => tester
    .widget<AnimatedOpacity>(
      find.ancestor(of: finder, matching: find.byType(AnimatedOpacity)).first,
    )
    .opacity;

/// Presses [finder] with a touch and keeps the pointer down; call `up()` on the result.
Future<TestGesture> pressAndHold(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 50));
  return gesture;
}

/// Rects of [finders] in order, for before/after geometry comparisons.
List<Rect> rectsOf(WidgetTester tester, List<Finder> finders) => [
  for (final f in finders) tester.getRect(f),
];

/// Mounts [child] at its natural size in the top-left corner (the harness page gives tight bounds).
Future<void> pumpLoose(
  WidgetTester tester,
  Widget child, {
  double textScale = 1,
  Size? size,
}) => pumpCharcoal(
  tester,
  Align(alignment: Alignment.topLeft, child: child),
  textScale: textScale,
  size: size,
);
