import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Abstract placeholder artwork for content that has no image yet: a post, a product, a story or
/// a cover in a demo or an empty draft.
///
/// A diagonal gradient with a disc and a tilted tile, drawn only from the pack's accent and status
/// colours, so the art follows light, dark and any other pack. [seed] picks one of four
/// compositions; the same seed always draws the same art. The artwork fills a bounded parent;
/// inside an unbounded one (a scrolling column) it is `metrics.artwork.height` tall. [rounded]
/// clips it to the card radius for artwork that stands on its own (a grid tile, a story).
///
/// The artwork is announced as an image named [semanticLabel].
final class CharcoalPlaceholderArtwork extends StatelessWidget {
  /// Creates the composition for [seed].
  const CharcoalPlaceholderArtwork({
    required this.seed,
    required this.semanticLabel,
    this.rounded = false,
    super.key,
  }) : assert(semanticLabel != '');

  /// Selects the composition; any integer.
  final int seed;

  /// What the artwork shows, for assistive technology.
  final String semanticLabel;

  /// Whether the corners are clipped to `radius.md`.
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.artwork;
    final (start, end, accent) = switch (seed % 4) {
      0 => (colors.primary, colors.negative, colors.notice),
      1 => (colors.negative, colors.positive, colors.background),
      2 => (colors.notice, colors.primary, colors.negative),
      _ => (colors.positive, colors.negative, colors.neutral),
    };
    final radius = BorderRadius.circular(theme.radius.md);
    Widget art = ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[start, end],
          ),
        ),
        child: Stack(
          children: <Widget>[
            PositionedDirectional(
              bottom: metrics.discOffsetBottom,
              start: metrics.discOffsetStart,
              child: SizedBox(
                width: metrics.discDiameter,
                height: metrics.discDiameter,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                ),
              ),
            ),
            PositionedDirectional(
              end: metrics.tileOffsetEnd,
              top: metrics.tileOffsetTop,
              child: Transform.rotate(
                angle: metrics.tileAngle,
                child: SizedBox(
                  width: metrics.tileEdge,
                  height: metrics.tileEdge,
                  child: DecoratedBox(
                    decoration: BoxDecoration(borderRadius: radius, color: accent),
                    // The end colour over the opaque accent tints the tile, so it reads as lying
                    // on the gradient while every pixel stays a blend of two pack colours.
                    child: Opacity(
                      opacity: metrics.tileTint,
                      child: DecoratedBox(
                        decoration: BoxDecoration(borderRadius: radius, color: end),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (rounded) art = ClipRRect(borderRadius: radius, child: art);
    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) => constraints.hasBoundedHeight
              ? SizedBox(height: constraints.maxHeight, child: art)
              : SizedBox(height: metrics.height, child: art),
        ),
      ),
    );
  }
}
