import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A scrollable profile editor with persistent page and keyboard-safe controls.
final class AgentScaffoldExample extends StatefulWidget {
  const AgentScaffoldExample({super.key});

  @override
  State<AgentScaffoldExample> createState() => _AgentScaffoldExampleState();
}

final class _AgentScaffoldExampleState extends State<AgentScaffoldExample> {
  final _name = TextEditingController(text: 'Aki Kondo');
  final _bio = TextEditingController(text: 'Illustrator and storyteller.');
  bool _saved = false;

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CharcoalScaffold(
    navigationBar: const CharcoalNavigationBar(title: Text('Edit profile')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CharcoalTextField(
              controller: _name,
              label: 'Display name',
              showLabel: true,
              autofillHints: const [AutofillHints.name],
              onChanged: (_) => setState(() => _saved = false),
            ),
            const SizedBox(height: 24),
            CharcoalTextArea(
              controller: _bio,
              label: 'About you',
              showLabel: true,
              showCount: true,
              maxLength: 200,
              onChanged: (_) => setState(() => _saved = false),
            ),
            if (_saved) ...[
              const SizedBox(height: 24),
              Semantics(
                liveRegion: true,
                child: const Text('Saved for this session.'),
              ),
            ],
          ],
        ),
      ),
    ),
    bottomBar: Padding(
      padding: const EdgeInsets.all(16),
      child: CharcoalButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() => _saved = true);
        },
        variant: CharcoalButtonVariant.primary,
        child: const Text('Save profile'),
      ),
    ),
  );
}
