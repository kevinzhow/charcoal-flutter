import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../action_controls_example.dart';
import '../async_action_example.dart';
import '../carousel_example.dart';
import '../clickable_example.dart';
import '../form_guidance_example.dart';
import '../mobile_apps/shared/demo_components.dart';
import '../multi_select_example.dart';
import '../navigation_item_example.dart';
import '../overlay_controls_example.dart';
import '../pagination_example.dart';
import '../selection_controls_example.dart';
import '../tag_item_example.dart';
import '../theme_typography_example.dart';
import 'preview_support.dart';

@AgentComponentPreview(name: 'Action controls', size: Size(390, 320))
Widget agentActionControlsPreview() => const AgentActionControlsExample();

@AgentComponentPreview(name: 'Async action · Wide', size: Size(520, 340))
Widget agentWideAsyncActionPreview() => const AgentAsyncActionExample();

@AgentComponentPreview(name: 'Async action · Compact', size: Size(240, 460))
Widget agentCompactAsyncActionPreview() => const AgentAsyncActionExample();

@AgentComponentPreview(name: 'Whole-surface action', size: Size(390, 300))
Widget agentClickableSurfacePreview() => const AgentClickableSurfaceExample();

@AgentComponentPreview(name: 'Anchored overlays', size: Size(390, 420))
Widget agentOverlayControlsPreview() => const AgentOverlayControlsExample();

@AgentComponentPreview(
  name: 'Adaptive destinations · Wide',
  size: Size(720, 420),
)
Widget agentWideDestinationsPreview() => const AgentNavigationItemExample();

@AgentComponentPreview(
  name: 'Adaptive destinations · Compact',
  size: Size(390, 440),
)
Widget agentCompactDestinationsPreview() => const AgentNavigationItemExample();

@AgentComponentPreview(name: 'Selection controls', size: Size(390, 440))
Widget agentSelectionControlsPreview() => const AgentSelectionControlsExample();

@AgentComponentPreview(name: 'Multi-select group', size: Size(390, 480))
Widget agentMultiSelectPreview() => const AgentMultiSelectExample();

@AgentComponentPreview(name: 'Pagination · Wide', size: Size(640, 220))
Widget agentWidePaginationPreview() => const AgentPaginationExample();

@AgentComponentPreview(name: 'Pagination · Compact', size: Size(320, 220))
Widget agentCompactPaginationPreview() => const AgentPaginationExample();

@AgentComponentPreview(name: 'Featured carousel · Wide', size: Size(640, 340))
Widget agentWideCarouselPreview() => const AgentCarouselExample();

@AgentComponentPreview(
  name: 'Featured carousel · Compact',
  size: Size(320, 340),
)
Widget agentCompactCarouselPreview() => const AgentCarouselExample();

@AgentComponentPreview(name: 'Tag filters · Wide', size: Size(520, 260))
Widget agentWideTagItemPreview() => const AgentTagItemExample();

@AgentComponentPreview(name: 'Tag filters · Compact', size: Size(240, 320))
Widget agentCompactTagItemPreview() => const AgentTagItemExample();

@AgentComponentPreview(name: 'Form guidance · Wide', size: Size(520, 360))
Widget agentWideFormGuidancePreview() => const AgentFormGuidanceExample();

@AgentComponentPreview(name: 'Form guidance · Compact', size: Size(240, 520))
Widget agentCompactFormGuidancePreview() => const AgentFormGuidanceExample();

@AgentComponentPreview(name: 'Theme typography · Wide', size: Size(520, 420))
Widget agentWideThemeTypographyPreview() => const AgentThemeTypographyExample();

@AgentComponentPreview(name: 'Theme typography · Compact', size: Size(240, 520))
Widget agentCompactThemeTypographyPreview() =>
    const AgentThemeTypographyExample();

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
