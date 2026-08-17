part of '../bloom.dart';

final class _BloomHomePage extends StatelessWidget {
  const _BloomHomePage({required this.viewModel});

  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final posts = state.data.posts
        .where((post) {
          if (state.data.hiddenPostIds.contains(post.id)) return false;
          return switch (state.feed) {
            BloomFeed.following =>
              (post.creatorId != 'mina' &&
                      state.data.followedCreatorIds.contains(post.creatorId)) ||
                  (post.creatorId == 'mina' &&
                      post.meta.startsWith('Just now')),
            BloomFeed.forYou => post.audience == BloomAudience.everyone,
          };
        })
        .toList(growable: false);
    return _bloomPagePadding(
      context,
      Column(
        key: ValueKey<String>('agent-social-feed-${state.feed.name}'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalSegmentedControl<BloomFeed>(
            key: const ValueKey<String>('agent-social-feed-control'),
            fullWidth: true,
            onChanged: viewModel.changeFeed,
            segments: const <CharcoalSegment<BloomFeed>>[
              CharcoalSegment(
                value: BloomFeed.following,
                child: Text('Following'),
              ),
              CharcoalSegment(value: BloomFeed.forYou, child: Text('For you')),
            ],
            semanticLabel: 'Bloom feed',
            value: state.feed,
          ),
          if (state.feed == BloomFeed.following) ...<Widget>[
            SizedBox(height: space.component30),
            Row(
              children: <Widget>[
                const Expanded(child: _BloomSectionTitle(title: 'Your circle')),
                Text(
                  '${state.data.conversations.length} new moments',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ],
            ),
            SizedBox(height: space.component20),
            Row(
              children: <Widget>[
                for (final creator in state.data.creators) ...<Widget>[
                  Expanded(
                    child: _BloomStoryAvatar(
                      creator: creator,
                      onPressed: () => viewModel.openStory(creator.id),
                    ),
                  ),
                  if (creator != state.data.creators.last)
                    SizedBox(width: space.component20),
                ],
              ],
            ),
          ] else ...<Widget>[
            SizedBox(height: space.component25),
            Text(
              'Ideas selected from the topics and creators you explore.',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textSecondaryDefault,
              ),
            ),
          ],
          SizedBox(height: space.component30),
          if (posts.isEmpty)
            const _BloomEmptyState(
              description:
                  'Try the other feed or restore a hidden post from the latest message.',
              icon: CharcoalIcons.home,
              title: 'No posts here right now',
            )
          else
            for (var index = 0; index < posts.length; index++) ...<Widget>[
              _BloomPostCard(
                onComment: () => viewModel.openComments(posts[index].id),
                onCreator: posts[index].creatorId == 'mina'
                    ? null
                    : () => viewModel.openCreator(posts[index].creatorId),
                onFollow: () => viewModel.toggleFollow(posts[index].creatorId),
                onLike: () => viewModel.toggleLike(posts[index].id),
                onMore: () =>
                    showBloomPostActions(context, viewModel, posts[index]),
                onSave: () => viewModel.toggleSave(posts[index].id),
                post: posts[index],
                showFollow: state.feed == BloomFeed.forYou,
                state: state,
              ),
              if (index + 1 < posts.length) SizedBox(height: space.component30),
            ],
        ],
      ),
    );
  }
}

final class _BloomStoryAvatar extends StatelessWidget {
  const _BloomStoryAvatar({required this.creator, required this.onPressed});

  final BloomCreator creator;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: 'View ${creator.name} story',
      builder: (context, states) => AnimatedOpacity(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        opacity: states.contains(WidgetState.pressed) ? 0.64 : 1,
        child: Column(
          children: <Widget>[
            _BloomAvatar(
              initials: creator.initials,
              tone: creator.tone,
              size: 46,
            ),
            SizedBox(height: theme.dimensions.space.component10),
            Text(
              creator.name.split(' ').first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textSecondaryDefault,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showBloomPostActions(
  BuildContext context,
  BloomViewModel viewModel,
  BloomPost post,
) async {
  final hide = await showCharcoalModal<bool>(
    actions: <Widget>[
      CharcoalButton(
        key: const ValueKey<String>('agent-social-hide-post'),
        fullWidth: true,
        onPressed: () => Navigator.of(context).pop(true),
        variant: CharcoalButtonVariant.danger,
        child: const Text('Hide post'),
      ),
    ],
    child: const _BloomModalMessage(
      'You will stop seeing this post. You can undo this immediately.',
    ),
    context: context,
    maxWidth: 360,
    style: CharcoalModalStyle.bottomSheet,
    title: 'Post options',
    useRootNavigator: false,
  );
  if (hide != true || !context.mounted) return;
  viewModel.hidePost(post.id);
  showCharcoalSnackBar(
    action: CharcoalButton(
      onPressed: () => viewModel.restorePost(post.id),
      size: CharcoalButtonSize.small,
      child: const Text('Undo'),
    ),
    context: context,
    maxWidth: 360,
    message: 'Post hidden from this feed',
    useRootOverlay: false,
  );
}
