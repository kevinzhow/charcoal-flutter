import 'dart:math' as math;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import 'close_glyph.dart';

/// The width class of a [CharcoalDialog].
enum CharcoalDialogSize {
  /// `metrics.modal.smallWidth`.
  small,

  /// `metrics.modal.mediumWidth`.
  medium,

  /// `metrics.modal.largeWidth`.
  large,
}

/// Where a modal sits on screen.
enum CharcoalModalStyle {
  /// A centred card.
  center,

  /// A sheet attached to the bottom edge.
  bottomSheet,
}

/// The Charcoal modal surface used for centred dialogs and bottom sheets.
///
/// The surface is a Material page-coloured card with a centred [title], a scrolling [child], and
/// full-width [actions] stacked underneath. The title and the actions stay in place while the body
/// scrolls, so a long form or a short window never pushes the buttons out of reach. The dialog
/// insets itself by the on-screen keyboard and the safe area. A close button appears when
/// [showCloseButton] is true and [onDismiss] is set.
///
/// Present one with `showCharcoalModal` or `showCharcoalDialog`; mount it directly only for
/// previews and tests.
///
/// ```dart
/// CharcoalDialog(
///   title: 'Delete project',
///   actions: [CharcoalButton(onPressed: remove, child: const Text('Delete'))],
///   child: const Text('This cannot be undone.'),
/// )
/// ```
final class CharcoalDialog extends StatelessWidget {
  /// Creates a dialog surface around [child].
  const CharcoalDialog({
    required this.child,
    this.actions = const <Widget>[],
    this.closeIcon,
    this.closeLabel = 'Close',
    this.contentPadding = EdgeInsets.zero,
    this.maxWidth,
    this.onDismiss,
    this.showCloseButton = false,
    this.size = CharcoalDialogSize.medium,
    this.style = CharcoalModalStyle.center,
    this.title,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  /// The body, which scrolls when it is taller than the space left.
  final Widget child;

  /// Buttons stacked full-width under the body.
  final List<Widget> actions;

  /// Replaces the painted close glyph.
  final Widget? closeIcon;

  /// Semantics label of the close button.
  final String closeLabel;

  /// Padding around [child].
  final EdgeInsetsGeometry contentPadding;

  /// Overrides the width of [size].
  final double? maxWidth;

  /// Called by the close button.
  final VoidCallback? onDismiss;

  /// Whether to show the close button (needs [onDismiss]).
  final bool showCloseButton;

  /// The width class.
  final CharcoalDialogSize size;

  /// Centred card or bottom sheet.
  final CharcoalModalStyle style;

  /// A one-line centred heading; it also names the route for assistive technology.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final modal = theme.metrics.modal;
    final media = MediaQuery.of(context);
    final centered = style == CharcoalModalStyle.center;
    final resolvedMaxWidth =
        maxWidth ??
        switch (size) {
          CharcoalDialogSize.small => modal.smallWidth,
          CharcoalDialogSize.medium => modal.mediumWidth,
          CharcoalDialogSize.large => modal.largeWidth,
        };
    final bottomActionPadding = centered
        ? modal.actionPadding
        : math.max(media.padding.bottom, modal.bottomSheetMinimumBottomPadding);
    final radius = Radius.circular(modal.cornerRadius);
    final borderRadius = centered
        ? BorderRadius.all(radius)
        : BorderRadius.only(topLeft: radius, topRight: radius);
    final hasClose = showCloseButton && onDismiss != null;

    final surface = ConstrainedBox(
      constraints: BoxConstraints(minWidth: modal.minWidth, maxWidth: resolvedMaxWidth),
      child: Material(
        type: MaterialType.card,
        color: theme.colors.background,
        elevation: theme.elevation.overlay,
        shadowColor: theme.colors.shadow,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (title case final title?)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: modal.titleHorizontalPadding,
                      vertical: modal.actionPadding,
                    ),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.style(CharcoalTextRole.size20, bold: true),
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: contentPadding,
                    child: child,
                  ),
                ),
                if (actions.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      modal.actionPadding,
                      modal.actionPadding,
                      modal.actionPadding,
                      bottomActionPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        for (var index = 0; index < actions.length; index++) ...<Widget>[
                          if (index > 0) CharcoalGap.vertical(CharcoalSpace.sm),
                          actions[index],
                        ],
                      ],
                    ),
                  ),
              ],
            ),
            if (hasClose)
              _CloseButton(
                icon: closeIcon,
                label: closeLabel,
                onPressed: onDismiss!,
              ),
          ],
        ),
      ),
    );

    return Semantics(
      container: true,
      label: title,
      namesRoute: true,
      scopesRoute: true,
      explicitChildNodes: true,
      child: AnimatedPadding(
        padding: media.viewInsets,
        duration: theme.duration(context, theme.motion.fast),
        child: MediaQuery.removeViewInsets(
          context: context,
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          child: SafeArea(
            bottom: centered,
            child: Align(
              alignment: centered ? Alignment.center : Alignment.bottomCenter,
              child: Padding(
                padding: centered ? EdgeInsets.all(theme.space.xl) : EdgeInsets.zero,
                child: surface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.label, required this.onPressed, this.icon});

  final Widget? icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final modal = theme.metrics.modal;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: label,
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final color = resolveCharcoalStateColor(
          states,
          normal: theme.colors.icon,
          hovered: theme.colors.iconHover,
          pressed: theme.colors.iconPress,
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: focused
                ? <BoxShadow>[
                    BoxShadow(color: theme.colors.focusRing, spreadRadius: theme.borders.focusRing),
                  ]
                : const <BoxShadow>[],
          ),
          child: SizedBox.square(
            dimension: theme.sizes.controlLg,
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: color, size: modal.closeIconSize),
                child:
                    icon ??
                    CustomPaint(
                      painter: CharcoalCloseGlyphPainter(
                        color: color,
                        inset: modal.closeIconInset,
                        strokeWidth: modal.closeIconStrokeWidth,
                      ),
                      size: Size.square(modal.closeIconSize),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
