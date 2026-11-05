import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../registry.dart';
import 'sidebar.dart';

final class ShowcaseMobileNavigationPanel extends StatelessWidget {
  const ShowcaseMobileNavigationPanel({
    required this.onSelected,
    required this.selected,
    super.key,
  });

  final ValueChanged<String> onSelected;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Showcase navigation',
      child: ColoredBox(
        color: theme.colors.backgroundDefault,
        child: SingleChildScrollView(
          key: const ValueKey<String>('showcase-mobile-navigation-scroll'),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
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
                            'Flutter · V2 Showcase',
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
              const SizedBox(height: 18),
              for (final section in showcaseSections) ...<Widget>[
                if (section.$1.label.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 15, 12, 7),
                    child: Text(
                      section.$1.label,
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textTertiaryDefault,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                for (final item in section.$2) ...<Widget>[
                  SizedBox(
                    height: 48,
                    child: CharcoalNavigationItem(
                      key: ValueKey<String>('nav-${item.title}'),
                      leading: CharcoalIcon(item.icon),
                      onPressed: () => onSelected(item.id),
                      selected: selected == item.id,
                      semanticLabel: item.title,
                      trailing: selected == item.id
                          ? const CharcoalIcon(CharcoalIcons.check)
                          : null,
                      child: Text(item.title),
                    ),
                  ),
                  SizedBox(height: theme.dimensions.space.component10),
                ],
              ],
              const SizedBox(height: 14),
              const ShowcaseSidebarStatusCard(),
            ],
          ),
        ),
      ),
    );
  }
}
