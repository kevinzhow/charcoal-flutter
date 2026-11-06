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
    return Column(
      key: const ValueKey<String>('agent-social-story-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CharcoalPadding(
          padding: const CharcoalInset.symmetric(
            horizontal: CharcoalSpace.lg,
            vertical: CharcoalSpace.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const CharcoalProgressBar(
                value: 1,
                semanticLabel: 'Story 1 of 1',
              ),
              const CharcoalGap(CharcoalSpace.sm),
              CharcoalText(
                'One moment from ${creator.location} · 1 of 1',
                role: CharcoalTextRole.caption,
                tone: CharcoalTextTone.secondary,
              ),
            ],
          ),
        ),
        Expanded(
          child: CharcoalPadding(
            padding: const CharcoalInset.symmetric(
              horizontal: CharcoalSpace.lg,
            ),
            child: _BloomArtwork(
              altText: '${creator.name} shared an abstract color study.',
              rounded: true,
              tone: creator.tone,
            ),
          ),
        ),
        const CharcoalGap(CharcoalSpace.sm),
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
