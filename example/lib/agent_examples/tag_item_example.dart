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
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final selectedCount = _selectedTags.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Artwork filters', style: theme.textStyles.headingS),
        SizedBox(height: space.component20),
        Semantics(
          liveRegion: true,
          child: Text(
            '$selectedCount ${selectedCount == 1 ? 'filter' : 'filters'} selected',
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ),
        SizedBox(height: space.layout30),
        Wrap(
          spacing: space.component20,
          runSpacing: space.component20,
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
