import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for batch 2C: toast, snack bar, balloons, banners and states, spinner (frozen by reduced
/// motion so the scene settles), a carousel, and a dialog and a bottom sheet mounted in place.
final overlaysScenes = <CharcoalScene>[
  CharcoalScene(
    name: 'overlays-feedback',
    size: const Size(600, 1100),
    build: (context) => const _FeedbackScene(),
  ),
  CharcoalScene(
    name: 'overlays-dialog',
    size: const Size(600, 700),
    build: (context) => const _DialogScene(style: CharcoalModalStyle.center),
  ),
  CharcoalScene(
    name: 'overlays-sheet',
    size: const Size(600, 700),
    build: (context) => const _DialogScene(style: CharcoalModalStyle.bottomSheet),
  ),
];

class _FeedbackScene extends StatelessWidget {
  const _FeedbackScene();

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return CharcoalScaffold(
      body: SingleChildScrollView(
        child: CharcoalPadding.all(
          CharcoalSpace.lg,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CharcoalToast(
                  message: 'Saved',
                  leading: CharcoalIcon(CharcoalIcons.checkCircle),
                ),
                const CharcoalGap(CharcoalSpace.sm),
                const CharcoalToast(message: 'Failed', variant: CharcoalToastVariant.error),
                const CharcoalGap(CharcoalSpace.sm),
                const CharcoalSnackBar(message: 'Bookmarked', action: Text('Undo')),
                const CharcoalGap(CharcoalSpace.md),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final position in CharcoalOverlayPosition.values)
                      CharcoalBalloon(
                        position: position,
                        onDismiss: noop,
                        action: const Text('Action'),
                        child: Text(position.name),
                      ),
                  ],
                ),
                const CharcoalGap(CharcoalSpace.md),
                for (final tone in CharcoalTone.values) ...[
                  CharcoalBanner(tone: tone, icon: CharcoalIcons.alert, message: tone.name),
                  const CharcoalGap(CharcoalSpace.sm),
                ],
                const CharcoalBanner(
                  title: 'Title',
                  message: 'Message',
                  filled: false,
                  action: Text('Act'),
                ),
                CharcoalEmptyState(
                  icon: CharcoalIcons.image,
                  message: 'Nothing here',
                  actions: [CharcoalButton(onPressed: noop, child: const Text('Create'))],
                ),
                CharcoalErrorState(message: 'Could not load', onRetry: noop),
                const CharcoalLoadingState(),
                SizedBox(
                  height: 160,
                  child: CharcoalCarousel(
                    size: CharcoalCarouselSize.small,
                    children: [
                      for (var i = 0; i < 3; i++) Center(child: Text('Slide $i')),
                    ],
                  ),
                ),
                const CharcoalGap(CharcoalSpace.sm),
                const SizedBox(
                  height: 120,
                  child: CharcoalSpinnerOverlay(
                    visible: true,
                    dimBackground: true,
                    child: Center(child: Text('Busy content')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogScene extends StatelessWidget {
  const _DialogScene({required this.style});

  final CharcoalModalStyle style;

  @override
  Widget build(BuildContext context) => CharcoalDialog(
    style: style,
    title: 'Delete project',
    showCloseButton: true,
    onDismiss: () {},
    actions: [
      CharcoalButton(
        variant: CharcoalButtonVariant.danger,
        fullWidth: true,
        onPressed: () {},
        child: const Text('Delete'),
      ),
      CharcoalButton(fullWidth: true, onPressed: () {}, child: const Text('Cancel')),
    ],
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text('This removes every key of the project and cannot be undone.'),
    ),
  );
}
