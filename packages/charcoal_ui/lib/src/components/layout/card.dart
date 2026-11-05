import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';

/// A grey filled card, the surface for stats and grouped information.
///
/// [outlined] swaps the fill for a hairline outline, for cards that sit directly on the grey
/// surface where a fill would disappear.
///
/// ```dart
/// CharcoalCard(child: CharcoalText('Plan: Pro', role: CharcoalTextRole.bodyBold))
/// ```
final class CharcoalCard extends StatelessWidget {
  /// Creates a card around [child].
  const CharcoalCard({
    required this.child,
    this.outlined = false,
    this.padding = const CharcoalInset.all(CharcoalSpace.lg),
    super.key,
  });

  /// The content.
  final Widget child;

  /// Whether the card is an outline without a fill.
  final bool outlined;

  /// The space between the card edge and [child].
  final CharcoalInset padding;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: outlined ? null : theme.colors.backgroundSecondary,
        border: outlined
            ? Border.all(color: theme.colors.borderSubtle, width: theme.borders.hairline)
            : null,
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      child: Padding(padding: padding.resolve(context), child: child),
    );
  }
}
