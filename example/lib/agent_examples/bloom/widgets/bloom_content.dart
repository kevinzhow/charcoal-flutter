part of '../bloom.dart';

/// The inset of every Bloom page body.
const _bloomPageInset = CharcoalInset.only(
  left: CharcoalSpace.lg,
  top: CharcoalSpace.md,
  right: CharcoalSpace.lg,
  bottom: CharcoalSpace.lg,
);

Widget _bloomPagePadding(BuildContext context, Widget child) =>
    CharcoalPadding(padding: _bloomPageInset, child: child);

({String handle, String initials, String name, int tone}) _bloomAuthor(
  BloomData data,
  String creatorId,
) {
  if (creatorId == 'mina') {
    return (
      handle: data.profile.handle,
      initials: 'MA',
      name: data.profile.name,
      tone: data.profile.tone,
    );
  }
  final creator = data.creator(creatorId);
  return (
    handle: creator.handle,
    initials: creator.initials,
    name: creator.name,
    tone: creator.tone,
  );
}

/// A Bloom card: a raised card on the grey feed page.
final class _BloomSurface extends StatelessWidget {
  const _BloomSurface({
    required this.child,
    this.padding = const CharcoalInset.all(CharcoalSpace.md),
  });

  final Widget child;
  final CharcoalInset padding;

  @override
  Widget build(BuildContext context) =>
      CharcoalCard(padding: padding, raised: true, child: child);
}

final class _BloomSectionTitle extends StatelessWidget {
  const _BloomSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => CharcoalText(
    title,
    role: CharcoalTextRole.captionMediumBold,
    tone: CharcoalTextTone.primary,
  );
}

/// The person's colour in the data model (an index) as a tone of the theme.
CharcoalTone _bloomTone(int tone) => switch (tone % 4) {
  0 => CharcoalTone.info,
  1 => CharcoalTone.negative,
  2 => CharcoalTone.notice,
  _ => CharcoalTone.positive,
};

final class _BloomAvatar extends StatelessWidget {
  const _BloomAvatar({
    required this.initials,
    required this.size,
    required this.tone,
  });

  final String initials;
  final CharcoalAvatarSize size;
  final int tone;

  @override
  Widget build(BuildContext context) => CharcoalAvatar(
    initials,
    circular: true,
    initials: initials,
    size: size,
    tone: _bloomTone(tone),
  );
}

final class _BloomArtwork extends StatelessWidget {
  const _BloomArtwork({
    required this.altText,
    required this.tone,
    this.rounded = false,
  });

  final String altText;
  final bool rounded;
  final int tone;

  @override
  Widget build(BuildContext context) => CharcoalPlaceholderArtwork(
    rounded: rounded,
    seed: tone,
    semanticLabel: altText,
  );
}

final class _BloomEmptyState extends StatelessWidget {
  const _BloomEmptyState({
    required this.description,
    required this.title,
    this.icon = CharcoalIcons.search,
  });

  final String description;
  final CharcoalIconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => _BloomSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CharcoalIconView(icon, tone: CharcoalIconTone.secondary),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalText(
          title,
          role: CharcoalTextRole.captionMediumBold,
          tone: CharcoalTextTone.primary,
        ),
        const CharcoalGap(CharcoalSpace.xs),
        CharcoalText(
          description,
          role: CharcoalTextRole.caption,
          tone: CharcoalTextTone.secondary,
        ),
      ],
    ),
  );
}

final class _BloomMetric extends StatelessWidget {
  const _BloomMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      CharcoalText(
        value,
        role: CharcoalTextRole.captionMediumBold,
        tone: CharcoalTextTone.primary,
      ),
      const CharcoalGap(CharcoalSpace.xs),
      CharcoalText(
        label,
        role: CharcoalTextRole.caption,
        tone: CharcoalTextTone.secondary,
      ),
    ],
  );
}

/// Bloom's mark: a square avatar in the brand tone.
final class _BloomBrandMark extends StatelessWidget {
  const _BloomBrandMark();

  @override
  Widget build(BuildContext context) => const CharcoalAvatar(
    'Bloom',
    initials: 'B',
    size: CharcoalAvatarSize.small,
    tone: CharcoalTone.negative,
  );
}

final class _BloomNotificationButton extends StatelessWidget {
  const _BloomNotificationButton({
    required this.onPressed,
    required this.unreadCount,
  });

  final VoidCallback onPressed;
  final int unreadCount;

  @override
  Widget build(BuildContext context) => CharcoalIconButton(
    badge: unreadCount > 0 ? '$unreadCount' : null,
    icon: const CharcoalIcon(CharcoalIcons.bell),
    onPressed: onPressed,
    semanticLabel: unreadCount > 0
        ? 'Notifications, $unreadCount unread'
        : 'Notifications',
    size: CharcoalIconButtonSize.small,
  );
}
