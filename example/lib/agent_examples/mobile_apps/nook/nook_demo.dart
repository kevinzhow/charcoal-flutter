import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shared/demo_shell.dart';
import 'nook_models.dart';
import 'nook_view_model.dart';
import 'pages/nook_checkout_pages.dart';
import 'pages/nook_collection_page.dart';
import 'pages/nook_product_page.dart';

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
    builder: (context, _) {
      final theme = CharcoalTheme.of(context);
      return AgentDemoAppShell(
        appKey: 'commerce',
        appLabel: 'Nook commerce app demo',
        brandColor: theme.colors.containerNoticeDefault,
        brandForeground: theme.colors.textOnNoticeDefault,
        brandMark: 'N',
        bottomItems: const <AgentDemoBottomItem>[
          AgentDemoBottomItem('Shop', CharcoalIcons.shopping),
          AgentDemoBottomItem('Search', CharcoalIcons.search),
          AgentDemoBottomItem('Saved', CharcoalIcons.bookmark),
          AgentDemoBottomItem('Profile', CharcoalIcons.personCircle),
        ],
        content: _content(),
        leading: _viewModel.canGoBack
            ? AgentDemoBackButton(
                onPressed: _viewModel.goBack,
                semanticLabel: 'Back from ${_viewModel.title}',
              )
            : null,
        onBottomItemSelected: (index) {
          _viewModel.selectDestination(index);
          if (index != NookDestination.search.index) {
            _searchController.clear();
            _viewModel.clearSearch();
          }
        },
        selectedBottomIndex: _viewModel.selectedBottomIndex,
        showBottomNavigation: _viewModel.showBottomNavigation,
        title: _viewModel.title,
        trailing: _viewModel.route == NookRoute.orderConfirmed
            ? null
            : CharcoalIconButton(
                key: const ValueKey<String>('agent-commerce-bag'),
                icon: const CharcoalIcon(CharcoalIcons.shopping),
                onPressed: _viewModel.openBag,
                semanticLabel: 'Shopping bag, ${_viewModel.bagCount} items',
                size: CharcoalIconButtonSize.small,
              ),
      );
    },
  );

  Widget _content() => switch (_viewModel.route) {
    NookRoute.root => NookCollectionPage(
      searchController: _searchController,
      viewModel: _viewModel,
    ),
    NookRoute.product => NookProductPage(
      product: _viewModel.selectedProduct!,
      viewModel: _viewModel,
    ),
    NookRoute.bag => NookBagPage(viewModel: _viewModel),
    NookRoute.checkoutReview => NookCheckoutReviewPage(viewModel: _viewModel),
    NookRoute.orderConfirmed => NookOrderConfirmedPage(viewModel: _viewModel),
  };
}
