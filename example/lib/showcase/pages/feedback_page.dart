import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'Hints, tooltips, balloons, live-region toasts, loading presentations, and modal surfaces.',
        eyebrow: 'COMPONENTS · FEEDBACK',
        title: 'Feedback and overlays',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description: 'Text, subtitle, info icon, visibility, alignment, and action slots.',
            eyebrow: 'HINT TEXT',
            title: 'HintText',
            child: const Column(
              children: <Widget>[
                CharcoalHintText(
                  action: CharcoalButton(
                    onPressed: showcaseNoop,
                    size: CharcoalButtonSize.small,
                    variant: CharcoalButtonVariant.primary,
                    child: Text('Review'),
                  ),
                  subtitle: Text('You can change this later.'),
                  child: Text('Changes are saved automatically.'),
                ),
                SizedBox(height: 16),
                CharcoalHintText(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  child: Text('This message applies to the whole page.'),
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'Click, tap, hover, or focus a trigger. Automatic collision handling follows the anchor.',
            eyebrow: 'TOOLTIP',
            title: 'Tooltip positions',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                for (final position in CharcoalOverlayPosition.values)
                  CharcoalTooltip(
                    message: '${displayTokenName(position.name)} tooltip',
                    position: position,
                    child: CharcoalButton(
                      key: ValueKey<String>('tooltip-${position.name}'),
                      onPressed: showcaseNoop,
                      size: CharcoalButtonSize.small,
                      child: Text(displayTokenName(position.name)),
                    ),
                  ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'A continuous outlined path plus the interactive anchored iOS presentation.',
            eyebrow: 'BALLOON',
            title: 'Balloon directions',
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final position in CharcoalOverlayPosition.values)
                  CharcoalBalloon(
                    key: ValueKey<String>('balloon-${position.name}'),
                    position: position,
                    child: Text('Balloon'),
                  ),
                CharcoalAnchoredBalloon(
                  anchor: CharcoalButton(
                    key: const ValueKey<String>('anchored-balloon-trigger'),
                    onPressed: showcaseNoop,
                    size: CharcoalButtonSize.small,
                    child: const Text('Anchored balloon'),
                  ),
                  dismissIcon: const CharcoalIcon(CharcoalIcons20.x),
                  message: 'A controlled Charcoal balloon',
                  action: const Text('Learn more'),
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description:
                'Success and error capsules animate from either screen edge.',
            eyebrow: 'TOAST',
            title: 'Toasts',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  key: const ValueKey<String>('show-default-toast'),
                  onPressed: () => showCharcoalToast(
                    context: context,
                    message: 'Your changes were saved.',
                    variant: CharcoalToastVariant.success,
                  ),
                  size: CharcoalButtonSize.small,
                  child: const Text('Default toast'),
                ),
                CharcoalButton(
                  key: const ValueKey<String>('show-negative-toast'),
                  onPressed: () => showCharcoalToast(
                    context: context,
                    message: 'The upload could not be completed.',
                    variant: CharcoalToastVariant.error,
                  ),
                  size: CharcoalButtonSize.small,
                  variant: CharcoalButtonVariant.danger,
                  child: const Text('Error toast'),
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'Bordered messages support a 64px thumbnail, action, edge placement, and swipe-to-dismiss.',
            eyebrow: 'SNACKBAR',
            title: 'Snackbars',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  key: const ValueKey<String>('show-bottom-snackbar'),
                  onPressed: () => showCharcoalSnackBar(
                    context: context,
                    message: 'Bookmarked',
                    action: const CharcoalButton(
                      onPressed: showcaseNoop,
                      size: CharcoalButtonSize.small,
                      child: Text('Edit'),
                    ),
                  ),
                  size: CharcoalButtonSize.small,
                  child: const Text('Bottom snackbar'),
                ),
                CharcoalButton(
                  key: const ValueKey<String>('show-top-snackbar'),
                  onPressed: () => showCharcoalSnackBar(
                    context: context,
                    edge: CharcoalPopupEdge.top,
                    message: 'Preview generated',
                    thumbnail: const ColoredBox(
                      color: Color(0xFF0096FA),
                      child: Center(child: CharcoalIcon(CharcoalIcons.image)),
                    ),
                  ),
                  size: CharcoalButtonSize.small,
                  child: const Text('Top with thumbnail'),
                ),
              ],
            ),
          ),
          const ShowcaseCard(
            description: '48px expanding circles, custom sizes, transparent surfaces, and blocking overlays.',
            eyebrow: 'LOADING',
            title: 'LoadingSpinner',
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 18,
              runSpacing: 18,
              children: <Widget>[
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-default'),
                ),
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-small'),
                  size: 32,
                  padding: 14,
                ),
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-transparent'),
                  transparent: true,
                ),
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-large'),
                  size: 64,
                ),
                SizedBox(
                  width: 112,
                  height: 96,
                  child: CharcoalSpinnerOverlay(
                    interactionPassthrough: true,
                    visible: true,
                    child: ColoredBox(
                      color: Color(0x0C000000),
                      child: Center(child: Text('Overlay')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'Centered and bottom-sheet presentations with matching motion and close behavior.',
            eyebrow: 'MODAL',
            title: 'Modals',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final style in CharcoalModalStyle.values)
                  CharcoalButton(
                    key: ValueKey<String>('show-modal-${style.name}'),
                    onPressed: () => _showDialog(context, style: style),
                    size: CharcoalButtonSize.small,
                    child: Text(displayTokenName(style.name)),
                  ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  // Kept as a compact specimen used while comparing the expanded catalog.
  // ignore: unused_element
}

void _showDialog(
  BuildContext context, {
  CharcoalDialogSize size = CharcoalDialogSize.medium,
  CharcoalModalStyle style = CharcoalModalStyle.center,
}) {
  showCharcoalDialog<void>(
    context: context,
    style: style,
    builder: (dialogContext) => CharcoalDialog(
      closeIcon: const CharcoalIcon(CharcoalIcons.x),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onDismiss: () => Navigator.of(dialogContext).pop(),
      showCloseButton: true,
      size: size,
      style: style,
      title: 'Ready to publish?',
      actions: <Widget>[
        CharcoalButton(
          key: const ValueKey<String>('modal-publish'),
          fullWidth: true,
          variant: CharcoalButtonVariant.primary,
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Publish'),
        ),
        CharcoalButton(
          key: const ValueKey<String>('modal-cancel'),
          fullWidth: true,
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
      ],
      child: const Text(
        'This dialog is built without Material or Cupertino dependencies.',
      ),
    ),
  );
}
