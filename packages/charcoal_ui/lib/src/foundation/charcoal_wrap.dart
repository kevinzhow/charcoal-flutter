import 'package:flutter/widgets.dart';

import 'layout.dart';

/// A [Wrap] whose gaps are spacing steps of the active theme.
///
/// The row of chips, tags or buttons that flows onto the next line: [spacing] separates items
/// within a line and [runSpacing] separates the lines.
class CharcoalWrap extends StatelessWidget {
  /// Lays out [children] with the given gaps.
  const CharcoalWrap({
    required this.children,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.runSpacing = CharcoalSpace.sm,
    this.spacing = CharcoalSpace.sm,
    super.key,
  });

  /// The items.
  final List<Widget> children;

  /// How the items of a line sit along the main axis.
  final WrapAlignment alignment;

  /// How the items of a line align across it.
  final WrapCrossAlignment crossAxisAlignment;

  /// The gap between lines.
  final CharcoalSpace runSpacing;

  /// The gap between items of a line.
  final CharcoalSpace spacing;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: alignment,
    crossAxisAlignment: crossAxisAlignment,
    runSpacing: runSpacing.resolve(context),
    spacing: spacing.resolve(context),
    children: children,
  );
}
