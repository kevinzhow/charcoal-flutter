import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Named one-shot actions, a controlled icon toggle, and a text-only action.
final class AgentActionControlsExample extends StatefulWidget {
  const AgentActionControlsExample({super.key});

  @override
  State<AgentActionControlsExample> createState() =>
      _AgentActionControlsExampleState();
}

final class _AgentActionControlsExampleState
    extends State<AgentActionControlsExample> {
  bool _saved = false;
  String _status = 'No action yet';

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Item actions', style: theme.textStyles.headingS),
        SizedBox(height: space.component20),
        Text(_status, style: theme.textStyles.captionMedium),
        SizedBox(height: space.layout40),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: space.component30,
          runSpacing: space.component30,
          children: <Widget>[
            CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.bookmark),
              onPressed: () {
                setState(() {
                  _saved = !_saved;
                  _status = _saved ? 'Item saved' : 'Item removed from saved';
                });
              },
              selected: _saved,
              semanticLabel: _saved ? 'Remove saved item' : 'Save item',
            ),
            CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.search),
              onPressed: () => setState(() => _status = 'Search opened'),
              semanticLabel: 'Search related items',
            ),
            const CharcoalIconButton(
              icon: CharcoalIcon(CharcoalIcons.dotsHorizontal),
              onPressed: null,
              semanticLabel: 'More actions unavailable',
            ),
          ],
        ),
        SizedBox(height: space.layout40),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: CharcoalLinkButton(
            onPressed: () => setState(() => _status = 'Filters cleared'),
            child: const Text('Clear filters'),
          ),
        ),
      ],
    );
  }
}
