import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import 'bloom/bloom.dart';
import 'mobile_apps/daylight/daylight_demo.dart';
import 'mobile_apps/lumen/lumen_demo.dart';
import 'mobile_apps/nook/nook_demo.dart';

enum AgentMobileApp { social, commerce, wallet, habits }

extension AgentMobileAppMetadata on AgentMobileApp {
  String get description => switch (this) {
    AgentMobileApp.social => 'Following feed and social reactions',
    AgentMobileApp.commerce => 'Product discovery through confirmed checkout',
    AgentMobileApp.wallet => 'Private balance and reviewed money movement',
    AgentMobileApp.habits => 'Breathable daily progress and tomorrow planning',
  };

  String get catalogIndex => switch (this) {
    AgentMobileApp.social => '01',
    AgentMobileApp.commerce => '02',
    AgentMobileApp.wallet => '03',
    AgentMobileApp.habits => '04',
  };

  String get keyName => switch (this) {
    AgentMobileApp.social => 'social',
    AgentMobileApp.commerce => 'commerce',
    AgentMobileApp.wallet => 'wallet',
    AgentMobileApp.habits => 'habits',
  };

  String get title => switch (this) {
    AgentMobileApp.social => 'Bloom',
    AgentMobileApp.commerce => 'Nook',
    AgentMobileApp.wallet => 'Lumen',
    AgentMobileApp.habits => 'Daylight',
  };

  String get type => switch (this) {
    AgentMobileApp.social => 'SOCIAL',
    AgentMobileApp.commerce => 'COMMERCE',
    AgentMobileApp.wallet => 'FINANCE',
    AgentMobileApp.habits => 'WELLNESS',
  };
}

final class AgentExampleTileGrid extends StatelessWidget {
  const AgentExampleTileGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = CharcoalTheme.of(context).dimensions.space.component30;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 960
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          key: const ValueKey<String>('agent-example-tile-grid'),
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final child in children)
              SizedBox(width: cardWidth, child: child),
          ],
        );
      },
    );
  }
}

final class AgentMobileAppTile extends StatelessWidget {
  const AgentMobileAppTile({
    required this.app,
    required this.onPressed,
    super.key,
  });

  final AgentMobileApp app;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return CharcoalClickable(
      key: ValueKey<String>('agent-app-tile-${app.keyName}'),
      onPressed: onPressed,
      semanticLabel: 'Open ${app.title} simulation',
      builder: (context, states) {
        final active =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed);
        return AnimatedContainer(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.fast,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: active
                  ? theme.colors.borderDefault
                  : theme.colors.borderSecondary,
            ),
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            color: states.contains(WidgetState.pressed)
                ? theme.colors.containerSecondaryDefaultA
                : theme.colors.backgroundDefault,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 210,
                  child: IgnorePointer(
                    child: ClipRect(
                      child: FittedBox(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: 360,
                          height: 640,
                          child: _phoneDemo(app),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: theme.dimensions.borderWidth.m,
                  child: ColoredBox(color: theme.colors.borderSecondary),
                ),
                Padding(
                  padding: EdgeInsets.all(space.component30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) => Align(
                                alignment: Alignment.centerLeft,
                                child: _AgentReadyBadge(
                                  compact: constraints.maxWidth < 240,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: space.component20),
                          Text(
                            app.catalogIndex,
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: space.component20),
                      Text(
                        '${app.title} · ${app.type}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      SizedBox(height: space.component10),
                      Text(
                        app.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                      SizedBox(height: space.component25),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Open simulation',
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textInfoDefault,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CharcoalIcon(
                            CharcoalIcons.chevronRight,
                            color: theme.colors.iconDefault,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class AgentMobileAppSimulator extends StatelessWidget {
  const AgentMobileAppSimulator({required this.app, super.key});

  final AgentMobileApp app;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageInset = theme.dimensions.space.component10;
        final width = (constraints.maxWidth - stageInset * 2)
            .clamp(0, 390)
            .toDouble();
        return Center(
          child: DecoratedBox(
            key: ValueKey<String>('agent-app-simulator-stage-${app.keyName}'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
              color: theme.colors.backgroundTertiary,
            ),
            child: Padding(
              padding: EdgeInsets.all(stageInset),
              child: DecoratedBox(
                key: ValueKey<String>('agent-app-simulator-${app.keyName}'),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colors.borderDefault,
                    width: theme.dimensions.borderWidth.m,
                  ),
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.m,
                  ),
                  color: theme.colors.backgroundDefault,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.m,
                  ),
                  child: SizedBox(
                    width: width,
                    height: 640,
                    child: _phoneDemo(app),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _phoneDemo(AgentMobileApp app) => switch (app) {
  AgentMobileApp.social => const BloomDemo(),
  AgentMobileApp.commerce => const NookDemo(),
  AgentMobileApp.wallet => const LumenDemo(),
  AgentMobileApp.habits => const DaylightDemo(),
};

final class _AgentReadyBadge extends StatelessWidget {
  const _AgentReadyBadge({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: space.component20,
          vertical: space.component10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.check,
              color: theme.colors.iconOnPrimaryDefault,
              size: 12,
            ),
            SizedBox(width: space.component10),
            Text(
              compact ? 'AGENT READY' : 'MADE WITH AGENT READY',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textOnPrimaryDefault,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
