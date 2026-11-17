import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

// Previews for the page-section parts of the admin redesign.

@CharcoalComponentPreview(name: 'Section card · Danger zone', size: Size(640, 620))
Widget charcoalSectionCardPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalSectionCard(
      title: 'Rules',
      caption: 'Checked from top to bottom; the first match wins',
      actions: <Widget>[
        CharcoalButton(
          size: CharcoalButtonSize.small,
          variant: CharcoalButtonVariant.primary,
          leading: const CharcoalIcon(CharcoalIcons.add),
          onPressed: () {},
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
    const CharcoalSectionCard(
      children: <Widget>[CharcoalText('Without a title the card starts with its body.')],
    ),
    const CharcoalGap(CharcoalSpace.lg),
    CharcoalDangerZone(
      title: 'Delete flag',
      description: 'Its 2 rules are deleted too and cannot be restored.',
      actionLabel: 'Delete',
      onPressed: () {},
    ),
  ],
);

const _previewMembers = <String, String>{'lin': 'Lin Xiaoyu', 'aoi': 'Aoi Tanaka'};

@CharcoalComponentPreview(name: 'Data table · Selection', size: Size(720, 360))
Widget charcoalDataTablePreview() => CharcoalSectionCard(
  title: 'Members',
  flush: true,
  children: <Widget>[
    CharcoalDataTable<String>(
      columns: const <CharcoalTableColumn>[
        CharcoalTableColumn(label: 'User', flex: 2),
        CharcoalTableColumn(label: 'Note', hideWhenNarrow: true),
        CharcoalTableColumn.fit(label: 'Joined', align: CharcoalColumnAlign.end),
      ],
      selection: CharcoalTableSelection<String>(
        selected: const <String>{'lin'},
        onChanged: (_) {},
        selectRowLabel: (id) => 'Select ${_previewMembers[id]}',
      ),
      rows: <CharcoalTableRow<String>>[
        for (final MapEntry(key: id, value: name) in _previewMembers.entries)
          CharcoalTableRow<String>(
            id: id,
            onPressed: () {},
            cells: <Widget>[
              CharcoalText(name, bold: true),
              const CharcoalText('Beta feedback'),
              const CharcoalText('2026-11-12', role: CharcoalTextRole.caption),
            ],
            action: CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.x),
              semanticLabel: 'Remove',
              size: CharcoalIconButtonSize.small,
              onPressed: () {},
            ),
          ),
      ],
    ),
  ],
);

@CharcoalComponentPreview(name: 'Radio cards', size: Size(480, 320))
Widget charcoalRadioCardsPreview() => CharcoalFormField(
  label: 'Default value',
  required: true,
  child: CharcoalRadioCards<String>(
    value: 'none',
    onChanged: (_) {},
    options: const <CharcoalRadioCardOption<String>>[
      CharcoalRadioCardOption(
        value: 'none',
        title: 'Not set (recommended)',
        description: 'Keep the current routing',
      ),
      CharcoalRadioCardOption(
        value: 'large',
        title: 'Whisper large-v3',
        description: 'x3k9wq1v7plm2a',
        trailing: CharcoalChip('Live', tone: CharcoalTone.positive),
      ),
      CharcoalRadioCardOption(
        value: 'old',
        title: 'Old cluster',
        description: 'Stopped',
        enabled: false,
      ),
    ],
  ),
);

@CharcoalComponentPreview(name: 'Disclosure · More options', size: Size(480, 240))
Widget charcoalDisclosurePreview() => const CharcoalDisclosure(
  title: 'More options',
  summary: 'Visibility: server only · Enabled after creation · No description',
  child: CharcoalTextField(label: 'Description', showLabel: true, optionalText: '(optional)'),
);

@CharcoalComponentPreview(name: 'Copyable text', size: Size(480, 120))
Widget charcoalCopyableTextPreview() => const CharcoalCopyableText(
  text: 'FC055F80-20D8-4DAB-90ED-E62C534D433D',
  copyLabel: 'Copy ID',
  copiedMessage: 'ID copied',
);

@CharcoalComponentPreview(name: 'Empty state · Steps', size: Size(760, 420))
Widget charcoalEmptyStateStepsPreview() => CharcoalSectionCard(
  title: 'Segments',
  children: <Widget>[
    CharcoalEmptyState(
      icon: CharcoalIcons.persons,
      title: 'No segments yet',
      message: 'Flag rules target a segment, such as "Beta testers".',
      actions: <Widget>[
        CharcoalButton(
          variant: CharcoalButtonVariant.primary,
          onPressed: () {},
          child: const Text('New segment'),
        ),
      ],
      steps: const <CharcoalEmptyStateStep>[
        CharcoalEmptyStateStep(title: 'Create and name it', description: 'Only a name is needed'),
        CharcoalEmptyStateStep(title: 'Choose who matches', description: 'Members or conditions'),
        CharcoalEmptyStateStep(title: 'Use it in a flag', description: 'Pick it in a new rule'),
      ],
    ),
  ],
);
