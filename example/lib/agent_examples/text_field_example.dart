import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A controlled field that exposes validation without replacing Charcoal internals.
final class AgentTextFieldExample extends StatefulWidget {
  const AgentTextFieldExample({super.key});

  @override
  State<AgentTextFieldExample> createState() => _AgentTextFieldExampleState();
}

final class _AgentTextFieldExampleState extends State<AgentTextFieldExample> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    final invalid = _value.isNotEmpty && _value.length < 3;
    return CharcoalTextField(
      assistiveText: invalid
          ? 'Use at least 3 characters.'
          : 'This appears on your profile.',
      invalid: invalid,
      label: 'Display name',
      onChanged: (value) => setState(() => _value = value),
      placeholder: 'Enter a name',
      required: true,
      showLabel: true,
      textInputAction: TextInputAction.done,
    );
  }
}
