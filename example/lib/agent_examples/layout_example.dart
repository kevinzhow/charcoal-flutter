import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A settings overview composed only from Charcoal layout components.
///
/// Spacing is named with `CharcoalSpace` steps, text with `CharcoalText` roles and tones, and the
/// surfaces come from `CharcoalCard` and `CharcoalList`; the example contains no colour, size or
/// text-style value.
final class AgentLayoutExample extends StatelessWidget {
  const AgentLayoutExample({super.key});

  static const _members = <({String name, String role})>[
    (name: 'Alice Chen', role: 'Owner'),
    (name: 'Bao Lin', role: 'Editor'),
    (name: 'Chika Mori', role: 'Viewer'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalSectionHeader(
          'Workspace',
          caption: 'People who can open this project',
        ),
        const CharcoalGap(CharcoalSpace.md),
        CharcoalCard(
          padding: const CharcoalInset.all(CharcoalSpace.lg),
          child: CharcoalWrap(
            spacing: CharcoalSpace.md,
            runSpacing: CharcoalSpace.md,
            children: <Widget>[
              CharcoalActionTile(
                icon: CharcoalIcons.add,
                label: 'Invite',
                onPressed: () {},
              ),
              CharcoalActionTile(
                icon: CharcoalIcons.setting,
                label: 'Settings',
                onPressed: () {},
              ),
            ],
          ),
        ),
        const CharcoalGap(CharcoalSpace.xl),
        CharcoalList(
          children: <Widget>[
            for (final member in _members)
              CharcoalListRow(
                title: member.name,
                leading: CharcoalAvatar(member.name, circular: true),
                trailing: <Widget>[CharcoalBadge(member.role)],
                onPressed: () {},
              ),
          ],
        ),
        const CharcoalDivider(),
        const CharcoalPadding(
          padding: CharcoalInset.symmetric(vertical: CharcoalSpace.md),
          child: Row(
            children: <Widget>[
              CharcoalIconView(
                CharcoalIcons.infoCircle,
                tone: CharcoalIconTone.secondary,
              ),
              CharcoalGap(CharcoalSpace.xs),
              CharcoalText(
                '3 members',
                role: CharcoalTextRole.caption,
                tone: CharcoalTextTone.secondary,
              ),
            ],
          ),
        ),
        CharcoalGrid(
          columns: const CharcoalGridColumns(wide: 2, compact: 1),
          children: <Widget>[
            for (final member in _members.take(2))
              CharcoalCard(
                outlined: true,
                child: CharcoalText(
                  member.role,
                  role: CharcoalTextRole.sectionTitle,
                ),
              ),
          ],
        ),
        const CharcoalGap(CharcoalSpace.md),
        const CharcoalSelectable(
          child: CharcoalText('member-4821', mono: true),
        ),
        const CharcoalGap(CharcoalSpace.md),
        const CharcoalFieldBox(
          width: CharcoalFieldWidth.compact,
          child: CharcoalText('Aligned to a field width class'),
        ),
      ],
    );
  }
}
