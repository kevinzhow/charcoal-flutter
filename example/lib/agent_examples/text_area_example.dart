import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A controlled multiline field with actionable validation guidance.
final class AgentTextAreaExample extends StatefulWidget {
  const AgentTextAreaExample({super.key});

  @override
  State<AgentTextAreaExample> createState() => _AgentTextAreaExampleState();
}

final class _AgentTextAreaExampleState extends State<AgentTextAreaExample> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    final invalid = _value.isNotEmpty && _value.trim().length < 10;
    return CharcoalTextArea(
      assistiveText: invalid
          ? 'Use at least 10 characters.'
          : 'Explain the context and expected result.',
      invalid: invalid,
      label: 'Description',
      maxLength: 500,
      onChanged: (value) => setState(() => _value = value),
      placeholder: 'Describe what happened',
      required: true,
      rows: 5,
      showCount: true,
      showLabel: true,
    );
  }
}
