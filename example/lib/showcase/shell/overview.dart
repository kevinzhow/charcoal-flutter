import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../registry.dart';
import 'page_chrome.dart';

final class ShowcaseOverviewPage extends StatelessWidget {
  const ShowcaseOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final onSelected = ShowcaseNavigation.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _Hero(),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final metricWidth = constraints.maxWidth >= 720
                ? (constraints.maxWidth - 40) / 3
                : constraints.maxWidth;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: <Widget>[
                _OverviewMetric(
                  accent: theme.colors.containerPrimaryDefault,
                  label: 'Compatibility layers',
                  value: '0',
                  width: metricWidth,
                ),
                _OverviewMetric(
                  accent: theme.colors.containerDiscoveryDefault,
                  label: 'Theme modes',
                  value: '2',
                  width: metricWidth,
                ),
                _OverviewMetric(
                  accent: theme.colors.containerPositiveDefault,
                  label: 'Token source',
                  value: 'V2',
                  width: metricWidth,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        ShowcaseCard(
          eyebrow: 'EXPLORE',
          title: 'Inside the system',
          description: 'Each destination now has its own content and can be opened from here or the sidebar.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final linkWidth = constraints.maxWidth >= 720
                  ? (constraints.maxWidth - 24) / 3
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _OverviewLink(
                    description: 'Interactive controls and composed surfaces',
                    icon: CharcoalIcons.gridview,
                    onPressed: () => onSelected('buttons'),
                    title: 'Components',
                    width: linkWidth,
                  ),
                  _OverviewLink(
                    description: 'Color, type, spacing, and radius tokens',
                    icon: CharcoalIcons.palette,
                    onPressed: () => onSelected('colors'),
                    title: 'Foundation',
                    width: linkWidth,
                  ),
                  _OverviewLink(
                    description: 'Sync, generate, diff, and CI checks',
                    icon: CharcoalIcons.syncIcon,
                    onPressed: () => onSelected('token-pipeline'),
                    title: 'Token pipeline',
                    width: linkWidth,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

final class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.accent,
    required this.label,
    required this.value,
    required this.width,
  });

  final Color accent;
  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(16),
          color: theme.colors.backgroundDefault,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: accent,
                ),
                child: const SizedBox.square(dimension: 12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      value,
                      style: theme.textStyles.headingS.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                    Text(
                      label,
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textSecondaryDefault,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _OverviewLink extends StatelessWidget {
  const _OverviewLink({
    required this.description,
    required this.icon,
    required this.onPressed,
    required this.title,
    required this.width,
  });

  final String description;
  final CharcoalIconData icon;
  final VoidCallback onPressed;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: width,
      child: CharcoalClickable(
        onPressed: onPressed,
        semanticLabel: 'Open $title',
        builder: (context, states) {
          final pressed = states.contains(WidgetState.pressed);
          final hovered = states.contains(WidgetState.hovered);
          final background = pressed
              ? theme.colors.containerSecondaryPress
              : hovered
              ? theme.colors.containerSecondaryHover
              : theme.colors.containerSecondaryDefault;
          return AnimatedContainer(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              CharcoalMotion.standard,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: background,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalIcon(
                  icon,
                  color: theme.colors.iconNoticeDefault,
                  size: theme.dimensions.space.component40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: theme.textStyles.bodyBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
                CharcoalIcon(
                  CharcoalIcons.arrowRight,
                  color: theme.colors.iconTertiaryDefault,
                  size: theme.dimensions.space.component30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CHARCOAL UI · FLUTTER',
              style: theme.textStyles.captionMediumBold.copyWith(
                color: theme.colors.textOnPrimaryDefault,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Source-backed components,\npowered by shared foundations.',
              style:
                  (compact
                          ? theme.textStyles.headingS
                          : theme.textStyles.headingM)
                      .copyWith(color: theme.colors.textOnPrimaryDefault),
            ),
            const SizedBox(height: 12),
            Text(
              'Pure Flutter Widgets. No Material or Cupertino dependency.',
              style: theme.textStyles.body.copyWith(
                color: theme.colors.textOnPrimaryDefault.withValues(
                  alpha: 0.82,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _HeroPill(label: 'V2 only'),
                _HeroPill(label: 'Pinned sources'),
                _HeroPill(label: 'Light + dark'),
              ],
            ),
          ],
        );
        final mark = DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colors.textOnPrimaryDefault.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(20),
            color: theme.colors.textOnPrimaryDefault.withValues(alpha: 0.1),
          ),
          child: SizedBox.square(
            dimension: 130,
            child: Center(
              child: Text(
                'V2',
                style: theme.textStyles.headingXxl.copyWith(
                  color: theme.colors.textOnPrimaryDefault,
                ),
              ),
            ),
          ),
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                theme.colors.containerPrimaryDefault,
                theme.colors.containerDiscoveryDefault,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 20 : 30),
            child: compact
                ? content
                : Row(
                    children: <Widget>[
                      Expanded(child: content),
                      const SizedBox(width: 24),
                      mark,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

final class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colors.textOnPrimaryDefault.withValues(alpha: 0.14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textOnPrimaryDefault,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
