import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';

/// One option of a [CharcoalSegmentedControl].
final class CharcoalSegment<T> {
  /// Creates a segment for [value] showing [child].
  const CharcoalSegment({required this.value, required this.child, this.enabled = true});

  /// The value reported when the segment is chosen.
  final T value;

  /// The label, usually a `Text`; it is styled by the control.
  final Widget child;

  /// Whether this segment can be chosen.
  final bool enabled;
}

/// A controlled, single-selection segmented control: a pill track with the chosen segment filled.
///
/// Selection is atomic: the previous and next segment change in the same frame as [value]. The
/// layout is intrinsic by default, [uniformSegmentWidth] gives every segment the same minimum
/// width and [fullWidth] spreads the segments across the parent. A null [onChanged] disables the
/// whole control.
final class CharcoalSegmentedControl<T> extends StatelessWidget {
  /// Creates a segmented control; at least two [segments] are required.
  const CharcoalSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.fullWidth = false,
    this.semanticLabel,
    this.uniformSegmentWidth = false,
    super.key,
  }) : assert(segments.length > 1);

  /// The options, in display order.
  final List<CharcoalSegment<T>> segments;

  /// The currently selected value.
  final T value;

  /// Reports the chosen value; null disables the control.
  final ValueChanged<T>? onChanged;

  /// Whether the control fills the width its parent offers.
  final bool fullWidth;

  /// Semantics label of the group.
  final String? semanticLabel;

  /// Whether every segment gets the same width.
  final bool uniformSegmentWidth;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final minWidth = theme.metrics.segmented.uniformSegmentMinWidth;
    final children = <Widget>[
      for (final segment in segments)
        if (fullWidth)
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: _buildSegment(context, segment),
            ),
          )
        else if (uniformSegmentWidth)
          SizedBox(width: minWidth, child: _buildSegment(context, segment))
        else
          _buildSegment(context, segment),
    ];
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radius.xl),
          color: theme.colors.fillSecondary,
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSegment(BuildContext context, CharcoalSegment<T> segment) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final selected = segment.value == value;
    final enabled = segment.enabled && onChanged != null;
    return CharcoalClickable(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      onPressed: enabled ? () => onChanged!(segment.value) : null,
      semanticButton: false,
      builder: (context, states) {
        return Opacity(
          opacity: enabled ? 1 : theme.metrics.clickable.disabledOpacity,
          child: Container(
            height: theme.sizes.controlSm,
            padding: EdgeInsets.symmetric(horizontal: theme.space.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.xl),
              color: selected ? colors.primary : null,
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.style(
                CharcoalTextRole.size14,
                color: selected ? colors.textOnPrimary : colors.textSecondary,
              ),
              child: segment.child,
            ),
          ),
        );
      },
    );
  }
}
