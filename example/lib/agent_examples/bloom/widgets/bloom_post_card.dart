part of '../bloom.dart';

final class _BloomPostCard extends StatelessWidget {
  const _BloomPostCard({
    required this.onComment,
    required this.onCreator,
    required this.onFollow,
    required this.onLike,
    required this.onMore,
    required this.onSave,
    required this.post,
    required this.state,
    this.showFollow = false,
  });

  final VoidCallback onComment;
  final VoidCallback? onCreator;
  final VoidCallback? onFollow;
  final VoidCallback onLike;
  final VoidCallback onMore;
  final VoidCallback onSave;
  final BloomPost post;
  final BloomViewState state;
  final bool showFollow;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final author = _bloomAuthor(state.data, post.creatorId);
    final liked = state.data.likedPostIds.contains(post.id);
    final saved = state.data.savedPostIds.contains(post.id);
    final followed = state.data.followedCreatorIds.contains(post.creatorId);
    return _BloomSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(space.md),
            child: Row(
              children: <Widget>[
                _BloomAvatar(
                  initials: author.initials,
                  tone: author.tone,
                  size: 38,
                ),
                SizedBox(width: space.sm),
                Expanded(
                  child: CharcoalClickable(
                    onPressed: onCreator,
                    semanticLabel: onCreator == null
                        ? null
                        : 'Open ${author.name} profile',
                    builder: (context, states) => AnimatedOpacity(
                      duration: CharcoalTheme.of(context).duration(
                        context,
                        CharcoalTheme.of(context).motion.fast,
                      ),
                      opacity: states.contains(WidgetState.pressed) ? 0.64 : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme
                                .style(CharcoalTextRole.captionMediumBold)
                                .copyWith(color: theme.colors.text),
                          ),
                          Text(
                            post.meta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme
                                .style(CharcoalTextRole.caption)
                                .copyWith(color: theme.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: space.xs),
                CharcoalIconButton(
                  key: ValueKey<String>('agent-social-post-actions-${post.id}'),
                  icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),
                  onPressed: onMore,
                  semanticLabel: 'More actions for ${author.name} post',
                  size: CharcoalIconButtonSize.small,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: space.md),
            child: Text(
              post.copy,
              style: theme
                  .style(CharcoalTextRole.captionMedium)
                  .copyWith(color: theme.colors.text),
            ),
          ),
          if (showFollow && post.creatorId != 'mina') ...<Widget>[
            SizedBox(height: space.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: space.md),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: CharcoalButton(
                  key: ValueKey<String>(
                    'agent-social-follow-${post.creatorId}',
                  ),
                  onPressed: onFollow,
                  selected: followed,
                  size: CharcoalButtonSize.small,
                  child: Text(followed ? 'Following' : 'Follow'),
                ),
              ),
            ),
          ],
          SizedBox(height: space.sm),
          _BloomArtwork(altText: post.altText, height: 174, tone: post.tone),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: space.sm,
              vertical: space.xs,
            ),
            child: Row(
              children: <Widget>[
                CharcoalIconButton(
                  key: ValueKey<String>('agent-social-like-${post.id}'),
                  icon: const CharcoalIcon(CharcoalIcons.heart),
                  onPressed: onLike,
                  selected: liked,
                  semanticLabel: liked ? 'Unlike post' : 'Like post',
                  size: CharcoalIconButtonSize.small,
                ),
                Text(
                  '${post.likes + (liked ? 1 : 0)}',
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(
                        color: theme.colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(width: space.sm),
                CharcoalIconButton(
                  key: ValueKey<String>('agent-social-comment-${post.id}'),
                  icon: const CharcoalIcon(CharcoalIcons.message),
                  onPressed: onComment,
                  semanticLabel: 'Comment on post',
                  size: CharcoalIconButtonSize.small,
                ),
                Text(
                  '${post.comments}',
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(
                        color: theme.colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                CharcoalIconButton(
                  key: ValueKey<String>('agent-social-save-${post.id}'),
                  icon: const CharcoalIcon(CharcoalIcons.bookmark),
                  onPressed: onSave,
                  selected: saved,
                  semanticLabel: saved ? 'Remove bookmark' : 'Bookmark post',
                  size: CharcoalIconButtonSize.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
