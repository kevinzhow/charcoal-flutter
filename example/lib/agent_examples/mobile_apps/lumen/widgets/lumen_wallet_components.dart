import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../lumen_models.dart';
import '../lumen_view_model.dart';

final class LumenBalanceCard extends StatelessWidget {
  const LumenBalanceCard({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[theme.colors.primary, theme.colors.negative],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'AVAILABLE BALANCE',
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(
                          color: theme.colors.textOnPrimary.withValues(
                            alpha: 0.72,
                          ),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                  ),
                ),
                CharcoalIconButton(
                  key: const ValueKey<String>('agent-wallet-visibility'),
                  icon: CharcoalIcon(
                    viewModel.balanceHidden
                        ? CharcoalIcons.eyeClosed
                        : CharcoalIcons.eye,
                  ),
                  onPressed: viewModel.toggleBalanceVisibility,
                  semanticLabel: viewModel.balanceHidden
                      ? 'Show balance'
                      : 'Hide balance',
                  size: CharcoalIconButtonSize.small,
                  variant: CharcoalIconButtonVariant.overlay,
                ),
              ],
            ),
            SizedBox(height: space.md),
            Text(
              viewModel.balanceHidden
                  ? '¥ ••••••'
                  : formatYen(viewModel.balance),
              style: theme
                  .style(CharcoalTextRole.headingS)
                  .copyWith(color: theme.colors.textOnPrimary),
            ),
            SizedBox(height: space.xs),
            Text(
              '+ ¥42,800 this month',
              style: theme
                  .style(CharcoalTextRole.caption)
                  .copyWith(
                    color: theme.colors.textOnPrimary.withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

final class LumenQuickAction extends StatelessWidget {
  const LumenQuickAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final CharcoalIconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      children: <Widget>[
        CharcoalIconButton(
          icon: CharcoalIcon(icon),
          onPressed: onPressed,
          semanticLabel: label,
          size: CharcoalIconButtonSize.small,
        ),
        SizedBox(height: theme.space.xs),
        Text(
          label,
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(color: theme.colors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

final class LumenActivityRow extends StatelessWidget {
  const LumenActivityRow({required this.activity, super.key});

  final LumenActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final positive = activity.amount > 0;
    final icon = switch (activity.kind) {
      LumenActivityKind.card => CharcoalIcons.shopping,
      LumenActivityKind.received => CharcoalIcons.arrowDown,
      LumenActivityKind.sent => CharcoalIcons.send,
      LumenActivityKind.topUp => CharcoalIcons.addCircle,
    };
    return AgentDemoSurface(
      padding: EdgeInsets.all(space.sm),
      child: Row(
        children: <Widget>[
          CharcoalIcon(icon, color: theme.colors.iconSecondary, size: 18),
          SizedBox(width: space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity.title,
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(
                        color: theme.colors.text,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  activity.subtitle,
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(color: theme.colors.textTertiary, fontSize: 10),
                ),
              ],
            ),
          ),
          SizedBox(width: space.sm),
          Text(
            '${positive ? '+ ' : ''}${formatYen(activity.amount)}',
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(
                  color: positive
                      ? theme.colors.textPositive
                      : theme.colors.text,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
