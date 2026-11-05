import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';
import 'support/harness.dart';

void main() {
  group('avatar', () {
    testWidgets('shows the upper-case first grapheme, or a question mark', (tester) async {
      await pumpLoose(
        tester,
        const Column(
          children: [
            CharcoalAvatar('  alice'),
            CharcoalAvatar(''),
            CharcoalAvatar('\u{1F468}‍\u{1F469}x'),
          ],
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('?'), findsOneWidget);
      expect(find.text('\u{1F468}‍\u{1F469}'), findsOneWidget);
    });

    testWidgets('has the sizes and shape of the pack', (tester) async {
      await pumpLoose(
        tester,
        const Row(
          children: [
            CharcoalAvatar('a', size: CharcoalAvatarSize.small, circular: true),
            CharcoalAvatar('b'),
            CharcoalAvatar('c', size: CharcoalAvatarSize.large),
          ],
        ),
      );
      final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalAvatar).first));
      expect(
        [
          for (final a in tester.widgetList(find.byType(CharcoalAvatar)))
            tester.getSize(find.byWidget(a)).width,
        ],
        [theme.sizes.avatarSm, theme.sizes.avatar, theme.sizes.avatarLg],
      );
      final circle = tester.widget<Container>(
        find.descendant(of: find.byType(CharcoalAvatar).first, matching: find.byType(Container)),
      );
      expect(
        (circle.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(theme.radius.pill),
      );
    });
  });

  testWidgets('card fills with the secondary background, or outlines', (tester) async {
    await pumpLoose(
      tester,
      const Column(
        children: [
          CharcoalCard(key: ValueKey('fill'), child: Text('a')),
          CharcoalCard(key: ValueKey('line'), outlined: true, child: Text('b')),
        ],
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.text('a')));
    BoxDecoration decoration(String key) =>
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byKey(ValueKey(key)),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    expect(decoration('fill').color, theme.colors.backgroundSecondary);
    expect(decoration('fill').border, isNull);
    expect(decoration('line').color, isNull);
    expect(decoration('line').border, isNotNull);
    expect(
      tester.getSize(find.byKey(const ValueKey('fill'))).height,
      tester.getSize(find.text('a')).height + 2 * theme.space.lg,
    );
  });

  testWidgets('section header puts the action at the end and the caption beside the title', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalSectionHeader(
          'Users',
          caption: '12 total',
          action: CharcoalButton(onPressed: () {}, child: const Text('Add')),
        ),
      ),
      size: const Size(500, 300),
    );
    expect(
      tester.getRect(find.text('12 total')).left,
      greaterThan(tester.getRect(find.text('Users')).right),
    );
    expect(tester.getRect(find.text('Add')).right, lessThan(501));
    expect(tester.getRect(find.byType(CharcoalButton)).right, 500);
  });

  group('info rows', () {
    testWidgets('lay labels in one column and values beside them', (tester) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: CharcoalInfoRows([('Email', 'alice@a.co'), ('Plan', 'Pro')]),
        ),
        size: const Size(500, 300),
      );
      final theme = CharcoalTheme.of(tester.element(find.text('Email')));
      expect(tester.getRect(find.text('Email')).left, tester.getRect(find.text('Plan')).left);
      expect(
        tester.getRect(find.text('alice@a.co')).left,
        tester.getRect(find.text('Email')).left + theme.sizes.infoLabelWidth + theme.space.lg,
      );
      expect(tester.getRect(find.text('alice@a.co')).left, tester.getRect(find.text('Pro')).left);
    });

    testWidgets('label width variants map to the pack sizes', (tester) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: CharcoalInfoRows([('K', 'v')], labelWidth: CharcoalInfoLabelWidth.wide),
        ),
        size: const Size(500, 300),
      );
      final theme = CharcoalTheme.of(tester.element(find.text('K')));
      expect(
        tester.getRect(find.text('v')).left,
        theme.sizes.infoLabelWidthWide + theme.space.lg,
      );
    });
  });

  testWidgets('stat card shows label, status, value, footnote and action', (tester) async {
    await pumpLoose(
      tester,
      SizedBox(
        width: 240,
        child: CharcoalStatCard(
          label: 'Revenue',
          value: r'$1,200',
          status: 'Up',
          statusTone: CharcoalTone.positive,
          footnote: 'vs last month',
          action: CharcoalLinkButton(onPressed: () {}, child: const Text('Details')),
        ),
      ),
    );
    for (final text in ['Revenue', r'$1,200', 'Up', 'vs last month', 'Details']) {
      expect(find.text(text), findsOneWidget);
    }
    final theme = CharcoalTheme.of(tester.element(find.text('Up')));
    expect(
      tester.widget<Text>(find.text('Up')).style!.color,
      theme.tone(CharcoalTone.positive).foreground,
    );
  });

  group('meter', () {
    Future<double> fillWidth(WidgetTester tester, double fraction) async {
      await pumpLoose(
        tester,
        SizedBox(
          width: 300,
          child: CharcoalMeter(label: 'Storage', value: '1 / 2 GB', fraction: fraction),
        ),
      );
      return tester.getSize(find.byType(FractionallySizedBox)).width;
    }

    testWidgets('clamps the fraction to the track', (tester) async {
      final half = await fillWidth(tester, 0.5);
      expect(await fillWidth(tester, 2), 2 * half);
      expect(await fillWidth(tester, -1), 0);
      expect(await fillWidth(tester, double.nan), 0);
    });

    testWidgets('announces label, value and percentage', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLoose(
        tester,
        const SizedBox(
          width: 300,
          child: CharcoalMeter(label: 'Storage', value: '1 / 2 GB', fraction: 0.5),
        ),
      );
      expect(
        tester.getSemantics(find.byType(CharcoalMeter)),
        matchesSemantics(label: 'Storage', value: '1 / 2 GB, 50%'),
      );
      handle.dispose();
    });
  });

  group('batch bar', () {
    Future<void> pumpBar(
      WidgetTester tester, {
      required bool selecting,
      int count = 0,
      VoidCallback? onDelete,
      VoidCallback? onToggle,
    }) => pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalBatchBar(
          selectionMode: selecting,
          selectedCount: count,
          restLabel: '3 notices',
          onDelete: onDelete ?? () {},
          onToggleMode: onToggle ?? () {},
          restActions: [CharcoalButton(onPressed: () {}, child: const Text('New'))],
        ),
      ),
      size: const Size(600, 200),
    );

    testWidgets('shows the row count and actions at rest', (tester) async {
      var toggles = 0;
      await pumpBar(tester, selecting: false, onToggle: () => toggles++);
      expect(find.text('3 notices'), findsOneWidget);
      expect(find.text('New'), findsOneWidget);
      await tester.tap(find.text('Select'));
      expect(toggles, 1);
    });

    testWidgets('disables delete until something is ticked', (tester) async {
      var deletes = 0;
      await pumpBar(tester, selecting: true, onDelete: () => deletes++);
      expect(find.text('0 selected'), findsOneWidget);
      expect(find.text('New'), findsNothing);
      await tester.tap(find.text('Delete selected'), warnIfMissed: false);
      expect(deletes, 0);
      await pumpBar(tester, selecting: true, count: 2, onDelete: () => deletes++);
      expect(find.text('2 selected'), findsOneWidget);
      await tester.tap(find.text('Delete selected'));
      expect(deletes, 1);
    });

    testWidgets('the selection mixin toggles, retains and exits', (tester) async {
      await pumpLoose(tester, const _SelectionHost());
      final state = tester.state<_SelectionHostState>(find.byType(_SelectionHost));
      expect(state.selectionMode, isFalse);
      state.toggleSelectionMode();
      state.toggleSelected('a');
      state.toggleSelected('b');
      expect(state.selectedIds, {'a', 'b'});
      expect(state.isSelected('a'), isTrue);
      state.toggleSelected('a');
      expect(state.hasSelection, isTrue);
      state.retainSelected(['c']);
      expect(state.hasSelection, isFalse);
      state.exitSelectionMode();
      expect(state.selectionMode, isFalse);
    });
  });

  group('compact pagination', () {
    testWidgets('shows the position and disables the buttons at the ends', (tester) async {
      int? requested;
      await pumpLoose(
        tester,
        CharcoalPagination.compact(
          currentPage: 1,
          pageCount: 5,
          onPageChanged: (p) => requested = p,
        ),
      );
      expect(find.text('1 / 5'), findsOneWidget);
      expect(find.byType(CharcoalIcon), findsNWidgets(2));
      final iconButtons = tester
          .widgetList<CharcoalIconButton>(find.byType(CharcoalIconButton))
          .toList();
      expect(iconButtons.first.onPressed, isNull);
      expect(iconButtons.last.onPressed, isNotNull);
      await tester.tap(find.byType(CharcoalIconButton).last);
      expect(requested, 2);
    });
  });

  group('sidebar and shell', () {
    Widget shell({VoidCallback? onSelect}) => CharcoalAdminShell(
      sidebar: CharcoalSidebar(
        brand: const CharcoalSidebarBrand(mark: 'M', title: 'Console'),
        footer: const Text('account'),
        children: [
          CharcoalSidebarGroup(
            children: [
              CharcoalNavigationItem(
                variant: CharcoalNavigationItemVariant.sidebar,
                selected: true,
                leading: const CharcoalIcon(CharcoalIcons.home),
                onPressed: onSelect ?? () {},
                child: const Text('Home'),
              ),
            ],
          ),
          const CharcoalSidebarGroup(title: 'Ops', children: [Text('Logs')]),
        ],
      ),
      bottomBar: CharcoalTabBar<String>(
        items: const [
          CharcoalTabItem(icon: CharcoalIcon(CharcoalIcons.home), label: 'Tab home', value: 'h'),
          CharcoalTabItem(icon: CharcoalIcon(CharcoalIcons.message), label: 'Tab more', value: 'm'),
        ],
        value: 'h',
        onChanged: (_) {},
      ),
      body: const Center(child: Text('Body', key: ValueKey('body'))),
    );

    testWidgets('wide: sidebar of the pack width beside the body', (tester) async {
      await pumpCharcoal(tester, shell(), size: const Size(1280, 800));
      final theme = CharcoalTheme.of(tester.element(find.text('Body')));
      expect(tester.getSize(find.byType(CharcoalSidebar)).width, theme.sizes.sidebarWidth);
      expect(tester.getRect(find.byType(CharcoalSidebar)).height, 800);
      expect(find.text('Tab home'), findsNothing);
      expect(
        tester.getRect(find.byKey(const ValueKey('body'))).center.dx,
        greaterThan(theme.sizes.sidebarWidth),
      );
      expect(find.text('Console'), findsOneWidget);
      expect(find.text('Ops'), findsOneWidget);
      expect(find.text('account'), findsOneWidget);
    });

    testWidgets('narrow: body above the bottom tab bar, state kept across the switch', (
      tester,
    ) async {
      await pumpCharcoal(tester, shell(), size: const Size(420, 800));
      expect(find.byType(CharcoalSidebar), findsNothing);
      expect(find.text('Tab home'), findsOneWidget);
      expect(tester.getRect(find.byType(CharcoalTabBar<String>)).bottom, 800);
      expect(tester.getRect(find.byKey(const ValueKey('body'))).center.dy, lessThan(400));
    });

    testWidgets('sidebar scrolls when its groups exceed the height', (tester) async {
      await pumpCharcoal(
        tester,
        CharcoalAdminShell(
          sidebar: CharcoalSidebar(
            brand: const CharcoalSidebarBrand(mark: 'M', title: 'Console'),
            children: [
              CharcoalSidebarGroup(children: [for (var i = 0; i < 30; i++) Text('Item $i')]),
            ],
          ),
          body: const SizedBox.expand(),
        ),
        size: const Size(1200, 400),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}

final class _SelectionHost extends StatefulWidget {
  const _SelectionHost();

  @override
  State<_SelectionHost> createState() => _SelectionHostState();
}

final class _SelectionHostState extends State<_SelectionHost>
    with CharcoalBatchSelection<_SelectionHost> {
  @override
  Widget build(BuildContext context) => const SizedBox();
}
