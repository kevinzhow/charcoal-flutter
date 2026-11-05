part of '../bloom.dart';

final class _BloomTopicTile extends StatelessWidget {
  const _BloomTopicTile({required this.onPressed, required this.topic});

  final VoidCallback onPressed;
  final BloomTopic topic;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: 'Open ${topic.label} collection',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalTheme.of(context)
            .duration(context, CharcoalTheme.of(context).motion.fast),
        padding: EdgeInsets.all(space.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: states.contains(WidgetState.hovered)
                ? theme.colors.border
                : theme.colors.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(theme.radius.md),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.fillSecondaryPress
              : theme.colors.background,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    topic.label,
                    style: theme
                        .style(CharcoalTextRole.captionMediumBold)
                        .copyWith(color: theme.colors.text),
                  ),
                  SizedBox(height: space.xs),
                  Text(
                    topic.description,
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(color: theme.colors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(width: space.sm),
            CharcoalIcon(
              CharcoalIcons.chevronRight,
              color: theme.colors.iconSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return _BloomSurface(
      child: Row(
        children: <Widget>[
          Expanded(
            child: CharcoalClickable(
              onPressed: onOpen,
              semanticLabel: 'Open ${creator.name} profile',
              builder: (context, states) => AnimatedOpacity(
                duration: CharcoalTheme.of(context)
                    .duration(context, CharcoalTheme.of(context).motion.fast),
                opacity: states.contains(WidgetState.pressed) ? 0.64 : 1,
                child: Row(
                  children: <Widget>[
                    _BloomAvatar(
                      initials: creator.initials,
                      tone: creator.tone,
                      size: 42,
                    ),
                    SizedBox(width: space.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            creator.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme
                                .style(CharcoalTextRole.captionMediumBold)
                                .copyWith(color: theme.colors.text),
                          ),
                          Text(
                            creator.handle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme
                                .style(CharcoalTextRole.caption)
                                .copyWith(color: theme.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: space.sm),
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
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel:
          '${creator.name}, ${conversation.unread ? 'unread, ' : ''}${conversation.preview}',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalTheme.of(context)
            .duration(context, CharcoalTheme.of(context).motion.fast),
        padding: EdgeInsets.all(space.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSubtle),
          borderRadius: BorderRadius.circular(theme.radius.md),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.fillSecondaryPress
              : conversation.unread
              ? theme.colors.surfaceSecondary
              : theme.colors.background,
        ),
        child: Row(
          children: <Widget>[
            _BloomAvatar(
              initials: creator.initials,
              tone: creator.tone,
              size: 44,
            ),
            SizedBox(width: space.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          creator.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme
                              .style(CharcoalTextRole.captionMediumBold)
                              .copyWith(color: theme.colors.text),
                        ),
                      ),
                      Text(
                        conversation.time,
                        style: theme
                            .style(CharcoalTextRole.caption)
                            .copyWith(color: theme.colors.textTertiary),
                      ),
                    ],
                  ),
                  SizedBox(height: space.xs),
                  Text(
                    conversation.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(
                          color: theme.colors.textSecondary,
                          fontWeight: conversation.unread
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _BloomNotificationTile extends StatelessWidget {
  const _BloomNotificationTile({
    required this.notification,
    required this.onPressed,
  });

  final BloomNotification notification;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel:
          '${notification.unread ? 'Unread. ' : ''}${notification.description}',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalTheme.of(context)
            .duration(context, CharcoalTheme.of(context).motion.fast),
        padding: EdgeInsets.all(space.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSubtle),
          borderRadius: BorderRadius.circular(theme.radius.md),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.fillSecondaryPress
              : notification.unread
              ? theme.colors.surfaceSecondary
              : theme.colors.background,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharcoalIcon(
              notification.kind == BloomNotificationKind.likedPost
                  ? CharcoalIcons.heart
                  : CharcoalIcons.personAdd,
              color: theme.colors.iconSecondary,
              size: 20,
            ),
            SizedBox(width: space.sm),
            Expanded(
              child: Text(
                notification.description,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(
                      color: theme.colors.text,
                      fontWeight: notification.unread
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
              ),
            ),
            SizedBox(width: space.sm),
            Text(
              notification.time,
              style: theme
                  .style(CharcoalTextRole.caption)
                  .copyWith(color: theme.colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
