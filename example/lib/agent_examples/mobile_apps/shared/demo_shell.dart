import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

final class AgentDemoBottomItem {
  const AgentDemoBottomItem(this.label, this.icon);

  final CharcoalIconData icon;
  final String label;
}

final class AgentDemoAppShell extends StatelessWidget {
  const AgentDemoAppShell({
    required this.appKey,
    required this.appLabel,
    required this.brandColor,
    required this.brandForeground,
    required this.brandMark,
    required this.bottomItems,
    required this.content,
    required this.onBottomItemSelected,
    required this.selectedBottomIndex,
    required this.title,
    this.leading,
    this.showBottomNavigation = true,
    this.trailing,
    super.key,
  });

  final String appKey;
  final String appLabel;
  final Color brandColor;
  final Color brandForeground;
  final String brandMark;
  final List<AgentDemoBottomItem> bottomItems;
  final Widget content;
  final Widget? leading;
  final ValueChanged<int> onBottomItemSelected;
  final int selectedBottomIndex;
  final bool showBottomNavigation;
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
            child: SingleChildScrollView(
              key: ValueKey<String>('agent-$appKey-page-scroll'),
              child: content,
            ),
          ),
          if (showBottomNavigation)
            AgentDemoBottomBar(
              appKey: appKey,
              items: bottomItems,
              onSelected: onBottomItemSelected,
              selectedIndex: selectedBottomIndex,
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

final class AgentDemoBottomBar extends StatelessWidget {
  const AgentDemoBottomBar({
    required this.appKey,
    required this.items,
    required this.onSelected,
    required this.selectedIndex,
    super.key,
  });

  final String appKey;
  final List<AgentDemoBottomItem> items;
  final ValueChanged<int> onSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colors.borderSecondary,
            width: theme.dimensions.borderWidth.m,
          ),
        ),
        color: theme.colors.backgroundDefault,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: <Widget>[
              for (final (index, item) in items.indexed)
                Expanded(
                  child: _BottomDestination(
                    key: ValueKey<String>(
                      'agent-$appKey-nav-${item.label.toLowerCase()}',
                    ),
                    icon: item.icon,
                    label: item.label,
                    onPressed: () => onSelected(index),
                    selected: selectedIndex == index,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _BottomDestination extends StatelessWidget {
  const _BottomDestination({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.selected,
    super.key,
  });

  final CharcoalIconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: label,
      selected: selected,
      builder: (context, states) {
        final active = selected || states.contains(WidgetState.focused);
        return ColoredBox(
          color: states.contains(WidgetState.pressed)
              ? theme.colors.containerSecondaryDefaultA
              : theme.colors.backgroundDefault,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: space.component10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CharcoalIcon(
                  icon,
                  color: active
                      ? theme.colors.iconDefault
                      : theme.colors.iconTertiaryDefault,
                  size: 18,
                ),
                SizedBox(height: space.component10),
                Text(
                  label,
                  maxLines: 1,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: active
                        ? theme.colors.textDefault
                        : theme.colors.textTertiaryDefault,
                    fontSize: 9,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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
