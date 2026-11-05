import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

final class _ColorsPageState extends State<ColorsPage> {
  String _catalog = 'applied';

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final entries = switch (_catalog) {
      'primitive' => CharcoalPrimitiveColors.entries,
      'brand' => CharcoalBrandColors.entries,
      _ => theme.colors.entries,
    };
    final groups = _group(entries);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'The complete generated V2 palette. Applied colors follow the active light or dark theme.',
          eyebrow: 'FOUNDATION · COLOR',
          title: 'Color catalog',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) => Align(
            alignment: Alignment.centerLeft,
            child: CharcoalSegmentedControl<String>(
              fullWidth: constraints.maxWidth < 420,
              onChanged: (value) => setState(() => _catalog = value),
              segments: const <CharcoalSegment<String>>[
                CharcoalSegment<String>(
                  child: Text('Applied'),
                  value: 'applied',
                ),
                CharcoalSegment<String>(
                  child: Text('Primitive'),
                  value: 'primitive',
                ),
                CharcoalSegment<String>(child: Text('Brand'), value: 'brand'),
              ],
              semanticLabel: 'Color catalog kind',
              value: _catalog,
            ),
          ),
        ),
        const SizedBox(height: 20),
        for (final group in groups.entries) ...<Widget>[
          ShowcaseCard(
            description: '${group.value.length} generated V2 color tokens.',
            eyebrow: _catalog.toUpperCase(),
            title: displayTokenName(group.key),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final entry in group.value) _ColorTokenTile(entry: entry),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Map<String, List<CharcoalColorTokenEntry>> _group(
    List<CharcoalColorTokenEntry> entries,
  ) {
    final groups = <String, List<CharcoalColorTokenEntry>>{};
    for (final entry in entries) {
      final withoutCategory = entry.path.substring(entry.path.indexOf('.') + 1);
      final group = withoutCategory.split('/').first;
      groups.putIfAbsent(group, () => <CharcoalColorTokenEntry>[]).add(entry);
    }
    final keys = groups.keys.toList()..sort();
    return <String, List<CharcoalColorTokenEntry>>{
      for (final key in keys) key: groups[key]!,
    };
  }
}

final class _ColorTokenTile extends StatelessWidget {
  const _ColorTokenTile({required this.entry});

  final CharcoalColorTokenEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final shortPath = entry.path.substring(entry.path.indexOf('.') + 1);
    final argb = entry.value
        .toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase();
    return Semantics(
      label: 'Color token ${entry.path}',
      child: SizedBox(
        width: 180,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.borderSecondary),
            borderRadius: BorderRadius.circular(10),
            color: theme.colors.backgroundDefault,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.borderSecondary),
                    borderRadius: BorderRadius.circular(8),
                    color: entry.value,
                  ),
                  child: const SizedBox.square(dimension: 38),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        shortPath,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textDefault,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#$argb',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textTertiaryDefault,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
