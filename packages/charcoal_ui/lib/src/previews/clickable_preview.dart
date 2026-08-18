import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Interaction primitive', size: Size(420, 220))
Widget charcoalClickablePreview() => Builder(
  builder: (context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      onPressed: () {},
      semanticLabel: 'Open preview project',
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final hovered = states.contains(WidgetState.hovered);
        final pressed = states.contains(WidgetState.pressed);
        return AnimatedContainer(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.fast,
          ),
          constraints: BoxConstraints(minHeight: space.targetL),
          padding: EdgeInsets.all(space.component30),
          decoration: BoxDecoration(
            border: Border.all(
              color: focused
                  ? theme.colors.borderFocus1
                  : pressed
                  ? theme.colors.borderPress
                  : hovered
                  ? theme.colors.borderHover
                  : theme.colors.borderSecondary,
              width: theme.dimensions.borderWidth.m,
            ),
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            color: pressed
                ? theme.colors.containerSecondaryPressA
                : hovered || focused
                ? theme.colors.containerSecondaryHoverA
                : theme.colors.backgroundDefault,
          ),
          child: Row(
            children: <Widget>[
              CharcoalIcon(
                CharcoalIcons.image,
                color: theme.colors.iconDefault,
              ),
              SizedBox(width: space.component30),
              Expanded(
                child: Text(
                  'Preview project',
                  style: theme.textStyles.bodyBold,
                ),
              ),
              CharcoalIcon(
                CharcoalIcons.chevronRight,
                color: theme.colors.iconTertiaryDefault,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  },
);
