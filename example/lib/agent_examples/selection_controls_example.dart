import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

enum _Audience { everyone, followers, private }

/// Parent-owned checkbox, radio, and switch state with distinct responsibilities.
final class AgentSelectionControlsExample extends StatefulWidget {
  const AgentSelectionControlsExample({super.key});

  @override
  State<AgentSelectionControlsExample> createState() =>
      _AgentSelectionControlsExampleState();
}

final class _AgentSelectionControlsExampleState
    extends State<AgentSelectionControlsExample> {
  _Audience _audience = _Audience.followers;
  bool _saveDrafts = true;
  bool _releaseNotifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Publishing preferences', style: theme.textStyles.headingS),
        SizedBox(height: space.component30),
        CharcoalCheckbox(
          value: _saveDrafts,
          onChanged: (value) => setState(() => _saveDrafts = value),
          label: const Text('Save drafts automatically'),
        ),
        SizedBox(height: space.layout40),
        Text('Audience', style: theme.textStyles.bodyBold),
        SizedBox(height: space.component20),
        Semantics(
          container: true,
          explicitChildNodes: true,
          label: 'Audience options',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CharcoalRadio<_Audience>(
                value: _Audience.everyone,
                groupValue: _audience,
                onChanged: (value) => setState(() => _audience = value),
                label: const Text('Everyone'),
              ),
              SizedBox(height: space.component30),
              CharcoalRadio<_Audience>(
                value: _Audience.followers,
                groupValue: _audience,
                onChanged: (value) => setState(() => _audience = value),
                label: const Text('Followers'),
              ),
              SizedBox(height: space.component30),
              CharcoalRadio<_Audience>(
                value: _Audience.private,
                groupValue: _audience,
                onChanged: (value) => setState(() => _audience = value),
                label: const Text('Only me'),
              ),
            ],
          ),
        ),
        SizedBox(height: space.layout40),
        CharcoalSwitch(
          value: _releaseNotifications,
          onChanged: (value) => setState(() => _releaseNotifications = value),
          label: const Text('Release notifications'),
        ),
      ],
    );
  }
}
