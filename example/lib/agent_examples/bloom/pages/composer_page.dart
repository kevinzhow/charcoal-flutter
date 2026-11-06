part of '../bloom.dart';

final class _BloomComposerPage extends StatefulWidget {
  const _BloomComposerPage({required this.viewModel, super.key});

  final BloomViewModel viewModel;

  @override
  State<_BloomComposerPage> createState() => _BloomComposerPageState();
}

final class _BloomComposerPageState extends State<_BloomComposerPage> {
  late final TextEditingController _altTextController;
  late final TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    final state = widget.viewModel.state;
    _altTextController = TextEditingController(text: state.composerAltText);
    _captionController = TextEditingController(text: state.composerCaption);
  }

  @override
  void dispose() {
    _altTextController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-composer-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _BloomAvatar(
                initials: 'MA',
                tone: state.data.profile.tone,
                size: CharcoalAvatarSize.regular,
              ),
              const CharcoalGap(CharcoalSpace.sm),
              Expanded(
                child: CharcoalText(
                  'Share one thing you noticed. A visual can speak on its own.',
                  role: CharcoalTextRole.captionMedium,
                  tone: CharcoalTextTone.secondary,
                ),
              ),
            ],
          ),
          if (state.hasSavedDraft) ...<Widget>[
            const CharcoalGap(CharcoalSpace.sm),
            CharcoalText(
              'Saved draft restored',
              bold: true,
              role: CharcoalTextRole.caption,
              tone: CharcoalTextTone.info,
            ),
          ],
          const CharcoalGap(CharcoalSpace.lg),
          const _BloomSectionTitle(title: 'Artwork'),
          const CharcoalGap(CharcoalSpace.sm),
          _BloomMediaPicker(
            onPressed: widget.viewModel.changeComposerArtwork,
            tone: state.composerTone,
          ),
          if (state.composerTone != null) ...<Widget>[
            const CharcoalGap(CharcoalSpace.md),
            CharcoalTextField(
              controller: _altTextController,
              label: 'Image description',
              maxLength: 100,
              onChanged: widget.viewModel.updateComposerAltText,
              placeholder: 'Describe the artwork for people who cannot see it',
              showCount: true,
              showLabel: true,
            ),
          ],
          const CharcoalGap(CharcoalSpace.lg),
          CharcoalTextArea(
            key: const ValueKey<String>('agent-social-post-field'),
            assistiveText: 'Optional when an artwork is selected.',
            controller: _captionController,
            label: 'Caption',
            maxLength: 140,
            onChanged: widget.viewModel.updateComposerCaption,
            placeholder: 'What caught your eye today?',
            rows: 4,
            showCount: true,
            showLabel: true,
          ),
          const CharcoalGap(CharcoalSpace.lg),
          const _BloomSectionTitle(title: 'Audience'),
          const CharcoalGap(CharcoalSpace.sm),
          CharcoalSegmentedControl<BloomAudience>(
            fullWidth: true,
            onChanged: widget.viewModel.changeAudience,
            segments: const <CharcoalSegment<BloomAudience>>[
              CharcoalSegment(
                value: BloomAudience.circle,
                child: Text('My circle'),
              ),
              CharcoalSegment(
                value: BloomAudience.everyone,
                child: Text('Everyone'),
              ),
            ],
            semanticLabel: 'Post audience',
            value: state.audience,
          ),
          const CharcoalGap(CharcoalSpace.md),
          _BloomSurface(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CharcoalIconView(
                  CharcoalIcons.infoCircle,
                  size: CharcoalIconSize.sm,
                  tone: CharcoalIconTone.secondary,
                ),
                const CharcoalGap(CharcoalSpace.sm),
                Expanded(
                  child: CharcoalText(
                    state.audience == BloomAudience.circle
                        ? 'Only people you follow can see and reply.'
                        : 'Anyone on Bloom can discover and reply.',
                    role: CharcoalTextRole.caption,
                    tone: CharcoalTextTone.secondary,
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

final class _BloomMediaPicker extends StatelessWidget {
  const _BloomMediaPicker({required this.onPressed, required this.tone});

  final VoidCallback onPressed;
  final int? tone;

  @override
  Widget build(BuildContext context) {
    if (tone == null) {
      return CharcoalClickable(
        key: const ValueKey<String>('agent-social-add-artwork'),
        onPressed: onPressed,
        semanticLabel: 'Choose sample artwork',
        builder: (context, states) => CharcoalCard(
          padding: const CharcoalInset.symmetric(vertical: CharcoalSpace.xxl),
          raised: true,
          states: states,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CharcoalIconView(
                  CharcoalIcons.imageAdd,
                  tone: CharcoalIconTone.secondary,
                ),
                CharcoalGap(CharcoalSpace.sm),
                CharcoalText(
                  'Choose sample artwork',
                  role: CharcoalTextRole.captionMediumBold,
                  tone: CharcoalTextTone.primary,
                ),
                CharcoalGap(CharcoalSpace.xs),
                CharcoalText(
                  'This simulation includes four visual studies.',
                  role: CharcoalTextRole.caption,
                  tone: CharcoalTextTone.secondary,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _BloomArtwork(
          altText: 'Selected sample artwork',
          rounded: true,
          tone: tone!,
        ),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalButton(
          fullWidth: true,
          leading: const CharcoalIcon(CharcoalIcons.imageReplace),
          onPressed: onPressed,
          child: const Text('Try another artwork'),
        ),
      ],
    );
  }
}
