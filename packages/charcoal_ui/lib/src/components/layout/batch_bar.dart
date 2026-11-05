import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../actions/button.dart';

/// Batch-selection state for a list screen: the mode flag, the selected ids and the helpers to
/// enter, leave and toggle, shared by every "select, tick rows, delete selected" screen.
///
/// ```dart
/// class _UsersState extends State<Users> with CharcoalBatchSelection<Users> { ... }
/// ```
mixin CharcoalBatchSelection<W extends StatefulWidget> on State<W> {
  final Set<String> _selected = <String>{};
  bool _selectionMode = false;

  /// The ids that are ticked now.
  Set<String> get selectedIds => Set<String>.unmodifiable(_selected);

  /// Whether the list is in selection mode.
  bool get selectionMode => _selectionMode;

  /// Whether at least one id is ticked.
  bool get hasSelection => _selected.isNotEmpty;

  /// Whether [id] is ticked.
  bool isSelected(String id) => _selected.contains(id);

  /// Enters or leaves selection mode, clearing the ticks.
  void toggleSelectionMode() => setState(() {
    _selectionMode = !_selectionMode;
    _selected.clear();
  });

  /// Leaves selection mode and clears the ticks.
  void exitSelectionMode() {
    if (!_selectionMode && _selected.isEmpty) return;
    setState(() {
      _selectionMode = false;
      _selected.clear();
    });
  }

  /// Ticks or unticks [id].
  void toggleSelected(String id) => setState(() {
    if (!_selected.remove(id)) _selected.add(id);
  });

  /// Drops ids that no longer exist, so a stale selection cannot survive a reload and send
  /// deleted ids back to the server. Does not rebuild.
  void retainSelected(Iterable<String> existing) {
    final keep = existing.toSet();
    _selected.removeWhere((id) => !keep.contains(id));
  }
}

/// The toolbar above a batch-selectable list.
///
/// At rest it shows [restLabel] and the [restActions] next to a "select" button; in selection
/// mode it shows the selection count with a delete button, which is disabled while nothing is
/// ticked, and a cancel button. All wording is a parameter, with English defaults.
final class CharcoalBatchBar extends StatelessWidget {
  /// Creates the bar.
  const CharcoalBatchBar({
    required this.onDelete,
    required this.onToggleMode,
    required this.restLabel,
    required this.selectedCount,
    required this.selectionMode,
    this.cancelLabel = 'Cancel',
    this.deleteLabel = 'Delete selected',
    this.restActions = const <Widget>[],
    this.selectLabel = 'Select',
    this.selectedCountLabel = _defaultSelectedCountLabel,
    super.key,
  });

  /// Whether the list is in selection mode.
  final bool selectionMode;

  /// How many rows are ticked.
  final int selectedCount;

  /// The label shown at rest, e.g. "3 notifications".
  final String restLabel;

  /// Enters or leaves selection mode.
  final VoidCallback onToggleMode;

  /// Deletes the ticked rows.
  final VoidCallback onDelete;

  /// The cancel button label in selection mode.
  final String cancelLabel;

  /// The delete button label.
  final String deleteLabel;

  /// Actions available only at rest, typically the create button.
  final List<Widget> restActions;

  /// The button label that enters selection mode.
  final String selectLabel;

  /// The count text in selection mode.
  final String Function(int count) selectedCountLabel;

  static String _defaultSelectedCountLabel(int count) => '$count selected';

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Loose flexes: the buttons may wrap onto several lines on a narrow screen, and neither
        // side takes space the other needs.
        Flexible(
          child: Text(
            selectionMode ? selectedCountLabel(selectedCount) : restLabel,
            style: theme.style(CharcoalTextRole.body, color: theme.colors.textTertiary),
          ),
        ),
        SizedBox(width: theme.space.md),
        Flexible(
          flex: 2,
          child: Wrap(
            spacing: theme.space.sm,
            runSpacing: theme.space.sm,
            alignment: WrapAlignment.end,
            children: selectionMode
                ? <Widget>[
                    CharcoalButton(
                      variant: CharcoalButtonVariant.danger,
                      size: CharcoalButtonSize.small,
                      leading: const CharcoalIcon(CharcoalIcons.delete),
                      // Disabled instead of scolding with a toast after the fact.
                      onPressed: selectedCount == 0 ? null : onDelete,
                      child: Text(deleteLabel),
                    ),
                    CharcoalButton(
                      size: CharcoalButtonSize.small,
                      onPressed: onToggleMode,
                      child: Text(cancelLabel),
                    ),
                  ]
                : <Widget>[
                    CharcoalButton(
                      size: CharcoalButtonSize.small,
                      onPressed: onToggleMode,
                      child: Text(selectLabel),
                    ),
                    ...restActions,
                  ],
          ),
        ),
      ],
    );
  }
}
