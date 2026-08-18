import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'typography.dart';

abstract final class _HintSpec {
  static const actionStackBreakpoint = 240.0;
  static const infoIconColor = Color(0xFF858585);
  static const iconSize = 16.0;
  static const textSize = 14.0;
}

final class _HintInfoIcon extends StatelessWidget {
  const _HintInfoIcon();

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const _HintInfoIconPainter(),
  );
}

final class _HintInfoIconPainter extends CustomPainter {
  const _HintInfoIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Exact vector transcription of Charcoal iOS's 16/Info.pdf asset.
    canvas
      ..save()
      ..scale(size.width / _HintSpec.iconSize, size.height / _HintSpec.iconSize);
    final fill = Paint()..color = _HintSpec.infoIconColor;
    final ring = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(const Rect.fromLTWH(0, 0, 16, 16))
      ..addOval(const Rect.fromLTWH(2, 2, 12, 12));
    canvas
      ..drawPath(ring, fill)
      ..drawCircle(const Offset(8, 5), 1.25, fill)
      ..drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTRB(7, 6.75, 9, 12.25),
          const Radius.circular(1),
        ),
        fill,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_HintInfoIconPainter oldDelegate) => false;
}

/// Informational copy on a semantic secondary container.
///
/// Use this for advisory page or section guidance, not validation or error
/// feedback. When an [action] no longer fits beside scaled copy, it moves below
/// the message while remaining the directional trailing action.
final class CharcoalHintText extends StatelessWidget {
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

  final Widget? action;
  final Alignment alignment;
  final Widget child;
  final Widget? icon;
  final double? maxWidth;
  final Widget? subtitle;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final theme = CharcoalTheme.of(context);
    final horizontalPadding = theme.dimensions.space.component30;
    final verticalPadding = theme.dimensions.space.component25;
    final contentGap = theme.dimensions.space.component10;
    final message = DefaultTextStyle(
      style: charcoalTypographyStyle(
        context,
        color: theme.colors.textDefault,
        size: CharcoalTypographySize.size14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          child,
          ?subtitle,
        ],
      ),
    );
    final leadingContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox.square(
          dimension: _HintSpec.iconSize,
          child: IconTheme(
            data: IconThemeData(
              color: theme.colors.iconDefault,
              size: _HintSpec.iconSize,
            ),
            child: icon ?? const _HintInfoIcon(),
          ),
        ),
        SizedBox(width: contentGap),
        Flexible(fit: FlexFit.loose, child: message),
      ],
    );
    final expands = action != null || maxWidth == double.infinity;
    final actionWidget = action;
    final scaledFontSize = MediaQuery.textScalerOf(
      context,
    ).scale(_HintSpec.textSize);
    final scaleFactor = (scaledFontSize / _HintSpec.textSize).clamp(1.0, 2.0);

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
            availableContentWidth < _HintSpec.actionStackBreakpoint * scaleFactor;
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
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerSecondaryDefault,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? double.infinity,
                ),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }
}
