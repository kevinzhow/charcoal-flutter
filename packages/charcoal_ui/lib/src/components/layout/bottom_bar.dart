import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A bar pinned under a page's scrolling content: a reply composer or the page's primary action.
///
/// Page-coloured with a hairline rule on top and `space.sm` around [child], so it reads as one
/// surface on a grey page. Place it last in the page's column, or pass it to
/// `CharcoalScaffold.bottomBar`, which keeps it above the keyboard.
final class CharcoalBottomBar extends StatelessWidget {
  /// Creates a bar around [child].
  const CharcoalBottomBar({required this.child, super.key});

  /// The content, normally a row of a field and an action.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline),
        ),
        color: theme.colors.background,
      ),
      child: Padding(padding: EdgeInsets.all(theme.space.sm), child: child),
    );
  }
}
