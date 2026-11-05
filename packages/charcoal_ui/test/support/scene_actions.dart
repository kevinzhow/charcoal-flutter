import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for batch 2A: every button variant and size, icon buttons, the selection controls in
/// each state, segmented controls, tags, chips and status dots.
final actionsScenes = <CharcoalScene>[
  CharcoalScene(name: 'actions', size: const Size(600, 1000), build: (_) => const _ActionsScene()),
  CharcoalScene(
    name: 'selection',
    size: const Size(600, 1000),
    build: (_) => const _SelectionScene(),
  ),
];

class _ActionsScene extends StatelessWidget {
  const _ActionsScene();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final size in CharcoalButtonSize.values)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final variant in CharcoalButtonVariant.values)
                      CharcoalButton(
                        size: size,
                        variant: variant,
                        onPressed: noop,
                        leading: CharcoalIcon(CharcoalIcons.check),
                        child: Text(variant.name),
                      ),
                    CharcoalButton(
                      size: size,
                      onPressed: noop,
                      selected: true,
                      child: const Text('Selected'),
                    ),
                    CharcoalButton(size: size, onPressed: null, child: const Text('Disabled')),
                  ],
                ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalButton(
                variant: CharcoalButtonVariant.primary,
                fullWidth: true,
                onPressed: noop,
                child: const Text('Full width'),
              ),
              const CharcoalGap(CharcoalSpace.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  CharcoalLinkButton(onPressed: noop, child: const Text('Link')),
                  const CharcoalLinkButton(onPressed: null, child: Text('Disabled link')),
                  CharcoalSwitchingButton(
                    isOn: true,
                    onButton: CharcoalButton(onPressed: noop, child: const Text('Following')),
                    offButton: CharcoalButton(onPressed: noop, child: const Text('Follow')),
                  ),
                  for (final size in CharcoalIconButtonSize.values) ...[
                    CharcoalIconButton(
                      size: size,
                      onPressed: noop,
                      semanticLabel: 'Like',
                      icon: CharcoalIcon(CharcoalIcons.heart),
                    ),
                    CharcoalIconButton(
                      size: size,
                      onPressed: noop,
                      selected: true,
                      semanticLabel: 'Liked',
                      variant: CharcoalIconButtonVariant.overlay,
                      icon: CharcoalIcon(CharcoalIcons.heart),
                    ),
                  ],
                  CharcoalIconButton(
                    onPressed: null,
                    semanticLabel: 'Disabled',
                    icon: CharcoalIcon(CharcoalIcons.heart),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionScene extends StatelessWidget {
  const _SelectionScene();

  @override
  Widget build(BuildContext context) {
    void noop(Object? _) {}
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CharcoalCheckbox(value: false, onChanged: noop, label: const Text('Off')),
                  CharcoalCheckbox(value: true, onChanged: noop, label: const Text('On')),
                  CharcoalCheckbox(value: true, rounded: true, onChanged: noop),
                  CharcoalCheckbox(value: false, invalid: true, onChanged: noop),
                  const CharcoalCheckbox(value: true, onChanged: null, label: Text('Disabled')),
                  CharcoalRadio<int>(
                    value: 1,
                    groupValue: 1,
                    onChanged: noop,
                    label: const Text('A'),
                  ),
                  CharcoalRadio<int>(
                    value: 2,
                    groupValue: 1,
                    onChanged: noop,
                    label: const Text('B'),
                  ),
                  const CharcoalRadio<int>(value: 2, groupValue: 1, onChanged: null),
                  CharcoalMultiSelect(selected: true, onChanged: noop, label: const Text('Multi')),
                  CharcoalMultiSelect(selected: false, onChanged: noop),
                  CharcoalMultiSelect(
                    selected: false,
                    invalid: true,
                    variant: CharcoalMultiSelectVariant.overlay,
                    onChanged: noop,
                  ),
                  const CharcoalMultiSelect(selected: true, onChanged: null),
                  const CharcoalSelectionBox(selected: true),
                  const CharcoalSelectionBox(selected: false),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CharcoalSwitch(value: true, onChanged: noop, label: const Text('On')),
                  CharcoalSwitch(value: false, onChanged: noop),
                  const CharcoalSwitch(value: true, onChanged: null, label: Text('Disabled')),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalSlider(value: 0.4, onChanged: (_) {}),
              const CharcoalSlider(value: 0.4, onChanged: null),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalSegmentedControl<int>(
                value: 1,
                fullWidth: true,
                onChanged: noop,
                segments: const [
                  CharcoalSegment(value: 1, child: Text('One')),
                  CharcoalSegment(value: 2, child: Text('Two')),
                  CharcoalSegment(value: 3, child: Text('Three'), enabled: false),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  CharcoalTagItem(label: '#tag', onPressed: () {}),
                  CharcoalTagItem(
                    label: '#active',
                    status: CharcoalTagItemStatus.active,
                    onPressed: () {},
                  ),
                  CharcoalTagItem(
                    label: '#inactive',
                    status: CharcoalTagItemStatus.inactive,
                    onPressed: () {},
                  ),
                  CharcoalTagItem(label: '#創作', translatedLabel: 'original', onPressed: () {}),
                  const CharcoalTagItem(label: '#disabled', onPressed: null),
                  for (final tone in CharcoalTone.values) CharcoalChip(tone.name, tone: tone),
                  const CharcoalChip('mono', monospace: true),
                  for (final tone in CharcoalTone.values) CharcoalStatusDot(tone),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
