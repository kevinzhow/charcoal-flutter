import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

enum AgentMobileApp { social, commerce, wallet, habits }

extension AgentMobileAppMetadata on AgentMobileApp {
  String get description => switch (this) {
    AgentMobileApp.social => 'Following feed and social reactions',
    AgentMobileApp.commerce => 'Search, categories, and product discovery',
    AgentMobileApp.wallet => 'Balance, shortcuts, and transactions',
    AgentMobileApp.habits => 'Daily progress and a focused checklist',
  };

  String get catalogIndex => switch (this) {
    AgentMobileApp.social => '01',
    AgentMobileApp.commerce => '02',
    AgentMobileApp.wallet => '03',
    AgentMobileApp.habits => '04',
  };

  String get interactionSummary => switch (this) {
    AgentMobileApp.social => 'Switch feeds, like posts, and save content.',
    AgentMobileApp.commerce => 'Search, change categories, and save products.',
    AgentMobileApp.wallet => 'Hide balances and explore finance shortcuts.',
    AgentMobileApp.habits => 'Complete habits and update daily progress.',
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

/// Responsive tile grid shared by all Agent Ready app entries.
final class AgentExampleTileGrid extends StatelessWidget {
  const AgentExampleTileGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final gap = theme.dimensions.space.component30;
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

/// A single discoverable entry that opens an interactive app simulation.
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
                  padding: EdgeInsets.all(theme.dimensions.space.component30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _AgentReadyBadge(),
                              ),
                            ),
                          ),
                          SizedBox(width: theme.dimensions.space.component20),
                          Text(
                            app.catalogIndex,
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: theme.dimensions.space.component20),
                      Text(
                        '${app.title} · ${app.type}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      SizedBox(height: theme.dimensions.space.component10),
                      Text(
                        app.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                      SizedBox(height: theme.dimensions.space.component25),
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

/// Full interactive simulator shown after an app tile is opened.
final class AgentMobileAppSimulator extends StatelessWidget {
  const AgentMobileAppSimulator({required this.app, super.key});

  final AgentMobileApp app;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(0, 360).toDouble();
        return Center(
          child: DecoratedBox(
            key: ValueKey<String>('agent-app-simulator-${app.keyName}'),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.borderSecondary),
              borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
              color: theme.colors.backgroundDefault,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
              child: SizedBox(
                width: width,
                height: 640,
                child: _phoneDemo(app),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _phoneDemo(AgentMobileApp app) => switch (app) {
  AgentMobileApp.social => const _SocialPhoneDemo(),
  AgentMobileApp.commerce => const _CommercePhoneDemo(),
  AgentMobileApp.wallet => const _WalletPhoneDemo(),
  AgentMobileApp.habits => const _HabitPhoneDemo(),
};

final class _AgentReadyBadge extends StatelessWidget {
  const _AgentReadyBadge();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component20,
          vertical: theme.dimensions.space.component10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.check,
              color: theme.colors.iconOnPrimaryDefault,
              size: 12,
            ),
            SizedBox(width: theme.dimensions.space.component10),
            Text(
              'MADE WITH AGENT READY',
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

enum _SocialFeed { following, discover }

final class _SocialPhoneDemo extends StatefulWidget {
  const _SocialPhoneDemo();

  @override
  State<_SocialPhoneDemo> createState() => _SocialPhoneDemoState();
}

final class _SocialPhoneDemoState extends State<_SocialPhoneDemo> {
  _SocialFeed _feed = _SocialFeed.following;
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appLabel: 'Bloom social app demo',
      brand: 'Bloom',
      brandColor: theme.colors.containerDiscoveryDefault,
      brandForeground: theme.colors.textOnDiscoveryDefault,
      brandMark: 'B',
      bottomItems: const <_BottomItem>[
        _BottomItem('Home', CharcoalIcons.home),
        _BottomItem('Discover', CharcoalIcons.compass),
        _BottomItem('Messages', CharcoalIcons.message),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: Padding(
        padding: EdgeInsets.fromLTRB(
          theme.dimensions.space.component30,
          theme.dimensions.space.component25,
          theme.dimensions.space.component30,
          theme.dimensions.space.component20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CharcoalSegmentedControl<_SocialFeed>(
              fullWidth: true,
              onChanged: (value) => setState(() => _feed = value),
              segments: const <CharcoalSegment<_SocialFeed>>[
                CharcoalSegment(
                  value: _SocialFeed.following,
                  child: Text('Following'),
                ),
                CharcoalSegment(
                  value: _SocialFeed.discover,
                  child: Text('Discover'),
                ),
              ],
              semanticLabel: 'Bloom feed',
              value: _feed,
            ),
            SizedBox(height: theme.dimensions.space.component25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _Story(initials: 'YO', label: 'Your story', tone: 0),
                _Story(initials: 'AK', label: 'Aki', tone: 1),
                _Story(initials: 'NO', label: 'Noa', tone: 2),
                _Story(initials: 'EM', label: 'Emi', tone: 3),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component25),
            _PhoneSurface(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(theme.dimensions.space.component25),
                    child: Row(
                      children: <Widget>[
                        const _DemoAvatar(initials: 'AK', tone: 1, size: 38),
                        SizedBox(width: theme.dimensions.space.component20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Aki Kondo',
                                style: theme.textStyles.captionMediumBold
                                    .copyWith(color: theme.colors.textDefault),
                              ),
                              Text(
                                '12 min · Kamakura',
                                style: theme.textStyles.captionSmall.copyWith(
                                  color: theme.colors.textSecondaryDefault,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CharcoalIconButton(
                          icon: const CharcoalIcon(
                            CharcoalIcons.dotsHorizontal,
                          ),
                          onPressed: () {},
                          semanticLabel: 'More post actions',
                          size: CharcoalIconButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.dimensions.space.component25,
                    ),
                    child: Text(
                      'Found a quiet patch of color between the rain clouds.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyles.captionMedium.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                  ),
                  SizedBox(height: theme.dimensions.space.component20),
                  const _DemoArtwork(height: 174, tone: 0),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.dimensions.space.component20,
                      vertical: theme.dimensions.space.component10,
                    ),
                    child: Row(
                      children: <Widget>[
                        CharcoalIconButton(
                          key: const ValueKey<String>('agent-social-like'),
                          icon: const CharcoalIcon(CharcoalIcons.heart),
                          onPressed: () => setState(() => _liked = !_liked),
                          selected: _liked,
                          semanticLabel: _liked ? 'Unlike post' : 'Like post',
                          size: CharcoalIconButtonSize.small,
                        ),
                        Text(
                          _liked ? '129' : '128',
                          style: theme.textStyles.captionSmall.copyWith(
                            color: theme.colors.textSecondaryDefault,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: theme.dimensions.space.component20),
                        CharcoalIconButton(
                          icon: const CharcoalIcon(CharcoalIcons.message),
                          onPressed: () {},
                          semanticLabel: 'Comment on post',
                          size: CharcoalIconButtonSize.small,
                        ),
                        Text(
                          '24',
                          style: theme.textStyles.captionSmall.copyWith(
                            color: theme.colors.textSecondaryDefault,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        CharcoalIconButton(
                          key: const ValueKey<String>('agent-social-save'),
                          icon: const CharcoalIcon(CharcoalIcons.bookmark),
                          onPressed: () => setState(() => _saved = !_saved),
                          selected: _saved,
                          semanticLabel: _saved
                              ? 'Remove bookmark'
                              : 'Bookmark post',
                          size: CharcoalIconButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      selectedBottomIndex: 0,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.bell),
        onPressed: () {},
        semanticLabel: 'Bloom notifications',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }
}

enum _CommerceCategory { newItems, home, gifts }

final class _CommercePhoneDemo extends StatefulWidget {
  const _CommercePhoneDemo();

  @override
  State<_CommercePhoneDemo> createState() => _CommercePhoneDemoState();
}

final class _CommercePhoneDemoState extends State<_CommercePhoneDemo> {
  _CommerceCategory _category = _CommerceCategory.newItems;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appLabel: 'Nook commerce app demo',
      brand: 'Nook',
      brandColor: theme.colors.containerNoticeDefault,
      brandForeground: theme.colors.textOnNoticeDefault,
      brandMark: 'N',
      bottomItems: const <_BottomItem>[
        _BottomItem('Shop', CharcoalIcons.shopping),
        _BottomItem('Search', CharcoalIcons.search),
        _BottomItem('Saved', CharcoalIcons.bookmark),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: Padding(
        padding: EdgeInsets.fromLTRB(
          theme.dimensions.space.component30,
          theme.dimensions.space.component25,
          theme.dimensions.space.component30,
          theme.dimensions.space.component20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Good morning, Mina',
                        style: theme.textStyles.headingXxs.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      Text(
                        'Small things for a calmer home',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component20),
            const CharcoalTextField(
              placeholder: 'Search the collection',
              prefix: CharcoalIcon(CharcoalIcons.search),
            ),
            SizedBox(height: theme.dimensions.space.component20),
            CharcoalSegmentedControl<_CommerceCategory>(
              fullWidth: true,
              onChanged: (value) => setState(() => _category = value),
              segments: const <CharcoalSegment<_CommerceCategory>>[
                CharcoalSegment(
                  value: _CommerceCategory.newItems,
                  child: Text('New'),
                ),
                CharcoalSegment(
                  value: _CommerceCategory.home,
                  child: Text('Home'),
                ),
                CharcoalSegment(
                  value: _CommerceCategory.gifts,
                  child: Text('Gifts'),
                ),
              ],
              semanticLabel: 'Nook category',
              value: _category,
            ),
            SizedBox(height: theme.dimensions.space.component20),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: theme.colors.containerDiscoveryDefault,
              ),
              child: SizedBox(
                height: 98,
                child: Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.component30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Slow Sunday edit',
                              style: theme.textStyles.captionMediumBold
                                  .copyWith(
                                    color: theme.colors.textOnDiscoveryDefault,
                                  ),
                            ),
                            SizedBox(
                              height: theme.dimensions.space.component10,
                            ),
                            Text(
                              'Warm textures · up to 25% off',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textOnDiscoveryDefault
                                    .withValues(alpha: 0.78),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _PromoShape(color: theme.colors.containerNoticeDefault),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: theme.dimensions.space.component25),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Popular today',
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  ),
                ),
                Text(
                  'See all',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textInfoDefault,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _MiniProductCard(
                    name: 'Ripple cup',
                    price: '¥2,800',
                    saved: _saved,
                    tone: 1,
                    onSave: () => setState(() => _saved = !_saved),
                  ),
                ),
                SizedBox(width: theme.dimensions.space.component20),
                const Expanded(
                  child: _MiniProductCard(
                    name: 'Linen tray',
                    price: '¥3,400',
                    tone: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      selectedBottomIndex: 0,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.shopping),
        onPressed: () {},
        semanticLabel: 'Shopping bag, two items',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }
}

final class _WalletPhoneDemo extends StatefulWidget {
  const _WalletPhoneDemo();

  @override
  State<_WalletPhoneDemo> createState() => _WalletPhoneDemoState();
}

final class _WalletPhoneDemoState extends State<_WalletPhoneDemo> {
  bool _balanceHidden = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appLabel: 'Lumen personal finance app demo',
      brand: 'Lumen',
      brandColor: theme.colors.containerPositiveDefault,
      brandForeground: theme.colors.textOnPositiveDefault,
      brandMark: 'L',
      bottomItems: const <_BottomItem>[
        _BottomItem('Wallet', CharcoalIcons.invoice),
        _BottomItem('Activity', CharcoalIcons.history),
        _BottomItem('Plan', CharcoalIcons.calendar),
        _BottomItem('Profile', CharcoalIcons.personCircle),
      ],
      content: Padding(
        padding: EdgeInsets.fromLTRB(
          theme.dimensions.space.component30,
          theme.dimensions.space.component25,
          theme.dimensions.space.component30,
          theme.dimensions.space.component20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Good afternoon',
                    style: theme.textStyles.headingXxs.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  ),
                ),
                const _DemoAvatar(initials: 'MA', tone: 2, size: 36),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component25),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    theme.colors.containerPrimaryDefault,
                    theme.colors.containerDiscoveryDefault,
                  ],
                ),
              ),
              child: SizedBox(
                height: 132,
                child: Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.component30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'AVAILABLE BALANCE',
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textOnPrimaryDefault
                                    .withValues(alpha: 0.72),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          CharcoalIconButton(
                            key: const ValueKey<String>(
                              'agent-wallet-visibility',
                            ),
                            icon: CharcoalIcon(
                              _balanceHidden
                                  ? CharcoalIcons.eyeClosed
                                  : CharcoalIcons.eye,
                            ),
                            onPressed: () => setState(
                              () => _balanceHidden = !_balanceHidden,
                            ),
                            semanticLabel: _balanceHidden
                                ? 'Show balance'
                                : 'Hide balance',
                            size: CharcoalIconButtonSize.small,
                            variant: CharcoalIconButtonVariant.overlay,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        _balanceHidden ? '¥ ••••••' : '¥ 1,284,600',
                        style: theme.textStyles.headingS.copyWith(
                          color: theme.colors.textOnPrimaryDefault,
                        ),
                      ),
                      SizedBox(height: theme.dimensions.space.component10),
                      Text(
                        '+ ¥42,800 this month',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textOnPrimaryDefault.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: theme.dimensions.space.component25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _QuickAction(icon: CharcoalIcons.arrowDown, label: 'Receive'),
                _QuickAction(icon: CharcoalIcons.send, label: 'Send'),
                _QuickAction(icon: CharcoalIcons.addCircle, label: 'Top up'),
                _QuickAction(icon: CharcoalIcons.dotsHorizontal, label: 'More'),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component30),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Recent activity',
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  ),
                ),
                Text(
                  'August',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component20),
            const _TransactionRow(
              amount: '− ¥1,240',
              icon: CharcoalIcons.shopping,
              subtitle: 'Today · Card',
              title: 'Morning Market',
            ),
            const _TransactionRow(
              amount: '+ ¥8,000',
              icon: CharcoalIcons.persons,
              positive: true,
              subtitle: 'Yesterday · Transfer',
              title: 'From Hana',
            ),
            const _TransactionRow(
              amount: '− ¥980',
              icon: CharcoalIcons.book,
              subtitle: 'Aug 15 · Card',
              title: 'Mori Books',
            ),
          ],
        ),
      ),
      selectedBottomIndex: 0,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.bell),
        onPressed: () {},
        semanticLabel: 'Lumen notifications',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }
}

final class _HabitPhoneDemo extends StatefulWidget {
  const _HabitPhoneDemo();

  @override
  State<_HabitPhoneDemo> createState() => _HabitPhoneDemoState();
}

final class _HabitPhoneDemoState extends State<_HabitPhoneDemo> {
  bool _read = false;
  bool _stretch = true;
  bool _walk = false;

  int get _completed =>
      <bool>[_stretch, _walk, _read].where((value) => value).length;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 340;
        return _PhoneDemoShell(
          appLabel: 'Daylight wellness app demo',
          brand: 'Daylight',
          brandColor: theme.colors.containerDiscoveryDefault,
          brandForeground: theme.colors.textOnDiscoveryDefault,
          brandMark: 'D',
          bottomItems: const <_BottomItem>[
            _BottomItem('Today', CharcoalIcons.sun),
            _BottomItem('Journey', CharcoalIcons.calendar),
            _BottomItem('Insights', CharcoalIcons.star),
            _BottomItem('Profile', CharcoalIcons.personCircle),
          ],
          content: Padding(
            padding: EdgeInsets.fromLTRB(
              theme.dimensions.space.component30,
              theme.dimensions.space.component25,
              theme.dimensions.space.component30,
              theme.dimensions.space.component20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Monday, August 17',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component10),
                Text(
                  'A gentle day is still progress.',
                  style: theme.textStyles.headingXxs.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component25),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.l,
                    ),
                    color: theme.colors.containerNoticeDefault,
                  ),
                  child: SizedBox(
                    height: 104,
                    child: Padding(
                      padding: EdgeInsets.all(
                        compact
                            ? theme.dimensions.space.component25
                            : theme.dimensions.space.component30,
                      ),
                      child: Row(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colors.iconOnNoticeDefault
                                    .withValues(alpha: 0.32),
                                width: 6,
                              ),
                              borderRadius: BorderRadius.circular(999),
                              color: theme.colors.backgroundDefault.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            child: SizedBox.square(
                              dimension: compact ? 56 : 64,
                              child: Center(
                                child: Text(
                                  '$_completed/3',
                                  style: theme.textStyles.captionMediumBold
                                      .copyWith(
                                        color: theme.colors.textOnNoticeDefault,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: compact
                                ? theme.dimensions.space.component20
                                : theme.dimensions.space.component30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Today’s rhythm',
                                  style:
                                      (compact
                                              ? theme.textStyles.captionSmall
                                              : theme
                                                    .textStyles
                                                    .captionMediumBold)
                                          .copyWith(
                                            color: theme
                                                .colors
                                                .textOnNoticeDefault,
                                            fontWeight: FontWeight.w700,
                                          ),
                                ),
                                SizedBox(
                                  height: theme.dimensions.space.component10,
                                ),
                                Text(
                                  _completed == 3
                                      ? 'Everything is complete.'
                                      : 3 - _completed == 1
                                      ? '1 small step remaining'
                                      : '${3 - _completed} small steps remaining',
                                  style: theme.textStyles.captionSmall.copyWith(
                                    color: theme.colors.textOnNoticeDefault
                                        .withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component30),
                Text(
                  'Your habits',
                  style: theme.textStyles.captionMediumBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component20),
                _HabitRow(
                  key: const ValueKey<String>('agent-habit-stretch-row'),
                  checked: _stretch,
                  icon: CharcoalIcons.body,
                  label: 'Morning stretch',
                  onChanged: (value) => setState(() => _stretch = value),
                  streak: '7 days',
                ),
                SizedBox(height: theme.dimensions.space.component20),
                _HabitRow(
                  key: const ValueKey<String>('agent-habit-walk-row'),
                  checked: _walk,
                  icon: CharcoalIcons.location,
                  label: 'Walk outside',
                  onChanged: (value) => setState(() => _walk = value),
                  streak: '3 days',
                ),
                SizedBox(height: theme.dimensions.space.component20),
                _HabitRow(
                  key: const ValueKey<String>('agent-habit-read-row'),
                  checked: _read,
                  icon: CharcoalIcons.book,
                  label: 'Read for 20 minutes',
                  onChanged: (value) => setState(() => _read = value),
                  streak: '5 days',
                ),
                SizedBox(height: theme.dimensions.space.component25),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.m,
                    ),
                    color: theme.colors.containerSecondaryDefault,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(theme.dimensions.space.component25),
                    child: Row(
                      children: <Widget>[
                        CharcoalIcon(
                          CharcoalIcons.bulbShine,
                          color: theme.colors.iconNoticeDefault,
                        ),
                        SizedBox(width: theme.dimensions.space.component20),
                        Expanded(
                          child: Text(
                            'Consistency grows from kindness, not pressure.',
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textSecondaryDefault,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          selectedBottomIndex: 0,
          trailing: CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons.calendar),
            onPressed: () {},
            semanticLabel: 'Open Daylight calendar',
            size: CharcoalIconButtonSize.small,
          ),
        );
      },
    );
  }
}

final class _PhoneDemoShell extends StatelessWidget {
  const _PhoneDemoShell({
    required this.appLabel,
    required this.bottomItems,
    required this.brand,
    required this.brandColor,
    required this.brandForeground,
    required this.brandMark,
    required this.content,
    required this.selectedBottomIndex,
    required this.trailing,
  });

  final String appLabel;
  final List<_BottomItem> bottomItems;
  final String brand;
  final Color brandColor;
  final Color brandForeground;
  final String brandMark;
  final Widget content;
  final int selectedBottomIndex;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: appLabel,
      child: ColoredBox(
        color: theme.colors.backgroundSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colors.borderSecondary),
                ),
                color: theme.colors.backgroundDefault,
              ),
              child: SizedBox(
                height: 64,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.dimensions.space.component30,
                    vertical: theme.dimensions.space.component25,
                  ),
                  child: Row(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            theme.dimensions.radius.m,
                          ),
                          color: brandColor,
                        ),
                        child: SizedBox.square(
                          dimension: 36,
                          child: Center(
                            child: Text(
                              brandMark,
                              style: theme.textStyles.captionMediumBold
                                  .copyWith(color: brandForeground),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: theme.dimensions.space.component20),
                      Expanded(
                        child: Text(
                          brand,
                          style: theme.textStyles.bodyBold.copyWith(
                            color: theme.colors.textDefault,
                          ),
                        ),
                      ),
                      trailing,
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: content),
            _MobileBottomBar(
              items: bottomItems,
              selectedIndex: selectedBottomIndex,
            ),
          ],
        ),
      ),
    );
  }
}

final class _BottomItem {
  const _BottomItem(this.label, this.icon);

  final CharcoalIconData icon;
  final String label;
}

final class _MobileBottomBar extends StatelessWidget {
  const _MobileBottomBar({required this.items, required this.selectedIndex});

  final List<_BottomItem> items;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: <Widget>[
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: _BottomNavItem(
                  item: items[index],
                  selected: index == selectedIndex,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({required this.item, required this.selected});

  final _BottomItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: () {},
      selected: selected,
      semanticLabel: item.label,
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        color: selected ? theme.colors.containerSecondaryDefaultA : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CharcoalIcon(
              item.icon,
              color: selected
                  ? theme.colors.iconDefault
                  : theme.colors.iconTertiaryDefault,
              size: 20,
            ),
            SizedBox(height: theme.dimensions.space.component10),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyles.captionSmall.copyWith(
                color: selected
                    ? theme.colors.textDefault
                    : theme.colors.textTertiaryDefault,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PhoneSurface extends StatelessWidget {
  const _PhoneSurface({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.dimensions.space.component25),
        child: child,
      ),
    );
  }
}

final class _Story extends StatelessWidget {
  const _Story({
    required this.initials,
    required this.label,
    required this.tone,
  });

  final String initials;
  final String label;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 66,
      child: Column(
        children: <Widget>[
          _DemoAvatar(initials: initials, tone: tone, size: 46),
          SizedBox(height: theme.dimensions.space.component10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

final class _DemoAvatar extends StatelessWidget {
  const _DemoAvatar({
    required this.initials,
    required this.size,
    required this.tone,
  });

  final String initials;
  final double size;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final background = switch (tone % 4) {
      0 => theme.colors.containerPrimaryDefault,
      1 => theme.colors.containerDiscoveryDefault,
      2 => theme.colors.containerNoticeDefault,
      _ => theme.colors.containerPositiveDefault,
    };
    final foreground = switch (tone % 4) {
      0 => theme.colors.textOnPrimaryDefault,
      1 => theme.colors.textOnDiscoveryDefault,
      2 => theme.colors.textOnNoticeDefault,
      _ => theme.colors.textOnPositiveDefault,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: background,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            initials,
            style: theme.textStyles.captionSmall.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

final class _DemoArtwork extends StatelessWidget {
  const _DemoArtwork({required this.height, required this.tone});

  final double height;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final palette = switch (tone % 4) {
      0 => (
        theme.colors.containerPrimaryDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNoticeDefault,
      ),
      1 => (
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerPositiveDefault,
        theme.colors.backgroundDefault,
      ),
      2 => (
        theme.colors.containerNoticeDefault,
        theme.colors.containerPrimaryDefault,
        theme.colors.containerNegativeDefault,
      ),
      _ => (
        theme.colors.containerPositiveDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNeutralDefault,
      ),
    };
    return Semantics(
      image: true,
      label: 'Abstract content artwork',
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: ClipRect(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[palette.$1, palette.$2],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: -48,
                    left: -28,
                    child: _DecorativeCircle(color: palette.$3, size: 148),
                  ),
                  Positioned(
                    right: 30,
                    top: 28,
                    child: Transform.rotate(
                      angle: -0.28,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            theme.dimensions.radius.m,
                          ),
                          color: palette.$3.withValues(alpha: 0.76),
                        ),
                        child: const SizedBox.square(dimension: 78),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: color,
    ),
    child: SizedBox.square(dimension: size),
  );
}

final class _PromoShape extends StatelessWidget {
  const _PromoShape({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: 0.24,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color,
      ),
      child: const SizedBox.square(dimension: 60),
    ),
  );
}

final class _MiniProductCard extends StatelessWidget {
  const _MiniProductCard({
    required this.name,
    required this.price,
    required this.tone,
    this.onSave,
    this.saved = false,
  });

  final String name;
  final VoidCallback? onSave;
  final String price;
  final bool saved;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(theme.dimensions.radius.m),
            ),
            child: _DemoArtwork(height: 72, tone: tone),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              theme.dimensions.space.component20,
              theme.dimensions.space.component20,
              theme.dimensions.space.component10,
              theme.dimensions.space.component20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textDefault,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        price,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
                CharcoalIconButton(
                  key: onSave == null
                      ? null
                      : const ValueKey<String>('agent-commerce-save'),
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

final class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

  final CharcoalIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      children: <Widget>[
        CharcoalIconButton(
          icon: CharcoalIcon(icon),
          onPressed: () {},
          semanticLabel: label,
          size: CharcoalIconButtonSize.small,
        ),
        SizedBox(height: theme.dimensions.space.component10),
        Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textSecondaryDefault,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

final class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.amount,
    required this.icon,
    required this.subtitle,
    required this.title,
    this.positive = false,
  });

  final String amount;
  final CharcoalIconData icon;
  final bool positive;
  final String subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      height: 52,
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerSecondaryDefault,
            ),
            child: SizedBox.square(
              dimension: 38,
              child: Center(
                child: CharcoalIcon(
                  icon,
                  color: theme.colors.iconDefault,
                  size: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: theme.dimensions.space.component20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textDefault,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textTertiaryDefault,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: theme.dimensions.space.component20),
          Text(
            amount,
            style: theme.textStyles.captionSmall.copyWith(
              color: positive
                  ? theme.colors.textPositiveDefault
                  : theme.colors.textDefault,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

final class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.checked,
    required this.icon,
    required this.label,
    required this.onChanged,
    required this.streak,
    super.key,
  });

  final bool checked;
  final CharcoalIconData icon;
  final String label;
  final ValueChanged<bool> onChanged;
  final String streak;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneSurface(
      padding: EdgeInsets.symmetric(
        horizontal: theme.dimensions.space.component20,
        vertical: theme.dimensions.space.component10,
      ),
      child: Row(
        children: <Widget>[
          CharcoalIcon(
            icon,
            color: theme.colors.iconSecondaryDefault,
            size: 20,
          ),
          SizedBox(width: theme.dimensions.space.component20),
          Expanded(
            child: CharcoalCheckbox(
              label: Text(label),
              onChanged: onChanged,
              rounded: true,
              semanticLabel: label,
              value: checked,
            ),
          ),
          SizedBox(width: theme.dimensions.space.component10),
          Text(
            streak,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
