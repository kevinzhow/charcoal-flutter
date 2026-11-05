import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';
import 'card.dart';

/// A labelled progress meter on a card, such as a quota report.
///
/// [fraction] is clamped to 0..1 so an over-quota account renders a full bar instead of
/// overflowing the track. Exposes the label, value and percentage to assistive technology.
final class CharcoalMeter extends StatelessWidget {
  /// Creates a meter showing [fraction] of its track filled.
  const CharcoalMeter({
    required this.label,
    required this.value,
    required this.fraction,
    super.key,
  });

  /// The caption above the value.
  final String label;

  /// The figure, e.g. "12.4 GB / 20 GB".
  final String value;

  /// The filled part of the track, 0..1.
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final clamped = fraction.isNaN ? 0.0 : fraction.clamp(0.0, 1.0).toDouble();
    return Semantics(
      container: true,
      label: label,
      value: '$value, ${(clamped * 100).round()}%',
      excludeSemantics: true,
      child: CharcoalCard(
        padding: const CharcoalInset.symmetric(
          horizontal: CharcoalSpace.lg,
          vertical: CharcoalSpace.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(label, style: theme.style(CharcoalTextRole.caption)),
            Text(
              value,
              style: theme.style(CharcoalTextRole.modalTitle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: theme.space.sm),
            ClipRRect(
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
            ),
          ],
        ),
      ),
    );
  }
}
