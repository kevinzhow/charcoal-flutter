import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../nook_models.dart';
import '../nook_view_model.dart';

final class NookProductPage extends StatelessWidget {
  const NookProductPage({
    required this.product,
    required this.viewModel,
    super.key,
  });

  final NookProduct product;
  final NookViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final saved = viewModel.isSaved(product);
    final inBag = viewModel.isInBag(product);
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-commerce-product-detail'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            child: AgentDemoArtwork(height: 220, tone: product.tone),
          ),
          SizedBox(height: space.component30),
          Text(
            product.name,
            style: theme.textStyles.headingXs.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            product.subtitle,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component20),
          Text(
            formatYen(product.price),
            style: theme.textStyles.bodyBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component20),
          Text(
            'Made in a small workshop and packed with recyclable paper. Ships in 2–3 days.',
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            key: const ValueKey<String>('agent-commerce-add-to-bag'),
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.shopping),
            onPressed: () => viewModel.addToBag(product),
            selected: inBag,
            variant: CharcoalButtonVariant.primary,
            child: Text(inBag ? 'Added to bag' : 'Add to bag'),
          ),
          SizedBox(height: space.component20),
          CharcoalButton(
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.bookmark),
            onPressed: () => viewModel.toggleSaved(product),
            selected: saved,
            child: Text(saved ? 'Saved' : 'Save for later'),
          ),
          if (inBag) ...<Widget>[
            SizedBox(height: space.component25),
            AgentDemoStatus(
              positive: true,
              message:
                  '${product.name} is in your bag. Open the bag to review checkout.',
            ),
          ],
        ],
      ),
    );
  }
}
