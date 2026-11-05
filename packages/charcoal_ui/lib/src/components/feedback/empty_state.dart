import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';

/// A centred empty state: a large muted icon, a message and optional actions.
///
/// Sized by its content with `space.lg` side and `space.xxl` vertical padding, so it sits in a
/// page region or a dialog alike. [actions] wrap onto further lines instead of overflowing.
class CharcoalEmptyState extends StatelessWidget {
  /// Creates an empty state showing [message].
  const CharcoalEmptyState({
    required this.message,
    this.actions = const <Widget>[],
    this.icon,
    super.key,
  });

  /// The explanation.
  final String message;

  /// Buttons offering a way out, such as "Create".
  final List<Widget> actions;

  /// The large icon above the message.
  final CharcoalIconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.space.lg, vertical: theme.space.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            CharcoalIcon(icon!, size: theme.sizes.iconXl, color: theme.colors.iconDisabled),
            CharcoalGap.vertical(CharcoalSpace.sm),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.style(CharcoalTextRole.body, color: theme.colors.textTertiary),
          ),
          if (actions.isNotEmpty) ...<Widget>[
            CharcoalGap.vertical(CharcoalSpace.sm),
            Wrap(
              spacing: theme.space.sm,
              runSpacing: theme.space.sm,
              alignment: WrapAlignment.center,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}
