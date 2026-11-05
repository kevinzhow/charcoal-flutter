import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';
import 'content_page.dart';

final class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

final class _NavigationPageState extends State<NavigationPage> {
  int _currentPage = 3;
  String _layout = 'grid';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'Page-level navigation, segmented selection, pagination, and both carousel presentation modes.',
        eyebrow: 'COMPONENTS · NAVIGATION',
        title: 'Navigation and paging',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description: 'A centered page title with balanced back and contextual action slots.',
            eyebrow: 'NAVIGATION BAR',
            title: 'NavigationBar',
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: CharcoalTheme.of(context).colors.borderSecondary,
                ),
                borderRadius: BorderRadius.circular(
                  CharcoalTheme.of(context).dimensions.radius.m,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  CharcoalTheme.of(context).dimensions.radius.m,
                ),
                child: CharcoalNavigationBar(
                  leading: const CharcoalIconButton(
                    icon: CharcoalIcon(CharcoalIcons.chevronLeft),
                    onPressed: showcaseNoop,
                    semanticLabel: 'Back to messages',
                    size: CharcoalIconButtonSize.small,
                  ),
                  semanticLabel: 'Conversation navigation example',
                  title: const Text('Aki Kondo'),
                  trailing: const CharcoalIconButton(
                    icon: CharcoalIcon(CharcoalIcons.dotsHorizontal),
                    onPressed: showcaseNoop,
                    semanticLabel: 'Conversation actions',
                    size: CharcoalIconButtonSize.small,
                  ),
                ),
              ),
            ),
          ),
          ShowcaseCard(
            description: 'Intrinsic and full-width arrangements with a disabled segment.',
            eyebrow: 'SEGMENTED CONTROL',
            title: 'SegmentedControl',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalSegmentedControl<String>(
                  value: _layout,
                  onChanged: (value) => setState(() => _layout = value),
                  segments: const <CharcoalSegment<String>>[
                    CharcoalSegment<String>(child: Text('Grid'), value: 'grid'),
                    CharcoalSegment<String>(child: Text('List'), value: 'list'),
                  ],
                ),
                const SizedBox(height: 18),
                CharcoalSegmentedControl<String>(
                  fullWidth: true,
                  value: _layout,
                  onChanged: (value) => setState(() => _layout = value),
                  segments: const <CharcoalSegment<String>>[
                    CharcoalSegment<String>(child: Text('Grid'), value: 'grid'),
                    CharcoalSegment<String>(child: Text('List'), value: 'list'),
                    CharcoalSegment<String>(
                      child: Text('Compact'),
                      enabled: false,
                      value: 'compact',
                    ),
                  ],
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description:
                'Page windows, ellipsis behavior, and disabled edge actions.',
            eyebrow: 'PAGINATION',
            title: 'Pagination',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxVisiblePages = constraints.maxWidth < 300 ? 3 : 5;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CharcoalPagination(
                      currentPage: _currentPage,
                      maxVisiblePages: maxVisiblePages,
                      onPageChanged: (value) =>
                          setState(() => _currentPage = value),
                      pageCount: 12,
                      size: CharcoalPaginationSize.small,
                    ),
                    const SizedBox(height: 20),
                    CharcoalPagination(
                      currentPage: _currentPage,
                      maxVisiblePages: maxVisiblePages,
                      onPageChanged: (value) =>
                          setState(() => _currentPage = value),
                      pageCount: 12,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      const CarouselGallery(),
    ],
  );
}
