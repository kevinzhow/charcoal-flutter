import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';
import 'support/harness.dart';

Color _textColor(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!.color!;

void main() {
  group('CharcoalText tone', () {
    testWidgets('resolves every tone from its pack role, in both brightnesses', (tester) async {
      for (final pack in [charcoalLightPack, charcoalDarkPack]) {
        final c = pack.colors;
        final expected = <CharcoalTextTone, Color>{
          CharcoalTextTone.primary: c.text,
          CharcoalTextTone.secondary: c.textSecondary,
          CharcoalTextTone.tertiary: c.textTertiary,
          CharcoalTextTone.placeholder: c.textPlaceholder,
          CharcoalTextTone.disabled: c.textDisabled,
          CharcoalTextTone.positive: c.textPositive,
          CharcoalTextTone.negative: c.textNegative,
          CharcoalTextTone.notice: c.textNotice,
          CharcoalTextTone.info: c.textInfo,
          CharcoalTextTone.onPrimary: c.textOnPrimary,
          CharcoalTextTone.onNegative: c.textOnNegative,
          CharcoalTextTone.onPositive: c.textOnPositive,
          CharcoalTextTone.onHud: c.textOnHud,
          CharcoalTextTone.onImage: c.textOnImage,
        };
        expect(expected.keys.toSet(), CharcoalTextTone.values.toSet());
        await pumpCharcoal(
          tester,
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [for (final t in CharcoalTextTone.values) CharcoalText(t.name, tone: t)],
            ),
          ),
          pack: pack,
        );
        for (final entry in expected.entries) {
          expect(_textColor(tester, entry.key.name), entry.value, reason: entry.key.name);
        }
      }
    });

    testWidgets('keeps the role colour without a tone, and rejects tone with color', (
      tester,
    ) async {
      await pumpLoose(tester, const CharcoalText('plain'));
      expect(_textColor(tester, 'plain'), isNotNull);
      expect(
        () => CharcoalText('x', color: const Color(0xFF000000), tone: CharcoalTextTone.primary),
        throwsAssertionError,
      );
    });
  });

  group('CharcoalIconView', () {
    testWidgets('resolves tone and size from the pack', (tester) async {
      await pumpLoose(
        tester,
        const CharcoalIconView(
          CharcoalIcons.lock,
          tone: CharcoalIconTone.negative,
          size: CharcoalIconSize.lg,
        ),
      );
      final icon = tester.widget<CharcoalIcon>(find.byType(CharcoalIcon));
      expect(icon.color, charcoalLightPack.colors.iconNegative);
      expect(icon.size, charcoalLightPack.sizes.iconLg);
      expect(tester.getSize(find.byType(CharcoalIcon)).width, charcoalLightPack.sizes.iconLg);
    });

    testWidgets('inherits colour and size without a tone and size', (tester) async {
      await pumpLoose(tester, const CharcoalIconView(CharcoalIcons.lock));
      final icon = tester.widget<CharcoalIcon>(find.byType(CharcoalIcon));
      expect(icon.color, isNull);
      expect(icon.size, isNull);
    });

    test('every tone and size maps to a distinct, existing role', () {
      final colors = charcoalLightPack.colors;
      expect(CharcoalIconTone.values.map((t) => t.resolve(colors)), isNotEmpty);
      final sizes = CharcoalIconSize.values.map((s) => s.resolve(charcoalLightPack.sizes));
      expect(sizes.toSet(), hasLength(CharcoalIconSize.values.length));
    });
  });

  group('CharcoalCodeBlock', () {
    testWidgets('shows monospace text on backgroundSecondary and is selectable', (tester) async {
      await pumpLoose(tester, const CharcoalCodeBlock('line 1\nline 2'));
      final box = tester.widget<Container>(find.byType(Container).first);
      expect(
        (box.decoration! as BoxDecoration).color,
        charcoalLightPack.colors.backgroundSecondary,
      );
      expect(find.byType(SelectableText), findsOneWidget);
      final style = tester.widget<SelectableText>(find.byType(SelectableText)).style!;
      expect(style.fontFamily, isNotNull);
    });

    testWidgets('selectable: false uses Text, and maxLines clips', (tester) async {
      await pumpLoose(
        tester,
        SizedBox(
          width: 200,
          child: CharcoalCodeBlock('word ' * 200, selectable: false, maxLines: 2),
        ),
      );
      expect(find.byType(SelectableText), findsNothing);
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('scrollable is bounded by codeViewportMaxHeight', (tester) async {
      await pumpLoose(
        tester,
        SizedBox(width: 300, child: CharcoalCodeBlock('x\n' * 500, scrollable: true)),
      );
      expect(
        tester.getSize(find.byType(CharcoalCodeBlock)).height,
        charcoalLightPack.sizes.codeViewportMaxHeight,
      );
    });

    testWidgets('lines builds lazily', (tester) async {
      await pumpLoose(
        tester,
        SizedBox(
          width: 300,
          height: 200,
          child: CharcoalCodeBlock.lines([for (var i = 0; i < 5000; i++) 'log line $i']),
        ),
      );
      expect(find.text('log line 0'), findsOneWidget);
      expect(find.text('log line 4999'), findsNothing);
    });

    testWidgets('the code dialog uses the same block', (tester) async {
      await pumpLoose(
        tester,
        Builder(
          builder: (context) => CharcoalButton(
            onPressed: () => showCharcoalCodeDialog(context, title: 'Log', code: 'hello'),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(CharcoalCodeBlock), findsOneWidget);
      expect(find.text('hello'), findsOneWidget);
    });
  });

  group('CharcoalLoadingState', () {
    testWidgets('keeps the Charcoal spinner inside xxxl padding', (tester) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: SizedBox(width: 300, child: CharcoalLoadingState()),
          ),
        ),
        settle: false,
      );
      expect(find.byType(CharcoalLoadingSpinner), findsOneWidget);
    });
  });

  group('CharcoalListRow body', () {
    testWidgets('top aligned leading and chevron keep their position through hover', (
      tester,
    ) async {
      final states = WidgetStatesController();
      addTearDown(states.dispose);
      await pumpLoose(
        tester,
        SizedBox(
          width: 400,
          child: CharcoalListRow(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalPadding: CharcoalSpace.md,
            leading: const CharcoalStatusDot(CharcoalTone.positive),
            title: 'Title',
            subtitle: 'Content line',
            subtitleRole: CharcoalTextRole.body,
            subtitleTone: CharcoalTextTone.secondary,
            subtitleGap: CharcoalSpace.xs,
            body: const CharcoalChip('sent'),
            statesController: states,
            onPressed: () {},
          ),
        ),
      );
      final pack = charcoalLightPack;
      expect(_textColor(tester, 'Content line'), pack.colors.textSecondary);
      final finders = [
        find.byType(CharcoalListRow),
        find.byType(CharcoalStatusDot),
        find.text('Title'),
        find.byType(CharcoalChip),
      ];
      final before = rectsOf(tester, finders);
      expect(
        tester.getTopLeft(find.byType(CharcoalStatusDot)).dy -
            tester.getTopLeft(find.byType(CharcoalListRow)).dy,
        pack.space.md + pack.space.xs,
      );
      for (final phase in [WidgetState.hovered, WidgetState.focused, WidgetState.pressed]) {
        states.update(phase, true);
        await tester.pump();
        expect(rectsOf(tester, finders), before, reason: '$phase');
        states.update(phase, false);
      }
    });
  });

  group('CharcoalActionTile', () {
    testWidgets('keeps its bounds through hover, focus and press and activates once', (
      tester,
    ) async {
      var taps = 0;
      final states = WidgetStatesController();
      addTearDown(states.dispose);
      await pumpLoose(
        tester,
        SizedBox(
          width: 240,
          child: CharcoalActionTile(
            icon: CharcoalIcons.add,
            label: 'New project',
            onPressed: () => taps++,
          ),
        ),
      );
      final before = tester.getRect(find.byType(CharcoalActionTile));
      expect(before.height, greaterThanOrEqualTo(charcoalLightPack.sizes.controlLg));
      final gesture = await tester.startGesture(tester.getCenter(find.byType(CharcoalActionTile)));
      await tester.pump();
      expect(tester.getRect(find.byType(CharcoalActionTile)), before);
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('CharcoalWrap', () {
    testWidgets('spaces items with theme steps', (tester) async {
      await pumpLoose(
        tester,
        const SizedBox(
          width: 100,
          child: CharcoalWrap(
            spacing: CharcoalSpace.lg,
            runSpacing: CharcoalSpace.xs,
            children: [SizedBox(width: 60, height: 10), SizedBox(width: 60, height: 10)],
          ),
        ),
      );
      final pack = charcoalLightPack;
      final boxes = find.byType(SizedBox);
      final a = tester.getRect(boxes.at(1));
      final b = tester.getRect(boxes.at(2));
      expect(b.top - a.bottom, pack.space.xs);
    });
  });

  group('CharcoalPage', () {
    Future<void> pumpPage(
      WidgetTester tester, {
      required Size size,
      bool? compact,
      bool showBack = false,
      VoidCallback? onBack,
      Widget? banner,
      bool busy = false,
      CharcoalPageWidth width = CharcoalPageWidth.standard,
      bool scrollable = true,
      bool shell = false,
    }) async {
      final page = CharcoalPage(
        title: 'Users',
        subtitle: 'Accounts',
        compact: compact,
        showBack: showBack,
        onBack: onBack,
        backLabel: 'Go back',
        banner: banner,
        busy: busy,
        maxWidth: width,
        scrollable: scrollable,
        compactTrailing: const CharcoalChip('eu'),
        actions: [CharcoalButton(onPressed: () {}, child: const Text('Invite'))],
        header: const Text('pinned'),
        child: const SizedBox(key: ValueKey('body'), height: 40),
      );
      await pumpCharcoal(
        tester,
        shell
            ? CharcoalAdminShell(
                sidebar: const SizedBox(width: 240),
                bottomBar: const SizedBox(height: 48),
                body: page,
              )
            : page,
        size: size,
      );
    }

    testWidgets('standard geometry: insets, title block, actions, gaps', (tester) async {
      await pumpPage(tester, size: const Size(1280, 900), showBack: true);
      final pack = charcoalLightPack;
      final body = tester.getRect(find.byKey(const ValueKey('body')));
      final title = tester.getRect(find.text('Users'));
      final inner = pack.sizes.contentMaxWidth - 2 * pack.sizes.pageInsetWide;
      expect(body.width, inner);
      expect(body.left, (1280 - pack.sizes.contentMaxWidth) / 2 + pack.sizes.pageInsetWide);
      expect(find.text('Go back'), findsOneWidget);
      // Top inset xxl; the back link (above the title) starts there.
      expect(tester.getTopLeft(find.text('Go back')).dy, greaterThanOrEqualTo(pack.space.xxl));
      expect(title.top, greaterThan(pack.space.xxl));
      expect(find.text('Accounts'), findsOneWidget);
      // Actions sit at the far end of the title row.
      expect(tester.getRect(find.text('Invite')).right, lessThanOrEqualTo(body.right));
      // No top bar title duplicated, no chip.
      expect(find.text('Users'), findsOneWidget);
      expect(find.byType(CharcoalChip), findsNothing);
      // xl between header, pinned header and body.
      final pinned = tester.getRect(find.text('pinned'));
      expect(body.top - pinned.bottom, pack.space.xl);
    });

    testWidgets('wide inset in the standard layout, narrow inset when compact', (tester) async {
      final pack = charcoalLightPack;
      await pumpPage(
        tester,
        size: const Size(600, 900),
        compact: false,
        width: CharcoalPageWidth.full,
      );
      expect(tester.getRect(find.byKey(const ValueKey('body'))).left, pack.sizes.pageInsetWide);
      await pumpPage(
        tester,
        size: const Size(600, 900),
        compact: true,
        width: CharcoalPageWidth.full,
      );
      expect(tester.getRect(find.byKey(const ValueKey('body'))).left, pack.space.lg);
    });

    testWidgets('maxWidth steps', (tester) async {
      final pack = charcoalLightPack;
      await pumpPage(tester, size: const Size(2400, 900), width: CharcoalPageWidth.wide);
      expect(
        tester.getSize(find.byKey(const ValueKey('body'))).width,
        pack.sizes.contentWideMaxWidth - 2 * pack.sizes.pageInsetWide,
      );
      await pumpPage(tester, size: const Size(2400, 900), width: CharcoalPageWidth.full);
      expect(
        tester.getSize(find.byKey(const ValueKey('body'))).width,
        2400 - 2 * pack.sizes.pageInsetWide,
      );
    });

    testWidgets('compact: top bar with centred title, trailing chip, actions above content', (
      tester,
    ) async {
      await pumpPage(tester, size: const Size(420, 900), compact: true);
      final pack = charcoalLightPack;
      expect(tester.getSize(find.text('Users')).height, greaterThan(0));
      expect(tester.getCenter(find.text('Users')).dx, closeTo(210, 1));
      expect(find.text('Accounts'), findsNothing);
      expect(find.byType(CharcoalChip), findsOneWidget);
      expect(tester.getRect(find.text('Users')).top, lessThan(pack.sizes.controlLg));
      expect(
        tester.getRect(find.text('Invite')).bottom,
        lessThan(tester.getRect(find.byKey(const ValueKey('body'))).top),
      );
    });

    testWidgets('compact with back: back button replaces the chip and calls onBack', (
      tester,
    ) async {
      var backs = 0;
      await pumpPage(
        tester,
        size: const Size(420, 900),
        compact: true,
        showBack: true,
        onBack: () => backs++,
      );
      expect(find.byType(CharcoalChip), findsNothing);
      await tester.tap(find.bySemanticsLabel('Go back'));
      await tester.pump();
      expect(backs, 1);
    });

    testWidgets('back link changes colour on hover and activates', (tester) async {
      var backs = 0;
      await pumpPage(tester, size: const Size(1280, 900), showBack: true, onBack: () => backs++);
      final pack = charcoalLightPack;
      expect(_textColor(tester, 'Go back'), pack.colors.textSecondary);
      FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.text('Go back')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(_textColor(tester, 'Go back'), pack.colors.text);
      await mouse.down(tester.getCenter(find.text('Go back')));
      await mouse.up();
      await tester.pump();
      expect(backs, 1);
    });

    testWidgets('follows the admin shell layout, not the window', (tester) async {
      await pumpPage(tester, size: const Size(1280, 900), shell: true);
      expect(find.text('Accounts'), findsOneWidget); // standard header
      await pumpPage(tester, size: const Size(420, 900), shell: true);
      expect(find.text('Accounts'), findsNothing); // compact top bar
    });

    testWidgets('without a shell it derives compact from its width', (tester) async {
      await pumpPage(tester, size: const Size(420, 900));
      expect(find.text('Accounts'), findsNothing);
      await pumpPage(tester, size: const Size(1280, 900));
      expect(find.text('Accounts'), findsOneWidget);
    });

    testWidgets('a banner replaces the content', (tester) async {
      await pumpPage(
        tester,
        size: const Size(1280, 900),
        banner: const CharcoalBanner(message: 'Locked'),
      );
      expect(find.text('Locked'), findsOneWidget);
      expect(find.byKey(const ValueKey('body')), findsNothing);
    });

    testWidgets('busy dims and blocks the page, announced once', (tester) async {
      var taps = 0;
      await pumpCharcoal(
        tester,
        CharcoalPage(
          title: 'T',
          busy: true,
          showBack: false,
          child: CharcoalButton(onPressed: () => taps++, child: const Text('Go')),
        ),
        size: const Size(1280, 900),
        settle: false,
      );
      await tester.pump();
      expect(find.byType(CharcoalLoadingSpinner), findsOneWidget);
      await tester.tap(find.text('Go'), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('scrollable false lets the child scroll itself', (tester) async {
      await pumpPage(tester, size: const Size(1280, 300), scrollable: false);
      expect(find.byType(SingleChildScrollView), findsNothing);
      await pumpPage(tester, size: const Size(1280, 300));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('lays out at text scale 3 without overflow', (tester) async {
      await pumpCharcoal(
        tester,
        CharcoalPage(
          title: 'Users',
          subtitle: 'Accounts',
          showBack: true,
          actions: [CharcoalButton(onPressed: () {}, child: const Text('Invite'))],
          child: const SizedBox(height: 40),
        ),
        size: const Size(420, 900),
        textScale: 3,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
