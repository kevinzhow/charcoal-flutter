import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

enum _FeedMode { recent, popular, saved }

/// A responsive, parent-owned view switcher.
final class AgentSegmentedControlExample extends StatefulWidget {
  const AgentSegmentedControlExample({super.key});

  @override
  State<AgentSegmentedControlExample> createState() =>
      _AgentSegmentedControlExampleState();
}

final class _AgentSegmentedControlExampleState
    extends State<AgentSegmentedControlExample> {
  _FeedMode _value = _FeedMode.recent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CharcoalSegmentedControl<_FeedMode>(
        fullWidth: constraints.maxWidth < 480,
        onChanged: (value) => setState(() => _value = value),
        segments: const <CharcoalSegment<_FeedMode>>[
          CharcoalSegment(value: _FeedMode.recent, child: Text('Recent')),
          CharcoalSegment(value: _FeedMode.popular, child: Text('Popular')),
          CharcoalSegment(value: _FeedMode.saved, child: Text('Saved')),
        ],
        semanticLabel: 'Feed order',
        value: _value,
      ),
    );
  }
}
