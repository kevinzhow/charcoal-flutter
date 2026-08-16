import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Launches transient feedback from a context that owns an Overlay.
final class AgentFeedbackExample extends StatelessWidget {
  const AgentFeedbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = CharcoalTheme.of(context).dimensions.space.component20;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: <Widget>[
        CharcoalButton(
          onPressed: () =>
              showCharcoalToast(context: context, message: 'Changes saved'),
          child: const Text('Show toast'),
        ),
        CharcoalButton(
          onPressed: () =>
              showCharcoalSnackBar(context: context, message: 'Draft restored'),
          child: const Text('Show snackbar'),
        ),
      ],
    );
  }
}
