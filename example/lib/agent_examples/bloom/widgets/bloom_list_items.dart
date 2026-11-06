part of '../bloom.dart';

final class _BloomTopicTile extends StatelessWidget {
  const _BloomTopicTile({required this.onPressed, required this.topic});

  final VoidCallback onPressed;
  final BloomTopic topic;

  @override
  Widget build(BuildContext context) => CharcoalClickable(
    onPressed: onPressed,
    semanticLabel: 'Open ${topic.label} collection',
    builder: (context, states) => CharcoalCard(
      padding: const CharcoalInset.all(CharcoalSpace.md),
      raised: true,
      states: states,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalText(
                  topic.label,
                  role: CharcoalTextRole.captionMediumBold,
                  tone: CharcoalTextTone.primary,
                ),
                const CharcoalGap(CharcoalSpace.xs),
                CharcoalText(
                  topic.description,
                  role: CharcoalTextRole.caption,
                  tone: CharcoalTextTone.secondary,
                ),
              ],
            ),
          ),
          const CharcoalGap(CharcoalSpace.sm),
          const CharcoalIconView(
            CharcoalIcons.chevronRight,
            size: CharcoalIconSize.sm,
            tone: CharcoalIconTone.secondary,
          ),
        ],
      ),
    ),
  );
}

final class _BloomCreatorTile extends StatelessWidget {
  const _BloomCreatorTile({
    required this.creator,
    required this.followed,
    required this.onFollow,
    required this.onOpen,
  });

  final BloomCreator creator;
  final bool followed;
  final VoidCallback onFollow;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => _BloomSurface(
    child: Row(
      children: <Widget>[
        Expanded(
          child: CharcoalClickable(
            onPressed: onOpen,
            semanticLabel: 'Open ${creator.name} profile',
            builder: (context, states) => CharcoalPressFeedback(
              states: states,
              child: Row(
                children: <Widget>[
                  _BloomAvatar(
                    initials: creator.initials,
                    tone: creator.tone,
                    size: CharcoalAvatarSize.regular,
                  ),
                  const CharcoalGap(CharcoalSpace.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CharcoalText(
                          creator.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          role: CharcoalTextRole.captionMediumBold,
                          tone: CharcoalTextTone.primary,
                        ),
                        CharcoalText(
                          creator.handle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          role: CharcoalTextRole.caption,
                          tone: CharcoalTextTone.secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalButton(
          onPressed: onFollow,
          selected: followed,
          size: CharcoalButtonSize.small,
          child: Text(followed ? 'Following' : 'Follow'),
        ),
      ],
    ),
  );
}

final class _BloomConversationTile extends StatelessWidget {
  const _BloomConversationTile({
    required this.conversation,
    required this.creator,
    required this.onPressed,
    super.key,
  });

  final BloomConversation conversation;
  final BloomCreator creator;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => CharcoalClickable(
    onPressed: onPressed,
    semanticLabel:
        '${creator.name}, ${conversation.unread ? 'unread, ' : ''}${conversation.preview}',
    // An unread conversation is highlighted among the raised cards.
    builder: (context, states) => CharcoalCard(
      highlighted: conversation.unread,
      padding: const CharcoalInset.all(CharcoalSpace.md),
      raised: true,
      states: states,
      child: Row(
        children: <Widget>[
          _BloomAvatar(
            initials: creator.initials,
            tone: creator.tone,
            size: CharcoalAvatarSize.regular,
          ),
          const CharcoalGap(CharcoalSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CharcoalText(
                        creator.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        role: CharcoalTextRole.captionMediumBold,
                        tone: CharcoalTextTone.primary,
                      ),
                    ),
                    CharcoalText(
                      conversation.time,
                      role: CharcoalTextRole.caption,
                      tone: CharcoalTextTone.tertiary,
                    ),
                  ],
                ),
                const CharcoalGap(CharcoalSpace.xs),
                CharcoalText(
                  conversation.preview,
                  bold: conversation.unread,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  role: CharcoalTextRole.caption,
                  tone: CharcoalTextTone.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

final class _BloomNotificationTile extends StatelessWidget {
  const _BloomNotificationTile({
    required this.notification,
    required this.onPressed,
  });

  final BloomNotification notification;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => CharcoalClickable(
    onPressed: onPressed,
    semanticLabel:
        '${notification.unread ? 'Unread. ' : ''}${notification.description}',
    // An unread notification is highlighted among the raised cards.
    builder: (context, states) => CharcoalCard(
      highlighted: notification.unread,
      padding: const CharcoalInset.all(CharcoalSpace.md),
      raised: true,
      states: states,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIconView(
            notification.kind == BloomNotificationKind.likedPost
                ? CharcoalIcons.heart
                : CharcoalIcons.personAdd,
            size: CharcoalIconSize.md,
            tone: CharcoalIconTone.secondary,
          ),
          const CharcoalGap(CharcoalSpace.sm),
          Expanded(
            child: CharcoalText(
              notification.description,
              bold: notification.unread,
              role: CharcoalTextRole.caption,
              tone: CharcoalTextTone.primary,
            ),
          ),
          const CharcoalGap(CharcoalSpace.sm),
          CharcoalText(
            notification.time,
            role: CharcoalTextRole.caption,
            tone: CharcoalTextTone.tertiary,
          ),
        ],
      ),
    ),
  );
}
