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
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final colors = <Color>[
      theme.colors.surfaceSecondary,
      theme.colors.neutral,
      theme.colors.surfaceTertiary,
      theme.colors.fillSecondary,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Featured guides', style: theme.style(CharcoalTextRole.headingS)),
        SizedBox(height: space.sm),
        Semantics(
          liveRegion: true,
          child: Text(
            'Guide ${_currentPage + 1} of ${_guides.length}: '
            '${_guides[_currentPage].title}',
            style: theme
                .style(CharcoalTextRole.captionMedium)
                .copyWith(color: theme.colors.textSecondary),
          ),
        ),
        SizedBox(height: space.xl),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 480;
            return SizedBox(
              height: 200,
              child: CharcoalCarousel(
                gap: compact ? 0 : space.sm,
                onPageChanged: (page) => setState(() => _currentPage = page),
                semanticLabel: 'Featured guides',
                semanticLabelBuilder: (index, itemCount) =>
                    'Guide ${index + 1} of $itemCount: ${_guides[index].title}',
                showIndicators: true,
                size: compact
                    ? CharcoalCarouselSize.small
                    : CharcoalCarouselSize.medium,
                children: <Widget>[
                  for (var index = 0; index < _guides.length; index++)
                    _GuideSlide(
                      color: colors[index],
                      description: _guides[index].description,
                      title: _guides[index].title,
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

final class _GuideSlide extends StatelessWidget {
  const _GuideSlide({
    required this.color,
    required this.description,
    required this.title,
  });

  final Color color;
  final String description;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: theme.style(CharcoalTextRole.bodyLargeBold)),
            SizedBox(height: space.sm),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme
                  .style(CharcoalTextRole.captionMedium)
                  .copyWith(color: theme.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
