import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

/// The theme contract of the active pack: colour roles, scales and metric groups.
final class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ShowcasePageIntro(
        description:
            'The frozen theme contract as the active pack fills it: colour roles by family, '
            'the spacing, radius, border and size scales, and the per-family metrics.',
        eyebrow: 'FOUNDATION · THEME ROLES',
        title: 'Theme roles',
      ),
      SizedBox(height: 24),
      _RoleCards(),
    ],
  );
}

class _RoleCards extends StatelessWidget {
  const _RoleCards();

  @override
  Widget build(BuildContext context) {
    final pack = CharcoalTheme.of(context).pack;
    final groups = <String, List<MapEntry<String, Color>>>{};
    for (final entry in pack.colors.toMap().entries) {
      final value = entry.value;
      if (value is! Color) continue;
      final family = entry.key.split(RegExp('(?=[A-Z])')).first;
      groups
          .putIfAbsent(family, () => <MapEntry<String, Color>>[])
          .add(MapEntry(entry.key, value));
    }
    return ShowcaseCatalogGrid(
      children: <Widget>[
        for (final group in groups.entries)
          ShowcaseCard(
            description: '${group.value.length} roles.',
            eyebrow: 'COLOR',
            title: displayTokenName(group.key),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final entry in group.value)
                  _Swatch(name: entry.key, color: entry.value),
              ],
            ),
          ),
        ShowcaseCard(
          description: 'Spacing, radius, border and size scales.',
          eyebrow: 'SCALES',
          title: 'Dimensions',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Scale(title: 'space', values: pack.space.toMap()),
              const CharcoalGap(CharcoalSpace.lg),
              _Scale(title: 'radius', values: pack.radius.toMap()),
              const CharcoalGap(CharcoalSpace.lg),
              _Scale(title: 'borders', values: pack.borders.toMap()),
              const CharcoalGap(CharcoalSpace.lg),
              _Scale(title: 'sizes', values: pack.sizes.toMap()),
            ],
          ),
        ),
        ShowcaseCard(
          description: 'Per-family measures read by the components.',
          eyebrow: 'METRICS',
          title: 'Field metrics',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Scale(
                title: 'textField',
                values: pack.metrics.textField.toMap(),
              ),
              const CharcoalGap(CharcoalSpace.lg),
              _Scale(title: 'textArea', values: pack.metrics.textArea.toMap()),
              const CharcoalGap(CharcoalSpace.lg),
              _Scale(title: 'field', values: pack.metrics.field.toMap()),
              const CharcoalGap(CharcoalSpace.lg),
              _Scale(title: 'dropdown', values: pack.metrics.dropdown.toMap()),
            ],
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 148,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: theme.colors.border,
                width: theme.borders.hairline,
              ),
              borderRadius: BorderRadius.circular(theme.radius.md),
            ),
            child: SizedBox(
              height: theme.sizes.controlLg,
              width: double.infinity,
            ),
          ),
          const CharcoalGap(CharcoalSpace.xs),
          CharcoalText(name, role: CharcoalTextRole.captionBold, maxLines: 2),
        ],
      ),
    );
  }
}

class _Scale extends StatelessWidget {
  const _Scale({required this.title, required this.values});

  final String title;
  final Map<String, Object?> values;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      CharcoalText(title, role: CharcoalTextRole.bodyBold),
      const CharcoalGap(CharcoalSpace.xs),
      for (final entry in values.entries)
        Row(
          children: <Widget>[
            Expanded(
              child: CharcoalText(entry.key, role: CharcoalTextRole.caption),
            ),
            CharcoalText('${entry.value}', role: CharcoalTextRole.captionMono),
          ],
        ),
    ],
  );
}
