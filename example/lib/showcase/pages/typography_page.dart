import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final fontSizes = theme.typography.fontSize.entries.toList()
      ..sort((left, right) {
        final sizeOrder = right.value.compareTo(left.value);
        return sizeOrder == 0 ? left.path.compareTo(right.path) : sizeOrder;
      });
    final lineHeights = <String, double>{
      for (final entry in theme.typography.lineHeight.entries)
        entry.path.substring('text.line-height/'.length): entry.value,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'Every generated V2 semantic text size, line height, family, and weight. The specimens update with the token pipeline.',
          eyebrow: 'FOUNDATION · TYPOGRAPHY',
          title: 'Typography catalog',
        ),
        const SizedBox(height: 24),
        ShowcaseCatalogGrid(
          children: <Widget>[
            ShowcaseCard(
              description: 'Generated family and weight primitives used by component typography.',
              eyebrow: 'TYPE PRIMITIVES',
              title: 'Font contract',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _TypographyMetadataRow(
                    label: 'Family',
                    token: theme.typography.fontFamily.entries.single.path,
                    value: theme.typography.fontFamily.sans,
                  ),
                  const SizedBox(height: 14),
                  for (final entry
                      in theme.typography.fontWeight.entries) ...<Widget>[
                    _TypographyMetadataRow(
                      label: displayTokenName(
                        entry.path.substring('text.font-weight/'.length),
                      ),
                      token: entry.path,
                      value: 'w${entry.value.value}',
                    ),
                    if (entry != theme.typography.fontWeight.entries.last)
                      const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
            ShowcaseCard(
              description: 'The public iOS 10/12/14/16/20 family, including regular, bold, and monospaced styles.',
              eyebrow: 'IOS PARITY',
              title: 'Component type scale',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final size in CharcoalTypographySize.values) ...<Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 58,
                          child: Text(
                            size.name.replaceFirst('size', ''),
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        Expanded(
                          child: CharcoalTypography(
                            size: size,
                            child: const Text('Regular typography'),
                          ),
                        ),
                        CharcoalTypography(
                          monospace: true,
                          size: size,
                          weight: CharcoalTypographyWeight.bold,
                          child: const Text('0123'),
                        ),
                      ],
                    ),
                    if (size != CharcoalTypographySize.values.last)
                      const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ShowcaseCatalogGrid(
          children: <Widget>[
            for (final entry in fontSizes)
              _TypographyTokenCard(
                fontFamily: theme.typography.fontFamily.sans,
                fontSize: entry.value,
                lineHeight:
                    lineHeights[entry.path.substring(
                      'text.font-size/'.length,
                    )] ??
                    entry.value,
                path: entry.path,
                regularWeight: theme.typography.fontWeight.regular,
                boldWeight: theme.typography.fontWeight.bold,
              ),
          ],
        ),
      ],
    );
  }
}

final class _TypographyMetadataRow extends StatelessWidget {
  const _TypographyMetadataRow({
    required this.label,
    required this.token,
    required this.value,
  });

  final String label;
  final String token;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              Text(
                token,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textTertiaryDefault,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: theme.textStyles.captionMedium.copyWith(
            color: theme.colors.textSecondaryDefault,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

final class _TypographyTokenCard extends StatelessWidget {
  const _TypographyTokenCard({
    required this.boldWeight,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.path,
    required this.regularWeight,
  });

  final FontWeight boldWeight;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final String path;
  final FontWeight regularWeight;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final semanticName = path.substring('text.font-size/'.length);
    final baseStyle = TextStyle(
      color: theme.colors.textDefault,
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      leadingDistribution: TextLeadingDistribution.even,
    );
    return ShowcaseCard(
      description:
          '${formatShowcaseNumber(fontSize)} px size · ${formatShowcaseNumber(lineHeight)} px line height',
      eyebrow: 'TEXT STYLE',
      title: displayTokenName(semanticName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Design with shared decisions',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: baseStyle.copyWith(fontWeight: regularWeight),
          ),
          const SizedBox(height: 12),
          Text(
            'Design with shared decisions',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: baseStyle.copyWith(fontWeight: boldWeight),
          ),
          const SizedBox(height: 14),
          Text(
            '$path  ·  text.line-height/$semanticName',
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
