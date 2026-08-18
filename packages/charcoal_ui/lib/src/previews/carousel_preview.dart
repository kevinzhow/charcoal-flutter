import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Carousel · Medium', size: Size(620, 320))
Widget charcoalMediumCarouselPreview() => const _CarouselPreview(
  itemCount: 4,
  size: CharcoalCarouselSize.medium,
);

@CharcoalComponentPreview(name: 'Carousel · Small', size: Size(320, 300))
Widget charcoalSmallCarouselPreview() => const _CarouselPreview(
  itemCount: 4,
  size: CharcoalCarouselSize.small,
);

@CharcoalComponentPreview(
  name: 'Carousel · Compact indicators',
  size: Size(240, 280),
)
Widget charcoalScrollableCarouselIndicatorsPreview() =>
    const _CarouselPreview(itemCount: 16, size: CharcoalCarouselSize.small);

final class _CarouselPreview extends StatefulWidget {
  const _CarouselPreview({required this.itemCount, required this.size});

  final int itemCount;
  final CharcoalCarouselSize size;

  @override
  State<_CarouselPreview> createState() => _CarouselPreviewState();
}

final class _CarouselPreviewState extends State<_CarouselPreview> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = <Color>[
      theme.colors.containerSecondaryDefault,
      theme.colors.containerNeutralDefault,
      theme.colors.containerTertiaryDefault,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Slide ${page + 1} of ${widget.itemCount}',
          style: theme.textStyles.captionMedium,
        ),
        SizedBox(height: theme.dimensions.space.component20),
        SizedBox(
          height: 200,
          child: CharcoalCarousel(
            gap: widget.size == CharcoalCarouselSize.small ? 0 : theme.dimensions.space.component20,
            onPageChanged: (value) => setState(() => page = value),
            semanticLabel: 'Preview slides',
            semanticLabelBuilder: (index, itemCount) => 'Preview slide ${index + 1} of $itemCount',
            showIndicators: true,
            size: widget.size,
            children: <Widget>[
              for (var index = 0; index < widget.itemCount; index++)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                    color: colors[index % colors.length],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textStyles.headingS,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
