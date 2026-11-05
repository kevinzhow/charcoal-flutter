import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../admin.dart';
import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Navigation', size: Size(420, 360))
Widget charcoalNavigationPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalNavigationBar(
      leading: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
        onPressed: () {},
        semanticLabel: 'Back',
        size: CharcoalIconButtonSize.small,
      ),
      title: const Text('Page title'),
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),
        onPressed: () {},
        semanticLabel: 'More actions',
        size: CharcoalIconButtonSize.small,
      ),
    ),
    const CharcoalGap(CharcoalSpace.xl),
    CharcoalNavigationItem(
      leading: const CharcoalIcon(CharcoalIcons.home),
      onPressed: () {},
      selected: true,
      child: const Text('Overview'),
    ),
    const CharcoalGap(CharcoalSpace.md),
    CharcoalNavigationItem(
      leading: const CharcoalIcon(CharcoalIcons.calendar),
      onPressed: () {},
      child: const Text('Journey'),
    ),
    const CharcoalGap(CharcoalSpace.md),
    CharcoalNavigationItem(
      variant: CharcoalNavigationItemVariant.sidebar,
      leading: const CharcoalIcon(CharcoalIcons.projects),
      selected: true,
      onPressed: () {},
      child: const Text('Sidebar destination'),
    ),
  ],
);

@CharcoalComponentPreview(name: 'Tab bar', size: Size(420, 180))
Widget charcoalTabBarPreview() => const _TabBarPreview();

final class _TabBarPreview extends StatefulWidget {
  const _TabBarPreview();

  @override
  State<_TabBarPreview> createState() => _TabBarPreviewState();
}

final class _TabBarPreviewState extends State<_TabBarPreview> {
  String destination = 'home';

  @override
  Widget build(BuildContext context) => CharcoalTabBar<String>(
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
        icon: CharcoalIcon(CharcoalIcons.personCircle),
        label: 'Profile',
        value: 'profile',
      ),
    ],
    onChanged: (value) => setState(() => destination = value),
    semanticLabel: 'Primary destinations',
    value: destination,
  );
}

@CharcoalComponentPreview(name: 'Pagination', size: Size(420, 220))
Widget charcoalPaginationPreview() => const _PaginationPreview();

final class _PaginationPreview extends StatefulWidget {
  const _PaginationPreview();

  @override
  State<_PaginationPreview> createState() => _PaginationPreviewState();
}

final class _PaginationPreviewState extends State<_PaginationPreview> {
  int page = 8;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      CharcoalPagination(
        currentPage: page,
        pageCount: 20,
        onPageChanged: (value) => setState(() => page = value),
        semanticLabel: 'Preview pages',
      ),
      const CharcoalGap(CharcoalSpace.lg),
      CharcoalPagination.compact(
        currentPage: page,
        pageCount: 20,
        onPageChanged: (value) => setState(() => page = value),
      ),
    ],
  );
}

@CharcoalComponentPreview(name: 'List and cards', size: Size(480, 560))
Widget charcoalLayoutPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const CharcoalSectionHeader('Users', caption: '2 total'),
    const CharcoalGap(CharcoalSpace.md),
    CharcoalList(
      children: <Widget>[
        CharcoalListRow(
          title: 'Alice',
          subtitle: 'alice@example.com',
          leading: const CharcoalAvatar('Alice', circular: true),
          trailing: const <Widget>[CharcoalChip('admin', tone: CharcoalTone.info)],
          onPressed: () {},
        ),
        CharcoalListRow(
          title: 'Bob',
          subtitle: 'bob@example.com',
          leading: const CharcoalAvatar('Bob', circular: true),
          selected: true,
          onPressed: () {},
        ),
      ],
    ),
    const CharcoalGap(CharcoalSpace.xl),
    const CharcoalStatCard(
      label: 'Revenue',
      value: r'$1,200',
      status: 'Up',
      statusTone: CharcoalTone.positive,
    ),
    const CharcoalGap(CharcoalSpace.md),
    const CharcoalMeter(label: 'Storage', value: '12 / 20 GB', fraction: 0.6),
    const CharcoalGap(CharcoalSpace.md),
    const CharcoalInfoRows(<(String, String)>[('Email', 'alice@example.com'), ('Plan', 'Pro')]),
  ],
);

@CharcoalComponentPreview(name: 'Interaction primitive', size: Size(420, 220))
Widget charcoalClickablePreview() => Builder(
  builder: (context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: () {},
      semanticLabel: 'Open preview project',
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final hovered = states.contains(WidgetState.hovered);
        final pressed = states.contains(WidgetState.pressed);
        return AnimatedContainer(
          duration: theme.duration(context, theme.motion.fast),
          constraints: BoxConstraints(minHeight: theme.sizes.controlLg),
          padding: EdgeInsets.all(theme.space.lg),
          decoration: BoxDecoration(
            border: Border.all(
              color: focused ? theme.colors.borderFocus : theme.colors.borderSubtle,
              width: theme.borders.hairline,
            ),
            borderRadius: BorderRadius.circular(theme.radius.md),
            color: pressed
                ? theme.colors.fillSecondaryPress
                : hovered || focused
                ? theme.colors.fillSecondaryHover
                : theme.colors.background,
          ),
          child: Row(
            children: <Widget>[
              CharcoalIcon(CharcoalIcons.image, color: theme.colors.icon),
              SizedBox(width: theme.space.lg),
              Expanded(
                child: Text(
                  'Preview project',
                  style: theme.style(CharcoalTextRole.bodyBold),
                ),
              ),
              CharcoalIcon(
                CharcoalIcons.chevronRight,
                color: theme.colors.iconTertiary,
                size: theme.sizes.iconSm,
              ),
            ],
          ),
        );
      },
    );
  },
);
