import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A feature-flag detail page built from section cards: the kill switch with its consequence, the
/// settings as read-only rows with an Edit action, the members in a selectable table with a batch
/// action, and the danger zone last.
///
/// Every section owns its actions in its own header; the page stacks the cards with
/// `CharcoalGap(CharcoalSpace.lg)` and never sets a size or a colour. The table's checked ids live
/// in one set that the header box, the row boxes and the batch action read in the same frame.
final class AgentAdminSectionsExample extends StatefulWidget {
  const AgentAdminSectionsExample({super.key});

  @override
  State<AgentAdminSectionsExample> createState() =>
      _AgentAdminSectionsExampleState();
}

final class _AgentAdminSectionsExampleState
    extends State<AgentAdminSectionsExample> {
  bool _enabled = true;
  bool _deleted = false;
  final Map<String, (String, String)> _members = <String, (String, String)>{
    'u1': ('Lin Xiaoyu', 'xiaoyu.lin@example.com'),
    'u2': ('ren.qa@example.com', 'No nickname'),
    'u3': ('Aoi Tanaka', 'aoi@example.com'),
  };
  Set<String> _checked = <String>{};

  void _remove(Set<String> ids) => setState(() {
    _members.removeWhere((id, _) => ids.contains(id));
    _checked = _checked.difference(ids);
  });

  Future<void> _delete() async {
    final confirmed = await showCharcoalConfirm(
      context,
      title: 'Delete flag?',
      message: 'Its 2 rules are deleted too. This cannot be undone.',
      danger: true,
    );
    if (confirmed && mounted) setState(() => _deleted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CharcoalSectionCard(
          title: 'Kill switch',
          caption: _enabled
              ? 'On: rules below decide the value. Turning it off serves the default to everyone.'
              : 'Off: everyone gets the default value. Rules are paused, not deleted.',
          actions: <Widget>[
            CharcoalSwitch(
              value: _enabled,
              semanticLabel: 'Kill switch',
              onChanged: (value) => setState(() => _enabled = value),
            ),
          ],
          children: const <Widget>[],
        ),
        const CharcoalGap(CharcoalSpace.lg),
        CharcoalSectionCard(
          title: 'Settings',
          actions: <Widget>[
            CharcoalButton(
              size: CharcoalButtonSize.small,
              leading: const CharcoalIcon(CharcoalIcons.pen),
              semanticLabel: 'Edit settings',
              onPressed: () {},
              child: const Text('Edit'),
            ),
          ],
          children: const <Widget>[
            CharcoalInfoRows(<(String, String)>[
              ('Default value', 'Not set: keep the current endpoint'),
              ('Value type', 'String'),
              ('Visibility', 'Server only'),
            ]),
          ],
        ),
        const CharcoalGap(CharcoalSpace.lg),
        CharcoalSectionCard(
          title: 'Members',
          caption: _checked.isEmpty
              ? 'Added by hand; they match whatever the rules say.'
              : '${_checked.length} selected',
          actions: <Widget>[
            if (_checked.isNotEmpty)
              CharcoalButton(
                size: CharcoalButtonSize.small,
                labelTone: CharcoalTextTone.negative,
                leading: const CharcoalIcon(CharcoalIcons.delete),
                onPressed: () => _remove(_checked),
                child: const Text('Remove selected'),
              ),
          ],
          flush: true,
          children: <Widget>[
            CharcoalDataTable<String>(
              columns: const <CharcoalTableColumn>[
                CharcoalTableColumn(label: 'User', flex: 2),
                CharcoalTableColumn(label: 'User ID', hideWhenNarrow: true),
              ],
              selection: CharcoalTableSelection<String>(
                selected: _checked,
                onChanged: (next) => setState(() => _checked = next),
              ),
              rows: <CharcoalTableRow<String>>[
                for (final MapEntry(key: id, value: (name, detail))
                    in _members.entries)
                  CharcoalTableRow<String>(
                    id: id,
                    cells: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CharcoalText(name, bold: true),
                          CharcoalText(
                            detail,
                            role: CharcoalTextRole.caption,
                            tone: CharcoalTextTone.secondary,
                          ),
                        ],
                      ),
                      CharcoalText(id, role: CharcoalTextRole.captionMono),
                    ],
                    action: CharcoalIconButton(
                      icon: const CharcoalIcon(CharcoalIcons.x),
                      semanticLabel: 'Remove $name',
                      size: CharcoalIconButtonSize.small,
                      onPressed: () => _remove(<String>{id}),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const CharcoalGap(CharcoalSpace.lg),
        CharcoalDangerZone(
          title: 'Delete flag',
          description: _deleted ? 'Deleted.' : 'Its 2 rules are deleted too. To pause the flag, turn off the kill switch.',
          actionLabel: 'Delete',
          onPressed: _deleted ? null : _delete,
        ),
      ],
    );
  }
}
