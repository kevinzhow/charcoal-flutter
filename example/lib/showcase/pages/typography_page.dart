import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';
import 'next_island.dart';

final class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ShowcasePageIntro(
        description:
            'Every type role of the active theme pack: size, line height, weight and family. '
            'The specimens follow the light and dark packs and the system text scale.',
        eyebrow: 'FOUNDATION · TYPOGRAPHY',
        title: 'Typography catalog',
      ),
      SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description: 'Family and weight primitives behind every role.',
            eyebrow: 'TYPE PRIMITIVES',
            title: 'Font contract',
            child: NextThemeIsland(child: _FontContract()),
          ),
          ShowcaseCard(
            description:
                'The 10/12/14/16/20 ladder, regular and bold, plus monospace and truncation.',
            eyebrow: 'COMPONENT SCALE',
            title: 'CharcoalTypography',
            child: NextThemeIsland(child: _Ladder()),
          ),
          ShowcaseCard(
            description: 'Application roles for pages, rows and metadata.',
            eyebrow: 'APPLICATION ROLES',
            title: 'Application type roles',
            child: NextThemeIsland(
              child: _Roles(
                roles: <CharcoalTextRole>[
                  CharcoalTextRole.pageTitle,
                  CharcoalTextRole.modalTitle,
                  CharcoalTextRole.sectionTitle,
                  CharcoalTextRole.body,
                  CharcoalTextRole.bodyBold,
                  CharcoalTextRole.caption,
                  CharcoalTextRole.captionBold,
                  CharcoalTextRole.captionMono,
                ],
              ),
            ),
          ),
          ShowcaseCard(
            description: 'Upstream body, caption and heading tokens.',
            eyebrow: 'UPSTREAM ROLES',
            title: 'Body and heading roles',
            child: NextThemeIsland(
              child: _Roles(
                roles: <CharcoalTextRole>[
                  CharcoalTextRole.bodyLarge,
                  CharcoalTextRole.bodyLargeBold,
                  CharcoalTextRole.paragraph,
                  CharcoalTextRole.captionMedium,
                  CharcoalTextRole.captionMediumBold,
                  CharcoalTextRole.headingXxxs,
                  CharcoalTextRole.headingXxs,
                  CharcoalTextRole.headingXs,
                  CharcoalTextRole.headingS,
                  CharcoalTextRole.headingM,
                  CharcoalTextRole.headingL,
                  CharcoalTextRole.headingXl,
                  CharcoalTextRole.headingXxl,
                  CharcoalTextRole.headingXxxl,
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class _FontContract extends StatelessWidget {
  const _FontContract();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final typography = theme.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Row(label: 'Sans family', value: typography.sansFamily ?? 'platform default'),
        const CharcoalGap(CharcoalSpace.md),
        _Row(label: 'Monospace family', value: typography.monoFamily),
        const CharcoalGap(CharcoalSpace.md),
        _Row(label: 'Regular weight', value: 'w${typography.weightRegular.value}'),
        const CharcoalGap(CharcoalSpace.md),
        _Row(label: 'Bold weight', value: 'w${typography.weightBold.value}'),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(child: CharcoalText(label, role: CharcoalTextRole.captionBold)),
      const CharcoalGap(CharcoalSpace.md),
      CharcoalText(value, role: CharcoalTextRole.captionMono),
    ],
  );
}

class _Ladder extends StatelessWidget {
  const _Ladder();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      CharcoalTypography(role: CharcoalTextRole.size10, child: Text('10 / 18 · Regular')),
      CharcoalGap(CharcoalSpace.sm),
      CharcoalTypography(role: CharcoalTextRole.size12, bold: true, child: Text('12 / 20 · Bold')),
      CharcoalGap(CharcoalSpace.sm),
      CharcoalTypography(role: CharcoalTextRole.size14, child: Text('14 / 22 · Regular')),
      CharcoalGap(CharcoalSpace.sm),
      CharcoalTypography(role: CharcoalTextRole.size16, bold: true, child: Text('16 / 24 · Bold')),
      CharcoalGap(CharcoalSpace.sm),
      CharcoalTypography(role: CharcoalTextRole.size20, child: Text('20 / 28 · Regular')),
      CharcoalGap(CharcoalSpace.sm),
      CharcoalTypography(monospace: true, child: Text('id_0123456789abcdef')),
      CharcoalGap(CharcoalSpace.sm),
      SizedBox(
        width: 220,
        child: CharcoalTextEllipsis('A long run of text that is truncated when it is too wide'),
      ),
    ],
  );
}

class _Roles extends StatelessWidget {
  const _Roles({required this.roles});

  final List<CharcoalTextRole> roles;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final role in roles) ...<Widget>[
          CharcoalText(
            '${role.name}  ${theme.typography.spec(role).fontSize.toStringAsFixed(0)}'
            '/${theme.typography.spec(role).lineHeight.toStringAsFixed(0)}',
            role: role,
            maxLines: 2,
          ),
          const CharcoalGap(CharcoalSpace.sm),
        ],
      ],
    );
  }
}
