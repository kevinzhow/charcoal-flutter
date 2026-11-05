import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Installs the theme's ambient text and icon defaults.
///
/// `MaterialApp` seeds the tree with an error text style (red 48px monospace with a yellow double
/// underline) as a nudge to put text inside a `Material`. Charcoal pages are not necessarily
/// inside one, so without this every `Text` with no explicit style would inherit that fallback.
///
/// `CharcoalApp` places this above the `Navigator`, so routes and the dialog routes pushed into
/// the same navigator both inherit the active pack's body style and icon colour and size.
class CharcoalTextDefaults extends StatelessWidget {
  /// Wraps [child] in the pack's default text style and icon theme.
  const CharcoalTextDefaults({required this.child, super.key});

  /// The subtree that inherits the defaults.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DefaultTextStyle(
      style: theme.style(CharcoalTextRole.bodyLarge),
      child: IconTheme(
        data: IconThemeData(color: theme.colors.icon, size: theme.sizes.iconLg),
        child: child,
      ),
    );
  }
}
