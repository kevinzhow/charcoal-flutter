import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../layout/section_inset.dart';
import '../status/tone_fill.dart';

/// A full-width bar across the top edge of the app that marks a special mode, such as acting as
/// a shared super user: a leading icon, the bold [title], an optional [message] and trailing
/// [actions] such as the way out of the mode.
///
/// It is filled with the [tone]'s solid colour and has no radius or outline, so it spans the
/// window edge to edge; put it above the page (the first child of the scaffold body's `Column`),
/// not inside the content. For a message inside the content, use `CharcoalBanner`. On a narrow
/// bar the message wraps under the title. The bar is one container announced by its [title]; the
/// message and the actions stay readable and focusable inside it.
///
/// The same bar with only a [title] heads a card that belongs to the mode, such as its sign-in
/// card: put it first in a flush, untitled `CharcoalSectionCard`, which clips it to the card's
/// corners.
///
/// ```dart
/// CharcoalModeBar(
///   title: 'Super-user mode',
///   message: 'Every action here is recorded as the super user.',
///   actions: [
///     CharcoalButton(size: CharcoalButtonSize.small, onPressed: exit, child: Text('Exit')),
///   ],
/// )
/// ```
final class CharcoalModeBar extends StatelessWidget {
  /// Creates a mode bar titled [title].
  const CharcoalModeBar({
    required this.title,
    this.message,
    this.actions = const <Widget>[],
    this.icon = CharcoalIcons.warnTriangle,
    this.tone = CharcoalTone.notice,
    super.key,
  });

  /// The name of the mode, in bold.
  final String title;

  /// What the mode means for the user, in caption text after the title.
  final String? message;

  /// Trailing actions, usually small buttons such as "Exit".
  final List<Widget> actions;

  /// The leading icon, drawn in the colour for icons on the [tone]'s fill.
  final CharcoalIconData icon;

  /// The colour family whose solid fill the bar takes.
  final CharcoalTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final colors = charcoalToneFill(theme.colors, tone);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: title,
      child: ColoredBox(
        color: colors.fill,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final inset = charcoalSectionInset(theme, constraints.maxWidth);
            // At least a compact row high, so a bar with or without a button keeps its size.
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: theme.sizes.rowMinHeightCompact),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: inset, vertical: space.sm),
                child: Row(
                  children: <Widget>[
                    CharcoalIcon(icon, size: theme.sizes.iconMd, color: colors.icon),
                    SizedBox(width: space.md),
                    Expanded(
                      child: Wrap(
                        spacing: space.md,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          // The container already reads the title.
                          ExcludeSemantics(
                            child: Text(
                              title,
                              style: theme.style(CharcoalTextRole.bodyBold, color: colors.text),
                            ),
                          ),
                          if (message case final message?)
                            Text(
                              message,
                              style: theme.style(CharcoalTextRole.caption, color: colors.text),
                            ),
                        ],
                      ),
                    ),
                    if (actions.isNotEmpty) ...<Widget>[
                      SizedBox(width: space.md),
                      // At most half the bar, so a long label or a large text scale shortens the
                      // actions instead of pushing them past the window edge.
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: (constraints.maxWidth - inset * 2) / 2,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: space.sm,
                          runSpacing: space.sm,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: actions,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
