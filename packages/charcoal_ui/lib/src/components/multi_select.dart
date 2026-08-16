import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';

abstract final class _MultiSelectSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const controlSize = 20.0;
  static const outerOffset = 2.0;
  static const checkSize = 16.0;
  static const focusRingWidth = 4.0;
  static const labelFontSize = 14.0;
  static const labelLineHeight = 22.0;
}

enum CharcoalMultiSelectVariant { normal, overlay }

/// A controlled Charcoal V2 multi-selection control.
///
/// Unlike `CharcoalCheckbox`, this component uses a circular, borderless
/// indicator. Use one instance per option
/// and keep the selected set in the parent widget.
final class CharcoalMultiSelect extends StatelessWidget {
  const CharcoalMultiSelect({
    required this.selected,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.invalid = false,
    this.label,
    this.semanticLabel,
    this.statesController,
    this.variant = CharcoalMultiSelectVariant.normal,
    super.key,
  });

  final bool selected;
  final ValueChanged<bool>? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool invalid;
  final Widget? label;
  final String? semanticLabel;
  final WidgetStatesController? statesController;
  final CharcoalMultiSelectVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        checked: selected,
        focusNode: focusNode,
        onPressed: onChanged == null ? null : () => onChanged!(!selected),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final background = selected
              ? resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerPrimaryDefault,
                  hovered: theme.colors.containerPrimaryHover,
                  pressed: theme.colors.containerPrimaryPress,
                )
              : switch (variant) {
                  CharcoalMultiSelectVariant.normal => resolveCharcoalStateColor(
                    states,
                    normal: theme.colors.containerNeutralDefault,
                    hovered: theme.colors.containerNeutralHover,
                    pressed: theme.colors.containerNeutralPress,
                  ),
                  CharcoalMultiSelectVariant.overlay => resolveCharcoalStateColor(
                    states,
                    normal: theme.colors.containerOnImgDefault,
                    hovered: theme.colors.containerNeutralHover,
                    pressed: theme.colors.containerNeutralPress,
                  ),
                };
          final overlay = variant == CharcoalMultiSelectVariant.overlay;
          final indicator = SizedBox.square(
            dimension: _MultiSelectSpec.controlSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                AnimatedContainer(
                  duration: CharcoalMotion.resolveDuration(
                    context,
                    _MultiSelectSpec.animationDuration,
                  ),
                  curve: CharcoalMotion.standardCurve,
                  width: _MultiSelectSpec.controlSize,
                  height: _MultiSelectSpec.controlSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.oval,
                    ),
                    boxShadow: focused || (invalid && !overlay)
                        ? <BoxShadow>[
                            BoxShadow(
                              color: invalid
                                  ? theme.colors.borderNegative
                                  : theme.colors.borderFocusLegacy,
                              spreadRadius: _MultiSelectSpec.focusRingWidth,
                            ),
                          ]
                        : const <BoxShadow>[],
                    color: background,
                  ),
                ),
                Positioned(
                  left: -_MultiSelectSpec.outerOffset,
                  top: -_MultiSelectSpec.outerOffset,
                  child: IgnorePointer(
                    child: Container(
                      width: theme.dimensions.space.targetXs,
                      height: theme.dimensions.space.targetXs,
                      decoration: BoxDecoration(
                        border: overlay
                            ? Border.all(
                                color: theme.colors.borderHud,
                                width: theme.dimensions.borderWidth.l,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(
                          theme.dimensions.radius.oval,
                        ),
                        boxShadow: invalid && overlay
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: theme.colors.borderNegative,
                                  spreadRadius: _MultiSelectSpec.focusRingWidth,
                                ),
                              ]
                            : const <BoxShadow>[],
                      ),
                      child: Center(
                        child: CharcoalIcon(
                          CharcoalIcons.check,
                          color: theme.colors.iconOnPrimaryDefault,
                          size: _MultiSelectSpec.checkSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              _MultiSelectSpec.animationDuration,
            ),
            opacity: disabled ? charcoalDisabledOpacity : 1,
            child: _MultiSelectContent(indicator: indicator, label: label),
          );
        },
      ),
    );
  }
}

final class _MultiSelectContent extends StatelessWidget {
  const _MultiSelectContent({required this.indicator, required this.label});

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
      children: <Widget>[
        indicator,
        SizedBox(width: theme.dimensions.space.component10),
        Flexible(
          child: DefaultTextStyle(
            style: TextStyle(
              color: theme.colors.textDefault,
              fontFamily: theme.typography.fontFamily.sans,
              fontSize: _MultiSelectSpec.labelFontSize,
              fontWeight: theme.typography.fontWeight.regular,
              height: _MultiSelectSpec.labelLineHeight / _MultiSelectSpec.labelFontSize,
              leadingDistribution: TextLeadingDistribution.even,
            ),
            child: label!,
          ),
        ),
      ],
    );
  }
}
