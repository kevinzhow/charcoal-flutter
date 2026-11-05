import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The fill of a [CharcoalBadge].
enum CharcoalBadgeTone {
  /// `colors.primary` with `textOnPrimary`.
  primary,

  /// `colors.positive` with `textOnPositive`.
  positive,

  /// `colors.negative` with `textOnNegative`.
  negative,
}

/// A small solid label: a count, a role, "new".
///
/// Unlike a `CharcoalChip`, which is a pale status surface, a badge is a saturated fill with
/// inverse text. It is one line, `radius.sm` round, with `space.sm` of horizontal padding.
///
/// ```dart
/// const CharcoalBadge('Owner')
/// ```
final class CharcoalBadge extends StatelessWidget {
  /// Shows [label] on a [tone] fill.
  const CharcoalBadge(this.label, {this.tone = CharcoalBadgeTone.primary, super.key});

  /// The text.
  final String label;

  /// The fill.
  final CharcoalBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final (fill, text) = switch (tone) {
      CharcoalBadgeTone.primary => (colors.primary, colors.textOnPrimary),
      CharcoalBadgeTone.positive => (colors.positive, colors.textOnPositive),
      CharcoalBadgeTone.negative => (colors.negative, colors.textOnNegative),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.space.sm),
      decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(theme.radius.sm)),
      child: Text(
        label,
        style: theme.style(CharcoalTextRole.captionBold, color: text),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
