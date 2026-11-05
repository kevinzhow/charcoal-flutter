import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('centres the title between equal edge slots', (tester) async {
    const titleKey = ValueKey<String>('title');
    await pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalNavigationBar(
          title: const Text('Settings', key: titleKey),
          leading: CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons.add),
            onPressed: () {},
            semanticLabel: 'Back',
          ),
        ),
      ),
      size: const Size(400, 600),
    );
    expect(tester.getCenter(find.byKey(titleKey)).dx, moreOrLessEquals(200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reports its height and grows with text scale', (tester) async {
    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: CharcoalNavigationBar(title: Text('Title')),
      ),
      size: const Size(400, 600),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalNavigationBar)));
    final bar = tester.widget<CharcoalNavigationBar>(find.byType(CharcoalNavigationBar));
    expect(
      tester.getSize(find.byType(CharcoalNavigationBar)).height,
      theme.metrics.navigationBar.height,
    );
    expect(bar.preferredSize.height, theme.metrics.navigationBar.height);

    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: CharcoalNavigationBar(title: Text('Title')),
      ),
      size: const Size(400, 600),
      textScale: 3,
    );
    expect(
      tester.getSize(find.byType(CharcoalNavigationBar)).height,
      greaterThan(theme.metrics.navigationBar.height),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('drives the scaffold top inset through its contextual height', (tester) async {
    await pumpCharcoal(
      tester,
      const CharcoalScaffold(
        navigationBar: CharcoalNavigationBar(title: Text('Title')),
        body: SizedBox.expand(key: ValueKey<String>('body')),
      ),
      size: const Size(400, 600),
      textScale: 3,
    );
    final bar = tester.getRect(find.byType(CharcoalNavigationBar));
    final body = tester.getRect(find.byKey(const ValueKey<String>('body')));
    expect(body.top, moreOrLessEquals(bar.bottom));
  });

  testWidgets('exposes the title as a header and the bar as a labelled region', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: CharcoalNavigationBar(title: Text('Inbox'), semanticLabel: 'Page bar'),
      ),
    );
    expect(find.bySemanticsLabel('Page bar'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Inbox')),
      matchesSemantics(label: 'Inbox', isHeader: true),
    );
    handle.dispose();
  });
}
