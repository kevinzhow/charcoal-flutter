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
  String _destination = 'home';
  String _tab = 'home';

  static const _destinations = <(String, String, CharcoalIconData)>[
    ('home', 'Overview', CharcoalIcons.home),
    ('projects', 'Projects', CharcoalIcons.projects),
    ('people', 'People', CharcoalIcons.persons),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'Page-level navigation, destination items, the bottom tab bar, segmented selection, pagination and both carousel presentation modes.',
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
                  border: Border.all(color: theme.colors.borderSubtle),
                  borderRadius: BorderRadius.circular(theme.radius.md),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(theme.radius.md),
                  child: const CharcoalNavigationBar(
                    leading: CharcoalIconButton(
                      icon: CharcoalIcon(CharcoalIcons.chevronLeft),
                      onPressed: showcaseNoop,
                      semanticLabel: 'Back to messages',
                      size: CharcoalIconButtonSize.small,
                    ),
                    semanticLabel: 'Conversation navigation example',
                    title: Text('Aki Kondo'),
                    trailing: CharcoalIconButton(
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
              description: 'Controlled destinations in the standard and sidebar variants, with a disabled and a trailing example.',
              eyebrow: 'NAVIGATION ITEM',
              title: 'NavigationItem',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final variant
                      in CharcoalNavigationItemVariant.values) ...<Widget>[
                    for (final (id, label, icon) in _destinations)
                      CharcoalNavigationItem(
                        key: ValueKey<String>('nav-item-${variant.name}-$id'),
                        variant: variant,
                        leading: CharcoalIcon(icon),
                        selected: _destination == id,
                        onPressed: () => setState(() => _destination = id),
                        trailing: id == 'people'
                            ? const CharcoalIcon(CharcoalIcons.lock)
                            : null,
                        child: Text(label),
                      ),
                    const CharcoalNavigationItem(
                      onPressed: null,
                      leading: CharcoalIcon(CharcoalIcons.setting),
                      child: Text('Disabled'),
                    ),
                    const CharcoalGap(CharcoalSpace.xl),
                  ],
                ],
              ),
            ),
            ShowcaseCard(
              description: 'Two to five top-level destinations; the badge is part of the accessible label.',
              eyebrow: 'TAB BAR',
              title: 'TabBar',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.radius.md),
                child: CharcoalTabBar<String>(
                  value: _tab,
                  onChanged: (value) => setState(() => _tab = value),
                  semanticLabel: 'Primary destinations',
                  items: const <CharcoalTabItem<String>>[
                    CharcoalTabItem<String>(
                      icon: CharcoalIcon(CharcoalIcons.home),
                      label: 'Home',
                      value: 'home',
                    ),
                    CharcoalTabItem<String>(
                      icon: CharcoalIcon(CharcoalIcons.compass),
                      label: 'Discover',
                      value: 'discover',
                    ),
                    CharcoalTabItem<String>(
                      badge: '3',
                      icon: CharcoalIcon(CharcoalIcons.message),
                      label: 'Messages',
                      semanticLabel: 'Messages, 3 unread',
                      value: 'messages',
                    ),
                    CharcoalTabItem<String>(
                      enabled: false,
                      icon: CharcoalIcon(CharcoalIcons.personCircle),
                      label: 'Profile',
                      value: 'profile',
                    ),
                  ],
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
                      CharcoalSegment<String>(
                        child: Text('Grid'),
                        value: 'grid',
                      ),
                      CharcoalSegment<String>(
                        child: Text('List'),
                        value: 'list',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  CharcoalSegmentedControl<String>(
                    fullWidth: true,
                    value: _layout,
                    onChanged: (value) => setState(() => _layout = value),
                    segments: const <CharcoalSegment<String>>[
                      CharcoalSegment<String>(
                        child: Text('Grid'),
                        value: 'grid',
                      ),
                      CharcoalSegment<String>(
                        child: Text('List'),
                        value: 'list',
                      ),
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
              description: 'Page windows, ellipsis behavior, disabled edge actions and the compact previous / next form.',
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
                      const SizedBox(height: 20),
                      CharcoalPagination.compact(
                        currentPage: _currentPage,
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
}
