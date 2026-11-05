import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The square, non-interactive checkbox indicator for a list's batch-selection mode.
///
/// It fills `sizes.indicatorSlot`, the same slot as `CharcoalStatusDot`, so entering and leaving
/// selection mode cannot shift a row's content sideways. Wrap it in a tappable row or use
/// `CharcoalCheckbox` for a standalone control.
class CharcoalSelectionBox extends StatelessWidget {
  /// Creates the indicator in the [selected] state.
  const CharcoalSelectionBox({required this.selected, super.key});

  /// Whether the box is filled and checked.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    return Container(
      width: theme.sizes.indicatorSlot,
      height: theme.sizes.indicatorSlot,
      decoration: BoxDecoration(
        color: selected ? colors.primary : null,
        border: Border.all(
          color: selected ? colors.primary : colors.border,
          width: theme.borders.thick,
        ),
        borderRadius: BorderRadius.circular(theme.radius.sm),
      ),
      child: selected
          ? CharcoalIcon(CharcoalIcons.check, size: theme.sizes.iconSm, color: colors.textOnPrimary)
          : null,
    );
  }
}
