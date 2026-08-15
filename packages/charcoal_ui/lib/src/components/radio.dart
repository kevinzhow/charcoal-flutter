import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';

/// A controlled Charcoal V2 radio option.
final class CharcoalRadio<T> extends StatelessWidget {
  const CharcoalRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.invalid = false,
    this.label,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool invalid;
  final Widget? label;
  final String? semanticLabel;
  final WidgetStatesController? statesController;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.radio;
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        checked: _selected,
        focusNode: focusNode,
        inMutuallyExclusiveGroup: true,
        onPressed: onChanged == null ? null : () => onChanged!(value),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final background = _selected
              ? tokens.checkedBackground.resolve(states)
              : tokens.uncheckedBackground.resolve(states);
          final borderColor = tokens.borderColor.resolve(states);
          final ringColor = invalid ? tokens.invalidRingColor : tokens.focusRingColor;
          final indicator = AnimatedContainer(
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            width: tokens.size,
            height: tokens.size,
            decoration: BoxDecoration(
              border: _selected ? null : Border.all(color: borderColor, width: tokens.borderWidth),
              borderRadius: BorderRadius.circular(tokens.radius),
              boxShadow: focused || invalid
                  ? <BoxShadow>[
                      BoxShadow(color: ringColor, spreadRadius: tokens.focusRingWidth),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: Center(
              child: AnimatedContainer(
                duration: tokens.animationDuration,
                width: _selected ? tokens.dotSize : 0,
                height: _selected ? tokens.dotSize : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(tokens.radius),
                  color: tokens.dotColor.resolve(states),
                ),
              ),
            ),
          );
          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: tokens.animationDuration,
            opacity: disabled ? tokens.disabledOpacity : 1,
            child: _RadioContent(indicator: indicator, label: label),
          );
        },
      ),
    );
  }
}

final class _RadioContent extends StatelessWidget {
  const _RadioContent({required this.indicator, required this.label});

  final Widget indicator;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final labelTokens = theme.components.radio.label;
    if (label == null) {
      return indicator;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        indicator,
        SizedBox(width: labelTokens.gap),
        Flexible(
          child: DefaultTextStyle(
            style: TextStyle(
              color: labelTokens.color,
              fontFamily: theme.typography.fontFamily.sans,
              fontSize: labelTokens.fontSize,
              fontWeight: labelTokens.fontWeight,
              height: labelTokens.lineHeight / labelTokens.fontSize,
              leadingDistribution: TextLeadingDistribution.even,
            ),
            child: label!,
          ),
        ),
      ],
    );
  }
}
