part of '../bloom.dart';

Widget _bloomPagePadding(BuildContext context, Widget child) {
  final space = CharcoalTheme.of(context).dimensions.space;
  return Padding(
    padding: EdgeInsets.fromLTRB(
      space.component30,
      space.component25,
      space.component30,
      space.component30,
    ),
    child: child,
  );
}

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

final class _BloomSurface extends StatelessWidget {
  const _BloomSurface({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.dimensions.space.component25),
        child: child,
      ),
    );
  }
}

final class _BloomSectionTitle extends StatelessWidget {
  const _BloomSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Text(
      title,
      style: theme.textStyles.captionMediumBold.copyWith(
        color: theme.colors.textDefault,
      ),
    );
  }
}

final class _BloomAvatar extends StatelessWidget {
  const _BloomAvatar({
    required this.initials,
    required this.size,
    required this.tone,
  });

  final String initials;
  final double size;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final background = switch (tone % 4) {
      0 => theme.colors.containerPrimaryDefault,
      1 => theme.colors.containerDiscoveryDefault,
      2 => theme.colors.containerNoticeDefault,
      _ => theme.colors.containerPositiveDefault,
    };
    final foreground = switch (tone % 4) {
      0 => theme.colors.textOnPrimaryDefault,
      1 => theme.colors.textOnDiscoveryDefault,
      2 => theme.colors.textOnNoticeDefault,
      _ => theme.colors.textOnPositiveDefault,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: background,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            initials,
            style: theme.textStyles.captionSmall.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

final class _BloomArtwork extends StatelessWidget {
  const _BloomArtwork({
    required this.altText,
    required this.height,
    required this.tone,
  });

  final String altText;
  final double height;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final palette = switch (tone % 4) {
      0 => (
        theme.colors.containerPrimaryDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNoticeDefault,
      ),
      1 => (
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerPositiveDefault,
        theme.colors.backgroundDefault,
      ),
      2 => (
        theme.colors.containerNoticeDefault,
        theme.colors.containerPrimaryDefault,
        theme.colors.containerNegativeDefault,
      ),
      _ => (
        theme.colors.containerPositiveDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNeutralDefault,
      ),
    };
    return Semantics(
      image: true,
      label: altText,
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: ClipRect(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[palette.$1, palette.$2],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: -48,
                    left: -28,
                    child: _BloomDecorativeCircle(color: palette.$3, size: 148),
                  ),
                  Positioned(
                    right: 30,
                    top: 28,
                    child: Transform.rotate(
                      angle: -0.28,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            theme.dimensions.radius.m,
                          ),
                          color: palette.$3.withValues(alpha: 0.76),
                        ),
                        child: const SizedBox.square(dimension: 78),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _BloomDecorativeCircle extends StatelessWidget {
  const _BloomDecorativeCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: color,
    ),
    child: SizedBox.square(dimension: size),
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
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _BloomSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIcon(icon, color: theme.colors.iconSecondaryDefault),
          SizedBox(height: space.component20),
          Text(
            title,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ],
      ),
    );
  }
}

final class _BloomCountBadge extends StatelessWidget {
  const _BloomCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component20,
          vertical: theme.dimensions.space.component10,
        ),
        child: Text(
          '$count unread',
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textOnPrimaryDefault,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

final class _BloomCompactBadge extends StatelessWidget {
  const _BloomCompactBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.backgroundDefault),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerNegativeDefault,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            child: Text(
              '$count',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textOnNegativeDefault,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _BloomMetric extends StatelessWidget {
  const _BloomMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      children: <Widget>[
        Text(
          value,
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component10),
        Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
        ),
      ],
    );
  }
}

final class _BloomBrandMark extends StatelessWidget {
  const _BloomBrandMark();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.containerDiscoveryDefault,
      ),
      child: SizedBox.square(
        dimension: theme.dimensions.space.targetS,
        child: Center(
          child: Text(
            'B',
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textOnDiscoveryDefault,
            ),
          ),
        ),
      ),
    );
  }
}

final class _BloomNotificationButton extends StatelessWidget {
  const _BloomNotificationButton({
    required this.onPressed,
    required this.unreadCount,
  });

  final VoidCallback onPressed;
  final int unreadCount;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: <Widget>[
      CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.bell),
        onPressed: onPressed,
        semanticLabel: unreadCount > 0
            ? 'Notifications, $unreadCount unread'
            : 'Notifications',
        size: CharcoalIconButtonSize.small,
      ),
      if (unreadCount > 0)
        PositionedDirectional(
          end: -2,
          top: -2,
          child: ExcludeSemantics(
            child: _BloomCompactBadge(count: unreadCount),
          ),
        ),
    ],
  );
}
