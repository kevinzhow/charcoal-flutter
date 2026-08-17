import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../nook_models.dart';
import '../nook_view_model.dart';
import '../widgets/nook_product_card.dart';

final class NookCollectionPage extends StatelessWidget {
  const NookCollectionPage({
    required this.searchController,
    required this.viewModel,
    super.key,
  });

  final TextEditingController searchController;
  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final savedOnly = viewModel.destination == NookDestination.saved;
    final products = savedOnly
        ? viewModel.savedProducts
        : viewModel.visibleProducts;
    final heading = switch (viewModel.destination) {
      NookDestination.shop => (
        'GOOD MORNING, MINA',
        'Small things for a calmer home',
        'Browse a considered weekly edit or search for something specific.',
      ),
      NookDestination.search => (
        'SEARCH',
        'Find exactly what feels right',
        'Search the full collection by object, material, or mood.',
      ),
      NookDestination.saved => (
        'SAVED',
        'Ideas worth returning to',
        'Saved products stay separate from your shopping bag.',
      ),
      NookDestination.profile => throw StateError('Handled above'),
    };
    return AgentDemoPage(
      child: Column(
        key: ValueKey<String>(switch (viewModel.destination) {
          NookDestination.shop => 'agent-commerce-shop-page',
          NookDestination.search => 'agent-commerce-search-page',
          NookDestination.saved => 'agent-commerce-saved-page',
          NookDestination.profile => throw StateError(
            'Profile has its own page.',
          ),
        }),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AgentDemoPageHeading(
            eyebrow: heading.$1,
            title: heading.$2,
            description: heading.$3,
          ),
          SizedBox(height: space.component30),
          if (!savedOnly) ...<Widget>[
            CharcoalTextField(
              key: const ValueKey<String>('agent-commerce-search'),
              controller: searchController,
              label: 'Search the collection',
              onChanged: viewModel.setQuery,
              placeholder: 'Try “lamp” or “paper”',
              prefix: const CharcoalIcon(CharcoalIcons.search),
              showLabel: viewModel.destination == NookDestination.search,
            ),
            if (viewModel.destination == NookDestination.shop) ...<Widget>[
              SizedBox(height: space.component25),
              CharcoalSegmentedControl<NookCategory>(
                key: const ValueKey<String>('agent-commerce-category'),
                fullWidth: true,
                onChanged: viewModel.setCategory,
                segments: const <CharcoalSegment<NookCategory>>[
                  CharcoalSegment(
                    value: NookCategory.newItems,
                    child: Text('New'),
                  ),
                  CharcoalSegment(
                    value: NookCategory.home,
                    child: Text('Home'),
                  ),
                  CharcoalSegment(
                    value: NookCategory.gifts,
                    child: Text('Gifts'),
                  ),
                ],
                semanticLabel: 'Nook category',
                value: viewModel.category,
              ),
            ],
            SizedBox(height: space.component30),
          ] else
            SizedBox(height: space.component30),
          AgentDemoSectionHeading(
            title: savedOnly
                ? '${products.length} saved ${products.length == 1 ? 'piece' : 'pieces'}'
                : viewModel.query.trim().isNotEmpty
                ? '${products.length} results for “${viewModel.query.trim()}”'
                : _categoryTitle(viewModel.category, viewModel.destination),
          ),
          SizedBox(height: space.component20),
          if (products.isEmpty)
            AgentDemoEmptyState(
              actionLabel: savedOnly ? 'Browse products' : 'Clear search',
              description: savedOnly
                  ? 'Save a product from the collection and it will remain here.'
                  : 'No products match “${viewModel.query.trim()}”. Your category and saved items are unchanged.',
              onAction: () {
                if (savedOnly) {
                  viewModel.selectDestination(NookDestination.shop.index);
                } else {
                  searchController.clear();
                  viewModel.clearSearch();
                }
              },
              title: savedOnly ? 'Nothing saved yet' : 'No matching products',
            )
          else
            _NookProductGrid(products: products, viewModel: viewModel),
        ],
      ),
    );
  }
}

String _categoryTitle(NookCategory category, NookDestination destination) {
  if (destination == NookDestination.search) {
    return 'Browse the full collection';
  }
  return switch (category) {
    NookCategory.newItems => 'New this week',
    NookCategory.home => 'For your home',
    NookCategory.gifts => 'Thoughtful gifts',
  };
}

final class _NookProductGrid extends StatelessWidget {
  const _NookProductGrid({required this.products, required this.viewModel});

  final List<NookProduct> products;
  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final gap = CharcoalTheme.of(context).dimensions.space.component20;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 520 ? 3 : 2;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: CharcoalTheme.of(context).dimensions.space.component30,
          children: <Widget>[
            for (final product in products)
              SizedBox(
                width: width,
                child: NookProductCard(
                  key: ValueKey<String>('agent-commerce-product-${product.id}'),
                  onOpen: () => viewModel.openProduct(product),
                  onSave: () => viewModel.toggleSaved(product),
                  product: product,
                  saved: viewModel.isSaved(product),
                ),
              ),
          ],
        );
      },
    );
  }
}
