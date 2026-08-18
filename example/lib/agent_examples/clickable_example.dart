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
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Whole-surface action', style: theme.textStyles.headingS),
        SizedBox(height: space.component20),
        Text(_status, style: theme.textStyles.captionMedium),
        SizedBox(height: space.layout40),
        CharcoalClickable(
          onPressed: () => setState(() => _status = 'Moonlit Lake opened'),
          semanticLabel: 'Open Moonlit Lake project',
          builder: (context, states) {
            final focused = states.contains(WidgetState.focused);
            final hovered = states.contains(WidgetState.hovered);
            final pressed = states.contains(WidgetState.pressed);
            final background = pressed
                ? theme.colors.containerSecondaryPressA
                : hovered || focused
                ? theme.colors.containerSecondaryHoverA
                : theme.colors.backgroundDefault;
            final border = focused
                ? theme.colors.borderFocus1
                : pressed
                ? theme.colors.borderPress
                : hovered
                ? theme.colors.borderHover
                : theme.colors.borderSecondary;
            return AnimatedContainer(
              curve: CharcoalMotion.standardCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                CharcoalMotion.fast,
              ),
              constraints: BoxConstraints(
                minHeight: theme.dimensions.space.targetL,
              ),
              padding: EdgeInsets.all(space.component30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: border,
                  width: theme.dimensions.borderWidth.m,
                ),
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: background,
              ),
              child: Row(
                children: <Widget>[
                  CharcoalIcon(
                    CharcoalIcons.image,
                    color: theme.colors.iconDefault,
                  ),
                  SizedBox(width: space.component30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Moonlit Lake', style: theme.textStyles.bodyBold),
                        SizedBox(height: space.component10),
                        Text(
                          'Illustration · updated today',
                          style: theme.textStyles.captionSmall.copyWith(
                            color: theme.colors.textSecondaryDefault,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: space.component20),
                  CharcoalIcon(
                    CharcoalIcons.chevronRight,
                    color: theme.colors.iconTertiaryDefault,
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
