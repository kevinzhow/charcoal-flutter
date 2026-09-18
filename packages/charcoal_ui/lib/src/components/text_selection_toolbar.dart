import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'button.dart';

/// Builds a Charcoal editing menu using Flutter's permitted clipboard actions.
///
/// Labels follow [WidgetsLocalizations]. Pass this as a context menu builder,
/// or replace it on a field to supply application-specific actions.
Widget buildCharcoalTextContextMenu(BuildContext context, EditableTextState state) {
  if (SystemContextMenu.isSupportedByField(state)) {
    return SystemContextMenu.editableText(editableTextState: state);
  }
  final anchors = state.contextMenuAnchors;
  final items = state.contextMenuButtonItems;
  final theme = CharcoalTheme.of(state.context);
  final labels = WidgetsLocalizations.of(state.context);
  String label(ContextMenuButtonItem item) =>
      item.label ??
      switch (item.type) {
        ContextMenuButtonType.cut => labels.cutButtonLabel,
        ContextMenuButtonType.copy => labels.copyButtonLabel,
        ContextMenuButtonType.paste => labels.pasteButtonLabel,
        ContextMenuButtonType.selectAll => labels.selectAllButtonLabel,
        ContextMenuButtonType.lookUp => labels.lookUpButtonLabel,
        ContextMenuButtonType.searchWeb => labels.searchWebButtonLabel,
        ContextMenuButtonType.share => labels.shareButtonLabel,
        // These types require an application-provided label.
        ContextMenuButtonType.delete ||
        ContextMenuButtonType.liveTextInput ||
        ContextMenuButtonType.custom => '',
      };
  final visible = items.where((item) => label(item).isNotEmpty).toList();
  if (visible.isEmpty) return const SizedBox.shrink();
  final media = MediaQuery.of(context);
  final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
  final origin = overlay.localToGlobal(Offset.zero);
  final inset = EdgeInsets.fromLTRB(
    math.max(8, media.padding.left),
    math.max(8, media.padding.top),
    math.max(8, media.padding.right),
    math.max(8, math.max(media.padding.bottom, media.viewInsets.bottom)),
  );
  final offset = origin + Offset(inset.left, inset.top);
  return CharcoalTheme(
    data: theme,
    child: Padding(
      padding: inset,
      child: CustomSingleChildLayout(
        delegate: _ToolbarLayout(
          anchorAbove: anchors.primaryAnchor - offset - const Offset(0, 8),
          anchorBelow:
              (anchors.secondaryAnchor ?? anchors.primaryAnchor) - offset + const Offset(0, 16),
        ),
        child: TextFieldTapRegion(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colors.backgroundDefault,
              border: Border.all(color: theme.colors.borderSecondary),
              borderRadius: BorderRadius.circular(theme.dimensions.radius.s),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Wrap(
                  children: [
                    for (final item in visible)
                      CharcoalButton(
                        variant: CharcoalButtonVariant.normal,
                        onPressed: item.onPressed,
                        child: Text(label(item)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

final class _ToolbarLayout extends TextSelectionToolbarLayoutDelegate {
  _ToolbarLayout({required super.anchorAbove, required super.anchorBelow});

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final position = super.getPositionForChild(size, childSize);
    return Offset(
      position.dx,
      position.dy.clamp(0.0, math.max(0.0, size.height - childSize.height)).toDouble(),
    );
  }
}
