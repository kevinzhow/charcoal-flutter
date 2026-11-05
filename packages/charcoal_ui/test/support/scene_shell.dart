import 'package:charcoal_ui/next.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';

/// Scenes for the app shell and foundation: scaffold, text defaults, layout helpers, clickable in
/// every state. Component families add their own `scene_<family>.dart` and register it in
/// `scenes.dart`.
final shellScenes = <CharcoalScene>[
  CharcoalScene(
    name: 'shell',
    build: (context) => _ShellScene(onPressed: () {}),
  ),
];

class _ShellScene extends StatelessWidget {
  const _ShellScene({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalScaffold(
      body: CharcoalPadding.all(
        CharcoalSpace.lg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Title', style: theme.style(CharcoalTextRole.pageTitle)),
            const CharcoalGap(CharcoalSpace.md),
            const Text('Body text uses the ambient default style.'),
            const CharcoalGap(CharcoalSpace.md),
            _Row(label: 'Normal', onPressed: onPressed),
            const CharcoalGap(CharcoalSpace.sm),
            _Row(label: 'Selected', onPressed: onPressed, selected: true),
            const CharcoalGap(CharcoalSpace.sm),
            const _Row(label: 'Disabled', onPressed: null),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.onPressed, this.selected = false});

  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    return CharcoalClickable(
      onPressed: onPressed,
      selected: selected,
      semanticLabel: label,
      builder: (context, states) => DecoratedBox(
        decoration: BoxDecoration(
          color: resolveCharcoalStateColor(
            states,
            normal: colors.surface,
            hovered: colors.surfaceHover,
            pressed: colors.surfacePress,
            disabled: colors.surfaceDisabled,
            selected: colors.surfaceSecondary,
          ),
          border: Border.all(color: colors.border, width: theme.borders.hairline),
          borderRadius: BorderRadius.circular(theme.radius.md),
        ),
        child: CharcoalPadding.all(
          CharcoalSpace.md,
          child: Text(
            label,
            style: theme.style(
              CharcoalTextRole.bodyBold,
              color: states.contains(WidgetState.disabled) ? colors.textDisabled : colors.text,
            ),
          ),
        ),
      ),
    );
  }
}
