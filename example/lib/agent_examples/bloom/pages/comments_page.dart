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
    final space = theme.dimensions.space;
    return Column(
      key: const ValueKey<String>('agent-social-comments-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              space.component30,
              space.component25,
              space.component30,
              space.component30,
            ),
            children: <Widget>[
              _BloomCommentPostContext(post: post, state: state),
              SizedBox(height: space.component30),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: _BloomSectionTitle(title: 'Recent comments'),
                  ),
                  Text(
                    '${post.comments} total',
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  ),
                ],
              ),
              SizedBox(height: space.component25),
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
                    SizedBox(height: space.component25),
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
        duration: CharcoalMotion.resolveDuration(
          context,
          const Duration(milliseconds: 220),
        ),
        curve: CharcoalMotion.standardCurve,
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
    final space = theme.dimensions.space;
    final author = _bloomAuthor(state.data, post.creatorId);
    return _BloomSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BloomAvatar(initials: author.initials, size: 36, tone: author.tone),
          SizedBox(width: space.component20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  author.name,
                  style: theme.textStyles.captionMediumBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                SizedBox(height: space.component10),
                Text(
                  post.copy,
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textDefault,
                  ),
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
    final space = theme.dimensions.space;
    final author = _bloomAuthor(state.data, comment.authorId);
    return Row(
      key: ValueKey<String>(comment.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BloomAvatar(initials: author.initials, size: 34, tone: author.tone),
        SizedBox(width: space.component20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      author.name,
                      style: theme.textStyles.captionMediumBold.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                  ),
                  SizedBox(width: space.component20),
                  Text(
                    comment.time,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textTertiaryDefault,
                    ),
                  ),
                ],
              ),
              SizedBox(height: space.component10),
              Text(
                comment.text,
                style: theme.textStyles.captionMedium.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
