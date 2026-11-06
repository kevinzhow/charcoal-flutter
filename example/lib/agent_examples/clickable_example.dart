import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// An audited whole-surface action for a case with no higher-level component.
///
/// `CharcoalClickable` owns activation, focus and semantics and hands its states to a raised
/// `CharcoalCard`, which paints hover, press and focus from the theme. The example draws nothing
/// itself.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalText(
          'Whole-surface action',
          role: CharcoalTextRole.headingS,
        ),
        const CharcoalGap(CharcoalSpace.sm),
        CharcoalText(_status, role: CharcoalTextRole.captionMedium),
        const CharcoalGap(CharcoalSpace.xl),
        CharcoalClickable(
          onPressed: () => setState(() => _status = 'Moonlit Lake opened'),
          semanticLabel: 'Open Moonlit Lake project',
          builder: (context, states) => CharcoalCard(
            raised: true,
            states: states,
            child: const Row(
              children: <Widget>[
                CharcoalIconView(
                  CharcoalIcons.image,
                  tone: CharcoalIconTone.primary,
                ),
                CharcoalGap(CharcoalSpace.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CharcoalText(
                        'Moonlit Lake',
                        role: CharcoalTextRole.bodyLargeBold,
                      ),
                      CharcoalGap(CharcoalSpace.xs),
                      CharcoalText(
                        'Illustration · updated today',
                        role: CharcoalTextRole.caption,
                        tone: CharcoalTextTone.secondary,
                      ),
                    ],
                  ),
                ),
                CharcoalGap(CharcoalSpace.sm),
                CharcoalIconView(
                  CharcoalIcons.chevronRight,
                  size: CharcoalIconSize.sm,
                  tone: CharcoalIconTone.tertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
