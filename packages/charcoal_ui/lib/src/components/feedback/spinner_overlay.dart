import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'loading_spinner.dart';

/// Centers a Charcoal spinner over [child] while [visible] is true.
///
/// By default the overlay intercepts input, matching the iOS modifier. Set
/// [interactionPassthrough] only for background work where the underlying
/// content remains safe to use. A blocking overlay also removes the child from
/// keyboard focus and accessibility traversal until loading finishes.
final class CharcoalSpinnerOverlay extends StatelessWidget {
  const CharcoalSpinnerOverlay({
    required this.child,
    required this.visible,
    this.dimBackground = false,
    this.interactionPassthrough = false,
    this.semanticLabel = 'Loading',
    this.spinnerSize,
    this.transparentBackground = false,
    super.key,
  }) : assert(semanticLabel != ''),
       assert(spinnerSize == null || spinnerSize > 0);

  /// The content the spinner covers.
  final Widget child;

  /// Whether to dim the content with `colors.scrim` while loading (myopay's busy overlay).
  final bool dimBackground;

  /// Whether the content stays interactive while loading.
  final bool interactionPassthrough;

  /// Semantics label of the spinner.
  final String semanticLabel;

  /// Edge of the spinner circle; defaults to `sizes.controlLg`.
  final double? spinnerSize;

  /// Whether the spinner's own surface is transparent.
  final bool transparentBackground;

  /// Whether the spinner is shown.
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final spinner = Center(
      child: CharcoalLoadingSpinner(
        semanticLabel: semanticLabel,
        size: spinnerSize,
        transparent: transparentBackground,
      ),
    );
    final blocksInteraction = visible && !interactionPassthrough;
    return Stack(
      children: <Widget>[
        ExcludeFocus(
          excluding: blocksInteraction,
          child: ExcludeSemantics(
            excluding: blocksInteraction,
            child: child,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: interactionPassthrough || !visible,
            child: AnimatedSwitcher(
              duration: theme.duration(context, theme.motion.overlay),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: visible
                  ? Listener(
                      key: const ValueKey<String>('charcoal-spinner-overlay'),
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: (_) {},
                      child: dimBackground
                          ? ColoredBox(color: theme.colors.scrim, child: spinner)
                          : spinner,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
