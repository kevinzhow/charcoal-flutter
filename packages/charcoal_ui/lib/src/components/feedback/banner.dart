import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';

/// An inline banner: tone icon, message, optional trailing action.
///
/// Covers gates, empty-credential notices and inline errors. With a [title] the banner becomes two
/// lines, a bold title over a quieter message. A [filled] banner is tinted with the [tone]'s
/// surface (grey for [CharcoalTone.neutral]); an unfilled one is a hairline-outlined box. The
/// banner is announced as a live region so an error that appears is read out.
///
/// ```dart
/// CharcoalBanner(
///   tone: CharcoalTone.notice,
///   icon: CharcoalIcons.alert,
///   message: 'Your trial ends tomorrow.',
///   action: CharcoalButton(size: CharcoalButtonSize.small, onPressed: upgrade, child: Text('Upgrade')),
/// )
/// ```
class CharcoalBanner extends StatelessWidget {
  /// Creates a banner showing [message].
  const CharcoalBanner({
    required this.message,
    this.action,
    this.filled = true,
    this.icon,
    this.title,
    this.tone = CharcoalTone.neutral,
    super.key,
  });

  /// The body text.
  final String message;

  /// A trailing widget, usually a small button.
  final Widget? action;

  /// Whether the banner is tinted (true) or only outlined (false).
  final bool filled;

  /// A leading icon, coloured by [tone].
  final CharcoalIconData? icon;

  /// A bold first line; makes the banner two-line.
  final String? title;

  /// The status colour family.
  final CharcoalTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.tone(tone);
    final neutral = tone == CharcoalTone.neutral;
    final background = neutral ? theme.colors.backgroundSecondary : colors.surface;
    final messageColor = neutral ? theme.colors.textSecondary : colors.foreground;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.lg,
          vertical: theme.space.md,
        ),
        decoration: BoxDecoration(
          color: filled ? background : null,
          border: filled
              ? null
              : Border.all(
                  color: theme.colors.borderSubtle,
                  width: theme.borders.hairline,
                ),
          borderRadius: BorderRadius.circular(theme.radius.md),
        ),
        child: Row(
          crossAxisAlignment: title == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              CharcoalIcon(icon!, size: theme.sizes.iconLg, color: colors.icon),
              CharcoalGap.horizontal(CharcoalSpace.md),
            ],
            Expanded(
              child: title == null
                  ? Text(
                      message,
                      style: theme.style(
                        CharcoalTextRole.body,
                        color: messageColor,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title!,
                          style: theme.style(CharcoalTextRole.bodyBold),
                        ),
                        Text(
                          message,
                          style: theme.style(CharcoalTextRole.caption),
                        ),
                      ],
                    ),
            ),
            if (action != null) ...<Widget>[
              CharcoalGap.horizontal(CharcoalSpace.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
