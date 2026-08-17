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
    final space = theme.dimensions.space;
    return Column(
      key: const ValueKey<String>('agent-social-story-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            space.component30,
            space.component20,
            space.component30,
            space.component20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Semantics(
                label: 'Story 1 of 1',
                child: ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.oval,
                    ),
                    child: SizedBox(
                      height: theme.dimensions.borderWidth.l,
                      child: ColoredBox(
                        color: theme.colors.containerPrimaryDefault,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: space.component20),
              Text(
                'One moment from ${creator.location} · 1 of 1',
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: space.component30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
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
        SizedBox(height: space.component20),
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
