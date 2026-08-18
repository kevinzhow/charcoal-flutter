import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Tag item · Controlled states', size: Size(520, 220))
Widget charcoalTagItemStatesPreview() => const _TagItemPreview();

@CharcoalComponentPreview(name: 'Tag item · Compact translation', size: Size(240, 220))
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
    if (widget.compact) {
      return SizedBox(
        width: double.infinity,
        child: CharcoalTagItem(
          label: '#とても長いオリジナルタグ',
          onPressed: () => setState(() => selected = !selected),
          semanticLabel: 'Long translated tag',
          status: selected ? CharcoalTagItemStatus.active : CharcoalTagItemStatus.normal,
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
          status: selected ? CharcoalTagItemStatus.active : CharcoalTagItemStatus.normal,
        ),
        CharcoalTagItem(
          label: '#inactive',
          onPressed: () {},
          status: CharcoalTagItemStatus.inactive,
        ),
        CharcoalTagItem(
          label: '#創作',
          onPressed: () {},
          translatedLabel: 'original work',
        ),
        const CharcoalTagItem(label: '#disabled', onPressed: null),
      ],
    );
  }
}
