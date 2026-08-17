import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Navigation', size: Size(420, 360))
Widget charcoalNavigationPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    CharcoalNavigationBar(
      leading: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
        onPressed: () {},
        semanticLabel: 'Back',
        size: CharcoalIconButtonSize.small,
      ),
      title: const Text('Page title'),
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),
        onPressed: () {},
        semanticLabel: 'More actions',
        size: CharcoalIconButtonSize.small,
      ),
    ),
    const SizedBox(height: 24),
    CharcoalNavigationItem(
      leading: const CharcoalIcon(CharcoalIcons.home),
      onPressed: () {},
      selected: true,
      child: const Text('Overview'),
    ),
    const SizedBox(height: 12),
    CharcoalNavigationItem(
      leading: const CharcoalIcon(CharcoalIcons.calendar),
      onPressed: () {},
      child: const Text('Journey'),
    ),
  ],
);

@CharcoalComponentPreview(name: 'Toast and snackbar', size: Size(520, 300))
Widget charcoalFeedbackPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    const CharcoalToast(
      leading: CharcoalIcon(CharcoalIcons.checkCircle),
      message: 'Changes saved',
    ),
    const SizedBox(height: 24),
    CharcoalToast(
      action: CharcoalLinkButton(onPressed: () {}, child: const Text('Retry')),
      message: 'Could not finish the action',
      variant: CharcoalToastVariant.error,
    ),
    const SizedBox(height: 24),
    CharcoalSnackBar(
      action: CharcoalLinkButton(onPressed: () {}, child: const Text('Undo')),
      message: 'Item removed',
    ),
  ],
);
