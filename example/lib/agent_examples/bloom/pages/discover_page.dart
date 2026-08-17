part of '../bloom.dart';

final class _BloomDiscoverPage extends StatefulWidget {
  const _BloomDiscoverPage({required this.viewModel});

  final BloomViewModel viewModel;

  @override
  State<_BloomDiscoverPage> createState() => _BloomDiscoverPageState();
}

final class _BloomDiscoverPageState extends State<_BloomDiscoverPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.viewModel.state.discoverQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final query = state.discoverQuery.trim().toLowerCase();
    final matchingTopics = state.data.topics
        .where((topic) {
          return topic.label.toLowerCase().contains(query) ||
              topic.description.toLowerCase().contains(query);
        })
        .toList(growable: false);
    final matchingCreators = state.data.creators
        .where((creator) {
          return creator.name.toLowerCase().contains(query) ||
              creator.handle.toLowerCase().contains(query) ||
              creator.bio.toLowerCase().contains(query);
        })
        .toList(growable: false);
    final hasResults = matchingTopics.isNotEmpty || matchingCreators.isNotEmpty;

    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-discover-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Find an idea, then follow it into real work and people.',
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component25),
          CharcoalTextField(
            key: const ValueKey<String>('agent-social-discover-search'),
            controller: _searchController,
            onChanged: widget.viewModel.updateDiscoverQuery,
            placeholder: 'Search topics and creators',
            prefix: const CharcoalIcon(CharcoalIcons.search),
          ),
          SizedBox(height: space.component30),
          if (query.isEmpty) ...<Widget>[
            const _BloomSectionTitle(title: 'Explore topics'),
            SizedBox(height: space.component20),
            for (
              var index = 0;
              index < state.data.topics.length;
              index++
            ) ...<Widget>[
              _BloomTopicTile(
                onPressed: () =>
                    widget.viewModel.openTopic(state.data.topics[index].id),
                topic: state.data.topics[index],
              ),
              if (index + 1 < state.data.topics.length)
                SizedBox(height: space.component20),
            ],
            SizedBox(height: space.component30),
            const _BloomSectionTitle(title: 'Creators to know'),
            SizedBox(height: space.component20),
            _creatorResults(state, state.data.creators, space),
          ] else if (!hasResults) ...<Widget>[
            _BloomEmptyState(
              description:
                  'No topics or creators match “${state.discoverQuery.trim()}”. Try a broader word.',
              title: 'Nothing found yet',
            ),
            SizedBox(height: space.component20),
            CharcoalButton(
              fullWidth: true,
              onPressed: () {
                _searchController.clear();
                widget.viewModel.clearDiscoverQuery();
              },
              child: const Text('Clear search'),
            ),
          ] else ...<Widget>[
            Text(
              '${matchingTopics.length + matchingCreators.length} results for “${state.discoverQuery.trim()}”',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textSecondaryDefault,
              ),
            ),
            if (matchingTopics.isNotEmpty) ...<Widget>[
              SizedBox(height: space.component25),
              const _BloomSectionTitle(title: 'Topics'),
              SizedBox(height: space.component20),
              for (
                var index = 0;
                index < matchingTopics.length;
                index++
              ) ...<Widget>[
                _BloomTopicTile(
                  onPressed: () =>
                      widget.viewModel.openTopic(matchingTopics[index].id),
                  topic: matchingTopics[index],
                ),
                if (index + 1 < matchingTopics.length)
                  SizedBox(height: space.component20),
              ],
            ],
            if (matchingCreators.isNotEmpty) ...<Widget>[
              SizedBox(height: space.component30),
              const _BloomSectionTitle(title: 'Creators'),
              SizedBox(height: space.component20),
              _creatorResults(state, matchingCreators, space),
            ],
          ],
        ],
      ),
    );
  }

  Widget _creatorResults(
    BloomViewState state,
    List<BloomCreator> creators,
    CharcoalSpaceTokens space,
  ) => Column(
    children: <Widget>[
      for (var index = 0; index < creators.length; index++) ...<Widget>[
        _BloomCreatorTile(
          creator: creators[index],
          followed: state.data.followedCreatorIds.contains(creators[index].id),
          onFollow: () => widget.viewModel.toggleFollow(creators[index].id),
          onOpen: () => widget.viewModel.openCreator(creators[index].id),
        ),
        if (index + 1 < creators.length) SizedBox(height: space.component20),
      ],
    ],
  );
}

final class _BloomTopicPage extends StatelessWidget {
  const _BloomTopicPage({
    required this.topicId,
    required this.viewModel,
    super.key,
  });

  final String topicId;
  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final topic = state.data.topic(topicId);
    final posts = state.data.posts
        .where((post) => post.topicId == topic.id)
        .toList(growable: false);
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-topic-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            topic.description,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            '${posts.length} ${posts.length == 1 ? 'post' : 'posts'} in this collection',
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
            ),
          ),
          SizedBox(height: space.component30),
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
              showFollow: posts[index].creatorId != 'mina',
              state: state,
            ),
            if (index + 1 < posts.length) SizedBox(height: space.component30),
          ],
        ],
      ),
    );
  }
}

final class _BloomCreatorPage extends StatelessWidget {
  const _BloomCreatorPage({
    required this.creatorId,
    required this.viewModel,
    super.key,
  });

  final String creatorId;
  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final creator = state.data.creator(creatorId);
    final followed = state.data.followedCreatorIds.contains(creator.id);
    final posts = state.data.posts
        .where((post) => post.creatorId == creator.id)
        .toList(growable: false);
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-creator-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: _BloomAvatar(
              initials: creator.initials,
              size: 72,
              tone: creator.tone,
            ),
          ),
          SizedBox(height: space.component20),
          Text(
            creator.handle,
            textAlign: TextAlign.center,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            creator.location,
            textAlign: TextAlign.center,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
            ),
          ),
          SizedBox(height: space.component25),
          Text(
            creator.bio,
            textAlign: TextAlign.center,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component25),
          Row(
            children: <Widget>[
              Expanded(
                child: CharcoalButton(
                  fullWidth: true,
                  onPressed: () => viewModel.toggleFollow(creator.id),
                  selected: followed,
                  variant: followed
                      ? CharcoalButtonVariant.normal
                      : CharcoalButtonVariant.primary,
                  child: Text(followed ? 'Following' : 'Follow'),
                ),
              ),
              SizedBox(width: space.component20),
              Expanded(
                child: CharcoalButton(
                  fullWidth: true,
                  leading: const CharcoalIcon(CharcoalIcons.message),
                  onPressed: () =>
                      viewModel.openConversationForCreator(creator.id),
                  child: const Text('Message'),
                ),
              ),
            ],
          ),
          SizedBox(height: space.component30),
          _BloomSurface(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _BloomMetric(
                  label: 'Followers',
                  value: '${creator.followers + (followed ? 1 : 0)}',
                ),
                _BloomMetric(label: 'Posts', value: '${posts.length}'),
              ],
            ),
          ),
          SizedBox(height: space.component30),
          const _BloomSectionTitle(title: 'Recent work'),
          SizedBox(height: space.component20),
          if (posts.isEmpty)
            const _BloomEmptyState(
              description: 'New work from this creator will appear here.',
              icon: CharcoalIcons.image,
              title: 'No posts yet',
            )
          else
            for (var index = 0; index < posts.length; index++) ...<Widget>[
              _BloomPostCard(
                onComment: () => viewModel.openComments(posts[index].id),
                onCreator: null,
                onFollow: null,
                onLike: () => viewModel.toggleLike(posts[index].id),
                onMore: () =>
                    showBloomPostActions(context, viewModel, posts[index]),
                onSave: () => viewModel.toggleSave(posts[index].id),
                post: posts[index],
                state: state,
              ),
              if (index + 1 < posts.length) SizedBox(height: space.component30),
            ],
        ],
      ),
    );
  }
}

final class _BloomPostDetailPage extends StatelessWidget {
  const _BloomPostDetailPage({
    required this.postId,
    required this.viewModel,
    super.key,
  });

  final String postId;
  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final post = state.data.post(postId);
    return _bloomPagePadding(
      context,
      _BloomPostCard(
        onComment: () => viewModel.openComments(post.id),
        onCreator: post.creatorId == 'mina'
            ? null
            : () => viewModel.openCreator(post.creatorId),
        onFollow: () => viewModel.toggleFollow(post.creatorId),
        onLike: () => viewModel.toggleLike(post.id),
        onMore: () => showBloomPostActions(context, viewModel, post),
        onSave: () => viewModel.toggleSave(post.id),
        post: post,
        showFollow: post.creatorId != 'mina',
        state: state,
      ),
    );
  }
}
