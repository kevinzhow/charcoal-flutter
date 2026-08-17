import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../nook_demo.dart';
import '../nook_models.dart';
import '../nook_view_model.dart';

@AgentPagePreview(app: 'Nook', state: 'Collection', includeDark: true)
Widget nookCollectionPreview() => const NookDemo();

@AgentPagePreview(app: 'Nook', state: 'No-result recovery')
Widget nookNoResultPreview() =>
    NookDemo(createViewModel: createNookNoResultPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Checkout review')
Widget nookCheckoutReviewPreview() =>
    NookDemo(createViewModel: createNookCheckoutReviewPreviewModel);

@AgentPagePreview(app: 'Nook', state: 'Order receipt')
Widget nookOrderReceiptPreview() =>
    NookDemo(createViewModel: createNookOrderReceiptPreviewModel);

NookViewModel createNookNoResultPreviewModel() => NookViewModel()
  ..selectDestination(NookDestination.search.index)
  ..setQuery('blue lantern');

NookViewModel createNookCheckoutReviewPreviewModel() => NookViewModel()
  ..addToBag(nookProducts[0])
  ..addToBag(nookProducts[2])
  ..openBag()
  ..startCheckout();

NookViewModel createNookOrderReceiptPreviewModel() =>
    createNookCheckoutReviewPreviewModel()..placeOrder();
