enum BloomDestination { home, discover, messages, profile }

enum BloomFeed { following, forYou }

enum BloomAudience { circle, everyone }

enum BloomProfileTab { posts, saved }

enum BloomRouteKind {
  story,
  topic,
  creator,
  conversation,
  comments,
  composer,
  notifications,
  profileEditor,
  post,
}

enum BloomMessageDelivery { received, sending, sent, failed }

enum BloomNotificationKind { likedPost, followed }

final class BloomRoute {
  const BloomRoute(this.kind, {this.id});

  final BloomRouteKind kind;
  final String? id;

  String get storageKey => '${kind.name}-${id ?? 'root'}';
}

final class BloomCreator {
  const BloomCreator({
    required this.bio,
    required this.followers,
    required this.handle,
    required this.id,
    required this.initials,
    required this.location,
    required this.name,
    required this.tone,
  });

  final String bio;
  final int followers;
  final String handle;
  final String id;
  final String initials;
  final String location;
  final String name;
  final int tone;
}

final class BloomTopic {
  const BloomTopic({
    required this.description,
    required this.id,
    required this.label,
    required this.postIds,
  });

  final String description;
  final String id;
  final String label;
  final List<String> postIds;
}

final class BloomPost {
  const BloomPost({
    required this.altText,
    required this.audience,
    required this.comments,
    required this.copy,
    required this.creatorId,
    required this.id,
    required this.likes,
    required this.meta,
    required this.tone,
    required this.topicId,
  });

  final String altText;
  final BloomAudience audience;
  final int comments;
  final String copy;
  final String creatorId;
  final String id;
  final int likes;
  final String meta;
  final int tone;
  final String topicId;

  BloomPost copyWith({int? comments}) => BloomPost(
    altText: altText,
    audience: audience,
    comments: comments ?? this.comments,
    copy: copy,
    creatorId: creatorId,
    id: id,
    likes: likes,
    meta: meta,
    tone: tone,
    topicId: topicId,
  );
}

final class BloomComment {
  const BloomComment({
    required this.authorId,
    required this.id,
    required this.text,
    required this.time,
  });

  final String authorId;
  final String id;
  final String text;
  final String time;
}

final class BloomMessage {
  const BloomMessage({
    required this.delivery,
    required this.id,
    required this.own,
    required this.text,
  });

  final BloomMessageDelivery delivery;
  final String id;
  final bool own;
  final String text;

  BloomMessage copyWith({BloomMessageDelivery? delivery}) => BloomMessage(
    delivery: delivery ?? this.delivery,
    id: id,
    own: own,
    text: text,
  );
}

final class BloomConversation {
  const BloomConversation({
    required this.creatorId,
    required this.id,
    required this.messages,
    required this.time,
    required this.unread,
  });

  final String creatorId;
  final String id;
  final List<BloomMessage> messages;
  final String time;
  final bool unread;

  String get preview =>
      messages.isEmpty ? 'Start a conversation' : messages.last.text;

  BloomConversation copyWith({
    List<BloomMessage>? messages,
    String? time,
    bool? unread,
  }) => BloomConversation(
    creatorId: creatorId,
    id: id,
    messages: List<BloomMessage>.unmodifiable(messages ?? this.messages),
    time: time ?? this.time,
    unread: unread ?? this.unread,
  );
}

final class BloomNotification {
  const BloomNotification({
    required this.description,
    required this.id,
    required this.kind,
    required this.targetId,
    required this.time,
    required this.unread,
  });

  final String description;
  final String id;
  final BloomNotificationKind kind;
  final String targetId;
  final String time;
  final bool unread;

  BloomNotification copyWith({bool? unread}) => BloomNotification(
    description: description,
    id: id,
    kind: kind,
    targetId: targetId,
    time: time,
    unread: unread ?? this.unread,
  );
}

final class BloomProfile {
  const BloomProfile({
    required this.bio,
    required this.handle,
    required this.location,
    required this.name,
    required this.tone,
  });

  final String bio;
  final String handle;
  final String location;
  final String name;
  final int tone;
}

final class BloomData {
  BloomData({
    required Map<String, List<BloomComment>> commentsByPost,
    required List<BloomConversation> conversations,
    required List<BloomCreator> creators,
    required Set<String> followedCreatorIds,
    required Set<String> hiddenPostIds,
    required Set<String> likedPostIds,
    required List<BloomNotification> notifications,
    required List<BloomPost> posts,
    required this.profile,
    required Set<String> savedPostIds,
    required List<BloomTopic> topics,
  }) : commentsByPost = Map<String, List<BloomComment>>.unmodifiable(
         <String, List<BloomComment>>{
           for (final entry in commentsByPost.entries)
             entry.key: List<BloomComment>.unmodifiable(entry.value),
         },
       ),
       conversations = List<BloomConversation>.unmodifiable(conversations),
       creators = List<BloomCreator>.unmodifiable(creators),
       followedCreatorIds = Set<String>.unmodifiable(followedCreatorIds),
       hiddenPostIds = Set<String>.unmodifiable(hiddenPostIds),
       likedPostIds = Set<String>.unmodifiable(likedPostIds),
       notifications = List<BloomNotification>.unmodifiable(notifications),
       posts = List<BloomPost>.unmodifiable(posts),
       savedPostIds = Set<String>.unmodifiable(savedPostIds),
       topics = List<BloomTopic>.unmodifiable(topics);

  final Map<String, List<BloomComment>> commentsByPost;
  final List<BloomConversation> conversations;
  final List<BloomCreator> creators;
  final Set<String> followedCreatorIds;
  final Set<String> hiddenPostIds;
  final Set<String> likedPostIds;
  final List<BloomNotification> notifications;
  final List<BloomPost> posts;
  final BloomProfile profile;
  final Set<String> savedPostIds;
  final List<BloomTopic> topics;

  BloomCreator creator(String id) =>
      creators.firstWhere((item) => item.id == id);

  BloomPost post(String id) => posts.firstWhere((item) => item.id == id);

  BloomTopic topic(String id) => topics.firstWhere((item) => item.id == id);

  BloomConversation conversation(String id) =>
      conversations.firstWhere((item) => item.id == id);

  List<BloomComment> commentsFor(String postId) =>
      commentsByPost[postId] ?? const <BloomComment>[];
}
