import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('preserves full semantics while compact RTL copy is truncated', (
    tester,
  ) async {
    const spokenLabel = 'Complete project title: Moonlit Garden Archive';
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 120,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CharcoalTextEllipsis(
                'Moonlit Garden Archive for the Northern Collection',
                maxLines: 2,
                semanticLabel: spokenLabel,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(
      find.text('Moonlit Garden Archive for the Northern Collection'),
    );
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.softWrap, isTrue);
    expect(text.textAlign, TextAlign.start);
    expect(find.semantics.byLabel(spokenLabel), findsOne);
    expect(tester.takeException(), isNull);
  });

  test('rejects invalid line counts and empty semantic overrides', () {
    expect(
      () => CharcoalTextEllipsis('Invalid', maxLines: 0),
      throwsAssertionError,
    );
    expect(
      () => CharcoalTextEllipsis('Hidden from speech', semanticLabel: ''),
      throwsAssertionError,
    );
  });
}
