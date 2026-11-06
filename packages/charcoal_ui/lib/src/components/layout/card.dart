import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';

/// A grey filled card, the surface for stats and grouped information.
///
/// [outlined] swaps the fill for a hairline outline, for cards that sit directly on the grey
/// surface where a fill would disappear. [raised] keeps the outline and fills the card with the
/// page colour, for cards that stand out from a grey page such as the posts of a feed.
/// [highlighted] marks one item of such a list as new or unread with the secondary surface.
///
/// Pass the interaction [states] of an enclosing `CharcoalClickable` to make the whole card the
/// visible surface of one action: hover and press tint the card, hover and press strengthen the
/// outline, and keyboard focus draws the focus outline. The card owns no gesture; the clickable
/// owns activation and semantics.
///
/// ```dart
/// CharcoalCard(child: CharcoalText('Plan: Pro', role: CharcoalTextRole.bodyBold))
///
/// CharcoalClickable(
///   onPressed: openProject,
///   semanticLabel: 'Open project',
///   builder: (context, states) => CharcoalCard(raised: true, states: states, child: row),
/// )
/// ```
final class CharcoalCard extends StatelessWidget {
  /// Creates a card around [child].
  const CharcoalCard({
    required this.child,
    this.highlighted = false,
    this.outlined = false,
    this.padding = const CharcoalInset.all(CharcoalSpace.lg),
    this.raised = false,
    this.states,
    super.key,
  });

  /// The content.
  final Widget child;

  /// Whether the card is outlined on the secondary surface, marking a new or unread item among
  /// raised cards. Takes precedence over [raised] and [outlined].
  final bool highlighted;

  /// Whether the card is an outline without a fill.
  final bool outlined;

  /// The space between the card edge and [child].
  final CharcoalInset padding;

  /// Whether the card is page-coloured with an outline, raised from a grey page. Takes precedence
  /// over [outlined].
  final bool raised;

  /// The interaction states of the clickable that owns this card, or null for a static card.
  final Set<WidgetState>? states;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final content = Padding(padding: padding.resolve(context), child: child);
    final interaction = states;
    if (interaction == null) {
      return DecoratedBox(decoration: _decoration(theme, null), child: content);
    }
    return TweenAnimationBuilder<Decoration>(
      duration: theme.duration(context, theme.motion.fast),
      tween: DecorationTween(end: _decoration(theme, interaction)),
      builder: (context, decoration, child) => DecoratedBox(
        decoration: decoration,
        position: DecorationPosition.background,
        child: child,
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: TweenAnimationBuilder<Color?>(
                duration: theme.duration(context, theme.motion.fast),
                tween: ColorTween(end: _overlay(colors, interaction)),
                builder: (context, color, _) => DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(theme.radius.md),
                  ),
                ),
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }

  BoxDecoration _decoration(CharcoalTheme theme, Set<WidgetState>? states) {
    final colors = theme.colors;
    final Color? fill = highlighted
        ? colors.surfaceSecondary
        : raised
        ? colors.background
        : outlined
        ? null
        : colors.backgroundSecondary;
    final hasOutline = highlighted || raised || outlined;
    final Color? outline = switch (states) {
      null => hasOutline ? colors.borderSubtle : null,
      final s when s.contains(WidgetState.focused) => colors.borderFocus,
      final s when s.contains(WidgetState.pressed) || s.contains(WidgetState.hovered) =>
        hasOutline ? colors.border : CharcoalColorRoles.transparent,
      _ => hasOutline ? colors.borderSubtle : CharcoalColorRoles.transparent,
    };
    return BoxDecoration(
      color: fill,
      border: outline == null ? null : Border.all(color: outline, width: theme.borders.hairline),
      borderRadius: BorderRadius.circular(theme.radius.md),
    );
  }

  Color _overlay(CharcoalColorRoles colors, Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) return colors.restOverlay;
    if (states.contains(WidgetState.pressed)) return colors.pressOverlay;
    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
      return colors.hoverOverlay;
    }
    return colors.restOverlay;
  }
}
