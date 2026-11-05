import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../next.dart';
import 'next_preview_support.dart';

@CharcoalNextComponentPreview(name: 'Toast and snack bar', size: Size(520, 300))
Widget charcoalToastPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const CharcoalToast(leading: CharcoalIcon(CharcoalIcons.checkCircle), message: 'Changes saved'),
    const CharcoalGap(CharcoalSpace.lg),
    CharcoalToast(
      action: CharcoalLinkButton(onPressed: () {}, child: const Text('Retry')),
      message: 'Could not finish the action',
      variant: CharcoalToastVariant.error,
    ),
    const CharcoalGap(CharcoalSpace.lg),
    CharcoalSnackBar(
      action: CharcoalLinkButton(onPressed: () {}, child: const Text('Undo')),
      message: 'Item removed',
    ),
  ],
);

@CharcoalNextComponentPreview(name: 'Banners and states', size: Size(480, 640))
Widget charcoalBannerPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    for (final tone in CharcoalTone.values) ...<Widget>[
      CharcoalBanner(tone: tone, icon: CharcoalIcons.alert, message: 'A $tone banner'),
      const CharcoalGap(CharcoalSpace.sm),
    ],
    const CharcoalBanner(title: 'Titled', message: 'Detail line', filled: false),
    CharcoalEmptyState(
      icon: CharcoalIcons.image,
      message: 'Nothing here yet',
      actions: <Widget>[CharcoalButton(onPressed: () {}, child: const Text('Create'))],
    ),
    CharcoalErrorState(message: 'Could not load', onRetry: () {}),
  ],
);

@CharcoalNextComponentPreview(name: 'Loading', size: Size(420, 360))
Widget charcoalLoadingPreview() => const _LoadingPreview();

final class _LoadingPreview extends StatefulWidget {
  const _LoadingPreview();

  @override
  State<_LoadingPreview> createState() => _LoadingPreviewState();
}

final class _LoadingPreviewState extends State<_LoadingPreview> {
  bool loading = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Wrap(
        spacing: 16,
        runSpacing: 16,
        children: <Widget>[
          CharcoalLoadingSpinner(),
          CharcoalLoadingSpinner(transparent: true),
        ],
      ),
      const CharcoalLoadingState(),
      CharcoalSpinnerOverlay(
        visible: loading,
        dimBackground: true,
        child: CharcoalButton(
          onPressed: () => setState(() => loading = !loading),
          child: Text(loading ? 'Tap the overlay area to retry' : 'Start loading'),
        ),
      ),
    ],
  );
}

@CharcoalNextComponentPreview(name: 'Dialog', size: Size(520, 420))
Widget charcoalDialogPreview() => SizedBox(
  height: 340,
  child: CharcoalDialog(
    title: 'Delete key',
    showCloseButton: true,
    onDismiss: () {},
    actions: <Widget>[
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
      child: Text('Apps using this key stop working.'),
    ),
  ),
);

@CharcoalNextComponentPreview(name: 'Tooltip and balloons', size: Size(420, 380))
Widget charcoalAnchoredOverlayPreview() => const _AnchoredOverlayPreview();

final class _AnchoredOverlayPreview extends StatefulWidget {
  const _AnchoredOverlayPreview();

  @override
  State<_AnchoredOverlayPreview> createState() => _AnchoredOverlayPreviewState();
}

final class _AnchoredOverlayPreviewState extends State<_AnchoredOverlayPreview> {
  bool _balloonVisible = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const CharcoalBalloon(
        position: CharcoalOverlayPosition.left,
        semanticLabel: 'Persistent callout',
        child: Text('This callout stays in the authored layout.'),
      ),
      const CharcoalGap(CharcoalSpace.xl),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: <Widget>[
          CharcoalTooltip(
            message: 'Brief, non-interactive context',
            child: CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.infoCircle),
              onPressed: () {},
              semanticLabel: 'Show information',
            ),
          ),
          CharcoalAnchoredBalloon(
            anchor: CharcoalButton(
              onPressed: () => setState(() => _balloonVisible = !_balloonVisible),
              child: const Text('Persistent details'),
            ),
            dismissOnTapOutside: true,
            message: 'The controlled trigger works from pointer or keyboard.',
            onVisibilityChanged: (visible) => setState(() => _balloonVisible = visible),
            showOnTap: false,
            visible: _balloonVisible,
          ),
        ],
      ),
    ],
  );
}

@CharcoalNextComponentPreview(name: 'Carousel', size: Size(620, 560))
Widget charcoalCarouselPreview() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    SizedBox(height: 240, child: _CarouselDemo(size: CharcoalCarouselSize.medium)),
    CharcoalGap(CharcoalSpace.lg),
    SizedBox(height: 260, child: _CarouselDemo(size: CharcoalCarouselSize.small)),
  ],
);

final class _CarouselDemo extends StatelessWidget {
  const _CarouselDemo({required this.size});

  final CharcoalCarouselSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final fills = <Color>[
      theme.colors.surfaceSecondary,
      theme.colors.surfaceTertiary,
      theme.colors.neutral,
    ];
    return CharcoalCarousel(
      size: size,
      gap: theme.space.md,
      children: <Widget>[
        for (var i = 0; i < 4; i++)
          DecoratedBox(
            decoration: BoxDecoration(
              color: fills[i % fills.length],
              borderRadius: BorderRadius.circular(theme.radius.lg),
            ),
            child: Center(child: Text('Slide ${i + 1}')),
          ),
      ],
    );
  }
}
