import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

final class _LayoutPageState extends State<LayoutPage> {
  String _selected = 'alice';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'The list, row, section header, card and avatar the console screens are built from. Hover, focus and selection never move a row.',
        eyebrow: 'COMPONENTS · LAYOUT',
        title: 'Lists and cards',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description: 'A divided list of rows: interactive, selected, static, with inline chips and details.',
            eyebrow: 'LIST · LIST ROW',
            title: 'List',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CharcoalSectionHeader(
                  'Users',
                  caption: '3 total',
                  action: CharcoalButton(
                    size: CharcoalButtonSize.small,
                    onPressed: showcaseNoop,
                    child: const Text('Add'),
                  ),
                ),
                const CharcoalGap(CharcoalSpace.md),
                CharcoalList(
                  children: <Widget>[
                    for (final (id, name, mail)
                        in const <(String, String, String)>[
                          ('alice', 'Alice', 'alice@example.com'),
                          ('bob', 'Bob', 'bob@example.com'),
                        ])
                      CharcoalListRow(
                        key: ValueKey<String>('layout-row-$id'),
                        title: name,
                        subtitle: mail,
                        leading: CharcoalAvatar(name, circular: true),
                        trailing: <Widget>[
                          if (id == 'alice')
                            const CharcoalChip(
                              'admin',
                              tone: CharcoalTone.info,
                            ),
                        ],
                        selected: _selected == id,
                        onPressed: () => setState(() => _selected = id),
                      ),
                    const CharcoalListRow(
                      title: 'config.remote.v2',
                      titleMonospace: true,
                      titleTrailing: <Widget>[
                        CharcoalChip('draft', tone: CharcoalTone.notice),
                      ],
                      details: '{"flag": true}',
                      height: CharcoalListRowHeight.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'Filled and outlined cards, and the avatar in its four sizes and with a tone.',
            eyebrow: 'CARD · AVATAR',
            title: 'Card and avatar',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const CharcoalCard(child: Text('Filled card')),
                const CharcoalGap(CharcoalSpace.md),
                const CharcoalCard(
                  outlined: true,
                  child: Text('Outlined card'),
                ),
                const CharcoalGap(CharcoalSpace.lg),
                CharcoalWrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: CharcoalSpace.md,
                  runSpacing: CharcoalSpace.md,
                  children: <Widget>[
                    for (final size in CharcoalAvatarSize.values)
                      CharcoalAvatar('Name', size: size),
                    const CharcoalAvatar('Round', circular: true),
                    const CharcoalAvatar(
                      'Aki Kondo',
                      circular: true,
                      initials: 'AK',
                      tone: CharcoalTone.info,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'A section heading with an optional caption beside it and an action at the end.',
            eyebrow: 'SECTION HEADER',
            title: 'SectionHeader',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CharcoalSectionHeader('Projects'),
                CharcoalGap(CharcoalSpace.md),
                CharcoalSectionHeader(
                  'Providers',
                  caption: 'Third-party',
                  action: CharcoalIcon(CharcoalIcons.add),
                ),
              ],
            ),
          ),
          const ShowcaseCard(
            description: 'An identifier the reader needs elsewhere: selectable monospace text and a copy button that confirms with a toast. In a narrow cell the text shortens; the button still copies all of it.',
            eyebrow: 'COPYABLE TEXT',
            title: 'CopyableText',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalCopyableText(
                  text: 'FC055F80-20D8-4DAB-90ED-E62C534D433D',
                  copyLabel: 'Copy ID',
                  copiedMessage: 'ID copied',
                ),
                CharcoalGap(CharcoalSpace.md),
                SizedBox(
                  width: 180,
                  child: CharcoalCopyableText(
                    text: 'b1f6c2d4-7a3e-4c1b-9e2f-1a2b3c4d5e6f',
                    copyLabel: 'Copy user ID',
                    copiedMessage: 'User ID copied',
                  ),
                ),
              ],
            ),
          ),
          const ShowcaseCard(
            description: 'Columns that line up across rows under a header, row heights from the list row heights, a selection column with a mixed "select all" box, and a trailing action per row. Narrow tables drop their optional columns.',
            eyebrow: 'DATA TABLE',
            title: 'DataTable',
            child: _TableDemo(),
          ),
          ShowcaseCard(
            description: 'One titled section of a page: caption under the title, the section\'s own actions at the end, a body with optional dividers. A flush body lets a list or table reach the card edges. The danger zone closes a detail page.',
            eyebrow: 'SECTION CARD · DANGER ZONE',
            title: 'SectionCard',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CharcoalSectionCard(
                  title: 'Settings',
                  caption: 'Read-only until you edit them',
                  actions: <Widget>[
                    CharcoalButton(
                      size: CharcoalButtonSize.small,
                      leading: const CharcoalIcon(CharcoalIcons.pen),
                      onPressed: showcaseNoop,
                      child: const Text('Edit'),
                    ),
                  ],
                  dividers: true,
                  children: const <Widget>[
                    CharcoalText('Default value: not set'),
                    CharcoalText('Visibility: server only'),
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
                          onPressed: showcaseNoop,
                        ),
                        CharcoalListRow(
                          title: 'Bob',
                          subtitle: 'bob@example.com',
                          onPressed: showcaseNoop,
                        ),
                      ],
                    ),
                  ],
                ),
                const CharcoalGap(CharcoalSpace.lg),
                CharcoalDangerZone(
                  title: 'Delete flag',
                  description:
                      'Its 2 rules are deleted too and cannot be restored.',
                  actionLabel: 'Delete',
                  onPressed: showcaseNoop,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

final class _TableDemo extends StatefulWidget {
  const _TableDemo();

  @override
  State<_TableDemo> createState() => _TableDemoState();
}

final class _TableDemoState extends State<_TableDemo> {
  static const _users = <(String, String, String)>[
    ('lin', 'Lin Xiaoyu', 'Beta feedback'),
    ('ren', 'ren.qa@example.com', 'QA'),
    ('aoi', 'Aoi Tanaka', '—'),
  ];
  Set<String> _selected = <String>{'lin'};
  String? _open;

  @override
  Widget build(BuildContext context) => CharcoalSectionCard(
    title: 'Members',
    caption: '${_selected.length} selected',
    flush: true,
    children: <Widget>[
      CharcoalDataTable<String>(
        columns: const <CharcoalTableColumn>[
          CharcoalTableColumn(label: 'User', flex: 2),
          CharcoalTableColumn(label: 'Note', hideWhenNarrow: true),
          CharcoalTableColumn.fit(
            label: 'Joined',
            align: CharcoalColumnAlign.end,
          ),
        ],
        selection: CharcoalTableSelection<String>(
          selected: _selected,
          onChanged: (next) => setState(() => _selected = next),
          selectRowLabel: (id) =>
              'Select ${_users.firstWhere((user) => user.$1 == id).$2}',
        ),
        rows: <CharcoalTableRow<String>>[
          for (final (id, name, note) in _users)
            CharcoalTableRow<String>(
              id: id,
              selected: _open == id,
              onPressed: () => setState(() => _open = id),
              cells: <Widget>[
                CharcoalText(name, bold: true),
                CharcoalText(note),
                const CharcoalText(
                  '2026-11-12',
                  role: CharcoalTextRole.caption,
                ),
              ],
              action: CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.x),
                semanticLabel: 'Remove $name',
                size: CharcoalIconButtonSize.small,
                onPressed: showcaseNoop,
              ),
            ),
        ],
      ),
    ],
  );
}
