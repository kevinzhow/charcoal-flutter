import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';

enum CharcoalDialogSize { small, medium, large }

Future<T?> showCharcoalDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss dialog',
}) {
  final theme = CharcoalTheme.of(context);
  return showGeneralDialog<T>(
    barrierColor: theme.colors.backgroundOverlay,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => CharcoalTheme(
      data: theme,
      child: Builder(builder: builder),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: CharcoalMotion.emphasizedCurve),
      child: child,
    ),
    transitionDuration: theme.components.button.animationDuration,
  );
}

/// A token-driven dialog surface intended for [showCharcoalDialog].
final class CharcoalDialog extends StatelessWidget {
  const CharcoalDialog({
    required this.title,
    required this.child,
    this.actions = const <Widget>[],
    this.size = CharcoalDialogSize.medium,
    super.key,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final CharcoalDialogSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final maxWidth = switch (size) {
      CharcoalDialogSize.small => theme.dimensions.paragraphWidth.s,
      CharcoalDialogSize.medium => theme.dimensions.space.layout100,
      CharcoalDialogSize.large => theme.dimensions.paragraphWidth.l,
    };
    final horizontalPadding = theme.dimensions.space.component30;
    return Semantics(
      container: true,
      label: title,
      namesRoute: true,
      scopesRoute: true,
      explicitChildNodes: true,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.dimensions.space.component40,
            vertical: theme.dimensions.space.component50,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.xxl),
                color: theme.colors.containerDefault,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: theme.dimensions.space.layout60,
                    child: Center(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.bodyBold.copyWith(color: theme.colors.textDefault),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      theme.dimensions.space.component50,
                    ),
                    child: DefaultTextStyle(
                      style: theme.textStyles.body.copyWith(color: theme.colors.textDefault),
                      child: child,
                    ),
                  ),
                  if (actions.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          for (var index = 0; index < actions.length; index++) ...<Widget>[
                            if (index > 0) SizedBox(height: theme.dimensions.space.component20),
                            actions[index],
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
