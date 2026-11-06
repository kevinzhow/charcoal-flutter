import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Visible field metadata and optional guidance with one controlled outcome.
final class AgentFormGuidanceExample extends StatefulWidget {
  const AgentFormGuidanceExample({super.key});

  @override
  State<AgentFormGuidanceExample> createState() =>
      _AgentFormGuidanceExampleState();
}

final class _AgentFormGuidanceExampleState
    extends State<AgentFormGuidanceExample> {
  final TextEditingController _controller = TextEditingController();
  bool _showGuidance = true;
  String? _status;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyExample() {
    setState(() {
      _controller.text = 'https://example.com/portfolio';
      _showGuidance = false;
      _status = 'Example portfolio URL applied.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalText('Public profile', role: CharcoalTextRole.headingS),
        const CharcoalGap(CharcoalSpace.xl),
        const CharcoalFieldLabel(
          label: 'Portfolio URL',
          required: true,
          requiredText: 'Required',
          subLabel: Text('Public'),
        ),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalTextField(
          controller: _controller,
          label: 'Portfolio URL',
          placeholder: 'https://example.com/your-name',
          required: true,
        ),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalHintText(
          action: CharcoalButton(
            onPressed: _applyExample,
            size: CharcoalButtonSize.small,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Use example'),
          ),
          alignment: Alignment.centerLeft,
          maxWidth: double.infinity,
          subtitle: const Text('You can replace it before publishing.'),
          visible: _showGuidance,
          child: const Text('Add a complete URL including https://.'),
        ),
        if (_status case final status?) ...<Widget>[
          const CharcoalGap(CharcoalSpace.sm),
          Semantics(
            liveRegion: true,
            child: CharcoalText(
              status,
              role: CharcoalTextRole.captionMedium,
              tone: CharcoalTextTone.secondary,
            ),
          ),
        ],
      ],
    );
  }
}
