import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import 'dialog.dart';
import 'modal.dart';

/// One option of a [showCharcoalChoiceDialog].
@immutable
class CharcoalChoice<T> {
  /// Creates an option that resolves [value] when chosen.
  const CharcoalChoice({required this.label, required this.value, this.leading});

  /// The row text.
  final String label;

  /// What the dialog resolves to when this row is taken.
  final T value;

  /// An icon before the label.
  final Widget? leading;
}

/// A list-of-options dialog. Resolves the chosen [CharcoalChoice.value], or null when dismissed.
///
/// Each option is a full-width row with a trailing chevron; the rows are focusable and activate
/// with Enter or Space.
Future<T?> showCharcoalChoiceDialog<T>(
  BuildContext context, {
  required String title,
  required List<CharcoalChoice<T>> choices,
  String? description,
}) => showCharcoalDialog<T>(
  context: context,
  builder: (dialogContext) {
    final theme = CharcoalTheme.of(dialogContext);
    return CharcoalDialog(
      title: title,
      showCloseButton: true,
      onDismiss: () => Navigator.of(dialogContext).maybePop(),
      contentPadding: EdgeInsets.fromLTRB(
        theme.metrics.modal.actionPadding,
        0,
        theme.metrics.modal.actionPadding,
        theme.metrics.modal.actionPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (description != null) ...<Widget>[
            Text(
              description,
              style: theme.style(CharcoalTextRole.body, color: theme.colors.textSecondary),
            ),
            CharcoalGap.vertical(CharcoalSpace.md),
          ],
          for (final choice in choices)
            Padding(
              padding: EdgeInsets.only(bottom: theme.space.xs),
              child: _ChoiceRow<T>(
                choice: choice,
                onPressed: () => Navigator.of(dialogContext).pop(choice.value),
              ),
            ),
        ],
      ),
    );
  },
);

class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({required this.choice, required this.onPressed});

  final CharcoalChoice<T> choice;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: onPressed,
      builder: (context, states) {
        final background = resolveCharcoalStateColor(
          states,
          normal: theme.colors.restOverlay,
          hovered: theme.colors.hoverOverlay,
          pressed: theme.colors.pressOverlay,
        );
        final focused = states.contains(WidgetState.focused);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(theme.radius.sm),
            boxShadow: focused
                ? <BoxShadow>[
                    BoxShadow(color: theme.colors.focusRing, spreadRadius: theme.borders.focusRing),
                  ]
                : const <BoxShadow>[],
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: theme.sizes.controlMd),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.space.md, vertical: theme.space.sm),
              child: Row(
                children: <Widget>[
                  if (choice.leading != null) ...<Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: theme.colors.iconSecondary,
                        size: theme.sizes.iconLg,
                      ),
                      child: choice.leading!,
                    ),
                    CharcoalGap.horizontal(CharcoalSpace.sm),
                  ],
                  Expanded(
                    child: Text(choice.label, style: theme.style(CharcoalTextRole.bodyBold)),
                  ),
                  CharcoalGap.horizontal(CharcoalSpace.sm),
                  CharcoalIcon(
                    CharcoalIcons.chevronRight,
                    size: theme.sizes.iconSm,
                    color: theme.colors.iconTertiary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
