import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalHintContext { section, page }

/// Informational copy on a semantic secondary container.
final class CharcoalHintText extends StatelessWidget {
  const CharcoalHintText({
    required this.child,
    this.context = CharcoalHintContext.section,
    this.icon,
    super.key,
  });

  final Widget child;
  final CharcoalHintContext context;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final horizontalPadding = switch (this.context) {
      CharcoalHintContext.section => theme.dimensions.space.component30,
      CharcoalHintContext.page => theme.dimensions.space.component50,
    };
    final verticalPadding = switch (this.context) {
      CharcoalHintContext.section => theme.dimensions.space.component25,
      CharcoalHintContext.page => theme.dimensions.space.component30,
    };
    return DecoratedBox(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              IconTheme(
                data: IconThemeData(
                  color: theme.colors.iconTertiaryDefault,
                  size: theme.dimensions.space.component30,
                ),
                child: icon!,
              ),
              SizedBox(width: theme.dimensions.space.component10),
            ],
            Flexible(
              child: DefaultTextStyle(
                style: theme.textStyles.captionMedium.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
