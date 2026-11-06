part of '../bloom.dart';

final class _BloomProfilePage extends StatelessWidget {
  const _BloomProfilePage({required this.viewModel});

  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final profile = state.data.profile;
    final ownPosts = state.data.posts
        .where((post) => post.creatorId == 'mina')
        .toList(growable: false);
    final savedPosts = state.data.posts
        .where((post) => state.data.savedPostIds.contains(post.id))
        .toList(growable: false);
    final visiblePosts = state.profileTab == BloomProfileTab.posts
        ? ownPosts
        : savedPosts;
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: _BloomAvatar(
              initials: 'MA',
              tone: profile.tone,
              size: CharcoalAvatarSize.extraLarge,
            ),
          ),
          const CharcoalGap(CharcoalSpace.sm),
          CharcoalText(
            profile.name,
            textAlign: TextAlign.center,
            role: CharcoalTextRole.headingXxs,
            tone: CharcoalTextTone.primary,
          ),
          const CharcoalGap(CharcoalSpace.xs),
          CharcoalText(
            '${profile.handle} · ${profile.location}',
            textAlign: TextAlign.center,
            role: CharcoalTextRole.caption,
            tone: CharcoalTextTone.secondary,
          ),
          const CharcoalGap(CharcoalSpace.md),
          CharcoalText(
            profile.bio.isEmpty ? 'No bio yet.' : profile.bio,
            textAlign: TextAlign.center,
            role: CharcoalTextRole.captionMedium,
            tone: CharcoalTextTone.secondary,
          ),
          const CharcoalGap(CharcoalSpace.lg),
          _BloomSurface(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _BloomMetric(label: 'Posts', value: '${ownPosts.length}'),
                _BloomMetric(label: 'Saved', value: '${savedPosts.length}'),
                _BloomMetric(
                  label: 'Following',
                  value: '${state.data.followedCreatorIds.length}',
                ),
              ],
            ),
          ),
          const CharcoalGap(CharcoalSpace.lg),
          CharcoalSegmentedControl<BloomProfileTab>(
            fullWidth: true,
            onChanged: viewModel.changeProfileTab,
            segments: const <CharcoalSegment<BloomProfileTab>>[
              CharcoalSegment(
                value: BloomProfileTab.posts,
                child: Text('Posts'),
              ),
              CharcoalSegment(
                value: BloomProfileTab.saved,
                child: Text('Saved'),
              ),
            ],
            semanticLabel: 'Profile content',
            value: state.profileTab,
          ),
          const CharcoalGap(CharcoalSpace.md),
          if (visiblePosts.isEmpty &&
              state.profileTab == BloomProfileTab.saved) ...<Widget>[
            const _BloomEmptyState(
              description:
                  'Save a post and it will stay here for a quieter return.',
              icon: CharcoalIcons.bookmark,
              title: 'Nothing saved yet',
            ),
            const CharcoalGap(CharcoalSpace.sm),
            CharcoalButton(
              fullWidth: true,
              onPressed: viewModel.exploreFromProfile,
              child: const Text('Explore ideas'),
            ),
          ] else
            _BloomArtworkGrid(onOpen: viewModel.openPost, posts: visiblePosts),
        ],
      ),
    );
  }
}

final class _BloomArtworkGrid extends StatelessWidget {
  const _BloomArtworkGrid({required this.onOpen, required this.posts});

  final ValueChanged<String> onOpen;
  final List<BloomPost> posts;

  @override
  Widget build(BuildContext context) {
    final gap = CharcoalSpace.sm.resolve(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: gap,
        mainAxisSpacing: gap,
      ),
      itemCount: posts.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => CharcoalClickable(
        onPressed: () => onOpen(posts[index].id),
        semanticLabel: 'Open post: ${posts[index].copy}',
        builder: (context, states) => CharcoalPressFeedback(
          states: states,
          child: _BloomArtwork(
            altText: posts[index].altText,
            rounded: true,
            tone: posts[index].tone,
          ),
        ),
      ),
    );
  }
}

final class _BloomProfileEditorPage extends StatefulWidget {
  const _BloomProfileEditorPage({required this.viewModel, super.key});

  final BloomViewModel viewModel;

  @override
  State<_BloomProfileEditorPage> createState() =>
      _BloomProfileEditorPageState();
}

final class _BloomProfileEditorPageState
    extends State<_BloomProfileEditorPage> {
  late final TextEditingController _bioController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = widget.viewModel.state;
    _bioController = TextEditingController(text: state.profileDraftBio);
    _nameController = TextEditingController(text: state.profileDraftName);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final invalid = state.profileDraftName.trim().isEmpty;
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-profile-editor'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: _BloomAvatar(
              initials: 'MA',
              tone: state.profileDraftTone,
              size: CharcoalAvatarSize.extraLarge,
            ),
          ),
          const CharcoalGap(CharcoalSpace.sm),
          Center(
            child: CharcoalButton(
              onPressed: widget.viewModel.changeProfileTone,
              size: CharcoalButtonSize.small,
              child: const Text('Change avatar color'),
            ),
          ),
          const CharcoalGap(CharcoalSpace.lg),
          CharcoalTextField(
            assistiveText: invalid ? 'Enter a display name.' : null,
            controller: _nameController,
            invalid: invalid,
            label: 'Display name',
            maxLength: 30,
            onChanged: widget.viewModel.updateProfileDraftName,
            required: true,
            showCount: true,
            showLabel: true,
          ),
          const CharcoalGap(CharcoalSpace.md),
          CharcoalTextArea(
            assistiveText: 'Tell people what you notice or make.',
            controller: _bioController,
            label: 'Bio',
            maxLength: 80,
            onChanged: widget.viewModel.updateProfileDraftBio,
            placeholder: 'A short introduction',
            rows: 3,
            showCount: true,
            showLabel: true,
          ),
          if (state.profileDirty) ...<Widget>[
            const CharcoalGap(CharcoalSpace.md),
            CharcoalText(
              'Unsaved changes',
              textAlign: TextAlign.center,
              role: CharcoalTextRole.caption,
              tone: CharcoalTextTone.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
