import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalDialogSize { small, medium, large }

enum CharcoalModalStyle { center, bottomSheet }

Future<T?> showCharcoalDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss dialog',
  Duration? duration,
  CharcoalModalStyle style = CharcoalModalStyle.center,
}) {
  assert(duration == null || !duration.isNegative);
  final theme = CharcoalTheme.of(context);
  final tokens = theme.components.modal;
  return showGeneralDialog<T>(
    barrierColor: tokens.barrierColor.withValues(alpha: tokens.barrierOpacity),
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => CharcoalTheme(
      data: theme,
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                if (barrierDismissible) Navigator.of(context).maybePop();
                return null;
              },
            ),
          },
          child: Builder(builder: builder),
        ),
      ),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      );
      if (reduceMotion) return FadeTransition(opacity: curved, child: child);
      return switch (style) {
        CharcoalModalStyle.center => FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: tokens.centerScale,
              end: 1,
            ).animate(curved),
            child: child,
          ),
        ),
        CharcoalModalStyle.bottomSheet => FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ),
      };
    },
    transitionDuration: duration ?? tokens.animationDuration,
  );
}

/// Convenience API that constructs the correctly paired route and surface.
Future<T?> showCharcoalModal<T>({
  required BuildContext context,
  required Widget child,
  List<Widget> actions = const <Widget>[],
  bool barrierDismissible = true,
  Widget? closeIcon,
  Duration? duration,
  double? maxWidth,
  CharcoalDialogSize size = CharcoalDialogSize.medium,
  CharcoalModalStyle style = CharcoalModalStyle.center,
  String? title,
}) => showCharcoalDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  duration: duration,
  style: style,
  builder: (dialogContext) => CharcoalDialog(
    actions: actions,
    closeIcon: closeIcon,
    maxWidth: maxWidth,
    onDismiss: barrierDismissible ? () => Navigator.of(dialogContext).maybePop() : null,
    showCloseButton: barrierDismissible,
    size: size,
    style: style,
    title: title,
    child: child,
  ),
);

/// The Charcoal modal surface used for centered dialogs and bottom sheets.
final class CharcoalDialog extends StatelessWidget {
  const CharcoalDialog({
    required this.child,
    this.actions = const <Widget>[],
    this.closeIcon,
    this.contentPadding = EdgeInsets.zero,
    this.maxWidth,
    this.onDismiss,
    this.showCloseButton = false,
    this.size = CharcoalDialogSize.medium,
    this.style = CharcoalModalStyle.center,
    this.title,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  final List<Widget> actions;
  final Widget child;
  final Widget? closeIcon;
  final EdgeInsetsGeometry contentPadding;
  final double? maxWidth;
  final VoidCallback? onDismiss;
  final bool showCloseButton;
  final CharcoalDialogSize size;
  final CharcoalModalStyle style;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.modal;
    final media = MediaQuery.of(context);
    final resolvedMaxWidth =
        maxWidth ??
        switch (size) {
          CharcoalDialogSize.small => theme.dimensions.paragraphWidth.s,
          CharcoalDialogSize.medium => tokens.defaultMaxWidth,
          CharcoalDialogSize.large => theme.dimensions.paragraphWidth.l,
        };
    final bottomActionPadding = style == CharcoalModalStyle.center
        ? tokens.actionPadding
        : math.max(
            media.padding.bottom,
            tokens.bottomSheetMinBottomPadding,
          );
    final radius = Radius.circular(tokens.radius);
    final borderRadius = switch (style) {
      CharcoalModalStyle.center => BorderRadius.all(radius),
      CharcoalModalStyle.bottomSheet => BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
    };
    final surface = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: tokens.minWidth,
        maxWidth: resolvedMaxWidth,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: tokens.backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (title case final title?)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.titlePaddingHorizontal,
                        vertical: tokens.titlePaddingVertical,
                      ),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textStyles.headingXxxs.copyWith(
                          color: theme.colors.textDefaultText1,
                          fontSize: tokens.titleFontSize,
                          fontWeight: tokens.titleFontWeight,
                          height: tokens.titleLineHeight / tokens.titleFontSize,
                        ),
                      ),
                    ),
                  Padding(padding: contentPadding, child: child),
                  if (actions.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        tokens.actionPadding,
                        tokens.actionPadding,
                        tokens.actionPadding,
                        bottomActionPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          for (var index = 0; index < actions.length; index++) ...<Widget>[
                            if (index > 0) SizedBox(height: tokens.actionGap),
                            actions[index],
                          ],
                        ],
                      ),
                    ),
                ],
              ),
              if (showCloseButton && onDismiss != null)
                Semantics(
                  button: true,
                  label: 'Close',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onDismiss,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox.square(
                        dimension: tokens.closeSize,
                        child: Center(
                          child: IconTheme(
                            data: IconThemeData(
                              color: theme.colors.iconDefault,
                              size: tokens.closeIconSize,
                            ),
                            child:
                                closeIcon ??
                                CustomPaint(
                                  painter: _ClosePainter(
                                    color: theme.colors.iconDefault,
                                    inset: tokens.closeStrokeInset,
                                    strokeWidth: tokens.closeStrokeWidth,
                                  ),
                                  size: Size.square(tokens.closeIconSize),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    return Semantics(
      container: true,
      label: title,
      namesRoute: true,
      scopesRoute: true,
      explicitChildNodes: true,
      child: Align(
        alignment: style == CharcoalModalStyle.center ? Alignment.center : Alignment.bottomCenter,
        child: Padding(
          padding: style == CharcoalModalStyle.center
              ? EdgeInsets.all(tokens.centerEdgePadding)
              : EdgeInsets.zero,
          child: surface,
        ),
      ),
    );
  }
}

final class _ClosePainter extends CustomPainter {
  const _ClosePainter({
    required this.color,
    required this.inset,
    required this.strokeWidth,
  });

  final Color color;
  final double inset;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(
        Offset(inset, inset),
        Offset(size.width - inset, size.height - inset),
        paint,
      )
      ..drawLine(
        Offset(size.width - inset, inset),
        Offset(inset, size.height - inset),
        paint,
      );
  }

  @override
  bool shouldRepaint(_ClosePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.inset != inset ||
      oldDelegate.strokeWidth != strokeWidth;
}
