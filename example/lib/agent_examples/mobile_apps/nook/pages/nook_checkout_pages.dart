import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../nook_view_model.dart';

final class NookBagPage extends StatelessWidget {
  const NookBagPage({required this.viewModel, super.key});

  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final products = viewModel.bagProducts;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-commerce-bag-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AgentDemoPageHeading(
            eyebrow: 'BAG',
            title: products.isEmpty
                ? 'Your bag is empty'
                : 'Review before checkout',
            description: products.isEmpty
                ? 'Add a product from the collection to begin.'
                : '${products.length} ${products.length == 1 ? 'item' : 'items'} · Free delivery',
          ),
          SizedBox(height: space.lg),
          if (products.isEmpty)
            AgentDemoEmptyState(
              actionLabel: 'Continue shopping',
              description: 'Your saved products are still available in Saved.',
              onAction: viewModel.continueShopping,
              title: 'Nothing to checkout yet',
            )
          else ...<Widget>[
            for (final product in products) ...<Widget>[
              AgentDemoSurface(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: theme
                                .style(CharcoalTextRole.captionMediumBold)
                                .copyWith(color: theme.colors.text),
                          ),
                          SizedBox(height: space.xs),
                          Text(
                            formatYen(product.price),
                            style: theme
                                .style(CharcoalTextRole.caption)
                                .copyWith(color: theme.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    CharcoalIconButton(
                      icon: const CharcoalIcon(CharcoalIcons.x),
                      onPressed: () => viewModel.removeFromBag(product),
                      semanticLabel: 'Remove ${product.name} from bag',
                      size: CharcoalIconButtonSize.extraSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: space.sm),
            ],
            _OrderTotal(label: 'Order total', total: viewModel.bagTotal),
            SizedBox(height: space.lg),
            CharcoalButton(
              key: const ValueKey<String>('agent-commerce-checkout'),
              fullWidth: true,
              onPressed: viewModel.startCheckout,
              variant: CharcoalButtonVariant.primary,
              child: const Text('Review checkout'),
            ),
          ],
        ],
      ),
    );
  }
}

final class NookCheckoutReviewPage extends StatelessWidget {
  const NookCheckoutReviewPage({required this.viewModel, super.key});

  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-commerce-checkout-review'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'FINAL REVIEW',
            title: 'Everything in one place',
            description: 'Check the delivery destination and total before placing this simulated order.',
          ),
          SizedBox(height: space.lg),
          AgentDemoStatus(
            icon: CharcoalIcons.location,
            message: 'Mina Aoki · 2-8-14 Kichijoji, Tokyo · Standard delivery',
          ),
          SizedBox(height: space.sm),
          _OrderTotal(
            label: '${viewModel.bagCount} item total',
            total: viewModel.bagTotal,
          ),
          SizedBox(height: space.lg),
          CharcoalButton(
            key: const ValueKey<String>('agent-commerce-place-order'),
            fullWidth: true,
            onPressed: viewModel.placeOrder,
            variant: CharcoalButtonVariant.primary,
            child: Text('Place order · ${formatYen(viewModel.bagTotal)}'),
          ),
        ],
      ),
    );
  }
}

final class NookOrderConfirmedPage extends StatelessWidget {
  const NookOrderConfirmedPage({required this.viewModel, super.key});

  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-commerce-order-confirmed'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'ORDER NK-817',
            title: 'Your order is confirmed',
            description: 'The bag is clear and this receipt remains available from Profile.',
          ),
          SizedBox(height: space.lg),
          AgentDemoStatus(
            positive: true,
            message:
                '${viewModel.confirmedProducts.length} item · ${formatYen(viewModel.confirmedTotal)} · Preparing for delivery',
          ),
          SizedBox(height: space.lg),
          CharcoalButton(
            fullWidth: true,
            onPressed: viewModel.continueShopping,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Continue shopping'),
          ),
        ],
      ),
    );
  }
}

final class _OrderTotal extends StatelessWidget {
  const _OrderTotal({required this.label, required this.total});

  final String label;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return AgentDemoSurface(
      color: theme.colors.surfaceSecondary,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: theme
                  .style(CharcoalTextRole.captionMediumBold)
                  .copyWith(color: theme.colors.text),
            ),
          ),
          Text(
            formatYen(total),
            style: theme
                .style(CharcoalTextRole.bodyLargeBold)
                .copyWith(color: theme.colors.text),
          ),
        ],
      ),
    );
  }
}
