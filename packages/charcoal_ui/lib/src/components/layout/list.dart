import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A divided list, the main content shape of data screens.
///
/// A hairline rule is drawn above the first row (unless [topBorder] is false) and each
/// `CharcoalListRow` draws the rule below itself, so the list reads as a table without card
/// chrome. An empty list renders nothing.
///
/// ```dart
/// CharcoalList(children: [
///   for (final user in users) CharcoalListRow(title: user.name, onPressed: () => open(user)),
/// ])
/// ```
final class CharcoalList extends StatelessWidget {
  /// Creates a list of [children], normally `CharcoalListRow`s.
  const CharcoalList({required List<Widget> this.children, this.topBorder = true, super.key})
    : child = null;

  /// Draws the list's top rule around any [child], such as a reorderable or lazily built list
  /// of `CharcoalListRow`s.
  const CharcoalList.around(Widget this.child, {this.topBorder = true, super.key})
    : children = null;

  /// The rows.
  final List<Widget>? children;

  /// The wrapped list of [CharcoalList.around].
  final Widget? child;

  /// Whether a rule is drawn above the first row.
  final bool topBorder;

  @override
  Widget build(BuildContext context) {
    if (children != null && children!.isEmpty) return const SizedBox.shrink();
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: topBorder
            ? Border(
                top: BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline),
              )
            : null,
      ),
      child: child ?? Column(children: children!),
    );
  }
}
