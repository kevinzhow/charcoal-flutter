import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../registry.dart';

final class ShowcaseSidebar extends StatelessWidget {
  const ShowcaseSidebar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 247,
      child: DecoratedBox(
        decoration: BoxDecoration(color: theme.colors.backgroundDefault),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colors.containerPrimaryDefault,
                      ),
                      child: SizedBox.square(
                        dimension: 40,
                        child: Center(
                          child: Text(
                            'C',
                            style: theme.textStyles.headingXxs.copyWith(
                              color: theme.colors.textOnPrimaryDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Charcoal UI',
                            style: theme.textStyles.bodyBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                          Text(
                            'Flutter · V2',
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      for (final section in showcaseSections) ...<Widget>[
                        if (section.$1.label.isNotEmpty) ...<Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 13, 12, 7),
                            child: Text(
                              section.$1.label,
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textTertiaryDefault,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                        for (final item in section.$2) ...<Widget>[
                          CharcoalNavigationItem(
                            key: ValueKey<String>('nav-${item.title}'),
                            leading: CharcoalIcon(item.icon),
                            selected: selected == item.id,
                            semanticLabel: item.title,
                            onPressed: () => onSelected(item.id),
                            child: Text(item.title),
                          ),
                          SizedBox(height: theme.dimensions.space.component10),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const ShowcaseSidebarStatusCard(),
            ],
          ),
        ),
      ),
    );
  }
}

String get _renderingBackendName {
  if (!kIsWeb) {
    return 'Native';
  }
  if (isSkwasm) {
    return 'skwasm';
  }
  if (isCanvasKit) {
    return 'CanvasKit';
  }
  return 'Unknown web renderer';
}

final class ShowcaseSidebarStatusCard extends StatelessWidget {
  const ShowcaseSidebarStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final renderingBackend = _renderingBackendName;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colors.containerSecondaryDefault,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: theme.colors.containerPositiveDefault,
                  ),
                  child: const SizedBox.square(dimension: 8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tokens synchronized',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Rendering backend',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textSecondaryDefault,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              renderingBackend,
              key: const ValueKey<String>('showcase-rendering-backend'),
              style: theme.textStyles.captionMediumBold.copyWith(
                color: theme.colors.textDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class ShowcaseSidebarDivider extends StatelessWidget {
  const ShowcaseSidebarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return RepaintBoundary(
      key: const ValueKey<String>('showcase-sidebar-divider'),
      child: SizedBox(
        width: 1,
        height: double.infinity,
        child: ColoredBox(color: theme.colors.borderSecondary),
      ),
    );
  }
}
