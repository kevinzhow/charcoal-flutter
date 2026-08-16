import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'typography.dart';

enum CharcoalHintContext { section, page }

abstract final class _HintSpec {
  static const iconSize = 16.0;
  static const pageHorizontalPadding = 32.0;
}

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
    final horizontalPadding = switch (this.context) {
      CharcoalHintContext.section => theme.dimensions.space.component30,
      CharcoalHintContext.page => _HintSpec.pageHorizontalPadding,
    };
    final verticalPadding = switch (this.context) {
      CharcoalHintContext.section => theme.dimensions.space.component25,
      CharcoalHintContext.page => theme.dimensions.space.component30,
    };
    final contentGap = theme.dimensions.space.component10;
    final actionGap = theme.dimensions.space.component20;
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
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
            child: Row(
              mainAxisAlignment: this.context == CharcoalHintContext.page
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: theme.colors.iconDefault,
                      size: _HintSpec.iconSize,
                    ),
                    child: icon!,
                  ),
                  SizedBox(width: contentGap),
                ],
                Flexible(
                  child: DefaultTextStyle(
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
                  ),
                ),
                if (action case final action?) ...<Widget>[
                  SizedBox(width: actionGap),
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
