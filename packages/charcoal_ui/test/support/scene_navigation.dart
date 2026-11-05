import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/next.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for batch 2D: navigation items (both variants, every state), the navigation bar, tab
/// bar and pagination, then the layout kit and the admin pieces.
final navigationScenes = <CharcoalScene>[
  CharcoalScene(
    name: 'navigation',
    size: const Size(600, 1000),
    build: (_) => const _NavigationScene(),
  ),
  CharcoalScene(name: 'layout', size: const Size(700, 1100), build: (_) => const _LayoutScene()),
  CharcoalScene(
    name: 'admin shell',
    size: const Size(1280, 800),
    build: (_) => const _AdminScene(),
  ),
];

class _NavigationScene extends StatelessWidget {
  const _NavigationScene();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      navigationBar: CharcoalNavigationBar(
        title: const Text('Settings'),
        leading: CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
          onPressed: noop,
          semanticLabel: 'Back',
        ),
        trailing: CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.add),
          onPressed: noop,
          semanticLabel: 'Add',
        ),
      ),
      bottomBar: CharcoalTabBar<int>(
        value: 1,
        onChanged: (_) {},
        items: const [
          CharcoalTabItem(icon: CharcoalIcon(CharcoalIcons.home), label: 'Home', value: 0),
          CharcoalTabItem(
            icon: CharcoalIcon(CharcoalIcons.message),
            label: 'Messages',
            value: 1,
            badge: '3',
            semanticLabel: 'Messages, 3 unread',
          ),
          CharcoalTabItem(
            icon: CharcoalIcon(CharcoalIcons.setting),
            label: 'Disabled',
            value: 2,
            enabled: false,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final variant in CharcoalNavigationItemVariant.values) ...[
                CharcoalNavigationItem(
                  variant: variant,
                  selected: true,
                  leading: const CharcoalIcon(CharcoalIcons.home),
                  trailing: const CharcoalIcon(CharcoalIcons.chevronRight),
                  onPressed: noop,
                  child: const Text('Selected'),
                ),
                CharcoalNavigationItem(
                  variant: variant,
                  leading: const CharcoalIcon(CharcoalIcons.projects),
                  onPressed: noop,
                  child: const Text('Normal'),
                ),
                CharcoalNavigationItem(
                  variant: variant,
                  leading: const CharcoalIcon(CharcoalIcons.lock),
                  onPressed: null,
                  child: const Text('Disabled'),
                ),
                const CharcoalGap(CharcoalSpace.md),
              ],
              CharcoalPagination(currentPage: 5, pageCount: 20, onPageChanged: (_) {}),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalPagination(
                currentPage: 1,
                pageCount: 3,
                size: CharcoalPaginationSize.small,
                onPageChanged: (_) {},
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalPagination.compact(currentPage: 2, pageCount: 9, onPageChanged: (_) {}),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalPagination(currentPage: 2, pageCount: 9, onPageChanged: null),
            ],
          ),
        ),
      ),
    );
  }
}

class _LayoutScene extends StatelessWidget {
  const _LayoutScene();

  @override
  Widget build(BuildContext context) {
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CharcoalSectionHeader(
                'Users',
                caption: '3 total',
                action: CharcoalButton(
                  size: CharcoalButtonSize.small,
                  onPressed: () {},
                  child: const Text('Add'),
                ),
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalList(
                children: [
                  CharcoalListRow(
                    title: 'Alice',
                    subtitle: 'alice@example.com',
                    leading: const CharcoalAvatar('Alice', circular: true),
                    trailing: const [CharcoalChip('admin', tone: CharcoalTone.info)],
                    onPressed: () {},
                  ),
                  CharcoalListRow(
                    title: 'Selected row',
                    selected: true,
                    height: CharcoalListRowHeight.tall,
                    leading: const CharcoalAvatar('Selected'),
                    onPressed: () {},
                  ),
                  const CharcoalListRow(
                    title: 'Static row',
                    height: CharcoalListRowHeight.compact,
                    titleMonospace: true,
                    titleTrailing: [CharcoalChip('v2')],
                    details: '{"key": "value"}',
                  ),
                ],
              ),
              const CharcoalGap(CharcoalSpace.lg),
              const CharcoalCard(child: Text('Filled card')),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalCard(outlined: true, child: Text('Outlined card')),
              const CharcoalGap(CharcoalSpace.lg),
              Row(
                children: [
                  for (final size in CharcoalAvatarSize.values) ...[
                    CharcoalAvatar('Name', size: size),
                    const CharcoalGap.horizontal(CharcoalSpace.sm),
                  ],
                  const CharcoalAvatar('', circular: true),
                ],
              ),
              const CharcoalGap(CharcoalSpace.lg),
              const CharcoalInfoRows([('Email', 'alice@example.com'), ('Plan', 'Pro')]),
              const CharcoalGap(CharcoalSpace.lg),
              CharcoalStatCard(
                label: 'Revenue',
                value: r'$1,200',
                status: 'Up',
                statusTone: CharcoalTone.positive,
                footnote: 'vs last month',
                action: CharcoalLinkButton(onPressed: () {}, child: const Text('Details')),
              ),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalMeter(label: 'Storage', value: '12 / 20 GB', fraction: 0.6),
              const CharcoalGap(CharcoalSpace.lg),
              CharcoalBatchBar(
                selectionMode: false,
                selectedCount: 0,
                restLabel: '3 notices',
                onToggleMode: () {},
                onDelete: () {},
                restActions: [
                  CharcoalButton(
                    size: CharcoalButtonSize.small,
                    onPressed: () {},
                    child: const Text('New'),
                  ),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalBatchBar(
                selectionMode: true,
                selectedCount: 2,
                restLabel: '',
                onToggleMode: () {},
                onDelete: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminScene extends StatelessWidget {
  const _AdminScene();

  @override
  Widget build(BuildContext context) {
    return CharcoalAdminShell(
      sidebar: CharcoalSidebar(
        brand: const CharcoalSidebarBrand(mark: 'M', title: 'Console'),
        footer: CharcoalNavigationItem(
          variant: CharcoalNavigationItemVariant.sidebar,
          leading: const CharcoalAvatar(
            'alice@example.com',
            circular: true,
            size: CharcoalAvatarSize.small,
          ),
          trailing: const CharcoalIcon(CharcoalIcons.chevronRight),
          onPressed: () {},
          child: const Text('alice@example.com'),
        ),
        children: [
          CharcoalSidebarGroup(
            children: [
              CharcoalNavigationItem(
                variant: CharcoalNavigationItemVariant.sidebar,
                selected: true,
                leading: const CharcoalIcon(CharcoalIcons.home),
                onPressed: () {},
                child: const Text('Home'),
              ),
              CharcoalNavigationItem(
                variant: CharcoalNavigationItemVariant.sidebar,
                leading: const CharcoalIcon(CharcoalIcons.projects),
                onPressed: () {},
                child: const Text('Projects'),
              ),
            ],
          ),
          CharcoalSidebarGroup(
            title: 'Operations',
            children: [
              CharcoalNavigationItem(
                variant: CharcoalNavigationItemVariant.sidebar,
                leading: const CharcoalIcon(CharcoalIcons.announce),
                trailing: const CharcoalIcon(CharcoalIcons.lock),
                onPressed: () {},
                child: const Text('Broadcast'),
              ),
            ],
          ),
        ],
      ),
      body: const Center(child: Text('Page')),
    );
  }
}
