import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Reports the global bounds of [child] whenever layout or painting moves it.
///
/// Overlay entries live outside their anchor's render subtree, so scrolling an
/// ancestor does not rebuild them. This render-object bridge keeps anchored
/// Charcoal surfaces attached without scheduling an idle frame loop.
final class CharcoalOverlayAnchorTracker extends SingleChildRenderObjectWidget {
  const CharcoalOverlayAnchorTracker({
    required this.onRectChanged,
    required super.child,
    super.key,
  });

  final ValueChanged<Rect> onRectChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderCharcoalOverlayAnchorTracker(onRectChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderObject renderObject,
  ) {
    (renderObject as _RenderCharcoalOverlayAnchorTracker).onRectChanged = onRectChanged;
  }
}

final class _RenderCharcoalOverlayAnchorTracker extends RenderProxyBox {
  _RenderCharcoalOverlayAnchorTracker(this.onRectChanged);

  ValueChanged<Rect> onRectChanged;
  Rect? _lastRect;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (!attached || !hasSize) return;

    final rect = MatrixUtils.transformRect(
      getTransformTo(null),
      Offset.zero & size,
    );
    if (_lastRect == rect) return;
    _lastRect = rect;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached && _lastRect == rect) onRectChanged(rect);
    });
  }
}
