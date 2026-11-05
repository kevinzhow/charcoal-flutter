import 'package:charcoal_ui/next.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/isolation.dart';
import 'support/scenes.dart';

/// The isolation proof.
///
/// Mounts every registered scene under [extremePack] (colours and numbers no real pack or Material
/// default resembles) and checks that what is painted comes from that pack and nowhere else:
///
/// 1. every colour a widget in the tree carries is a pack colour;
/// 2. every flat colour on screen (>= 0.05% of the pixels) is a pack colour or a blend of two,
///    which also catches colours painted by Material internals no widget property exposes;
/// 3. geometry and type follow the pack.
///
/// Both brightnesses run, so a role only one pack feeds shows up in the other. Family batches add
/// scenes to `support/scenes.dart`; they need no changes here.
void main() {
  const boundary = ValueKey<String>('shot');

  /// Colours that artwork (multi-colour icons) may use. Target: empty.
  const artworkAllowList = <Color>{};

  Future<List<String>> problems(WidgetTester tester, CharcoalThemePack pack) async {
    final allowed = packColors(pack);
    final seen = <Color>{};
    final foreign = foreignWidgetColors(tester, allowed, seen: seen);
    final problems = <String>[
      for (final f in foreign) 'widget colour outside the pack: $f',
      if (seen.length <= 3) 'the walk found too few colours (${seen.length}) to prove anything',
      for (final p in await strayPixels(
        tester,
        allowed,
        boundary,
        artworkAllowList: artworkAllowList,
      ))
        'flat pixel colour outside the pack: $p',
    ];
    return problems;
  }

  test('the scene registry has unique names', () {
    final names = charcoalScenes.map((s) => s.name).toList();
    expect(names.toSet(), hasLength(names.length));
    expect(artworkAllowList, isEmpty);
  });

  for (final brightness in Brightness.values) {
    final pack = extremePack(brightness);

    group('extreme pack (${brightness.name})', () {
      for (final scene in charcoalScenes) {
        testWidgets('${scene.name} paints only pack colours', (tester) async {
          await pumpCharcoal(
            tester,
            Builder(builder: scene.build),
            pack: pack,
            size: scene.size,
            boundaryKey: boundary,
          );
          expect(await problems(tester, pack), isEmpty, reason: scene.name);
        });
      }

      testWidgets('a scene that paints a foreign colour is caught', (tester) async {
        await pumpCharcoal(
          tester,
          const ColoredBox(color: Color(0xFF123456), child: SizedBox.expand()),
          pack: pack,
          size: const Size(400, 400),
          boundaryKey: boundary,
        );
        final found = await problems(tester, pack);
        expect(found.any((p) => p.startsWith('widget colour')), isTrue, reason: '$found');
        expect(found.any((p) => p.startsWith('flat pixel')), isTrue, reason: '$found');
      });

      testWidgets('a foreign colour from a Material default is caught by pixels', (tester) async {
        // No widget property exposes this colour; only the pixel check can see it.
        await pumpCharcoal(
          tester,
          CustomPaint(painter: _ForeignPainter(), child: const SizedBox.expand()),
          pack: pack,
          size: const Size(400, 400),
          boundaryKey: boundary,
        );
        final found = await problems(tester, pack);
        expect(found.any((p) => p.startsWith('flat pixel')), isTrue, reason: '$found');
      });
    });
  }

  group('geometry and type follow the pack', () {
    final pack = extremePack(Brightness.light);

    testWidgets('layout helpers resolve spacing steps', (tester) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CharcoalGap(CharcoalSpace.md, key: ValueKey('gap')),
              CharcoalPadding(
                padding: CharcoalInset.symmetric(
                  horizontal: CharcoalSpace.lg,
                  vertical: CharcoalSpace.xs,
                ),
                child: SizedBox(key: ValueKey('pad'), width: 10, height: 10),
              ),
            ],
          ),
        ),
        pack: pack,
        size: const Size(800, 600),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('gap'))).height,
        closeTo(pack.space.md, 1e-9),
      );
      final padded = tester.getRect(find.byType(CharcoalPadding));
      expect(padded.width, closeTo(10 + 2 * pack.space.lg, 1e-9));
      expect(padded.height, closeTo(10 + 2 * pack.space.xs, 1e-9));
    });

    testWidgets('ambient text and icon defaults follow the pack', (tester) async {
      late BuildContext inner;
      // Without pumpCharcoal's Material wrapper, which sets its own text style.
      useWindow(tester, const Size(400, 400));
      await tester.pumpWidget(
        CharcoalApp(
          lightPack: pack,
          themeMode: CharcoalThemeMode.light,
          home: Builder(
            builder: (context) {
              inner = context;
              return const Text('x');
            },
          ),
        ),
      );
      final style = DefaultTextStyle.of(inner).style;
      final spec = pack.typography.spec(CharcoalTextRole.bodyLarge);
      expect(style.fontSize, spec.fontSize);
      expect(style.color, pack.colors.text);
      expect(IconTheme.of(inner).size, pack.sizes.iconLg);
      expect(IconTheme.of(inner).color, pack.colors.icon);
      expect(style.decoration, isNot(TextDecoration.underline));
    });

    testWidgets('scaffold paints the pack background and picks icon contrast by luminance', (
      tester,
    ) async {
      await pumpCharcoal(
        tester,
        const CharcoalScaffold(body: SizedBox.expand()),
        pack: pack,
        size: const Size(400, 400),
      );
      final box = tester.widget<ColoredBox>(
        find.descendant(of: find.byType(CharcoalScaffold), matching: find.byType(ColoredBox)).first,
      );
      expect(box.color, pack.colors.background);
    });

    testWidgets('page transition offsets follow the pack', (tester) async {
      late BuildContext home;
      await pumpCharcoal(
        tester,
        Builder(
          builder: (context) {
            home = context;
            return const SizedBox.expand();
          },
        ),
        pack: pack,
        size: const Size(800, 600),
      );
      final route = CharcoalPageRoute<void>(
        builder: (context) => const SizedBox.expand(key: ValueKey('detail')),
      );
      Navigator.of(home).push<void>(route);
      await tester.pump();
      expect(route.transitionDuration, pack.motion.routeForward);
      expect(route.reverseTransitionDuration, pack.motion.routeReverse);
    }, variant: TargetPlatformVariant.only(TargetPlatform.linux));
  });
}

class _ForeignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF123456));

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
