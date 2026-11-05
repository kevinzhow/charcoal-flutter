import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Toast and snack bar', size: Size(520, 300))
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

@CharcoalComponentPreview(name: 'Banners and states', size: Size(480, 640))
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

@CharcoalComponentPreview(name: 'Loading', size: Size(420, 360))
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
      Wrap(
        spacing: CharcoalTheme.of(context).space.lg,
        runSpacing: CharcoalTheme.of(context).space.lg,
        children: const <Widget>[
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

@CharcoalComponentPreview(name: 'Dialog', size: Size(520, 420))
Widget charcoalDialogPreview() => Builder(
  builder: (context) => SizedBox(
    height: CharcoalTheme.of(context).sizes.codeViewportMaxHeight,
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
      child: const Text('Apps using this key stop working.'),
    ),
  ),
);

@CharcoalComponentPreview(name: 'Tooltip and balloons', size: Size(420, 380))
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
        spacing: CharcoalTheme.of(context).space.lg,
        runSpacing: CharcoalTheme.of(context).space.lg,
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

@CharcoalComponentPreview(name: 'Carousel', size: Size(620, 560))
Widget charcoalCarouselPreview() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    _CarouselDemo(size: CharcoalCarouselSize.medium),
    CharcoalGap(CharcoalSpace.lg),
    _CarouselDemo(size: CharcoalCarouselSize.small),
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
    return SizedBox(
      height: switch (size) {
        CharcoalCarouselSize.medium => theme.sizes.codeViewportMaxHeight,
        CharcoalCarouselSize.small => theme.sizes.rowMinHeightTall * 2,
      },
      child: CharcoalCarousel(
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
      ),
    );
  }
}
