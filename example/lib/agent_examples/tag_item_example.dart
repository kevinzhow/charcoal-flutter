import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A compact, caller-controlled tag filter collection.
final class AgentTagItemExample extends StatefulWidget {
  const AgentTagItemExample({super.key});

  @override
  State<AgentTagItemExample> createState() => _AgentTagItemExampleState();
}

final class _AgentTagItemExampleState extends State<AgentTagItemExample> {
  static const _tags = <({String id, String label, String? translation})>[
    (id: 'landscape', label: '#landscape', translation: null),
    (id: 'original', label: '#オリジナル', translation: 'original work'),
    (id: 'character', label: '#character', translation: null),
    (id: 'background', label: '#background-art', translation: null),
  ];

  final Set<String> _selectedTags = <String>{'landscape'};

  void _toggleTag(String id) {
    setState(() {
      if (!_selectedTags.add(id)) {
        _selectedTags.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedTags.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalText('Artwork filters', role: CharcoalTextRole.headingS),
        const CharcoalGap(CharcoalSpace.sm),
        Semantics(
          liveRegion: true,
          child: CharcoalText(
            '$selectedCount ${selectedCount == 1 ? 'filter' : 'filters'} selected',
            role: CharcoalTextRole.captionMedium,
            tone: CharcoalTextTone.secondary,
          ),
        ),
        const CharcoalGap(CharcoalSpace.lg),
        CharcoalWrap(
          children: <Widget>[
            for (final tag in _tags)
              CharcoalTagItem(
                label: tag.label,
                onPressed: () => _toggleTag(tag.id),
                semanticLabel: '${tag.id} tag filter',
                status: _selectedTags.contains(tag.id)
                    ? CharcoalTagItemStatus.active
                    : CharcoalTagItemStatus.normal,
                translatedLabel: tag.translation,
              ),
          ],
        ),
      ],
    );
  }
}
