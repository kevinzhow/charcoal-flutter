import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Fades [child] while it is pressed: the tap feedback of a `CharcoalClickable` region that is
/// not a card or a control, such as an author header or an artwork tile.
///
/// Pass the clickable's builder states. The fade uses `metrics.clickable.pressedOpacity` over
/// `motion.fast` and never changes the child's bounds.
///
/// ```dart
/// CharcoalClickable(
///   onPressed: openProfile,
///   semanticLabel: 'Open Aki Kondo profile',
///   builder: (context, states) => CharcoalPressFeedback(states: states, child: header),
/// )
/// ```
final class CharcoalPressFeedback extends StatelessWidget {
  /// Fades [child] for [states].
  const CharcoalPressFeedback({required this.child, required this.states, super.key});

  /// The pressable content.
  final Widget child;

  /// The interaction states of the enclosing clickable.
  final Set<WidgetState> states;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return AnimatedOpacity(
      duration: theme.duration(context, theme.motion.fast),
      opacity: states.contains(WidgetState.pressed) ? theme.metrics.clickable.pressedOpacity : 1,
      child: child,
    );
  }
}
