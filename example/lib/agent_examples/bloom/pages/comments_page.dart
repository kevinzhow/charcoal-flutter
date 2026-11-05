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
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Column(
      key: const ValueKey<String>('agent-social-comments-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              space.lg,
              space.md,
              space.lg,
              space.lg,
            ),
            children: <Widget>[
              _BloomCommentPostContext(post: post, state: state),
              SizedBox(height: space.lg),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: _BloomSectionTitle(title: 'Recent comments'),
                  ),
                  Text(
                    '${post.comments} total',
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(color: theme.colors.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: space.md),
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
                  if (index + 1 < comments.length) SizedBox(height: space.md),
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
        duration: CharcoalTheme.of(context)
            .duration(context, const Duration(milliseconds: 220)),
        curve: CharcoalTheme.of(context).motion.curve,
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
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final author = _bloomAuthor(state.data, post.creatorId);
    return _BloomSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BloomAvatar(initials: author.initials, size: 36, tone: author.tone),
          SizedBox(width: space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  author.name,
                  style: theme
                      .style(CharcoalTextRole.captionMediumBold)
                      .copyWith(color: theme.colors.text),
                ),
                SizedBox(height: space.xs),
                Text(
                  post.copy,
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(color: theme.colors.text),
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
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final author = _bloomAuthor(state.data, comment.authorId);
    return Row(
      key: ValueKey<String>(comment.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BloomAvatar(initials: author.initials, size: 34, tone: author.tone),
        SizedBox(width: space.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      author.name,
                      style: theme
                          .style(CharcoalTextRole.captionMediumBold)
                          .copyWith(color: theme.colors.text),
                    ),
                  ),
                  SizedBox(width: space.sm),
                  Text(
                    comment.time,
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(color: theme.colors.textTertiary),
                  ),
                ],
              ),
              SizedBox(height: space.xs),
              Text(
                comment.text,
                style: theme
                    .style(CharcoalTextRole.captionMedium)
                    .copyWith(color: theme.colors.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
