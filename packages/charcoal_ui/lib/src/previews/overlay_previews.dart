import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Tooltip and balloons', size: Size(420, 380))
Widget charcoalAnchoredOverlayPreview() => const _AnchoredOverlayPreview();

final class _AnchoredOverlayPreview extends StatefulWidget {
  const _AnchoredOverlayPreview();

  @override
  State<_AnchoredOverlayPreview> createState() => _AnchoredOverlayPreviewState();
}

final class _AnchoredOverlayPreviewState extends State<_AnchoredOverlayPreview> {
  bool _balloonVisible = false;

  void _setBalloonVisible(bool visible) {
    if (_balloonVisible == visible) return;
    setState(() => _balloonVisible = visible);
  }

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalBalloon(
          position: CharcoalOverlayPosition.left,
          semanticLabel: 'Persistent callout',
          child: Text('This callout stays in the authored layout.'),
        ),
        SizedBox(height: space.layout40),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: space.component30,
          runSpacing: space.component30,
          children: <Widget>[
            CharcoalTooltip(
              message: 'Brief, non-interactive context',
              child: CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.infoCircle),
                onPressed: () {},
                semanticLabel: 'Show information',
              ),
            ),
            CharcoalAnchoredBalloon(
              anchor: CharcoalButton(
                onPressed: () => _setBalloonVisible(!_balloonVisible),
                semanticLabel: _balloonVisible
                    ? 'Hide persistent details'
                    : 'Show persistent details',
                child: const Text('Persistent details'),
              ),
              dismissOnTapOutside: true,
              message: 'The controlled trigger works from pointer or keyboard.',
              onVisibilityChanged: _setBalloonVisible,
              showOnTap: false,
              visible: _balloonVisible,
            ),
          ],
        ),
      ],
    );
  }
}
