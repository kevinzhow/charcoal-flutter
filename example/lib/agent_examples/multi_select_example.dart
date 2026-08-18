import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

enum _ExportContent { originalFiles, sourceMetadata, previewImages }

/// A named, validated multi-selection group with one parent-owned value set.
final class AgentMultiSelectExample extends StatefulWidget {
  const AgentMultiSelectExample({super.key});

  @override
  State<AgentMultiSelectExample> createState() =>
      _AgentMultiSelectExampleState();
}

final class _AgentMultiSelectExampleState
    extends State<AgentMultiSelectExample> {
  static const _options = <({String label, _ExportContent value})>[
    (label: 'Original files', value: _ExportContent.originalFiles),
    (label: 'Source metadata', value: _ExportContent.sourceMetadata),
    (label: 'Preview images', value: _ExportContent.previewImages),
  ];

  Set<_ExportContent> _selected = <_ExportContent>{
    _ExportContent.originalFiles,
  };
  bool _reviewed = false;
  String? _result;

  bool get _invalid => _reviewed && _selected.isEmpty;

  String get _selectionSummary {
    final count = _selected.length;
    return '$count content ${count == 1 ? 'type' : 'types'} selected.';
  }

  void _setSelected(_ExportContent value, {required bool selected}) {
    final next = Set<_ExportContent>.of(_selected);
    selected ? next.add(value) : next.remove(value);
    setState(() {
      _selected = next;
      _reviewed = false;
      _result = null;
    });
  }

  void _prepareExport() {
    setState(() {
      _reviewed = true;
      _result = _selected.isEmpty
          ? null
          : 'Export prepared with ${_selected.length} content '
                '${_selected.length == 1 ? 'type' : 'types'}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Prepare download', style: theme.textStyles.headingS),
        SizedBox(height: space.layout40),
        const CharcoalFieldLabel(
          label: 'Export contents',
          required: true,
          requiredText: 'Required',
        ),
        SizedBox(height: space.component20),
        Semantics(
          container: true,
          explicitChildNodes: true,
          label: 'Export content options',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (var index = 0; index < _options.length; index++) ...<Widget>[
                CharcoalMultiSelect(
                  invalid: _invalid,
                  label: Text(_options[index].label),
                  onChanged: (selected) =>
                      _setSelected(_options[index].value, selected: selected),
                  selected: _selected.contains(_options[index].value),
                ),
                if (index != _options.length - 1)
                  SizedBox(height: space.component30),
              ],
            ],
          ),
        ),
        SizedBox(height: space.component20),
        Semantics(
          liveRegion: _invalid || _result != null,
          child: Text(
            _invalid
                ? 'Select at least one content type.'
                : _result ?? _selectionSummary,
            style: theme.textStyles.captionMedium.copyWith(
              color: _invalid
                  ? theme.colors.textNegativeDefault
                  : theme.colors.textSecondaryDefault,
            ),
          ),
        ),
        SizedBox(height: space.layout40),
        CharcoalButton(
          fullWidth: true,
          onPressed: _prepareExport,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Prepare export'),
        ),
      ],
    );
  }
}
