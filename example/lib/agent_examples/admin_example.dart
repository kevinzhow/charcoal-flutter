import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// An admin console frame: sidebar shell, a page with stat cards, a quota meter, an info table
/// and a batch bar.
///
/// The shell chooses sidebar or bottom bar from the width it is given; one state owner (`_section`)
/// updates both navigations in the same frame.
final class AgentAdminExample extends StatefulWidget {
  const AgentAdminExample({super.key});

  @override
  State<AgentAdminExample> createState() => _AgentAdminExampleState();
}

final class _AgentAdminExampleState extends State<AgentAdminExample> {
  String _section = 'overview';
  bool _selecting = false;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return CharcoalAdminShell(
      sidebar: CharcoalSidebar(
        brand: const CharcoalSidebarBrand(mark: 'M', title: 'Console'),
        children: <Widget>[
          CharcoalSidebarGroup(
            children: <Widget>[
              for (final entry in const <(String, String)>[
                ('overview', 'Overview'),
                ('keys', 'Keys'),
              ])
                CharcoalNavigationItem(
                  variant: CharcoalNavigationItemVariant.sidebar,
                  selected: _section == entry.$1,
                  onPressed: () => setState(() => _section = entry.$1),
                  child: Text(entry.$2),
                ),
            ],
          ),
        ],
      ),
      bottomBar: CharcoalTabBar<String>(
        value: _section,
        onChanged: (value) => setState(() => _section = value),
        items: const <CharcoalTabItem<String>>[
          CharcoalTabItem<String>(
            icon: CharcoalIcon(CharcoalIcons.home),
            label: 'Overview',
            value: 'overview',
          ),
          CharcoalTabItem<String>(
            icon: CharcoalIcon(CharcoalIcons.lock),
            label: 'Keys',
            value: 'keys',
          ),
        ],
      ),
      body: CharcoalPage(
        title: _section == 'overview' ? 'Overview' : 'Keys',
        subtitle: 'Last 30 days',
        header: const Row(
          children: <Widget>[
            CharcoalBrandMark('M'),
            CharcoalGap(CharcoalSpace.sm),
            CharcoalText('Acme Console', role: CharcoalTextRole.sectionTitle),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const CharcoalStatCard(
              label: 'Requests',
              value: '1.2M',
              status: 'Up 12%',
              statusTone: CharcoalTone.positive,
              footnote: 'Compared with the previous period',
            ),
            const CharcoalGap(CharcoalSpace.lg),
            const CharcoalMeter(
              label: 'Monthly quota',
              value: '72 of 100 GB',
              fraction: 0.72,
            ),
            const CharcoalGap(CharcoalSpace.lg),
            const CharcoalInfoRows(<(String, String)>[
              ('Plan', 'Team'),
              ('Region', 'ap-northeast-1'),
            ]),
            const CharcoalGap(CharcoalSpace.lg),
            CharcoalBatchBar(
              selectionMode: _selecting,
              selectedCount: _selected,
              restLabel: 'Keys',
              onToggleMode: () => setState(() {
                _selecting = !_selecting;
                _selected = 0;
              }),
              onDelete: () => setState(() {
                _selecting = false;
                _selected = 0;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
