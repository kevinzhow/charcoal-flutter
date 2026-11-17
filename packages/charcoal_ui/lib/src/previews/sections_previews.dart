import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

// Previews for the page-section parts of the admin redesign: section card and danger zone.

@CharcoalComponentPreview(name: 'Section card · Danger zone', size: Size(640, 520))
Widget charcoalSectionCardPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalSectionCard(
      title: 'Rules',
      caption: 'Checked from top to bottom; the first match wins',
      actions: <Widget>[
        CharcoalButton(
          size: CharcoalButtonSize.small,
          variant: CharcoalButtonVariant.primary,
          leading: const CharcoalIcon(CharcoalIcons.add),
          onPressed: () {},
          child: const Text('Add rule'),
        ),
      ],
      dividers: true,
      children: const <Widget>[
        CharcoalText('Staff → Whisper large-v3'),
        CharcoalText('Beta testers, 30% → Turbo'),
      ],
    ),
    const CharcoalGap(CharcoalSpace.lg),
    CharcoalDangerZone(
      title: 'Delete flag',
      description: 'Its 2 rules are deleted too and cannot be restored.',
      actionLabel: 'Delete',
      onPressed: () {},
    ),
  ],
);
