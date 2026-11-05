import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

class _HintInfoIcon extends StatelessWidget {
  const _HintInfoIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _HintInfoIconPainter(color, size));
}

class _HintInfoIconPainter extends CustomPainter {
  const _HintInfoIconPainter(this.color, this.nativeSize);

  final Color color;
  // The icon is drawn on a 16-unit grid (the Charcoal iOS 16/Info asset) and scaled to the box.
  final double nativeSize;

  @override
  void paint(Canvas canvas, Size size) {
    const grid = 16.0;
    canvas
      ..save()
      ..scale(size.width / grid, size.height / grid);
    final fill = Paint()..color = color;
    final ring = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(const Rect.fromLTWH(0, 0, grid, grid))
      ..addOval(const Rect.fromLTWH(2, 2, 12, 12));
    canvas
      ..drawPath(ring, fill)
      ..drawCircle(const Offset(8, 5), 1.25, fill)
      ..drawRRect(
        RRect.fromRectXY(const Rect.fromLTRB(7, 6.75, 9, 12.25), 1, 1),
        fill,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_HintInfoIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.nativeSize != nativeSize;
}

/// Informational copy on a semantic secondary container.
///
/// Use this for advisory page or section guidance, not validation or error feedback. When an
/// [action] no longer fits beside scaled copy, it moves below the message while remaining the
/// directional trailing action.
final class CharcoalHintText extends StatelessWidget {
  /// Shows [child] (and an optional [subtitle]) next to an info icon.
  const CharcoalHintText({
    required this.child,
    this.action,
    this.alignment = Alignment.center,
    this.icon,
    this.maxWidth,
    this.subtitle,
    this.visible = true,
    super.key,
  }) : assert(maxWidth == null || maxWidth >= 0);

  /// Trailing action, for example a link button.
  final Widget? action;

  /// Where the container sits when it is narrower than its parent.
  final Alignment alignment;

  /// The message.
  final Widget child;

  /// Replaces the default info icon.
  final Widget? icon;

  /// Upper bound of the content width.
  final double? maxWidth;

  /// A second line under the message.
  final Widget? subtitle;

  /// Whether to show the hint; hidden hints take no space.
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.hint;
    final horizontalPadding = theme.space.lg;
    final verticalPadding = theme.space.md;
    final contentGap = theme.space.xs;
    const textRole = CharcoalTextRole.size14;
    final message = DefaultTextStyle(
      style: theme.style(textRole, color: theme.colors.text),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[child, ?subtitle],
      ),
    );
    final leadingContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox.square(
          dimension: metrics.iconSize,
          child: IconTheme(
            data: IconThemeData(color: theme.colors.icon, size: metrics.iconSize),
            child: icon ?? _HintInfoIcon(color: theme.colors.iconHint, size: metrics.iconSize),
          ),
        ),
        SizedBox(width: contentGap),
        Flexible(child: message),
      ],
    );
    final expands = action != null || maxWidth == double.infinity;
    final actionWidget = action;
    final fontSize = theme.typography.spec(textRole).fontSize;
    final scaleFactor = (MediaQuery.textScalerOf(context).scale(fontSize) / fontSize).clamp(
      1.0,
      theme.metrics.field.textScaleClampMax,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        var availableContentWidth = constraints.hasBoundedWidth
            ? (constraints.maxWidth - horizontalPadding * 2).clamp(0.0, double.infinity).toDouble()
            : double.infinity;
        final configuredMaxWidth = maxWidth;
        if (configuredMaxWidth != null && configuredMaxWidth < availableContentWidth) {
          availableContentWidth = configuredMaxWidth;
        }
        final stackAction =
            actionWidget != null &&
            availableContentWidth < metrics.actionStackBreakpoint * scaleFactor;
        final content = actionWidget != null
            ? stackAction
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          heightFactor: 1,
                          child: leadingContent,
                        ),
                        SizedBox(height: contentGap),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          heightFactor: 1,
                          child: actionWidget,
                        ),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            heightFactor: 1,
                            child: leadingContent,
                          ),
                        ),
                        SizedBox(width: contentGap),
                        actionWidget,
                      ],
                    )
            : Align(
                alignment: alignment,
                heightFactor: 1,
                widthFactor: expands ? null : 1,
                child: leadingContent,
              );

        return Align(
          alignment: alignment,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.md),
              color: theme.colors.surfaceSecondary,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }
}
