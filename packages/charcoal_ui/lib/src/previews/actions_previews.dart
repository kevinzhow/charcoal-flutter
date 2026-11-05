import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../next.dart';
import 'next_preview_support.dart';

@CharcoalNextComponentPreview(name: 'Buttons', size: Size(420, 460))
Widget charcoalButtonGalleryPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    for (final variant in CharcoalButtonVariant.values) ...<Widget>[
      CharcoalButton(onPressed: () {}, variant: variant, child: Text(variant.name)),
      const CharcoalGap(CharcoalSpace.sm),
    ],
    const CharcoalButton(onPressed: null, child: Text('disabled')),
  ],
);

@CharcoalNextComponentPreview(name: 'Icon actions', size: Size(420, 180))
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
      const CharcoalGap.horizontal(CharcoalSpace.md),
    ],
  ],
);

@CharcoalNextComponentPreview(name: 'Selection controls', size: Size(420, 440))
Widget charcoalSelectionControlsPreview() => const _SelectionControlsPreview();

final class _SelectionControlsPreview extends StatefulWidget {
  const _SelectionControlsPreview();

  @override
  State<_SelectionControlsPreview> createState() => _SelectionControlsPreviewState();
}

final class _SelectionControlsPreviewState extends State<_SelectionControlsPreview> {
  bool checkbox = true;
  bool switchValue = true;
  String radio = 'first';
  String segment = 'week';
  double slider = 0.4;

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
        const CharcoalGap(CharcoalSpace.lg),
        for (final option in const <String>['first', 'second']) ...<Widget>[
          CharcoalRadio<String>(
            value: option,
            groupValue: radio,
            onChanged: (value) => setState(() => radio = value),
            label: Text('$option option'),
          ),
          const CharcoalGap(CharcoalSpace.sm),
        ],
        const CharcoalGap(CharcoalSpace.md),
        CharcoalSwitch(
          value: switchValue,
          onChanged: (value) => setState(() => switchValue = value),
          label: const Text('Enable notifications'),
        ),
        const CharcoalGap(CharcoalSpace.lg),
        CharcoalSegmentedControl<String>(
          value: segment,
          onChanged: (value) => setState(() => segment = value),
          segments: const <CharcoalSegment<String>>[
            CharcoalSegment<String>(value: 'day', child: Text('Day')),
            CharcoalSegment<String>(value: 'week', child: Text('Week')),
          ],
        ),
        const CharcoalGap(CharcoalSpace.md),
        SizedBox(
          width: 280,
          child: CharcoalSlider(
            value: slider,
            onChanged: (value) => setState(() => slider = value),
          ),
        ),
      ],
    );
  }
}

@CharcoalNextComponentPreview(name: 'Multi-select', size: Size(420, 300))
Widget charcoalMultiSelectPreview() => const _MultiSelectPreview();

final class _MultiSelectPreview extends StatefulWidget {
  const _MultiSelectPreview();

  @override
  State<_MultiSelectPreview> createState() => _MultiSelectPreviewState();
}

final class _MultiSelectPreviewState extends State<_MultiSelectPreview> {
  bool selected = true;
  bool overlaySelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalMultiSelect(
          label: const Text('Include original files'),
          onChanged: (value) => setState(() => selected = value),
          selected: selected,
        ),
        const CharcoalGap(CharcoalSpace.lg),
        const CharcoalMultiSelect(
          invalid: true,
          label: Text('Invalid option'),
          onChanged: null,
          selected: false,
        ),
        const CharcoalGap(CharcoalSpace.lg),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.radius.lg),
            gradient: LinearGradient(colors: <Color>[theme.colors.primary, theme.colors.neutral]),
          ),
          child: SizedBox(
            height: 96,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsets.all(theme.space.md),
                child: CharcoalMultiSelect(
                  onChanged: (value) => setState(() => overlaySelected = value),
                  selected: overlaySelected,
                  semanticLabel: 'Select featured media',
                  variant: CharcoalMultiSelectVariant.overlay,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

@CharcoalNextComponentPreview(name: 'Tag item · Controlled states', size: Size(520, 220))
Widget charcoalTagItemStatesPreview() => const _TagItemPreview();

@CharcoalNextComponentPreview(name: 'Tag item · Compact translation', size: Size(240, 220))
Widget charcoalCompactTagItemPreview() => const _TagItemPreview(compact: true);

final class _TagItemPreview extends StatefulWidget {
  const _TagItemPreview({this.compact = false});

  final bool compact;

  @override
  State<_TagItemPreview> createState() => _TagItemPreviewState();
}

final class _TagItemPreviewState extends State<_TagItemPreview> {
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    final status = selected ? CharcoalTagItemStatus.active : CharcoalTagItemStatus.normal;
    if (widget.compact) {
      return SizedBox(
        width: double.infinity,
        child: CharcoalTagItem(
          label: '#とても長いオリジナルタグ',
          onPressed: () => setState(() => selected = !selected),
          semanticLabel: 'Long translated tag',
          status: status,
          translatedLabel: 'a very long translated tag',
        ),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        CharcoalTagItem(label: '#landscape', onPressed: () {}),
        CharcoalTagItem(
          label: '#original',
          onPressed: () => setState(() => selected = !selected),
          status: status,
        ),
        CharcoalTagItem(
          label: '#inactive',
          onPressed: () {},
          status: CharcoalTagItemStatus.inactive,
        ),
        CharcoalTagItem(label: '#創作', onPressed: () {}, translatedLabel: 'original work'),
        const CharcoalTagItem(label: '#disabled', onPressed: null),
        const CharcoalChip('positive', tone: CharcoalTone.positive),
        const CharcoalStatusDot(CharcoalTone.negative),
      ],
    );
  }
}
