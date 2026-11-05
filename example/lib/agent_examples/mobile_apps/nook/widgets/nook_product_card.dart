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
    final space = theme.space;
    return AgentDemoSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalClickable(
            onPressed: onOpen,
            semanticLabel: 'Open ${product.name}',
            builder: (context, states) => AnimatedOpacity(
              duration: CharcoalTheme.of(context)
                  .duration(context, CharcoalTheme.of(context).motion.fast),
              opacity: states.contains(WidgetState.pressed) ? 0.72 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(theme.radius.md),
                ),
                child: AgentDemoArtwork(height: 84, tone: product.tone),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              space.sm,
              space.sm,
              space.xs,
              space.sm,
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
                        style: theme
                            .style(CharcoalTextRole.caption)
                            .copyWith(
                              color: theme.colors.text,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        formatYen(product.price),
                        style: theme
                            .style(CharcoalTextRole.caption)
                            .copyWith(color: theme.colors.textSecondary),
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
