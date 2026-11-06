import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The size of a [CharcoalAvatar].
enum CharcoalAvatarSize {
  /// `sizes.avatarSm`.
  small,

  /// `sizes.avatar`.
  regular,

  /// `sizes.avatarLg`.
  large,

  /// `sizes.avatarXl`: a profile header.
  extraLarge,
}

/// A square or circular avatar showing the first letter of [source].
///
/// The initial scales with the avatar: a heading for the extra-large one, a title for the large
/// one, a section heading for the regular one and bold body text for the small one. An empty
/// [source] shows a question mark. [initials] replaces the derived letter (for example two
/// letters), and a [tone] fills the avatar with that tone's solid colour, so people or accounts
/// can be told apart without the caller naming a colour.
final class CharcoalAvatar extends StatelessWidget {
  /// Creates an avatar for the name or e-mail [source].
  const CharcoalAvatar(
    this.source, {
    this.circular = false,
    this.initials,
    this.size = CharcoalAvatarSize.regular,
    this.tone,
    super.key,
  }) : assert(initials == null || initials != '');

  /// The text whose first letter is shown.
  final String source;

  /// Whether the avatar is a circle instead of a rounded square.
  final bool circular;

  /// The letters shown instead of the first letter of [source].
  final String? initials;

  /// The edge length.
  final CharcoalAvatarSize size;

  /// The fill: null for the neutral tertiary surface, otherwise the tone's solid colour.
  final CharcoalTone? tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final (edge, role) = switch (size) {
      CharcoalAvatarSize.small => (theme.sizes.avatarSm, CharcoalTextRole.bodyBold),
      CharcoalAvatarSize.regular => (theme.sizes.avatar, CharcoalTextRole.sectionTitle),
      CharcoalAvatarSize.large => (theme.sizes.avatarLg, CharcoalTextRole.modalTitle),
      CharcoalAvatarSize.extraLarge => (theme.sizes.avatarXl, CharcoalTextRole.headingL),
    };
    final colors = theme.colors;
    final (fill, letter) = switch (tone) {
      null => (colors.surfaceTertiary, colors.textSecondary),
      CharcoalTone.info => (colors.primary, colors.textOnPrimary),
      CharcoalTone.negative => (colors.negative, colors.textOnNegative),
      CharcoalTone.positive => (colors.positive, colors.textOnPositive),
      CharcoalTone.notice => (colors.notice, colors.textOnNotice),
      CharcoalTone.neutral => (colors.neutral, colors.textOnPrimary),
    };
    final trimmed = source.trim();
    final initial = initials ?? (trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase());
    return Semantics(
      container: true,
      label: source,
      excludeSemantics: true,
      child: Container(
        width: edge,
        height: edge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(circular ? theme.radius.pill : theme.radius.md),
        ),
        child: Text(initial, maxLines: 1, style: theme.style(role, color: letter)),
      ),
    );
  }
}
