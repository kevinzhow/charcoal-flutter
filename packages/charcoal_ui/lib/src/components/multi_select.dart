import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';

enum CharcoalMultiSelectVariant { normal, overlay }

/// A controlled Charcoal V2 multi-selection control.
///
/// Unlike `CharcoalCheckbox`, this component uses the circular, borderless
/// indicator from Charcoal's `MultiSelect` recipe. Use one instance per option
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
    final tokens = theme.components.multiSelect;
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
          final uncheckedBackground = switch (variant) {
            CharcoalMultiSelectVariant.normal => tokens.uncheckedBackground,
            CharcoalMultiSelectVariant.overlay => tokens.overlayUncheckedBackground,
          };
          final background = selected
              ? tokens.checkedBackground.resolve(states)
              : uncheckedBackground.resolve(states);
          final ringColor = invalid ? tokens.invalidRingColor : tokens.focusRingColor;
          final indicator = AnimatedContainer(
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            width: tokens.size,
            height: tokens.size,
            decoration: BoxDecoration(
              border: variant == CharcoalMultiSelectVariant.overlay
                  ? Border.all(
                      color: tokens.overlayBorderColor,
                      width: tokens.overlayBorderWidth,
                    )
                  : null,
              borderRadius: BorderRadius.circular(tokens.radius),
              boxShadow: focused || invalid
                  ? <BoxShadow>[
                      BoxShadow(color: ringColor, spreadRadius: tokens.focusRingWidth),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: selected
                ? Center(
                    child: CharcoalIcon(
                      CharcoalIcons.check,
                      color: tokens.checkColor.resolve(states),
                      size: tokens.size * 0.72,
                    ),
                  )
                : null,
          );

          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: tokens.animationDuration,
            opacity: disabled ? tokens.disabledOpacity : 1,
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
    final labelTokens = theme.components.multiSelect.label;
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
