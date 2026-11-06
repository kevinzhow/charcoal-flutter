import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A responsive featured-content carousel with caller-owned page context.
final class AgentCarouselExample extends StatefulWidget {
  const AgentCarouselExample({super.key});

  @override
  State<AgentCarouselExample> createState() => _AgentCarouselExampleState();
}

final class _AgentCarouselExampleState extends State<AgentCarouselExample> {
  static const _guides = <({String title, String description})>[
    (
      title: 'Build a calm first run',
      description: 'Introduce one decision before revealing advanced tools.',
    ),
    (
      title: 'Keep navigation truthful',
      description: 'Stable destinations switch state; detail work uses routes.',
    ),
    (
      title: 'Make recovery explicit',
      description:
          'Errors explain what remains safe and the next useful action.',
    ),
    (
      title: 'Verify every input path',
      description:
          'Touch, pointer, keyboard, and assistive actions share outcomes.',
    ),
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalText('Featured guides', role: CharcoalTextRole.headingS),
        const CharcoalGap(CharcoalSpace.sm),
        Semantics(
          liveRegion: true,
          child: CharcoalText(
            'Guide ${_currentPage + 1} of ${_guides.length}: '
            '${_guides[_currentPage].title}',
            role: CharcoalTextRole.captionMedium,
            tone: CharcoalTextTone.secondary,
          ),
        ),
        const CharcoalGap(CharcoalSpace.xl),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 480;
            // In a scrolling column the carousel takes its default height from the theme.
            return CharcoalCarousel(
              onPageChanged: (page) => setState(() => _currentPage = page),
              semanticLabel: 'Featured guides',
              semanticLabelBuilder: (index, itemCount) =>
                  'Guide ${index + 1} of $itemCount: ${_guides[index].title}',
              showIndicators: true,
              size: compact
                  ? CharcoalCarouselSize.small
                  : CharcoalCarouselSize.medium,
              spacing: compact ? null : CharcoalSpace.sm,
              children: <Widget>[
                for (final guide in _guides)
                  _GuideSlide(
                    description: guide.description,
                    title: guide.title,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

final class _GuideSlide extends StatelessWidget {
  const _GuideSlide({required this.description, required this.title});

  final String description;
  final String title;

  @override
  Widget build(BuildContext context) => CharcoalCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CharcoalText(title, role: CharcoalTextRole.bodyLargeBold),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalText(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          role: CharcoalTextRole.captionMedium,
          tone: CharcoalTextTone.secondary,
        ),
      ],
    ),
  );
}
