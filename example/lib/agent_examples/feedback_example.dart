import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Launches transient feedback from a context that owns an Overlay.
final class AgentFeedbackExample extends StatelessWidget {
  const AgentFeedbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CharcoalWrap(
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
