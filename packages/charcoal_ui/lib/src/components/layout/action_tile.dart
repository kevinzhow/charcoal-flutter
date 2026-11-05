import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../icons/icon_view.dart';
import '../text/charcoal_text.dart';

/// An outlined button tile with a leading icon and a one-line label: a quick action on a
/// dashboard.
///
/// Hover and press blend the theme's state overlays into the tile and focus recolours the
/// outline; the outline keeps its width in every state, so the tile never moves. The tile is at
/// least `sizes.controlLg` high and takes the width it is given.
///
/// ```dart
/// CharcoalActionTile(icon: CharcoalIcons.add, label: 'New project', onPressed: create)
/// ```
final class CharcoalActionTile extends StatelessWidget {
  /// Creates a tile.
  const CharcoalActionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// The glyph before the label.
  final CharcoalIconData icon;

  /// The label; also the semantics label.
  final String label;

  /// Called on activation; null disables the tile.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: label,
      builder: (context, states) {
        final overlay = states.contains(WidgetState.pressed)
            ? colors.pressOverlay
            : states.contains(WidgetState.hovered)
            ? colors.hoverOverlay
            : null;
        return Container(
          constraints: BoxConstraints(minHeight: theme.sizes.controlLg),
          padding: EdgeInsets.symmetric(
            horizontal: theme.space.md,
            vertical: theme.space.sm,
          ),
          decoration: BoxDecoration(
            color: overlay,
            border: Border.all(
              color: states.contains(WidgetState.focused)
                  ? colors.borderFocus
                  : colors.borderSubtle,
              width: theme.borders.hairline,
            ),
            borderRadius: BorderRadius.circular(theme.radius.md),
          ),
          child: Row(
            children: <Widget>[
              CharcoalIconView(
                icon,
                size: CharcoalIconSize.lg,
                tone: CharcoalIconTone.secondary,
              ),
              SizedBox(width: theme.space.sm),
              Expanded(
                child: CharcoalText(
                  label,
                  role: CharcoalTextRole.bodyBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
