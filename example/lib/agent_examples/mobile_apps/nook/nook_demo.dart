import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../agent_example_navigator.dart';
import '../../shared/agent_demo_tab_bar.dart';
import '../shared/demo_shell.dart';
import 'nook_models.dart';
import 'nook_view_model.dart';
import 'pages/nook_checkout_pages.dart';
import 'pages/nook_collection_page.dart';
import 'pages/nook_product_page.dart';
import 'pages/nook_profile_page.dart';

final class NookDemo extends StatefulWidget {
  const NookDemo({this.createViewModel, super.key});

  /// Supplies deterministic state for previews while keeping the demo in
  /// charge of the model lifecycle.
  final NookViewModel Function()? createViewModel;

  @override
  State<NookDemo> createState() => _NookDemoState();
}

final class _NookDemoState extends State<NookDemo> {
  late final NookViewModel _viewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.createViewModel?.call() ?? NookViewModel();
    _searchController = TextEditingController(text: _viewModel.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, _) =>
        AgentExampleNavigator(appKey: 'commerce', pages: _pages()),
  );

  List<AgentExamplePage> _pages() {
    final destination = _viewModel.destination;
    final root = _page(
      destination: destination,
      pageKey: 'root-${destination.name}',
      route: NookRoute.root,
      routeKey: 'root',
    );
    return switch (_viewModel.route) {
      NookRoute.root => <AgentExamplePage>[root],
      NookRoute.product => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'product-${_viewModel.selectedProduct!.id}',
          onDidPop: () => _popIfCurrent(NookRoute.product),
          product: _viewModel.selectedProduct,
          route: NookRoute.product,
        ),
      ],
      NookRoute.bag => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'bag',
          onDidPop: () => _popIfCurrent(NookRoute.bag),
          route: NookRoute.bag,
        ),
      ],
      NookRoute.checkoutReview => <AgentExamplePage>[
        root,
        _page(destination: destination, pageKey: 'bag', route: NookRoute.bag),
        _page(
          destination: destination,
          pageKey: 'checkout-review',
          onDidPop: () => _popIfCurrent(NookRoute.checkoutReview),
          route: NookRoute.checkoutReview,
        ),
      ],
      NookRoute.orderConfirmed when _viewModel.canGoBack => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'order-confirmed',
          onDidPop: () => _popIfCurrent(NookRoute.orderConfirmed),
          route: NookRoute.orderConfirmed,
        ),
      ],
      NookRoute.orderConfirmed => <AgentExamplePage>[
        _page(
          destination: destination,
          pageKey: 'order-confirmed',
          route: NookRoute.orderConfirmed,
        ),
      ],
    };
  }

  AgentExamplePage _page({
    required NookDestination destination,
    required String pageKey,
    required NookRoute route,
    VoidCallback? onDidPop,
    NookProduct? product,
    String? routeKey,
  }) => AgentExamplePage(
    builder: (context) => _shell(
      context,
      canGoBack: onDidPop != null,
      destination: destination,
      pageKey: pageKey,
      product: product,
      route: route,
    ),
    key: ValueKey<String>('agent-commerce-route-${routeKey ?? pageKey}'),
    listenable: _viewModel,
    name: '/nook/$pageKey',
    onDidPop: onDidPop,
  );

  Widget _shell(
    BuildContext context, {
    required bool canGoBack,
    required NookDestination destination,
    required String pageKey,
    required NookRoute route,
    NookProduct? product,
  }) {
    final theme = CharcoalTheme.of(context);
    final title = _title(route, destination, product);
    return AgentDemoAppShell(
      appKey: 'commerce',
      appLabel: 'Nook commerce app demo',
      brandColor: theme.colors.containerNoticeDefault,
      brandForeground: theme.colors.textOnNoticeDefault,
      brandMark: 'N',
      tabItems: const <AgentDemoTabItem>[
        AgentDemoTabItem('Shop', CharcoalIcons.shopping),
        AgentDemoTabItem('Search', CharcoalIcons.search),
        AgentDemoTabItem('Saved', CharcoalIcons.bookmark),
        AgentDemoTabItem('Profile', CharcoalIcons.personCircle),
      ],
      content: _content(route, destination, product),
      leading: canGoBack
          ? AgentDemoBackButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              semanticLabel: 'Back from $title',
            )
          : null,
      onTabSelected: (index) {
        _viewModel.selectDestination(index);
        if (index != NookDestination.search.index) {
          _searchController.clear();
          _viewModel.clearSearch();
        }
      },
      pageKey: pageKey,
      selectedTabIndex: destination.index,
      showTabBar: route == NookRoute.root,
      title: title,
      trailing: route == NookRoute.orderConfirmed
          ? null
          : CharcoalIconButton(
              key: const ValueKey<String>('agent-commerce-bag'),
              icon: const CharcoalIcon(CharcoalIcons.shopping),
              onPressed: _viewModel.openBag,
              semanticLabel: 'Shopping bag, ${_viewModel.bagCount} items',
              size: CharcoalIconButtonSize.small,
            ),
    );
  }

  Widget _content(
    NookRoute route,
    NookDestination destination,
    NookProduct? product,
  ) => switch (route) {
    NookRoute.root => switch (destination) {
      NookDestination.profile => NookProfilePage(viewModel: _viewModel),
      _ => NookCollectionPage(
        destination: destination,
        searchController: _searchController,
        viewModel: _viewModel,
      ),
    },
    NookRoute.product => NookProductPage(
      product: product!,
      viewModel: _viewModel,
    ),
    NookRoute.bag => NookBagPage(viewModel: _viewModel),
    NookRoute.checkoutReview => NookCheckoutReviewPage(viewModel: _viewModel),
    NookRoute.orderConfirmed => NookOrderConfirmedPage(viewModel: _viewModel),
  };

  String _title(
    NookRoute route,
    NookDestination destination,
    NookProduct? product,
  ) => switch (route) {
    NookRoute.root => switch (destination) {
      NookDestination.shop => 'Nook',
      NookDestination.search => 'Search',
      NookDestination.saved => 'Saved',
      NookDestination.profile => 'Profile',
    },
    NookRoute.product => product?.name ?? 'Product',
    NookRoute.bag => 'Bag',
    NookRoute.checkoutReview => 'Review order',
    NookRoute.orderConfirmed => 'Order confirmed',
  };

  void _popIfCurrent(NookRoute route) {
    if (_viewModel.route == route) _viewModel.goBack();
  }
}
