import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for the pieces the Agent Ready examples needed: placeholder artwork, message bubbles,
/// the progress bar, the bottom bar, raised and interactive cards, toned and extra-large avatars,
/// the icon-button badge, the inline spinner, a spaced carousel and the secondary page background.
final contentScenes = <CharcoalScene>[
  CharcoalScene(
    name: 'content-feed',
    size: const Size(420, 1500),
    build: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: const _Feed(),
    ),
  ),
  CharcoalScene(
    name: 'content-conversation',
    size: const Size(420, 700),
    build: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: const _Conversation(),
    ),
  ),
];

class _Feed extends StatelessWidget {
  const _Feed();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      background: CharcoalPageBackground.secondary,
      navigationBar: CharcoalNavigationBar(
        leading: const CharcoalAvatar('Bloom', initials: 'B', size: CharcoalAvatarSize.small),
        title: const Text('Feed'),
        trailing: CharcoalIconButton(
          badge: '3',
          icon: const CharcoalIcon(CharcoalIcons.bell),
          onPressed: noop,
          semanticLabel: 'Notifications, 3 unread',
          size: CharcoalIconButtonSize.small,
        ),
      ),
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CharcoalWrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final tone in CharcoalTone.values)
                    CharcoalAvatar(tone.name, circular: true, initials: 'AK', tone: tone),
                  const CharcoalAvatar('Mina Arai', size: CharcoalAvatarSize.extraLarge),
                ],
              ),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalCard(
                padding: const CharcoalInset.only(),
                raised: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CharcoalClickable(
                      onPressed: noop,
                      semanticLabel: 'Open profile',
                      builder: (context, states) => CharcoalPressFeedback(
                        states: states,
                        child: CharcoalPadding.all(
                          CharcoalSpace.md,
                          child: const CharcoalText('Aki Kondo', role: CharcoalTextRole.bodyBold),
                        ),
                      ),
                    ),
                    for (var seed = 0; seed < 4; seed++)
                      CharcoalPlaceholderArtwork(seed: seed, semanticLabel: 'Study $seed'),
                  ],
                ),
              ),
              const CharcoalGap(CharcoalSpace.md),
              SizedBox(
                height: 160,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var seed = 0; seed < 2; seed++) ...[
                      Expanded(
                        child: CharcoalPlaceholderArtwork(
                          rounded: true,
                          seed: seed,
                          semanticLabel: 'Tile $seed',
                        ),
                      ),
                      const CharcoalGap(CharcoalSpace.sm),
                    ],
                  ],
                ),
              ),
              const CharcoalGap(CharcoalSpace.md),
              for (final states in const <Set<WidgetState>>{
                {},
                {WidgetState.hovered},
                {WidgetState.pressed},
                {WidgetState.focused},
              }) ...[
                CharcoalCard(
                  raised: true,
                  states: states,
                  child: CharcoalText(states.isEmpty ? 'rest' : states.first.name),
                ),
                const CharcoalGap(CharcoalSpace.sm),
              ],
              const CharcoalCard(outlined: true, states: {}, child: CharcoalText('outlined')),
              const CharcoalGap(CharcoalSpace.sm),
              const CharcoalCard(highlighted: true, child: CharcoalText('unread')),
              const CharcoalGap(CharcoalSpace.md),
              const CharcoalProgressBar(value: 0.6, semanticLabel: 'Upload'),
              const CharcoalGap(CharcoalSpace.md),
              CharcoalCarousel(
                spacing: CharcoalSpace.sm,
                children: [
                  for (var i = 0; i < 3; i++) CharcoalCard(child: CharcoalText('Slide $i')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Conversation extends StatelessWidget {
  const _Conversation();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      background: CharcoalPageBackground.secondary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: CharcoalPadding.all(
                CharcoalSpace.lg,
                child: const Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: CharcoalMessageBubble(
                        'A long incoming message that wraps at the bubble width of the pack.',
                      ),
                    ),
                    CharcoalGap(CharcoalSpace.sm),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: CharcoalMessageBubble('On my way', outgoing: true),
                    ),
                    CharcoalGap(CharcoalSpace.xs),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CharcoalLoadingSpinner.inline(semanticLabel: 'Sending message'),
                          CharcoalGap(CharcoalSpace.xs),
                          CharcoalText('Sending…', role: CharcoalTextRole.size10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CharcoalBottomBar(
            child: Row(
              children: [
                const Expanded(child: CharcoalText('Reply')),
                CharcoalIconButton(
                  icon: const CharcoalIcon(CharcoalIcons.send),
                  onPressed: noop,
                  semanticLabel: 'Send',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
