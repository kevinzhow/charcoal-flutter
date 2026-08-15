import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/component_tokens.dart';
import 'clickable.dart';

enum CharcoalTagItemStatus { normal, active, inactive }

/// A compact Charcoal V2 tag action with optional translated text or artwork.
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
    final tokens = theme.components.tagItem;
    final sizeTokens = tokens.size(_hasTranslation ? CharcoalTagItemSize.medium : size);
    final hasImage = backgroundImage != null && status != CharcoalTagItemStatus.inactive;
    final foreground = switch (status) {
      CharcoalTagItemStatus.inactive => tokens.inactiveForegroundColor,
      _ when hasImage => tokens.imageForegroundColor,
      _ => tokens.foregroundColor,
    };
    final iconColor = hasImage ? tokens.imageIconColor : tokens.iconColor;
    final background = switch (status) {
      CharcoalTagItemStatus.inactive => tokens.inactiveBackgroundColor,
      _ when hasImage => tokens.imageBackgroundColor,
      _ => backgroundColor ?? tokens.backgroundColor,
    };
    final horizontalPadding = status == CharcoalTagItemStatus.active
        ? (left: tokens.activePaddingLeft, right: tokens.activePaddingRight)
        : (left: sizeTokens.paddingHorizontal, right: sizeTokens.paddingHorizontal);
    final effectiveSemanticLabel =
        semanticLabel ?? (_hasTranslation ? '${translatedLabel!}, $label' : label);

    return CharcoalClickable(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onPressed,
      semanticLabel: effectiveSemanticLabel,
      selected: status == CharcoalTagItemStatus.active,
      statesController: statesController,
      builder: (context, states) {
        final disabled = states.contains(WidgetState.disabled);
        final focused = states.contains(WidgetState.focused);
        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: tokens.animationDuration,
          opacity: disabled ? tokens.disabledOpacity : 1,
          child: AnimatedContainer(
            clipBehavior: Clip.antiAlias,
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            height: sizeTokens.height,
            padding: EdgeInsetsDirectional.only(
              start: horizontalPadding.left,
              end: horizontalPadding.right,
            ),
            decoration: BoxDecoration(
              backgroundBlendMode: hasImage ? BlendMode.overlay : null,
              borderRadius: BorderRadius.circular(tokens.radius),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(color: tokens.focusRingColor, spreadRadius: tokens.focusRingWidth),
                    ]
                  : const <BoxShadow>[],
              color: background,
              image: hasImage ? DecorationImage(image: backgroundImage!, fit: imageFit) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: tokens.maxLabelWidth),
                  child: _TagLabels(
                    foreground: foreground,
                    label: label,
                    translatedLabel: translatedLabel,
                  ),
                ),
                if (status == CharcoalTagItemStatus.active) ...<Widget>[
                  SizedBox(width: tokens.gap),
                  CharcoalIcon(
                    CharcoalIcons.x,
                    color: iconColor,
                    size: tokens.iconSize,
                  ),
                ],
              ],
            ),
          ),
        );
      },
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
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.tagItem;
    final translation = translatedLabel;
    if (translation == null || translation.isEmpty) {
      return Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foreground,
          fontFamily: theme.typography.fontFamily.sans,
          fontSize: tokens.labelFontSize,
          fontWeight: tokens.labelFontWeight,
          height: tokens.labelLineHeight / tokens.labelFontSize,
          leadingDistribution: TextLeadingDistribution.even,
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
          style: TextStyle(
            color: foreground,
            fontFamily: theme.typography.fontFamily.sans,
            fontSize: tokens.translatedFontSize,
            fontWeight: tokens.translatedFontWeight,
            height: tokens.translatedLineHeight / tokens.translatedFontSize,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: foreground,
            fontFamily: theme.typography.fontFamily.sans,
            fontSize: tokens.translatedLabelFontSize,
            fontWeight: tokens.translatedLabelFontWeight,
            height: tokens.translatedLabelLineHeight / tokens.translatedLabelFontSize,
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
      ],
    );
  }
}
