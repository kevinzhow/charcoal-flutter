import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Buttons', size: Size(420, 360))
Widget charcoalButtonGalleryPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    for (final variant in CharcoalButtonVariant.values) ...<Widget>[
      CharcoalButton(
        onPressed: () {},
        variant: variant,
        child: Text(variant.name),
      ),
      const SizedBox(height: 12),
    ],
  ],
);

@CharcoalComponentPreview(name: 'Text fields', size: Size(420, 360))
Widget charcoalTextFieldGalleryPreview() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalTextField(
      assistiveText: 'Use 3–20 characters',
      label: 'Display name',
      maxLength: 20,
      placeholder: 'pixiv user',
      required: true,
      showCount: true,
      showLabel: true,
    ),
    SizedBox(height: 24),
    CharcoalTextField(
      assistiveText: 'This field is required',
      invalid: true,
      label: 'Invalid field',
      placeholder: 'Required',
    ),
  ],
);

@CharcoalComponentPreview(name: 'Text area', size: Size(420, 300))
Widget charcoalTextAreaPreview() => const CharcoalTextArea(
  assistiveText: 'Markdown is supported',
  label: 'Description',
  maxLength: 500,
  placeholder: 'Write a description',
  required: true,
  rows: 5,
  showCount: true,
  showLabel: true,
);

@CharcoalComponentPreview(name: 'Dropdown', size: Size(420, 360))
Widget charcoalDropdownPreview() => const _DropdownPreview();

final class _DropdownPreview extends StatefulWidget {
  const _DropdownPreview();

  @override
  State<_DropdownPreview> createState() => _DropdownPreviewState();
}

final class _DropdownPreviewState extends State<_DropdownPreview> {
  String? value;

  @override
  Widget build(BuildContext context) => CharcoalDropdown<String>(
    assistiveText: 'Choose the format of your work',
    label: 'Work type',
    onChanged: (nextValue) => setState(() => value = nextValue),
    options: const <CharcoalDropdownOption<String>>[
      CharcoalDropdownOption<String>(value: 'illustration', label: 'Illustration'),
      CharcoalDropdownOption<String>(
        value: 'manga',
        label: 'Manga',
        secondary: 'A work with multiple pages',
      ),
      CharcoalDropdownOption<String>(value: 'novel', label: 'Novel'),
    ],
    placeholder: 'Choose a type',
    required: true,
    showLabel: true,
    value: value,
  );
}

@CharcoalComponentPreview(
  name: 'Selection controls',
  size: Size(420, 360),
)
Widget charcoalSelectionControlsPreview() => const _SelectionControlsPreview();

final class _SelectionControlsPreview extends StatefulWidget {
  const _SelectionControlsPreview();

  @override
  State<_SelectionControlsPreview> createState() => _SelectionControlsPreviewState();
}

@CharcoalComponentPreview(name: 'Icon actions', size: Size(420, 180))
Widget charcoalIconActionsPreview() => Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    for (final size in CharcoalIconButtonSize.values) ...<Widget>[
      CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.add),
        onPressed: () {},
        semanticLabel: size.name,
        size: size,
      ),
      const SizedBox(width: 16),
    ],
    const CharcoalLoadingSpinner(size: 24, padding: 8),
  ],
);

@CharcoalComponentPreview(name: 'Composed UI', size: Size(520, 360))
Widget charcoalComposedUiPreview() => const _ComposedUiPreview();

final class _ComposedUiPreview extends StatefulWidget {
  const _ComposedUiPreview();

  @override
  State<_ComposedUiPreview> createState() => _ComposedUiPreviewState();
}

@CharcoalComponentPreview(name: 'Tab bar', size: Size(420, 180))
Widget charcoalTabBarPreview() => const _TabBarPreview();

final class _TabBarPreview extends StatefulWidget {
  const _TabBarPreview();

  @override
  State<_TabBarPreview> createState() => _TabBarPreviewState();
}

final class _TabBarPreviewState extends State<_TabBarPreview> {
  String destination = 'home';

  @override
  Widget build(BuildContext context) => CharcoalTabBar<String>(
    items: const <CharcoalTabItem<String>>[
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.home),
        label: 'Home',
        value: 'home',
      ),
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.compass),
        label: 'Discover',
        value: 'discover',
      ),
      CharcoalTabItem<String>(
        badge: '3',
        icon: CharcoalIcon(CharcoalIcons.message),
        label: 'Messages',
        semanticLabel: 'Messages, 3 unread',
        value: 'messages',
      ),
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.personCircle),
        label: 'Profile',
        value: 'profile',
      ),
    ],
    onChanged: (value) => setState(() => destination = value),
    semanticLabel: 'Primary destinations',
    value: destination,
  );
}

final class _ComposedUiPreviewState extends State<_ComposedUiPreview> {
  String layout = 'grid';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalSegmentedControl<String>(
          fullWidth: true,
          value: layout,
          onChanged: (value) => setState(() => layout = value),
          segments: const <CharcoalSegment<String>>[
            CharcoalSegment<String>(value: 'grid', child: Text('Grid')),
            CharcoalSegment<String>(value: 'list', child: Text('List')),
          ],
        ),
        const SizedBox(height: 24),
        const CharcoalHintText(child: Text('Changes are saved automatically.')),
        const SizedBox(height: 24),
        CharcoalButton(
          variant: CharcoalButtonVariant.primary,
          onPressed: () => showCharcoalDialog<void>(
            context: context,
            builder: (dialogContext) => CharcoalDialog(
              title: 'Charcoal dialog',
              actions: <Widget>[
                CharcoalButton(
                  fullWidth: true,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
              ],
              child: const Text('This surface is built without Material or Cupertino.'),
            ),
          ),
          child: const Text('Open dialog'),
        ),
      ],
    );
  }
}

final class _SelectionControlsPreviewState extends State<_SelectionControlsPreview> {
  bool checkbox = true;
  bool multiSelect = true;
  bool switchValue = true;
  String radio = 'first';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalCheckbox(
          value: checkbox,
          onChanged: (value) => setState(() => checkbox = value),
          label: const Text('Receive updates'),
        ),
        const SizedBox(height: 20),
        CharcoalMultiSelect(
          selected: multiSelect,
          onChanged: (value) => setState(() => multiSelect = value),
          label: const Text('Include original files'),
        ),
        const SizedBox(height: 20),
        CharcoalRadio<String>(
          value: 'first',
          groupValue: radio,
          onChanged: (value) => setState(() => radio = value),
          label: const Text('First option'),
        ),
        const SizedBox(height: 12),
        CharcoalRadio<String>(
          value: 'second',
          groupValue: radio,
          onChanged: (value) => setState(() => radio = value),
          label: const Text('Second option'),
        ),
        const SizedBox(height: 20),
        CharcoalSwitch(
          value: switchValue,
          onChanged: (value) => setState(() => switchValue = value),
          label: const Text('Enable notifications'),
        ),
      ],
    );
  }
}
