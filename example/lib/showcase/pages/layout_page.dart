import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/next.dart';
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
            description:
                'Filled and outlined cards, and the avatar in its three sizes.',
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
                Row(
                  children: <Widget>[
                    for (final size in CharcoalAvatarSize.values) ...<Widget>[
                      CharcoalAvatar('Name', size: size),
                      const CharcoalGap.horizontal(CharcoalSpace.md),
                    ],
                    const CharcoalAvatar('Round', circular: true),
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
        ],
      ),
    ],
  );
}
