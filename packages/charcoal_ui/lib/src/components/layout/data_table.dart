import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../selection/checkbox.dart';
import 'list_row.dart';
import 'row_surface.dart';
import 'section_inset.dart';

/// How a [CharcoalTableColumn] places its label and cells across the column.
enum CharcoalColumnAlign {
  /// At the start edge, for text.
  start,

  /// In the middle, for a status mark.
  center,

  /// At the end edge, for numbers and dates.
  end,
}

/// One column of a [CharcoalDataTable]: its header [label], its share of the width and its
/// alignment.
@immutable
final class CharcoalTableColumn {
  /// A column that takes [flex] shares of the width left over by fitted columns.
  const CharcoalTableColumn({
    required this.label,
    this.flex = 1,
    this.align = CharcoalColumnAlign.start,
    this.hideWhenNarrow = false,
  }) : assert(flex != null && flex > 0);

  /// A column as wide as its widest cell or label, such as a status switch.
  const CharcoalTableColumn.fit({
    required this.label,
    this.align = CharcoalColumnAlign.start,
    this.hideWhenNarrow = false,
  }) : flex = null;

  /// The header text; may be empty.
  final String label;

  /// The share of the remaining width, or null for a column that fits its content.
  final int? flex;

  /// Where the label and cells sit in the column.
  final CharcoalColumnAlign align;

  /// Whether the column is left out when the table is narrower than `sizes.sidebarBreakpoint`.
  final bool hideWhenNarrow;
}

/// One row of a [CharcoalDataTable], identified by [id].
@immutable
final class CharcoalTableRow<T> {
  /// A row with one widget per column in [cells].
  const CharcoalTableRow({
    required this.id,
    required this.cells,
    this.action,
    this.onPressed,
    this.selected = false,
  });

  /// The row's identity: its key in the table and its member of `CharcoalTableSelection.selected`.
  final T id;

  /// One cell per column, in column order.
  final List<Widget> cells;

  /// The trailing row action, such as an icon button that removes the row.
  final Widget? action;

  /// Called when the row is activated; null makes a static row. A row with [onPressed] and no
  /// [action] shows a trailing chevron.
  final VoidCallback? onPressed;

  /// Whether this is the current row, such as the one open in a detail pane.
  final bool selected;
}

/// The checked rows of a [CharcoalDataTable] and the one callback that changes them.
///
/// The caller owns [selected] (for example a `CharcoalBatchSelection` state) and replaces it from
/// [onChanged], so the row boxes, the header box and a batch bar change together in one frame.
@immutable
final class CharcoalTableSelection<T> {
  /// Checks the rows whose ids are in [selected].
  const CharcoalTableSelection({
    required this.selected,
    required this.onChanged,
    this.selectAllLabel = 'Select all',
    this.selectRowLabel = 'Select row',
  });

  /// The ids of the checked rows; ids of rows not shown are kept.
  final Set<T> selected;

  /// Receives the next set when a row box or the header box is pressed.
  final ValueChanged<Set<T>> onChanged;

  /// The spoken label of the header box; pass the localized string.
  final String selectAllLabel;

  /// The spoken label of each row box; pass the localized string.
  final String selectRowLabel;
}

/// A table of records with a header row: columns that line up across rows, a row height from the
/// list row heights, an optional selection column and a trailing action per row.
///
/// Each column takes a share of the width ([CharcoalTableColumn.flex]) or fits its content
/// ([CharcoalTableColumn.fit]); [CharcoalTableColumn.hideWhenNarrow] columns are left out when the
/// table is narrower than `sizes.sidebarBreakpoint`. The first and last cells are inset like a
/// `CharcoalSectionCard`'s title, so the table lines up with the title of the flush card it
/// sits in.
///
/// A row with `onPressed` behaves like an interactive `CharcoalListRow`: hover and press tint the
/// whole row, keyboard focus outlines it, and its first cell is the button assistive technology
/// reads. With [selection], a leading checkbox per row and a "select all" box in the header (mixed
/// while only some rows are checked) report the next set of ids. The [rowHeight] is a minimum;
/// rows grow with their content and with text scale.
///
/// ```dart
/// CharcoalDataTable<String>(
///   columns: const [
///     CharcoalTableColumn(label: 'User', flex: 2),
///     CharcoalTableColumn(label: 'Joined', hideWhenNarrow: true),
///   ],
///   rows: [
///     for (final user in users)
///       CharcoalTableRow(
///         id: user.id,
///         cells: [CharcoalText(user.name, bold: true), CharcoalText(user.joined)],
///         onPressed: () => open(user),
///       ),
///   ],
/// )
/// ```
final class CharcoalDataTable<T> extends StatefulWidget {
  /// Creates a table of [rows] under the header of [columns].
  const CharcoalDataTable({
    required this.columns,
    required this.rows,
    this.rowHeight = CharcoalListRowHeight.regular,
    this.selection,
    super.key,
  });

  /// The columns, in display order.
  final List<CharcoalTableColumn> columns;

  /// The rows, each with one cell per column.
  final List<CharcoalTableRow<T>> rows;

  /// The minimum height of each row.
  final CharcoalListRowHeight rowHeight;

  /// The checked rows; null hides the selection column.
  final CharcoalTableSelection<T>? selection;

  @override
  State<CharcoalDataTable<T>> createState() => _CharcoalDataTableState<T>();
}

final class _CharcoalDataTableState<T> extends State<CharcoalDataTable<T>> {
  final Map<T, WidgetStatesController> _states = <T, WidgetStatesController>{};

  WidgetStatesController _statesOf(T id) =>
      _states.putIfAbsent(id, () => WidgetStatesController()..addListener(_changed));

  void _changed() {
    if (!mounted) return;
    // A row's clickable syncs its selected and disabled states while it builds; repaint the row
    // decorations after that frame instead of during it.
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    } else {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(CharcoalDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ids = <T>{for (final row in widget.rows) row.id};
    final gone = <WidgetStatesController>[];
    _states.removeWhere((id, controller) {
      if (ids.contains(id)) return false;
      gone.add(controller..removeListener(_changed));
      return true;
    });
    // The removed rows' clickables still hold their controllers until they unmount.
    if (gone.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        for (final controller in gone) {
          controller.dispose();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _states.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.rows.every((row) => row.cells.length == widget.columns.length),
      'Every row needs one cell per column',
    );
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < theme.sizes.sidebarBreakpoint;
        final shown = <int>[
          for (var i = 0; i < widget.columns.length; i++)
            if (!narrow || !widget.columns[i].hideWhenNarrow) i,
        ];
        final layout = _Layout(
          theme: theme,
          inset: charcoalSectionInset(theme, constraints.maxWidth),
          selection: widget.selection != null,
          trailing: widget.rows.any((row) => row.action != null || row.onPressed != null),
          columns: <CharcoalTableColumn>[for (final i in shown) widget.columns[i]],
        );
        return Table(
          columnWidths: layout.columnWidths(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            _header(layout),
            for (final row in widget.rows) _row(layout, row, shown),
          ],
        );
      },
    );
  }

  TableRow _header(_Layout layout) {
    final theme = layout.theme;
    final selection = widget.selection;
    final ids = <T>{for (final row in widget.rows) row.id};
    final checked = ids.where((id) => selection?.selected.contains(id) ?? false).length;
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline),
        ),
      ),
      children: <Widget>[
        if (selection != null)
          layout.cell(
            0,
            vertical: theme.space.sm,
            child: CharcoalCheckbox(
              value: ids.isNotEmpty && checked == ids.length,
              mixed: checked > 0 && checked < ids.length,
              semanticLabel: selection.selectAllLabel,
              onChanged: ids.isEmpty
                  ? null
                  : (_) => selection.onChanged(
                      checked == ids.length
                          ? selection.selected.difference(ids)
                          : selection.selected.union(ids),
                    ),
            ),
          ),
        for (var i = 0; i < layout.columns.length; i++)
          layout.cell(
            layout.dataIndex(i),
            vertical: theme.space.sm,
            align: layout.columns[i].align,
            child: Text(
              layout.columns[i].label,
              style: theme.style(CharcoalTextRole.caption, color: theme.colors.textTertiary),
            ),
          ),
        if (layout.trailing) layout.cell(layout.count - 1, child: const SizedBox.shrink()),
      ],
    );
  }

  TableRow _row(_Layout layout, CharcoalTableRow<T> row, List<int> shown) {
    final theme = layout.theme;
    final colors = theme.colors;
    final selection = widget.selection;
    final onPressed = row.onPressed;
    final states = onPressed == null ? null : _statesOf(row.id);
    final current = states?.value ?? const <WidgetState>{};
    final minHeight = switch (widget.rowHeight) {
      CharcoalListRowHeight.compact => theme.sizes.rowMinHeightCompact,
      CharcoalListRowHeight.regular => theme.sizes.rowMinHeight,
      CharcoalListRowHeight.tall => theme.sizes.rowMinHeightTall,
    };

    // Every cell of an interactive row hovers and presses the row as a whole, in every focus
    // highlight mode; the first data cell is the row's focusable button.
    Widget hit(Widget child) => states == null
        ? child
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => states.update(WidgetState.hovered, true),
            onExit: (_) => states.update(WidgetState.hovered, false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              // The first cell is the row's button for assistive technology.
              excludeFromSemantics: true,
              onTapDown: (_) => states.update(WidgetState.pressed, true),
              onTapUp: (_) => states.update(WidgetState.pressed, false),
              onTapCancel: () => states.update(WidgetState.pressed, false),
              onTap: onPressed,
              child: child,
            ),
          );
    Widget hover(Widget child) => states == null
        ? child
        : MouseRegion(
            onEnter: (_) => states.update(WidgetState.hovered, true),
            onExit: (_) => states.update(WidgetState.hovered, false),
            child: child,
          );

    final cells = <Widget>[
      if (selection != null)
        hover(
          layout.cell(
            0,
            minHeight: minHeight,
            child: CharcoalCheckbox(
              value: selection.selected.contains(row.id),
              semanticLabel: selection.selectRowLabel,
              onChanged: (checked) => selection.onChanged(
                checked
                    ? selection.selected.union(<T>{row.id})
                    : selection.selected.difference(<T>{row.id}),
              ),
            ),
          ),
        ),
      for (var i = 0; i < shown.length; i++)
        if (i == 0 && states != null)
          hover(
            MergeSemantics(
              child: CharcoalClickable(
                onPressed: onPressed,
                selected: row.selected,
                statesController: states,
                builder: (context, _) => layout.cell(
                  layout.dataIndex(i),
                  minHeight: minHeight,
                  align: layout.columns[i].align,
                  child: row.cells[shown[i]],
                ),
              ),
            ),
          )
        else
          hit(
            layout.cell(
              layout.dataIndex(i),
              minHeight: minHeight,
              align: layout.columns[i].align,
              child: row.cells[shown[i]],
            ),
          ),
      if (layout.trailing)
        (row.action == null ? hit : hover)(
          layout.cell(
            layout.count - 1,
            minHeight: minHeight,
            align: CharcoalColumnAlign.end,
            child:
                row.action ??
                (onPressed == null
                    ? const SizedBox.shrink()
                    : CharcoalIcon(
                        CharcoalIcons16.chevronRight,
                        size: theme.sizes.iconSm,
                        color: colors.iconTertiary,
                        matchTextDirection: true,
                      )),
          ),
        ),
    ];

    final focused = current.contains(WidgetState.focused);
    return TableRow(
      key: ValueKey<T>(row.id),
      decoration: BoxDecoration(
        color: charcoalRowFill(theme, current, selected: row.selected),
        border: focused
            ? Border.all(color: colors.borderFocus, width: theme.borders.hairline)
            : Border(
                bottom: BorderSide(color: colors.borderSubtle, width: theme.borders.hairline),
              ),
      ),
      children: cells,
    );
  }
}

/// The column geometry of one layout pass: which columns show, their widths and the cell insets.
final class _Layout {
  _Layout({
    required this.theme,
    required this.inset,
    required this.selection,
    required this.trailing,
    required this.columns,
  });

  final CharcoalTheme theme;

  /// The start inset of the first cell and the end inset of the last.
  final double inset;

  /// Whether the first table column holds the selection boxes.
  final bool selection;

  /// Whether the last table column holds the row actions or chevrons.
  final bool trailing;

  /// The data columns shown.
  final List<CharcoalTableColumn> columns;

  int get count => columns.length + (selection ? 1 : 0) + (trailing ? 1 : 0);

  /// The table column of the data column at [index].
  int dataIndex(int index) => index + (selection ? 1 : 0);

  Map<int, TableColumnWidth> columnWidths() => <int, TableColumnWidth>{
    if (selection) 0: const IntrinsicColumnWidth(),
    for (var i = 0; i < columns.length; i++)
      dataIndex(i): switch (columns[i].flex) {
        final flex? => FlexColumnWidth(flex.toDouble()),
        null => const _FitColumnWidth(),
      },
    if (trailing) count - 1: const _FitColumnWidth(),
  };

  /// One cell of table column [index]: the edge insets, the gap before it, and [child] placed by
  /// [align] and centred in at least [minHeight].
  Widget cell(
    int index, {
    required Widget child,
    CharcoalColumnAlign align = CharcoalColumnAlign.start,
    double minHeight = 0,
    double? vertical,
  }) {
    final space = theme.space;
    // A data column is a wide gap from the column before it; the selection box and the trailing
    // action sit closer to their neighbours.
    final before = index == 0
        ? inset
        : index == 1 && selection
        ? space.md
        : trailing && index == count - 1
        ? space.sm
        : space.xl;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: before,
          end: index == count - 1 ? inset : 0,
          top: vertical ?? space.md,
          bottom: vertical ?? space.md,
        ),
        child: Align(
          alignment: switch (align) {
            CharcoalColumnAlign.start => AlignmentDirectional.centerStart,
            CharcoalColumnAlign.center => AlignmentDirectional.center,
            CharcoalColumnAlign.end => AlignmentDirectional.centerEnd,
          },
          widthFactor: 1,
          child: child,
        ),
      ),
    );
  }
}

/// A column as wide as its widest cell, rounded up to a whole pixel, plus one pixel of room.
///
/// A cell can lay out a fraction of a pixel wider than it measures: after a font change, Flutter's
/// `RenderParagraph` lays its text out with the new font but still reports the intrinsic widths it
/// measured with the old one. An exact fit then overflows a `Row` cell, such as a switch beside a
/// chip. The measured width can be a whole number already, so rounding up alone leaves no room.
final class _FitColumnWidth extends TableColumnWidth {
  const _FitColumnWidth();

  static const _intrinsic = IntrinsicColumnWidth();

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) =>
      _intrinsic.minIntrinsicWidth(cells, containerWidth);

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) =>
      _intrinsic.maxIntrinsicWidth(cells, containerWidth).ceilToDouble() + 1;
}
