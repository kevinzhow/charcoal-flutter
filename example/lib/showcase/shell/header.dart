import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

final class ShowcaseHeader extends StatelessWidget {
  const ShowcaseHeader({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.title,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: <Widget>[
              Text(
                title,
                style: theme.textStyles.headingXxs.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              const Spacer(),
              CharcoalSwitch(
                key: const ValueKey<String>('dark-mode-switch'),
                value: darkMode,
                onChanged: onDarkModeChanged,
                label: const Text('Dark mode'),
              ),
              const SizedBox(width: 20),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colors.containerDiscoveryDefault,
                ),
                child: SizedBox.square(
                  dimension: 36,
                  child: Center(
                    child: Text(
                      'V2',
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textOnDiscoveryDefault,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class ShowcaseMobileHeader extends StatelessWidget {
  const ShowcaseMobileHeader({
    super.key,
    required this.darkMode,
    required this.navigationOpen,
    required this.onDarkModeChanged,
    required this.onNavigationToggle,
    required this.title,
  });

  final bool darkMode;
  final bool navigationOpen;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onNavigationToggle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: <Widget>[
              SizedBox.square(
                dimension: 48,
                child: CharcoalIconButton(
                  key: const ValueKey<String>(
                    'showcase-mobile-navigation-toggle',
                  ),
                  icon: CharcoalIcon(
                    navigationOpen ? CharcoalIcons.x : CharcoalIcons.list,
                  ),
                  onPressed: onNavigationToggle,
                  selected: navigationOpen,
                  semanticLabel: navigationOpen
                      ? 'Close navigation'
                      : 'Open navigation',
                  size: CharcoalIconButtonSize.medium,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  key: const ValueKey<String>('showcase-mobile-title'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.bodyBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox.square(
                dimension: 48,
                child: CharcoalIconButton(
                  key: const ValueKey<String>('showcase-mobile-dark-mode'),
                  icon: const CharcoalIcon(CharcoalIcons.sun),
                  onPressed: () => onDarkModeChanged(!darkMode),
                  selected: darkMode,
                  semanticLabel: darkMode ? 'Use light mode' : 'Use dark mode',
                  size: CharcoalIconButtonSize.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
