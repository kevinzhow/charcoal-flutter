import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A bounded asynchronous action with blocking progress and a durable result.
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
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _published = published;
      _saving = false;
      _status = published ? 'Draft published.' : 'Draft returned to private.';
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
        Text('Publishing', style: theme.textStyles.headingS),
        SizedBox(height: space.component20),
        Semantics(
          liveRegion: true,
          child: Text(
            _status,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ),
        SizedBox(height: space.layout40),
        CharcoalSpinnerOverlay(
          semanticLabel: _pendingPublished
              ? 'Publishing draft'
              : 'Returning draft to private',
          visible: _saving,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerSecondaryDefault,
            ),
            child: Padding(
              padding: EdgeInsets.all(space.layout40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _published ? 'Published' : 'Private draft',
                    style: theme.textStyles.bodyBold,
                  ),
                  SizedBox(height: space.component30),
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
        ),
      ],
    );
  }
}
