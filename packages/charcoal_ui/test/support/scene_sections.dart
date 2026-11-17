import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for the parts of the admin redesign (page header meta, section card, danger zone, data
/// table, radio cards, disclosure, copyable text, empty state with steps, mode bar), at a regular
/// and a compact width.
final sectionsScenes = <CharcoalScene>[
  for (final (name, size) in const <(String, Size)>[
    ('sections-page', Size(1100, 500)),
    ('sections-page-compact', Size(420, 600)),
  ])
    CharcoalScene(
      name: name,
      size: size,
      build: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: CharcoalPage(
          title: 'transcribe.runpod_endpoint',
          subtitle: 'Which RunPod endpoint new transcriptions use',
          showBack: true,
          meta: const <Widget>[
            CharcoalChip('String'),
            CharcoalChip('Server only', tone: CharcoalTone.info),
            CharcoalCopyableText(
              text: 'FC055F80-20D8-4DAB-90ED-E62C534D433D',
              copyLabel: 'Copy ID',
              copiedMessage: 'ID copied',
            ),
          ],
          actions: <Widget>[
            CharcoalButton(
              size: CharcoalButtonSize.small,
              onPressed: () {},
              child: const Text('Audit log'),
            ),
          ],
          child: const CharcoalText('Body'),
        ),
      ),
    ),
  for (final (name, size) in const <(String, Size)>[
    ('sections-mode-bar', Size(1100, 300)),
    ('sections-mode-bar-compact', Size(420, 400)),
  ])
    CharcoalScene(
      name: name,
      size: size,
      build: (context) => CharcoalScaffold(
        background: CharcoalPageBackground.notice,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CharcoalModeBar(
                title: 'Super-user mode',
                message: 'Every action here is recorded as the super user in the audit log.',
                actions: <Widget>[
                  CharcoalButton(
                    size: CharcoalButtonSize.small,
                    onPressed: () {},
                    child: const Text('Exit super user'),
                  ),
                ],
              ),
              const CharcoalPadding(
                padding: CharcoalInset.all(CharcoalSpace.lg),
                child: CharcoalSectionCard(
                  flush: true,
                  children: <Widget>[
                    CharcoalModeBar(title: 'Super user (break-glass)'),
                    CharcoalPadding(
                      padding: CharcoalInset.all(CharcoalSpace.lg),
                      child: CharcoalText('Sign in with the shared credentials.'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
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
              CharcoalFormField(
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
                      description: 'Stopped: choosing it means not set',
                      enabled: false,
                      trailing: CharcoalChip('Stopped', tone: CharcoalTone.notice),
                    ),
                  ],
                ),
              ),
              const CharcoalGap(CharcoalSpace.lg),
              const CharcoalDisclosure(
                title: 'More options',
                summary: 'Visibility: server only · Enabled after creation · No description',
                child: CharcoalText('Hidden fields'),
              ),
              const CharcoalGap(CharcoalSpace.lg),
              const CharcoalDisclosure(
                title: 'Advanced',
                initiallyExpanded: true,
                child: CharcoalTextField(
                  label: 'Description',
                  showLabel: true,
                  optionalText: '(optional)',
                ),
              ),
              const CharcoalGap(CharcoalSpace.lg),
              const CharcoalCopyableText(
                text: 'FC055F80-20D8-4DAB-90ED-E62C534D433D',
                copyLabel: 'Copy ID',
                copiedMessage: 'ID copied',
              ),
              const CharcoalGap(CharcoalSpace.lg),
              CharcoalSectionCard(
                title: 'Segments',
                children: <Widget>[
                  CharcoalEmptyState(
                    icon: CharcoalIcons.persons,
                    title: 'No segments yet',
                    message: 'Flag rules target a segment.',
                    actions: <Widget>[
                      CharcoalButton(onPressed: noop, child: const Text('New segment')),
                    ],
                    steps: const <CharcoalEmptyStateStep>[
                      CharcoalEmptyStateStep(title: 'Create', description: 'A name is enough'),
                      CharcoalEmptyStateStep(title: 'Match', description: 'Members or conditions'),
                      CharcoalEmptyStateStep(title: 'Use'),
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
