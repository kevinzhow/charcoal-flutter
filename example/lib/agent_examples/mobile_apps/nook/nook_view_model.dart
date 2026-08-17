import 'package:flutter/foundation.dart';

import 'nook_models.dart';

final class NookViewModel extends ChangeNotifier {
  NookCategory _category = NookCategory.newItems;
  NookDestination _destination = NookDestination.shop;
  final Set<String> _bagIds = <String>{};
  final Set<String> _savedIds = <String>{};
  List<NookProduct> _confirmedProducts = const <NookProduct>[];
  String _query = '';
  bool _receiptOpenedFromProfile = false;
  NookRoute _route = NookRoute.root;
  NookProduct? _selectedProduct;

  NookCategory get category => _category;
  NookDestination get destination => _destination;
  String get query => _query;
  NookRoute get route => _route;
  NookProduct? get selectedProduct => _selectedProduct;
  List<NookProduct> get confirmedProducts => _confirmedProducts;
  bool get canGoBack =>
      _route != NookRoute.root &&
      (_route != NookRoute.orderConfirmed || _receiptOpenedFromProfile);

  List<NookProduct> get visibleProducts => visibleProductsFor(_destination);

  List<NookProduct> visibleProductsFor(NookDestination destination) {
    final normalized = _query.trim().toLowerCase();
    return nookProducts
        .where((product) {
          final matchesQuery =
              normalized.isEmpty ||
              product.name.toLowerCase().contains(normalized) ||
              product.subtitle.toLowerCase().contains(normalized);
          final categoryApplies =
              destination == NookDestination.shop && normalized.isEmpty;
          return matchesQuery &&
              (!categoryApplies || product.category == _category);
        })
        .toList(growable: false);
  }

  List<NookProduct> get savedProducts => nookProducts
      .where((product) => _savedIds.contains(product.id))
      .toList(growable: false);

  List<NookProduct> get bagProducts => nookProducts
      .where((product) => _bagIds.contains(product.id))
      .toList(growable: false);

  int get bagTotal =>
      bagProducts.fold(0, (total, product) => total + product.price);
  int get confirmedTotal =>
      _confirmedProducts.fold(0, (total, product) => total + product.price);
  int get bagCount => _bagIds.length;
  int get savedCount => _savedIds.length;

  String get title => switch (_route) {
    NookRoute.root => switch (_destination) {
      NookDestination.shop => 'Nook',
      NookDestination.search => 'Search',
      NookDestination.saved => 'Saved',
      NookDestination.profile => 'Profile',
    },
    NookRoute.product => _selectedProduct?.name ?? 'Product',
    NookRoute.bag => 'Bag',
    NookRoute.checkoutReview => 'Review order',
    NookRoute.orderConfirmed => 'Order confirmed',
  };

  bool isSaved(NookProduct product) => _savedIds.contains(product.id);
  bool isInBag(NookProduct product) => _bagIds.contains(product.id);

  void selectDestination(NookDestination destination) {
    _destination = destination;
    _route = NookRoute.root;
    _selectedProduct = null;
    notifyListeners();
  }

  void setCategory(NookCategory value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    notifyListeners();
  }

  void openProduct(NookProduct product) {
    _selectedProduct = product;
    _route = NookRoute.product;
    notifyListeners();
  }

  void toggleSaved(NookProduct product) {
    if (!_savedIds.remove(product.id)) _savedIds.add(product.id);
    notifyListeners();
  }

  void addToBag(NookProduct product) {
    _bagIds.add(product.id);
    notifyListeners();
  }

  void removeFromBag(NookProduct product) {
    _bagIds.remove(product.id);
    if (_bagIds.isEmpty && _route == NookRoute.checkoutReview) {
      _route = NookRoute.bag;
    }
    notifyListeners();
  }

  void openBag() {
    _route = NookRoute.bag;
    _selectedProduct = null;
    notifyListeners();
  }

  void startCheckout() {
    if (_bagIds.isEmpty) return;
    _route = NookRoute.checkoutReview;
    notifyListeners();
  }

  void placeOrder() {
    if (_bagIds.isEmpty) return;
    _confirmedProducts = bagProducts;
    _bagIds.clear();
    _receiptOpenedFromProfile = false;
    _route = NookRoute.orderConfirmed;
    notifyListeners();
  }

  void continueShopping() {
    _destination = NookDestination.shop;
    _route = NookRoute.root;
    _selectedProduct = null;
    _query = '';
    _receiptOpenedFromProfile = false;
    notifyListeners();
  }

  void openLatestOrder() {
    if (_confirmedProducts.isEmpty) return;
    _receiptOpenedFromProfile = true;
    _route = NookRoute.orderConfirmed;
    notifyListeners();
  }

  void goBack() {
    _route = switch (_route) {
      NookRoute.checkoutReview => NookRoute.bag,
      NookRoute.product || NookRoute.bag => NookRoute.root,
      NookRoute.orderConfirmed when _receiptOpenedFromProfile => NookRoute.root,
      NookRoute.root || NookRoute.orderConfirmed => _route,
    };
    if (_route == NookRoute.root) _receiptOpenedFromProfile = false;
    if (_route == NookRoute.root) _selectedProduct = null;
    notifyListeners();
  }
}
