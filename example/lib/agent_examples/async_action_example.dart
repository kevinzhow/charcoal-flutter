import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import 'simulated_latency.dart';

/// A bounded asynchronous action with blocking progress and a durable result.
///
/// The request is simulated (`simulateRequest`); an application awaits its own service there.
final class AgentAsyncActionExample extends StatefulWidget {
  const AgentAsyncActionExample({super.key});

  @override
  State<AgentAsyncActionExample> createState() =>
      _AgentAsyncActionExampleState();
}

final class _AgentAsyncActionExampleState
    extends State<AgentAsyncActionExample> {
  bool _published = false;
  bool _saving = false;
  bool _pendingPublished = false;
  String _status = 'This draft is private.';

  Future<void> _setPublished(bool published) async {
    if (_saving || _published == published) return;
    setState(() {
      _pendingPublished = published;
      _saving = true;
    });
    await simulateRequest(SimulatedLatency.save);
    if (!mounted) return;
    setState(() {
      _published = published;
      _saving = false;
      _status = published ? 'Draft published.' : 'Draft returned to private.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalText('Publishing', role: CharcoalTextRole.headingS),
        const CharcoalGap(CharcoalSpace.sm),
        Semantics(
          liveRegion: true,
          child: CharcoalText(
            _status,
            role: CharcoalTextRole.captionMedium,
            tone: CharcoalTextTone.secondary,
          ),
        ),
        const CharcoalGap(CharcoalSpace.xl),
        CharcoalSpinnerOverlay(
          semanticLabel: _pendingPublished
              ? 'Publishing draft'
              : 'Returning draft to private',
          visible: _saving,
          child: CharcoalCard(
            padding: const CharcoalInset.all(CharcoalSpace.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CharcoalText(
                  _published ? 'Published' : 'Private draft',
                  role: CharcoalTextRole.bodyLargeBold,
                ),
                const CharcoalGap(CharcoalSpace.lg),
                CharcoalSwitchingButton(
                  isOn: _published,
                  offButton: CharcoalButton(
                    onPressed: () => _setPublished(true),
                    semanticLabel: 'Publish draft',
                    variant: CharcoalButtonVariant.primary,
                    child: const Text('Publish'),
                  ),
                  onButton: CharcoalButton(
                    onPressed: () => _setPublished(false),
                    semanticLabel: 'Return published item to draft',
                    child: const Text('Unpublish'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
