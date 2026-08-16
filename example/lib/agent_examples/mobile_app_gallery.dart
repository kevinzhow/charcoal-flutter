import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum AgentMobileApp { social, commerce, wallet, habits }

extension AgentMobileAppMetadata on AgentMobileApp {
  String get description => switch (this) {
    AgentMobileApp.social => 'Following feed and social reactions',
    AgentMobileApp.commerce => 'Search, categories, and product discovery',
    AgentMobileApp.wallet => 'Balance, shortcuts, and transactions',
    AgentMobileApp.habits => 'Daily progress and a focused checklist',
  };

  String get catalogIndex => switch (this) {
    AgentMobileApp.social => '01',
    AgentMobileApp.commerce => '02',
    AgentMobileApp.wallet => '03',
    AgentMobileApp.habits => '04',
  };

  String get keyName => switch (this) {
    AgentMobileApp.social => 'social',
    AgentMobileApp.commerce => 'commerce',
    AgentMobileApp.wallet => 'wallet',
    AgentMobileApp.habits => 'habits',
  };

  String get title => switch (this) {
    AgentMobileApp.social => 'Bloom',
    AgentMobileApp.commerce => 'Nook',
    AgentMobileApp.wallet => 'Lumen',
    AgentMobileApp.habits => 'Daylight',
  };

  String get type => switch (this) {
    AgentMobileApp.social => 'SOCIAL',
    AgentMobileApp.commerce => 'COMMERCE',
    AgentMobileApp.wallet => 'FINANCE',
    AgentMobileApp.habits => 'WELLNESS',
  };
}

/// Responsive tile grid shared by all Agent Ready app entries.
final class AgentExampleTileGrid extends StatelessWidget {
  const AgentExampleTileGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final gap = space.component30;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 960
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          key: const ValueKey<String>('agent-example-tile-grid'),
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final child in children)
              SizedBox(width: cardWidth, child: child),
          ],
        );
      },
    );
  }
}

/// A single discoverable entry that opens an interactive app simulation.
final class AgentMobileAppTile extends StatelessWidget {
  const AgentMobileAppTile({
    required this.app,
    required this.onPressed,
    super.key,
  });

  final AgentMobileApp app;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      key: ValueKey<String>('agent-app-tile-${app.keyName}'),
      onPressed: onPressed,
      semanticLabel: 'Open ${app.title} simulation',
      builder: (context, states) {
        final active =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed);
        return AnimatedContainer(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.fast,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: active
                  ? theme.colors.borderDefault
                  : theme.colors.borderSecondary,
            ),
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            color: states.contains(WidgetState.pressed)
                ? theme.colors.containerSecondaryDefaultA
                : theme.colors.backgroundDefault,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 210,
                  child: IgnorePointer(
                    child: ClipRect(
                      child: FittedBox(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: 360,
                          height: 640,
                          child: _phoneDemo(app),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: theme.dimensions.borderWidth.m,
                  child: ColoredBox(color: theme.colors.borderSecondary),
                ),
                Padding(
                  padding: EdgeInsets.all(space.component30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _AgentReadyBadge(),
                              ),
                            ),
                          ),
                          SizedBox(width: space.component20),
                          Text(
                            app.catalogIndex,
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: space.component20),
                      Text(
                        '${app.title} · ${app.type}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      SizedBox(height: space.component10),
                      Text(
                        app.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                      SizedBox(height: space.component25),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Open simulation',
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textInfoDefault,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CharcoalIcon(
                            CharcoalIcons.chevronRight,
                            color: theme.colors.iconDefault,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Full interactive simulator shown after an app tile is opened.
final class AgentMobileAppSimulator extends StatelessWidget {
  const AgentMobileAppSimulator({required this.app, super.key});

  final AgentMobileApp app;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageInset = theme.dimensions.space.component10;
        final width = (constraints.maxWidth - stageInset * 2)
            .clamp(0, 360)
            .toDouble();
        return Center(
          child: DecoratedBox(
            key: ValueKey<String>('agent-app-simulator-stage-${app.keyName}'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
              color: theme.colors.backgroundTertiary,
            ),
            child: Padding(
              padding: EdgeInsets.all(stageInset),
              child: DecoratedBox(
                key: ValueKey<String>('agent-app-simulator-${app.keyName}'),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colors.borderDefault,
                    width: theme.dimensions.borderWidth.m,
                  ),
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.m,
                  ),
                  color: theme.colors.backgroundDefault,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.m,
                  ),
                  child: SizedBox(
                    width: width,
                    height: 640,
                    child: _phoneDemo(app),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _phoneDemo(AgentMobileApp app) => switch (app) {
  AgentMobileApp.social => const _SocialPhoneDemo(),
  AgentMobileApp.commerce => const _CommercePhoneDemo(),
  AgentMobileApp.wallet => const _WalletPhoneDemo(),
  AgentMobileApp.habits => const _HabitPhoneDemo(),
};

final class _AgentReadyBadge extends StatelessWidget {
  const _AgentReadyBadge();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: space.component20,
          vertical: space.component10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.check,
              color: theme.colors.iconOnPrimaryDefault,
              size: 12,
            ),
            SizedBox(width: space.component10),
            Text(
              'MADE WITH AGENT READY',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textOnPrimaryDefault,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SocialFeed { following, forYou }

enum _BloomAudience { circle, everyone }

enum _BloomProfileTab { posts, saved }

final class _SocialPostData {
  const _SocialPostData({
    required this.author,
    required this.comments,
    required this.copy,
    required this.initials,
    required this.likes,
    required this.meta,
    required this.tone,
  });

  final String author;
  final int comments;
  final String copy;
  final String initials;
  final int likes;
  final String meta;
  final int tone;
}

const _socialPosts = <_SocialFeed, _SocialPostData>{
  _SocialFeed.following: _SocialPostData(
    author: 'Aki Kondo',
    comments: 24,
    copy: 'Found a quiet patch of color between the rain clouds.',
    initials: 'AK',
    likes: 128,
    meta: '12 min · Kamakura',
    tone: 0,
  ),
  _SocialFeed.forYou: _SocialPostData(
    author: 'Noa Watanabe',
    comments: 41,
    copy: 'A tiny paper city built from yesterday’s train tickets.',
    initials: 'NO',
    likes: 342,
    meta: 'Trending · Tokyo',
    tone: 2,
  ),
};

const _bloomTopics = <({String description, String label})>[
  (label: 'Quiet color', description: 'Soft palettes and slow observations'),
  (label: 'Paper worlds', description: 'Collage, models, and tactile studies'),
  (label: 'Tiny gardens', description: 'Small spaces growing with care'),
];

const _bloomCreators =
    <({String handle, String initials, String name, int tone})>[
      (name: 'Noa Watanabe', handle: '@noa.paper', initials: 'NO', tone: 2),
      (name: 'Emi Sato', handle: '@emi.grows', initials: 'EM', tone: 3),
    ];

const _bloomConversations =
    <({String initials, String name, String preview, String time, int tone})>[
      (
        name: 'Aki Kondo',
        initials: 'AK',
        preview: 'That rain-cloud palette is beautiful.',
        time: '12m',
        tone: 1,
      ),
      (
        name: 'Noa Watanabe',
        initials: 'NO',
        preview: 'I left the folding notes in the shared folder.',
        time: 'Tue',
        tone: 2,
      ),
      (
        name: 'Emi Sato',
        initials: 'EM',
        preview: 'The balcony mint finally has new leaves.',
        time: 'Sun',
        tone: 3,
      ),
    ];

final class _SocialPhoneDemo extends StatefulWidget {
  const _SocialPhoneDemo();

  @override
  State<_SocialPhoneDemo> createState() => _SocialPhoneDemoState();
}

final class _SocialPhoneDemoState extends State<_SocialPhoneDemo> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _discoverController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _profileBioController = TextEditingController();
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _storyReplyController = TextEditingController();
  _SocialFeed _feed = _SocialFeed.following;
  final Set<_SocialFeed> _likedFeeds = <_SocialFeed>{};
  final Set<_SocialFeed> _mutedFeeds = <_SocialFeed>{};
  final Set<_SocialFeed> _savedFeeds = <_SocialFeed>{};
  final Set<String> _followedCreators = <String>{};
  final Map<String, List<String>> _sentMessages = <String, List<String>>{};
  final Set<String> _unreadConversations = <String>{'Aki Kondo'};
  _BloomAudience _audience = _BloomAudience.circle;
  _BloomProfileTab _profileTab = _BloomProfileTab.posts;
  String? _activeStory;
  String _commentDraft = '';
  String? _conversation;
  String _discoverQuery = '';
  String _messageDraft = '';
  String _profileBio = 'Collecting overlooked color in everyday places.';
  String _profileName = 'Mina Aoki';
  String? _publishedPost;
  String? _status;
  String _storyReplyDraft = '';
  int _commentDelta = 0;
  int _profileDraftTone = 2;
  int _profileTone = 2;
  int _selectedBottomIndex = 0;
  bool _commentComposerOpen = false;
  bool _composerOpen = false;
  bool _editProfileOpen = false;
  bool _notificationsOpen = false;
  bool _notificationsUnread = true;
  bool _postActionsOpen = false;
  bool _publishAttempted = false;

  @override
  void dispose() {
    _commentController.dispose();
    _discoverController.dispose();
    _messageController.dispose();
    _postController.dispose();
    _profileBioController.dispose();
    _profileNameController.dispose();
    _storyReplyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'social',
      appLabel: 'Bloom social app demo',
      brand: 'Bloom',
      brandColor: theme.colors.containerDiscoveryDefault,
      brandForeground: theme.colors.textOnDiscoveryDefault,
      brandMark: 'B',
      bottomItems: const <_BottomItem>[
        _BottomItem('Home', CharcoalIcons.home),
        _BottomItem('Discover', CharcoalIcons.compass),
        _BottomItem('Messages', CharcoalIcons.message),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) => setState(() {
        _selectedBottomIndex = index;
        _closeNestedRoute();
        _status = null;
      }),
      selectedBottomIndex: _selectedBottomIndex,
      navigationBar: _buildNavigationBar(theme),
      trailing: const SizedBox.shrink(),
    );
  }

  void _closeNestedRoute() {
    _activeStory = null;
    _commentComposerOpen = false;
    _composerOpen = false;
    _conversation = null;
    _editProfileOpen = false;
    _notificationsOpen = false;
    _postActionsOpen = false;
    _publishAttempted = false;
  }

  void _openComposer() {
    setState(() {
      _closeNestedRoute();
      _composerOpen = true;
      _postController.clear();
      _publishAttempted = false;
      _audience = _BloomAudience.circle;
      _status = null;
    });
  }

  void _openProfileEditor() {
    setState(() {
      _closeNestedRoute();
      _editProfileOpen = true;
      _profileNameController.text = _profileName;
      _profileBioController.text = _profileBio;
      _profileDraftTone = _profileTone;
      _status = null;
    });
  }

  void _publishPost() {
    final copy = _postController.text.trim();
    setState(() {
      _publishAttempted = true;
      if (copy.isEmpty) return;
      _publishedPost = copy;
      _composerOpen = false;
      _selectedBottomIndex = 0;
      _feed = _SocialFeed.following;
      _status = _audience == _BloomAudience.circle
          ? 'Shared with your circle.'
          : 'Published for everyone.';
      _postController.clear();
    });
  }

  void _saveProfile() {
    final name = _profileNameController.text.trim();
    final bio = _profileBioController.text.trim();
    setState(() {
      if (name.isEmpty) return;
      _profileName = name;
      _profileBio = bio;
      _profileTone = _profileDraftTone;
      _editProfileOpen = false;
      _status = 'Your profile changes are live.';
    });
  }

  Widget _buildNavigationBar(CharcoalThemeData theme) {
    if (_activeStory != null) {
      return CharcoalNavigationBar(
        leading: _backButton('Return to home'),
        semanticLabel: 'Story navigation',
        title: Text(_activeStory!),
      );
    }
    if (_conversation != null) {
      return CharcoalNavigationBar(
        leading: _backButton('Return to messages'),
        semanticLabel: 'Conversation navigation',
        title: Text(_conversation!),
      );
    }
    if (_notificationsOpen) {
      return CharcoalNavigationBar(
        leading: _backButton('Return to home'),
        semanticLabel: 'Notifications navigation',
        title: const Text('Notifications'),
        trailing: CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.check),
          onPressed: _notificationsUnread
              ? () => setState(() {
                  _notificationsUnread = false;
                  _status = 'All notifications marked as read.';
                })
              : null,
          semanticLabel: 'Mark all notifications as read',
          size: CharcoalIconButtonSize.small,
        ),
      );
    }
    if (_composerOpen) {
      return CharcoalNavigationBar(
        leading: _backButton('Discard new post'),
        semanticLabel: 'New post navigation',
        title: const Text('New post'),
        trailing: CharcoalButton(
          key: const ValueKey<String>('agent-social-publish-post'),
          onPressed: _publishPost,
          size: CharcoalButtonSize.small,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Post'),
        ),
      );
    }
    if (_editProfileOpen) {
      return CharcoalNavigationBar(
        leading: _backButton('Cancel editing profile'),
        semanticLabel: 'Edit profile navigation',
        title: const Text('Edit profile'),
        trailing: CharcoalButton(
          key: const ValueKey<String>('agent-social-save-profile'),
          onPressed: _saveProfile,
          size: CharcoalButtonSize.small,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Save'),
        ),
      );
    }

    final title = switch (_selectedBottomIndex) {
      0 => 'Bloom',
      1 => 'Discover',
      2 => 'Messages',
      _ => 'Profile',
    };
    return CharcoalNavigationBar(
      leading: _selectedBottomIndex == 0 ? const _BloomBrandMark() : null,
      semanticLabel: '$title navigation',
      title: Text(title),
      trailing: switch (_selectedBottomIndex) {
        0 => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIconButton(
              key: const ValueKey<String>('agent-social-new-post'),
              icon: const CharcoalIcon(CharcoalIcons.penAdd),
              onPressed: _openComposer,
              semanticLabel: 'Create a post',
              size: CharcoalIconButtonSize.small,
            ),
            SizedBox(width: theme.dimensions.space.component10),
            _BloomNotificationButton(
              onPressed: () => setState(() {
                _closeNestedRoute();
                _notificationsOpen = true;
                _status = null;
              }),
              unread: _notificationsUnread,
            ),
          ],
        ),
        3 => CharcoalIconButton(
          key: const ValueKey<String>('agent-social-edit-profile'),
          icon: const CharcoalIcon(CharcoalIcons.penText),
          onPressed: _openProfileEditor,
          semanticLabel: 'Edit profile',
          size: CharcoalIconButtonSize.small,
        ),
        _ => null,
      },
    );
  }

  Widget _backButton(String semanticLabel) => CharcoalIconButton(
    key: const ValueKey<String>('agent-social-page-back'),
    icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
    onPressed: () => setState(() {
      _closeNestedRoute();
      _status = null;
    }),
    semanticLabel: semanticLabel,
    size: CharcoalIconButtonSize.small,
  );

  Widget _buildSelectedPage(CharcoalThemeData theme) {
    if (_activeStory != null) return _buildStory(theme);
    if (_conversation != null) return _buildConversation(theme);
    if (_notificationsOpen) return _buildNotifications(theme);
    if (_composerOpen) return _buildComposer(theme);
    if (_editProfileOpen) return _buildProfileEditor(theme);
    return switch (_selectedBottomIndex) {
      0 => _buildFeed(theme),
      1 => _buildDiscover(theme),
      2 => _buildMessages(theme),
      _ => _buildProfile(theme),
    };
  }

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildFeed(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final post = _socialPosts[_feed]!;
    final liked = _likedFeeds.contains(_feed);
    final muted = _mutedFeeds.contains(_feed);
    final saved = _savedFeeds.contains(_feed);
    return _pagePadding(
      theme,
      Column(
        key: ValueKey<String>('agent-social-feed-${_feed.name}'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Good afternoon, Mina',
            style: theme.textStyles.headingXxs.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            'Catch up without needing to catch everything.',
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component30),
          if (_status != null) ...<Widget>[
            _BloomInlineNotice(message: _status!),
            SizedBox(height: space.component30),
          ],
          Row(
            children: <Widget>[
              const Expanded(child: _PhoneSectionTitle(title: 'Your circle')),
              Text(
                '4 new',
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ],
          ),
          SizedBox(height: space.component20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _BloomStory(
                initials: '+',
                label: 'New post',
                onPressed: _openComposer,
                semanticLabel: 'Create a post',
                tone: 0,
              ),
              _BloomStory(
                initials: 'AK',
                label: 'Aki',
                onPressed: () => setState(() => _activeStory = 'Aki Kondo'),
                tone: 1,
              ),
              _BloomStory(
                initials: 'NO',
                label: 'Noa',
                onPressed: () => setState(() => _activeStory = 'Noa Watanabe'),
                tone: 2,
              ),
              _BloomStory(
                initials: 'EM',
                label: 'Emi',
                onPressed: () => setState(() => _activeStory = 'Emi Sato'),
                tone: 3,
              ),
            ],
          ),
          SizedBox(height: space.component30),
          CharcoalSegmentedControl<_SocialFeed>(
            key: const ValueKey<String>('agent-social-feed-control'),
            fullWidth: true,
            onChanged: (value) => setState(() {
              _feed = value;
              _commentComposerOpen = false;
              _postActionsOpen = false;
              _status = null;
            }),
            segments: const <CharcoalSegment<_SocialFeed>>[
              CharcoalSegment(
                value: _SocialFeed.following,
                child: Text('Following'),
              ),
              CharcoalSegment(
                value: _SocialFeed.forYou,
                child: Text('For you'),
              ),
            ],
            semanticLabel: 'Bloom feed',
            value: _feed,
          ),
          SizedBox(height: space.component30),
          if (_publishedPost != null &&
              _feed == _SocialFeed.following) ...<Widget>[
            _BloomPublishedPost(copy: _publishedPost!),
            SizedBox(height: space.component30),
          ],
          if (muted) ...<Widget>[
            _BloomInlineNotice(
              actionLabel: 'Undo',
              message: '${post.author} is hidden from this feed.',
              onAction: () => setState(() {
                _mutedFeeds.remove(_feed);
                _status = '${post.author} is back in your feed.';
              }),
            ),
            SizedBox(height: space.component20),
            const _SimulationEmptyState(
              description: 'You have seen everything else here. Try the other feed or undo the change.',
              title: 'You are caught up',
            ),
          ] else
            _PhoneSurface(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(space.component25),
                    child: Row(
                      children: <Widget>[
                        _DemoAvatar(
                          initials: post.initials,
                          tone: post.tone,
                          size: 38,
                        ),
                        SizedBox(width: space.component20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                post.author,
                                style: theme.textStyles.captionMediumBold
                                    .copyWith(color: theme.colors.textDefault),
                              ),
                              Text(
                                post.meta,
                                style: theme.textStyles.captionSmall.copyWith(
                                  color: theme.colors.textSecondaryDefault,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_feed == _SocialFeed.forYou) ...<Widget>[
                          CharcoalButton(
                            key: const ValueKey<String>(
                              'agent-social-follow-author',
                            ),
                            onPressed: () => _toggleCreator(post.author),
                            selected: _followedCreators.contains(post.author),
                            size: CharcoalButtonSize.small,
                            child: Text(
                              _followedCreators.contains(post.author)
                                  ? 'Following'
                                  : 'Follow',
                            ),
                          ),
                          SizedBox(width: space.component10),
                        ],
                        CharcoalIconButton(
                          key: const ValueKey<String>(
                            'agent-social-post-actions',
                          ),
                          icon: const CharcoalIcon(
                            CharcoalIcons.dotsHorizontal,
                          ),
                          onPressed: () => setState(
                            () => _postActionsOpen = !_postActionsOpen,
                          ),
                          selected: _postActionsOpen,
                          semanticLabel: 'More post actions',
                          size: CharcoalIconButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: space.component25,
                    ),
                    child: Text(
                      post.copy,
                      style: theme.textStyles.captionMedium.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                  ),
                  SizedBox(height: space.component20),
                  _DemoArtwork(height: 174, tone: post.tone),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: space.component20,
                      vertical: space.component10,
                    ),
                    child: Row(
                      children: <Widget>[
                        CharcoalIconButton(
                          key: const ValueKey<String>('agent-social-like'),
                          icon: const CharcoalIcon(CharcoalIcons.heart),
                          onPressed: () => setState(() {
                            liked
                                ? _likedFeeds.remove(_feed)
                                : _likedFeeds.add(_feed);
                            _status = null;
                          }),
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
                          key: const ValueKey<String>('agent-social-comment'),
                          icon: const CharcoalIcon(CharcoalIcons.message),
                          onPressed: () => setState(
                            () => _commentComposerOpen = !_commentComposerOpen,
                          ),
                          selected: _commentComposerOpen,
                          semanticLabel: 'Comment on post',
                          size: CharcoalIconButtonSize.small,
                        ),
                        Text(
                          '${post.comments + _commentDelta}',
                          style: theme.textStyles.captionSmall.copyWith(
                            color: theme.colors.textSecondaryDefault,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        CharcoalIconButton(
                          key: const ValueKey<String>('agent-social-save'),
                          icon: const CharcoalIcon(CharcoalIcons.bookmark),
                          onPressed: () => setState(() {
                            saved
                                ? _savedFeeds.remove(_feed)
                                : _savedFeeds.add(_feed);
                            _status = null;
                          }),
                          selected: saved,
                          semanticLabel: saved
                              ? 'Remove bookmark'
                              : 'Bookmark post',
                          size: CharcoalIconButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (_postActionsOpen) ...<Widget>[
            SizedBox(height: space.component20),
            _SimulationActionPanel(
              actionLabel: 'Hide this creator',
              description:
                  'Their posts leave your feed. You can undo this immediately.',
              onAction: () => setState(() {
                _postActionsOpen = false;
                _mutedFeeds.add(_feed);
                _status = null;
              }),
              title: 'Tune your feed',
            ),
          ],
          if (_commentComposerOpen) ...<Widget>[
            SizedBox(height: space.component20),
            _SimulationActionPanel(
              actionLabel: 'Post comment',
              actionEnabled: _commentDraft.trim().isNotEmpty,
              description: 'Join the conversation with a short reply.',
              onAction: () => setState(() {
                _commentDelta += 1;
                _commentDraft = '';
                _commentController.clear();
                _commentComposerOpen = false;
                _status = 'Your comment was posted.';
              }),
              title: 'Add a comment',
              child: CharcoalTextField(
                key: const ValueKey<String>('agent-social-comment-field'),
                controller: _commentController,
                label: 'Comment',
                onChanged: (value) => setState(() => _commentDraft = value),
                placeholder: 'Write something kind',
                showLabel: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscover(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final query = _discoverQuery.trim().toLowerCase();
    final matchingTopics = _bloomTopics
        .where(
          (topic) =>
              topic.label.toLowerCase().contains(query) ||
              topic.description.toLowerCase().contains(query),
        )
        .toList(growable: false);
    final matchingCreators = _bloomCreators
        .where(
          (creator) =>
              creator.name.toLowerCase().contains(query) ||
              creator.handle.toLowerCase().contains(query),
        )
        .toList(growable: false);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-discover-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Find ideas worth slowing down for.',
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component25),
          CharcoalTextField(
            key: const ValueKey<String>('agent-social-discover-search'),
            controller: _discoverController,
            onChanged: (value) => setState(() => _discoverQuery = value),
            placeholder: 'Search creators and ideas',
            prefix: const CharcoalIcon(CharcoalIcons.search),
          ),
          SizedBox(height: space.component30),
          if (query.isEmpty) ...<Widget>[
            const _PhoneSectionTitle(title: 'Browse by mood'),
            SizedBox(height: space.component20),
            for (final topic in _bloomTopics) ...<Widget>[
              _BloomTopicTile(
                description: topic.description,
                label: topic.label,
                onPressed: () => _openTopic(topic.label),
              ),
              SizedBox(height: space.component20),
            ],
            SizedBox(height: space.component20),
            const _PhoneSectionTitle(title: 'Creators to know'),
            SizedBox(height: space.component20),
            for (final creator in _bloomCreators) ...<Widget>[
              _BloomCreatorTile(
                followed: _followedCreators.contains(creator.name),
                handle: creator.handle,
                initials: creator.initials,
                name: creator.name,
                onFollow: () => _toggleCreator(creator.name),
                tone: creator.tone,
              ),
              SizedBox(height: space.component20),
            ],
          ] else if (matchingTopics.isEmpty &&
              matchingCreators.isEmpty) ...<Widget>[
            _SimulationEmptyState(
              description:
                  'No creators or ideas match “${_discoverQuery.trim()}”. Try a broader word.',
              title: 'Nothing found yet',
            ),
            SizedBox(height: space.component20),
            CharcoalButton(
              fullWidth: true,
              onPressed: () => setState(() {
                _discoverController.clear();
                _discoverQuery = '';
              }),
              child: const Text('Clear search'),
            ),
          ] else ...<Widget>[
            Text(
              '${matchingTopics.length + matchingCreators.length} results for “${_discoverQuery.trim()}”',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textSecondaryDefault,
              ),
            ),
            SizedBox(height: space.component20),
            for (final topic in matchingTopics) ...<Widget>[
              _BloomTopicTile(
                description: topic.description,
                label: topic.label,
                onPressed: () => _openTopic(topic.label),
              ),
              SizedBox(height: space.component20),
            ],
            for (final creator in matchingCreators) ...<Widget>[
              _BloomCreatorTile(
                followed: _followedCreators.contains(creator.name),
                handle: creator.handle,
                initials: creator.initials,
                name: creator.name,
                onFollow: () => _toggleCreator(creator.name),
                tone: creator.tone,
              ),
              SizedBox(height: space.component20),
            ],
          ],
        ],
      ),
    );
  }

  void _openTopic(String topic) {
    setState(() {
      _feed = _SocialFeed.forYou;
      _selectedBottomIndex = 0;
      _status = 'The $topic collection is now shaping your feed.';
    });
  }

  void _toggleCreator(String name) {
    final followed = _followedCreators.contains(name);
    setState(() {
      followed ? _followedCreators.remove(name) : _followedCreators.add(name);
    });
  }

  Widget _buildMessages(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-messages-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'A small inbox for people you know.',
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ),
              if (_unreadConversations.isNotEmpty)
                _BloomCountBadge(count: _unreadConversations.length),
            ],
          ),
          SizedBox(height: space.component30),
          for (final conversation in _bloomConversations) ...<Widget>[
            _BloomConversationTile(
              initials: conversation.initials,
              name: conversation.name,
              onPressed: () => setState(() {
                _conversation = conversation.name;
                _unreadConversations.remove(conversation.name);
                _messageController.clear();
                _messageDraft = '';
                _status = null;
              }),
              preview: conversation.preview,
              time: conversation.time,
              tone: conversation.tone,
              unread: _unreadConversations.contains(conversation.name),
            ),
            SizedBox(height: space.component20),
          ],
        ],
      ),
    );
  }

  Widget _buildConversation(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final conversation = _bloomConversations.firstWhere(
      (item) => item.name == _conversation,
    );
    final sent = _sentMessages[conversation.name] ?? const <String>[];
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-conversation'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              'Today · Take your time',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textTertiaryDefault,
              ),
            ),
          ),
          SizedBox(height: space.component30),
          _BloomMessageBubble(
            message: conversation.preview,
            sender: conversation.name.split(' ').first,
          ),
          for (final message in sent) ...<Widget>[
            SizedBox(height: space.component20),
            _BloomMessageBubble(message: message, own: true, sender: 'You'),
          ],
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _BloomInlineNotice(message: _status!),
          ],
          SizedBox(height: space.component30),
          CharcoalTextField(
            key: const ValueKey<String>('agent-social-message-field'),
            controller: _messageController,
            label: 'Reply',
            onChanged: (value) => setState(() => _messageDraft = value),
            onSubmitted: (_) => _sendMessage(),
            placeholder: 'Write a thoughtful reply',
            showLabel: true,
            textInputAction: TextInputAction.send,
          ),
          SizedBox(height: space.component20),
          CharcoalButton(
            key: const ValueKey<String>('agent-social-send-message'),
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.send),
            onPressed: _messageDraft.trim().isEmpty ? null : _sendMessage,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Send message'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageDraft.trim();
    if (message.isEmpty || _conversation == null) return;
    setState(() {
      _sentMessages.putIfAbsent(_conversation!, () => <String>[]).add(message);
      _messageDraft = '';
      _messageController.clear();
      _status = 'Sent. They usually reply later in the day.';
    });
  }

  Widget _buildProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: _DemoAvatar(initials: 'MA', tone: _profileTone, size: 72),
          ),
          SizedBox(height: space.component25),
          Text(
            _profileName,
            textAlign: TextAlign.center,
            style: theme.textStyles.headingXxs.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            '@mina.color · Tokyo',
            textAlign: TextAlign.center,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component30),
          Text(
            _profileBio.isEmpty ? 'No bio yet.' : _profileBio,
            textAlign: TextAlign.center,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component30),
          _PhoneSurface(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _ProfileMetric(label: 'Posts', value: '48'),
                _ProfileMetric(label: 'Saved', value: '${_savedFeeds.length}'),
                const _ProfileMetric(label: 'Friends', value: '326'),
              ],
            ),
          ),
          SizedBox(height: space.component30),
          CharcoalSegmentedControl<_BloomProfileTab>(
            fullWidth: true,
            onChanged: (value) => setState(() => _profileTab = value),
            segments: const <CharcoalSegment<_BloomProfileTab>>[
              CharcoalSegment(
                value: _BloomProfileTab.posts,
                child: Text('Posts'),
              ),
              CharcoalSegment(
                value: _BloomProfileTab.saved,
                child: Text('Saved'),
              ),
            ],
            semanticLabel: 'Profile content',
            value: _profileTab,
          ),
          SizedBox(height: space.component25),
          if (_profileTab == _BloomProfileTab.posts)
            const _BloomArtworkGrid(tones: <int>[0, 3, 1, 2])
          else if (_savedFeeds.isEmpty) ...<Widget>[
            const _SimulationEmptyState(
              description:
                  'Bookmark a post and it will stay here for a quieter return.',
              title: 'Nothing saved yet',
            ),
            SizedBox(height: space.component20),
            CharcoalButton(
              fullWidth: true,
              onPressed: () => setState(() {
                _selectedBottomIndex = 1;
                _profileTab = _BloomProfileTab.posts;
              }),
              child: const Text('Explore ideas'),
            ),
          ] else
            _BloomArtworkGrid(
              tones: _savedFeeds.map((feed) => feed.index + 1).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildComposer(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final invalid = _publishAttempted && _postController.text.trim().isEmpty;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-composer-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _DemoAvatar(initials: 'MA', tone: 2, size: 42),
              SizedBox(width: space.component20),
              Expanded(
                child: Text(
                  'Share one thing you noticed. It does not need to be finished.',
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: space.component30),
          CharcoalTextArea(
            key: const ValueKey<String>('agent-social-post-field'),
            assistiveText: invalid
                ? 'Write something before posting.'
                : 'Up to 140 characters.',
            controller: _postController,
            invalid: invalid,
            label: 'Your thought',
            maxLength: 140,
            onChanged: (_) => setState(() => _publishAttempted = false),
            placeholder: 'What caught your eye today?',
            required: true,
            rows: 4,
            showCount: true,
            showLabel: true,
          ),
          SizedBox(height: space.component30),
          const _PhoneSectionTitle(title: 'Who can see this?'),
          SizedBox(height: space.component20),
          CharcoalSegmentedControl<_BloomAudience>(
            fullWidth: true,
            onChanged: (value) => setState(() => _audience = value),
            segments: const <CharcoalSegment<_BloomAudience>>[
              CharcoalSegment(
                value: _BloomAudience.circle,
                child: Text('My circle'),
              ),
              CharcoalSegment(
                value: _BloomAudience.everyone,
                child: Text('Everyone'),
              ),
            ],
            semanticLabel: 'Post audience',
            value: _audience,
          ),
          SizedBox(height: space.component30),
          _PhoneSurface(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalIcon(
                  CharcoalIcons.infoCircle,
                  color: theme.colors.iconSecondaryDefault,
                  size: 18,
                ),
                SizedBox(width: space.component20),
                Expanded(
                  child: Text(
                    _audience == _BloomAudience.circle
                        ? 'Only people you follow can see and reply.'
                        : 'Anyone on Bloom can discover and reply.',
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-notifications-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_status != null) ...<Widget>[
            _BloomInlineNotice(message: _status!),
            SizedBox(height: space.component30),
          ],
          _BloomNotificationTile(
            description: 'Aki Kondo liked your color study.',
            onPressed: () => setState(() {
              _notificationsUnread = false;
              _notificationsOpen = false;
              _selectedBottomIndex = 0;
              _feed = _SocialFeed.following;
              _status = 'Opened the post Aki liked.';
            }),
            time: '8 min',
            unread: _notificationsUnread,
          ),
          SizedBox(height: space.component20),
          _BloomNotificationTile(
            description: 'Noa Watanabe started following you.',
            onPressed: () => setState(() {
              _notificationsUnread = false;
              _notificationsOpen = false;
              _selectedBottomIndex = 1;
              _discoverController.text = 'Noa';
              _discoverQuery = 'Noa';
            }),
            time: 'Yesterday',
            unread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileEditor(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final invalid = _profileNameController.text.trim().isEmpty;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-profile-editor'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: _DemoAvatar(
              initials: 'MA',
              tone: _profileDraftTone,
              size: 72,
            ),
          ),
          SizedBox(height: space.component20),
          Center(
            child: CharcoalButton(
              onPressed: () => setState(() {
                _profileDraftTone = (_profileDraftTone + 1) % 4;
                _status = 'New profile color selected. Save to keep it.';
              }),
              size: CharcoalButtonSize.small,
              child: const Text('Change photo'),
            ),
          ),
          SizedBox(height: space.component30),
          CharcoalTextField(
            controller: _profileNameController,
            invalid: invalid,
            label: 'Display name',
            maxLength: 30,
            onChanged: (_) => setState(() {}),
            required: true,
            showCount: true,
            showLabel: true,
          ),
          SizedBox(height: space.component25),
          CharcoalTextArea(
            assistiveText: 'Tell people what you notice or make.',
            controller: _profileBioController,
            label: 'Bio',
            maxLength: 80,
            onChanged: (_) => setState(() {}),
            placeholder: 'A short introduction',
            rows: 3,
            showCount: true,
            showLabel: true,
          ),
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _BloomInlineNotice(message: _status!),
          ],
        ],
      ),
    );
  }

  Widget _buildStory(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final story = _activeStory!;
    final tone = story.startsWith('Aki')
        ? 1
        : story.startsWith('Noa')
        ? 2
        : 3;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-social-story-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
            child: SizedBox(
              height: theme.dimensions.borderWidth.l,
              child: ColoredBox(color: theme.colors.containerPrimaryDefault),
            ),
          ),
          SizedBox(height: space.component20),
          Text(
            'A small moment from today',
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component20),
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            child: _DemoArtwork(height: 300, tone: tone),
          ),
          SizedBox(height: space.component25),
          CharcoalTextField(
            controller: _storyReplyController,
            onChanged: (value) => setState(() => _storyReplyDraft = value),
            placeholder: 'Reply to $story',
            prefix: const CharcoalIcon(CharcoalIcons.message),
            textInputAction: TextInputAction.send,
          ),
          SizedBox(height: space.component20),
          CharcoalButton(
            fullWidth: true,
            onPressed: _storyReplyDraft.trim().isEmpty
                ? null
                : () => setState(() {
                    _conversation = story;
                    _activeStory = null;
                    _sentMessages
                        .putIfAbsent(story, () => <String>[])
                        .add(_storyReplyDraft.trim());
                    _storyReplyDraft = '';
                    _storyReplyController.clear();
                    _status = 'Your story reply was sent.';
                  }),
            variant: CharcoalButtonVariant.primary,
            child: const Text('Send reply'),
          ),
        ],
      ),
    );
  }
}

final class _BloomBrandMark extends StatelessWidget {
  const _BloomBrandMark();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.containerDiscoveryDefault,
      ),
      child: SizedBox.square(
        dimension: theme.dimensions.space.targetS,
        child: Center(
          child: Text(
            'B',
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textOnDiscoveryDefault,
            ),
          ),
        ),
      ),
    );
  }
}

final class _BloomNotificationButton extends StatelessWidget {
  const _BloomNotificationButton({
    required this.onPressed,
    required this.unread,
  });

  final VoidCallback onPressed;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.bell),
          onPressed: onPressed,
          semanticLabel: unread
              ? 'Notifications, new activity'
              : 'Notifications',
          size: CharcoalIconButtonSize.small,
        ),
        if (unread)
          PositionedDirectional(
            end: 2,
            top: 2,
            child: ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.oval,
                  ),
                  color: theme.colors.containerNegativeDefault,
                ),
                child: const SizedBox.square(dimension: 7),
              ),
            ),
          ),
      ],
    );
  }
}

final class _BloomStory extends StatelessWidget {
  const _BloomStory({
    required this.initials,
    required this.label,
    required this.onPressed,
    required this.tone,
    this.semanticLabel,
  });

  final String initials;
  final String label;
  final VoidCallback onPressed;
  final String? semanticLabel;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: semanticLabel ?? 'View $label story',
      builder: (context, states) => AnimatedOpacity(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        opacity: states.contains(WidgetState.pressed) ? 0.64 : 1,
        child: SizedBox(
          width: 66,
          child: Column(
            children: <Widget>[
              _DemoAvatar(initials: initials, tone: tone, size: 46),
              SizedBox(height: theme.dimensions.space.component10),
              Text(
                label,
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
      ),
    );
  }
}

final class _BloomInlineNotice extends StatelessWidget {
  const _BloomInlineNotice({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String? actionLabel;
  final String message;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.containerSecondaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.component20),
        child: Row(
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.checkCircle,
              color: theme.colors.iconSecondaryDefault,
              size: 18,
            ),
            SizedBox(width: space.component20),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...<Widget>[
              SizedBox(width: space.component20),
              CharcoalButton(
                onPressed: onAction,
                size: CharcoalButtonSize.small,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _BloomPublishedPost extends StatelessWidget {
  const _BloomPublishedPost({required this.copy});

  final String copy;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _DemoAvatar(initials: 'MA', tone: 2, size: 36),
              SizedBox(width: space.component20),
              Expanded(
                child: Text(
                  'Mina Aoki · Just now',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: space.component20),
          Text(
            copy,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
        ],
      ),
    );
  }
}

final class _BloomTopicTile extends StatelessWidget {
  const _BloomTopicTile({
    required this.description,
    required this.label,
    required this.onPressed,
  });

  final String description;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: 'Open $label collection',
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
                    label,
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  ),
                  SizedBox(height: space.component10),
                  Text(
                    description,
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
    required this.followed,
    required this.handle,
    required this.initials,
    required this.name,
    required this.onFollow,
    required this.tone,
  });

  final bool followed;
  final String handle;
  final String initials;
  final String name;
  final VoidCallback onFollow;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      child: Row(
        children: <Widget>[
          _DemoAvatar(initials: initials, tone: tone, size: 42),
          SizedBox(width: space.component20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionMediumBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                Text(
                  handle,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ],
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

final class _BloomCountBadge extends StatelessWidget {
  const _BloomCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component20,
          vertical: theme.dimensions.space.component10,
        ),
        child: Text(
          '$count unread',
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textOnPrimaryDefault,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

final class _BloomConversationTile extends StatelessWidget {
  const _BloomConversationTile({
    required this.initials,
    required this.name,
    required this.onPressed,
    required this.preview,
    required this.time,
    required this.tone,
    required this.unread,
  });

  final String initials;
  final String name;
  final VoidCallback onPressed;
  final String preview;
  final String time;
  final int tone;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: '$name, ${unread ? 'unread, ' : ''}$preview',
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        padding: EdgeInsets.all(space.component25),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          color: states.contains(WidgetState.pressed)
              ? theme.colors.containerSecondaryPressA
              : unread
              ? theme.colors.containerSecondaryDefault
              : theme.colors.backgroundDefault,
        ),
        child: Row(
          children: <Widget>[
            _DemoAvatar(initials: initials, tone: tone, size: 44),
            SizedBox(width: space.component20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textStyles.captionMediumBold.copyWith(
                            color: theme.colors.textDefault,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textTertiaryDefault,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: space.component10),
                  Text(
                    preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w400,
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

final class _BloomMessageBubble extends StatelessWidget {
  const _BloomMessageBubble({
    required this.message,
    required this.sender,
    this.own = false,
  });

  final String message;
  final bool own;
  final String sender;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Align(
      alignment: own
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            color: own
                ? theme.colors.containerPrimaryDefault
                : theme.colors.backgroundDefault,
          ),
          child: Padding(
            padding: EdgeInsets.all(space.component20),
            child: Text(
              '$sender: $message',
              style: theme.textStyles.captionMedium.copyWith(
                color: own
                    ? theme.colors.textOnPrimaryDefault
                    : theme.colors.textDefault,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _BloomNotificationTile extends StatelessWidget {
  const _BloomNotificationTile({
    required this.description,
    required this.onPressed,
    required this.time,
    required this.unread,
  });

  final String description;
  final VoidCallback onPressed;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalNavigationItem(
      leading: CharcoalIcon(
        unread ? CharcoalIcons.heart : CharcoalIcons.personCircle,
      ),
      onPressed: onPressed,
      trailing: Text(
        time,
        style: theme.textStyles.captionSmall.copyWith(
          color: theme.colors.textTertiaryDefault,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: space.component20),
        child: Text(description, maxLines: 2),
      ),
    );
  }
}

final class _BloomArtworkGrid extends StatelessWidget {
  const _BloomArtworkGrid({required this.tones});

  final List<int> tones;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final gap = theme.dimensions.space.component20;
    return Column(
      children: <Widget>[
        for (var index = 0; index < tones.length; index += 2) ...<Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.m,
                  ),
                  child: _DemoArtwork(height: 126, tone: tones[index]),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: index + 1 < tones.length
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          theme.dimensions.radius.m,
                        ),
                        child: _DemoArtwork(
                          height: 126,
                          tone: tones[index + 1],
                        ),
                      )
                    : const SizedBox(height: 126),
              ),
            ],
          ),
          if (index + 2 < tones.length) SizedBox(height: gap),
        ],
      ],
    );
  }
}

enum _CommerceCategory { newItems, home, gifts }

final class _CommerceProduct {
  const _CommerceProduct({
    required this.category,
    required this.id,
    required this.name,
    required this.price,
    required this.subtitle,
    required this.tone,
  });

  final _CommerceCategory category;
  final String id;
  final String name;
  final String price;
  final String subtitle;
  final int tone;
}

const _commerceProducts = <_CommerceProduct>[
  _CommerceProduct(
    category: _CommerceCategory.newItems,
    id: 'ripple-cup',
    name: 'Ripple cup',
    price: '¥2,800',
    subtitle: 'Hand-glazed stoneware',
    tone: 1,
  ),
  _CommerceProduct(
    category: _CommerceCategory.newItems,
    id: 'linen-tray',
    name: 'Linen tray',
    price: '¥3,400',
    subtitle: 'Soft structure for small things',
    tone: 3,
  ),
  _CommerceProduct(
    category: _CommerceCategory.home,
    id: 'paper-lamp',
    name: 'Paper lamp',
    price: '¥8,900',
    subtitle: 'A warm pool of evening light',
    tone: 0,
  ),
  _CommerceProduct(
    category: _CommerceCategory.home,
    id: 'wool-cushion',
    name: 'Wool cushion',
    price: '¥6,200',
    subtitle: 'Woven in a quiet moss tone',
    tone: 2,
  ),
  _CommerceProduct(
    category: _CommerceCategory.gifts,
    id: 'tea-pair',
    name: 'Tea pair',
    price: '¥4,600',
    subtitle: 'Two cups wrapped for sharing',
    tone: 2,
  ),
  _CommerceProduct(
    category: _CommerceCategory.gifts,
    id: 'letter-set',
    name: 'Letter set',
    price: '¥1,900',
    subtitle: 'Textured paper and six envelopes',
    tone: 0,
  ),
];

final class _CommercePhoneDemo extends StatefulWidget {
  const _CommercePhoneDemo();

  @override
  State<_CommercePhoneDemo> createState() => _CommercePhoneDemoState();
}

final class _CommercePhoneDemoState extends State<_CommercePhoneDemo> {
  _CommerceCategory _category = _CommerceCategory.newItems;
  final Set<String> _bag = <String>{};
  final Set<String> _saved = <String>{};
  String _query = '';
  String? _status;
  _CommerceProduct? _selectedProduct;
  int _selectedBottomIndex = 0;
  bool _bagOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'commerce',
      appLabel: 'Nook commerce app demo',
      brand: 'Nook',
      brandColor: theme.colors.containerNoticeDefault,
      brandForeground: theme.colors.textOnNoticeDefault,
      brandMark: 'N',
      bottomItems: const <_BottomItem>[
        _BottomItem('Shop', CharcoalIcons.shopping),
        _BottomItem('Search', CharcoalIcons.search),
        _BottomItem('Saved', CharcoalIcons.bookmark),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) => setState(() {
        _selectedBottomIndex = index;
        _selectedProduct = null;
        _bagOpen = false;
        _status = null;
      }),
      selectedBottomIndex: _selectedBottomIndex,
      trailing: CharcoalIconButton(
        key: const ValueKey<String>('agent-commerce-bag'),
        icon: const CharcoalIcon(CharcoalIcons.shopping),
        onPressed: () => setState(() {
          _selectedBottomIndex = 0;
          _selectedProduct = null;
          _bagOpen = true;
        }),
        semanticLabel: 'Shopping bag, ${_bag.length} items',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }

  List<_CommerceProduct> get _visibleProducts {
    final normalizedQuery = _query.trim().toLowerCase();
    return _commerceProducts
        .where((product) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              product.name.toLowerCase().contains(normalizedQuery) ||
              product.subtitle.toLowerCase().contains(normalizedQuery);
          final matchesCategory =
              normalizedQuery.isNotEmpty ||
              _selectedBottomIndex == 1 ||
              product.category == _category;
          return matchesQuery && matchesCategory;
        })
        .toList(growable: false);
  }

  Widget _buildSelectedPage(CharcoalThemeData theme) {
    if (_bagOpen) return _buildBag(theme);
    final product = _selectedProduct;
    if (product != null) return _buildProductDetail(theme, product);
    return switch (_selectedBottomIndex) {
      0 => _buildShop(theme),
      1 => _buildSearch(theme),
      2 => _buildSaved(theme),
      _ => _buildCommerceProfile(theme),
    };
  }

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildShop(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-shop-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'GOOD MORNING, MINA',
            title: 'Small things for a calmer home',
          ),
          SizedBox(height: space.component20),
          _commerceSearchField(),
          SizedBox(height: space.component20),
          _categoryControl(),
          SizedBox(height: space.component20),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerDiscoveryDefault,
            ),
            child: SizedBox(
              height: 98,
              child: Padding(
                padding: EdgeInsets.all(space.component30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Slow Sunday edit',
                            style: theme.textStyles.captionMediumBold.copyWith(
                              color: theme.colors.textOnDiscoveryDefault,
                            ),
                          ),
                          SizedBox(height: space.component10),
                          Text(
                            'Warm textures · up to 25% off',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textOnDiscoveryDefault
                                  .withValues(alpha: 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _PromoShape(color: theme.colors.containerNoticeDefault),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: space.component25),
          _PhoneSectionTitle(
            title: _query.trim().isEmpty
                ? switch (_category) {
                    _CommerceCategory.newItems => 'New this week',
                    _CommerceCategory.home => 'For your home',
                    _CommerceCategory.gifts => 'Thoughtful gifts',
                  }
                : 'Search results',
          ),
          SizedBox(height: space.component20),
          _buildProductGrid(theme, _visibleProducts),
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _SimulationStatus(message: _status!),
          ],
        ],
      ),
    );
  }

  Widget _buildSearch(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-search-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'SEARCH',
            title: 'Find exactly what feels right',
          ),
          SizedBox(height: space.component25),
          _commerceSearchField(showLabel: true),
          SizedBox(height: space.component25),
          _PhoneSectionTitle(
            title: _query.trim().isEmpty
                ? 'Browse the full collection'
                : '${_visibleProducts.length} matches',
          ),
          SizedBox(height: space.component20),
          _buildProductGrid(theme, _visibleProducts),
        ],
      ),
    );
  }

  Widget _buildSaved(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final products = _commerceProducts
        .where((product) => _saved.contains(product.id))
        .toList(growable: false);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-saved-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'SAVED',
            title: 'Keep ideas for later',
          ),
          SizedBox(height: space.component25),
          if (products.isEmpty)
            const _SimulationEmptyState(
              description: 'Bookmark a product and it will appear here.',
              title: 'Nothing saved yet',
            )
          else
            _buildProductGrid(theme, products),
        ],
      ),
    );
  }

  Widget _buildCommerceProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'PROFILE',
            title: 'Good morning, Mina',
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message:
                '${_saved.length} saved · ${_bag.length} in bag · Free delivery enabled',
          ),
          SizedBox(height: space.component25),
          for (final label in const <String>[
            'Orders and returns',
            'Delivery addresses',
            'Payment methods',
          ]) ...<Widget>[
            CharcoalNavigationItem(
              onPressed: () =>
                  setState(() => _status = '$label opened in this simulation.'),
              trailing: const CharcoalIcon(CharcoalIcons.chevronRight),
              child: Text(label),
            ),
            SizedBox(height: space.component20),
          ],
          if (_status != null) _SimulationStatus(message: _status!),
        ],
      ),
    );
  }

  Widget _commerceSearchField({bool showLabel = false}) => CharcoalTextField(
    key: const ValueKey<String>('agent-commerce-search'),
    label: 'Search the collection',
    onChanged: (value) => setState(() => _query = value),
    placeholder: 'Try “lamp” or “paper”',
    prefix: const CharcoalIcon(CharcoalIcons.search),
    showLabel: showLabel,
  );

  Widget _categoryControl() => CharcoalSegmentedControl<_CommerceCategory>(
    key: const ValueKey<String>('agent-commerce-category'),
    fullWidth: true,
    onChanged: (value) => setState(() {
      _category = value;
      _status = 'Category changed to ${value.name}.';
    }),
    segments: const <CharcoalSegment<_CommerceCategory>>[
      CharcoalSegment(value: _CommerceCategory.newItems, child: Text('New')),
      CharcoalSegment(value: _CommerceCategory.home, child: Text('Home')),
      CharcoalSegment(value: _CommerceCategory.gifts, child: Text('Gifts')),
    ],
    semanticLabel: 'Nook category',
    value: _category,
  );

  Widget _buildProductGrid(
    CharcoalThemeData theme,
    List<_CommerceProduct> products,
  ) {
    if (products.isEmpty) {
      return _SimulationEmptyState(
        description: 'Try another word or browse a different category.',
        title: 'No products for “${_query.trim()}”',
      );
    }
    final space = theme.dimensions.space;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - space.component20) / 2;
        return Wrap(
          spacing: space.component20,
          runSpacing: space.component25,
          children: <Widget>[
            for (final product in products)
              SizedBox(
                width: width,
                child: _MiniProductCard(
                  key: ValueKey<String>('agent-commerce-product-${product.id}'),
                  name: product.name,
                  onOpen: () => setState(() => _selectedProduct = product),
                  onSave: () => _toggleSaved(product),
                  price: product.price,
                  saved: _saved.contains(product.id),
                  saveKey: ValueKey<String>(
                    product.id == 'ripple-cup'
                        ? 'agent-commerce-save'
                        : 'agent-commerce-save-${product.id}',
                  ),
                  tone: product.tone,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProductDetail(
    CharcoalThemeData theme,
    _CommerceProduct product,
  ) {
    final space = theme.dimensions.space;
    final saved = _saved.contains(product.id);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-product-detail'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalButton(
            leading: const CharcoalIcon(CharcoalIcons.chevronLeft),
            onPressed: () => setState(() => _selectedProduct = null),
            size: CharcoalButtonSize.small,
            child: const Text('Back to products'),
          ),
          SizedBox(height: space.component25),
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            child: _DemoArtwork(height: 220, tone: product.tone),
          ),
          SizedBox(height: space.component25),
          Text(
            product.name,
            style: theme.textStyles.headingXs.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            product.subtitle,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component20),
          Text(
            product.price,
            style: theme.textStyles.bodyBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component25),
          CharcoalButton(
            key: const ValueKey<String>('agent-commerce-add-to-bag'),
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.shopping),
            onPressed: () => setState(() {
              _bag.add(product.id);
              _status = '${product.name} was added to your bag.';
            }),
            variant: CharcoalButtonVariant.primary,
            child: Text(
              _bag.contains(product.id) ? 'Added to bag' : 'Add to bag',
            ),
          ),
          SizedBox(height: space.component20),
          CharcoalButton(
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.bookmark),
            onPressed: () => _toggleSaved(product),
            selected: saved,
            child: Text(saved ? 'Saved' : 'Save for later'),
          ),
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _SimulationStatus(message: _status!),
          ],
        ],
      ),
    );
  }

  Widget _buildBag(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final products = _commerceProducts
        .where((product) => _bag.contains(product.id))
        .toList(growable: false);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-bag-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalButton(
            leading: const CharcoalIcon(CharcoalIcons.chevronLeft),
            onPressed: () => setState(() => _bagOpen = false),
            size: CharcoalButtonSize.small,
            child: const Text('Continue shopping'),
          ),
          SizedBox(height: space.component25),
          const _PhonePageHeading(eyebrow: 'BAG', title: 'Ready when you are'),
          SizedBox(height: space.component25),
          if (products.isEmpty)
            const _SimulationEmptyState(
              description: 'Open a product and add it to begin checkout.',
              title: 'Your bag is empty',
            )
          else ...<Widget>[
            for (final product in products) ...<Widget>[
              _SimulationStatus(message: '${product.name} · ${product.price}'),
              SizedBox(height: space.component20),
            ],
            CharcoalButton(
              key: const ValueKey<String>('agent-commerce-checkout'),
              fullWidth: true,
              onPressed: () => setState(() {
                _status = products.length == 1
                    ? 'Checkout is ready for 1 item.'
                    : 'Checkout is ready for ${products.length} items.';
              }),
              variant: CharcoalButtonVariant.primary,
              child: const Text('Continue to checkout'),
            ),
            if (_status != null) ...<Widget>[
              SizedBox(height: space.component25),
              _SimulationStatus(message: _status!),
            ],
          ],
        ],
      ),
    );
  }

  void _toggleSaved(_CommerceProduct product) {
    setState(() {
      final removed = _saved.remove(product.id);
      if (!removed) _saved.add(product.id);
      _status = removed
          ? '${product.name} was removed from saved.'
          : '${product.name} was saved for later.';
    });
  }
}

final class _WalletPhoneDemo extends StatefulWidget {
  const _WalletPhoneDemo();

  @override
  State<_WalletPhoneDemo> createState() => _WalletPhoneDemoState();
}

enum _WalletAction { receive, send, topUp, more }

final class _WalletPhoneDemoState extends State<_WalletPhoneDemo> {
  _WalletAction? _action;
  int _balance = 1284600;
  int _selectedBottomIndex = 0;
  int _topUpAmount = 10000;
  String _recipient = '';
  String _sendAmount = '';
  String? _status;
  String? _transferActivity;
  bool _balanceHidden = false;
  bool _roundUps = true;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'wallet',
      appLabel: 'Lumen personal finance app demo',
      brand: 'Lumen',
      brandColor: theme.colors.containerPositiveDefault,
      brandForeground: theme.colors.textOnPositiveDefault,
      brandMark: 'L',
      bottomItems: const <_BottomItem>[
        _BottomItem('Wallet', CharcoalIcons.invoice),
        _BottomItem('Activity', CharcoalIcons.history),
        _BottomItem('Plan', CharcoalIcons.calendar),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) => setState(() {
        _selectedBottomIndex = index;
        _action = null;
        _status = null;
      }),
      selectedBottomIndex: _selectedBottomIndex,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.bell),
        onPressed: () => setState(
          () => _status = 'No new account alerts. Everything looks calm.',
        ),
        semanticLabel: 'Lumen notifications',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }

  Widget _buildSelectedPage(CharcoalThemeData theme) =>
      switch (_selectedBottomIndex) {
        0 => _buildWallet(theme),
        1 => _buildActivity(theme),
        2 => _buildPlan(theme),
        _ => _buildWalletProfile(theme),
      };

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildWallet(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-home-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Good afternoon',
                  style: theme.textStyles.headingXxs.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
              ),
              const _DemoAvatar(initials: 'MA', tone: 2, size: 36),
            ],
          ),
          SizedBox(height: space.component25),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  theme.colors.containerPrimaryDefault,
                  theme.colors.containerDiscoveryDefault,
                ],
              ),
            ),
            child: SizedBox(
              height: 132,
              child: Padding(
                padding: EdgeInsets.all(space.component30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'AVAILABLE BALANCE',
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textOnPrimaryDefault
                                  .withValues(alpha: 0.72),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        CharcoalIconButton(
                          key: const ValueKey<String>(
                            'agent-wallet-visibility',
                          ),
                          icon: CharcoalIcon(
                            _balanceHidden
                                ? CharcoalIcons.eyeClosed
                                : CharcoalIcons.eye,
                          ),
                          onPressed: () =>
                              setState(() => _balanceHidden = !_balanceHidden),
                          semanticLabel: _balanceHidden
                              ? 'Show balance'
                              : 'Hide balance',
                          size: CharcoalIconButtonSize.small,
                          variant: CharcoalIconButtonVariant.overlay,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      _balanceHidden ? '¥ ••••••' : _formatYen(_balance),
                      style: theme.textStyles.headingS.copyWith(
                        color: theme.colors.textOnPrimaryDefault,
                      ),
                    ),
                    SizedBox(height: space.component10),
                    Text(
                      '+ ¥42,800 this month',
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textOnPrimaryDefault.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: space.component25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _QuickAction(
                action: _WalletAction.receive,
                icon: CharcoalIcons.arrowDown,
                label: 'Receive',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.receive,
              ),
              _QuickAction(
                action: _WalletAction.send,
                icon: CharcoalIcons.send,
                label: 'Send',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.send,
              ),
              _QuickAction(
                action: _WalletAction.topUp,
                icon: CharcoalIcons.addCircle,
                label: 'Top up',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.topUp,
              ),
              _QuickAction(
                action: _WalletAction.more,
                icon: CharcoalIcons.dotsHorizontal,
                label: 'More',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.more,
              ),
            ],
          ),
          if (_action != null) ...<Widget>[
            SizedBox(height: space.component25),
            _buildWalletAction(theme),
          ],
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _SimulationStatus(message: _status!),
          ],
          SizedBox(height: space.component30),
          Row(
            children: <Widget>[
              const Expanded(
                child: _PhoneSectionTitle(title: 'Recent activity'),
              ),
              Text(
                'August',
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ],
          ),
          SizedBox(height: space.component20),
          ..._activityRows,
        ],
      ),
    );
  }

  Widget _buildWalletAction(CharcoalThemeData theme) => switch (_action!) {
    _WalletAction.receive => _SimulationActionPanel(
      actionLabel: 'Copy payment link',
      description: 'Share lumen.me/mina so someone can send money securely.',
      onAction: () => setState(() {
        _action = null;
        _status = 'Payment link copied. It is ready to share.';
      }),
      title: 'Receive money',
    ),
    _WalletAction.send => _SimulationActionPanel(
      actionLabel: 'Send money',
      actionEnabled:
          _recipient.trim().isNotEmpty && (_parsedSendAmount ?? 0) > 0,
      description:
          'Transfers in this simulation update your balance instantly.',
      onAction: _sendMoney,
      title: 'Send money',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalTextField(
            key: const ValueKey<String>('agent-wallet-recipient'),
            label: 'Recipient',
            onChanged: (value) => setState(() => _recipient = value),
            placeholder: 'Name or handle',
            showLabel: true,
          ),
          SizedBox(height: theme.dimensions.space.component20),
          CharcoalTextField(
            key: const ValueKey<String>('agent-wallet-amount'),
            keyboardType: TextInputType.number,
            label: 'Amount',
            onChanged: (value) => setState(() => _sendAmount = value),
            placeholder: '8000',
            prefix: const Text('¥'),
            showLabel: true,
          ),
        ],
      ),
    ),
    _WalletAction.topUp => _SimulationActionPanel(
      actionLabel: 'Add ${_formatYen(_topUpAmount)}',
      description: 'Choose an amount to add from your linked bank.',
      onAction: () => setState(() {
        _balance += _topUpAmount;
        _transferActivity = '+ ${_formatYen(_topUpAmount)} · Bank top up';
        _action = null;
        _status = '${_formatYen(_topUpAmount)} was added to your balance.';
      }),
      title: 'Top up balance',
      child: CharcoalSegmentedControl<int>(
        fullWidth: true,
        onChanged: (value) => setState(() => _topUpAmount = value),
        segments: const <CharcoalSegment<int>>[
          CharcoalSegment(value: 5000, child: Text('¥5k')),
          CharcoalSegment(value: 10000, child: Text('¥10k')),
          CharcoalSegment(value: 20000, child: Text('¥20k')),
        ],
        semanticLabel: 'Top up amount',
        value: _topUpAmount,
      ),
    ),
    _WalletAction.more => _SimulationActionPanel(
      actionLabel: 'Done',
      description: 'Small preferences that help money move quietly.',
      onAction: () => setState(() {
        _action = null;
        _status = _roundUps
            ? 'Round ups are enabled for future card purchases.'
            : 'Round ups are paused.';
      }),
      title: 'More options',
      child: CharcoalSwitch(
        label: const Text('Round up card purchases'),
        onChanged: (value) => setState(() => _roundUps = value),
        value: _roundUps,
      ),
    ),
  };

  Widget _buildActivity(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-activity-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'ACTIVITY',
            title: 'Every movement, in one place',
          ),
          SizedBox(height: space.component25),
          ..._activityRows,
        ],
      ),
    );
  }

  List<Widget> get _activityRows => <Widget>[
    if (_transferActivity != null)
      _TransactionRow(
        amount: _transferActivity!.split(' · ').first,
        icon: _transferActivity!.startsWith('+')
            ? CharcoalIcons.addCircle
            : CharcoalIcons.send,
        positive: _transferActivity!.startsWith('+'),
        subtitle: 'Just now · Transfer',
        title: _transferActivity!.split(' · ').last,
      ),
    const _TransactionRow(
      amount: '− ¥1,240',
      icon: CharcoalIcons.shopping,
      subtitle: 'Today · Card',
      title: 'Morning Market',
    ),
    const _TransactionRow(
      amount: '+ ¥8,000',
      icon: CharcoalIcons.persons,
      positive: true,
      subtitle: 'Yesterday · Transfer',
      title: 'From Hana',
    ),
    const _TransactionRow(
      amount: '− ¥980',
      icon: CharcoalIcons.book,
      subtitle: 'Aug 15 · Card',
      title: 'Mori Books',
    ),
  ];

  Widget _buildPlan(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-plan-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'AUGUST PLAN',
            title: 'Spend with a little more intention',
          ),
          SizedBox(height: space.component25),
          const _SimulationStatus(
            message: '¥68,420 of your ¥120,000 flexible budget remains.',
          ),
          SizedBox(height: space.component25),
          for (final item in const <(String, String)>[
            ('Home and groceries', '¥31,200 left'),
            ('Creative supplies', '¥18,900 left'),
            ('Rest and play', '¥18,320 left'),
          ]) ...<Widget>[
            _PhoneSurface(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(item.$1)),
                  Text(item.$2),
                ],
              ),
            ),
            SizedBox(height: space.component20),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(eyebrow: 'PROFILE', title: 'Mina’s Lumen'),
          SizedBox(height: space.component25),
          CharcoalSwitch(
            label: const Text('Round up card purchases'),
            onChanged: (value) => setState(() => _roundUps = value),
            value: _roundUps,
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message: _roundUps
                ? 'Round ups are currently active.'
                : 'Round ups are currently paused.',
          ),
        ],
      ),
    );
  }

  int? get _parsedSendAmount =>
      int.tryParse(_sendAmount.replaceAll(RegExp('[^0-9]'), ''));

  void _selectWalletAction(_WalletAction action) {
    setState(() {
      _action = _action == action ? null : action;
      _status = null;
    });
  }

  void _sendMoney() {
    final amount = _parsedSendAmount;
    if (amount == null || amount <= 0 || _recipient.trim().isEmpty) return;
    setState(() {
      _balance -= amount;
      _transferActivity = '− ${_formatYen(amount)} · To ${_recipient.trim()}';
      _status = '${_formatYen(amount)} was sent to ${_recipient.trim()}.';
      _recipient = '';
      _sendAmount = '';
      _action = null;
    });
  }

  String _formatYen(int amount) {
    final digits = amount.abs().toString();
    final chunks = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = (end - 3).clamp(0, digits.length);
      chunks.add(digits.substring(start, end));
    }
    final formatted = chunks.reversed.join(',');
    return '${amount < 0 ? '− ' : ''}¥ $formatted';
  }
}

final class _HabitPhoneDemo extends StatefulWidget {
  const _HabitPhoneDemo();

  @override
  State<_HabitPhoneDemo> createState() => _HabitPhoneDemoState();
}

final class _HabitPhoneDemoState extends State<_HabitPhoneDemo> {
  bool _read = false;
  bool _reminders = true;
  bool _stretch = true;
  bool _walk = false;
  int _selectedBottomIndex = 0;

  int get _completed =>
      <bool>[_stretch, _walk, _read].where((value) => value).length;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'habits',
      appLabel: 'Daylight wellness app demo',
      brand: 'Daylight',
      brandColor: theme.colors.containerDiscoveryDefault,
      brandForeground: theme.colors.textOnDiscoveryDefault,
      brandMark: 'D',
      bottomItems: const <_BottomItem>[
        _BottomItem('Today', CharcoalIcons.sun),
        _BottomItem('Journey', CharcoalIcons.calendar),
        _BottomItem('Insights', CharcoalIcons.star),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) =>
          setState(() => _selectedBottomIndex = index),
      selectedBottomIndex: _selectedBottomIndex,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.calendar),
        onPressed: () => setState(() => _selectedBottomIndex = 1),
        semanticLabel: 'Open Daylight calendar',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }

  Widget _buildSelectedPage(CharcoalThemeData theme) =>
      switch (_selectedBottomIndex) {
        0 => _buildToday(theme),
        1 => _buildJourney(theme),
        2 => _buildInsights(theme),
        _ => _buildHabitProfile(theme),
      };

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildToday(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-today-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'MONDAY, AUGUST 17',
            title: 'A gentle day is still progress.',
          ),
          SizedBox(height: space.component25),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 340;
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.l,
                  ),
                  color: theme.colors.containerNoticeDefault,
                ),
                child: SizedBox(
                  height: 104,
                  child: Padding(
                    padding: EdgeInsets.all(
                      compact ? space.component25 : space.component30,
                    ),
                    child: Row(
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colors.iconOnNoticeDefault
                                  .withValues(alpha: 0.32),
                              width: 6,
                            ),
                            borderRadius: BorderRadius.circular(999),
                            color: theme.colors.backgroundDefault.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          child: SizedBox.square(
                            dimension: compact ? 56 : 64,
                            child: Center(
                              child: Text(
                                '$_completed/3',
                                style: theme.textStyles.captionMediumBold
                                    .copyWith(
                                      color: theme.colors.textOnNoticeDefault,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: compact
                              ? space.component20
                              : space.component30,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Today’s rhythm',
                                style:
                                    (compact
                                            ? theme.textStyles.captionSmall
                                            : theme
                                                  .textStyles
                                                  .captionMediumBold)
                                        .copyWith(
                                          color:
                                              theme.colors.textOnNoticeDefault,
                                          fontWeight: FontWeight.w700,
                                        ),
                              ),
                              SizedBox(height: space.component10),
                              Text(
                                _completed == 3
                                    ? 'Everything is complete.'
                                    : 3 - _completed == 1
                                    ? '1 small step remaining'
                                    : '${3 - _completed} small steps remaining',
                                style: theme.textStyles.captionSmall.copyWith(
                                  color: theme.colors.textOnNoticeDefault
                                      .withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: space.component30),
          const _PhoneSectionTitle(title: 'Your habits'),
          SizedBox(height: space.component30),
          _HabitRow(
            key: const ValueKey<String>('agent-habit-stretch-row'),
            checked: _stretch,
            icon: CharcoalIcons.body,
            label: 'Morning stretch',
            onChanged: (value) => setState(() => _stretch = value),
            streak: '7 days',
          ),
          SizedBox(height: space.component30),
          _HabitRow(
            key: const ValueKey<String>('agent-habit-walk-row'),
            checked: _walk,
            icon: CharcoalIcons.location,
            label: 'Walk outside',
            onChanged: (value) => setState(() => _walk = value),
            streak: '3 days',
          ),
          SizedBox(height: space.component30),
          _HabitRow(
            key: const ValueKey<String>('agent-habit-read-row'),
            checked: _read,
            icon: CharcoalIcons.book,
            label: 'Read for 20 minutes',
            onChanged: (value) => setState(() => _read = value),
            streak: '5 days',
          ),
          SizedBox(height: space.component25),
          if (_completed == 3)
            _SimulationActionPanel(
              actionLabel: 'Plan tomorrow',
              description: 'You completed every gentle commitment for today.',
              onAction: () => setState(() => _selectedBottomIndex = 1),
              title: 'A complete day',
            )
          else
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: theme.colors.containerSecondaryDefault,
              ),
              child: Padding(
                padding: EdgeInsets.all(space.component25),
                child: Row(
                  children: <Widget>[
                    CharcoalIcon(
                      CharcoalIcons.bulbShine,
                      color: theme.colors.iconNoticeDefault,
                    ),
                    SizedBox(width: space.component20),
                    Expanded(
                      child: Text(
                        'Consistency grows from kindness, not pressure.',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJourney(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-journey-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'YOUR JOURNEY',
            title: 'A week made from small moments',
          ),
          SizedBox(height: space.component25),
          for (final day in <(String, String)>[
            ('Monday', '$_completed of 3 complete'),
            ('Sunday', '3 of 3 complete'),
            ('Saturday', '2 of 3 complete'),
            ('Friday', '3 of 3 complete'),
          ]) ...<Widget>[
            _PhoneSurface(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      day.$1,
                      style: theme.textStyles.captionMediumBold.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                  ),
                  Text(
                    day.$2,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: space.component20),
          ],
          CharcoalButton(
            key: const ValueKey<String>('agent-habits-return-today'),
            fullWidth: true,
            onPressed: () => setState(() => _selectedBottomIndex = 0),
            child: const Text('Return to today'),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-insights-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'INSIGHTS',
            title: 'Notice what is already working',
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message: 'This week: ${14 + _completed} habits completed',
          ),
          SizedBox(height: space.component20),
          const _SimulationStatus(message: 'Strongest rhythm: Morning stretch'),
          SizedBox(height: space.component20),
          const _SimulationStatus(message: 'Kindest streak: 7 gentle days'),
        ],
      ),
    );
  }

  Widget _buildHabitProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'PROFILE',
            title: 'Make Daylight feel like yours',
          ),
          SizedBox(height: space.component25),
          CharcoalSwitch(
            label: const Text('Gentle evening reminder'),
            onChanged: (value) => setState(() => _reminders = value),
            value: _reminders,
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message: _reminders
                ? 'Evening reminders arrive at 8:30 PM.'
                : 'Evening reminders are paused.',
          ),
        ],
      ),
    );
  }
}

final class _PhoneDemoShell extends StatelessWidget {
  const _PhoneDemoShell({
    required this.appKey,
    required this.appLabel,
    required this.bottomItems,
    required this.brand,
    required this.brandColor,
    required this.brandForeground,
    required this.brandMark,
    required this.content,
    required this.onBottomItemSelected,
    required this.selectedBottomIndex,
    required this.trailing,
    this.navigationBar,
  });

  final String appKey;
  final String appLabel;
  final List<_BottomItem> bottomItems;
  final String brand;
  final Color brandColor;
  final Color brandForeground;
  final String brandMark;
  final Widget content;
  final ValueChanged<int> onBottomItemSelected;
  final int selectedBottomIndex;
  final Widget trailing;
  final Widget? navigationBar;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: appLabel,
      child: ColoredBox(
        color: theme.colors.backgroundSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (navigationBar != null)
              navigationBar!
            else
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.colors.borderSecondary),
                  ),
                  color: theme.colors.backgroundDefault,
                ),
                child: SizedBox(
                  height: 64,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: space.component30,
                      vertical: space.component25,
                    ),
                    child: Row(
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              theme.dimensions.radius.m,
                            ),
                            color: brandColor,
                          ),
                          child: SizedBox.square(
                            dimension: 36,
                            child: Center(
                              child: Text(
                                brandMark,
                                style: theme.textStyles.captionMediumBold
                                    .copyWith(color: brandForeground),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: space.component20),
                        Expanded(
                          child: Text(
                            brand,
                            style: theme.textStyles.bodyBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                        ),
                        trailing,
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey<String>('agent-$appKey-scroll'),
                child: content,
              ),
            ),
            _MobileBottomBar(
              appKey: appKey,
              items: bottomItems,
              onSelected: onBottomItemSelected,
              selectedIndex: selectedBottomIndex,
            ),
          ],
        ),
      ),
    );
  }
}

final class _BottomItem {
  const _BottomItem(this.label, this.icon);

  final CharcoalIconData icon;
  final String label;
}

final class _MobileBottomBar extends StatelessWidget {
  const _MobileBottomBar({
    required this.appKey,
    required this.items,
    required this.onSelected,
    required this.selectedIndex,
  });

  final String appKey;
  final List<_BottomItem> items;
  final ValueChanged<int> onSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: <Widget>[
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: _BottomNavItem(
                  appKey: appKey,
                  item: items[index],
                  onPressed: () => onSelected(index),
                  selected: index == selectedIndex,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.appKey,
    required this.item,
    required this.onPressed,
    required this.selected,
  });

  final String appKey;
  final _BottomItem item;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      key: ValueKey<String>('agent-$appKey-nav-${item.label.toLowerCase()}'),
      onPressed: onPressed,
      selected: selected,
      semanticLabel: item.label,
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        color: selected ? theme.colors.containerSecondaryDefaultA : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CharcoalIcon(
              item.icon,
              color: selected
                  ? theme.colors.iconDefault
                  : theme.colors.iconTertiaryDefault,
              size: 20,
            ),
            SizedBox(height: theme.dimensions.space.component10),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyles.captionSmall.copyWith(
                color: selected
                    ? theme.colors.textDefault
                    : theme.colors.textTertiaryDefault,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PhoneSurface extends StatelessWidget {
  const _PhoneSurface({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.dimensions.space.component25),
        child: child,
      ),
    );
  }
}

final class _PhonePageHeading extends StatelessWidget {
  const _PhonePageHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textSecondaryDefault,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: space.component10),
        Text(
          title,
          style: theme.textStyles.headingXxs.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
      ],
    );
  }
}

final class _PhoneSectionTitle extends StatelessWidget {
  const _PhoneSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Text(
      title,
      style: theme.textStyles.captionMediumBold.copyWith(
        color: theme.colors.textDefault,
      ),
    );
  }
}

final class _SimulationStatus extends StatelessWidget {
  const _SimulationStatus({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.containerSecondaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.component20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.checkCircle,
              color: theme.colors.iconSecondaryDefault,
              size: 18,
            ),
            SizedBox(width: space.component20),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SimulationActionPanel extends StatelessWidget {
  const _SimulationActionPanel({
    required this.actionLabel,
    required this.description,
    required this.onAction,
    required this.title,
    this.actionEnabled = true,
    this.child,
  });

  final bool actionEnabled;
  final String actionLabel;
  final Widget? child;
  final String description;
  final VoidCallback onAction;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          if (child != null) ...<Widget>[
            SizedBox(height: space.component25),
            child!,
          ],
          SizedBox(height: space.component25),
          CharcoalButton(
            fullWidth: true,
            onPressed: actionEnabled ? onAction : null,
            variant: CharcoalButtonVariant.primary,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

final class _SimulationEmptyState extends StatelessWidget {
  const _SimulationEmptyState({required this.description, required this.title});

  final String description;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIcon(
            CharcoalIcons.search,
            color: theme.colors.iconSecondaryDefault,
          ),
          SizedBox(height: space.component20),
          Text(
            title,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      children: <Widget>[
        Text(
          value,
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        SizedBox(height: space.component10),
        Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
        ),
      ],
    );
  }
}

final class _DemoAvatar extends StatelessWidget {
  const _DemoAvatar({
    required this.initials,
    required this.size,
    required this.tone,
  });

  final String initials;
  final double size;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final background = switch (tone % 4) {
      0 => theme.colors.containerPrimaryDefault,
      1 => theme.colors.containerDiscoveryDefault,
      2 => theme.colors.containerNoticeDefault,
      _ => theme.colors.containerPositiveDefault,
    };
    final foreground = switch (tone % 4) {
      0 => theme.colors.textOnPrimaryDefault,
      1 => theme.colors.textOnDiscoveryDefault,
      2 => theme.colors.textOnNoticeDefault,
      _ => theme.colors.textOnPositiveDefault,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: background,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            initials,
            style: theme.textStyles.captionSmall.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

final class _DemoArtwork extends StatelessWidget {
  const _DemoArtwork({required this.height, required this.tone});

  final double height;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final palette = switch (tone % 4) {
      0 => (
        theme.colors.containerPrimaryDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNoticeDefault,
      ),
      1 => (
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerPositiveDefault,
        theme.colors.backgroundDefault,
      ),
      2 => (
        theme.colors.containerNoticeDefault,
        theme.colors.containerPrimaryDefault,
        theme.colors.containerNegativeDefault,
      ),
      _ => (
        theme.colors.containerPositiveDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNeutralDefault,
      ),
    };
    return Semantics(
      image: true,
      label: 'Abstract content artwork',
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: ClipRect(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[palette.$1, palette.$2],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: -48,
                    left: -28,
                    child: _DecorativeCircle(color: palette.$3, size: 148),
                  ),
                  Positioned(
                    right: 30,
                    top: 28,
                    child: Transform.rotate(
                      angle: -0.28,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            theme.dimensions.radius.m,
                          ),
                          color: palette.$3.withValues(alpha: 0.76),
                        ),
                        child: const SizedBox.square(dimension: 78),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: color,
    ),
    child: SizedBox.square(dimension: size),
  );
}

final class _PromoShape extends StatelessWidget {
  const _PromoShape({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: 0.24,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color,
      ),
      child: const SizedBox.square(dimension: 60),
    ),
  );
}

final class _MiniProductCard extends StatelessWidget {
  const _MiniProductCard({
    required this.name,
    required this.onOpen,
    required this.onSave,
    required this.price,
    required this.saveKey,
    required this.saved,
    required this.tone,
    super.key,
  });

  final String name;
  final VoidCallback onOpen;
  final VoidCallback onSave;
  final String price;
  final Key saveKey;
  final bool saved;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalClickable(
            onPressed: onOpen,
            semanticLabel: 'Open $name',
            builder: (context, states) => AnimatedOpacity(
              duration: CharcoalMotion.resolveDuration(
                context,
                CharcoalMotion.fast,
              ),
              opacity: states.contains(WidgetState.pressed) ? 0.76 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(theme.dimensions.radius.m),
                ),
                child: _DemoArtwork(height: 72, tone: tone),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              space.component20,
              space.component20,
              space.component10,
              space.component20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textDefault,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        price,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
                CharcoalIconButton(
                  key: saveKey,
                  icon: const CharcoalIcon(CharcoalIcons.bookmark),
                  onPressed: onSave,
                  selected: saved,
                  semanticLabel: saved
                      ? 'Remove saved product'
                      : 'Save product',
                  size: CharcoalIconButtonSize.extraSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.action,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.selected,
  });

  final _WalletAction action;
  final CharcoalIconData icon;
  final String label;
  final ValueChanged<_WalletAction> onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      children: <Widget>[
        CharcoalIconButton(
          key: ValueKey<String>('agent-wallet-action-${action.name}'),
          icon: CharcoalIcon(icon),
          onPressed: () => onPressed(action),
          selected: selected,
          semanticLabel: label,
          size: CharcoalIconButtonSize.small,
        ),
        SizedBox(height: theme.dimensions.space.component10),
        Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textSecondaryDefault,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

final class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.amount,
    required this.icon,
    required this.subtitle,
    required this.title,
    this.positive = false,
  });

  final String amount;
  final CharcoalIconData icon;
  final bool positive;
  final String subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return SizedBox(
      height: 52,
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerSecondaryDefault,
            ),
            child: SizedBox.square(
              dimension: 38,
              child: Center(
                child: CharcoalIcon(
                  icon,
                  color: theme.colors.iconDefault,
                  size: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: space.component20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textDefault,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textTertiaryDefault,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: space.component20),
          Text(
            amount,
            style: theme.textStyles.captionSmall.copyWith(
              color: positive
                  ? theme.colors.textPositiveDefault
                  : theme.colors.textDefault,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

final class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.checked,
    required this.icon,
    required this.label,
    required this.onChanged,
    required this.streak,
    super.key,
  });

  final bool checked;
  final CharcoalIconData icon;
  final String label;
  final ValueChanged<bool> onChanged;
  final String streak;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      padding: EdgeInsets.symmetric(
        horizontal: space.component30,
        vertical: space.component20,
      ),
      child: Row(
        children: <Widget>[
          CharcoalIcon(
            icon,
            color: theme.colors.iconSecondaryDefault,
            size: 20,
          ),
          SizedBox(width: space.component30),
          Expanded(
            child: CharcoalCheckbox(
              label: Text(label),
              onChanged: onChanged,
              rounded: true,
              semanticLabel: label,
              value: checked,
            ),
          ),
          SizedBox(width: space.component20),
          Text(
            streak,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
