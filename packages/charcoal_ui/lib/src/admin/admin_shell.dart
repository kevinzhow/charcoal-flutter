import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The responsive frame of an admin app: a permanent [sidebar] beside [body] at or above
/// `sizes.sidebarBreakpoint`, and [body] above a [bottomBar] (a `CharcoalTabBar`) below it.
///
/// The decision follows the width the shell is given, not the window, so it also works in a
/// pane. Switching layouts keeps [body]'s state because it keeps the same position in the tree.
final class CharcoalAdminShell extends StatelessWidget {
  /// Creates a shell.
  const CharcoalAdminShell({
    required this.body,
    required this.sidebar,
    this.bottomBar,
    super.key,
  });

  /// The page content.
  final Widget body;

  /// The wide layout's sidebar, usually a `CharcoalSidebar`.
  final Widget sidebar;

  /// The narrow layout's bottom navigation, usually a `CharcoalTabBar`.
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= theme.sizes.sidebarBreakpoint;
          return Flex(
            direction: wide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (wide) sidebar,
              Expanded(child: body),
              if (!wide && bottomBar != null) bottomBar!,
            ],
          );
        },
      ),
    );
  }
}
