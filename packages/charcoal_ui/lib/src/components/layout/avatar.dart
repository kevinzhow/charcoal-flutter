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
}

/// A square or circular avatar showing the first letter of [source].
///
/// The initial scales with the avatar: a title for the large one, a section heading for the
/// regular one and bold body text for the small one. An empty [source] shows a question mark.
final class CharcoalAvatar extends StatelessWidget {
  /// Creates an avatar for the name or e-mail [source].
  const CharcoalAvatar(
    this.source, {
    this.circular = false,
    this.size = CharcoalAvatarSize.regular,
    super.key,
  });

  /// The text whose first letter is shown.
  final String source;

  /// Whether the avatar is a circle instead of a rounded square.
  final bool circular;

  /// The edge length.
  final CharcoalAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final (edge, role) = switch (size) {
      CharcoalAvatarSize.small => (theme.sizes.avatarSm, CharcoalTextRole.bodyBold),
      CharcoalAvatarSize.regular => (theme.sizes.avatar, CharcoalTextRole.sectionTitle),
      CharcoalAvatarSize.large => (theme.sizes.avatarLg, CharcoalTextRole.modalTitle),
    };
    final trimmed = source.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();
    return Semantics(
      container: true,
      label: source,
      excludeSemantics: true,
      child: Container(
        width: edge,
        height: edge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colors.surfaceTertiary,
          borderRadius: BorderRadius.circular(circular ? theme.radius.pill : theme.radius.md),
        ),
        child: Text(initial, style: theme.style(role, color: theme.colors.textSecondary)),
      ),
    );
  }
}
