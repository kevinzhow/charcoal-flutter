import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';
import 'next_island.dart';

export 'carousel_gallery.dart' show CarouselGallery;

final class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
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
            child: NextThemeIsland(
              child: Builder(
                builder: (context) => Wrap(
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
                      backgroundColor: CharcoalTheme.of(context)
                          .colors
                          .negative,
                      label: '#discovery',
                      onPressed: showcaseNoop,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const ShowcaseCard(
            description:
                'Normal, active, inactive, translated, and disabled states.',
            eyebrow: 'TAG ITEM',
            title: 'States',
            child: NextThemeIsland(
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
          ),
          ShowcaseCard(
            description:
                'Single-line truncation with a separate semantic label.',
            eyebrow: 'TEXT ELLIPSIS',
            title: 'One line',
            child: NextThemeIsland(
              child: Builder(
                builder: (context) => SizedBox(
                  width: 280,
                  child: CharcoalTextEllipsis(
                    'A deliberately long artwork title that cannot fit in one line',
                    semanticLabel: 'Full artwork title',
                    style: CharcoalTheme.of(context)
                        .style(CharcoalTextRole.body),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseCard(
            description:
                'Two-line truncation for longer descriptions and metadata.',
            eyebrow: 'TEXT ELLIPSIS',
            title: 'Multiple lines',
            child: NextThemeIsland(
              child: Builder(
                builder: (context) => SizedBox(
                  width: 280,
                  child: CharcoalTextEllipsis(
                    'Charcoal keeps overflow behavior explicit so content layouts remain predictable across compact and wide surfaces.',
                    maxLines: 2,
                    style: CharcoalTheme.of(context).style(
                      CharcoalTextRole.paragraph,
                      color: CharcoalTheme.of(context).colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
