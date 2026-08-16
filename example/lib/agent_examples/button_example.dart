import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A responsive pair of primary and secondary actions.
final class AgentButtonExample extends StatelessWidget {
  const AgentButtonExample({
    required this.onContinue,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onContinue;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final gap = CharcoalTheme.of(context).dimensions.space.component20;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        final cancel = CharcoalButton(
          fullWidth: compact,
          onPressed: onCancel,
          child: const Text('Cancel'),
        );
        final submit = CharcoalButton(
          fullWidth: compact,
          onPressed: onContinue,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Continue'),
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              submit,
              SizedBox(height: gap),
              cancel,
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            cancel,
            SizedBox(width: gap),
            submit,
          ],
        );
      },
    );
  }
}
