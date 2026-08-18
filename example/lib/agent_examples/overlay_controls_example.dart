import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Separates brief tooltip context, persistent callouts, and anchored details.
final class AgentOverlayControlsExample extends StatefulWidget {
  const AgentOverlayControlsExample({super.key});

  @override
  State<AgentOverlayControlsExample> createState() =>
      _AgentOverlayControlsExampleState();
}

final class _AgentOverlayControlsExampleState
    extends State<AgentOverlayControlsExample> {
  bool _detailsVisible = false;
  String _status = 'No overlay action yet';

  void _setDetailsVisible(bool visible) {
    if (_detailsVisible == visible) return;
    setState(() {
      _detailsVisible = visible;
      _status = visible
          ? 'Publishing details open'
          : 'Publishing details closed';
    });
  }

  void _reviewSettings() {
    setState(() {
      _detailsVisible = false;
      _status = 'Settings review requested';
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
        Text('Anchored context', style: theme.textStyles.headingS),
        SizedBox(height: space.component20),
        Text(_status, style: theme.textStyles.captionMedium),
        SizedBox(height: space.layout40),
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: CharcoalBalloon(
            position: CharcoalOverlayPosition.left,
            semanticLabel: 'Publishing guidance',
            child: Text('Drafts remain private until you publish.'),
          ),
        ),
        SizedBox(height: space.layout40),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: space.component30,
          runSpacing: space.component30,
          children: <Widget>[
            CharcoalTooltip(
              message: 'Copies a shareable link',
              child: CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.link),
                onPressed: () => setState(() => _status = 'Share link copied'),
                semanticLabel: 'Copy share link',
              ),
            ),
            CharcoalAnchoredBalloon(
              action: CharcoalLinkButton(
                onPressed: _reviewSettings,
                child: const Text('Review settings'),
              ),
              anchor: CharcoalButton(
                leading: const CharcoalIcon(CharcoalIcons.questionCircle),
                onPressed: () => _setDetailsVisible(!_detailsVisible),
                semanticLabel: _detailsVisible
                    ? 'Hide publishing details'
                    : 'Show publishing details',
                child: const Text('Publishing details'),
              ),
              dismissOnTapOutside: true,
              message: 'Only workspace owners can publish this draft.',
              onVisibilityChanged: _setDetailsVisible,
              showOnTap: false,
              visible: _detailsVisible,
            ),
          ],
        ),
      ],
    );
  }
}
