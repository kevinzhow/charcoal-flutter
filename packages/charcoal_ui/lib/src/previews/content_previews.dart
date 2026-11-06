import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Feed post on a grey page', size: Size(420, 560))
Widget charcoalFeedPostPreview() => CharcoalScaffold(
  background: CharcoalPageBackground.secondary,
  navigationBar: CharcoalNavigationBar(
    title: const Text('Feed'),
    trailing: CharcoalIconButton(
      badge: '2',
      icon: const CharcoalIcon(CharcoalIcons.bell),
      onPressed: () {},
      semanticLabel: 'Notifications, 2 unread',
      size: CharcoalIconButtonSize.small,
    ),
  ),
  body: CharcoalPadding.all(
    CharcoalSpace.lg,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const CharcoalProgressBar(value: 0.5, semanticLabel: 'Story 1 of 2'),
        const CharcoalGap(CharcoalSpace.md),
        CharcoalCard(
          padding: const CharcoalInset.only(),
          raised: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CharcoalClickable(
                onPressed: () {},
                semanticLabel: 'Open Aki Kondo profile',
                builder: (context, states) => CharcoalPressFeedback(
                  states: states,
                  child: CharcoalPadding.all(
                    CharcoalSpace.md,
                    child: const Row(
                      children: <Widget>[
                        CharcoalAvatar(
                          'Aki Kondo',
                          circular: true,
                          initials: 'AK',
                          tone: CharcoalTone.negative,
                        ),
                        CharcoalGap(CharcoalSpace.sm),
                        CharcoalText('Aki Kondo', role: CharcoalTextRole.captionMediumBold),
                      ],
                    ),
                  ),
                ),
              ),
              const CharcoalPlaceholderArtwork(seed: 0, semanticLabel: 'Abstract study'),
            ],
          ),
        ),
      ],
    ),
  ),
);

@CharcoalComponentPreview(name: 'Conversation and reply bar', size: Size(420, 360))
Widget charcoalConversationPreview() => CharcoalScaffold(
  background: CharcoalPageBackground.secondary,
  body: const CharcoalPadding(
    padding: CharcoalInset.all(CharcoalSpace.lg),
    child: Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: CharcoalMessageBubble('Is the print still available?'),
        ),
        CharcoalGap(CharcoalSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: CharcoalMessageBubble('Yes, two left.', outgoing: true),
        ),
        CharcoalGap(CharcoalSpace.xs),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: CharcoalLoadingSpinner.inline(semanticLabel: 'Sending message'),
        ),
      ],
    ),
  ),
  bottomBar: CharcoalBottomBar(
    child: Row(
      children: <Widget>[
        const Expanded(child: CharcoalText('Reply', tone: CharcoalTextTone.placeholder)),
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.send),
          onPressed: () {},
          semanticLabel: 'Send',
        ),
      ],
    ),
  ),
);
