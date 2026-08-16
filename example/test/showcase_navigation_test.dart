import 'dart:ui' as ui;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/main.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sidebar destinations replace the showcase content', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1180, 820));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const CharcoalShowcaseApp());

    expect(find.textContaining('Source-backed components'), findsOneWidget);

    const destinations = <String, String>{
      'Colors': 'Color catalog',
      'Typography': 'Typography catalog',
      'Dimensions': 'Dimension catalog',
      'Icons': 'Icon catalog',
      'Buttons': 'Content slots',
      'Selection': 'Selection controls',
      'Fields': 'Fields and menus',
      'Navigation': 'Navigation and paging',
      'Content': 'Content presentation',
      'Feedback': 'Feedback and overlays',
      'Token pipeline': 'From source to Flutter',
    };

    for (final destination in destinations.entries) {
      final navigationItem = find.byKey(
        ValueKey<String>('nav-${destination.key}'),
      );
      await tester.ensureVisible(navigationItem);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.tap(navigationItem);
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.text(destination.value),
        findsOneWidget,
        reason: '${destination.key} should replace the page content',
      );
    }
  });

  testWidgets(
    'page transitions preserve scroll state without jumping the outgoing page',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1180, 820));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const CharcoalShowcaseApp());
      await tester.tap(find.byKey(const ValueKey<String>('nav-Typography')));
      await tester.pump(const Duration(milliseconds: 300));

      final typographyScroll = find.byKey(
        const ValueKey<String>('page-scroll-Typography'),
      );
      await tester.drag(typographyScroll, const Offset(0, -560));
      await tester.pump();
      final outgoingController = tester
          .widget<SingleChildScrollView>(typographyScroll)
          .controller!;
      final savedOffset = outgoingController.offset;
      expect(savedOffset, greaterThan(0));

      await tester.tap(find.byKey(const ValueKey<String>('nav-Buttons')));
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        outgoingController.offset,
        savedOffset,
        reason:
            'the outgoing page must not jump to its top before transitioning',
      );
      expect(
        find.byKey(const ValueKey<String>('page-Typography')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('page-Buttons')),
        findsOneWidget,
      );

      await tester.pump(const Duration(milliseconds: 250));
      expect(
        find.byKey(const ValueKey<String>('page-Typography')),
        findsNothing,
      );

      await tester.tap(find.byKey(const ValueKey<String>('nav-Typography')));
      await tester.pump(const Duration(milliseconds: 300));
      final restoredController = tester
          .widget<SingleChildScrollView>(typographyScroll)
          .controller!;
      expect(restoredController.offset, moreOrLessEquals(savedOffset));
    },
  );

  testWidgets(
    'rapid destination changes do not share active scroll controllers',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1180, 820));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const CharcoalShowcaseApp());
      await tester.tap(find.byKey(const ValueKey<String>('nav-Colors')));
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(find.byKey(const ValueKey<String>('nav-Typography')));
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(find.byKey(const ValueKey<String>('nav-Colors')));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey<String>('page-Colors')), findsOneWidget);
    },
  );

  testWidgets('page transitions never paint over the sidebar divider', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1180, 820));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final surfaceKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: surfaceKey, child: const CharcoalShowcaseApp()),
    );

    final divider = find.byKey(
      const ValueKey<String>('showcase-sidebar-divider'),
    );
    final initialRenderObject = tester.renderObject(divider);
    final dividerColor = tester.widget<ColoredBox>(
      find.descendant(of: divider, matching: find.byType(ColoredBox)),
    );
    final theme = CharcoalThemeData.light();

    expect(tester.getSize(divider).width, 1);
    expect(dividerColor.color, theme.colors.borderSecondary);

    final feedback = find.byKey(const ValueKey<String>('nav-Feedback'));
    await tester.ensureVisible(feedback);
    await tester.pump(const Duration(milliseconds: 300));
    final stablePixel = await tester.runAsync(
      () => _pixelAt(surfaceKey, x: 247, y: 400),
    );
    await tester.tap(feedback);

    expect(
      tester.renderObject(divider),
      same(initialRenderObject),
      reason: 'page transitions must not replace the divider render object',
    );
    var elapsed = Duration.zero;
    for (final frameDelta in <Duration>[
      const Duration(milliseconds: 16),
      const Duration(milliseconds: 32),
      const Duration(milliseconds: 50),
      const Duration(milliseconds: 75),
      const Duration(milliseconds: 100),
    ]) {
      await tester.pump(frameDelta);
      elapsed += frameDelta;
      expect(
        await tester.runAsync(() => _pixelAt(surfaceKey, x: 247, y: 400)),
        stablePixel,
        reason:
            'the main page viewport painted over the divider after '
            '${elapsed.inMilliseconds} ms',
      );
    }

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey<String>('page-Overview')), findsNothing);
  });
}

Future<int> _pixelAt(
  GlobalKey boundaryKey, {
  required int x,
  required int y,
}) async {
  final boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage();
  final width = image.width;
  final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  image.dispose();
  final offset = ((y * width) + x) * 4;
  final data = bytes!.buffer.asUint8List();
  return data[offset] << 24 |
      data[offset + 1] << 16 |
      data[offset + 2] << 8 |
      data[offset + 3];
}
