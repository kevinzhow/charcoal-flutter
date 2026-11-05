import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:charcoal_theme/testing.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final packs = <String, CharcoalThemePack>{'light': charcoalLightPack, 'dark': charcoalDarkPack};

  for (final entry in packs.entries) {
    group('buildCharcoalThemeData (${entry.key})', () {
      final pack = entry.value;
      final theme = buildCharcoalThemeData(pack, platform: TargetPlatform.android);
      final c = pack.colors;

      test('injects the pack as a ThemeExtension', () {
        expect(theme.extension<CharcoalTheme>()!.pack, same(pack));
        expect(theme.brightness, pack.brightness);
        expect(theme.colorScheme.brightness, pack.brightness);
        expect(theme.useMaterial3, isTrue);
      });

      test('assigns the colour scheme role by role (no seed)', () {
        final scheme = theme.colorScheme;
        expect(scheme.primary, c.primary);
        expect(scheme.onPrimary, c.textOnPrimary);
        expect(scheme.primaryContainer, c.infoSurface);
        expect(scheme.onPrimaryContainer, c.textInfo);
        expect(scheme.secondary, c.textSecondary);
        expect(scheme.onSecondary, c.background);
        expect(scheme.secondaryContainer, c.fillSecondary);
        expect(scheme.tertiary, c.notice);
        expect(scheme.tertiaryContainer, c.noticeSurface);
        expect(scheme.error, c.negative);
        expect(scheme.onError, c.textOnNegative);
        expect(scheme.errorContainer, c.negativeSurface);
        expect(scheme.onErrorContainer, c.textNegative);
        expect(scheme.surface, c.background);
        expect(scheme.onSurface, c.text);
        expect(scheme.onSurfaceVariant, c.textSecondary);
        expect(scheme.surfaceContainer, c.backgroundSecondary);
        expect(scheme.surfaceContainerHighest, c.backgroundTertiary);
        expect(scheme.outline, c.border);
        expect(scheme.outlineVariant, c.borderSubtle);
        expect(scheme.scrim, c.scrim);
        expect(scheme.inverseSurface, c.hud);
        expect(scheme.onInverseSurface, c.textOnHud);
        expect(scheme.surfaceTint, CharcoalColorRoles.transparent);
      });

      test('every colour in the scheme is a pack role (or transparent)', () {
        final allowed = <Color>{...c.toMap().values.cast<Color>(), CharcoalColorRoles.transparent};
        final scheme = theme.colorScheme;
        final colours = <String, Color>{
          'primary': scheme.primary,
          'onPrimary': scheme.onPrimary,
          'primaryContainer': scheme.primaryContainer,
          'onPrimaryContainer': scheme.onPrimaryContainer,
          'primaryFixed': scheme.primaryFixed,
          'secondary': scheme.secondary,
          'onSecondary': scheme.onSecondary,
          'secondaryContainer': scheme.secondaryContainer,
          'tertiary': scheme.tertiary,
          'tertiaryContainer': scheme.tertiaryContainer,
          'error': scheme.error,
          'errorContainer': scheme.errorContainer,
          'surface': scheme.surface,
          'onSurface': scheme.onSurface,
          'surfaceDim': scheme.surfaceDim,
          'surfaceBright': scheme.surfaceBright,
          'surfaceContainerLowest': scheme.surfaceContainerLowest,
          'surfaceContainerLow': scheme.surfaceContainerLow,
          'surfaceContainer': scheme.surfaceContainer,
          'surfaceContainerHigh': scheme.surfaceContainerHigh,
          'surfaceContainerHighest': scheme.surfaceContainerHighest,
          'onSurfaceVariant': scheme.onSurfaceVariant,
          'outline': scheme.outline,
          'outlineVariant': scheme.outlineVariant,
          'shadow': scheme.shadow,
          'scrim': scheme.scrim,
          'inverseSurface': scheme.inverseSurface,
          'onInverseSurface': scheme.onInverseSurface,
          'inversePrimary': scheme.inversePrimary,
          'surfaceTint': scheme.surfaceTint,
        };
        // `*Fixed` roles are not assigned by Charcoal; Material derives them, so they stay out.
        colours.remove('primaryFixed');
        for (final role in colours.entries) {
          expect(allowed, contains(role.value), reason: 'scheme.${role.key}');
        }
      });

      test('themes the Material components Charcoal uses', () {
        expect(theme.filledButtonTheme.style, isNotNull);
        expect(theme.elevatedButtonTheme.style, isNotNull);
        expect(theme.outlinedButtonTheme.style, isNotNull);
        expect(theme.textButtonTheme.style, isNotNull);
        expect(theme.iconButtonTheme.style, isNotNull);
        expect(theme.segmentedButtonTheme.style, isNotNull);
        expect(theme.inputDecorationTheme.fillColor, c.fillSecondary);
        expect(theme.dialogTheme.backgroundColor, c.background);
        expect(theme.dialogTheme.barrierColor, c.barrier);
        expect(theme.bottomSheetTheme.modalBarrierColor, c.barrier);
        expect(theme.snackBarTheme.backgroundColor, c.hud);
        expect(theme.popupMenuTheme.color, c.background);
        expect(theme.menuTheme.style, isNotNull);
        expect(theme.menuButtonTheme.style, isNotNull);
        expect(theme.dropdownMenuTheme.menuStyle, isNotNull);
        expect(theme.listTileTheme.tileColor, c.fillSecondary);
        expect(theme.cardTheme.color, c.surface);
        expect(theme.switchTheme.trackColor, isNotNull);
        expect(theme.checkboxTheme.fillColor, isNotNull);
        expect(theme.radioTheme.fillColor, isNotNull);
        expect(theme.sliderTheme.activeTrackColor, c.primary);
        expect(theme.progressIndicatorTheme.color, c.primary);
        expect(theme.tooltipTheme.decoration, isNotNull);
        expect(theme.appBarTheme.backgroundColor, c.background);
        expect(theme.navigationBarTheme.backgroundColor, c.background);
        expect(theme.navigationRailTheme.backgroundColor, c.background);
        expect(theme.tabBarTheme.indicatorColor, c.primary);
        expect(theme.drawerTheme.scrimColor, c.barrier);
        expect(theme.bannerTheme.backgroundColor, c.infoSurface);
        expect(theme.badgeTheme.backgroundColor, c.negative);
        expect(theme.chipTheme.backgroundColor, c.surfaceSecondary);
        expect(theme.dividerTheme.color, c.borderSubtle);
        expect(theme.scrollbarTheme.thumbColor, isNotNull);
        expect(theme.textSelectionTheme.cursorColor, c.primary);
      });

      test('no ink splash, tint or implicit shadow', () {
        expect(theme.splashFactory, same(NoSplash.splashFactory));
        expect(theme.cardTheme.surfaceTintColor, CharcoalColorRoles.transparent);
        expect(theme.dialogTheme.surfaceTintColor, CharcoalColorRoles.transparent);
        expect(theme.appBarTheme.surfaceTintColor, CharcoalColorRoles.transparent);
      });

      test('geometry follows the pack', () {
        expect(theme.dialogTheme.elevation, pack.elevation.overlay);
        expect(theme.iconTheme.size, pack.sizes.iconLg);
        expect(theme.inputDecorationTheme.constraints!.minHeight, pack.sizes.fieldHeight);
        expect(theme.dividerTheme.thickness, pack.borders.hairline);
        final dialogShape = theme.dialogTheme.shape! as RoundedRectangleBorder;
        expect(dialogShape.borderRadius, BorderRadius.circular(pack.radius.lg));
        final focused = theme.inputDecorationTheme.focusedBorder! as OutlineInputBorder;
        expect(focused.borderSide.width, pack.borders.focusRing);
        expect(focused.borderSide.color, c.focusRing);
      });

      test('the button style resolves colours per state', () {
        final style = theme.filledButtonTheme.style!;
        Color? background(Set<WidgetState> s) => style.backgroundColor!.resolve(s);
        expect(background({}), c.primary);
        expect(background({WidgetState.hovered}), c.primaryHover);
        expect(background({WidgetState.pressed}), c.primaryPress);
        expect(background({WidgetState.disabled}), c.surfaceDisabled);
        expect(style.foregroundColor!.resolve({}), c.textOnPrimary);
        expect(style.foregroundColor!.resolve({WidgetState.disabled}), c.textDisabled);
        expect(style.minimumSize!.resolve({}), Size(0, pack.sizes.controlMd));
        expect(style.iconSize!.resolve({}), pack.metrics.button.iconSize);
        final normal = theme.elevatedButtonTheme.style!;
        expect(normal.backgroundColor!.resolve({}), c.fillSecondary);
        expect(normal.backgroundColor!.resolve({WidgetState.hovered}), c.fillSecondaryHover);
      });

      test('button variants and sizes', () {
        final charcoal = CharcoalTheme(pack);
        final danger = buildCharcoalButtonStyle(charcoal, CharcoalButtonVariant.danger);
        expect(danger.backgroundColor!.resolve({WidgetState.pressed}), c.negativePress);
        final small = buildCharcoalButtonStyle(charcoal, CharcoalButtonVariant.normal, small: true);
        expect(small.minimumSize!.resolve({}), Size(0, pack.sizes.controlSm));
      });

      test('the switch draws the same thumb on and off', () {
        final sw = theme.switchTheme;
        expect(sw.thumbColor!.resolve({}), c.iconOnPrimary);
        expect(sw.thumbColor!.resolve({WidgetState.selected}), c.iconOnPrimary);
        expect(sw.trackColor!.resolve({WidgetState.selected}), c.primary);
        expect(sw.trackColor!.resolve({}), c.neutral);
        expect(sw.trackColor!.resolve({WidgetState.disabled}), c.surfaceDisabled);
      });

      test('page transitions cover the three gesture platforms', () {
        final builders = theme.pageTransitionsTheme.builders;
        expect(builders[TargetPlatform.android], isA<PredictiveBackPageTransitionsBuilder>());
        expect(builders[TargetPlatform.iOS], isA<CupertinoPageTransitionsBuilder>());
        expect(builders[TargetPlatform.macOS], isA<CupertinoPageTransitionsBuilder>());
      });
    });
  }

  test('the platform argument reaches ThemeData and the extension', () {
    final ios = buildCharcoalThemeData(charcoalLightPack, platform: TargetPlatform.iOS);
    expect(ios.platform, TargetPlatform.iOS);
    expect(ios.extension<CharcoalTheme>()!.platform, TargetPlatform.iOS);
  });

  test('without a platform it follows the running platform', () {
    final theme = buildCharcoalThemeData(charcoalDarkPack);
    expect(theme.platform, defaultTargetPlatform);
  });

  test('a derived pack flows through the builder', () {
    final derived = extremePack(Brightness.light);
    final theme = buildCharcoalThemeData(derived);
    expect(theme.colorScheme.primary, derived.colors.primary);
    expect(theme.colorScheme.primary, isNot(charcoalLightPack.colors.primary));
    expect(theme.dialogTheme.barrierColor, derived.colors.barrier);
    expect(theme.extension<CharcoalTheme>()!.pack, same(derived));
  });

  testWidgets('Material widgets render with the pack colours', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildCharcoalThemeData(charcoalLightPack),
        home: Scaffold(
          body: FilledButton(onPressed: () {}, child: const Text('Go')),
        ),
      ),
    );
    final material = tester.widget<Material>(
      find.descendant(of: find.byType(FilledButton), matching: find.byType(Material)),
    );
    expect(material.color, charcoalLightPack.colors.primary);
  });
}
