import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../agent_example_navigator.dart';

final class AgentDemoAppShell<T> extends StatelessWidget {
  const AgentDemoAppShell({
    required this.appKey,
    required this.appLabel,
    required this.brandColor,
    required this.brandForeground,
    required this.brandMark,
    required this.tabItems,
    required this.content,
    required this.onTabSelected,
    required this.pageKey,
    required this.selectedTab,
    required this.title,
    this.leading,
    this.showTabBar = true,
    this.trailing,
    super.key,
  });

  final String appKey;
  final String appLabel;
  final Color brandColor;
  final Color brandForeground;
  final String brandMark;
  final List<CharcoalTabItem<T>> tabItems;
  final Widget content;
  final Widget? leading;
  final ValueChanged<T> onTabSelected;
  final String pageKey;
  final T selectedTab;
  final bool showTabBar;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: appLabel,
    child: ColoredBox(
      color: CharcoalTheme.of(context).colors.backgroundDefault,
      child: Column(
        children: <Widget>[
          CharcoalNavigationBar(
            key: ValueKey<String>('agent-$appKey-navigation-bar'),
            leading:
                leading ??
                _BrandMark(
                  background: brandColor,
                  foreground: brandForeground,
                  mark: brandMark,
                ),
            semanticLabel: '$title navigation',
            title: Text(title),
            trailing: trailing,
          ),
          Expanded(
            child: AgentExamplePageScrollView(
              storageKey: 'agent-$appKey-page-scroll-$pageKey',
              child: content,
            ),
          ),
          if (showTabBar)
            CharcoalTabBar<T>(
              items: tabItems,
              onChanged: onTabSelected,
              semanticLabel: '$appLabel primary destinations',
              value: selectedTab,
            ),
        ],
      ),
    ),
  );
}

final class AgentDemoBackButton extends StatelessWidget {
  const AgentDemoBackButton({
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => CharcoalIconButton(
    icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
    onPressed: onPressed,
    semanticLabel: semanticLabel,
    size: CharcoalIconButtonSize.small,
  );
}

final class _BrandMark extends StatelessWidget {
  const _BrandMark({
    required this.background,
    required this.foreground,
    required this.mark,
  });

  final Color background;
  final Color foreground;
  final String mark;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        CharcoalTheme.of(context).dimensions.radius.oval,
      ),
      color: background,
    ),
    child: SizedBox.square(
      dimension: 30,
      child: Center(
        child: Text(
          mark,
          style: CharcoalTheme.of(context).textStyles.captionSmall
              .copyWith(color: foreground, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
