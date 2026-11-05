import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Tells the pages inside a [CharcoalAdminShell] whether the shell is in its compact layout
/// (bottom bar, no sidebar).
///
/// The shell decides, because it is what moves the navigation chrome; a `CharcoalPage` reads it
/// so its own header matches. Outside a shell, [compactOf] is null.
final class CharcoalAdminLayout extends InheritedWidget {
  /// Creates a scope.
  const CharcoalAdminLayout({required this.compact, required super.child, super.key});

  /// Whether the shell shows the bottom bar instead of the sidebar.
  final bool compact;

  /// The nearest shell's layout, or null when there is none.
  static bool? compactOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CharcoalAdminLayout>()?.compact;

  @override
  bool updateShouldNotify(CharcoalAdminLayout oldWidget) => oldWidget.compact != compact;
}

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
          return CharcoalAdminLayout(
            compact: !wide,
            child: Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (wide) sidebar,
                Expanded(child: body),
                if (!wide && bottomBar != null) bottomBar!,
              ],
            ),
          );
        },
      ),
    );
  }
}
