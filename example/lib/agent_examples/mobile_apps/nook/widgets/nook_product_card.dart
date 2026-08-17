import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../nook_models.dart';

final class NookProductCard extends StatelessWidget {
  const NookProductCard({
    required this.onOpen,
    required this.onSave,
    required this.product,
    required this.saved,
    super.key,
  });

  final VoidCallback onOpen;
  final VoidCallback onSave;
  final NookProduct product;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return AgentDemoSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalClickable(
            onPressed: onOpen,
            semanticLabel: 'Open ${product.name}',
            builder: (context, states) => AnimatedOpacity(
              duration: CharcoalMotion.resolveDuration(
                context,
                CharcoalMotion.fast,
              ),
              opacity: states.contains(WidgetState.pressed) ? 0.72 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(theme.dimensions.radius.m),
                ),
                child: AgentDemoArtwork(height: 84, tone: product.tone),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              space.component20,
              space.component20,
              space.component10,
              space.component20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textDefault,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        formatYen(product.price),
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
                CharcoalIconButton(
                  key: ValueKey<String>(
                    product.id == 'ripple-cup'
                        ? 'agent-commerce-save'
                        : 'agent-commerce-save-${product.id}',
                  ),
                  icon: const CharcoalIcon(CharcoalIcons.bookmark),
                  onPressed: onSave,
                  selected: saved,
                  semanticLabel: saved
                      ? 'Remove saved product'
                      : 'Save product',
                  size: CharcoalIconButtonSize.extraSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
