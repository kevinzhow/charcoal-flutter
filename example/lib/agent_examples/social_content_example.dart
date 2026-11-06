import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Social content on a grey page: story progress, a post with an author header and placeholder
/// artwork, and a short conversation above a reply bar.
///
/// Every surface is a component: the raised card, the artwork, the message bubbles and the
/// bottom bar. The tappable author header gets its press feedback from `CharcoalPressFeedback`;
/// the example names no colour, size or text style.
final class AgentSocialContentExample extends StatefulWidget {
  const AgentSocialContentExample({super.key});

  @override
  State<AgentSocialContentExample> createState() =>
      _AgentSocialContentExampleState();
}

final class _AgentSocialContentExampleState
    extends State<AgentSocialContentExample> {
  final _messages = <({String text, bool outgoing})>[
    (text: 'Is the print still available?', outgoing: false),
    (text: 'Yes, two left.', outgoing: true),
  ];
  String _status = 'No profile opened';
  bool _liked = false;

  void _reply() {
    setState(() => _messages.add((text: 'I will take one.', outgoing: true)));
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const CharcoalProgressBar(value: 0.5, semanticLabel: 'Story 1 of 2'),
      const CharcoalGap(CharcoalSpace.sm),
      CharcoalText(_status, role: CharcoalTextRole.caption),
      const CharcoalGap(CharcoalSpace.md),
      CharcoalCard(
        padding: const CharcoalInset.only(),
        raised: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CharcoalPadding.all(
              CharcoalSpace.md,
              child: CharcoalClickable(
                onPressed: () => setState(() => _status = 'Aki Kondo opened'),
                semanticLabel: 'Open Aki Kondo profile',
                builder: (context, states) => CharcoalPressFeedback(
                  states: states,
                  child: const Row(
                    children: <Widget>[
                      CharcoalAvatar(
                        'Aki Kondo',
                        circular: true,
                        initials: 'AK',
                        tone: CharcoalTone.negative,
                      ),
                      CharcoalGap(CharcoalSpace.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CharcoalText(
                              'Aki Kondo',
                              role: CharcoalTextRole.captionMediumBold,
                            ),
                            CharcoalText(
                              '12 min · Kamakura',
                              role: CharcoalTextRole.caption,
                              tone: CharcoalTextTone.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const CharcoalPlaceholderArtwork(
              seed: 0,
              semanticLabel: 'Rain clouds over a field of colour',
            ),
            CharcoalPadding.all(
              CharcoalSpace.xs,
              child: Row(
                children: <Widget>[
                  CharcoalIconButton(
                    icon: const CharcoalIcon(CharcoalIcons.heart),
                    onPressed: () => setState(() => _liked = !_liked),
                    selected: _liked,
                    semanticLabel: _liked ? 'Unlike post' : 'Like post',
                    size: CharcoalIconButtonSize.small,
                  ),
                  CharcoalText(
                    _liked ? '129' : '128',
                    bold: true,
                    role: CharcoalTextRole.caption,
                    tone: CharcoalTextTone.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const CharcoalGap(CharcoalSpace.lg),
      for (final message in _messages) ...<Widget>[
        Align(
          alignment: message.outgoing
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: CharcoalMessageBubble(
            message.text,
            outgoing: message.outgoing,
          ),
        ),
        const CharcoalGap(CharcoalSpace.sm),
      ],
      CharcoalBottomBar(
        child: Row(
          children: <Widget>[
            const Expanded(
              child: CharcoalText(
                'Reply with a saved answer',
                tone: CharcoalTextTone.secondary,
              ),
            ),
            CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.send),
              onPressed: _reply,
              semanticLabel: 'Send saved reply',
            ),
          ],
        ),
      ),
    ],
  );
}
