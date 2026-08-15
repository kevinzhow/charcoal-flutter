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

final class CharcoalLoadingSpinnerTokens {
  const CharcoalLoadingSpinnerTokens({
    required this.animationDuration,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.opacity,
    required this.padding,
    required this.radius,
    required this.size,
  });

  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  final double opacity;
  final double padding;
  final double radius;
  final double size;
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
  });

  final Duration animationDuration;
  final Color assistiveTextColor;
  final CharcoalStateColors background;
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
}

final class CharcoalComponentTokens {
  const CharcoalComponentTokens({
    required this.button,
    required this.carousel,
    required this.checkbox,
    required this.dropdown,
    required this.iconButton,
    required this.loadingSpinner,
    required this.multiSelect,
    required this.radio,
    required this.switchControl,
    required this.tagItem,
    required this.textField,
  });

  final CharcoalButtonTokens button;
  final CharcoalCarouselTokens carousel;
  final CharcoalCheckboxTokens checkbox;
  final CharcoalDropdownTokens dropdown;
  final CharcoalIconButtonTokens iconButton;
  final CharcoalLoadingSpinnerTokens loadingSpinner;
  final CharcoalMultiSelectTokens multiSelect;
  final CharcoalRadioTokens radio;
  final CharcoalSwitchTokens switchControl;
  final CharcoalTagItemTokens tagItem;
  final CharcoalTextFieldTokens textField;

  CharcoalComponentTokens copyWith({
    CharcoalButtonTokens? button,
    CharcoalCarouselTokens? carousel,
    CharcoalCheckboxTokens? checkbox,
    CharcoalDropdownTokens? dropdown,
    CharcoalIconButtonTokens? iconButton,
    CharcoalLoadingSpinnerTokens? loadingSpinner,
    CharcoalMultiSelectTokens? multiSelect,
    CharcoalRadioTokens? radio,
    CharcoalSwitchTokens? switchControl,
    CharcoalTagItemTokens? tagItem,
    CharcoalTextFieldTokens? textField,
  }) => CharcoalComponentTokens(
    button: button ?? this.button,
    carousel: carousel ?? this.carousel,
    checkbox: checkbox ?? this.checkbox,
    dropdown: dropdown ?? this.dropdown,
    iconButton: iconButton ?? this.iconButton,
    loadingSpinner: loadingSpinner ?? this.loadingSpinner,
    multiSelect: multiSelect ?? this.multiSelect,
    radio: radio ?? this.radio,
    switchControl: switchControl ?? this.switchControl,
    tagItem: tagItem ?? this.tagItem,
    textField: textField ?? this.textField,
  );
}
