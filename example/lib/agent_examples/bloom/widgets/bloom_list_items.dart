part of '../bloom.dart';

final class _BloomTopicTile extends StatelessWidget {
  const _BloomTopicTile({required this.onPressed, required this.topic});

  final VoidCallback onPressed;
  final BloomTopic topic;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: 'Open ${topic.label} collection',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        padding: EdgeInsets.all(space.component25),
        decoration: BoxDecoration(
          border: Border.all(
            color: states.contains(WidgetState.hovered)
                ? theme.colors.borderDefault
                : theme.colors.borderSecondary,
          ),
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.containerSecondaryPressA
              : theme.colors.backgroundDefault,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    topic.label,
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  ),
                  SizedBox(height: space.component10),
                  Text(
                    topic.description,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: space.component20),
            CharcoalIcon(
              CharcoalIcons.chevronRight,
              color: theme.colors.iconSecondaryDefault,
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
    final space = theme.dimensions.space;
    return _BloomSurface(
      child: Row(
        children: <Widget>[
          Expanded(
            child: CharcoalClickable(
              onPressed: onOpen,
              semanticLabel: 'Open ${creator.name} profile',
              builder: (context, states) => AnimatedOpacity(
                duration: CharcoalMotion.resolveDuration(
                  context,
                  CharcoalMotion.fast,
                ),
                opacity: states.contains(WidgetState.pressed) ? 0.64 : 1,
                child: Row(
                  children: <Widget>[
                    _BloomAvatar(
                      initials: creator.initials,
                      tone: creator.tone,
                      size: 42,
                    ),
                    SizedBox(width: space.component20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            creator.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyles.captionMediumBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                          Text(
                            creator.handle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textSecondaryDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: space.component20),
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
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel:
          '${creator.name}, ${conversation.unread ? 'unread, ' : ''}${conversation.preview}',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        padding: EdgeInsets.all(space.component25),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.containerSecondaryPressA
              : conversation.unread
              ? theme.colors.containerSecondaryDefault
              : theme.colors.backgroundDefault,
        ),
        child: Row(
          children: <Widget>[
            _BloomAvatar(
              initials: creator.initials,
              tone: creator.tone,
              size: 44,
            ),
            SizedBox(width: space.component20),
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
                          style: theme.textStyles.captionMediumBold.copyWith(
                            color: theme.colors.textDefault,
                          ),
                        ),
                      ),
                      Text(
                        conversation.time,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textTertiaryDefault,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: space.component10),
                  Text(
                    conversation.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
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
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel:
          '${notification.unread ? 'Unread. ' : ''}${notification.description}',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        padding: EdgeInsets.all(space.component25),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.containerSecondaryPressA
              : notification.unread
              ? theme.colors.containerSecondaryDefault
              : theme.colors.backgroundDefault,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharcoalIcon(
              notification.kind == BloomNotificationKind.likedPost
                  ? CharcoalIcons.heart
                  : CharcoalIcons.personAdd,
              color: theme.colors.iconSecondaryDefault,
              size: 20,
            ),
            SizedBox(width: space.component20),
            Expanded(
              child: Text(
                notification.description,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textDefault,
                  fontWeight: notification.unread
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ),
            SizedBox(width: space.component20),
            Text(
              notification.time,
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textTertiaryDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
