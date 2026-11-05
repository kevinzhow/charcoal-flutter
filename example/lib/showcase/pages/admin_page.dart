import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

final class _AdminPageState extends State<AdminPage> {
  String _section = 'home';
  bool _selecting = false;
  int _selectedCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    Widget item(
      String id,
      String label,
      CharcoalIconData icon, {
      bool locked = false,
    }) => CharcoalNavigationItem(
      key: ValueKey<String>('admin-nav-$id'),
      variant: CharcoalNavigationItemVariant.sidebar,
      leading: CharcoalIcon(icon),
      selected: _section == id,
      onPressed: () => setState(() => _section = id),
      trailing: locked
          ? CharcoalIcon(CharcoalIcons.lock, color: theme.colors.iconDisabled)
          : null,
      child: Text(label),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'Pieces for an admin console, from package:charcoal_ui/admin.dart: the sidebar shell, stat cards, meters, info tables and the batch bar.',
          eyebrow: 'COMPONENTS · ADMIN',
          title: 'Admin console pieces',
        ),
        const SizedBox(height: 24),
        ShowcaseCatalogGrid(
          children: <Widget>[
            ShowcaseCard(
              description: 'Brand header, grouped destinations and a pinned account tile. The shell switches to a bottom tab bar below the sidebar breakpoint.',
              eyebrow: 'SIDEBAR',
              title: 'Sidebar',
              child: SizedBox(
                height: 420,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.borderSubtle),
                    borderRadius: BorderRadius.circular(theme.radius.md),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(theme.radius.md),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: CharcoalSidebar(
                        brand: const CharcoalSidebarBrand(
                          mark: 'M',
                          title: 'Console',
                        ),
                        footer: CharcoalNavigationItem(
                          variant: CharcoalNavigationItemVariant.sidebar,
                          leading: const CharcoalAvatar(
                            'alice@example.com',
                            circular: true,
                            size: CharcoalAvatarSize.small,
                          ),
                          trailing: const CharcoalIcon(
                            CharcoalIcons.chevronRight,
                          ),
                          onPressed: showcaseNoop,
                          child: const Text('alice@example.com'),
                        ),
                        children: <Widget>[
                          CharcoalSidebarGroup(
                            children: <Widget>[
                              item('home', 'Dashboard', CharcoalIcons.home),
                              item(
                                'projects',
                                'Projects',
                                CharcoalIcons.projects,
                              ),
                            ],
                          ),
                          CharcoalSidebarGroup(
                            title: 'Operations',
                            children: <Widget>[
                              item(
                                'broadcast',
                                'Broadcast',
                                CharcoalIcons.announce,
                                locked: true,
                              ),
                              item(
                                'logs',
                                'Logs',
                                CharcoalIcons.file,
                                locked: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ShowcaseCard(
              description: 'Stat tiles with status and footnote, and a quota meter that clamps its fraction.',
              eyebrow: 'STAT CARD · METER',
              title: 'Stats',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalStatCard(
                    label: 'Revenue',
                    value: r'$1,200',
                    status: 'Up 12%',
                    statusTone: CharcoalTone.positive,
                    footnote: 'vs last month',
                    action: CharcoalLinkButton(
                      onPressed: showcaseNoop,
                      child: const Text('Details'),
                    ),
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  const CharcoalMeter(
                    label: 'Storage',
                    value: '12 / 20 GB',
                    fraction: 0.6,
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  const CharcoalMeter(
                    label: 'Requests',
                    value: '120% of quota',
                    fraction: 1.2,
                  ),
                ],
              ),
            ),
            ShowcaseCard(
              description: 'A ruled key / value table with selectable values.',
              eyebrow: 'INFO ROWS',
              title: 'InfoRows',
              child: const CharcoalInfoRows(<(String, String)>[
                ('Email', 'alice@example.com'),
                ('User ID', 'usr_01HZX3'),
                ('Plan', 'Pro'),
              ]),
            ),
            ShowcaseCard(
              description: 'Count at rest, selection count in selection mode, and delete disabled until a row is ticked.',
              eyebrow: 'BATCH BAR',
              title: 'BatchBar',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalBatchBar(
                    selectionMode: _selecting,
                    selectedCount: _selectedCount,
                    restLabel: '3 notices',
                    onToggleMode: () => setState(() {
                      _selecting = !_selecting;
                      _selectedCount = 0;
                    }),
                    onDelete: showcaseNoop,
                    restActions: <Widget>[
                      CharcoalButton(
                        size: CharcoalButtonSize.small,
                        variant: CharcoalButtonVariant.primary,
                        onPressed: showcaseNoop,
                        child: const Text('New'),
                      ),
                    ],
                  ),
                  if (_selecting) ...<Widget>[
                    const CharcoalGap(CharcoalSpace.md),
                    CharcoalButton(
                      size: CharcoalButtonSize.small,
                      onPressed: () => setState(
                        () => _selectedCount = (_selectedCount + 1) % 4,
                      ),
                      child: const Text('Tick another row'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
