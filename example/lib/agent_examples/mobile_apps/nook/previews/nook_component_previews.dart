import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../nook_models.dart';
import '../widgets/nook_product_card.dart';

@AgentComponentPreview(name: 'Nook product card', size: Size(390, 270))
Widget nookProductCardPreview() => const _NookProductCardPreview();

final class _NookProductCardPreview extends StatefulWidget {
  const _NookProductCardPreview();

  @override
  State<_NookProductCardPreview> createState() =>
      _NookProductCardPreviewState();
}

final class _NookProductCardPreviewState
    extends State<_NookProductCardPreview> {
  bool saved = false;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 168,
      child: NookProductCard(
        onOpen: () {},
        onSave: () => setState(() => saved = !saved),
        product: nookProducts.first,
        saved: saved,
      ),
    ),
  );
}
