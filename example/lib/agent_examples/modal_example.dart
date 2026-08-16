import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Opens the same modal task as a dialog or bottom sheet based on available width.
final class AgentModalExample extends StatelessWidget {
  const AgentModalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CharcoalButton(
      onPressed: () => _openModal(context),
      variant: CharcoalButtonVariant.primary,
      child: const Text('Review changes'),
    );
  }

  Future<void> _openModal(BuildContext context) async {
    final compact = MediaQuery.sizeOf(context).width < 600;
    await showCharcoalModal<void>(
      actions: <Widget>[
        CharcoalButton(
          onPressed: () => Navigator.of(context).pop(),
          variant: CharcoalButtonVariant.primary,
          child: const Text('Done'),
        ),
      ],
      child: const CharcoalTypography(
        child: Text(
          'Your profile and visibility changes are ready to publish.',
        ),
      ),
      context: context,
      style: compact
          ? CharcoalModalStyle.bottomSheet
          : CharcoalModalStyle.center,
      title: 'Review changes',
    );
  }
}
