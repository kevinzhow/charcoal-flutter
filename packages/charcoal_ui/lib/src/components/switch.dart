import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _SwitchSpec {
  static const animationDuration = Duration(milliseconds: 200);

  // UISwitch geometry used by Charcoal's SwiftUI wrapper.
  static const trackWidth = 51.0;
  static const trackHeight = 31.0;
  static const trackInset = 2.0;
  static const thumbSize = 27.0;
  static const focusRingWidth = 4.0;
}

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
    final horizontalTrackPadding = theme.dimensions.space.component10;
    final labelGap = theme.dimensions.space.component20;
    final radius = theme.dimensions.radius.oval;
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
              ? resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerPrimaryDefault,
                  hovered: theme.colors.containerPrimaryHover,
                  pressed: theme.colors.containerPrimaryPress,
                )
              : resolveCharcoalStateColor(
                  states,
                  normal: theme.colors.containerNeutralDefault,
                  hovered: theme.colors.containerNeutralHover,
                  pressed: theme.colors.containerNeutralPress,
                );
          final thumbColor = resolveCharcoalStateColor(
            states,
            normal: theme.colors.iconOnPrimaryDefault,
            hovered: theme.colors.iconOnPrimaryHover,
            pressed: theme.colors.iconOnPrimaryPress,
          );
          final trackSurface = AnimatedContainer(
            duration: CharcoalMotion.resolveDuration(
              context,
              _SwitchSpec.animationDuration,
            ),
            curve: CharcoalMotion.standardCurve,
            width: _SwitchSpec.trackWidth,
            height: _SwitchSpec.trackHeight,
            padding: const EdgeInsets.all(_SwitchSpec.trackInset),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: theme.colors.borderFocusLegacy,
                        spreadRadius: _SwitchSpec.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: AnimatedAlign(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              curve: CharcoalMotion.emphasizedCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                _SwitchSpec.animationDuration,
              ),
              child: SizedBox(
                width: _SwitchSpec.thumbSize,
                height: _SwitchSpec.thumbSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: thumbColor,
                  ),
                ),
              ),
            ),
          );
          final track = Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalTrackPadding),
            child: AnimatedOpacity(
              curve: CharcoalMotion.standardCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                _SwitchSpec.animationDuration,
              ),
              opacity: disabled ? charcoalDisabledOpacity : 1,
              child: trackSurface,
            ),
          );
          return _SwitchContent(
            label: label,
            labelGap: labelGap,
            track: track,
          );
        },
      ),
    );
  }
}

final class _SwitchContent extends StatelessWidget {
  const _SwitchContent({
    required this.label,
    required this.labelGap,
    required this.track,
  });

  final Widget? label;
  final double labelGap;
  final Widget track;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    if (label == null) {
      return track;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
        SizedBox(width: labelGap),
        track,
      ],
    );
  }
}
