import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A project settings form built from Charcoal form components.
///
/// `CharcoalFormSection` and `CharcoalFormField` own label, helper, required and invalid
/// presentation; the screen owns the values and the validation rule.
final class AgentFormSectionExample extends StatefulWidget {
  const AgentFormSectionExample({super.key});

  @override
  State<AgentFormSectionExample> createState() =>
      _AgentFormSectionExampleState();
}

final class _AgentFormSectionExampleState
    extends State<AgentFormSectionExample> {
  final TextEditingController _name = TextEditingController(
    text: 'Moonlit Garden',
  );
  final TextEditingController _search = TextEditingController();
  bool _public = false;
  double _quality = 0.6;
  DateTime? _publishAt;

  bool get _nameInvalid => _name.text.trim().isEmpty;

  @override
  void dispose() {
    _name.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalFormSection(
          title: 'Project',
          caption: 'Shown to everyone who can open the project.',
          children: <Widget>[
            CharcoalFormField(
              label: 'Name',
              required: true,
              invalid: _nameInvalid,
              assistiveText: _nameInvalid ? 'Enter a project name.' : null,
              child: CharcoalTextField(
                controller: _name,
                invalid: _nameInvalid,
                onChanged: (_) => setState(() {}),
              ),
            ),
            CharcoalSwitchField(
              label: 'Public project',
              hint: 'Anyone with the link can view it.',
              value: _public,
              onChanged: (value) => setState(() => _public = value),
            ),
            CharcoalDateTimeField(
              label: 'Publish at',
              value: _publishAt,
              onChanged: (value) => setState(() => _publishAt = value),
            ),
          ],
        ),
        const CharcoalGap(CharcoalSpace.xl),
        CharcoalFormSection(
          title: 'Export',
          children: <Widget>[
            CharcoalSearchField(
              controller: _search,
              label: 'Find a preset',
              onClear: _search.clear,
            ),
            CharcoalFormField(
              label: 'Quality',
              child: CharcoalSlider(
                value: _quality,
                semanticLabel: 'Export quality',
                onChanged: (value) => setState(() => _quality = value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
