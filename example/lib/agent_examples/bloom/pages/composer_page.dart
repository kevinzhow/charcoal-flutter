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
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
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
                size: 42,
              ),
              SizedBox(width: space.sm),
              Expanded(
                child: Text(
                  'Share one thing you noticed. A visual can speak on its own.',
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(color: theme.colors.textSecondary),
                ),
              ),
            ],
          ),
          if (state.hasSavedDraft) ...<Widget>[
            SizedBox(height: space.sm),
            Text(
              'Saved draft restored',
              style: theme
                  .style(CharcoalTextRole.caption)
                  .copyWith(
                    color: theme.colors.textInfo,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          SizedBox(height: space.lg),
          const _BloomSectionTitle(title: 'Artwork'),
          SizedBox(height: space.sm),
          _BloomMediaPicker(
            onPressed: widget.viewModel.changeComposerArtwork,
            tone: state.composerTone,
          ),
          if (state.composerTone != null) ...<Widget>[
            SizedBox(height: space.md),
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
          SizedBox(height: space.lg),
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
          SizedBox(height: space.lg),
          const _BloomSectionTitle(title: 'Audience'),
          SizedBox(height: space.sm),
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
          SizedBox(height: space.md),
          _BloomSurface(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalIcon(
                  CharcoalIcons.infoCircle,
                  color: theme.colors.iconSecondary,
                  size: 18,
                ),
                SizedBox(width: space.sm),
                Expanded(
                  child: Text(
                    state.audience == BloomAudience.circle
                        ? 'Only people you follow can see and reply.'
                        : 'Anyone on Bloom can discover and reply.',
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(color: theme.colors.textSecondary),
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
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    if (tone == null) {
      return CharcoalClickable(
        key: const ValueKey<String>('agent-social-add-artwork'),
        onPressed: onPressed,
        semanticLabel: 'Choose sample artwork',
        builder: (context, states) => AnimatedContainer(
          duration: CharcoalTheme.of(context)
              .duration(context, CharcoalTheme.of(context).motion.fast),
          height: 156,
          decoration: BoxDecoration(
            border: Border.all(
              color: states.contains(WidgetState.hovered)
                  ? theme.colors.border
                  : theme.colors.borderSubtle,
            ),
            borderRadius: BorderRadius.circular(theme.radius.md),
            color: states.contains(WidgetState.pressed)
                ? theme.colors.fillSecondaryPress
                : theme.colors.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CharcoalIcon(
                CharcoalIcons.imageAdd,
                color: theme.colors.iconSecondary,
              ),
              SizedBox(height: space.sm),
              Text(
                'Choose sample artwork',
                style: theme
                    .style(CharcoalTextRole.captionMediumBold)
                    .copyWith(color: theme.colors.text),
              ),
              SizedBox(height: space.xs),
              Text(
                'This simulation includes four visual studies.',
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(color: theme.colors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(theme.radius.md),
          child: _BloomArtwork(
            altText: 'Selected sample artwork',
            height: 200,
            tone: tone!,
          ),
        ),
        SizedBox(height: space.sm),
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
