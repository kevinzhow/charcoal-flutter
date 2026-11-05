part of '../bloom.dart';

Widget _bloomPagePadding(BuildContext context, Widget child) {
  final space = CharcoalTheme.of(context).space;
  return Padding(
    padding: EdgeInsets.fromLTRB(space.lg, space.md, space.lg, space.lg),
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
        border: Border.all(color: theme.colors.borderSubtle),
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: theme.colors.background,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.space.md),
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
      style: theme
          .style(CharcoalTextRole.captionMediumBold)
          .copyWith(color: theme.colors.text),
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
      0 => theme.colors.primary,
      1 => theme.colors.negative,
      2 => theme.colors.notice,
      _ => theme.colors.positive,
    };
    final foreground = switch (tone % 4) {
      0 => theme.colors.textOnPrimary,
      1 => theme.colors.textOnNegative,
      2 => theme.colors.text,
      _ => theme.colors.textOnPositive,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: background,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            initials,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(color: foreground, fontWeight: FontWeight.w700),
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
      0 => (theme.colors.primary, theme.colors.negative, theme.colors.notice),
      1 => (
        theme.colors.negative,
        theme.colors.positive,
        theme.colors.background,
      ),
      2 => (theme.colors.notice, theme.colors.primary, theme.colors.negative),
      _ => (theme.colors.positive, theme.colors.negative, theme.colors.neutral),
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
                          borderRadius: BorderRadius.circular(theme.radius.md),
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
    final space = theme.space;
    return _BloomSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIcon(icon, color: theme.colors.iconSecondary),
          SizedBox(height: space.sm),
          Text(
            title,
            style: theme
                .style(CharcoalTextRole.captionMediumBold)
                .copyWith(color: theme.colors.text),
          ),
          SizedBox(height: space.xs),
          Text(
            description,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(color: theme.colors.textSecondary),
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
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: theme.colors.primary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.sm,
          vertical: theme.space.xs,
        ),
        child: Text(
          '$count unread',
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(
                color: theme.colors.textOnPrimary,
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
        border: Border.all(color: theme.colors.background),
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: theme.colors.negative,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            child: Text(
              '$count',
              style: theme
                  .style(CharcoalTextRole.caption)
                  .copyWith(
                    color: theme.colors.textOnNegative,
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
          style: theme
              .style(CharcoalTextRole.captionMediumBold)
              .copyWith(color: theme.colors.text),
        ),
        SizedBox(height: theme.space.xs),
        Text(
          label,
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(color: theme.colors.textSecondary),
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
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: theme.colors.negative,
      ),
      child: SizedBox.square(
        dimension: theme.sizes.controlSm,
        child: Center(
          child: Text(
            'B',
            style: theme
                .style(CharcoalTextRole.captionMediumBold)
                .copyWith(color: theme.colors.textOnNegative),
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
