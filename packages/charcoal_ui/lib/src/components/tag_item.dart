import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

enum CharcoalTagItemStatus { normal, active, inactive }

enum CharcoalTagItemSize { small, medium }

abstract final class _TagItemSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const defaultBackground = Color(0xFF7ACCB1);
  static const maxLabelWidth = 152.0;
  static const iconSize = 16.0;
  static const focusRingWidth = 4.0;
  static const translatedLabelLineHeight = 1.4;
}

/// A compact Charcoal V2 tag action with optional translated text or artwork.
///
/// [status] is controlled by the caller. The active state is exposed as
/// selected and keeps one interaction target: its trailing remove icon
/// communicates that activating the tag again can clear the selection, but is
/// not a nested action. The baseline sizes grow when accessibility text scaling
/// needs more vertical space.
final class CharcoalTagItem extends StatelessWidget {
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

  final String label;
  final VoidCallback? onPressed;
  final bool autofocus;
  final Color? backgroundColor;
  final ImageProvider<Object>? backgroundImage;
  final FocusNode? focusNode;
  final BoxFit imageFit;
  final String? semanticLabel;
  final CharcoalTagItemSize size;
  final WidgetStatesController? statesController;
  final CharcoalTagItemStatus status;
  final String? translatedLabel;

  bool get _hasTranslation => translatedLabel != null && translatedLabel!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final effectiveSize = _hasTranslation ? CharcoalTagItemSize.medium : size;
    final sizeSpec = switch (effectiveSize) {
      CharcoalTagItemSize.small => (
        height: theme.dimensions.space.targetS,
        padding: theme.dimensions.space.component30,
      ),
      CharcoalTagItemSize.medium => (
        height: theme.dimensions.space.targetM,
        padding: theme.dimensions.space.component40,
      ),
    };
    final hasImage = backgroundImage != null && status != CharcoalTagItemStatus.inactive;
    final baseBackground = backgroundColor ?? _TagItemSpec.defaultBackground;
    final horizontalPadding = status == CharcoalTagItemStatus.active
        ? (
            left: theme.dimensions.space.component30,
            right: theme.dimensions.space.component20,
          )
        : (left: sizeSpec.padding, right: sizeSpec.padding);
    final activeGap = theme.dimensions.space.component20;
    final effectiveSemanticLabel =
        semanticLabel ?? (_hasTranslation ? '${translatedLabel!}, $label' : label);

    final selected = status == CharcoalTagItemStatus.active;
    return MergeSemantics(
      child: Semantics(
        // CharcoalClickable already exposes the active state. Supply only the
        // missing explicit false state here so active does not create two
        // selected semantics boundaries.
        selected: selected ? null : false,
        child: CharcoalClickable(
          autofocus: autofocus,
          focusNode: focusNode,
          onPressed: onPressed,
          semanticLabel: effectiveSemanticLabel,
          selected: selected,
          statesController: statesController,
          builder: (context, states) {
            final disabled = states.contains(WidgetState.disabled);
            final focused = states.contains(WidgetState.focused);
            final foreground = switch (status) {
              CharcoalTagItemStatus.inactive => resolveCharcoalStateColor(
                states,
                normal: theme.colors.textSecondaryDefault,
                hovered: theme.colors.textSecondaryHover,
                pressed: theme.colors.textSecondaryPress,
              ),
              _ when hasImage => resolveCharcoalStateColor(
                states,
                normal: theme.colors.textOnOnImgDefault,
                hovered: theme.colors.textOnOnImgHover,
                pressed: theme.colors.textOnOnImgPress,
              ),
              _ => resolveCharcoalStateColor(
                states,
                normal: theme.colors.textOnPrimaryDefault,
                hovered: theme.colors.textOnPrimaryHover,
                pressed: theme.colors.textOnPrimaryPress,
              ),
            };
            final iconColor = hasImage
                ? resolveCharcoalStateColor(
                    states,
                    normal: theme.colors.iconOnOnImgDefault,
                    hovered: theme.colors.iconOnOnImgHover,
                    pressed: theme.colors.iconOnOnImgPress,
                  )
                : resolveCharcoalStateColor(
                    states,
                    normal: theme.colors.iconOnPrimaryDefault,
                    hovered: theme.colors.iconOnPrimaryHover,
                    pressed: theme.colors.iconOnPrimaryPress,
                  );
            final background = switch (status) {
              CharcoalTagItemStatus.inactive => resolveCharcoalStateColor(
                states,
                normal: theme.colors.containerSecondaryDefault,
                hovered: theme.colors.containerSecondaryHover,
                pressed: theme.colors.containerSecondaryPress,
              ),
              _ when hasImage => resolveCharcoalStateColor(
                states,
                normal: theme.colors.containerOnImgDefault,
                hovered: theme.colors.containerOnImgHover,
                pressed: theme.colors.containerOnImgPress,
              ),
              _ when states.contains(WidgetState.pressed) => Color.alphaBlend(
                theme.colors.containerPressA,
                baseBackground,
              ),
              _ when states.contains(WidgetState.hovered) => Color.alphaBlend(
                theme.colors.containerHoverA,
                baseBackground,
              ),
              _ => baseBackground,
            };
            return AnimatedOpacity(
              curve: CharcoalMotion.standardCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                _TagItemSpec.animationDuration,
              ),
              opacity: disabled ? charcoalDisabledOpacity : 1,
              child: AnimatedContainer(
                clipBehavior: Clip.antiAlias,
                duration: CharcoalMotion.resolveDuration(
                  context,
                  _TagItemSpec.animationDuration,
                ),
                curve: CharcoalMotion.standardCurve,
                constraints: BoxConstraints(minHeight: sizeSpec.height),
                padding: EdgeInsetsDirectional.only(
                  start: horizontalPadding.left,
                  end: horizontalPadding.right,
                ),
                decoration: BoxDecoration(
                  backgroundBlendMode: hasImage ? BlendMode.overlay : null,
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.s,
                  ),
                  boxShadow: focused
                      ? <BoxShadow>[
                          BoxShadow(
                            color: theme.colors.borderFocusLegacy,
                            spreadRadius: _TagItemSpec.focusRingWidth,
                          ),
                        ]
                      : const <BoxShadow>[],
                  color: background,
                  image: hasImage
                      ? DecorationImage(
                          image: backgroundImage!,
                          fit: imageFit,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _TagItemSpec.maxLabelWidth,
                        ),
                        child: _TagLabels(
                          foreground: foreground,
                          label: label,
                          translatedLabel: translatedLabel,
                        ),
                      ),
                    ),
                    if (selected) ...<Widget>[
                      SizedBox(width: activeGap),
                      CharcoalIcon(
                        CharcoalIcons.x,
                        color: iconColor,
                        size: _TagItemSpec.iconSize,
                      ),
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
  });

  final Color foreground;
  final String label;
  final String? translatedLabel;

  @override
  Widget build(BuildContext context) {
    final translation = translatedLabel;
    if (translation == null || translation.isEmpty) {
      return Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: charcoalTypographyStyle(
          context,
          color: foreground,
          size: CharcoalTypographySize.size14,
          weight: CharcoalTypographyWeight.bold,
        ),
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
          style: charcoalTypographyStyle(
            context,
            color: foreground,
            size: CharcoalTypographySize.size12,
            weight: CharcoalTypographyWeight.bold,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: charcoalTypographyStyle(
            context,
            color: foreground,
            size: CharcoalTypographySize.size10,
          ).copyWith(height: _TagItemSpec.translatedLabelLineHeight),
        ),
      ],
    );
  }
}
