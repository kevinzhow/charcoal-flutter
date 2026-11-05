import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A hairline rule across the width it is given, in `colors.borderSubtle`.
final class CharcoalDivider extends StatelessWidget {
  /// Creates a rule.
  const CharcoalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: double.infinity,
      height: theme.borders.hairline,
      child: ColoredBox(color: theme.colors.borderSubtle),
    );
  }
}
