import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';

/// An indeterminate progress ring: a `sizes.iconLg` circle with a `borders.thick` stroke in the
/// primary colour.
///
/// The quiet inline indicator for page regions and busy overlays, where
/// `CharcoalLoadingSpinner` (the expanding circle on its own card) would be too loud. The ring is
/// announced with [semanticLabel]. [size] overrides the edge. With reduced motion the ring stands
/// still as a half circle instead of spinning.
final class CharcoalProgressRing extends StatelessWidget {
  /// Creates a ring.
  const CharcoalProgressRing({
    this.semanticLabel = 'Loading',
    this.size,
    super.key,
  }) : assert(semanticLabel != ''),
       assert(size == null || size > 0);

  /// What assistive technology announces.
  final String semanticLabel;

  /// Edge of the ring; defaults to `sizes.iconLg`.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox.square(
      dimension: size ?? theme.sizes.iconLg,
      child: CircularProgressIndicator(
        semanticsLabel: semanticLabel,
        strokeWidth: theme.borders.thick,
        value: MediaQuery.disableAnimationsOf(context) ? 1 / 2 : null,
      ),
    );
  }
}
