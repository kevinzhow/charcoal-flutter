import 'dart:math' as math;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Colours that may appear on screen for [pack]: every role plus transparent.
Set<Color> packColors(CharcoalThemePack pack) => {
  ...pack.colors.toMap().values.whereType<Color>(),
  CharcoalColorRoles.transparent,
};

/// Colours widgets in the tree carry that are not in [allowed], as `Widget.property: colour`.
///
/// Also returns, through [seen], every colour found, so a test can prove the walk saw something.
Set<String> foreignWidgetColors(WidgetTester tester, Set<Color> allowed, {Set<Color>? seen}) {
  final foreign = <String>{};
  void check(String where, Color? color) {
    if (color == null) return;
    seen?.add(color);
    if (color.a != 0 && !allowed.contains(color)) foreign.add('$where: $color');
  }

  for (final element in tester.allElements) {
    final widget = element.widget;
    final where = widget.runtimeType.toString();
    if (widget is DecoratedBox) {
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        check('$where.color', decoration.color);
        final border = decoration.border;
        if (border is Border) {
          for (final side in [border.top, border.right, border.bottom, border.left]) {
            if (side.style == BorderStyle.solid && side.width > 0) {
              check('$where.border', side.color);
            }
          }
        }
        for (final shadow in decoration.boxShadow ?? const <BoxShadow>[]) {
          check('$where.shadow', shadow.color);
        }
      }
    } else if (widget is ColoredBox) {
      check('$where.color', widget.color);
    } else if (widget is Material) {
      if (widget.type != MaterialType.transparency) check('$where.color', widget.color);
    } else if (widget is RichText) {
      check('$where.text', widget.text.style?.color);
      widget.text.visitChildren((span) {
        if (span is TextSpan) check('$where.text', span.style?.color);
        return true;
      });
    } else if (widget is Icon) {
      check('$where.color', widget.color ?? IconTheme.of(element).color);
    } else if (widget is CharcoalIcon) {
      check('$where.color', widget.color ?? IconTheme.of(element).color);
    }
  }
  return foreign;
}

/// Flat colours covering at least 0.05% of the pixels of the [boundaryKey] boundary that are
/// neither a pack colour nor a blend of two (anti-aliasing), as `0xAARRGGBB xCOUNT`.
Future<List<String>> strayPixels(
  WidgetTester tester,
  Set<Color> allowed,
  Key boundaryKey, {
  Set<Color> artworkAllowList = const {},
}) async {
  final boundary = tester.firstRenderObject<RenderRepaintBoundary>(find.byKey(boundaryKey));
  final (bytes, width, height) = (await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final data = (await image.toByteData())!;
    return (data, image.width, image.height);
  }))!;

  final histogram = <int, int>{};
  for (var i = 0; i < width * height; i++) {
    final rgba = bytes.getUint32(i * 4);
    histogram[rgba] = (histogram[rgba] ?? 0) + 1;
  }
  final threshold = (width * height * 0.0005).ceil();

  final palette = [
    for (final c in {...allowed, ...artworkAllowList}) (c.r * 255, c.g * 255, c.b * 255),
  ];
  double distance(
    (double, double, double) a,
    (double, double, double) b,
    (double, double, double) q,
  ) {
    final d = (b.$1 - a.$1, b.$2 - a.$2, b.$3 - a.$3);
    final v = (q.$1 - a.$1, q.$2 - a.$2, q.$3 - a.$3);
    final len2 = d.$1 * d.$1 + d.$2 * d.$2 + d.$3 * d.$3;
    final t = len2 == 0 ? 0.0 : ((v.$1 * d.$1 + v.$2 * d.$2 + v.$3 * d.$3) / len2).clamp(0.0, 1.0);
    final dx = a.$1 + d.$1 * t - q.$1;
    final dy = a.$2 + d.$2 * t - q.$2;
    final dz = a.$3 + d.$3 * t - q.$3;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  bool isAllowed(int rgba) {
    final p = (
      ((rgba >> 24) & 0xFF).toDouble(),
      ((rgba >> 16) & 0xFF).toDouble(),
      ((rgba >> 8) & 0xFF).toDouble(),
    );
    for (var i = 0; i < palette.length; i++) {
      for (var j = i; j < palette.length; j++) {
        if (distance(palette[i], palette[j], p) <= 3) return true;
      }
    }
    return false;
  }

  return [
    for (final entry in histogram.entries)
      if (entry.value >= threshold && !isAllowed(entry.key))
        '0x${entry.key.toRadixString(16).padLeft(8, '0')} x${entry.value}',
  ];
}
