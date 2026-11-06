import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The small negative count pill drawn over a navigation icon: a tab item or an icon button.
///
/// Library-internal (not exported): callers pass a `badge` label to `CharcoalTabItem` or
/// `CharcoalIconButton`. Geometry comes from `metrics.tabBar`, where the badge was first defined.
final class CharcoalCountBadge extends StatelessWidget {
  /// Draws [label] in the badge.
  const CharcoalCountBadge({required this.label, super.key});

  /// The count, normally a short number.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.tabBar;
    final base = theme.style(
      CharcoalTextRole.size10,
      color: theme.colors.textOnNegative,
      bold: true,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.background, width: theme.borders.hairline),
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: theme.colors.negative,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: metrics.badgeMinExtent,
          minWidth: metrics.badgeMinExtent,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.space.xs),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              style: base.apply(fontSizeFactor: metrics.badgeFontSize / base.fontSize!),
            ),
          ),
        ),
      ),
    );
  }
}
