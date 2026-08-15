import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'charcoal_icon_data.dart';

/// Renders a bundled Charcoal V2 SVG using Flutter's standard [IconTheme].
///
/// Regular and solid assets inherit the nearest icon color. Multicolor assets
/// preserve their authored colors unless [color] is supplied explicitly.
final class CharcoalIcon extends StatelessWidget {
  const CharcoalIcon(
    this.icon, {
    this.alignment = Alignment.center,
    this.color,
    this.fit = BoxFit.contain,
    this.matchTextDirection = false,
    this.semanticLabel,
    this.size,
    super.key,
  });

  final CharcoalIconData icon;
  final AlignmentGeometry alignment;
  final Color? color;
  final BoxFit fit;
  final bool matchTextDirection;
  final String? semanticLabel;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final resolvedSize = size ?? iconTheme.size ?? icon.nativeSize;
    final resolvedColor = color ?? iconTheme.color;
    final preservesAuthoredColors = icon.style == CharcoalIconStyle.color && color == null;
    Widget result = SvgPicture.asset(
      icon.assetName,
      alignment: alignment,
      colorFilter: preservesAuthoredColors || resolvedColor == null
          ? null
          : ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      excludeFromSemantics: true,
      fit: fit,
      height: resolvedSize,
      matchTextDirection: matchTextDirection,
      package: 'charcoal_icons',
      width: resolvedSize,
    );

    final opacity = iconTheme.opacity;
    if (opacity != null && opacity != 1) {
      result = Opacity(opacity: opacity, child: result);
    }

    final label = semanticLabel;
    return label == null
        ? ExcludeSemantics(child: result)
        : Semantics(image: true, label: label, child: result);
  }
}
