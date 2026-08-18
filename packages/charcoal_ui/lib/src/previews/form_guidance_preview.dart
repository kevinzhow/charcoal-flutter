import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Field label · Metadata', size: Size(420, 180))
Widget charcoalFieldLabelPreview() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalFieldLabel(label: 'Display name'),
    SizedBox(height: 20),
    CharcoalFieldLabel(
      label: 'Project description',
      required: true,
      requiredText: 'Required',
      subLabel: Text('0/500'),
    ),
  ],
);

@CharcoalComponentPreview(
  name: 'Field label · Compact scaled metadata',
  size: Size(240, 280),
)
Widget charcoalScaledFieldLabelPreview() => Builder(
  builder: (context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(2),
    ),
    child: const CharcoalFieldLabel(
      label: 'Project description',
      required: true,
      requiredText: 'Required',
      subLabel: Text('0/500'),
    ),
  ),
);

@CharcoalComponentPreview(name: 'Hint text · Advisory action', size: Size(420, 240))
Widget charcoalHintTextPreview() => const _HintTextPreview();

@CharcoalComponentPreview(
  name: 'Hint text · Compact advisory action',
  size: Size(240, 340),
)
Widget charcoalCompactHintTextPreview() => const _HintTextPreview();

final class _HintTextPreview extends StatefulWidget {
  const _HintTextPreview();

  @override
  State<_HintTextPreview> createState() => _HintTextPreviewState();
}

final class _HintTextPreviewState extends State<_HintTextPreview> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    if (!visible) {
      return Text(
        'Guidance dismissed',
        style: theme.textStyles.captionMedium,
      );
    }
    return CharcoalHintText(
      action: CharcoalButton(
        onPressed: () => setState(() => visible = false),
        size: CharcoalButtonSize.small,
        variant: CharcoalButtonVariant.primary,
        child: const Text('Dismiss'),
      ),
      maxWidth: double.infinity,
      subtitle: const Text('This is guidance, not validation feedback.'),
      child: const Text('Changes are saved automatically.'),
    );
  }
}
