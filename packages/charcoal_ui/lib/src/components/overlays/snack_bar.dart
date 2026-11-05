import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';
import 'toast_presentation.dart';

/// A bordered Charcoal snack bar, optionally with a square thumbnail.
///
/// Wider and quieter than a toast: a page-coloured pill with a hairline border. Present one with
/// [showCharcoalSnackBar]; it can be dragged towards its edge to dismiss.
final class CharcoalSnackBar extends StatelessWidget {
  /// Creates a snack bar showing [message].
  const CharcoalSnackBar({
    required this.message,
    this.action,
    this.maxWidth,
    this.semanticLabel,
    this.thumbnail,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  /// A trailing widget, usually a text button.
  final Widget? action;

  /// Overrides `metrics.toast.maxWidth`.
  final double? maxWidth;

  /// The single-line text.
  final String message;

  /// Semantics label; defaults to [message].
  final String? semanticLabel;

  /// An image before the message, cropped to a square of `metrics.toast.thumbnailSize`.
  final Widget? thumbnail;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.toast;
    final radius = BorderRadius.circular(metrics.cornerRadius);
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? metrics.maxWidth),
        child: ClipRRect(
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.border, width: theme.borders.hairline),
              borderRadius: radius,
              color: theme.colors.background,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (thumbnail case final thumbnail?)
                  SizedBox.square(
                    dimension: theme.metrics.toast.thumbnailSize,
                    child: FittedBox(fit: BoxFit.cover, child: thumbnail),
                  ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.space.lg,
                      vertical: theme.space.md,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.style(CharcoalTextRole.size14, bold: true),
                          ),
                        ),
                        if (action case final action?) ...<Widget>[
                          CharcoalGap.horizontal(CharcoalSpace.lg),
                          action,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inserts a draggable [CharcoalSnackBar] into an overlay and removes it after [duration].
///
/// [duration] defaults to `motion.toastVisible`; zero keeps the snack bar until the returned
/// controller dismisses it or the user drags it away. Set [useRootOverlay] to false when [context]
/// belongs to a deliberately bounded nested overlay.
CharcoalToastController showCharcoalSnackBar({
  required BuildContext context,
  required String message,
  Widget? action,
  CharcoalToastAnimationConfiguration animationConfiguration =
      CharcoalToastAnimationConfiguration.defaultConfiguration,
  Duration? duration,
  CharcoalPopupEdge edge = CharcoalPopupEdge.bottom,
  double? maxWidth,
  String? semanticLabel,
  double? screenEdgeSpacing,
  Widget? thumbnail,
  bool useRootOverlay = true,
}) {
  final theme = CharcoalTheme.of(context);
  return insertCharcoalPopup(
    animationConfiguration: animationConfiguration,
    context: context,
    draggable: true,
    duration: duration ?? theme.motion.toastVisible,
    edge: edge,
    screenEdgeSpacing: screenEdgeSpacing ?? theme.metrics.toast.snackBarScreenEdgeSpacing,
    useRootOverlay: useRootOverlay,
    child: CharcoalSnackBar(
      action: action,
      maxWidth: maxWidth,
      message: message,
      semanticLabel: semanticLabel,
      thumbnail: thumbnail,
    ),
  );
}
