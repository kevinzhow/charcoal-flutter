import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../contract/colors.dart';
import '../contract/typography.dart';
import '../pack.dart';
import '../theme.dart';
import 'button_style.dart';
import 'text_theme.dart';

/// Builds the Material [ThemeData] for [pack].
///
/// Every Material surface is configured from the pack, and the [ColorScheme] is assigned role by
/// role rather than derived from a seed, so nothing in an app can render a hue the pack did not
/// choose. Slots Material has no field for (tones, sizes, type roles, per-family metrics) travel
/// on the [CharcoalTheme] extension. [platform] selects the system font family for Apple targets
/// and defaults to the running platform.
ThemeData buildCharcoalThemeData(CharcoalThemePack pack, {TargetPlatform? platform}) {
  final charcoal = CharcoalTheme(pack, platform: platform ?? defaultTargetPlatform);
  final c = pack.colors;
  const clear = CharcoalColorRoles.transparent;
  final textTheme = buildCharcoalTextTheme(charcoal);
  final body = charcoal.style(CharcoalTextRole.body);
  final caption = charcoal.style(CharcoalTextRole.caption);
  final bold = charcoal.style(CharcoalTextRole.bodyBold);
  final captionBold = charcoal.style(CharcoalTextRole.captionBold);

  final scheme = ColorScheme(
    brightness: pack.brightness,
    primary: c.primary,
    onPrimary: c.textOnPrimary,
    primaryContainer: c.infoSurface,
    onPrimaryContainer: c.textInfo,
    secondary: c.textSecondary,
    onSecondary: c.background,
    secondaryContainer: c.fillSecondary,
    onSecondaryContainer: c.textSecondary,
    tertiary: c.notice,
    onTertiary: c.text,
    tertiaryContainer: c.noticeSurface,
    onTertiaryContainer: c.textNotice,
    error: c.negative,
    onError: c.textOnNegative,
    errorContainer: c.negativeSurface,
    onErrorContainer: c.textNegative,
    surface: c.background,
    onSurface: c.text,
    onSurfaceVariant: c.textSecondary,
    surfaceDim: c.backgroundTertiary,
    surfaceBright: c.background,
    surfaceContainerLowest: c.background,
    surfaceContainerLow: c.background,
    surfaceContainer: c.backgroundSecondary,
    surfaceContainerHigh: c.backgroundSecondary,
    surfaceContainerHighest: c.backgroundTertiary,
    outline: c.border,
    outlineVariant: c.borderSubtle,
    shadow: c.scrim,
    scrim: c.scrim,
    inverseSurface: c.hud,
    onInverseSurface: c.textOnHud,
    inversePrimary: c.primary,
    surfaceTint: clear,
  );

  OutlineInputBorder fieldBorder(Color color, double width) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(pack.radius.sm),
    borderSide: width == 0 ? BorderSide.none : BorderSide(color: color, width: width),
  );

  final inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: c.fillSecondary,
    isDense: false,
    constraints: BoxConstraints(minHeight: pack.sizes.fieldHeight),
    contentPadding: EdgeInsets.symmetric(
      horizontal: pack.space.md,
      vertical: pack.metrics.textField.verticalPadding,
    ),
    hintStyle: charcoal.style(CharcoalTextRole.body, color: c.textPlaceholder),
    helperStyle: caption,
    errorStyle: charcoal.style(CharcoalTextRole.caption, color: c.textNegative),
    prefixIconColor: c.iconSecondary,
    suffixIconColor: c.iconSecondary,
    border: fieldBorder(clear, 0),
    enabledBorder: fieldBorder(clear, 0),
    disabledBorder: fieldBorder(clear, 0),
    focusedBorder: fieldBorder(c.focusRing, pack.borders.focusRing),
    errorBorder: fieldBorder(c.borderNegative, pack.borders.focusRing),
    focusedErrorBorder: fieldBorder(c.borderNegative, pack.borders.focusRing),
  );

  RoundedRectangleBorder roundedShape(double radius, {BorderSide side = BorderSide.none}) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: side);
  final hairline = BorderSide(color: c.borderSubtle, width: pack.borders.hairline);

  MenuStyle menuStyle({bool outlined = true}) => MenuStyle(
    backgroundColor: WidgetStatePropertyAll(c.background),
    surfaceTintColor: const WidgetStatePropertyAll(clear),
    shadowColor: const WidgetStatePropertyAll(clear),
    elevation: WidgetStatePropertyAll(pack.elevation.overlay),
    shape: WidgetStatePropertyAll(
      roundedShape(pack.radius.md, side: outlined ? hairline : BorderSide.none),
    ),
  );

  Color? selectedFill(Set<WidgetState> states) => states.contains(WidgetState.disabled)
      ? c.surfaceDisabled
      : states.contains(WidgetState.selected)
      ? c.primary
      : null;

  return ThemeData(
    useMaterial3: true,
    brightness: pack.brightness,
    platform: charcoal.platform,
    colorScheme: scheme,
    extensions: <ThemeExtension<dynamic>>[charcoal],
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    cardColor: c.surface,
    dividerColor: c.borderSubtle,
    disabledColor: c.textDisabled,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    iconTheme: IconThemeData(color: c.icon, size: pack.sizes.iconLg),
    primaryIconTheme: IconThemeData(color: c.icon, size: pack.sizes.iconLg),
    splashFactory: NoSplash.splashFactory,
    highlightColor: clear,
    hoverColor: c.hoverOverlay,
    focusColor: clear,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.standard,
    dividerTheme: DividerThemeData(
      color: c.borderSubtle,
      thickness: pack.borders.hairline,
      space: pack.borders.hairline,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.primary,
      selectionColor: c.focusRing,
      selectionHandleColor: c.primary,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(c.border),
      trackColor: const WidgetStatePropertyAll(clear),
      trackBorderColor: const WidgetStatePropertyAll(clear),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: buildCharcoalButtonStyle(charcoal, CharcoalButtonVariant.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buildCharcoalButtonStyle(charcoal, CharcoalButtonVariant.normal),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: buildCharcoalButtonStyle(charcoal, CharcoalButtonVariant.normal),
    ),
    textButtonTheme: TextButtonThemeData(
      style: buildCharcoalButtonStyle(charcoal, CharcoalButtonVariant.normal),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(c.iconSecondary),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? c.pressOverlay
              : states.contains(WidgetState.hovered)
              ? c.hoverOverlay
              : clear,
        ),
        iconSize: WidgetStatePropertyAll(pack.sizes.iconSm),
        minimumSize: WidgetStatePropertyAll(Size.square(pack.sizes.controlSm)),
        padding: WidgetStatePropertyAll(EdgeInsets.all(pack.space.xs)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.primary : c.fillSecondary,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? c.textDisabled
              : states.contains(WidgetState.selected)
              ? c.textOnPrimary
              : c.textSecondary,
        ),
        overlayColor: const WidgetStatePropertyAll(clear),
        side: const WidgetStatePropertyAll(BorderSide.none),
        minimumSize: WidgetStatePropertyAll(Size(0, pack.sizes.controlSm)),
        textStyle: WidgetStatePropertyAll(bold),
        shape: WidgetStatePropertyAll(roundedShape(pack.radius.pill)),
      ),
    ),
    inputDecorationTheme: inputTheme,
    dialogTheme: DialogThemeData(
      backgroundColor: c.background,
      barrierColor: c.barrier,
      surfaceTintColor: clear,
      shadowColor: clear,
      elevation: pack.elevation.overlay,
      shape: roundedShape(pack.radius.lg),
      titleTextStyle: charcoal.style(CharcoalTextRole.modalTitle),
      contentTextStyle: body,
      insetPadding: EdgeInsets.symmetric(horizontal: pack.space.lg, vertical: pack.space.xl),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.background,
      modalBackgroundColor: c.background,
      modalBarrierColor: c.barrier,
      surfaceTintColor: clear,
      shadowColor: clear,
      elevation: pack.elevation.overlay,
      modalElevation: pack.elevation.overlay,
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(pack.metrics.modal.cornerRadius)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.hud,
      contentTextStyle: charcoal.style(CharcoalTextRole.body, color: c.textOnHud),
      actionTextColor: c.textOnHud,
      elevation: pack.elevation.overlay,
      behavior: SnackBarBehavior.floating,
      shape: roundedShape(pack.metrics.toast.cornerRadius),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.background,
      surfaceTintColor: clear,
      shadowColor: clear,
      elevation: pack.elevation.overlay,
      shape: roundedShape(pack.radius.md, side: hairline),
      textStyle: body,
    ),
    menuTheme: MenuThemeData(style: menuStyle()),
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? c.textDisabled : c.text,
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? c.pressOverlay
              : states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)
              ? c.hoverOverlay
              : clear,
        ),
        overlayColor: const WidgetStatePropertyAll(clear),
        textStyle: WidgetStatePropertyAll(body),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: body,
      inputDecorationTheme: inputTheme,
      menuStyle: menuStyle(),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: c.fillSecondary,
      iconColor: c.iconSecondary,
      textColor: c.text,
      titleTextStyle: bold,
      subtitleTextStyle: caption,
      contentPadding: EdgeInsets.symmetric(horizontal: pack.space.md),
      minVerticalPadding: pack.space.sm,
      minTileHeight: pack.sizes.rowMinHeight,
      shape: roundedShape(pack.radius.sm),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      surfaceTintColor: clear,
      shadowColor: clear,
      elevation: pack.elevation.surface,
      margin: EdgeInsets.zero,
      shape: roundedShape(pack.radius.md, side: hairline),
    ),
    switchTheme: SwitchThemeData(
      // Charcoal's thumb is the same light disc on and off, so the thumb colour does not depend
      // on state. A (blank) thumb icon makes Material draw the unselected thumb at full size too.
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? c.surfaceDisabled : c.iconOnPrimary,
      ),
      thumbIcon: const WidgetStatePropertyAll(Icon(null)),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? c.surfaceDisabled
            : states.contains(WidgetState.selected)
            ? c.primary
            : c.neutral,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(clear),
      overlayColor: const WidgetStatePropertyAll(clear),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(selectedFill),
      checkColor: WidgetStatePropertyAll(c.textOnPrimary),
      side: BorderSide(color: c.border, width: pack.borders.thick),
      shape: roundedShape(pack.radius.sm),
      overlayColor: const WidgetStatePropertyAll(clear),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? c.surfaceDisabled
            : states.contains(WidgetState.selected)
            ? c.primary
            : c.border,
      ),
      overlayColor: const WidgetStatePropertyAll(clear),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: c.primary,
      inactiveTrackColor: c.surfaceTertiary,
      thumbColor: c.primary,
      overlayColor: c.focusRing,
      disabledActiveTrackColor: c.surfaceDisabled,
      disabledInactiveTrackColor: c.surfaceDisabled,
      disabledThumbColor: c.surfaceDisabled,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.primary,
      linearTrackColor: c.surfaceTertiary,
      circularTrackColor: clear,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: c.hud, borderRadius: BorderRadius.circular(pack.radius.sm)),
      textStyle: charcoal.style(CharcoalTextRole.caption, color: c.textOnHud),
      waitDuration: pack.metrics.tooltip.defaultWaitDuration,
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: c.background,
      foregroundColor: c.text,
      surfaceTintColor: clear,
      shadowColor: clear,
      elevation: pack.elevation.surface,
      scrolledUnderElevation: pack.elevation.surface,
      titleTextStyle: charcoal.style(CharcoalTextRole.sectionTitle),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.background,
      surfaceTintColor: clear,
      shadowColor: clear,
      elevation: pack.elevation.surface,
      indicatorColor: c.infoSurface,
      labelTextStyle: WidgetStatePropertyAll(captionBold),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: c.background,
      elevation: pack.elevation.surface,
      indicatorColor: c.infoSurface,
      selectedLabelTextStyle: captionBold,
      unselectedLabelTextStyle: caption,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.text,
      unselectedLabelColor: c.textTertiary,
      labelStyle: captionBold,
      unselectedLabelStyle: captionBold,
      indicatorColor: c.primary,
      dividerColor: c.borderSubtle,
      overlayColor: const WidgetStatePropertyAll(clear),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: c.background,
      surfaceTintColor: clear,
      shadowColor: clear,
      scrimColor: c.barrier,
      elevation: pack.elevation.overlay,
    ),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: c.infoSurface,
      surfaceTintColor: clear,
      contentTextStyle: charcoal.style(CharcoalTextRole.body, color: c.textInfo),
    ),
    badgeTheme: BadgeThemeData(
      backgroundColor: c.negative,
      textColor: c.textOnNegative,
      textStyle: charcoal.style(CharcoalTextRole.captionBold, color: c.textOnNegative),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.surfaceSecondary,
      labelStyle: charcoal.style(CharcoalTextRole.captionBold, color: c.textSecondary),
      side: BorderSide.none,
      shape: roundedShape(pack.radius.sm),
    ),
    // iOS leading-edge drag and Android predictive back; `CharcoalPageRoute` (batch 1B) layers
    // the Charcoal transition on top of the same slots.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
