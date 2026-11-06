import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A thin horizontal bar filled to [value]: the progress of a story, an upload or a quota.
///
/// [value] is clamped to 0..1. The track is `sizes.meterTrack` high on the tertiary surface and
/// the filled part is the primary colour. With a [semanticLabel] the bar reports its percentage
/// to assistive technology; without one it is decorative.
final class CharcoalProgressBar extends StatelessWidget {
  /// Creates a bar filled to [value].
  const CharcoalProgressBar({required this.value, this.semanticLabel, super.key})
    : assert(semanticLabel == null || semanticLabel != '');

  /// The filled part of the track, 0..1.
  final double value;

  /// Spoken name of the progress, or null for a decorative bar.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final clamped = value.isNaN ? 0.0 : value.clamp(0.0, 1.0).toDouble();
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(theme.radius.xs),
      child: Container(
        height: theme.sizes.meterTrack,
        color: theme.colors.surfaceTertiary,
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: clamped,
          heightFactor: 1,
          child: ColoredBox(color: theme.colors.primary),
        ),
      ),
    );
    final label = semanticLabel;
    if (label == null) return ExcludeSemantics(child: bar);
    return Semantics(
      container: true,
      label: label,
      value: '${(clamped * 100).round()}%',
      excludeSemantics: true,
      child: bar,
    );
  }
}
