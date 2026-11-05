import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../admin/admin_shell.dart';
import '../../foundation/layout.dart';

/// How many columns a [CharcoalGrid] uses in each layout class.
@immutable
final class CharcoalGridColumns {
  /// [wide] columns in the standard (sidebar) layout, [compact] in the compact one.
  const CharcoalGridColumns({this.wide = 3, this.compact = 1}) : assert(wide > 0 && compact > 0);

  /// Columns in the standard layout.
  final int wide;

  /// Columns in the compact layout.
  final int compact;

  @override
  bool operator ==(Object other) =>
      other is CharcoalGridColumns && other.wide == wide && other.compact == compact;

  @override
  int get hashCode => Object.hash(wide, compact);
}

/// A grid of equal-width cells whose column count follows the layout class.
///
/// The layout class is the enclosing `CharcoalAdminShell`'s (`CharcoalAdminLayout`); outside a
/// shell it is decided by the grid's own width against `sizes.sidebarBreakpoint`. Cells are as tall
/// as their content (rows do not stretch their cells), the last row is padded with empty cells so
/// columns stay aligned, and gaps are [spacing] steps of the theme. The count never exceeds the
/// number of children.
///
/// ```dart
/// CharcoalGrid(
///   columns: const CharcoalGridColumns(wide: 3, compact: 1),
///   children: [for (final stat in stats) CharcoalStatCard(label: stat.label, value: stat.value)],
/// )
/// ```
final class CharcoalGrid extends StatelessWidget {
  /// Lays out [children] in rows.
  const CharcoalGrid({
    required this.children,
    this.columns = const CharcoalGridColumns(),
    this.runSpacing,
    this.spacing = CharcoalSpace.md,
    super.key,
  });

  /// The cells.
  final List<Widget> children;

  /// Column counts per layout class.
  final CharcoalGridColumns columns;

  /// The gap between rows; [spacing] when null.
  final CharcoalSpace? runSpacing;

  /// The gap between columns.
  final CharcoalSpace spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final shell = CharcoalAdminLayout.compactOf(context);
    if (shell != null) return _grid(shell);
    final breakpoint = CharcoalTheme.of(context).sizes.sidebarBreakpoint;
    return LayoutBuilder(
      builder: (context, constraints) => _grid(constraints.maxWidth < breakpoint),
    );
  }

  Widget _grid(bool compact) {
    final count = (compact ? columns.compact : columns.wide).clamp(1, children.length);
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += count) {
      final end = (start + count).clamp(0, children.length);
      final cells = <Widget>[];
      for (var i = start; i < start + count; i++) {
        if (i > start) cells.add(CharcoalGap.horizontal(spacing));
        cells.add(Expanded(child: i < end ? children[i] : const SizedBox.shrink()));
      }
      if (start > 0) rows.add(CharcoalGap.vertical(runSpacing ?? spacing));
      rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}
