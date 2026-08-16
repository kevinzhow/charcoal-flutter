import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'typography.dart';

abstract final class _HintSpec {
  static const infoIconColor = Color(0xFF858585);
  static const iconSize = 16.0;
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
  });

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
    final content = actionWidget != null
        ? Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
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
            constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
            child: content,
          ),
        ),
      ),
    );
  }
}
