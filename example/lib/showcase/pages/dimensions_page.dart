import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

enum _DimensionKind { borderWidth, paragraphWidth, radius, space }

final class DimensionsPage extends StatelessWidget {
  const DimensionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.brightness == Brightness.dark
        ? CharcoalGeneratedDimensionTokens.dark
        : CharcoalGeneratedDimensionTokens.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'All generated V2 geometry values: spacing, radii, borders, targets, and readable paragraph widths.',
          eyebrow: 'FOUNDATION · DIMENSIONS',
          title: 'Dimension catalog',
        ),
        const SizedBox(height: 24),
        ShowcaseCatalogGrid(
          children: <Widget>[
            _DimensionCatalog(
              description: 'Component, layout, padding, and target values.',
              entries: tokens.space.entries,
              kind: _DimensionKind.space,
              title: 'Space',
            ),
            _DimensionCatalog(
              description: 'Corner geometry including the oval primitive.',
              entries: tokens.radius.entries,
              kind: _DimensionKind.radius,
              title: 'Radius',
            ),
            _DimensionCatalog(
              description: 'Standard and focus-ring stroke widths.',
              entries: tokens.borderWidth.entries,
              kind: _DimensionKind.borderWidth,
              title: 'Border width',
            ),
            _DimensionCatalog(
              description: 'Compact, regular, and cozy reading measures.',
              entries: tokens.paragraphWidth.entries,
              kind: _DimensionKind.paragraphWidth,
              title: 'Paragraph width',
            ),
          ],
        ),
      ],
    );
  }
}

final class _DimensionCatalog extends StatelessWidget {
  const _DimensionCatalog({
    required this.description,
    required this.entries,
    required this.kind,
    required this.title,
  });

  final String description;
  final List<CharcoalDimensionTokenEntry> entries;
  final _DimensionKind kind;
  final String title;

  @override
  Widget build(BuildContext context) => ShowcaseCard(
    description: '$description ${entries.length} generated tokens.',
    eyebrow: 'DIMENSION',
    title: title,
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final entry in entries)
          _DimensionTokenTile(entry: entry, kind: kind),
      ],
    ),
  );
}

final class _DimensionTokenTile extends StatelessWidget {
  const _DimensionTokenTile({required this.entry, required this.kind});

  final CharcoalDimensionTokenEntry entry;
  final _DimensionKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 180,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSubtle),
          borderRadius: BorderRadius.circular(10),
          color: theme.colors.background,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 58,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _visual(theme),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.path,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(
                      color: theme.colors.textSecondary,
                      fontFamily: 'monospace',
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                '${formatShowcaseNumber(entry.value)} px',
                style: theme
                    .style(CharcoalTextRole.captionMediumBold)
                    .copyWith(
                      color: theme.colors.text,
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _visual(CharcoalTheme theme) => switch (kind) {
    _DimensionKind.radius => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSelected),
        borderRadius: BorderRadius.circular(entry.value.clamp(0, 28)),
        color: theme.colors.fillSecondary,
      ),
      child: const SizedBox(width: 72, height: 48),
    ),
    _DimensionKind.borderWidth => SizedBox(
      width: 112,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colors.borderSelected,
              width: entry.value.clamp(1, 12),
            ),
          ),
        ),
      ),
    ),
    _DimensionKind.paragraphWidth => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: theme.colors.negative,
      ),
      child: SizedBox(width: (entry.value / 5).clamp(24, 150), height: 14),
    ),
    _DimensionKind.space => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: theme.colors.primary,
      ),
      child: SizedBox(width: (entry.value * 2).clamp(2, 150), height: 14),
    ),
  };
}
