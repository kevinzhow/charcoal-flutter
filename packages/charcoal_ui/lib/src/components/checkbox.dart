import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';

/// A controlled Charcoal V2 checkbox.
final class CharcoalCheckbox extends StatelessWidget {
  const CharcoalCheckbox({
    required this.value,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.invalid = false,
    this.label,
    this.rounded = false,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool invalid;
  final Widget? label;
  final bool rounded;
  final String? semanticLabel;
  final WidgetStatesController? statesController;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.checkbox;
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        checked: value,
        focusNode: focusNode,
        onPressed: onChanged == null ? null : () => onChanged!(!value),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final background = value
              ? tokens.checkedBackground.resolve(states)
              : tokens.uncheckedBackground.resolve(states);
          final borderColor = tokens.borderColor.resolve(states);
          final checkColor = tokens.checkColor.resolve(states);
          final ringColor = invalid ? tokens.invalidRingColor : tokens.focusRingColor;
          final indicator = AnimatedContainer(
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            width: tokens.size,
            height: tokens.size,
            decoration: BoxDecoration(
              border: value ? null : Border.all(color: borderColor, width: tokens.borderWidth),
              borderRadius: BorderRadius.circular(rounded ? tokens.roundedRadius : tokens.radius),
              boxShadow: focused || invalid
                  ? <BoxShadow>[
                      BoxShadow(color: ringColor, spreadRadius: tokens.focusRingWidth),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: value
                ? Center(
                    child: CharcoalIcon(
                      CharcoalIcons.check,
                      color: checkColor,
                      size: tokens.size * 0.72,
                    ),
                  )
                : null,
          );

          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: tokens.animationDuration,
            opacity: disabled ? tokens.disabledOpacity : 1,
            child: _CheckboxContent(indicator: indicator, label: label),
          );
        },
      ),
    );
  }
}

final class _CheckboxContent extends StatelessWidget {
  const _CheckboxContent({required this.indicator, required this.label});

  final Widget indicator;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final labelTokens = theme.components.checkbox.label;
    if (label == null) {
      return indicator;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
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
