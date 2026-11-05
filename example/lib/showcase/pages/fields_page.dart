import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';
import 'next_island.dart';

final class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

final class _FieldsPageState extends State<FieldsPage> {
  final _search = TextEditingController();
  String? _workType = 'illustration';
  bool _notify = true;
  DateTime? _publishAt = DateTime(2026, 9, 13, 14, 20);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description:
            'Labels, single-line and multiline inputs, validation, counters, disabled states, '
            'dropdown menus and form shells.',
        eyebrow: 'COMPONENTS · FIELDS',
        title: 'Fields and menus',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          const ShowcaseCard(
            description: 'Label, required marker, and trailing sub-label composition.',
            eyebrow: 'FIELD LABEL',
            title: 'FieldLabel',
            child: NextThemeIsland(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalFieldLabel(label: 'Display name'),
                  SizedBox(height: 18),
                  CharcoalFieldLabel(label: 'Description', required: true, subLabel: Text('0/500')),
                ],
              ),
            ),
          ),
          const ShowcaseCard(
            description: 'Default, invalid, disabled and read-only single-line states.',
            eyebrow: 'TEXT FIELD',
            title: 'TextField',
            child: NextThemeIsland(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalTextField(
                    key: ValueKey<String>('display-name-field'),
                    assistiveText: 'Use 3–20 characters',
                    label: 'Display name',
                    maxLength: 20,
                    placeholder: 'pixiv user',
                    required: true,
                    showCount: true,
                    showLabel: true,
                  ),
                  CharcoalGap(CharcoalSpace.md),
                  CharcoalTextField(
                    assistiveText: 'This name is already taken',
                    invalid: true,
                    label: 'Invalid name',
                    placeholder: 'pixiv user',
                    showLabel: true,
                  ),
                  CharcoalGap(CharcoalSpace.md),
                  CharcoalTextField(disabled: true, label: 'Disabled', placeholder: 'Unavailable'),
                  CharcoalGap(CharcoalSpace.md),
                  CharcoalTextField(label: 'Read only', placeholder: 'Fixed', readOnly: true),
                ],
              ),
            ),
          ),
          const ShowcaseCard(
            description: 'A fixed-row multiline input with a counter inside the box.',
            eyebrow: 'TEXT AREA',
            title: 'TextArea',
            child: NextThemeIsland(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalTextArea(
                    key: ValueKey<String>('biography-area'),
                    assistiveText: 'Visible on your public profile',
                    label: 'Biography',
                    maxLength: 200,
                    placeholder: 'Tell us about yourself',
                    rows: 3,
                    showCount: true,
                    showLabel: true,
                  ),
                  CharcoalGap(CharcoalSpace.md),
                  CharcoalTextArea(
                    invalid: true,
                    label: 'Invalid area',
                    rows: 2,
                    assistiveText: 'Required',
                  ),
                ],
              ),
            ),
          ),
          ShowcaseCard(
            description: 'Search with a clear affordance, a date-time picker and a switch row.',
            eyebrow: 'COMPOSED FIELDS',
            title: 'SearchField · DateTimeField · SwitchField',
            child: NextThemeIsland(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalSearchField(
                    controller: _search,
                    placeholder: 'Search works',
                    onClear: _search.clear,
                  ),
                  const CharcoalGap(CharcoalSpace.lg),
                  CharcoalDateTimeField(
                    label: 'Publish at',
                    hint: 'Shown to everyone from this moment',
                    value: _publishAt,
                    onChanged: (value) => setState(() => _publishAt = value),
                  ),
                  const CharcoalGap(CharcoalSpace.lg),
                  CharcoalSwitchField(
                    label: 'Notify followers',
                    hint: 'Sent once when the work is published',
                    value: _notify,
                    onChanged: (value) => setState(() => _notify = value),
                  ),
                ],
              ),
            ),
          ),
          ShowcaseCard(
            description: 'A controlled dropdown with an anchored, keyboard-navigable list.',
            eyebrow: 'DROPDOWN',
            title: 'Dropdown',
            child: NextThemeIsland(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalDropdown<String>(
                    key: const ValueKey<String>('work-type-dropdown'),
                    label: 'Work type',
                    onChanged: (value) => setState(() => _workType = value),
                    options: const <CharcoalDropdownOption<String>>[
                      CharcoalDropdownOption<String>(value: 'illustration', label: 'Illustration'),
                      CharcoalDropdownOption<String>(
                        value: 'manga',
                        label: 'Manga',
                        secondary: 'Multiple pages',
                      ),
                      CharcoalDropdownOption<String>(value: 'novel', label: 'Novel'),
                    ],
                    placeholder: 'Choose a type',
                    showLabel: true,
                    value: _workType,
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  CharcoalDropdown<String>(
                    disabled: true,
                    label: 'Disabled',
                    onChanged: (_) {},
                    options: const <CharcoalDropdownOption<String>>[
                      CharcoalDropdownOption<String>(value: 'a', label: 'A'),
                    ],
                    placeholder: 'Unavailable',
                    value: null,
                  ),
                ],
              ),
            ),
          ),
          const ShowcaseCard(
            description: 'Advisory guidance on a secondary surface, with an action.',
            eyebrow: 'HINT TEXT',
            title: 'HintText',
            child: NextThemeIsland(
              child: CharcoalHintText(
                action: Text('Review'),
                maxWidth: double.infinity,
                subtitle: Text('This is guidance, not validation feedback.'),
                child: Text('Changes are saved automatically.'),
              ),
            ),
          ),
          const ShowcaseCard(
            description:
                'A titled group of fields and a labelled shell for any control, such as a secret '
                'field with a file action the app provides.',
            eyebrow: 'FORM SHELL',
            title: 'FormSection · FormField',
            child: NextThemeIsland(
              child: CharcoalFormSection(
                caption: 'Credentials are stored encrypted',
                title: 'Signing key',
                children: <Widget>[
                  CharcoalFormField(
                    action: Text('Choose file…'),
                    assistiveText: 'PEM or JSON, up to 64 KiB',
                    label: 'Private key',
                    required: true,
                    child: CharcoalTextArea(rows: 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
