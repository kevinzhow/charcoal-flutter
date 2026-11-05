import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart' show InputDecoration, TextField;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

/// Records why Charcoal keeps its own editable text (`CharcoalEditableText` + Charcoal toolbar)
/// instead of wrapping Material's `TextField`.
///
/// The decision criterion (batch 2B) is whether a Material `TextField`, configured only through
/// the theme's `InputDecorationTheme` (what `buildCharcoalThemeData` installs), reproduces the
/// baseline geometry: the 8px horizontal / 10px vertical padding, the external 4px focus ring and
/// the counter inside the field. Each assertion below is one measured difference; if a Material
/// release ever closes them, the wrap option can be revisited.
void main() {
  final pack = charcoalLightPack;
  const key = ValueKey<String>('field');

  testWidgets('Material TextField differs from the baseline in padding, ring and counter', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 320,
          child: TextField(
            key: key,
            maxLength: 10,
            decoration: InputDecoration(hintText: 'x'),
          ),
        ),
      ),
    );
    final materialBox = tester.getRect(find.byKey(key));
    final materialText = tester.getRect(find.byType(EditableText));
    final materialInset = materialText.left - materialBox.left;

    // 1. Padding: Material measures 16 from the box edge to the text (12 contentPadding plus the
    // 4px focus border width it reserves); the baseline is 8. A 2px tolerance would already be a
    // visible shift, and the gap is 8.
    expect(materialInset, closeTo(16, 0.01));
    expect(materialInset - pack.space.sm, greaterThan(pack.borders.focusHalo));

    // 2. Counter: Material puts the counter below the box (outside the fill), the baseline keeps
    // it inside the field next to the text.
    final counter = tester.getRect(find.text('0/10'));
    expect(counter.top, greaterThanOrEqualTo(materialBox.top + pack.sizes.fieldHeight - 0.01));
    expect(materialBox.height, greaterThan(pack.sizes.fieldHeight));

    // 3. Ring: the focused border is drawn inside the box; focusing must not change the box, so
    // there is no external halo to compare with the baseline's 4px outside ring.
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(key)), materialBox);
  });

  testWidgets('CharcoalTextField matches the baseline geometry', (tester) async {
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 320,
          child: CharcoalTextField(key: key, maxLength: 10, showCount: true, placeholder: 'x'),
        ),
      ),
    );
    final box = tester.getRect(find.byType(AnimatedContainer));
    final text = tester.getRect(find.byType(EditableText));
    expect(text.left - box.left, pack.space.sm);
    expect(text.left - box.left, 8);
    expect(box.height, pack.metrics.textField.verticalPadding * 2 + 22);
    final counter = tester.getRect(find.text('0/10'));
    expect(counter.bottom, lessThanOrEqualTo(box.bottom));
    expect(counter.right, lessThanOrEqualTo(box.right - pack.space.sm + 0.01));

    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(AnimatedContainer)), box);
  });
}
