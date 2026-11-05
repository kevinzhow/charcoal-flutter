import 'package:flutter/widgets.dart';

/// Makes the text below it selectable and copyable with pointer and keyboard.
///
/// Uses the widgets-level selection region with no platform handles or toolbar, which suits
/// identifiers and values in dense admin views.
final class CharcoalSelectable extends StatelessWidget {
  /// Wraps [child].
  const CharcoalSelectable({required this.child, super.key});

  /// The content to make selectable.
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SelectableRegion(selectionControls: emptyTextSelectionControls, child: child);
}
