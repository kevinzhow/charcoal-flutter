import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';

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
    super.key,
  }) : assert(segments.length > 1);

  final List<CharcoalSegment<T>> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final bool fullWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final buttonTokens = theme.components.button;
    final size = buttonTokens.small;
    final children = <Widget>[
      for (final segment in segments)
        if (fullWidth)
          Expanded(child: _buildSegment(context, segment))
        else
          _buildSegment(context, segment),
    ];
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.radius),
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
    final buttonTokens = theme.components.button;
    final size = buttonTokens.small;
    final selected = segment.value == value;
    final enabled = segment.enabled && onChanged != null;
    final colors = selected ? buttonTokens.primary : buttonTokens.normal;
    return CharcoalClickable(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      onPressed: enabled ? () => onChanged!(segment.value) : null,
      semanticButton: false,
      builder: (context, states) {
        final background = colors.background.resolve(states);
        final foreground = colors.foreground.resolve(states);
        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: buttonTokens.animationDuration,
          opacity: enabled ? 1 : buttonTokens.disabledOpacity,
          child: AnimatedContainer(
            duration: buttonTokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            height: size.height,
            padding: EdgeInsets.symmetric(horizontal: size.paddingHorizontal),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.radius),
              color: background,
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontFamily: theme.typography.fontFamily.sans,
                fontSize: size.fontSize,
                fontWeight: theme.typography.fontWeight.regular,
                height: size.lineHeight / size.fontSize,
                leadingDistribution: TextLeadingDistribution.even,
              ),
              child: segment.child,
            ),
          ),
        );
      },
    );
  }
}
