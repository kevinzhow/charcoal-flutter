import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

final class _SelectionPageState extends State<SelectionPage> {
  bool _includeOriginals = true;
  bool _receiveUpdates = true;
  bool _showNotifications = true;
  String _privacy = 'public';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'Checkbox, MultiSelect, Radio, and Switch shown across variants, validation, and disabled states.',
        eyebrow: 'COMPONENTS · SELECTION',
        title: 'Selection controls',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description: 'Square, rounded, invalid, selected, and disabled.',
            eyebrow: 'CHECKBOX',
            title: 'Checkbox',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalCheckbox(
                  key: const ValueKey<String>('receive-updates-checkbox'),
                  label: const Text('Receive product updates'),
                  onChanged: (value) => setState(() => _receiveUpdates = value),
                  value: _receiveUpdates,
                ),
                const SizedBox(height: 16),
                CharcoalCheckbox(
                  label: const Text('Rounded selection'),
                  onChanged: (value) =>
                      setState(() => _includeOriginals = value),
                  rounded: true,
                  value: _includeOriginals,
                ),
                const SizedBox(height: 16),
                CharcoalCheckbox(
                  invalid: true,
                  label: const Text('Invalid selection'),
                  onChanged: (value) =>
                      setState(() => _includeOriginals = value),
                  value: false,
                ),
                const SizedBox(height: 16),
                const CharcoalCheckbox(
                  label: Text('Disabled selected'),
                  onChanged: null,
                  value: true,
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'Normal and overlay indicators with controlled state.',
            eyebrow: 'MULTI SELECT',
            title: 'MultiSelect',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalMultiSelect(
                  label: const Text('Include original files'),
                  onChanged: (value) =>
                      setState(() => _includeOriginals = value),
                  selected: _includeOriginals,
                ),
                const SizedBox(height: 16),
                CharcoalMultiSelect(
                  label: const Text('Overlay variant'),
                  onChanged: (value) => setState(() => _receiveUpdates = value),
                  selected: _receiveUpdates,
                  variant: CharcoalMultiSelectVariant.overlay,
                ),
                const SizedBox(height: 16),
                const CharcoalMultiSelect(
                  label: Text('Disabled'),
                  onChanged: null,
                  selected: false,
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'Mutually exclusive values with an invalid example.',
            eyebrow: 'RADIO',
            title: 'Radio group',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final option in <String>[
                  'public',
                  'private',
                  'followers',
                ]) ...<Widget>[
                  CharcoalRadio<String>(
                    groupValue: _privacy,
                    invalid: option == 'followers',
                    label: Text(option[0].toUpperCase() + option.substring(1)),
                    onChanged: (value) => setState(() => _privacy = value),
                    value: option,
                  ),
                  const SizedBox(height: 14),
                ],
                const CharcoalRadio<String>(
                  groupValue: 'disabled',
                  label: Text('Disabled'),
                  onChanged: null,
                  value: 'disabled',
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'On, off, and disabled switch states.',
            eyebrow: 'SWITCH',
            title: 'Switch',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalSwitch(
                  label: const Text('Show notifications'),
                  onChanged: (value) =>
                      setState(() => _showNotifications = value),
                  value: _showNotifications,
                ),
                const SizedBox(height: 18),
                CharcoalSwitch(
                  label: const Text('Receive updates'),
                  onChanged: (value) => setState(() => _receiveUpdates = value),
                  value: _receiveUpdates,
                ),
                const SizedBox(height: 18),
                const CharcoalSwitch(
                  label: Text('Disabled'),
                  onChanged: null,
                  value: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
