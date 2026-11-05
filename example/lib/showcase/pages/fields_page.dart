import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

final class _FieldsPageState extends State<FieldsPage> {
  String? _workType = 'illustration';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'Labels, single-line and multiline inputs, validation, counters, disabled states, and dropdown menus.',
        eyebrow: 'COMPONENTS · FIELDS',
        title: 'Fields and menus',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description:
                'Label, required marker, and trailing sub-label composition.',
            eyebrow: 'FIELD LABEL',
            title: 'FieldLabel',
            child: Column(
              children: <Widget>[
                CharcoalFieldLabel(label: 'Display name'),
                SizedBox(height: 18),
                CharcoalFieldLabel(
                  label: 'Description',
                  required: true,
                  subLabel: Text('0/500'),
                ),
              ],
            ),
          ),
          const ShowcaseCard(
            description: 'Default, invalid, and disabled single-line states.',
            eyebrow: 'TEXT FIELD',
            title: 'TextField',
            child: Column(
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
                SizedBox(height: 22),
                CharcoalTextField(
                  assistiveText: 'This value is required',
                  invalid: true,
                  label: 'Invalid field',
                  placeholder: 'Required',
                  showLabel: true,
                ),
                SizedBox(height: 22),
                CharcoalTextField(
                  assistiveText: 'Editing is unavailable',
                  disabled: true,
                  label: 'Disabled field',
                  placeholder: 'Disabled',
                  showLabel: true,
                ),
              ],
            ),
          ),
          const ShowcaseCard(
            description: 'Multiline editing follows the source row, label, and counter metrics.',
            eyebrow: 'TEXT AREA',
            title: 'TextArea',
            child: Column(
              children: <Widget>[
                CharcoalTextArea(
                  assistiveText: 'Markdown is supported',
                  label: 'Description',
                  maxLength: 500,
                  placeholder: 'Write a description',
                  required: true,
                  rows: 4,
                  showCount: true,
                  showLabel: true,
                ),
                SizedBox(height: 22),
                CharcoalTextArea(
                  assistiveText: 'Description is too short',
                  invalid: true,
                  label: 'Invalid description',
                  placeholder: 'Add more detail',
                  rows: 3,
                  showLabel: true,
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description:
                'Selected, placeholder, disabled option, and field metadata.',
            eyebrow: 'DROPDOWN',
            title: 'Dropdown',
            child: Column(
              children: <Widget>[
                CharcoalDropdown<String>(
                  key: const ValueKey<String>('work-type-dropdown'),
                  assistiveText: 'Choose the format of your work',
                  label: 'Work type',
                  onChanged: (value) => setState(() => _workType = value),
                  options: const <CharcoalDropdownOption<String>>[
                    CharcoalDropdownOption<String>(
                      label: 'Illustration',
                      value: 'illustration',
                    ),
                    CharcoalDropdownOption<String>(
                      label: 'Manga',
                      secondary: 'A work with multiple pages',
                      value: 'manga',
                    ),
                    CharcoalDropdownOption<String>(
                      label: 'Novel',
                      value: 'novel',
                    ),
                    CharcoalDropdownOption<String>(
                      enabled: false,
                      label: 'Animation (unavailable)',
                      value: 'animation',
                    ),
                  ],
                  placeholder: 'Choose a type',
                  required: true,
                  showLabel: true,
                  value: _workType,
                ),
                const SizedBox(height: 22),
                const CharcoalDropdown<String>(
                  disabled: true,
                  label: 'Disabled menu',
                  onChanged: null,
                  options: <CharcoalDropdownOption<String>>[
                    CharcoalDropdownOption<String>(
                      label: 'Illustration',
                      value: 'illustration',
                    ),
                  ],
                  showLabel: true,
                  value: 'illustration',
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
