import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for the fields and text family: every field in rest, focused (autofocus), invalid,
/// disabled and read-only states, label metadata, counters, dropdown, hint, form shells and the
/// type roles.
final fieldsScenes = <CharcoalScene>[
  CharcoalScene(name: 'fields', build: (context) => const _FieldsScene()),
  CharcoalScene(name: 'fields-text', build: (context) => const _TextScene()),
];

class _FieldsScene extends StatefulWidget {
  const _FieldsScene();

  @override
  State<_FieldsScene> createState() => _FieldsSceneState();
}

class _FieldsSceneState extends State<_FieldsScene> {
  final search = TextEditingController(text: 'query');
  final filled = TextEditingController(text: 'Filled value');
  bool switchOn = true;
  String? kind = 'manga';
  DateTime? moment = DateTime(2026, 9, 13, 14, 20);

  @override
  void dispose() {
    search.dispose();
    filled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CharcoalHintText(
                action: Text('Review'),
                subtitle: Text('Editable later.'),
                child: Text('Changes saved.'),
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalFormSection(
                title: 'Text fields',
                caption: 'Rest, filled, invalid, disabled, read-only',
                children: [
                  const CharcoalTextField(
                    label: 'Name',
                    placeholder: 'Display name',
                    showLabel: true,
                    required: true,
                    requiredText: 'Required',
                    showCount: true,
                    maxLength: 20,
                    subLabel: Text('Public'),
                    assistiveText: 'Shown on your profile',
                  ),
                  CharcoalTextField(label: 'Filled', controller: filled, showLabel: true),
                  const CharcoalTextField(
                    label: 'Invalid',
                    invalid: true,
                    showLabel: true,
                    assistiveText: 'Must not be empty',
                    prefix: CharcoalIcon(CharcoalIcons.search),
                  ),
                  const CharcoalTextField(label: 'Disabled', disabled: true, placeholder: 'Off'),
                  const CharcoalTextField(label: 'Read only', readOnly: true, placeholder: 'Fixed'),
                  CharcoalSearchField(
                    controller: search,
                    placeholder: 'Search',
                    onClear: search.clear,
                  ),
                ],
              ),
              const CharcoalTextArea(
                label: 'Notes',
                placeholder: 'Write something',
                rows: 3,
                showCount: true,
                maxLength: 200,
                showLabel: true,
                assistiveText: 'Markdown is not supported',
              ),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalTextArea(label: 'Invalid area', invalid: true, rows: 2),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalTextArea(label: 'Disabled area', disabled: true, rows: 2),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalDropdown<String>(
                label: 'Kind',
                showLabel: true,
                placeholder: 'Choose',
                value: kind,
                options: const [
                  CharcoalDropdownOption(value: 'manga', label: 'Manga', secondary: 'Pages'),
                  CharcoalDropdownOption(value: 'novel', label: 'Novel'),
                ],
                onChanged: (value) => setState(() => kind = value),
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalDropdown<String>(
                label: 'Invalid kind',
                invalid: true,
                assistiveText: 'Pick one',
                placeholder: 'Choose',
                value: null,
                options: const [CharcoalDropdownOption(value: 'a', label: 'A')],
                onChanged: (_) {},
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalDateTimeField(
                label: 'Publish at',
                value: moment,
                hint: 'Shown to everyone',
                onChanged: (value) => setState(() => moment = value),
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalSwitchField(
                label: 'Notify me',
                value: switchOn,
                hint: 'Once a day',
                onChanged: (value) => setState(() => switchOn = value),
              ),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalFormField(
                label: 'Private key',
                required: true,
                requiredText: 'Required',
                assistiveText: 'PEM only',
                action: Text('Choose file'),
                child: CharcoalTextArea(rows: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextScene extends StatelessWidget {
  const _TextScene();

  @override
  Widget build(BuildContext context) {
    final colors = CharcoalTheme.of(context).colors;
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final role in CharcoalTextRole.values)
                CharcoalText(role.name, role: role, maxLines: 1, overflow: TextOverflow.ellipsis),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalText('secondary', color: colors.textSecondary),
              CharcoalText('tertiary', color: colors.textTertiary),
              CharcoalText('placeholder', color: colors.textPlaceholder),
              CharcoalText('negative', color: colors.textNegative),
              CharcoalText('positive', color: colors.textPositive),
              CharcoalText('notice', color: colors.textNotice),
              CharcoalText('info', color: colors.textInfo),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalTypography(
                role: CharcoalTextRole.size12,
                bold: true,
                child: Text('Typography widget'),
              ),
              const CharcoalTextEllipsis(
                'A long run of text that is truncated when it is too wide',
              ),
              const CharcoalTypography(monospace: true, child: Text('id_0123456789')),
            ],
          ),
        ),
      ),
    );
  }
}
