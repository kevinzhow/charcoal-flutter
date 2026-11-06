import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// One message of a conversation.
///
/// An [outgoing] message (sent by the current person) is filled with the primary colour; an
/// incoming one is page-coloured with a hairline outline. The bubble grows with its text up to
/// `sizes.messageBubbleMaxWidth` and then wraps. The caller aligns the bubble (end for outgoing,
/// start for incoming) and owns sender names, timestamps and delivery status.
final class CharcoalMessageBubble extends StatelessWidget {
  /// Shows [text].
  const CharcoalMessageBubble(this.text, {this.outgoing = false, super.key});

  /// The message.
  final String text;

  /// Whether the current person sent the message.
  final bool outgoing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: theme.sizes.messageBubbleMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: outgoing
              ? null
              : Border.all(color: colors.borderSubtle, width: theme.borders.hairline),
          borderRadius: BorderRadius.circular(theme.radius.md),
          color: outgoing ? colors.primary : colors.background,
        ),
        child: Padding(
          padding: EdgeInsets.all(theme.space.sm),
          child: Text(
            text,
            style: theme.style(
              CharcoalTextRole.captionMedium,
              color: outgoing ? colors.textOnPrimary : colors.text,
            ),
          ),
        ),
      ),
    );
  }
}
