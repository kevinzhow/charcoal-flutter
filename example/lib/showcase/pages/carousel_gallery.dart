import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

/// The carousel specimens, shared by the Content page and the Navigation page.
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
          style: theme.style(CharcoalTextRole.captionMediumBold),
        ),
        const CharcoalGap(CharcoalSpace.sm),
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
      theme.colors.primary,
      theme.colors.negative,
      theme.colors.positive,
    ];
    return Padding(
      padding: EdgeInsetsDirectional.only(end: theme.space.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radius.xl),
          color: colors[index - 1],
        ),
        child: Center(
          child: Text(
            'Artwork $index',
            style: theme.style(
              CharcoalTextRole.headingXs,
              color: theme.colors.textOnPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
