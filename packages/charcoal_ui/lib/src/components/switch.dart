import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';

/// A controlled Charcoal V2 switch.
final class CharcoalSwitch extends StatelessWidget {
  const CharcoalSwitch({
    required this.value,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.label,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? label;
  final String? semanticLabel;
  final WidgetStatesController? statesController;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.switchControl;
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        focusNode: focusNode,
        onPressed: onChanged == null ? null : () => onChanged!(!value),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        toggled: value,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final background = value
              ? tokens.checkedBackground.resolve(states)
              : tokens.uncheckedBackground.resolve(states);
          final thumbColor = tokens.thumbColor.resolve(states);
          final track = AnimatedContainer(
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            width: tokens.width,
            height: tokens.height,
            padding: EdgeInsets.all(tokens.borderWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radius),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(color: tokens.focusRingColor, spreadRadius: tokens.focusRingWidth),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: AnimatedAlign(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              curve: CharcoalMotion.emphasizedCurve,
              duration: tokens.animationDuration,
              child: SizedBox(
                width: tokens.thumbSize,
                height: tokens.thumbSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radius),
                    color: thumbColor,
                  ),
                ),
              ),
            ),
          );
          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: tokens.animationDuration,
            opacity: disabled ? tokens.disabledOpacity : 1,
            child: _SwitchContent(track: track, label: label),
          );
        },
      ),
    );
  }
}

final class _SwitchContent extends StatelessWidget {
  const _SwitchContent({required this.track, required this.label});

  final Widget track;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final labelTokens = theme.components.switchControl.label;
    if (label == null) {
      return track;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        track,
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
