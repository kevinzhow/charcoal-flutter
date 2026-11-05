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
    final space = theme.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Publishing', style: theme.style(CharcoalTextRole.headingS)),
        SizedBox(height: space.sm),
        Semantics(
          liveRegion: true,
          child: Text(
            _status,
            style: theme
                .style(CharcoalTextRole.captionMedium)
                .copyWith(color: theme.colors.textSecondary),
          ),
        ),
        SizedBox(height: space.xl),
        CharcoalSpinnerOverlay(
          semanticLabel: _pendingPublished
              ? 'Publishing draft'
              : 'Returning draft to private',
          visible: _saving,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.md),
              color: theme.colors.surfaceSecondary,
            ),
            child: Padding(
              padding: EdgeInsets.all(space.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _published ? 'Published' : 'Private draft',
                    style: theme.style(CharcoalTextRole.bodyLargeBold),
                  ),
                  SizedBox(height: space.lg),
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
