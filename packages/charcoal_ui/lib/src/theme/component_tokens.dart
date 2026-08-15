import 'package:flutter/widgets.dart';

/// A color value that resolves against interaction states from the Widgets layer.
final class CharcoalStateColors implements WidgetStateProperty<Color> {
  const CharcoalStateColors({
    required this.normal,
    required this.hovered,
    required this.pressed,
    required this.disabled,
    this.focused,
    this.selected,
  });

  final Color normal;
  final Color hovered;
  final Color pressed;
  final Color disabled;
  final Color? focused;
  final Color? selected;

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabled;
    }
    if (states.contains(WidgetState.pressed)) {
      return pressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return hovered;
    }
    if (states.contains(WidgetState.focused) && focused != null) {
      return focused!;
    }
    if (states.contains(WidgetState.selected) && selected != null) {
      return selected!;
    }
    return normal;
  }
}

/// Generated recipe for the iOS-compatible balloon surface and presentation.
final class CharcoalBalloonTokens {
  const CharcoalBalloonTokens({
    required this.actionBackgroundColor,
    required this.actionPaddingHorizontal,
    required this.actionPaddingVertical,
    required this.animationDuration,
    required this.arrowHalfWidth,
    required this.arrowHeight,
    required this.backgroundColor,
    required this.closeIconSize,
    required this.closeSize,
    required this.closeStrokeInset,
    required this.closeStrokeWidth,
    required this.contentGap,
    required this.fontSize,
    required this.fontWeight,
    required this.foregroundColor,
    required this.gap,
    required this.lineHeight,
    required this.maxWidth,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.radius,
    required this.screenInset,
    required this.strokeColor,
    required this.strokeWidth,
  });

  final Color actionBackgroundColor;
  final double actionPaddingHorizontal;
  final double actionPaddingVertical;
  final Duration animationDuration;
  final double arrowHalfWidth;
  final double arrowHeight;
  final Color backgroundColor;
  final double closeIconSize;
  final double closeSize;
  final double closeStrokeInset;
  final double closeStrokeWidth;
  final double contentGap;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foregroundColor;
  final double gap;
  final double lineHeight;
  final double maxWidth;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radius;
  final double screenInset;
  final Color strokeColor;
  final double strokeWidth;
}

enum CharcoalButtonVariant { normal, primary, overlay, danger, navigation }

enum CharcoalButtonSize { small, medium }

enum CharcoalIconButtonVariant { normal, overlay }

enum CharcoalIconButtonSize { extraSmall, small, medium }

final class CharcoalButtonSizeTokens {
  const CharcoalButtonSizeTokens({
    required this.gap,
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
    required this.paddingHorizontal,
    required this.radius,
  });

  final double gap;
  final double height;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final double lineHeight;
  final double paddingHorizontal;
  final double radius;
}

final class CharcoalButtonVariantTokens {
  const CharcoalButtonVariantTokens({required this.background, required this.foreground});

  final CharcoalStateColors background;
  final CharcoalStateColors foreground;
}

final class CharcoalButtonTokens {
  const CharcoalButtonTokens({
    required this.animationDuration,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.small,
    required this.medium,
    required this.normal,
    required this.primary,
    required this.overlay,
    required this.danger,
    required this.navigation,
  });

  final Duration animationDuration;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final CharcoalButtonSizeTokens small;
  final CharcoalButtonSizeTokens medium;
  final CharcoalButtonVariantTokens normal;
  final CharcoalButtonVariantTokens primary;
  final CharcoalButtonVariantTokens overlay;
  final CharcoalButtonVariantTokens danger;
  final CharcoalButtonVariantTokens navigation;

  CharcoalButtonSizeTokens size(CharcoalButtonSize value) => switch (value) {
    CharcoalButtonSize.small => small,
    CharcoalButtonSize.medium => medium,
  };

  CharcoalButtonVariantTokens variant(CharcoalButtonVariant value) => switch (value) {
    CharcoalButtonVariant.normal => normal,
    CharcoalButtonVariant.primary => primary,
    CharcoalButtonVariant.overlay => overlay,
    CharcoalButtonVariant.danger => danger,
    CharcoalButtonVariant.navigation => navigation,
  };
}

final class CharcoalCarouselTokens {
  const CharcoalCarouselTokens({
    required this.animationDuration,
    required this.defaultGap,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.indicatorActiveColor,
    required this.indicatorColor,
    required this.indicatorGap,
    required this.indicatorHeight,
    required this.indicatorRadius,
    required this.indicatorSize,
    required this.mediumViewportFraction,
    required this.navigationInset,
    required this.scrollDuration,
  });

  final Duration animationDuration;
  final double defaultGap;
  final Color focusRingColor;
  final double focusRingWidth;
  final Color indicatorActiveColor;
  final CharcoalStateColors indicatorColor;
  final double indicatorGap;
  final double indicatorHeight;
  final double indicatorRadius;
  final double indicatorSize;
  final double mediumViewportFraction;
  final double navigationInset;
  final Duration scrollDuration;
}

final class CharcoalControlLabelTokens {
  const CharcoalControlLabelTokens({
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    required this.gap,
    required this.lineHeight,
  });

  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double gap;
  final double lineHeight;
}

final class CharcoalCheckboxTokens {
  const CharcoalCheckboxTokens({
    required this.animationDuration,
    required this.borderColor,
    required this.borderWidth,
    required this.checkedBackground,
    required this.checkColor,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.invalidRingColor,
    required this.label,
    required this.radius,
    required this.roundedRadius,
    required this.size,
    required this.uncheckedBackground,
  });

  final Duration animationDuration;
  final CharcoalStateColors borderColor;
  final double borderWidth;
  final CharcoalStateColors checkedBackground;
  final CharcoalStateColors checkColor;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final Color invalidRingColor;
  final CharcoalControlLabelTokens label;
  final double radius;
  final double roundedRadius;
  final double size;
  final CharcoalStateColors uncheckedBackground;
}

/// Generated visual recipe for `CharcoalDropdown`.
///
/// This type intentionally contains only values resolved from
/// `tokens/components.json`. Keeping the values separate from widget logic
/// lets a token regeneration update the component without source edits.
final class CharcoalDropdownTokens {
  const CharcoalDropdownTokens({
    required this.animationDuration,
    required this.assistiveTextColor,
    required this.background,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.fontSize,
    required this.fontWeight,
    required this.foregroundColor,
    required this.gap,
    required this.height,
    required this.iconColor,
    required this.iconSize,
    required this.iconStrokeWidth,
    required this.invalidAssistiveTextColor,
    required this.invalidRingColor,
    required this.lineHeight,
    required this.menuBackgroundColor,
    required this.menuBorderColor,
    required this.menuBorderWidth,
    required this.menuGap,
    required this.menuMaxHeight,
    required this.menuPaddingVertical,
    required this.menuRadius,
    required this.optionBackground,
    required this.optionCheckColor,
    required this.optionCheckWidth,
    required this.optionDisabledOpacity,
    required this.optionGap,
    required this.optionMinHeight,
    required this.optionPaddingHorizontal,
    required this.optionPrimaryColor,
    required this.optionSecondaryColor,
    required this.optionSecondaryFontSize,
    required this.optionSecondaryLineHeight,
    required this.paddingHorizontal,
    required this.placeholderColor,
    required this.radius,
  });

  final Duration animationDuration;
  final Color assistiveTextColor;
  final CharcoalStateColors background;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foregroundColor;
  final double gap;
  final double height;
  final Color iconColor;
  final double iconSize;
  final double iconStrokeWidth;
  final Color invalidAssistiveTextColor;
  final Color invalidRingColor;
  final double lineHeight;
  final Color menuBackgroundColor;
  final Color menuBorderColor;
  final double menuBorderWidth;
  final double menuGap;
  final double menuMaxHeight;
  final double menuPaddingVertical;
  final double menuRadius;
  final CharcoalStateColors optionBackground;
  final Color optionCheckColor;
  final double optionCheckWidth;
  final double optionDisabledOpacity;
  final double optionGap;
  final double optionMinHeight;
  final double optionPaddingHorizontal;
  final Color optionPrimaryColor;
  final Color optionSecondaryColor;
  final double optionSecondaryFontSize;
  final double optionSecondaryLineHeight;
  final double paddingHorizontal;
  final Color placeholderColor;
  final double radius;
}

final class CharcoalIconButtonSizeTokens {
  const CharcoalIconButtonSizeTokens({required this.iconSize, required this.size});

  final double iconSize;
  final double size;
}

final class CharcoalIconButtonVariantTokens {
  const CharcoalIconButtonVariantTokens({required this.background, required this.foreground});

  final CharcoalStateColors background;
  final CharcoalStateColors foreground;
}

final class CharcoalIconButtonTokens {
  const CharcoalIconButtonTokens({
    required this.animationDuration,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.radius,
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.normal,
    required this.overlay,
  });

  final Duration animationDuration;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final double radius;
  final CharcoalIconButtonSizeTokens extraSmall;
  final CharcoalIconButtonSizeTokens small;
  final CharcoalIconButtonSizeTokens medium;
  final CharcoalIconButtonVariantTokens normal;
  final CharcoalIconButtonVariantTokens overlay;

  CharcoalIconButtonSizeTokens size(CharcoalIconButtonSize value) => switch (value) {
    CharcoalIconButtonSize.extraSmall => extraSmall,
    CharcoalIconButtonSize.small => small,
    CharcoalIconButtonSize.medium => medium,
  };

  CharcoalIconButtonVariantTokens variant(CharcoalIconButtonVariant value) => switch (value) {
    CharcoalIconButtonVariant.normal => normal,
    CharcoalIconButtonVariant.overlay => overlay,
  };
}

final class CharcoalHintTokens {
  const CharcoalHintTokens({
    required this.actionGap,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontWeight,
    required this.foregroundColor,
    required this.gap,
    required this.iconColor,
    required this.iconSize,
    required this.lineHeight,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.radius,
  });

  final double actionGap;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foregroundColor;
  final double gap;
  final Color iconColor;
  final double iconSize;
  final double lineHeight;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radius;
}

final class CharcoalLinkButtonTokens {
  const CharcoalLinkButtonTokens({
    required this.animationDuration,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.fontSize,
    required this.fontWeight,
    required this.foreground,
    required this.height,
    required this.lineHeight,
    required this.paddingHorizontal,
    required this.radius,
  });

  final Duration animationDuration;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final double fontSize;
  final FontWeight fontWeight;
  final CharcoalStateColors foreground;
  final double height;
  final double lineHeight;
  final double paddingHorizontal;
  final double radius;
}

final class CharcoalLoadingSpinnerTokens {
  const CharcoalLoadingSpinnerTokens({
    required this.animationDuration,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.opacity,
    required this.padding,
    required this.radius,
    required this.shadowBlur,
    required this.shadowOpacity,
    required this.size,
  });

  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  final double opacity;
  final double padding;
  final double radius;
  final double shadowBlur;
  final double shadowOpacity;
  final double size;
}

final class CharcoalModalTokens {
  const CharcoalModalTokens({
    required this.actionGap,
    required this.actionPadding,
    required this.animationDuration,
    required this.backgroundColor,
    required this.barrierColor,
    required this.barrierOpacity,
    required this.bottomSheetMinBottomPadding,
    required this.centerEdgePadding,
    required this.centerScale,
    required this.closeIconSize,
    required this.closeSize,
    required this.closeStrokeInset,
    required this.closeStrokeWidth,
    required this.defaultMaxWidth,
    required this.minWidth,
    required this.radius,
    required this.titleFontSize,
    required this.titleFontWeight,
    required this.titleLineHeight,
    required this.titlePaddingHorizontal,
    required this.titlePaddingVertical,
  });

  final double actionGap;
  final double actionPadding;
  final Duration animationDuration;
  final Color backgroundColor;
  final Color barrierColor;
  final double barrierOpacity;
  final double bottomSheetMinBottomPadding;
  final double centerEdgePadding;
  final double centerScale;
  final double closeIconSize;
  final double closeSize;
  final double closeStrokeInset;
  final double closeStrokeWidth;
  final double defaultMaxWidth;
  final double minWidth;
  final double radius;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final double titleLineHeight;
  final double titlePaddingHorizontal;
  final double titlePaddingVertical;
}

final class CharcoalMultiSelectTokens {
  const CharcoalMultiSelectTokens({
    required this.animationDuration,
    required this.checkedBackground,
    required this.checkColor,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.invalidRingColor,
    required this.label,
    required this.overlayBorderColor,
    required this.overlayBorderWidth,
    required this.overlayUncheckedBackground,
    required this.radius,
    required this.size,
    required this.uncheckedBackground,
  });

  final Duration animationDuration;
  final CharcoalStateColors checkedBackground;
  final CharcoalStateColors checkColor;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final Color invalidRingColor;
  final CharcoalControlLabelTokens label;
  final Color overlayBorderColor;
  final double overlayBorderWidth;
  final CharcoalStateColors overlayUncheckedBackground;
  final double radius;
  final double size;
  final CharcoalStateColors uncheckedBackground;
}

final class CharcoalNumericTypographySizeTokens {
  const CharcoalNumericTypographySizeTokens({
    required this.fontSize,
    required this.lineHeight,
  });

  final double fontSize;
  final double lineHeight;
}

final class CharcoalNumericTypographyTokens {
  const CharcoalNumericTypographyTokens({
    required this.boldFontWeight,
    required this.regularFontWeight,
    required this.size10,
    required this.size12,
    required this.size14,
    required this.size16,
    required this.size20,
  });

  final FontWeight boldFontWeight;
  final FontWeight regularFontWeight;
  final CharcoalNumericTypographySizeTokens size10;
  final CharcoalNumericTypographySizeTokens size12;
  final CharcoalNumericTypographySizeTokens size14;
  final CharcoalNumericTypographySizeTokens size16;
  final CharcoalNumericTypographySizeTokens size20;
}

final class CharcoalRadioTokens {
  const CharcoalRadioTokens({
    required this.animationDuration,
    required this.borderColor,
    required this.borderWidth,
    required this.checkedBackground,
    required this.disabledOpacity,
    required this.dotColor,
    required this.dotSize,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.invalidRingColor,
    required this.label,
    required this.radius,
    required this.size,
    required this.uncheckedBackground,
  });

  final Duration animationDuration;
  final CharcoalStateColors borderColor;
  final double borderWidth;
  final CharcoalStateColors checkedBackground;
  final double disabledOpacity;
  final CharcoalStateColors dotColor;
  final double dotSize;
  final Color focusRingColor;
  final double focusRingWidth;
  final Color invalidRingColor;
  final CharcoalControlLabelTokens label;
  final double radius;
  final double size;
  final CharcoalStateColors uncheckedBackground;
}

final class CharcoalSnackbarTokens {
  const CharcoalSnackbarTokens({
    required this.animationDuration,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.contentGap,
    required this.dismissDuration,
    required this.fontSize,
    required this.fontWeight,
    required this.foregroundColor,
    required this.maxWidth,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.radius,
    required this.screenEdgeSpacing,
    required this.screenHorizontalInset,
    required this.thumbnailSize,
  });

  final Duration animationDuration;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double contentGap;
  final Duration dismissDuration;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foregroundColor;
  final double maxWidth;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radius;
  final double screenEdgeSpacing;
  final double screenHorizontalInset;
  final double thumbnailSize;
}

final class CharcoalSwitchTokens {
  const CharcoalSwitchTokens({
    required this.animationDuration,
    required this.borderWidth,
    required this.checkedBackground,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.height,
    required this.label,
    required this.radius,
    required this.thumbColor,
    required this.thumbSize,
    required this.uncheckedBackground,
    required this.width,
  });

  final Duration animationDuration;
  final double borderWidth;
  final CharcoalStateColors checkedBackground;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final double height;
  final CharcoalControlLabelTokens label;
  final double radius;
  final CharcoalStateColors thumbColor;
  final double thumbSize;
  final CharcoalStateColors uncheckedBackground;
  final double width;
}

enum CharcoalTagItemSize { small, medium }

final class CharcoalTagItemSizeTokens {
  const CharcoalTagItemSizeTokens({required this.height, required this.paddingHorizontal});

  final double height;
  final double paddingHorizontal;
}

final class CharcoalTagItemTokens {
  const CharcoalTagItemTokens({
    required this.activePaddingLeft,
    required this.activePaddingRight,
    required this.animationDuration,
    required this.backgroundColor,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.foregroundColor,
    required this.gap,
    required this.iconColor,
    required this.iconSize,
    required this.iconStrokeWidth,
    required this.imageBackgroundColor,
    required this.imageForegroundColor,
    required this.imageIconColor,
    required this.inactiveBackgroundColor,
    required this.inactiveForegroundColor,
    required this.labelFontSize,
    required this.labelFontWeight,
    required this.labelLineHeight,
    required this.maxLabelWidth,
    required this.radius,
    required this.small,
    required this.medium,
    required this.translatedFontSize,
    required this.translatedFontWeight,
    required this.translatedLabelFontSize,
    required this.translatedLabelFontWeight,
    required this.translatedLabelLineHeight,
    required this.translatedLineHeight,
  });

  final double activePaddingLeft;
  final double activePaddingRight;
  final Duration animationDuration;
  final Color backgroundColor;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final Color foregroundColor;
  final double gap;
  final Color iconColor;
  final double iconSize;
  final double iconStrokeWidth;
  final Color imageBackgroundColor;
  final Color imageForegroundColor;
  final Color imageIconColor;
  final Color inactiveBackgroundColor;
  final Color inactiveForegroundColor;
  final double labelFontSize;
  final FontWeight labelFontWeight;
  final double labelLineHeight;
  final double maxLabelWidth;
  final double radius;
  final CharcoalTagItemSizeTokens small;
  final CharcoalTagItemSizeTokens medium;
  final double translatedFontSize;
  final FontWeight translatedFontWeight;
  final double translatedLabelFontSize;
  final FontWeight translatedLabelFontWeight;
  final double translatedLabelLineHeight;
  final double translatedLineHeight;

  CharcoalTagItemSizeTokens size(CharcoalTagItemSize value) => switch (value) {
    CharcoalTagItemSize.small => small,
    CharcoalTagItemSize.medium => medium,
  };
}

final class CharcoalTextFieldTokens {
  const CharcoalTextFieldTokens({
    required this.animationDuration,
    required this.assistiveTextColor,
    required this.background,
    required this.contentGap,
    required this.counterColor,
    required this.disabledOpacity,
    required this.focusRingColor,
    required this.focusRingWidth,
    required this.fontSize,
    required this.fontWeight,
    required this.foregroundColor,
    required this.gap,
    required this.height,
    required this.invalidAssistiveTextColor,
    required this.invalidRingColor,
    required this.lineHeight,
    required this.paddingHorizontal,
    required this.placeholderColor,
    required this.radius,
    required this.verticalGap,
  });

  final Duration animationDuration;
  final Color assistiveTextColor;
  final CharcoalStateColors background;
  final double contentGap;
  final Color counterColor;
  final double disabledOpacity;
  final Color focusRingColor;
  final double focusRingWidth;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foregroundColor;
  final double gap;
  final double height;
  final Color invalidAssistiveTextColor;
  final Color invalidRingColor;
  final double lineHeight;
  final double paddingHorizontal;
  final Color placeholderColor;
  final double radius;
  final double verticalGap;
}

final class CharcoalToastTokens {
  const CharcoalToastTokens({
    required this.animationDuration,
    required this.borderColor,
    required this.borderWidth,
    required this.dismissDuration,
    required this.errorBackgroundColor,
    required this.errorForegroundColor,
    required this.fontSize,
    required this.fontWeight,
    required this.gap,
    required this.maxWidth,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.radius,
    required this.screenEdgeSpacing,
    required this.screenHorizontalInset,
    required this.successBackgroundColor,
    required this.successForegroundColor,
  });

  final Duration animationDuration;
  final Color borderColor;
  final double borderWidth;
  final Duration dismissDuration;
  final Color errorBackgroundColor;
  final Color errorForegroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double gap;
  final double maxWidth;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radius;
  final double screenEdgeSpacing;
  final double screenHorizontalInset;
  final Color successBackgroundColor;
  final Color successForegroundColor;
}

final class CharcoalTooltipTokens {
  const CharcoalTooltipTokens({
    required this.animationDuration,
    required this.arrowHalfWidth,
    required this.arrowHeight,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontWeight,
    required this.foregroundColor,
    required this.gap,
    required this.lineHeight,
    required this.maxWidth,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.radius,
    required this.screenInset,
  });

  final Duration animationDuration;
  final double arrowHalfWidth;
  final double arrowHeight;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foregroundColor;
  final double gap;
  final double lineHeight;
  final double maxWidth;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radius;
  final double screenInset;
}

final class CharcoalComponentTokens {
  const CharcoalComponentTokens({
    required this.balloon,
    required this.button,
    required this.carousel,
    required this.checkbox,
    required this.dropdown,
    required this.hint,
    required this.iconButton,
    required this.linkButton,
    required this.loadingSpinner,
    required this.modal,
    required this.multiSelect,
    required this.numericTypography,
    required this.radio,
    required this.snackbar,
    required this.switchControl,
    required this.tagItem,
    required this.textField,
    required this.toast,
    required this.tooltip,
  });

  final CharcoalBalloonTokens balloon;
  final CharcoalButtonTokens button;
  final CharcoalCarouselTokens carousel;
  final CharcoalCheckboxTokens checkbox;
  final CharcoalDropdownTokens dropdown;
  final CharcoalHintTokens hint;
  final CharcoalIconButtonTokens iconButton;
  final CharcoalLinkButtonTokens linkButton;
  final CharcoalLoadingSpinnerTokens loadingSpinner;
  final CharcoalModalTokens modal;
  final CharcoalMultiSelectTokens multiSelect;
  final CharcoalNumericTypographyTokens numericTypography;
  final CharcoalRadioTokens radio;
  final CharcoalSnackbarTokens snackbar;
  final CharcoalSwitchTokens switchControl;
  final CharcoalTagItemTokens tagItem;
  final CharcoalTextFieldTokens textField;
  final CharcoalToastTokens toast;
  final CharcoalTooltipTokens tooltip;

  CharcoalComponentTokens copyWith({
    CharcoalBalloonTokens? balloon,
    CharcoalButtonTokens? button,
    CharcoalCarouselTokens? carousel,
    CharcoalCheckboxTokens? checkbox,
    CharcoalDropdownTokens? dropdown,
    CharcoalHintTokens? hint,
    CharcoalIconButtonTokens? iconButton,
    CharcoalLinkButtonTokens? linkButton,
    CharcoalLoadingSpinnerTokens? loadingSpinner,
    CharcoalModalTokens? modal,
    CharcoalMultiSelectTokens? multiSelect,
    CharcoalNumericTypographyTokens? numericTypography,
    CharcoalRadioTokens? radio,
    CharcoalSnackbarTokens? snackbar,
    CharcoalSwitchTokens? switchControl,
    CharcoalTagItemTokens? tagItem,
    CharcoalTextFieldTokens? textField,
    CharcoalToastTokens? toast,
    CharcoalTooltipTokens? tooltip,
  }) => CharcoalComponentTokens(
    balloon: balloon ?? this.balloon,
    button: button ?? this.button,
    carousel: carousel ?? this.carousel,
    checkbox: checkbox ?? this.checkbox,
    dropdown: dropdown ?? this.dropdown,
    hint: hint ?? this.hint,
    iconButton: iconButton ?? this.iconButton,
    linkButton: linkButton ?? this.linkButton,
    loadingSpinner: loadingSpinner ?? this.loadingSpinner,
    modal: modal ?? this.modal,
    multiSelect: multiSelect ?? this.multiSelect,
    numericTypography: numericTypography ?? this.numericTypography,
    radio: radio ?? this.radio,
    snackbar: snackbar ?? this.snackbar,
    switchControl: switchControl ?? this.switchControl,
    tagItem: tagItem ?? this.tagItem,
    textField: textField ?? this.textField,
    toast: toast ?? this.toast,
    tooltip: tooltip ?? this.tooltip,
  );
}
