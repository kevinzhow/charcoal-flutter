import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import '../actions/control_support.dart';

/// A controlled switch with the 51 x 31 track and 27 px thumb of Charcoal iOS.
///
/// The geometry is Charcoal's, not Material's `Switch` default. [onChanged] requests the next
/// value without mutating [value]; a null callback disables the switch. The optional [label]
/// precedes the track. Disabled dims only the track: the label keeps its colour.
final class CharcoalSwitch extends StatelessWidget {
  /// Creates a switch.
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

  /// Whether the switch is on.
  final bool value;

  /// Requests the next value; null disables the switch.
  final ValueChanged<bool>? onChanged;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// A label before the track.
  final Widget? label;

  /// Semantics label; when set it replaces the label of [label].
  final String? semanticLabel;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.switchToggle;
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
          final duration = theme.duration(context, theme.motion.standard);
          final background = value
              ? resolveCharcoalStateColor(
                  states,
                  normal: colors.primary,
                  hovered: colors.primaryHover,
                  pressed: colors.primaryPress,
                )
              : resolveCharcoalStateColor(
                  states,
                  normal: colors.neutral,
                  hovered: colors.neutralHover,
                  pressed: colors.neutralPress,
                );
          final trackSurface = AnimatedContainer(
            duration: duration,
            curve: theme.motion.curve,
            width: metrics.trackWidth,
            height: metrics.trackHeight,
            padding: EdgeInsets.all(metrics.trackInset),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.pill),
              boxShadow: charcoalHaloShadow(theme, visible: states.contains(WidgetState.focused)),
              color: background,
            ),
            child: AnimatedAlign(
              alignment: value ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
              curve: theme.motion.emphasizedCurve,
              duration: duration,
              child: SizedBox(
                width: metrics.thumbSize,
                height: metrics.thumbSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.radius.pill),
                    color: colors.iconOnPrimary,
                  ),
                ),
              ),
            ),
          );
          final track = Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.space.xs),
            child: CharcoalDisabledFade(
              disabled: states.contains(WidgetState.disabled),
              child: trackSurface,
            ),
          );
          if (label == null) return track;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(child: CharcoalControlLabel(child: label!)),
              const CharcoalGap.horizontal(CharcoalSpace.sm),
              track,
            ],
          );
        },
      ),
    );
  }
}
