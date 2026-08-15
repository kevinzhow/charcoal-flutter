import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalHintContext { section, page }

/// Informational copy on a semantic secondary container.
final class CharcoalHintText extends StatelessWidget {
  const CharcoalHintText({
    required this.child,
    this.action,
    this.alignment = Alignment.center,
    this.context = CharcoalHintContext.section,
    this.icon,
    this.maxWidth,
    this.subtitle,
    this.visible = true,
    super.key,
  });

  final Widget? action;
  final Alignment alignment;
  final Widget child;
  final CharcoalHintContext context;
  final Widget? icon;
  final double? maxWidth;
  final Widget? subtitle;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.hint;
    final horizontalPadding = switch (this.context) {
      CharcoalHintContext.section => tokens.paddingHorizontal,
      CharcoalHintContext.page => theme.dimensions.space.component50,
    };
    final verticalPadding = switch (this.context) {
      CharcoalHintContext.section => tokens.paddingVertical,
      CharcoalHintContext.page => theme.dimensions.space.component30,
    };
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
            color: tokens.backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: this.context == CharcoalHintContext.page
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: tokens.iconColor,
                      size: tokens.iconSize,
                    ),
                    child: icon!,
                  ),
                  SizedBox(width: tokens.gap),
                ],
                Flexible(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: tokens.foregroundColor,
                      fontFamily: theme.typography.fontFamily.sans,
                      fontSize: tokens.fontSize,
                      fontWeight: tokens.fontWeight,
                      height: tokens.lineHeight / tokens.fontSize,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        child,
                        ?subtitle,
                      ],
                    ),
                  ),
                ),
                if (action case final action?) ...<Widget>[
                  SizedBox(width: tokens.actionGap),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
