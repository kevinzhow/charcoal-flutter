part of '../bloom.dart';

final class _BloomCommentsPage extends StatefulWidget {
  const _BloomCommentsPage({
    required this.postId,
    required this.viewModel,
    super.key,
  });

  final String postId;
  final BloomViewModel viewModel;

  @override
  State<_BloomCommentsPage> createState() => _BloomCommentsPageState();
}

final class _BloomCommentsPageState extends State<_BloomCommentsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final post = state.data.post(widget.postId);
    final comments = state.data.commentsFor(widget.postId);
    return Column(
      key: const ValueKey<String>('agent-social-comments-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: _bloomPageInset.resolve(context),
            children: <Widget>[
              _BloomCommentPostContext(post: post, state: state),
              const CharcoalGap(CharcoalSpace.lg),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: _BloomSectionTitle(title: 'Recent comments'),
                  ),
                  CharcoalText(
                    '${post.comments} total',
                    role: CharcoalTextRole.caption,
                    tone: CharcoalTextTone.secondary,
                  ),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              if (comments.isEmpty)
                const _BloomEmptyState(
                  description: 'Share the first thoughtful response.',
                  icon: CharcoalIcons.message,
                  title: 'No comments yet',
                )
              else
                for (
                  var index = 0;
                  index < comments.length;
                  index++
                ) ...<Widget>[
                  _BloomCommentRow(comment: comments[index], state: state),
                  if (index + 1 < comments.length)
                    const CharcoalGap(CharcoalSpace.md),
                ],
            ],
          ),
        ),
        _BloomReplyBar(
          fieldKey: const ValueKey<String>('agent-social-comment-field'),
          fieldSemanticLabel: 'Comment',
          onSend: _send,
          placeholder: 'Add a thoughtful comment',
          sendKey: const ValueKey<String>('agent-social-send-comment'),
          sendSemanticLabel: 'Post comment',
        ),
      ],
    );
  }

  void _send(String text) {
    widget.viewModel.addComment(widget.postId, text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: CharcoalMotion.standard.resolve(context),
        curve: CharcoalMotion.curveOf(context),
      );
    });
  }
}

final class _BloomCommentPostContext extends StatelessWidget {
  const _BloomCommentPostContext({required this.post, required this.state});

  final BloomPost post;
  final BloomViewState state;

  @override
  Widget build(BuildContext context) {
    final author = _bloomAuthor(state.data, post.creatorId);
    return _BloomSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BloomAvatar(
            initials: author.initials,
            size: CharcoalAvatarSize.small,
            tone: author.tone,
          ),
          const CharcoalGap(CharcoalSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalText(
                  author.name,
                  role: CharcoalTextRole.captionMediumBold,
                  tone: CharcoalTextTone.primary,
                ),
                const CharcoalGap(CharcoalSpace.xs),
                CharcoalText(
                  post.copy,
                  role: CharcoalTextRole.captionMedium,
                  tone: CharcoalTextTone.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _BloomCommentRow extends StatelessWidget {
  const _BloomCommentRow({required this.comment, required this.state});

  final BloomComment comment;
  final BloomViewState state;

  @override
  Widget build(BuildContext context) {
    final author = _bloomAuthor(state.data, comment.authorId);
    return Row(
      key: ValueKey<String>(comment.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BloomAvatar(
          initials: author.initials,
          size: CharcoalAvatarSize.small,
          tone: author.tone,
        ),
        const CharcoalGap(CharcoalSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: CharcoalText(
                      author.name,
                      role: CharcoalTextRole.captionMediumBold,
                      tone: CharcoalTextTone.primary,
                    ),
                  ),
                  const CharcoalGap(CharcoalSpace.sm),
                  CharcoalText(
                    comment.time,
                    role: CharcoalTextRole.caption,
                    tone: CharcoalTextTone.tertiary,
                  ),
                ],
              ),
              const CharcoalGap(CharcoalSpace.xs),
              CharcoalText(
                comment.text,
                role: CharcoalTextRole.captionMedium,
                tone: CharcoalTextTone.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
