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
    final foreground = switch (status) {
      CharcoalTagItemStatus.inactive => theme.colors.textSecondaryDefault,
      _ when hasImage => theme.colors.textOnOnImgDefault,
      _ => theme.colors.textOnPrimaryDefault,
    };
    final iconColor = hasImage
        ? theme.colors.iconOnOnImgDefault
        : theme.colors.iconOnPrimaryDefault;
    final background = switch (status) {
      CharcoalTagItemStatus.inactive => theme.colors.containerSecondaryDefault,
      _ when hasImage => theme.colors.containerOnImgDefault,
      _ => backgroundColor ?? _TagItemSpec.defaultBackground,
    };
    final horizontalPadding = status == CharcoalTagItemStatus.active
        ? (
            left: theme.dimensions.space.component30,
            right: theme.dimensions.space.component20,
          )
        : (left: sizeSpec.padding, right: sizeSpec.padding);
    final activeGap = theme.dimensions.space.component20;
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
            height: sizeSpec.height,
            padding: EdgeInsetsDirectional.only(
              start: horizontalPadding.left,
              end: horizontalPadding.right,
            ),
            decoration: BoxDecoration(
              backgroundBlendMode: hasImage ? BlendMode.overlay : null,
              borderRadius: BorderRadius.circular(theme.dimensions.radius.s),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: theme.colors.borderFocusLegacy,
                        spreadRadius: _TagItemSpec.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
              image: hasImage ? DecorationImage(image: backgroundImage!, fit: imageFit) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _TagItemSpec.maxLabelWidth,
                  ),
                  child: _TagLabels(
                    foreground: foreground,
                    label: label,
                    translatedLabel: translatedLabel,
                  ),
                ),
                if (status == CharcoalTagItemStatus.active) ...<Widget>[
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
