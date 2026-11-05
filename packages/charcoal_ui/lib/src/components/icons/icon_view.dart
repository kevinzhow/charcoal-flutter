import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The semantic colour of an icon.
///
/// A tone names an icon colour role of the active pack.
enum CharcoalIconTone {
  /// `colors.icon`, the default icon colour.
  primary,

  /// `colors.iconSecondary`.
  secondary,

  /// `colors.iconTertiary`: quiet affordances such as chevrons.
  tertiary,

  /// `colors.iconDisabled`.
  disabled,

  /// `colors.iconHint`.
  hint,

  /// `colors.iconPositive`.
  positive,

  /// `colors.iconNegative`.
  negative,

  /// `colors.iconNotice`.
  notice,

  /// `colors.primary`: the brand accent.
  accent,

  /// `colors.iconOnPrimary`: on a primary-coloured surface.
  onPrimary,

  /// `colors.iconOnImage`: over imagery.
  onImage;

  /// The colour this tone resolves to in [colors].
  Color resolve(CharcoalColorRoles colors) => switch (this) {
    CharcoalIconTone.primary => colors.icon,
    CharcoalIconTone.secondary => colors.iconSecondary,
    CharcoalIconTone.tertiary => colors.iconTertiary,
    CharcoalIconTone.disabled => colors.iconDisabled,
    CharcoalIconTone.hint => colors.iconHint,
    CharcoalIconTone.positive => colors.iconPositive,
    CharcoalIconTone.negative => colors.iconNegative,
    CharcoalIconTone.notice => colors.iconNotice,
    CharcoalIconTone.accent => colors.primary,
    CharcoalIconTone.onPrimary => colors.iconOnPrimary,
    CharcoalIconTone.onImage => colors.iconOnImage,
  };
}

/// The size step of an icon.
enum CharcoalIconSize {
  /// `sizes.iconSm`.
  sm,

  /// `sizes.iconMd`.
  md,

  /// `sizes.iconLg`.
  lg,

  /// `sizes.iconXl`.
  xl;

  /// The edge this step resolves to in [sizes].
  double resolve(CharcoalSizeScale sizes) => switch (this) {
    CharcoalIconSize.sm => sizes.iconSm,
    CharcoalIconSize.md => sizes.iconMd,
    CharcoalIconSize.lg => sizes.iconLg,
    CharcoalIconSize.xl => sizes.iconXl,
  };
}

/// A [CharcoalIcon] glyph painted in a semantic [tone] and [size] of the active theme.
///
/// `CharcoalIcon` (package `charcoal_icons`) stays the theme-free glyph widget and takes raw
/// colours and sizes; this widget is what application code uses when an icon needs a colour or a
/// size of its own, so no colour or number appears at the call site. Without a [tone] the icon
/// inherits the colour of its surroundings (a button, a list row), and without a [size] it keeps
/// the inherited or native size.
///
/// ```dart
/// const CharcoalIconView(
///   CharcoalIcons.lock,
///   tone: CharcoalIconTone.secondary,
///   size: CharcoalIconSize.lg,
/// )
/// ```
final class CharcoalIconView extends StatelessWidget {
  /// Shows [icon].
  const CharcoalIconView(
    this.icon, {
    this.matchTextDirection = false,
    this.semanticLabel,
    this.size,
    this.tone,
    super.key,
  });

  /// The glyph.
  final CharcoalIconData icon;

  /// Whether the glyph is mirrored in right-to-left text.
  final bool matchTextDirection;

  /// Spoken description; the icon is decorative without one.
  final String? semanticLabel;

  /// The size step; inherited or native when null.
  final CharcoalIconSize? size;

  /// The semantic colour; inherited when null.
  final CharcoalIconTone? tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalIcon(
      icon,
      color: tone?.resolve(theme.colors),
      matchTextDirection: matchTextDirection,
      semanticLabel: semanticLabel,
      size: size?.resolve(theme.sizes),
    );
  }
}
