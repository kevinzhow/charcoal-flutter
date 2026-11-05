import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import '../actions/control_support.dart';

/// State of a [CharcoalTagItem], controlled by the caller.
enum CharcoalTagItemStatus {
  /// A tag that can be activated.
  normal,

  /// A selected tag, with a trailing remove icon.
  active,

  /// A tag dimmed to the secondary surface.
  inactive,
}

/// Size of a [CharcoalTagItem].
enum CharcoalTagItemSize {
  /// `sizes.controlSm` high.
  small,

  /// `sizes.controlMd` high.
  medium,
}

/// A compact tag action with optional translated text or artwork.
///
/// [status] is controlled by the caller. The active state is exposed as selected and keeps one
/// interaction target: its trailing remove icon says that activating the tag again can clear the
/// selection, but is not a nested action. A translation forces the medium size; the baseline
/// sizes grow when text scaling needs more vertical space.
final class CharcoalTagItem extends StatelessWidget {
  /// Creates a tag showing [label].
  const CharcoalTagItem({
    required this.label,
    required this.onPressed,
    this.autofocus = false,
    this.backgroundColor,
    this.backgroundImage,
    this.focusNode,
    this.imageFit = BoxFit.cover,
    this.semanticLabel,
    this.size = CharcoalTagItemSize.medium,
    this.statesController,
    this.status = CharcoalTagItemStatus.normal,
    this.translatedLabel,
    super.key,
  });

  /// The tag text.
  final String label;

  /// Called on activation; null disables the tag.
  final VoidCallback? onPressed;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Fill of a normal or active tag; defaults to the theme's tag background.
  final Color? backgroundColor;

  /// Artwork behind the label of a normal or active tag.
  final ImageProvider<Object>? backgroundImage;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// How [backgroundImage] fits the tag.
  final BoxFit imageFit;

  /// Semantics label; defaults to the label (with its translation).
  final String? semanticLabel;

  /// The tag size.
  final CharcoalTagItemSize size;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  /// The tag state.
  final CharcoalTagItemStatus status;

  /// A translation shown above the label.
  final String? translatedLabel;

  bool get _hasTranslation => translatedLabel != null && translatedLabel!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.tag;
    final effectiveSize = _hasTranslation ? CharcoalTagItemSize.medium : size;
    final (height, padding) = switch (effectiveSize) {
      CharcoalTagItemSize.small => (theme.sizes.controlSm, theme.space.lg),
      CharcoalTagItemSize.medium => (theme.sizes.controlMd, theme.space.xl),
    };
    final hasImage = backgroundImage != null && status != CharcoalTagItemStatus.inactive;
    final baseBackground = backgroundColor ?? colors.tagBackground;
    final selected = status == CharcoalTagItemStatus.active;
    final startPadding = selected ? theme.space.lg : padding;
    final endPadding = selected ? theme.space.sm : padding;
    final effectiveSemanticLabel =
        semanticLabel ?? (_hasTranslation ? '${translatedLabel!}, $label' : label);

    return MergeSemantics(
      child: Semantics(
        // CharcoalClickable already exposes the active state. Supply only the missing explicit
        // false state here so active does not create two selected semantics boundaries.
        selected: selected ? null : false,
        child: CharcoalClickable(
          autofocus: autofocus,
          focusNode: focusNode,
          onPressed: onPressed,
          semanticLabel: effectiveSemanticLabel,
          selected: selected,
          statesController: statesController,
          builder: (context, states) {
            final foreground = switch (status) {
              CharcoalTagItemStatus.inactive => resolveCharcoalStateColor(
                states,
                normal: colors.textSecondary,
                hovered: colors.textSecondaryHover,
                pressed: colors.textSecondaryPress,
              ),
              _ when hasImage => colors.textOnImage,
              _ => colors.textOnPrimary,
            };
            final iconColor = hasImage ? colors.iconOnImage : colors.iconOnPrimary;
            final background = switch (status) {
              CharcoalTagItemStatus.inactive => resolveCharcoalStateColor(
                states,
                normal: colors.surfaceSecondary,
                hovered: colors.surfaceSecondaryHover,
                pressed: colors.surfaceSecondaryPress,
              ),
              _ when hasImage => resolveCharcoalStateColor(
                states,
                normal: colors.fillOnImage,
                hovered: colors.fillOnImageHover,
                pressed: colors.fillOnImagePress,
              ),
              _ when states.contains(WidgetState.pressed) => Color.alphaBlend(
                colors.pressOverlay,
                baseBackground,
              ),
              _ when states.contains(WidgetState.hovered) => Color.alphaBlend(
                colors.hoverOverlay,
                baseBackground,
              ),
              _ => baseBackground,
            };
            return CharcoalDisabledFade(
              disabled: states.contains(WidgetState.disabled),
              child: AnimatedContainer(
                clipBehavior: Clip.antiAlias,
                duration: theme.duration(context, theme.motion.standard),
                curve: theme.motion.curve,
                constraints: BoxConstraints(minHeight: height),
                padding: EdgeInsetsDirectional.only(start: startPadding, end: endPadding),
                decoration: BoxDecoration(
                  backgroundBlendMode: hasImage ? BlendMode.overlay : null,
                  borderRadius: BorderRadius.circular(theme.radius.sm),
                  boxShadow: charcoalHaloShadow(
                    theme,
                    visible: states.contains(WidgetState.focused),
                  ),
                  color: background,
                  image: hasImage ? DecorationImage(image: backgroundImage!, fit: imageFit) : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: metrics.maxLabelWidth),
                        child: _TagLabels(
                          foreground: foreground,
                          label: label,
                          translatedLabel: translatedLabel,
                          lineHeight: metrics.translatedLabelLineHeight,
                        ),
                      ),
                    ),
                    if (selected) ...<Widget>[
                      const CharcoalGap.horizontal(CharcoalSpace.sm),
                      CharcoalIcon(CharcoalIcons.x, color: iconColor, size: metrics.iconSize),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _TagLabels extends StatelessWidget {
  const _TagLabels({
    required this.foreground,
    required this.label,
    required this.translatedLabel,
    required this.lineHeight,
  });

  final Color foreground;
  final String label;
  final String? translatedLabel;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final translation = translatedLabel;
    if (translation == null || translation.isEmpty) {
      return Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.style(CharcoalTextRole.bodyBold, color: foreground),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          translation,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.style(CharcoalTextRole.size12, color: foreground, bold: true),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme
              .style(CharcoalTextRole.size10, color: foreground)
              .copyWith(height: lineHeight),
        ),
      ],
    );
  }
}
