import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _SegmentedControlSpec {
  static const uniformSegmentMinWidth = 80.0;
}

final class CharcoalSegment<T> {
  const CharcoalSegment({required this.value, required this.child, this.enabled = true});

  final T value;
  final Widget child;
  final bool enabled;
}

/// A controlled, single-selection segmented control.
final class CharcoalSegmentedControl<T> extends StatelessWidget {
  const CharcoalSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.fullWidth = false,
    this.semanticLabel,
    this.uniformSegmentWidth = false,
    super.key,
  }) : assert(segments.length > 1);

  final List<CharcoalSegment<T>> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final bool fullWidth;
  final String? semanticLabel;
  final bool uniformSegmentWidth;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final children = <Widget>[
      for (final segment in segments)
        if (fullWidth)
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _SegmentedControlSpec.uniformSegmentMinWidth,
              ),
              child: _buildSegment(context, segment),
            ),
          )
        else if (uniformSegmentWidth)
          SizedBox(
            width: _SegmentedControlSpec.uniformSegmentMinWidth,
            child: _buildSegment(context, segment),
          )
        else
          _buildSegment(context, segment),
    ];
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.dimensions.radius.xl),
          color: theme.colors.containerSecondaryDefaultA,
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
    final selected = segment.value == value;
    final enabled = segment.enabled && onChanged != null;
    return CharcoalClickable(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      onPressed: enabled ? () => onChanged!(segment.value) : null,
      semanticButton: false,
      builder: (context, states) {
        return Opacity(
          opacity: enabled ? 1 : charcoalDisabledOpacity,
          child: Container(
            height: theme.dimensions.space.targetS,
            padding: EdgeInsets.symmetric(
              horizontal: theme.dimensions.space.component30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                theme.dimensions.radius.xl,
              ),
              color: selected ? theme.colors.containerPrimaryDefault : null,
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: charcoalTypographyStyle(
                context,
                color: selected
                    ? theme.colors.textOnPrimaryDefault
                    : theme.colors.textSecondaryDefault,
                size: CharcoalTypographySize.size14,
              ),
              child: segment.child,
            ),
          ),
        );
      },
    );
  }
}
