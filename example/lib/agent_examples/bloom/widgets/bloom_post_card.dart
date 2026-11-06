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
    final author = _bloomAuthor(state.data, post.creatorId);
    final liked = state.data.likedPostIds.contains(post.id);
    final saved = state.data.savedPostIds.contains(post.id);
    final followed = state.data.followedCreatorIds.contains(post.creatorId);
    return _BloomSurface(
      padding: const CharcoalInset.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalPadding.all(
            CharcoalSpace.md,
            child: Row(
              children: <Widget>[
                _BloomAvatar(
                  initials: author.initials,
                  tone: author.tone,
                  size: CharcoalAvatarSize.regular,
                ),
                const CharcoalGap(CharcoalSpace.sm),
                Expanded(
                  child: CharcoalClickable(
                    onPressed: onCreator,
                    semanticLabel: onCreator == null
                        ? null
                        : 'Open ${author.name} profile',
                    builder: (context, states) => CharcoalPressFeedback(
                      states: states,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CharcoalText(
                            author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            role: CharcoalTextRole.captionMediumBold,
                            tone: CharcoalTextTone.primary,
                          ),
                          CharcoalText(
                            post.meta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            role: CharcoalTextRole.caption,
                            tone: CharcoalTextTone.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const CharcoalGap(CharcoalSpace.xs),
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
          CharcoalPadding(
            padding: const CharcoalInset.symmetric(
              horizontal: CharcoalSpace.md,
            ),
            child: CharcoalText(
              post.copy,
              role: CharcoalTextRole.captionMedium,
              tone: CharcoalTextTone.primary,
            ),
          ),
          if (showFollow && post.creatorId != 'mina') ...<Widget>[
            const CharcoalGap(CharcoalSpace.sm),
            CharcoalPadding(
              padding: const CharcoalInset.symmetric(
                horizontal: CharcoalSpace.md,
              ),
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
          const CharcoalGap(CharcoalSpace.sm),
          _BloomArtwork(altText: post.altText, tone: post.tone),
          CharcoalPadding(
            padding: const CharcoalInset.symmetric(
              horizontal: CharcoalSpace.sm,
              vertical: CharcoalSpace.xs,
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
                CharcoalText(
                  '${post.likes + (liked ? 1 : 0)}',
                  bold: true,
                  role: CharcoalTextRole.caption,
                  tone: CharcoalTextTone.secondary,
                ),
                const CharcoalGap(CharcoalSpace.sm),
                CharcoalIconButton(
                  key: ValueKey<String>('agent-social-comment-${post.id}'),
                  icon: const CharcoalIcon(CharcoalIcons.message),
                  onPressed: onComment,
                  semanticLabel: 'Comment on post',
                  size: CharcoalIconButtonSize.small,
                ),
                CharcoalText(
                  '${post.comments}',
                  bold: true,
                  role: CharcoalTextRole.caption,
                  tone: CharcoalTextTone.secondary,
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
