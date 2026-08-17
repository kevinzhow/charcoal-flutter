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
    final space = theme.dimensions.space;
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
              SizedBox(width: space.component20),
              Expanded(
                child: Text(
                  'Share one thing you noticed. A visual can speak on its own.',
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ),
            ],
          ),
          if (state.hasSavedDraft) ...<Widget>[
            SizedBox(height: space.component20),
            Text(
              'Saved draft restored',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textInfoDefault,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          SizedBox(height: space.component30),
          const _BloomSectionTitle(title: 'Artwork'),
          SizedBox(height: space.component20),
          _BloomMediaPicker(
            onPressed: widget.viewModel.changeComposerArtwork,
            tone: state.composerTone,
          ),
          if (state.composerTone != null) ...<Widget>[
            SizedBox(height: space.component25),
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
          SizedBox(height: space.component30),
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
          SizedBox(height: space.component30),
          const _BloomSectionTitle(title: 'Audience'),
          SizedBox(height: space.component20),
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
          SizedBox(height: space.component25),
          _BloomSurface(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalIcon(
                  CharcoalIcons.infoCircle,
                  color: theme.colors.iconSecondaryDefault,
                  size: 18,
                ),
                SizedBox(width: space.component20),
                Expanded(
                  child: Text(
                    state.audience == BloomAudience.circle
                        ? 'Only people you follow can see and reply.'
                        : 'Anyone on Bloom can discover and reply.',
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
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
    final space = theme.dimensions.space;
    if (tone == null) {
      return CharcoalClickable(
        key: const ValueKey<String>('agent-social-add-artwork'),
        onPressed: onPressed,
        semanticLabel: 'Choose sample artwork',
        builder: (context, states) => AnimatedContainer(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.fast,
          ),
          height: 156,
          decoration: BoxDecoration(
            border: Border.all(
              color: states.contains(WidgetState.hovered)
                  ? theme.colors.borderDefault
                  : theme.colors.borderSecondary,
            ),
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            color: states.contains(WidgetState.pressed)
                ? theme.colors.containerSecondaryPressA
                : theme.colors.backgroundDefault,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CharcoalIcon(
                CharcoalIcons.imageAdd,
                color: theme.colors.iconSecondaryDefault,
              ),
              SizedBox(height: space.component20),
              Text(
                'Choose sample artwork',
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              SizedBox(height: space.component10),
              Text(
                'This simulation includes four visual studies.',
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
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
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          child: _BloomArtwork(
            altText: 'Selected sample artwork',
            height: 200,
            tone: tone!,
          ),
        ),
        SizedBox(height: space.component20),
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
