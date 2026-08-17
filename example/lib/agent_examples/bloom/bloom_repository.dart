import 'bloom_model.dart';

/// In-memory product data for the interactive Bloom simulation.
///
/// Keeping this outside the widgets makes every flow update one source of
/// truth: publishing affects Home and Profile, reading affects both the inbox
/// and its badge, and saving affects both the post and Saved.
final class BloomRepository {
  BloomRepository()
    : _profile = const BloomProfile(
        bio: 'Collecting overlooked color in everyday places.',
        handle: '@mina.color',
        location: 'Tokyo',
        name: 'Mina Aoki',
        tone: 2,
      ),
      _creators = const <BloomCreator>[
        BloomCreator(
          bio: 'Weather, color, and the quiet edges of the city.',
          followers: 842,
          handle: '@aki.afterrain',
          id: 'aki',
          initials: 'AK',
          location: 'Kamakura',
          name: 'Aki Kondo',
          tone: 1,
        ),
        BloomCreator(
          bio: 'Small paper worlds made from things already used.',
          followers: 1240,
          handle: '@noa.paper',
          id: 'noa',
          initials: 'NO',
          location: 'Tokyo',
          name: 'Noa Watanabe',
          tone: 2,
        ),
        BloomCreator(
          bio: 'Growing edible corners on a very small balcony.',
          followers: 618,
          handle: '@emi.grows',
          id: 'emi',
          initials: 'EM',
          location: 'Yokohama',
          name: 'Emi Sato',
          tone: 3,
        ),
      ],
      _topics = const <BloomTopic>[
        BloomTopic(
          description: 'Soft palettes and slow observations',
          id: 'quiet-color',
          label: 'Quiet color',
          postIds: <String>['post-aki-rain', 'post-mina-study'],
        ),
        BloomTopic(
          description: 'Collage, models, and tactile studies',
          id: 'paper-worlds',
          label: 'Paper worlds',
          postIds: <String>['post-noa-city'],
        ),
        BloomTopic(
          description: 'Small spaces growing with care',
          id: 'tiny-gardens',
          label: 'Tiny gardens',
          postIds: <String>['post-emi-mint'],
        ),
      ],
      _commentsByPost = <String, List<BloomComment>>{
        'post-mina-study': <BloomComment>[
          const BloomComment(
            authorId: 'aki',
            id: 'comment-mina-1',
            text: 'The apricot against that blue feels so calm.',
            time: 'Yesterday',
          ),
        ],
        'post-aki-rain': <BloomComment>[
          const BloomComment(
            authorId: 'noa',
            id: 'comment-aki-1',
            text: 'That small green band changes the whole palette.',
            time: '9 min',
          ),
          const BloomComment(
            authorId: 'emi',
            id: 'comment-aki-2',
            text: 'It really feels like the air just after rain.',
            time: '5 min',
          ),
        ],
        'post-emi-mint': <BloomComment>[
          const BloomComment(
            authorId: 'aki',
            id: 'comment-emi-1',
            text: 'The new leaves look incredibly bright.',
            time: '42 min',
          ),
        ],
        'post-noa-city': <BloomComment>[
          const BloomComment(
            authorId: 'mina',
            id: 'comment-noa-1',
            text: 'I love how the ticket marks became windows.',
            time: '2 hr',
          ),
        ],
      },
      _posts = <BloomPost>[
        const BloomPost(
          altText: 'Layered blue and apricot shapes after rain.',
          audience: BloomAudience.circle,
          comments: 8,
          copy: 'A color study from the walk home.',
          creatorId: 'mina',
          id: 'post-mina-study',
          likes: 67,
          meta: 'Yesterday · Tokyo',
          tone: 2,
          topicId: 'quiet-color',
        ),
        const BloomPost(
          altText: 'Muted bands of blue, green, and warm cloud light.',
          audience: BloomAudience.circle,
          comments: 24,
          copy: 'Found a quiet patch of color between the rain clouds.',
          creatorId: 'aki',
          id: 'post-aki-rain',
          likes: 128,
          meta: '12 min · Kamakura',
          tone: 0,
          topicId: 'quiet-color',
        ),
        const BloomPost(
          altText: 'Fresh mint leaves arranged on a warm green ground.',
          audience: BloomAudience.circle,
          comments: 12,
          copy: 'The balcony mint finally has new leaves.',
          creatorId: 'emi',
          id: 'post-emi-mint',
          likes: 96,
          meta: '1 hr · Yokohama',
          tone: 3,
          topicId: 'tiny-gardens',
        ),
        const BloomPost(
          altText: 'A miniature paper skyline made from train tickets.',
          audience: BloomAudience.everyone,
          comments: 41,
          copy: 'A tiny paper city built from yesterday’s train tickets.',
          creatorId: 'noa',
          id: 'post-noa-city',
          likes: 342,
          meta: 'Trending · Tokyo',
          tone: 2,
          topicId: 'paper-worlds',
        ),
      ],
      _conversations = <BloomConversation>[
        const BloomConversation(
          creatorId: 'aki',
          id: 'conversation-aki',
          messages: <BloomMessage>[
            BloomMessage(
              delivery: BloomMessageDelivery.received,
              id: 'message-aki-1',
              own: false,
              text: 'That rain-cloud palette is beautiful.',
            ),
          ],
          time: '12m',
          unread: true,
        ),
        const BloomConversation(
          creatorId: 'noa',
          id: 'conversation-noa',
          messages: <BloomMessage>[
            BloomMessage(
              delivery: BloomMessageDelivery.received,
              id: 'message-noa-1',
              own: false,
              text: 'I left the folding notes in the shared folder.',
            ),
          ],
          time: 'Tue',
          unread: false,
        ),
        const BloomConversation(
          creatorId: 'emi',
          id: 'conversation-emi',
          messages: <BloomMessage>[
            BloomMessage(
              delivery: BloomMessageDelivery.received,
              id: 'message-emi-1',
              own: false,
              text: 'The balcony mint finally has new leaves.',
            ),
          ],
          time: 'Sun',
          unread: false,
        ),
      ],
      _notifications = <BloomNotification>[
        const BloomNotification(
          description: 'Aki Kondo liked your color study.',
          id: 'notification-like',
          kind: BloomNotificationKind.likedPost,
          targetId: 'post-mina-study',
          time: '8 min',
          unread: true,
        ),
        const BloomNotification(
          description: 'Noa Watanabe started following you.',
          id: 'notification-follow',
          kind: BloomNotificationKind.followed,
          targetId: 'noa',
          time: 'Yesterday',
          unread: false,
        ),
      ];

  BloomProfile _profile;
  final List<BloomCreator> _creators;
  final List<BloomTopic> _topics;
  final Map<String, List<BloomComment>> _commentsByPost;
  final List<BloomPost> _posts;
  final List<BloomConversation> _conversations;
  final List<BloomNotification> _notifications;
  final Set<String> _followedCreatorIds = <String>{'aki', 'emi'};
  final Set<String> _hiddenPostIds = <String>{};
  final Set<String> _likedPostIds = <String>{};
  final Set<String> _savedPostIds = <String>{};
  var _commentSequence = 1;
  var _messageSequence = 1;
  var _postSequence = 2;

  BloomData snapshot() => BloomData(
    commentsByPost: _commentsByPost,
    conversations: _conversations,
    creators: _creators,
    followedCreatorIds: _followedCreatorIds,
    hiddenPostIds: _hiddenPostIds,
    likedPostIds: _likedPostIds,
    notifications: _notifications,
    posts: _posts,
    profile: _profile,
    savedPostIds: _savedPostIds,
    topics: _topics,
  );

  void toggleLike(String postId) => _toggle(_likedPostIds, postId);

  void toggleSave(String postId) => _toggle(_savedPostIds, postId);

  void toggleFollow(String creatorId) =>
      _toggle(_followedCreatorIds, creatorId);

  void hidePost(String postId) => _hiddenPostIds.add(postId);

  void restorePost(String postId) => _hiddenPostIds.remove(postId);

  void addComment(String postId, String text) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index < 0) return;
    _commentsByPost
        .putIfAbsent(postId, () => <BloomComment>[])
        .add(
          BloomComment(
            authorId: 'mina',
            id: 'comment-new-${_commentSequence++}',
            text: text,
            time: 'Now',
          ),
        );
    _posts[index] = _posts[index].copyWith(
      comments: _posts[index].comments + 1,
    );
  }

  String publish({
    required String altText,
    required BloomAudience audience,
    required String copy,
    required int tone,
  }) {
    final id = 'post-mina-${_postSequence++}';
    _posts.insert(
      0,
      BloomPost(
        altText: altText.isEmpty ? 'A new abstract color study.' : altText,
        audience: audience,
        comments: 0,
        copy: copy.isEmpty ? 'A quiet study from today.' : copy,
        creatorId: 'mina',
        id: id,
        likes: 0,
        meta: 'Just now · Tokyo',
        tone: tone,
        topicId: 'quiet-color',
      ),
    );
    return id;
  }

  void markConversationRead(String conversationId) {
    _replaceConversation(
      conversationId,
      (conversation) => conversation.copyWith(unread: false),
    );
  }

  String queueMessage(String conversationId, String text) {
    final messageId = 'message-sent-${_messageSequence++}';
    _replaceConversation(conversationId, (conversation) {
      final messages = <BloomMessage>[
        ...conversation.messages,
        BloomMessage(
          delivery: BloomMessageDelivery.sending,
          id: messageId,
          own: true,
          text: text,
        ),
      ];
      return conversation.copyWith(
        messages: messages,
        time: 'Now',
        unread: false,
      );
    });
    return messageId;
  }

  void markMessageSent(String conversationId, String messageId) {
    _replaceMessage(conversationId, messageId, BloomMessageDelivery.sent);
  }

  void markMessageFailed(String conversationId, String messageId) {
    _replaceMessage(conversationId, messageId, BloomMessageDelivery.failed);
  }

  void markNotificationRead(String notificationId) {
    final index = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(unread: false);
    }
  }

  void markAllNotificationsRead() {
    for (var index = 0; index < _notifications.length; index++) {
      _notifications[index] = _notifications[index].copyWith(unread: false);
    }
  }

  void updateProfile({
    required String bio,
    required String name,
    required int tone,
  }) {
    _profile = BloomProfile(
      bio: bio,
      handle: _profile.handle,
      location: _profile.location,
      name: name,
      tone: tone,
    );
  }

  void _replaceConversation(
    String id,
    BloomConversation Function(BloomConversation conversation) replace,
  ) {
    final index = _conversations.indexWhere((item) => item.id == id);
    if (index >= 0) _conversations[index] = replace(_conversations[index]);
  }

  void _replaceMessage(
    String conversationId,
    String messageId,
    BloomMessageDelivery delivery,
  ) {
    _replaceConversation(conversationId, (conversation) {
      final messages = <BloomMessage>[
        for (final message in conversation.messages)
          if (message.id == messageId)
            message.copyWith(delivery: delivery)
          else
            message,
      ];
      return conversation.copyWith(messages: messages);
    });
  }

  static void _toggle(Set<String> values, String value) {
    values.contains(value) ? values.remove(value) : values.add(value);
  }
}
