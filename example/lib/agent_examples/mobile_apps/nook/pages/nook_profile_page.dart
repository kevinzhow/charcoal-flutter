import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../nook_models.dart';
import '../nook_view_model.dart';

final class NookProfilePage extends StatelessWidget {
  const NookProfilePage({required this.viewModel, super.key});

  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-commerce-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'PROFILE',
            title: 'Your Nook at a glance',
            description: 'Return to saved ideas, your bag, or the order that needs your attention.',
          ),
          SizedBox(height: space.lg),
          AgentDemoProfileHeader(
            name: 'Mina Aoki',
            context: 'Nook member · Tokyo',
            summary: viewModel.confirmedProducts.isEmpty
                ? 'Free delivery on every order'
                : 'Latest order is preparing for delivery',
          ),
          SizedBox(height: space.lg),
          const AgentDemoSectionHeading(title: 'Shopping activity'),
          SizedBox(height: space.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: CharcoalButton(
                  key: const ValueKey<String>('agent-commerce-profile-saved'),
                  fullWidth: true,
                  leading: const CharcoalIcon(CharcoalIcons.bookmark),
                  onPressed: () =>
                      viewModel.selectDestination(NookDestination.saved),
                  child: Text('Saved · ${viewModel.savedCount}'),
                ),
              ),
              SizedBox(width: space.sm),
              Expanded(
                child: CharcoalButton(
                  key: const ValueKey<String>('agent-commerce-profile-bag'),
                  fullWidth: true,
                  leading: const CharcoalIcon(CharcoalIcons.shopping),
                  onPressed: viewModel.openBag,
                  child: Text('Bag · ${viewModel.bagCount}'),
                ),
              ),
            ],
          ),
          SizedBox(height: space.lg),
          const AgentDemoSectionHeading(title: 'Latest order'),
          SizedBox(height: space.sm),
          if (viewModel.confirmedProducts.isEmpty)
            AgentDemoEmptyState(
              actionLabel: 'Browse the collection',
              description: 'Completed orders will remain here with their current delivery status.',
              onAction: viewModel.continueShopping,
              title: 'No orders yet',
            )
          else
            AgentDemoSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'NK-817',
                    style: theme
                        .style(CharcoalTextRole.captionMediumBold)
                        .copyWith(color: theme.colors.text),
                  ),
                  SizedBox(height: space.xs),
                  Text(
                    '${viewModel.confirmedProducts.length} ${viewModel.confirmedProducts.length == 1 ? 'item' : 'items'} · ${formatYen(viewModel.confirmedTotal)}',
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(color: theme.colors.textSecondary),
                  ),
                  SizedBox(height: space.sm),
                  const AgentDemoStatus(
                    icon: CharcoalIcons.shopping,
                    message: 'Preparing for delivery · Estimated August 20–21',
                  ),
                  SizedBox(height: space.md),
                  CharcoalButton(
                    key: const ValueKey<String>(
                      'agent-commerce-view-latest-order',
                    ),
                    fullWidth: true,
                    onPressed: viewModel.openLatestOrder,
                    child: const Text('View order details'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
