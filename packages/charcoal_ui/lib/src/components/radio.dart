import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _RadioSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const controlSize = 20.0;
  static const dotSize = 8.0;
  static const focusRingWidth = 4.0;
}

/// A controlled Charcoal V2 radio option.
///
/// [invalid] is reflected visually and through input validation semantics.
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
        validationResult: invalid
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final background = _selected
              ? resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerPrimaryDefault,
                  hovered: theme.colors.containerPrimaryHover,
                  pressed: theme.colors.containerPrimaryPress,
                )
              : resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerDefault,
                  hovered: theme.colors.containerHover,
                  pressed: theme.colors.containerPress,
                );
          final ringColor = invalid ? theme.colors.borderNegative : theme.colors.borderFocusLegacy;
          final indicator = AnimatedContainer(
            duration: CharcoalMotion.resolveDuration(
              context,
              _RadioSpec.animationDuration,
            ),
            curve: CharcoalMotion.standardCurve,
            width: _RadioSpec.controlSize,
            height: _RadioSpec.controlSize,
            decoration: BoxDecoration(
              border: _selected
                  ? null
                  : Border.all(
                      color: theme.colors.borderDefault,
                      width: theme.dimensions.borderWidth.l,
                    ),
              borderRadius: BorderRadius.circular(
                theme.dimensions.radius.oval,
              ),
              boxShadow: focused || invalid
                  ? <BoxShadow>[
                      BoxShadow(
                        color: ringColor,
                        spreadRadius: _RadioSpec.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: Center(
              child: AnimatedContainer(
                duration: CharcoalMotion.resolveDuration(
                  context,
                  _RadioSpec.animationDuration,
                ),
                width: _selected ? _RadioSpec.dotSize : 0,
                height: _selected ? _RadioSpec.dotSize : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.oval,
                  ),
                  color: resolveCharcoalStateColor(
                    states,
                    normal: theme.colors.iconOnPrimaryDefault,
                    hovered: theme.colors.iconOnPrimaryHover,
                    pressed: theme.colors.iconOnPrimaryPress,
                  ),
                ),
              ),
            ),
          );
          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              _RadioSpec.animationDuration,
            ),
            opacity: disabled ? charcoalDisabledOpacity : 1,
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
            style: charcoalTypographyStyle(
              context,
              color: theme.colors.textDefault,
              size: CharcoalTypographySize.size14,
            ),
            child: label!,
          ),
        ),
      ],
    );
  }
}
