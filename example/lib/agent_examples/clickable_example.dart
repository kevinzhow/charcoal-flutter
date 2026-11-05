import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// An audited whole-surface action for a case with no higher-level component.
final class AgentClickableSurfaceExample extends StatefulWidget {
  const AgentClickableSurfaceExample({super.key});

  @override
  State<AgentClickableSurfaceExample> createState() =>
      _AgentClickableSurfaceExampleState();
}

final class _AgentClickableSurfaceExampleState
    extends State<AgentClickableSurfaceExample> {
  String _status = 'No project opened';

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Whole-surface action',
          style: theme.style(CharcoalTextRole.headingS),
        ),
        SizedBox(height: space.sm),
        Text(_status, style: theme.style(CharcoalTextRole.captionMedium)),
        SizedBox(height: space.xl),
        CharcoalClickable(
          onPressed: () => setState(() => _status = 'Moonlit Lake opened'),
          semanticLabel: 'Open Moonlit Lake project',
          builder: (context, states) {
            final focused = states.contains(WidgetState.focused);
            final hovered = states.contains(WidgetState.hovered);
            final pressed = states.contains(WidgetState.pressed);
            final background = pressed
                ? theme.colors.fillSecondaryPress
                : hovered || focused
                ? theme.colors.fillSecondaryHover
                : theme.colors.background;
            final border = focused
                ? theme.colors.borderFocus
                : pressed
                ? theme.colors.border
                : hovered
                ? theme.colors.border
                : theme.colors.borderSubtle;
            return AnimatedContainer(
              curve: CharcoalTheme.of(context).motion.curve,
              duration: CharcoalTheme.of(context)
                  .duration(context, CharcoalTheme.of(context).motion.fast),
              constraints: BoxConstraints(minHeight: theme.sizes.controlLg),
              padding: EdgeInsets.all(space.lg),
              decoration: BoxDecoration(
                border: Border.all(
                  color: border,
                  width: theme.borders.hairline,
                ),
                borderRadius: BorderRadius.circular(theme.radius.md),
                color: background,
              ),
              child: Row(
                children: <Widget>[
                  CharcoalIcon(CharcoalIcons.image, color: theme.colors.icon),
                  SizedBox(width: space.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Moonlit Lake',
                          style: theme.style(CharcoalTextRole.bodyLargeBold),
                        ),
                        SizedBox(height: space.xs),
                        Text(
                          'Illustration · updated today',
                          style: theme
                              .style(CharcoalTextRole.caption)
                              .copyWith(color: theme.colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: space.sm),
                  CharcoalIcon(
                    CharcoalIcons.chevronRight,
                    color: theme.colors.iconTertiary,
                    size: 16,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
