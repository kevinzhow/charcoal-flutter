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
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Public profile', style: theme.textStyles.headingS),
        SizedBox(height: space.layout40),
        const CharcoalFieldLabel(
          label: 'Portfolio URL',
          required: true,
          requiredText: 'Required',
          subLabel: Text('Public'),
        ),
        SizedBox(height: space.component20),
        CharcoalTextField(
          controller: _controller,
          label: 'Portfolio URL',
          placeholder: 'https://example.com/your-name',
          required: true,
        ),
        SizedBox(height: space.component20),
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
          SizedBox(height: space.component20),
          Semantics(
            liveRegion: true,
            child: Text(
              status,
              style: theme.textStyles.captionMedium.copyWith(
                color: theme.colors.textSecondaryDefault,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
