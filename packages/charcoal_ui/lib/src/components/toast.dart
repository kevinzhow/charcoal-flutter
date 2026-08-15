import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalToastVariant { normal, negative }

/// A compact live-region notification surface.
final class CharcoalToast extends StatelessWidget {
  const CharcoalToast({
    required this.message,
    this.action,
    this.leading,
    this.semanticLabel,
    this.variant = CharcoalToastVariant.normal,
    super.key,
  });

  final Widget? action;
  final Widget? leading;
  final String message;
  final String? semanticLabel;
  final CharcoalToastVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final (background, foreground) = switch (variant) {
      CharcoalToastVariant.normal => (
        theme.colors.containerHudDefault,
        theme.colors.textOnHudDefault,
      ),
      CharcoalToastVariant.negative => (
        theme.colors.containerNegativeDefault,
        theme.colors.textOnNegativeDefault,
      ),
    };
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: theme.dimensions.paragraphWidth.m),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            color: background,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: theme.dimensions.space.component30,
                color: theme.colors.backgroundOverlay,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.dimensions.space.component30,
              vertical: theme.dimensions.space.component20,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: foreground,
                      size: theme.dimensions.space.component40,
                    ),
                    child: leading!,
                  ),
                  SizedBox(width: theme.dimensions.space.component20),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: theme.textStyles.captionMediumBold.copyWith(color: foreground),
                  ),
                ),
                if (action != null) ...<Widget>[
                  SizedBox(width: theme.dimensions.space.component30),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Handle returned by [showCharcoalToast].
final class CharcoalToastController {
  CharcoalToastController._(this._entry);

  OverlayEntry? _entry;
  Timer? _timer;

  bool get isShowing => _entry?.mounted ?? false;

  void dismiss() {
    _timer?.cancel();
    _timer = null;
    final entry = _entry;
    _entry = null;
    if (entry?.mounted ?? false) {
      entry!.remove();
    }
  }
}

/// Inserts a [CharcoalToast] into the nearest overlay.
CharcoalToastController showCharcoalToast({
  required BuildContext context,
  required String message,
  Widget? action,
  Duration duration = const Duration(seconds: 4),
  Widget? leading,
  String? semanticLabel,
  CharcoalToastVariant variant = CharcoalToastVariant.normal,
}) {
  final overlay = Overlay.of(context);
  final theme = CharcoalTheme.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) => Positioned(
      bottom: theme.dimensions.space.layout40,
      left: theme.dimensions.space.layout30,
      right: theme.dimensions.space.layout30,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CharcoalTheme(
          data: theme,
          child: CharcoalToast(
            action: action,
            leading: leading,
            message: message,
            semanticLabel: semanticLabel,
            variant: variant,
          ),
        ),
      ),
    ),
  );
  final controller = CharcoalToastController._(entry);
  overlay.insert(entry);
  if (duration > Duration.zero) {
    controller._timer = Timer(duration, controller.dismiss);
  }
  return controller;
}
