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

@CharcoalComponentPreview(name: 'Tag items', size: Size(520, 220))
Widget charcoalTagItemsPreview() => Wrap(
  spacing: 12,
  runSpacing: 12,
  children: <Widget>[
    CharcoalTagItem(label: '#landscape', onPressed: () {}),
    CharcoalTagItem(
      label: '#landscape',
      onPressed: () {},
      status: CharcoalTagItemStatus.active,
    ),
    CharcoalTagItem(
      label: '#landscape',
      onPressed: () {},
      status: CharcoalTagItemStatus.inactive,
    ),
    CharcoalTagItem(
      label: '#original',
      onPressed: () {},
      translatedLabel: 'original work',
    ),
    const CharcoalTagItem(label: '#disabled', onPressed: null),
  ],
);

@CharcoalComponentPreview(name: 'Composed UI', size: Size(520, 360))
Widget charcoalComposedUiPreview() => const _ComposedUiPreview();

final class _ComposedUiPreview extends StatefulWidget {
  const _ComposedUiPreview();

  @override
  State<_ComposedUiPreview> createState() => _ComposedUiPreviewState();
}

@CharcoalComponentPreview(name: 'Carousel', size: Size(620, 320))
Widget charcoalCarouselPreview() => const _CarouselPreview();

final class _CarouselPreview extends StatelessWidget {
  const _CarouselPreview();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = <Color>[
      theme.colors.containerPrimaryDefault,
      theme.colors.containerSecondaryDefault,
      theme.colors.containerNeutralDefault,
    ];
    return SizedBox(
      height: 240,
      child: CharcoalCarousel(
        gap: theme.dimensions.space.component20,
        semanticLabel: 'Featured works',
        showIndicators: true,
        children: <Widget>[
          for (var index = 0; index < colors.length; index++)
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: colors[index],
              ),
              child: Center(
                child: Text(
                  'Slide ${index + 1}',
                  style: theme.textStyles.headingS.copyWith(color: theme.colors.textDefault),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

@CharcoalComponentPreview(name: 'Pagination', size: Size(640, 140))
Widget charcoalPaginationPreview() => const _PaginationPreview();

final class _PaginationPreview extends StatefulWidget {
  const _PaginationPreview();

  @override
  State<_PaginationPreview> createState() => _PaginationPreviewState();
}

final class _PaginationPreviewState extends State<_PaginationPreview> {
  int page = 8;

  @override
  Widget build(BuildContext context) => CharcoalPagination(
    currentPage: page,
    pageCount: 20,
    onPageChanged: (value) => setState(() => page = value),
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
