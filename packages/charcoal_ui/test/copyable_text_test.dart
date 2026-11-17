import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

const _id = 'FC055F80-20D8-4DAB-90ED-E62C534D433D';

void main() {
  String? clipboard;
  setUp(() {
    clipboard = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  Future<void> mount(WidgetTester tester, {double width = 600}) => pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        child: const Row(
          children: [
            Flexible(
              child: CharcoalCopyableText(
                text: _id,
                copyLabel: 'Copy ID',
                copiedMessage: 'ID copied',
              ),
            ),
          ],
        ),
      ),
    ),
  );

  testWidgets('the copy button writes the whole text and confirms with a toast', (tester) async {
    await mount(tester);
    expect(find.text('ID copied'), findsNothing);
    await tester.tap(find.bySemanticsLabel('Copy ID'));
    await tester.pump();
    expect(clipboard, _id);
    expect(find.text('ID copied'), findsOneWidget);
    expect(find.byType(CharcoalToast), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });

  testWidgets('the text is selectable, monospace caption, and shortens in a narrow space', (
    tester,
  ) async {
    await mount(tester, width: 160);
    final theme = CharcoalTheme.of(tester.element(find.text(_id)));
    expect(find.ancestor(of: find.text(_id), matching: find.byType(SelectableRegion)), findsOne);
    final text = tester.widget<Text>(find.text(_id));
    expect(text.style, theme.style(CharcoalTextRole.captionMono));
    expect(text.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
    expect(tester.getTopRight(find.byType(CharcoalIconButton)).dx, lessThanOrEqualTo(160));
    await tester.tap(find.bySemanticsLabel('Copy ID'));
    await tester.pump();
    expect(clipboard, _id, reason: 'the full value, not the visible part');
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });
}
