part of 'bloom.dart';

/// Complete, stateful Bloom simulation used by the Agent Ready gallery.
final class BloomDemo extends StatefulWidget {
  const BloomDemo({super.key});

  @override
  State<BloomDemo> createState() => _BloomDemoState();
}

final class _BloomDemoState extends State<BloomDemo> {
  late final BloomViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BloomViewModel(BloomRepository());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Navigator(
    onGenerateRoute: (_) => PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final state = _viewModel.state;
              final route = state.route;
              final focusedTask =
                  route?.kind == BloomRouteKind.conversation ||
                  route?.kind == BloomRouteKind.comments ||
                  route?.kind == BloomRouteKind.story;
              return _BloomShell(
                content: _buildContent(state),
                contentKey: route?.storageKey ?? state.destination.name,
                navigationBar: _buildNavigationBar(context, state),
                onDestinationSelected: _viewModel.selectDestination,
                scrollContent: !focusedTask,
                selectedDestination: state.destination,
                showBottomNavigation: route == null,
                unreadMessages: state.unreadConversationCount,
              );
            },
          ),
    ),
  );

  Widget _buildContent(BloomViewState state) {
    final route = state.route;
    if (route != null) {
      return switch (route.kind) {
        BloomRouteKind.story => _BloomStoryPage(
          key: ValueKey<String>(route.storageKey),
          creatorId: route.id!,
          viewModel: _viewModel,
        ),
        BloomRouteKind.topic => _BloomTopicPage(
          key: ValueKey<String>(route.storageKey),
          topicId: route.id!,
          viewModel: _viewModel,
        ),
        BloomRouteKind.creator => _BloomCreatorPage(
          key: ValueKey<String>(route.storageKey),
          creatorId: route.id!,
          viewModel: _viewModel,
        ),
        BloomRouteKind.conversation => _BloomConversationPage(
          key: ValueKey<String>(route.storageKey),
          conversationId: route.id!,
          viewModel: _viewModel,
        ),
        BloomRouteKind.comments => _BloomCommentsPage(
          key: ValueKey<String>(route.storageKey),
          postId: route.id!,
          viewModel: _viewModel,
        ),
        BloomRouteKind.composer => _BloomComposerPage(
          key: ValueKey<String>(route.storageKey),
          viewModel: _viewModel,
        ),
        BloomRouteKind.notifications => _BloomNotificationsPage(
          key: ValueKey<String>(route.storageKey),
          viewModel: _viewModel,
        ),
        BloomRouteKind.profileEditor => _BloomProfileEditorPage(
          key: ValueKey<String>(route.storageKey),
          viewModel: _viewModel,
        ),
        BloomRouteKind.post => _BloomPostDetailPage(
          key: ValueKey<String>(route.storageKey),
          postId: route.id!,
          viewModel: _viewModel,
        ),
      };
    }
    return switch (state.destination) {
      BloomDestination.home => _BloomHomePage(viewModel: _viewModel),
      BloomDestination.discover => _BloomDiscoverPage(viewModel: _viewModel),
      BloomDestination.messages => _BloomMessagesPage(viewModel: _viewModel),
      BloomDestination.profile => _BloomProfilePage(viewModel: _viewModel),
    };
  }

  Widget _buildNavigationBar(BuildContext context, BloomViewState state) {
    final route = state.route;
    if (route != null) {
      final title = switch (route.kind) {
        BloomRouteKind.story => state.data.creator(route.id!).name,
        BloomRouteKind.topic => state.data.topic(route.id!).label,
        BloomRouteKind.creator => state.data.creator(route.id!).name,
        BloomRouteKind.conversation =>
          state.data.creator(state.data.conversation(route.id!).creatorId).name,
        BloomRouteKind.comments => 'Comments',
        BloomRouteKind.composer => 'New post',
        BloomRouteKind.notifications => 'Notifications',
        BloomRouteKind.profileEditor => 'Edit profile',
        BloomRouteKind.post => 'Post',
      };
      return CharcoalNavigationBar(
        leading: CharcoalIconButton(
          key: const ValueKey<String>('agent-social-page-back'),
          icon: CharcoalIcon(
            route.kind == BloomRouteKind.composer
                ? CharcoalIcons.x
                : CharcoalIcons.chevronLeft,
          ),
          onPressed: () => _handleBack(context, state),
          semanticLabel: _backSemanticLabel(route.kind),
          size: CharcoalIconButtonSize.small,
        ),
        semanticLabel: '$title navigation',
        title: Text(title),
        trailing: switch (route.kind) {
          BloomRouteKind.composer => CharcoalButton(
            key: const ValueKey<String>('agent-social-publish-post'),
            onPressed: state.canPublish && !state.publishing
                ? () => _publish(context)
                : null,
            size: CharcoalButtonSize.small,
            variant: CharcoalButtonVariant.primary,
            child: Text(state.publishing ? 'Posting…' : 'Post'),
          ),
          BloomRouteKind.notifications => CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons.check),
            onPressed: state.unreadNotificationCount > 0
                ? () {
                    _viewModel.markAllNotificationsRead();
                    showCharcoalToast(
                      context: context,
                      message: 'All activity marked as read',
                      useRootOverlay: false,
                    );
                  }
                : null,
            semanticLabel: 'Mark all notifications as read',
            size: CharcoalIconButtonSize.small,
          ),
          BloomRouteKind.profileEditor => CharcoalButton(
            key: const ValueKey<String>('agent-social-save-profile'),
            onPressed: state.profileDraftValid && state.profileDirty
                ? () => _saveProfile(context)
                : null,
            size: CharcoalButtonSize.small,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Save'),
          ),
          _ => null,
        },
      );
    }

    final title = switch (state.destination) {
      BloomDestination.home => 'Bloom',
      BloomDestination.discover => 'Discover',
      BloomDestination.messages => 'Messages',
      BloomDestination.profile => 'Profile',
    };
    return CharcoalNavigationBar(
      leading: state.destination == BloomDestination.home
          ? const _BloomBrandMark()
          : null,
      semanticLabel: '$title navigation',
      title: Text(title),
      trailing: switch (state.destination) {
        BloomDestination.home => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIconButton(
              key: const ValueKey<String>('agent-social-new-post'),
              icon: const CharcoalIcon(CharcoalIcons.penAdd),
              onPressed: _viewModel.openComposer,
              semanticLabel: state.hasSavedDraft
                  ? 'Continue draft post'
                  : 'Create a post',
              size: CharcoalIconButtonSize.small,
            ),
            SizedBox(
              width: CharcoalTheme.of(context).dimensions.space.component10,
            ),
            _BloomNotificationButton(
              onPressed: _viewModel.openNotifications,
              unreadCount: state.unreadNotificationCount,
            ),
          ],
        ),
        BloomDestination.profile => CharcoalIconButton(
          key: const ValueKey<String>('agent-social-edit-profile'),
          icon: const CharcoalIcon(CharcoalIcons.penText),
          onPressed: _viewModel.openProfileEditor,
          semanticLabel: 'Edit profile',
          size: CharcoalIconButtonSize.small,
        ),
        _ => null,
      },
    );
  }

  String _backSemanticLabel(BloomRouteKind kind) => switch (kind) {
    BloomRouteKind.story => 'Return to home',
    BloomRouteKind.topic || BloomRouteKind.creator => 'Return to discover',
    BloomRouteKind.conversation => 'Return to messages',
    BloomRouteKind.comments => 'Return to post',
    BloomRouteKind.composer => 'Close new post',
    BloomRouteKind.notifications => 'Return to home',
    BloomRouteKind.profileEditor => 'Return to profile',
    BloomRouteKind.post => 'Return to previous page',
  };

  Future<void> _handleBack(BuildContext context, BloomViewState state) async {
    switch (state.route?.kind) {
      case BloomRouteKind.composer when state.composerDirty:
        final choice = await showCharcoalModal<_BloomExitChoice>(
          actions: <Widget>[
            CharcoalButton(
              key: const ValueKey<String>('agent-social-save-draft'),
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(_BloomExitChoice.save),
              variant: CharcoalButtonVariant.primary,
              child: const Text('Save draft'),
            ),
            CharcoalButton(
              key: const ValueKey<String>('agent-social-discard-post'),
              fullWidth: true,
              onPressed: () =>
                  Navigator.of(context).pop(_BloomExitChoice.discard),
              variant: CharcoalButtonVariant.danger,
              child: const Text('Discard post'),
            ),
            CharcoalButton(
              key: const ValueKey<String>('agent-social-keep-editing-post'),
              fullWidth: true,
              onPressed: () =>
                  Navigator.of(context).pop(_BloomExitChoice.keepEditing),
              child: const Text('Keep editing'),
            ),
          ],
          child: const _BloomModalMessage(
            'Keep the thought for later or discard it permanently.',
          ),
          context: context,
          maxWidth: 360,
          style: CharcoalModalStyle.bottomSheet,
          title: 'Leave this post?',
          useRootNavigator: false,
        );
        if (!context.mounted) return;
        switch (choice) {
          case _BloomExitChoice.save:
            _viewModel.saveComposerDraft();
            showCharcoalToast(
              context: context,
              message: 'Draft saved',
              useRootOverlay: false,
            );
          case _BloomExitChoice.discard:
            _viewModel.discardComposer();
          case _BloomExitChoice.keepEditing || null:
            return;
        }
      case BloomRouteKind.profileEditor when state.profileDirty:
        final choice = await showCharcoalModal<_BloomExitChoice>(
          actions: <Widget>[
            CharcoalButton(
              key: const ValueKey<String>('agent-social-save-profile-exit'),
              fullWidth: true,
              onPressed: state.profileDraftValid
                  ? () => Navigator.of(context).pop(_BloomExitChoice.save)
                  : null,
              variant: CharcoalButtonVariant.primary,
              child: const Text('Save changes'),
            ),
            CharcoalButton(
              key: const ValueKey<String>(
                'agent-social-discard-profile-changes',
              ),
              fullWidth: true,
              onPressed: () =>
                  Navigator.of(context).pop(_BloomExitChoice.discard),
              variant: CharcoalButtonVariant.danger,
              child: const Text('Discard changes'),
            ),
            CharcoalButton(
              key: const ValueKey<String>('agent-social-keep-editing-profile'),
              fullWidth: true,
              onPressed: () =>
                  Navigator.of(context).pop(_BloomExitChoice.keepEditing),
              child: const Text('Keep editing'),
            ),
          ],
          child: const _BloomModalMessage(
            'Choose what should happen to your profile changes.',
          ),
          context: context,
          maxWidth: 360,
          style: CharcoalModalStyle.bottomSheet,
          title: 'Unsaved profile changes',
          useRootNavigator: false,
        );
        if (!context.mounted) return;
        switch (choice) {
          case _BloomExitChoice.save:
            _saveProfile(context);
          case _BloomExitChoice.discard:
            _viewModel.discardProfileChanges();
          case _BloomExitChoice.keepEditing || null:
            return;
        }
      default:
        _viewModel.popRoute();
    }
  }

  Future<void> _publish(BuildContext context) async {
    final published = await _viewModel.publish();
    if (!context.mounted || !published) return;
    showCharcoalToast(
      context: context,
      message: 'Post published',
      useRootOverlay: false,
    );
  }

  void _saveProfile(BuildContext context) {
    if (!_viewModel.saveProfile()) return;
    showCharcoalToast(
      context: context,
      message: 'Profile updated',
      useRootOverlay: false,
    );
  }
}

enum _BloomExitChoice { keepEditing, save, discard }

final class _BloomModalMessage extends StatelessWidget {
  const _BloomModalMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space.component25),
      child: CharcoalTypography(child: Text(message)),
    );
  }
}
