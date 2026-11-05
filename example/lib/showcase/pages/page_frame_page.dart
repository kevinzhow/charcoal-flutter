import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

/// The admin page frame and the semantic text, icon and code primitives that admin pages use
/// instead of colours and sizes.
final class PageFramePage extends StatelessWidget {
  const PageFramePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'CharcoalPage frames one admin page (title block, back link, actions, banner, busy state). Text, icons and code blocks take semantic tones and size steps, so application code holds no colour or number.',
          eyebrow: 'COMPONENTS · ADMIN',
          title: 'Page frame and tones',
        ),
        const SizedBox(height: 24),
        ShowcaseCatalogGrid(
          children: <Widget>[
            ShowcaseCard(
              description: 'Standard layout (wide enough for the sidebar shell): back link, page title, subtitle and actions, then the content column. Narrower pages switch to the compact layout by themselves.',
              eyebrow: 'CHARCOAL PAGE',
              title: 'Standard',
              child: _Frame(
                height: 360,
                child: CharcoalPage(
                  showBack: true,
                  title: 'Users',
                  subtitle: 'Accounts and quotas',
                  actions: <Widget>[
                    CharcoalButton(
                      onPressed: showcaseNoop,
                      child: const Text('Invite'),
                    ),
                  ],
                  child: CharcoalList(
                    children: <Widget>[
                      CharcoalListRow(
                        title: 'Alice',
                        subtitle: 'alice@example.com',
                        onPressed: showcaseNoop,
                      ),
                      CharcoalListRow(
                        title: 'Bob',
                        subtitle: 'bob@example.com',
                        onPressed: showcaseNoop,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ShowcaseCard(
              description: 'Compact layout: a top bar with the title and a trailing chip, actions above the content.',
              eyebrow: 'CHARCOAL PAGE',
              title: 'Compact',
              child: _Frame(
                height: 360,
                child: CharcoalPage(
                  compact: true,
                  showBack: false,
                  title: 'Users',
                  compactTrailing: const CharcoalChip(
                    'eu',
                    tone: CharcoalTone.info,
                  ),
                  actions: <Widget>[
                    CharcoalButton(
                      onPressed: showcaseNoop,
                      child: const Text('Invite'),
                    ),
                  ],
                  child: CharcoalListRow(
                    title: 'Alice',
                    subtitle: 'alice@example.com',
                    onPressed: showcaseNoop,
                  ),
                ),
              ),
            ),
            ShowcaseCard(
              description: 'A banner replaces the content of a page that cannot be used yet.',
              eyebrow: 'BANNER · BUSY',
              title: 'Gate and busy',
              child: _Frame(
                height: 280,
                child: CharcoalPage(
                  showBack: false,
                  title: 'Settings',
                  subtitle: 'Credentials required',
                  banner: const CharcoalBanner(
                    tone: CharcoalTone.notice,
                    icon: CharcoalIcons.lock,
                    message: 'This page needs administrator credentials.',
                  ),
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
            ShowcaseCard(
              description: 'CharcoalText tone: the semantic text colour, resolved from the pack.',
              eyebrow: 'TEXT TONE',
              title: 'Text tones',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (final tone in CharcoalTextTone.values)
                    if (!tone.name.startsWith('on'))
                      CharcoalText(tone.name, tone: tone),
                ],
              ),
            ),
            ShowcaseCard(
              description: 'CharcoalIconView: icon tone and size step. CharcoalIcon stays the theme-free glyph.',
              eyebrow: 'ICON TONE · SIZE',
              title: 'Icon tones',
              child: CharcoalWrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  for (final tone in CharcoalIconTone.values)
                    if (!tone.name.startsWith('on'))
                      CharcoalIconView(
                        CharcoalIcons.lock,
                        tone: tone,
                        size: CharcoalIconSize.lg,
                      ),
                  for (final size in CharcoalIconSize.values)
                    CharcoalIconView(
                      CharcoalIcons.setting,
                      tone: CharcoalIconTone.secondary,
                      size: size,
                    ),
                ],
              ),
            ),
            ShowcaseCard(
              description: 'CharcoalCodeBlock: monospace on the secondary background, selectable, optionally clipped; the same block as the code dialog.',
              eyebrow: 'CODE BLOCK',
              title: 'Code block',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const CharcoalCodeBlock(
                    '{\n  "feature": "checkout",\n  "enabled": true\n}',
                  ),
                  const CharcoalGap(CharcoalSpace.sm),
                  CharcoalCodeBlock(
                    'a long line of log output ' * 8,
                    maxLines: 2,
                    selectable: false,
                  ),
                ],
              ),
            ),
            ShowcaseCard(
              description: 'CharcoalBrandMark and CharcoalBadge, a negative-toned button label, a secret value box with trailing actions, a key/value table and a divider.',
              eyebrow: 'BRAND · BADGE · SECRET BOX',
              title: 'Brand, badge, secret box',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const CharcoalWrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      CharcoalBrandMark('M'),
                      CharcoalBadge('Owner'),
                      CharcoalBadge('Paid', tone: CharcoalBadgeTone.positive),
                      CharcoalBadge('Banned', tone: CharcoalBadgeTone.negative),
                    ],
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  CharcoalCodeBlock(
                    '••••••••••••••••',
                    field: true,
                    maxLines: 1,
                    tone: CharcoalTextTone.secondary,
                    trailing: CharcoalIconButton(
                      icon: const CharcoalIcon(CharcoalIcons.copy),
                      semanticLabel: 'Copy',
                      onPressed: showcaseNoop,
                    ),
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: CharcoalButton(
                      size: CharcoalButtonSize.small,
                      labelTone: CharcoalTextTone.negative,
                      onPressed: showcaseNoop,
                      child: const Text('Delete'),
                    ),
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  const CharcoalInfoRows([
                    ('Email', 'alice@example.com'),
                    ('OpenID', 'oid-1234'),
                  ], labelWidth: CharcoalInfoLabelWidth.narrow),
                  const CharcoalGap(CharcoalSpace.md),
                  const CharcoalDivider(),
                  const CharcoalGap(CharcoalSpace.md),
                  const CharcoalFieldBox(
                    width: CharcoalFieldWidth.compact,
                    child: CharcoalTextField(label: 'Compact field'),
                  ),
                ],
              ),
            ),
            ShowcaseCard(
              description: 'CharcoalActionTile for dashboards, and a CharcoalListRow with a body slot and running-text subtitle.',
              eyebrow: 'TILE · ROW',
              title: 'Action tile and rich row',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CharcoalActionTile(
                    icon: CharcoalIcons.add,
                    label: 'New project',
                    onPressed: showcaseNoop,
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  CharcoalListRow(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalPadding: CharcoalSpace.md,
                    leading: const CharcoalStatusDot(CharcoalTone.positive),
                    title: 'Maintenance window',
                    subtitle:
                        'Restarts at midnight; unavailable for a few minutes.',
                    subtitleGap: CharcoalSpace.xs,
                    subtitleRole: CharcoalTextRole.body,
                    subtitleTone: CharcoalTextTone.secondary,
                    body: const CharcoalWrap(
                      spacing: CharcoalSpace.sm,
                      runSpacing: CharcoalSpace.xs,
                      children: <Widget>[
                        CharcoalChip('sent'),
                        CharcoalChip('ios'),
                      ],
                    ),
                    onPressed: showcaseNoop,
                  ),
                  const CharcoalLoadingState(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: theme.space.xl),
      ],
    );
  }
}

final class _Frame extends StatelessWidget {
  const _Frame({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSubtle),
          borderRadius: BorderRadius.circular(theme.radius.md),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.radius.md),
          child: child,
        ),
      ),
    );
  }
}
