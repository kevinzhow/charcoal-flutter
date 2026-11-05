import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/next.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for the "gaps" batch: text and icon tones, the code block, the action tile, the list row
/// with a body, and the admin page frame in both layouts, with a banner and while busy.
final gapsScenes = <CharcoalScene>[
  CharcoalScene(
    name: 'gaps-primitives',
    size: const Size(700, 1300),
    build: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: const _Primitives(),
    ),
  ),
  CharcoalScene(
    name: 'gaps-page',
    size: const Size(1100, 800),
    build: (_) => const _PageScene(),
  ),
  CharcoalScene(
    name: 'gaps-page-busy-banner',
    size: const Size(900, 600),
    build: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: const CharcoalPage(
        title: 'Settings',
        subtitle: 'Credentials required',
        busy: true,
        banner: CharcoalBanner(message: 'Sign in with admin credentials to use this page.'),
        child: SizedBox.shrink(),
      ),
    ),
  ),
];

class _Primitives extends StatelessWidget {
  const _Primitives();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final tone in CharcoalTextTone.values)
                ColoredBox(
                  color: tone.name.startsWith('on')
                      ? CharcoalTheme.of(context).colors.primary
                      : CharcoalTheme.of(context).colors.background,
                  child: CharcoalText(tone.name, tone: tone),
                ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalWrap(
                children: [
                  for (final tone in CharcoalIconTone.values)
                    for (final size in CharcoalIconSize.values)
                      CharcoalIconView(CharcoalIcons.lock, tone: tone, size: size),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalCodeBlock('{\n  "key": "value",\n  "list": [1, 2, 3]\n}'),
              const CharcoalGap(CharcoalSpace.sm),
              CharcoalCodeBlock('a very long line ' * 20, maxLines: 2, selectable: false),
              const CharcoalGap(CharcoalSpace.sm),
              CharcoalActionTile(icon: CharcoalIcons.add, label: 'New project', onPressed: noop),
              const CharcoalGap(CharcoalSpace.sm),
              CharcoalListRow(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalPadding: CharcoalSpace.md,
                leading: const CharcoalStatusDot(CharcoalTone.positive),
                title: 'Maintenance window',
                subtitle: 'The service restarts at midnight and is unavailable for a few minutes.',
                subtitleGap: CharcoalSpace.xs,
                subtitleRole: CharcoalTextRole.body,
                subtitleTone: CharcoalTextTone.secondary,
                body: const CharcoalWrap(
                  spacing: CharcoalSpace.sm,
                  runSpacing: CharcoalSpace.xs,
                  children: [CharcoalChip('sent'), CharcoalChip('normal'), CharcoalChip('ios')],
                ),
                onPressed: noop,
              ),
              const CharcoalLoadingState(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageScene extends StatelessWidget {
  const _PageScene();

  @override
  Widget build(BuildContext context) => CharcoalPage(
    title: 'Users',
    subtitle: 'Accounts and quotas',
    showBack: true,
    backLabel: 'Back',
    compactTrailing: const CharcoalChip('eu'),
    actions: [CharcoalButton(onPressed: () {}, child: const Text('Invite'))],
    header: const CharcoalText('Pinned header', tone: CharcoalTextTone.tertiary),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < 3; i++) CharcoalListRow(title: 'Row $i', onPressed: () {})],
    ),
  );
}
