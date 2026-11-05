import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

final class ShowcasePageIntro extends StatelessWidget {
  const ShowcasePageIntro({
    super.key,
    required this.description,
    required this.eyebrow,
    required this.title,
  });

  final String description;
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final eyebrowText = Text(
          eyebrow,
          style: theme
              .style(CharcoalTextRole.captionMediumBold)
              .copyWith(color: theme.colors.textInfo, letterSpacing: 1.2),
        );
        final badge = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: theme.colors.negative,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              'V2',
              style: theme
                  .style(CharcoalTextRole.captionMediumBold)
                  .copyWith(color: theme.colors.textOnNegative),
            ),
          ),
        );
        final titleAndDescription = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style:
                  (compact
                          ? theme.style(CharcoalTextRole.headingS)
                          : theme.style(CharcoalTextRole.headingM))
                      .copyWith(color: theme.colors.text),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme
                  .style(CharcoalTextRole.bodyLarge)
                  .copyWith(color: theme.colors.textSecondary),
            ),
          ],
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.borderSubtle),
            borderRadius: BorderRadius.circular(18),
            color: theme.colors.background,
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 20 : 28),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: eyebrowText),
                          const SizedBox(width: 12),
                          badge,
                        ],
                      ),
                      const SizedBox(height: 12),
                      titleAndDescription,
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            eyebrowText,
                            const SizedBox(height: 9),
                            titleAndDescription,
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      badge,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

final class ShowcaseCatalogGrid extends StatelessWidget {
  const ShowcaseCatalogGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final twoColumns = constraints.maxWidth >= 760;
      final cardWidth = twoColumns
          ? (constraints.maxWidth - 20) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          for (final child in children)
            SizedBox(width: cardWidth, child: child),
        ],
      );
    },
  );
}

String displayTokenName(String value) => value
    .split(RegExp('[-_/]'))
    .where((part) => part.isNotEmpty)
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join(' ');

String formatShowcaseNumber(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(2);

final class ShowcaseCard extends StatelessWidget {
  const ShowcaseCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSubtle),
          borderRadius: BorderRadius.circular(16),
          color: theme.colors.background,
        ),
        child: Padding(
          padding: EdgeInsets.all(constraints.maxWidth < 420 ? 20 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eyebrow,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(
                      color: theme.colors.textInfo,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                style: theme
                    .style(CharcoalTextRole.headingXs)
                    .copyWith(color: theme.colors.text),
              ),
              const SizedBox(height: 7),
              Text(
                description,
                style: theme
                    .style(CharcoalTextRole.captionMedium)
                    .copyWith(color: theme.colors.textSecondary),
              ),
              const SizedBox(height: 22),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder callback for demo controls that should look enabled.
void showcaseNoop() {}
