import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for the page-section parts of the admin redesign (section card, danger zone, data
/// table), at a regular and a compact width.
final sectionsScenes = <CharcoalScene>[
  for (final (name, size) in const <(String, Size)>[
    ('sections-regular', Size(1100, 900)),
    ('sections-compact', Size(420, 1100)),
  ])
    CharcoalScene(
      name: name,
      size: size,
      build: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: const _Sections(),
      ),
    ),
];

class _Sections extends StatelessWidget {
  const _Sections();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CharcoalSectionCard(
                title: 'Rules',
                caption: 'Checked from top to bottom; the first match wins',
                actions: <Widget>[
                  CharcoalButton(
                    size: CharcoalButtonSize.small,
                    variant: CharcoalButtonVariant.primary,
                    leading: const CharcoalIcon(CharcoalIcons.add),
                    onPressed: noop,
                    child: const Text('Add rule'),
                  ),
                ],
                dividers: true,
                children: const <Widget>[
                  CharcoalText('Staff → Whisper large-v3'),
                  CharcoalText('Beta testers, 30% → Turbo'),
                ],
              ),
              const CharcoalGap(CharcoalSpace.lg),
              CharcoalSectionCard(
                title: 'Members',
                flush: true,
                children: <Widget>[
                  CharcoalList(
                    topBorder: false,
                    children: <Widget>[
                      CharcoalListRow(
                        title: 'Alice',
                        subtitle: 'alice@example.com',
                        onPressed: noop,
                      ),
                      const CharcoalListRow(title: 'Bob', selected: true),
                    ],
                  ),
                ],
              ),
              const CharcoalGap(CharcoalSpace.lg),
              CharcoalSectionCard(
                title: 'Users',
                flush: true,
                children: <Widget>[
                  CharcoalDataTable<String>(
                    columns: const <CharcoalTableColumn>[
                      CharcoalTableColumn(label: 'User', flex: 2),
                      CharcoalTableColumn(label: 'Note', hideWhenNarrow: true),
                      CharcoalTableColumn.fit(label: 'Joined', align: CharcoalColumnAlign.end),
                    ],
                    selection: CharcoalTableSelection<String>(
                      selected: const <String>{'alice'},
                      onChanged: (_) {},
                    ),
                    rows: <CharcoalTableRow<String>>[
                      CharcoalTableRow<String>(
                        id: 'alice',
                        cells: const <Widget>[
                          CharcoalText('Alice', bold: true),
                          CharcoalText('Beta feedback'),
                          CharcoalText('2026-11-12', role: CharcoalTextRole.caption),
                        ],
                        onPressed: noop,
                      ),
                      CharcoalTableRow<String>(
                        id: 'bob',
                        selected: true,
                        cells: const <Widget>[
                          CharcoalText('Bob', bold: true),
                          CharcoalText('QA'),
                          CharcoalText('2026-11-12', role: CharcoalTextRole.caption),
                        ],
                        action: CharcoalIconButton(
                          icon: const CharcoalIcon(CharcoalIcons.x),
                          semanticLabel: 'Remove',
                          size: CharcoalIconButtonSize.small,
                          onPressed: noop,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const CharcoalGap(CharcoalSpace.lg),
              CharcoalDangerZone(
                title: 'Delete flag',
                description: 'Its 2 rules are deleted too and cannot be restored.',
                actionLabel: 'Delete',
                onPressed: noop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
