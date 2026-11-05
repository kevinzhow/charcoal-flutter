import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../actions/button.dart';
import 'dialog.dart';
import 'modal.dart';

/// Asks the user to confirm an action; resolves true when the primary button is taken.
///
/// Dismissing the dialog (close button, barrier, Escape or back) resolves false. With [danger] the
/// primary button is the destructive variant and [confirmLabel] defaults to "Delete", otherwise
/// "Confirm".
///
/// ```dart
/// final ok = await showCharcoalConfirm(
///   context,
///   title: 'Delete key',
///   message: 'Apps using this key stop working.',
///   danger: true,
/// );
/// ```
Future<bool> showCharcoalConfirm(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String cancelLabel = 'Cancel',
  bool danger = false,
}) async {
  final result = await showCharcoalDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final theme = CharcoalTheme.of(dialogContext);
      return CharcoalDialog(
        title: title,
        showCloseButton: true,
        onDismiss: () => Navigator.of(dialogContext).maybePop(false),
        contentPadding: EdgeInsets.symmetric(horizontal: theme.metrics.modal.actionPadding),
        actions: <Widget>[
          CharcoalButton(
            variant: danger ? CharcoalButtonVariant.danger : CharcoalButtonVariant.primary,
            fullWidth: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel ?? (danger ? 'Delete' : 'Confirm')),
          ),
          CharcoalButton(
            fullWidth: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
        ],
        child: Text(
          message,
          style: theme.style(CharcoalTextRole.body, color: theme.colors.textSecondary),
        ),
      );
    },
  );
  return result ?? false;
}
