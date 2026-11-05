import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Composed UI', size: Size(520, 360))
Widget charcoalComposedUiPreview() => const _ComposedUiPreview();

final class _ComposedUiPreview extends StatefulWidget {
  const _ComposedUiPreview();

  @override
  State<_ComposedUiPreview> createState() => _ComposedUiPreviewState();
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
