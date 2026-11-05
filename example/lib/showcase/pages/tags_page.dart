import 'package:charcoal_ui/next.dart'
    show
        CharcoalChip,
        CharcoalStatusDot,
        CharcoalTagItem,
        CharcoalTagItemSize,
        CharcoalTagItemStatus,
        CharcoalTone;
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

final class _TagsPageState extends State<TagsPage> {
  bool _active = true;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'Tag items, status chips and status dots across sizes, states and tones.',
        eyebrow: 'COMPONENTS · TAGS',
        title: 'Tags and status',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          ShowcaseCard(
            description:
                'Controlled normal, active, inactive and disabled tags.',
            eyebrow: 'TAG ITEM',
            title: 'Tag item',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final size in CharcoalTagItemSize.values)
                  CharcoalTagItem(
                    label: '#${size.name}',
                    onPressed: showcaseNoop,
                    size: size,
                  ),
                CharcoalTagItem(
                  key: const ValueKey<String>('tag-item-toggle'),
                  label: '#original',
                  onPressed: () => setState(() => _active = !_active),
                  status: _active
                      ? CharcoalTagItemStatus.active
                      : CharcoalTagItemStatus.normal,
                ),
                const CharcoalTagItem(
                  label: '#inactive',
                  onPressed: showcaseNoop,
                  status: CharcoalTagItemStatus.inactive,
                ),
                const CharcoalTagItem(
                  label: '#創作',
                  onPressed: showcaseNoop,
                  translatedLabel: 'original work',
                ),
                const CharcoalTagItem(label: '#disabled', onPressed: null),
              ],
            ),
          ),
          ShowcaseCard(
            description:
                'Non-interactive chips in every tone, plus the monospace form.',
            eyebrow: 'CHIP',
            title: 'Chip',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final tone in CharcoalTone.values)
                  CharcoalChip(tone.name, tone: tone),
                const CharcoalChip('id_8f3a', monospace: true),
              ],
            ),
          ),
          ShowcaseCard(
            description: 'The leading dot of a row; it reserves the same slot as a selection box.',
            eyebrow: 'STATUS DOT',
            title: 'Status dot',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                for (final tone in CharcoalTone.values) CharcoalStatusDot(tone),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
