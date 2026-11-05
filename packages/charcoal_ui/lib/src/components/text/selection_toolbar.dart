import 'dart:math' as math;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';

/// Builds a Charcoal editing menu using Flutter's permitted clipboard actions.
///
/// Labels follow [WidgetsLocalizations]. Pass this as a context menu builder, or replace it on a
/// field to supply application-specific actions. Where the platform offers a system menu for the
/// field it is used instead.
Widget buildCharcoalTextContextMenu(BuildContext context, EditableTextState state) {
  if (SystemContextMenu.isSupportedByField(state)) {
    return SystemContextMenu.editableText(editableTextState: state);
  }
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
  final entries = <CharcoalSelectionToolbarEntry>[
    for (final item in state.contextMenuButtonItems)
      if (label(item).isNotEmpty)
        CharcoalSelectionToolbarEntry(label: label(item), onPressed: item.onPressed),
  ];
  if (entries.isEmpty) return const SizedBox.shrink();
  return CharcoalSelectionToolbar(anchors: state.contextMenuAnchors, entries: entries);
}

/// One action of a [CharcoalSelectionToolbar].
@immutable
class CharcoalSelectionToolbarEntry {
  /// An action with a visible [label].
  const CharcoalSelectionToolbarEntry({required this.label, required this.onPressed});

  /// The visible and spoken label.
  final String label;

  /// Called on activation; null disables the entry.
  final VoidCallback? onPressed;
}

/// The floating editing menu shown over a text selection.
///
/// It stays inside the safe area and above the keyboard, prefers the space above the selection and
/// scrolls when the entries do not fit (large text scales).
class CharcoalSelectionToolbar extends StatelessWidget {
  /// Shows [entries] next to [anchors].
  const CharcoalSelectionToolbar({required this.anchors, required this.entries, super.key});

  /// Where the selection is; the toolbar picks the side with room.
  final TextSelectionToolbarAnchors anchors;

  /// The actions, in order.
  final List<CharcoalSelectionToolbarEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.selectionToolbar;
    final colors = theme.colors;
    final media = MediaQuery.of(context);
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final origin = overlay.localToGlobal(Offset.zero);
    final inset = EdgeInsets.fromLTRB(
      math.max(metrics.edgeInset, media.padding.left),
      math.max(metrics.edgeInset, media.padding.top),
      math.max(metrics.edgeInset, media.padding.right),
      math.max(metrics.edgeInset, math.max(media.padding.bottom, media.viewInsets.bottom)),
    );
    final offset = origin + Offset(inset.left, inset.top);
    return Padding(
      padding: inset,
      child: CustomSingleChildLayout(
        delegate: _ToolbarLayout(
          anchorAbove: anchors.primaryAnchor - offset - Offset(0, metrics.anchorAboveGap),
          anchorBelow:
              (anchors.secondaryAnchor ?? anchors.primaryAnchor) -
              offset +
              Offset(0, metrics.anchorBelowGap),
        ),
        child: TextFieldTapRegion(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.background,
              border: Border.all(color: colors.borderSubtle, width: theme.borders.hairline),
              borderRadius: BorderRadius.circular(theme.radius.sm),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(metrics.padding),
                child: Wrap(
                  children: [for (final entry in entries) _ToolbarButton(entry: entry)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.entry});

  final CharcoalSelectionToolbarEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    return CharcoalClickable(
      onPressed: entry.onPressed,
      semanticLabel: entry.label,
      builder: (context, states) => DecoratedBox(
        decoration: BoxDecoration(
          color: resolveCharcoalStateColor(
            states,
            normal: colors.fillSecondary,
            hovered: colors.fillSecondaryHover,
            pressed: colors.fillSecondaryPress,
          ),
          borderRadius: BorderRadius.circular(theme.radius.sm),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: theme.sizes.controlSm),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.space.md),
            child: Center(
              widthFactor: 1,
              child: Text(
                entry.label,
                style: theme.style(
                  CharcoalTextRole.size14,
                  bold: true,
                  color: states.contains(WidgetState.disabled)
                      ? colors.textDisabled
                      : colors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
