import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A small status chip: caption text on a pale tone surface.
///
/// Non-interactive; use `CharcoalTagItem` for a tappable tag. [monospace] sets the label in the
/// mono face, for identifiers and codes.
class CharcoalChip extends StatelessWidget {
  /// Creates a chip showing [label] in [tone].
  const CharcoalChip(
    this.label, {
    this.tone = CharcoalTone.neutral,
    this.monospace = false,
    super.key,
  });

  /// The text.
  final String label;

  /// The status colour family.
  final CharcoalTone tone;

  /// Whether to set the label in the mono face.
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.tone(tone);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.space.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(theme.radius.sm),
      ),
      child: Text(
        label,
        style: theme.style(
          monospace ? CharcoalTextRole.captionMono : CharcoalTextRole.captionBold,
          color: colors.foreground,
        ),
      ),
    );
  }
}
