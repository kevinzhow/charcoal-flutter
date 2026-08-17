enum NookDestination { shop, search, saved, profile }

enum NookRoute { root, product, bag, checkoutReview, orderConfirmed }

enum NookCategory { newItems, home, gifts }

final class NookProduct {
  const NookProduct({
    required this.category,
    required this.id,
    required this.name,
    required this.price,
    required this.subtitle,
    required this.tone,
  });

  final NookCategory category;
  final String id;
  final String name;
  final int price;
  final String subtitle;
  final int tone;
}

const List<NookProduct> nookProducts = <NookProduct>[
  NookProduct(
    category: NookCategory.newItems,
    id: 'ripple-cup',
    name: 'Ripple cup',
    price: 2800,
    subtitle: 'Hand-glazed stoneware',
    tone: 1,
  ),
  NookProduct(
    category: NookCategory.newItems,
    id: 'linen-tray',
    name: 'Linen tray',
    price: 3400,
    subtitle: 'Soft structure for small things',
    tone: 3,
  ),
  NookProduct(
    category: NookCategory.home,
    id: 'paper-lamp',
    name: 'Paper lamp',
    price: 8900,
    subtitle: 'A warm pool of evening light',
    tone: 0,
  ),
  NookProduct(
    category: NookCategory.home,
    id: 'wool-cushion',
    name: 'Wool cushion',
    price: 6200,
    subtitle: 'Woven in a quiet moss tone',
    tone: 2,
  ),
  NookProduct(
    category: NookCategory.gifts,
    id: 'tea-pair',
    name: 'Tea pair',
    price: 4600,
    subtitle: 'Two cups wrapped for sharing',
    tone: 2,
  ),
  NookProduct(
    category: NookCategory.gifts,
    id: 'letter-set',
    name: 'Letter set',
    price: 1900,
    subtitle: 'Textured paper and six envelopes',
    tone: 0,
  ),
];
