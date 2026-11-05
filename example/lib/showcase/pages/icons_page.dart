import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

enum _IconCatalogKind { regular, solid, compact, color }

final class IconsPage extends StatefulWidget {
  const IconsPage({super.key});

  @override
  State<IconsPage> createState() => _IconsPageState();
}

final class _IconsPageState extends State<IconsPage> {
  _IconCatalogKind _kind = _IconCatalogKind.regular;

  List<CharcoalIconData> get _icons => switch (_kind) {
    _IconCatalogKind.regular => CharcoalIcons.values,
    _IconCatalogKind.solid => CharcoalSolidIcons.values,
    _IconCatalogKind.compact => <CharcoalIconData>[
      ...CharcoalIcons16.values,
      ...CharcoalSolidIcons16.values,
      ...CharcoalIcons20.values,
      ...CharcoalSolidIcons20.values,
    ],
    _IconCatalogKind.color => CharcoalColorIcons.values,
  };

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final icons = _icons;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'The complete generated Charcoal Icons V2 package: regular, solid, compact, and authored-color SVG sources.',
          eyebrow: 'FOUNDATION · ICONS',
          title: 'Icon catalog',
        ),
        SizedBox(height: theme.dimensions.space.layout40),
        LayoutBuilder(
          builder: (context, constraints) {
            final canFitFourUniformSegments = constraints.maxWidth >= 320;
            final useUniformMobileLayout =
                canFitFourUniformSegments && constraints.maxWidth < 620;
            final control = CharcoalSegmentedControl<_IconCatalogKind>(
              fullWidth: useUniformMobileLayout,
              onChanged: (value) => setState(() => _kind = value),
              semanticLabel: 'Icon catalog style',
              value: _kind,
              segments: const <CharcoalSegment<_IconCatalogKind>>[
                CharcoalSegment(
                  value: _IconCatalogKind.regular,
                  child: Text(
                    'Regular 24',
                    key: ValueKey<String>('icon-catalog-regular'),
                  ),
                ),
                CharcoalSegment(
                  value: _IconCatalogKind.solid,
                  child: Text(
                    'Solid 24',
                    key: ValueKey<String>('icon-catalog-solid'),
                  ),
                ),
                CharcoalSegment(
                  value: _IconCatalogKind.compact,
                  child: Text(
                    '16 + 20',
                    key: ValueKey<String>('icon-catalog-compact'),
                  ),
                ),
                CharcoalSegment(
                  value: _IconCatalogKind.color,
                  child: Text(
                    'Color',
                    key: ValueKey<String>('icon-catalog-color'),
                  ),
                ),
              ],
            );
            return canFitFourUniformSegments
                ? Align(alignment: Alignment.centerLeft, child: control)
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: control,
                  );
          },
        ),
        SizedBox(height: theme.dimensions.space.layout30),
        Text(
          '${icons.length} generated assets',
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component30),
        Wrap(
          spacing: theme.dimensions.space.component25,
          runSpacing: theme.dimensions.space.component25,
          children: <Widget>[
            for (final icon in icons) _IconCatalogTile(icon: icon),
          ],
        ),
      ],
    );
  }
}

final class _IconCatalogTile extends StatelessWidget {
  const _IconCatalogTile({required this.icon});

  final CharcoalIconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 156,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          color: theme.colors.backgroundDefault,
        ),
        child: Padding(
          padding: EdgeInsets.all(theme.dimensions.space.component25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: theme.dimensions.space.targetL,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CharcoalIcon(
                    icon,
                    color: icon.style == CharcoalIconStyle.color
                        ? null
                        : theme.colors.iconDefault,
                    size: theme.dimensions.space.component50,
                  ),
                ),
              ),
              SizedBox(height: theme.dimensions.space.component20),
              Text(
                icon.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              Text(
                '${formatShowcaseNumber(icon.nativeSize)} px · ${icon.style.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textTertiaryDefault,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
