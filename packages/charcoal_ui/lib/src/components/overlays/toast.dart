import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';
import 'toast_presentation.dart';

/// The colour family of a [CharcoalToast].
enum CharcoalToastVariant {
  /// Green: the action worked.
  success,

  /// Red: the action failed.
  error,
}

/// A compact, coloured Charcoal notification surface.
///
/// The toast is a single line: an optional [leading] icon, the [message], and an optional [action].
/// It is announced as a live region. Show one over the current screen with [showCharcoalToast].
///
/// ```dart
/// showCharcoalToast(context: context, message: 'Saved');
/// ```
final class CharcoalToast extends StatelessWidget {
  /// Creates a toast showing [message].
  const CharcoalToast({
    required this.message,
    this.action,
    this.leading,
    this.maxWidth,
    this.semanticLabel,
    this.variant = CharcoalToastVariant.success,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  /// A trailing widget, usually a text button.
  final Widget? action;

  /// An icon before the message.
  final Widget? leading;

  /// Overrides `metrics.toast.maxWidth`.
  final double? maxWidth;

  /// The single-line text.
  final String message;

  /// Semantics label; defaults to [message].
  final String? semanticLabel;

  /// The colour family.
  final CharcoalToastVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.toast;
    final error = variant == CharcoalToastVariant.error;
    final background = error ? theme.colors.negative : theme.colors.positive;
    final foreground = error ? theme.colors.textOnNegative : theme.colors.textOnPositive;
    final textStyle = theme.style(CharcoalTextRole.size14, color: foreground, bold: true);
    final iconTheme = IconThemeData(color: foreground, size: metrics.iconSize);
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? metrics.maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.background, width: theme.borders.thick),
            borderRadius: BorderRadius.circular(metrics.cornerRadius),
            color: background,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.space.xl, vertical: theme.space.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leading case final leading?) ...<Widget>[
                  IconTheme(data: iconTheme, child: leading),
                  CharcoalGap.horizontal(CharcoalSpace.sm),
                ],
                Flexible(
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
                if (action case final action?) ...<Widget>[
                  CharcoalGap.horizontal(CharcoalSpace.sm),
                  IconTheme(
                    data: iconTheme,
                    child: DefaultTextStyle(style: textStyle, child: action),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inserts a [CharcoalToast] into an overlay and removes it after [duration].
///
/// [duration] defaults to `motion.toastVisible`; zero keeps the toast until the returned
/// controller dismisses it. Set [useRootOverlay] to false when [context] belongs to a
/// deliberately bounded nested overlay, such as an embedded app preview.
CharcoalToastController showCharcoalToast({
  required BuildContext context,
  required String message,
  Widget? action,
  CharcoalToastAnimationConfiguration animationConfiguration =
      CharcoalToastAnimationConfiguration.defaultConfiguration,
  Duration? duration,
  CharcoalPopupEdge edge = CharcoalPopupEdge.bottom,
  Widget? leading,
  double? maxWidth,
  String? semanticLabel,
  double? screenEdgeSpacing,
  CharcoalToastVariant variant = CharcoalToastVariant.success,
  bool useRootOverlay = true,
}) {
  final theme = CharcoalTheme.of(context);
  return insertCharcoalPopup(
    animationConfiguration: animationConfiguration,
    context: context,
    draggable: false,
    duration: duration ?? theme.motion.toastVisible,
    edge: edge,
    screenEdgeSpacing: screenEdgeSpacing ?? theme.metrics.toast.toastScreenEdgeSpacing,
    useRootOverlay: useRootOverlay,
    child: CharcoalToast(
      action: action,
      leading: leading,
      maxWidth: maxWidth,
      message: message,
      semanticLabel: semanticLabel,
      variant: variant,
    ),
  );
}
