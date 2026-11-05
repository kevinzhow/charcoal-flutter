import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The product mark: a `sizes.brandMark` square in the primary colour with one letter.
///
/// Used by `CharcoalSidebarBrand` and on its own, e.g. above a sign-in form.
final class CharcoalBrandMark extends StatelessWidget {
  /// Draws [mark], normally a single letter.
  const CharcoalBrandMark(this.mark, {super.key});

  /// The letter drawn in the mark.
  final String mark;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Container(
      width: theme.sizes.brandMark,
      height: theme.sizes.brandMark,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.primary,
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      child: Text(
        mark,
        style: theme.style(CharcoalTextRole.bodyBold, color: theme.colors.textOnPrimary),
      ),
    );
  }
}
