import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../nook_demo.dart';
import '../nook_models.dart';
import '../nook_view_model.dart';

@AgentPagePreview(app: 'Nook', state: 'Collection', includeDark: true)
Widget nookCollectionPreview() => const NookDemo();

@AgentPagePreview(app: 'Nook', state: 'Search')
Widget nookSearchPreview() =>
    NookDemo(createViewModel: createNookSearchPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'No-result recovery')
Widget nookNoResultPreview() =>
    NookDemo(createViewModel: createNookNoResultPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Saved empty')
Widget nookSavedEmptyPreview() =>
    NookDemo(createViewModel: createNookSavedEmptyPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Saved product')
Widget nookSavedProductPreview() =>
    NookDemo(createViewModel: createNookSavedProductPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Product detail')
Widget nookProductDetailPreview() =>
    NookDemo(createViewModel: createNookProductDetailPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Product in bag')
Widget nookProductInBagPreview() =>
    NookDemo(createViewModel: createNookProductInBagPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Bag empty')
Widget nookBagEmptyPreview() =>
    NookDemo(createViewModel: createNookBagEmptyPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Bag ready')
Widget nookBagReadyPreview() =>
    NookDemo(createViewModel: createNookBagReadyPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Checkout review')
Widget nookCheckoutReviewPreview() =>
    NookDemo(createViewModel: createNookCheckoutReviewPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Order receipt')
Widget nookOrderReceiptPreview() =>
    NookDemo(createViewModel: createNookOrderReceiptPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Profile before purchase')
Widget nookProfileEmptyPreview() =>
    NookDemo(createViewModel: createNookProfileEmptyPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Profile with order')
Widget nookProfileOrderPreview() =>
    NookDemo(createViewModel: createNookProfileOrderPreviewModel);

NookViewModel createNookSearchPreviewModel() =>
    NookViewModel()..selectDestination(NookDestination.search.index);

NookViewModel createNookNoResultPreviewModel() => NookViewModel()
  ..selectDestination(NookDestination.search.index)
  ..setQuery('blue lantern');

NookViewModel createNookSavedEmptyPreviewModel() =>
    NookViewModel()..selectDestination(NookDestination.saved.index);

NookViewModel createNookSavedProductPreviewModel() => NookViewModel()
  ..toggleSaved(nookProducts.first)
  ..selectDestination(NookDestination.saved.index);

NookViewModel createNookProductDetailPreviewModel() =>
    NookViewModel()..openProduct(nookProducts.first);

NookViewModel createNookProductInBagPreviewModel() => NookViewModel()
  ..openProduct(nookProducts.first)
  ..addToBag(nookProducts.first);

NookViewModel createNookBagEmptyPreviewModel() => NookViewModel()..openBag();

NookViewModel createNookBagReadyPreviewModel() => NookViewModel()
  ..addToBag(nookProducts.first)
  ..openBag();

NookViewModel createNookCheckoutReviewPreviewModel() => NookViewModel()
  ..addToBag(nookProducts[0])
  ..addToBag(nookProducts[2])
  ..openBag()
  ..startCheckout();

NookViewModel createNookOrderReceiptPreviewModel() =>
    createNookCheckoutReviewPreviewModel()..placeOrder();

NookViewModel createNookProfileEmptyPreviewModel() =>
    NookViewModel()..selectDestination(NookDestination.profile.index);

NookViewModel createNookProfileOrderPreviewModel() =>
    createNookOrderReceiptPreviewModel()
      ..continueShopping()
      ..selectDestination(NookDestination.profile.index);
