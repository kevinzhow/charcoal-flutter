import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'Tag metadata and explicit text truncation across all public V2 sizes and states.',
          eyebrow: 'COMPONENTS · CONTENT',
          title: 'Content presentation',
        ),
        const SizedBox(height: 24),
        ShowcaseCatalogGrid(
          children: <Widget>[
            ShowcaseCard(
              description:
                  'Small and medium sizing with a custom semantic background.',
              eyebrow: 'TAG ITEM',
              title: 'Sizes',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  for (final size in CharcoalTagItemSize.values)
                    CharcoalTagItem(
                      label: '#${size.name}',
                      onPressed: showcaseNoop,
                      size: size,
                    ),
                  CharcoalTagItem(
                    backgroundColor: theme.colors.containerDiscoveryDefault,
                    label: '#discovery',
                    onPressed: showcaseNoop,
                  ),
                ],
              ),
            ),
            const ShowcaseCard(
              description:
                  'Normal, active, inactive, translated, and disabled states.',
              eyebrow: 'TAG ITEM',
              title: 'States',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  CharcoalTagItem(label: '#landscape', onPressed: showcaseNoop),
                  CharcoalTagItem(
                    label: '#original',
                    onPressed: showcaseNoop,
                    status: CharcoalTagItemStatus.active,
                  ),
                  CharcoalTagItem(
                    label: '#創作',
                    onPressed: showcaseNoop,
                    translatedLabel: 'original work',
                  ),
                  CharcoalTagItem(
                    label: '#inactive',
                    onPressed: showcaseNoop,
                    status: CharcoalTagItemStatus.inactive,
                  ),
                  CharcoalTagItem(label: '#disabled', onPressed: null),
                ],
              ),
            ),
            ShowcaseCard(
              description:
                  'Single-line truncation with a separate semantic label.',
              eyebrow: 'TEXT ELLIPSIS',
              title: 'One line',
              child: SizedBox(
                width: 280,
                child: CharcoalTextEllipsis(
                  'A deliberately long artwork title that cannot fit in one line',
                  semanticLabel: 'Full artwork title',
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
              ),
            ),
            ShowcaseCard(
              description:
                  'Two-line truncation for longer descriptions and metadata.',
              eyebrow: 'TEXT ELLIPSIS',
              title: 'Multiple lines',
              child: SizedBox(
                width: 280,
                child: CharcoalTextEllipsis(
                  'Charcoal keeps overflow behavior explicit so content layouts remain predictable across compact and wide surfaces.',
                  maxLines: 2,
                  style: theme.textStyles.paragraph.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class CarouselGallery extends StatelessWidget {
  const CarouselGallery({super.key});

  @override
  Widget build(BuildContext context) => ShowcaseCard(
    description: 'Small carousels use full-page slides and indicators; medium carousels preview the next slide and expose navigation actions.',
    eyebrow: 'CAROUSEL',
    title: 'Carousel sizes',
    child: ShowcaseCatalogGrid(
      children: const <Widget>[
        _CarouselExample(size: CharcoalCarouselSize.small),
        _CarouselExample(size: CharcoalCarouselSize.medium),
      ],
    ),
  );
}

final class _CarouselExample extends StatelessWidget {
  const _CarouselExample({required this.size});

  final CharcoalCarouselSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          displayTokenName(size.name),
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: CharcoalCarousel(
            semanticLabel: '${size.name} artwork carousel',
            size: size,
            children: const <Widget>[
              _CarouselSlide(index: 1),
              _CarouselSlide(index: 2),
              _CarouselSlide(index: 3),
            ],
          ),
        ),
      ],
    );
  }
}

final class _CarouselSlide extends StatelessWidget {
  const _CarouselSlide({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = <Color>[
      theme.colors.containerPrimaryDefault,
      theme.colors.containerDiscoveryDefault,
      theme.colors.containerPositiveDefault,
    ];
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: colors[index - 1],
        ),
        child: Center(
          child: Text(
            'Artwork $index',
            style: theme.textStyles.headingXs.copyWith(
              color: theme.colors.textOnPrimaryDefault,
            ),
          ),
        ),
      ),
    );
  }
}
