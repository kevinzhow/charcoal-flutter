part of '../bloom.dart';

final class _BloomStoryPage extends StatelessWidget {
  const _BloomStoryPage({
    required this.creatorId,
    required this.viewModel,
    super.key,
  });

  final String creatorId;
  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final creator = viewModel.state.data.creator(creatorId);
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Column(
      key: const ValueKey<String>('agent-social-story-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(space.lg, space.sm, space.lg, space.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Semantics(
                label: 'Story 1 of 1',
                child: ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(theme.radius.pill),
                    child: SizedBox(
                      height: theme.borders.thick,
                      child: ColoredBox(color: theme.colors.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(height: space.sm),
              Text(
                'One moment from ${creator.location} · 1 of 1',
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(color: theme.colors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: space.lg),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(theme.radius.md),
              child: LayoutBuilder(
                builder: (context, constraints) => _BloomArtwork(
                  altText: '${creator.name} shared an abstract color study.',
                  height: constraints.maxHeight,
                  tone: creator.tone,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: space.sm),
        _BloomReplyBar(
          fieldKey: const ValueKey<String>('agent-social-story-reply-field'),
          fieldSemanticLabel: 'Reply to ${creator.name}',
          onSend: (reply) => viewModel.replyToStory(creatorId, reply),
          placeholder: 'Reply to ${creator.name.split(' ').first}',
          prefix: const CharcoalIcon(CharcoalIcons.message),
          sendKey: const ValueKey<String>('agent-social-send-story-reply'),
          sendSemanticLabel: 'Send story reply',
        ),
      ],
    );
  }
}
