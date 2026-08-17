import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../mobile_apps/shared/demo_components.dart';
import '../mobile_apps/shared/demo_shell.dart';
import 'preview_support.dart';

@AgentComponentPreview(
  name: 'Page hierarchy and feedback',
  size: Size(390, 620),
)
Widget agentPageHierarchyPreview() => Builder(
  builder: (context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AgentDemoPageHeading(
          eyebrow: 'CURRENT CONTEXT',
          title: 'One clear outcome leads the page',
          description:
              'Supporting information stays close to the decision it explains.',
        ),
        SizedBox(height: space.component30),
        const AgentDemoSectionHeading(title: 'Immediate status'),
        SizedBox(height: space.component20),
        const AgentDemoStatus(
          message: 'The current state remains visible and reversible.',
        ),
        SizedBox(height: space.component20),
        const AgentDemoStatus(
          message: 'The durable result is now part of the page.',
          positive: true,
        ),
      ],
    );
  },
);

@AgentComponentPreview(name: 'Recoverable empty state', size: Size(390, 360))
Widget agentEmptyStatePreview() => AgentDemoEmptyState(
  actionLabel: 'Clear search',
  description: 'No results match “blue lantern”. Your saved items and filters are unchanged.',
  onAction: () {},
  title: 'No matching products',
);

@AgentComponentPreview(name: 'Mobile destination bar', size: Size(390, 170))
Widget agentBottomNavigationPreview() => const _BottomNavigationPreview();

final class _BottomNavigationPreview extends StatefulWidget {
  const _BottomNavigationPreview();

  @override
  State<_BottomNavigationPreview> createState() =>
      _BottomNavigationPreviewState();
}

final class _BottomNavigationPreviewState
    extends State<_BottomNavigationPreview> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => AgentDemoBottomBar(
    appKey: 'preview',
    items: const <AgentDemoBottomItem>[
      AgentDemoBottomItem('Today', CharcoalIcons.sun),
      AgentDemoBottomItem('Journey', CharcoalIcons.calendar),
      AgentDemoBottomItem('Insights', CharcoalIcons.star),
      AgentDemoBottomItem('Profile', CharcoalIcons.personCircle),
    ],
    onSelected: (value) => setState(() => selectedIndex = value),
    selectedIndex: selectedIndex,
  );
}
