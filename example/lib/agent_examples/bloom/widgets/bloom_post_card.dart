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
    final space = theme.dimensions.space;
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
            padding: EdgeInsets.all(space.component25),
            child: Row(
              children: <Widget>[
                _BloomAvatar(
                  initials: author.initials,
                  tone: author.tone,
                  size: 38,
                ),
                SizedBox(width: space.component20),
                Expanded(
                  child: CharcoalClickable(
                    onPressed: onCreator,
                    semanticLabel: onCreator == null
                        ? null
                        : 'Open ${author.name} profile',
                    builder: (context, states) => AnimatedOpacity(
                      duration: CharcoalMotion.resolveDuration(
                        context,
                        CharcoalMotion.fast,
                      ),
                      opacity: states.contains(WidgetState.pressed) ? 0.64 : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyles.captionMediumBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                          Text(
                            post.meta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textSecondaryDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: space.component10),
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
            padding: EdgeInsets.symmetric(horizontal: space.component25),
            child: Text(
              post.copy,
              style: theme.textStyles.captionMedium.copyWith(
                color: theme.colors.textDefault,
              ),
            ),
          ),
          if (showFollow && post.creatorId != 'mina') ...<Widget>[
            SizedBox(height: space.component20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: space.component25),
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
          SizedBox(height: space.component20),
          _BloomArtwork(altText: post.altText, height: 174, tone: post.tone),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: space.component20,
              vertical: space.component10,
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
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: space.component20),
                CharcoalIconButton(
                  key: ValueKey<String>('agent-social-comment-${post.id}'),
                  icon: const CharcoalIcon(CharcoalIcons.message),
                  onPressed: onComment,
                  semanticLabel: 'Comment on post',
                  size: CharcoalIconButtonSize.small,
                ),
                Text(
                  '${post.comments}',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
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
