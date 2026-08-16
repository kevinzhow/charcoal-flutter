import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _CheckboxSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const controlSize = 20.0;
  static const roundedRadius = 10.0;
  static const checkSize = 16.0;
  static const focusRingWidth = 4.0;
  static const roundedFocusRingWidth = 6.0;
  static const outerOffset = 2.0;
  static const labelFontSize = 14.0;
  static const labelLineHeight = 20.0;
}

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
              ? resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerPrimaryDefault,
                  hovered: theme.colors.containerPrimaryHover,
                  pressed: theme.colors.containerPrimaryPress,
                )
              : rounded
              ? resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerSecondaryDefault,
                  hovered: theme.colors.containerSecondaryHover,
                  pressed: theme.colors.containerSecondaryPress,
                )
              : theme.colors.containerDefaultA;
          final checkColor = resolveCharcoalStateColor(
            states,
            normal: theme.colors.iconOnPrimaryDefault,
            hovered: theme.colors.iconOnPrimaryHover,
            pressed: theme.colors.iconOnPrimaryPress,
          );
          final ringColor = invalid ? theme.colors.borderNegative : theme.colors.borderFocusLegacy;
          final control = AnimatedContainer(
            duration: CharcoalMotion.resolveDuration(
              context,
              _CheckboxSpec.animationDuration,
            ),
            curve: CharcoalMotion.standardCurve,
            width: _CheckboxSpec.controlSize,
            height: _CheckboxSpec.controlSize,
            decoration: BoxDecoration(
              border: rounded
                  ? Border.all(
                      color: const Color(0x00000000),
                      width: theme.dimensions.borderWidth.l,
                    )
                  : value
                  ? null
                  : Border.all(
                      color: theme.colors.borderDefault,
                      width: theme.dimensions.borderWidth.l,
                    ),
              borderRadius: BorderRadius.circular(
                rounded ? _CheckboxSpec.roundedRadius : theme.dimensions.radius.s,
              ),
              boxShadow: focused || invalid
                  ? <BoxShadow>[
                      BoxShadow(
                        color: ringColor,
                        spreadRadius: rounded
                            ? _CheckboxSpec.roundedFocusRingWidth
                            : _CheckboxSpec.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: value
                ? Center(
                    child: CharcoalIcon(
                      CharcoalIcons.check,
                      color: checkColor,
                      size: _CheckboxSpec.checkSize,
                    ),
                  )
                : null,
          );
          final indicator = rounded
              ? SizedBox.square(
                  dimension: _CheckboxSpec.controlSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      control,
                      Positioned(
                        left: -_CheckboxSpec.outerOffset,
                        top: -_CheckboxSpec.outerOffset,
                        child: IgnorePointer(
                          child: Container(
                            width: theme.dimensions.space.targetXs,
                            height: theme.dimensions.space.targetXs,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFFFFFF),
                                width: theme.dimensions.borderWidth.l,
                              ),
                              borderRadius: BorderRadius.circular(
                                theme.dimensions.radius.l,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : control;

          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              _CheckboxSpec.animationDuration,
            ),
            opacity: disabled ? charcoalDisabledOpacity : 1,
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
    if (label == null) {
      return indicator;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        indicator,
        SizedBox(width: theme.dimensions.space.component10),
        Flexible(
          child: DefaultTextStyle(
            style:
                charcoalTypographyStyle(
                  context,
                  color: theme.colors.textDefault,
                  size: CharcoalTypographySize.size14,
                ).copyWith(
                  height: _CheckboxSpec.labelLineHeight / _CheckboxSpec.labelFontSize,
                ),
            child: label!,
          ),
        ),
      ],
    );
  }
}
