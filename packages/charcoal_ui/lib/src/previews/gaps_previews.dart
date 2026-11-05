import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../admin.dart';
import '../../next.dart';
import 'next_preview_support.dart';

@CharcoalNextComponentPreview(name: 'Text and icon tones', size: Size(420, 520))
Widget charcoalTonesPreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    for (final tone in CharcoalTextTone.values)
      if (!tone.name.startsWith('on')) CharcoalText(tone.name, tone: tone),
    const CharcoalGap(CharcoalSpace.md),
    CharcoalWrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (final tone in CharcoalIconTone.values)
          if (!tone.name.startsWith('on'))
            CharcoalIconView(CharcoalIcons.lock, tone: tone, size: CharcoalIconSize.lg),
      ],
    ),
    const CharcoalGap(CharcoalSpace.md),
    const CharcoalCodeBlock('{\n  "feature": "checkout",\n  "enabled": true\n}'),
  ],
);

@CharcoalNextComponentPreview(name: 'Admin page frame', size: Size(900, 420))
Widget charcoalPagePreview() => SizedBox(
  height: 380,
  child: CharcoalPage(
    title: 'Users',
    subtitle: 'Accounts and quotas',
    showBack: true,
    actions: <Widget>[CharcoalButton(onPressed: () {}, child: const Text('Invite'))],
    child: CharcoalList(
      children: <Widget>[
        CharcoalListRow(title: 'Alice', subtitle: 'alice@example.com', onPressed: () {}),
      ],
    ),
  ),
);

@CharcoalNextComponentPreview(name: 'Brand, badge, secret box', size: Size(420, 360))
Widget charcoalBadgePreview() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const CharcoalWrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        CharcoalBrandMark('M'),
        CharcoalBadge('Owner'),
        CharcoalBadge('Banned', tone: CharcoalBadgeTone.negative),
      ],
    ),
    const CharcoalGap(CharcoalSpace.md),
    CharcoalCodeBlock(
      '••••••••••••',
      field: true,
      maxLines: 1,
      tone: CharcoalTextTone.secondary,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.copy),
        semanticLabel: 'Copy',
        onPressed: () {},
      ),
    ),
    const CharcoalGap(CharcoalSpace.md),
    const CharcoalInfoRows([('Email', 'alice@example.com')]),
  ],
);
