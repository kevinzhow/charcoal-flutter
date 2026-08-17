import 'package:flutter/foundation.dart';

import 'bloom_model.dart';
import 'bloom_repository.dart';

final class BloomViewState {
  BloomViewState({
    required this.audience,
    required this.composerAltText,
    required this.composerCaption,
    required this.composerTone,
    required this.data,
    required this.destination,
    required this.discoverQuery,
    required this.feed,
    required this.hasSavedDraft,
    required this.profileDraftBio,
    required this.profileDraftName,
    required this.profileDraftTone,
    required this.profileTab,
    required this.publishing,
    required List<BloomRoute> routeStack,
  }) : routeStack = List<BloomRoute>.unmodifiable(routeStack);

  final BloomAudience audience;
  final String composerAltText;
  final String composerCaption;
  final int? composerTone;
  final BloomData data;
  final BloomDestination destination;
  final String discoverQuery;
  final BloomFeed feed;
  final bool hasSavedDraft;
  final String profileDraftBio;
  final String profileDraftName;
  final int profileDraftTone;
  final BloomProfileTab profileTab;
  final bool publishing;
  final List<BloomRoute> routeStack;

  BloomRoute? get route => routeStack.isEmpty ? null : routeStack.last;

  bool get composerDirty =>
      composerTone != null ||
      composerCaption.trim().isNotEmpty ||
      composerAltText.trim().isNotEmpty;

  bool get canPublish =>
      composerTone != null || composerCaption.trim().isNotEmpty;

  bool get profileDraftValid => profileDraftName.trim().isNotEmpty;

  bool get profileDirty =>
      profileDraftName.trim() != data.profile.name ||
      profileDraftBio.trim() != data.profile.bio ||
      profileDraftTone != data.profile.tone;

  int get unreadConversationCount =>
      data.conversations.where((conversation) => conversation.unread).length;

  int get unreadNotificationCount =>
      data.notifications.where((notification) => notification.unread).length;
}

final class BloomViewModel extends ChangeNotifier {
  BloomViewModel(this._repository);

  final BloomRepository _repository;
  BloomDestination _destination = BloomDestination.home;
  BloomFeed _feed = BloomFeed.following;
  BloomProfileTab _profileTab = BloomProfileTab.posts;
  final List<BloomRoute> _routeStack = <BloomRoute>[];
  String _discoverQuery = '';
  BloomAudience _audience = BloomAudience.circle;
  String _composerCaption = '';
  String _composerAltText = '';
  int? _composerTone;
  bool _hasSavedDraft = false;
  bool _publishing = false;
  String _profileDraftName = '';
  String _profileDraftBio = '';
  int _profileDraftTone = 0;
  bool _disposed = false;

  BloomViewState get state => BloomViewState(
    audience: _audience,
    composerAltText: _composerAltText,
    composerCaption: _composerCaption,
    composerTone: _composerTone,
    data: _repository.snapshot(),
    destination: _destination,
    discoverQuery: _discoverQuery,
    feed: _feed,
    hasSavedDraft: _hasSavedDraft,
    profileDraftBio: _profileDraftBio,
    profileDraftName: _profileDraftName,
    profileDraftTone: _profileDraftTone,
    profileTab: _profileTab,
    publishing: _publishing,
    routeStack: _routeStack,
  );

  void selectDestination(BloomDestination destination) {
    _destination = destination;
    _routeStack.clear();
    _notify();
  }

  void changeFeed(BloomFeed feed) {
    _feed = feed;
    _notify();
  }

  void changeProfileTab(BloomProfileTab tab) {
    _profileTab = tab;
    _notify();
  }

  void updateDiscoverQuery(String query) {
    _discoverQuery = query;
    _notify();
  }

  void clearDiscoverQuery() {
    _discoverQuery = '';
    _notify();
  }

  void openStory(String creatorId) =>
      _push(BloomRoute(BloomRouteKind.story, id: creatorId));

  void openTopic(String topicId) =>
      _push(BloomRoute(BloomRouteKind.topic, id: topicId));

  void openCreator(String creatorId) =>
      _push(BloomRoute(BloomRouteKind.creator, id: creatorId));

  void openPost(String postId) =>
      _push(BloomRoute(BloomRouteKind.post, id: postId));

  void openComments(String postId) =>
      _push(BloomRoute(BloomRouteKind.comments, id: postId));

  void openNotifications() =>
      _push(const BloomRoute(BloomRouteKind.notifications));

  void openConversation(String conversationId) {
    _repository.markConversationRead(conversationId);
    _push(BloomRoute(BloomRouteKind.conversation, id: conversationId));
  }

  void openConversationForCreator(String creatorId) {
    final conversation = state.data.conversations.firstWhere(
      (item) => item.creatorId == creatorId,
    );
    openConversation(conversation.id);
  }

  void openComposer() {
    if (!_hasSavedDraft) _clearComposer();
    _push(const BloomRoute(BloomRouteKind.composer));
  }

  void openProfileEditor() {
    final profile = state.data.profile;
    _profileDraftName = profile.name;
    _profileDraftBio = profile.bio;
    _profileDraftTone = profile.tone;
    _push(const BloomRoute(BloomRouteKind.profileEditor));
  }

  void popRoute() {
    if (_routeStack.isNotEmpty) {
      _routeStack.removeLast();
      _notify();
    }
  }

  void updateComposerCaption(String value) {
    _composerCaption = value;
    _notify();
  }

  void updateComposerAltText(String value) {
    _composerAltText = value;
    _notify();
  }

  void changeComposerArtwork() {
    _composerTone = _composerTone == null ? 0 : (_composerTone! + 1) % 4;
    _notify();
  }

  void changeAudience(BloomAudience value) {
    _audience = value;
    _notify();
  }

  void saveComposerDraft() {
    _hasSavedDraft = true;
    popRoute();
  }

  void discardComposer() {
    _clearComposer();
    popRoute();
  }

  Future<bool> publish() async {
    if (!state.canPublish || _publishing) return false;
    _publishing = true;
    _notify();
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (_disposed) return false;
    _repository.publish(
      altText: _composerAltText.trim(),
      audience: _audience,
      copy: _composerCaption.trim(),
      tone: _composerTone ?? 0,
    );
    _clearComposer();
    _publishing = false;
    _feed = BloomFeed.following;
    _destination = BloomDestination.home;
    _routeStack.clear();
    _notify();
    return true;
  }

  void toggleLike(String postId) {
    _repository.toggleLike(postId);
    _notify();
  }

  void toggleSave(String postId) {
    _repository.toggleSave(postId);
    _notify();
  }

  void toggleFollow(String creatorId) {
    _repository.toggleFollow(creatorId);
    _notify();
  }

  void hidePost(String postId) {
    _repository.hidePost(postId);
    _notify();
  }

  void restorePost(String postId) {
    _repository.restorePost(postId);
    _notify();
  }

  void addComment(String postId, String text) {
    _repository.addComment(postId, text);
    _notify();
  }

  Future<void> sendMessage(String conversationId, String text) async {
    final normalized = text.trim();
    if (normalized.isEmpty) return;
    final messageId = _repository.queueMessage(conversationId, normalized);
    _notify();
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (_disposed) return;
    _repository.markMessageSent(conversationId, messageId);
    _notify();
  }

  Future<void> retryMessage(String conversationId, String messageId) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (_disposed) return;
    _repository.markMessageSent(conversationId, messageId);
    _notify();
  }

  Future<void> replyToStory(String creatorId, String text) async {
    final conversation = state.data.conversations.firstWhere(
      (item) => item.creatorId == creatorId,
    );
    final messageId = _repository.queueMessage(conversation.id, text.trim());
    _repository.markConversationRead(conversation.id);
    _destination = BloomDestination.messages;
    _routeStack
      ..clear()
      ..add(BloomRoute(BloomRouteKind.conversation, id: conversation.id));
    _notify();
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (_disposed) return;
    _repository.markMessageSent(conversation.id, messageId);
    _notify();
  }

  void markAllNotificationsRead() {
    _repository.markAllNotificationsRead();
    _notify();
  }

  void openNotification(BloomNotification notification) {
    _repository.markNotificationRead(notification.id);
    final route = switch (notification.kind) {
      BloomNotificationKind.likedPost => BloomRoute(
        BloomRouteKind.post,
        id: notification.targetId,
      ),
      BloomNotificationKind.followed => BloomRoute(
        BloomRouteKind.creator,
        id: notification.targetId,
      ),
    };
    _routeStack.add(route);
    _notify();
  }

  void updateProfileDraftName(String value) {
    _profileDraftName = value;
    _notify();
  }

  void updateProfileDraftBio(String value) {
    _profileDraftBio = value;
    _notify();
  }

  void changeProfileTone() {
    _profileDraftTone = (_profileDraftTone + 1) % 4;
    _notify();
  }

  bool saveProfile() {
    final current = state;
    if (!current.profileDraftValid || !current.profileDirty) return false;
    _repository.updateProfile(
      bio: _profileDraftBio.trim(),
      name: _profileDraftName.trim(),
      tone: _profileDraftTone,
    );
    popRoute();
    return true;
  }

  void discardProfileChanges() => popRoute();

  void exploreFromProfile() {
    _profileTab = BloomProfileTab.posts;
    selectDestination(BloomDestination.discover);
  }

  void _push(BloomRoute route) {
    _routeStack.add(route);
    _notify();
  }

  void _clearComposer() {
    _audience = BloomAudience.circle;
    _composerAltText = '';
    _composerCaption = '';
    _composerTone = null;
    _hasSavedDraft = false;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
