import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import 'bloom/bloom.dart';

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
    final space = theme.dimensions.space;
    final gap = space.component30;
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
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _AgentReadyBadge(),
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

/// Full interactive simulator shown after an app tile is opened.
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
            .clamp(0, 360)
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
  AgentMobileApp.commerce => const _CommercePhoneDemo(),
  AgentMobileApp.wallet => const _WalletPhoneDemo(),
  AgentMobileApp.habits => const _HabitPhoneDemo(),
};

final class _AgentReadyBadge extends StatelessWidget {
  const _AgentReadyBadge();

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

enum _CommerceCategory { newItems, home, gifts }

final class _CommerceProduct {
  const _CommerceProduct({
    required this.category,
    required this.id,
    required this.name,
    required this.price,
    required this.subtitle,
    required this.tone,
  });

  final _CommerceCategory category;
  final String id;
  final String name;
  final String price;
  final String subtitle;
  final int tone;
}

const _commerceProducts = <_CommerceProduct>[
  _CommerceProduct(
    category: _CommerceCategory.newItems,
    id: 'ripple-cup',
    name: 'Ripple cup',
    price: '¥2,800',
    subtitle: 'Hand-glazed stoneware',
    tone: 1,
  ),
  _CommerceProduct(
    category: _CommerceCategory.newItems,
    id: 'linen-tray',
    name: 'Linen tray',
    price: '¥3,400',
    subtitle: 'Soft structure for small things',
    tone: 3,
  ),
  _CommerceProduct(
    category: _CommerceCategory.home,
    id: 'paper-lamp',
    name: 'Paper lamp',
    price: '¥8,900',
    subtitle: 'A warm pool of evening light',
    tone: 0,
  ),
  _CommerceProduct(
    category: _CommerceCategory.home,
    id: 'wool-cushion',
    name: 'Wool cushion',
    price: '¥6,200',
    subtitle: 'Woven in a quiet moss tone',
    tone: 2,
  ),
  _CommerceProduct(
    category: _CommerceCategory.gifts,
    id: 'tea-pair',
    name: 'Tea pair',
    price: '¥4,600',
    subtitle: 'Two cups wrapped for sharing',
    tone: 2,
  ),
  _CommerceProduct(
    category: _CommerceCategory.gifts,
    id: 'letter-set',
    name: 'Letter set',
    price: '¥1,900',
    subtitle: 'Textured paper and six envelopes',
    tone: 0,
  ),
];

final class _CommercePhoneDemo extends StatefulWidget {
  const _CommercePhoneDemo();

  @override
  State<_CommercePhoneDemo> createState() => _CommercePhoneDemoState();
}

final class _CommercePhoneDemoState extends State<_CommercePhoneDemo> {
  _CommerceCategory _category = _CommerceCategory.newItems;
  final Set<String> _bag = <String>{};
  final Set<String> _saved = <String>{};
  String _query = '';
  String? _status;
  _CommerceProduct? _selectedProduct;
  int _selectedBottomIndex = 0;
  bool _bagOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'commerce',
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
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) => setState(() {
        _selectedBottomIndex = index;
        _selectedProduct = null;
        _bagOpen = false;
        _status = null;
      }),
      selectedBottomIndex: _selectedBottomIndex,
      trailing: CharcoalIconButton(
        key: const ValueKey<String>('agent-commerce-bag'),
        icon: const CharcoalIcon(CharcoalIcons.shopping),
        onPressed: () => setState(() {
          _selectedBottomIndex = 0;
          _selectedProduct = null;
          _bagOpen = true;
        }),
        semanticLabel: 'Shopping bag, ${_bag.length} items',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }

  List<_CommerceProduct> get _visibleProducts {
    final normalizedQuery = _query.trim().toLowerCase();
    return _commerceProducts
        .where((product) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              product.name.toLowerCase().contains(normalizedQuery) ||
              product.subtitle.toLowerCase().contains(normalizedQuery);
          final matchesCategory =
              normalizedQuery.isNotEmpty ||
              _selectedBottomIndex == 1 ||
              product.category == _category;
          return matchesQuery && matchesCategory;
        })
        .toList(growable: false);
  }

  Widget _buildSelectedPage(CharcoalThemeData theme) {
    if (_bagOpen) return _buildBag(theme);
    final product = _selectedProduct;
    if (product != null) return _buildProductDetail(theme, product);
    return switch (_selectedBottomIndex) {
      0 => _buildShop(theme),
      1 => _buildSearch(theme),
      2 => _buildSaved(theme),
      _ => _buildCommerceProfile(theme),
    };
  }

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildShop(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-shop-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'GOOD MORNING, MINA',
            title: 'Small things for a calmer home',
          ),
          SizedBox(height: space.component20),
          _commerceSearchField(),
          SizedBox(height: space.component20),
          _categoryControl(),
          SizedBox(height: space.component20),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerDiscoveryDefault,
            ),
            child: SizedBox(
              height: 98,
              child: Padding(
                padding: EdgeInsets.all(space.component30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Slow Sunday edit',
                            style: theme.textStyles.captionMediumBold.copyWith(
                              color: theme.colors.textOnDiscoveryDefault,
                            ),
                          ),
                          SizedBox(height: space.component10),
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
          SizedBox(height: space.component25),
          _PhoneSectionTitle(
            title: _query.trim().isEmpty
                ? switch (_category) {
                    _CommerceCategory.newItems => 'New this week',
                    _CommerceCategory.home => 'For your home',
                    _CommerceCategory.gifts => 'Thoughtful gifts',
                  }
                : 'Search results',
          ),
          SizedBox(height: space.component20),
          _buildProductGrid(theme, _visibleProducts),
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _SimulationStatus(message: _status!),
          ],
        ],
      ),
    );
  }

  Widget _buildSearch(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-search-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'SEARCH',
            title: 'Find exactly what feels right',
          ),
          SizedBox(height: space.component25),
          _commerceSearchField(showLabel: true),
          SizedBox(height: space.component25),
          _PhoneSectionTitle(
            title: _query.trim().isEmpty
                ? 'Browse the full collection'
                : '${_visibleProducts.length} matches',
          ),
          SizedBox(height: space.component20),
          _buildProductGrid(theme, _visibleProducts),
        ],
      ),
    );
  }

  Widget _buildSaved(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final products = _commerceProducts
        .where((product) => _saved.contains(product.id))
        .toList(growable: false);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-saved-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'SAVED',
            title: 'Keep ideas for later',
          ),
          SizedBox(height: space.component25),
          if (products.isEmpty)
            const _SimulationEmptyState(
              description: 'Bookmark a product and it will appear here.',
              title: 'Nothing saved yet',
            )
          else
            _buildProductGrid(theme, products),
        ],
      ),
    );
  }

  Widget _buildCommerceProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'PROFILE',
            title: 'Good morning, Mina',
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message:
                '${_saved.length} saved · ${_bag.length} in bag · Free delivery enabled',
          ),
          SizedBox(height: space.component25),
          for (final label in const <String>[
            'Orders and returns',
            'Delivery addresses',
            'Payment methods',
          ]) ...<Widget>[
            CharcoalNavigationItem(
              onPressed: () =>
                  setState(() => _status = '$label opened in this simulation.'),
              trailing: const CharcoalIcon(CharcoalIcons.chevronRight),
              child: Text(label),
            ),
            SizedBox(height: space.component20),
          ],
          if (_status != null) _SimulationStatus(message: _status!),
        ],
      ),
    );
  }

  Widget _commerceSearchField({bool showLabel = false}) => CharcoalTextField(
    key: const ValueKey<String>('agent-commerce-search'),
    label: 'Search the collection',
    onChanged: (value) => setState(() => _query = value),
    placeholder: 'Try “lamp” or “paper”',
    prefix: const CharcoalIcon(CharcoalIcons.search),
    showLabel: showLabel,
  );

  Widget _categoryControl() => CharcoalSegmentedControl<_CommerceCategory>(
    key: const ValueKey<String>('agent-commerce-category'),
    fullWidth: true,
    onChanged: (value) => setState(() {
      _category = value;
      _status = 'Category changed to ${value.name}.';
    }),
    segments: const <CharcoalSegment<_CommerceCategory>>[
      CharcoalSegment(value: _CommerceCategory.newItems, child: Text('New')),
      CharcoalSegment(value: _CommerceCategory.home, child: Text('Home')),
      CharcoalSegment(value: _CommerceCategory.gifts, child: Text('Gifts')),
    ],
    semanticLabel: 'Nook category',
    value: _category,
  );

  Widget _buildProductGrid(
    CharcoalThemeData theme,
    List<_CommerceProduct> products,
  ) {
    if (products.isEmpty) {
      return _SimulationEmptyState(
        description: 'Try another word or browse a different category.',
        title: 'No products for “${_query.trim()}”',
      );
    }
    final space = theme.dimensions.space;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - space.component20) / 2;
        return Wrap(
          spacing: space.component20,
          runSpacing: space.component25,
          children: <Widget>[
            for (final product in products)
              SizedBox(
                width: width,
                child: _MiniProductCard(
                  key: ValueKey<String>('agent-commerce-product-${product.id}'),
                  name: product.name,
                  onOpen: () => setState(() => _selectedProduct = product),
                  onSave: () => _toggleSaved(product),
                  price: product.price,
                  saved: _saved.contains(product.id),
                  saveKey: ValueKey<String>(
                    product.id == 'ripple-cup'
                        ? 'agent-commerce-save'
                        : 'agent-commerce-save-${product.id}',
                  ),
                  tone: product.tone,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProductDetail(
    CharcoalThemeData theme,
    _CommerceProduct product,
  ) {
    final space = theme.dimensions.space;
    final saved = _saved.contains(product.id);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-product-detail'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalButton(
            leading: const CharcoalIcon(CharcoalIcons.chevronLeft),
            onPressed: () => setState(() => _selectedProduct = null),
            size: CharcoalButtonSize.small,
            child: const Text('Back to products'),
          ),
          SizedBox(height: space.component25),
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            child: _DemoArtwork(height: 220, tone: product.tone),
          ),
          SizedBox(height: space.component25),
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
            product.price,
            style: theme.textStyles.bodyBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component25),
          CharcoalButton(
            key: const ValueKey<String>('agent-commerce-add-to-bag'),
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.shopping),
            onPressed: () => setState(() {
              _bag.add(product.id);
              _status = '${product.name} was added to your bag.';
            }),
            variant: CharcoalButtonVariant.primary,
            child: Text(
              _bag.contains(product.id) ? 'Added to bag' : 'Add to bag',
            ),
          ),
          SizedBox(height: space.component20),
          CharcoalButton(
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.bookmark),
            onPressed: () => _toggleSaved(product),
            selected: saved,
            child: Text(saved ? 'Saved' : 'Save for later'),
          ),
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _SimulationStatus(message: _status!),
          ],
        ],
      ),
    );
  }

  Widget _buildBag(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    final products = _commerceProducts
        .where((product) => _bag.contains(product.id))
        .toList(growable: false);
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-commerce-bag-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalButton(
            leading: const CharcoalIcon(CharcoalIcons.chevronLeft),
            onPressed: () => setState(() => _bagOpen = false),
            size: CharcoalButtonSize.small,
            child: const Text('Continue shopping'),
          ),
          SizedBox(height: space.component25),
          const _PhonePageHeading(eyebrow: 'BAG', title: 'Ready when you are'),
          SizedBox(height: space.component25),
          if (products.isEmpty)
            const _SimulationEmptyState(
              description: 'Open a product and add it to begin checkout.',
              title: 'Your bag is empty',
            )
          else ...<Widget>[
            for (final product in products) ...<Widget>[
              _SimulationStatus(message: '${product.name} · ${product.price}'),
              SizedBox(height: space.component20),
            ],
            CharcoalButton(
              key: const ValueKey<String>('agent-commerce-checkout'),
              fullWidth: true,
              onPressed: () => setState(() {
                _status = products.length == 1
                    ? 'Checkout is ready for 1 item.'
                    : 'Checkout is ready for ${products.length} items.';
              }),
              variant: CharcoalButtonVariant.primary,
              child: const Text('Continue to checkout'),
            ),
            if (_status != null) ...<Widget>[
              SizedBox(height: space.component25),
              _SimulationStatus(message: _status!),
            ],
          ],
        ],
      ),
    );
  }

  void _toggleSaved(_CommerceProduct product) {
    setState(() {
      final removed = _saved.remove(product.id);
      if (!removed) _saved.add(product.id);
      _status = removed
          ? '${product.name} was removed from saved.'
          : '${product.name} was saved for later.';
    });
  }
}

final class _WalletPhoneDemo extends StatefulWidget {
  const _WalletPhoneDemo();

  @override
  State<_WalletPhoneDemo> createState() => _WalletPhoneDemoState();
}

enum _WalletAction { receive, send, topUp, more }

final class _WalletPhoneDemoState extends State<_WalletPhoneDemo> {
  _WalletAction? _action;
  int _balance = 1284600;
  int _selectedBottomIndex = 0;
  int _topUpAmount = 10000;
  String _recipient = '';
  String _sendAmount = '';
  String? _status;
  String? _transferActivity;
  bool _balanceHidden = false;
  bool _roundUps = true;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'wallet',
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
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) => setState(() {
        _selectedBottomIndex = index;
        _action = null;
        _status = null;
      }),
      selectedBottomIndex: _selectedBottomIndex,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.bell),
        onPressed: () => setState(
          () => _status = 'No new account alerts. Everything looks calm.',
        ),
        semanticLabel: 'Lumen notifications',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }

  Widget _buildSelectedPage(CharcoalThemeData theme) =>
      switch (_selectedBottomIndex) {
        0 => _buildWallet(theme),
        1 => _buildActivity(theme),
        2 => _buildPlan(theme),
        _ => _buildWalletProfile(theme),
      };

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildWallet(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-home-page'),
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
          SizedBox(height: space.component25),
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
                padding: EdgeInsets.all(space.component30),
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
                          onPressed: () =>
                              setState(() => _balanceHidden = !_balanceHidden),
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
                      _balanceHidden ? '¥ ••••••' : _formatYen(_balance),
                      style: theme.textStyles.headingS.copyWith(
                        color: theme.colors.textOnPrimaryDefault,
                      ),
                    ),
                    SizedBox(height: space.component10),
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
          SizedBox(height: space.component25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _QuickAction(
                action: _WalletAction.receive,
                icon: CharcoalIcons.arrowDown,
                label: 'Receive',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.receive,
              ),
              _QuickAction(
                action: _WalletAction.send,
                icon: CharcoalIcons.send,
                label: 'Send',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.send,
              ),
              _QuickAction(
                action: _WalletAction.topUp,
                icon: CharcoalIcons.addCircle,
                label: 'Top up',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.topUp,
              ),
              _QuickAction(
                action: _WalletAction.more,
                icon: CharcoalIcons.dotsHorizontal,
                label: 'More',
                onPressed: _selectWalletAction,
                selected: _action == _WalletAction.more,
              ),
            ],
          ),
          if (_action != null) ...<Widget>[
            SizedBox(height: space.component25),
            _buildWalletAction(theme),
          ],
          if (_status != null) ...<Widget>[
            SizedBox(height: space.component25),
            _SimulationStatus(message: _status!),
          ],
          SizedBox(height: space.component30),
          Row(
            children: <Widget>[
              const Expanded(
                child: _PhoneSectionTitle(title: 'Recent activity'),
              ),
              Text(
                'August',
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ],
          ),
          SizedBox(height: space.component20),
          ..._activityRows,
        ],
      ),
    );
  }

  Widget _buildWalletAction(CharcoalThemeData theme) => switch (_action!) {
    _WalletAction.receive => _SimulationActionPanel(
      actionLabel: 'Copy payment link',
      description: 'Share lumen.me/mina so someone can send money securely.',
      onAction: () => setState(() {
        _action = null;
        _status = 'Payment link copied. It is ready to share.';
      }),
      title: 'Receive money',
    ),
    _WalletAction.send => _SimulationActionPanel(
      actionLabel: 'Send money',
      actionEnabled:
          _recipient.trim().isNotEmpty && (_parsedSendAmount ?? 0) > 0,
      description:
          'Transfers in this simulation update your balance instantly.',
      onAction: _sendMoney,
      title: 'Send money',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalTextField(
            key: const ValueKey<String>('agent-wallet-recipient'),
            label: 'Recipient',
            onChanged: (value) => setState(() => _recipient = value),
            placeholder: 'Name or handle',
            showLabel: true,
          ),
          SizedBox(height: theme.dimensions.space.component20),
          CharcoalTextField(
            key: const ValueKey<String>('agent-wallet-amount'),
            keyboardType: TextInputType.number,
            label: 'Amount',
            onChanged: (value) => setState(() => _sendAmount = value),
            placeholder: '8000',
            prefix: const Text('¥'),
            showLabel: true,
          ),
        ],
      ),
    ),
    _WalletAction.topUp => _SimulationActionPanel(
      actionLabel: 'Add ${_formatYen(_topUpAmount)}',
      description: 'Choose an amount to add from your linked bank.',
      onAction: () => setState(() {
        _balance += _topUpAmount;
        _transferActivity = '+ ${_formatYen(_topUpAmount)} · Bank top up';
        _action = null;
        _status = '${_formatYen(_topUpAmount)} was added to your balance.';
      }),
      title: 'Top up balance',
      child: CharcoalSegmentedControl<int>(
        fullWidth: true,
        onChanged: (value) => setState(() => _topUpAmount = value),
        segments: const <CharcoalSegment<int>>[
          CharcoalSegment(value: 5000, child: Text('¥5k')),
          CharcoalSegment(value: 10000, child: Text('¥10k')),
          CharcoalSegment(value: 20000, child: Text('¥20k')),
        ],
        semanticLabel: 'Top up amount',
        value: _topUpAmount,
      ),
    ),
    _WalletAction.more => _SimulationActionPanel(
      actionLabel: 'Done',
      description: 'Small preferences that help money move quietly.',
      onAction: () => setState(() {
        _action = null;
        _status = _roundUps
            ? 'Round ups are enabled for future card purchases.'
            : 'Round ups are paused.';
      }),
      title: 'More options',
      child: CharcoalSwitch(
        label: const Text('Round up card purchases'),
        onChanged: (value) => setState(() => _roundUps = value),
        value: _roundUps,
      ),
    ),
  };

  Widget _buildActivity(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-activity-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'ACTIVITY',
            title: 'Every movement, in one place',
          ),
          SizedBox(height: space.component25),
          ..._activityRows,
        ],
      ),
    );
  }

  List<Widget> get _activityRows => <Widget>[
    if (_transferActivity != null)
      _TransactionRow(
        amount: _transferActivity!.split(' · ').first,
        icon: _transferActivity!.startsWith('+')
            ? CharcoalIcons.addCircle
            : CharcoalIcons.send,
        positive: _transferActivity!.startsWith('+'),
        subtitle: 'Just now · Transfer',
        title: _transferActivity!.split(' · ').last,
      ),
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
  ];

  Widget _buildPlan(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-plan-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'AUGUST PLAN',
            title: 'Spend with a little more intention',
          ),
          SizedBox(height: space.component25),
          const _SimulationStatus(
            message: '¥68,420 of your ¥120,000 flexible budget remains.',
          ),
          SizedBox(height: space.component25),
          for (final item in const <(String, String)>[
            ('Home and groceries', '¥31,200 left'),
            ('Creative supplies', '¥18,900 left'),
            ('Rest and play', '¥18,320 left'),
          ]) ...<Widget>[
            _PhoneSurface(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(item.$1)),
                  Text(item.$2),
                ],
              ),
            ),
            SizedBox(height: space.component20),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-wallet-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(eyebrow: 'PROFILE', title: 'Mina’s Lumen'),
          SizedBox(height: space.component25),
          CharcoalSwitch(
            label: const Text('Round up card purchases'),
            onChanged: (value) => setState(() => _roundUps = value),
            value: _roundUps,
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message: _roundUps
                ? 'Round ups are currently active.'
                : 'Round ups are currently paused.',
          ),
        ],
      ),
    );
  }

  int? get _parsedSendAmount =>
      int.tryParse(_sendAmount.replaceAll(RegExp('[^0-9]'), ''));

  void _selectWalletAction(_WalletAction action) {
    setState(() {
      _action = _action == action ? null : action;
      _status = null;
    });
  }

  void _sendMoney() {
    final amount = _parsedSendAmount;
    if (amount == null || amount <= 0 || _recipient.trim().isEmpty) return;
    setState(() {
      _balance -= amount;
      _transferActivity = '− ${_formatYen(amount)} · To ${_recipient.trim()}';
      _status = '${_formatYen(amount)} was sent to ${_recipient.trim()}.';
      _recipient = '';
      _sendAmount = '';
      _action = null;
    });
  }

  String _formatYen(int amount) {
    final digits = amount.abs().toString();
    final chunks = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = (end - 3).clamp(0, digits.length);
      chunks.add(digits.substring(start, end));
    }
    final formatted = chunks.reversed.join(',');
    return '${amount < 0 ? '− ' : ''}¥ $formatted';
  }
}

final class _HabitPhoneDemo extends StatefulWidget {
  const _HabitPhoneDemo();

  @override
  State<_HabitPhoneDemo> createState() => _HabitPhoneDemoState();
}

final class _HabitPhoneDemoState extends State<_HabitPhoneDemo> {
  bool _read = false;
  bool _reminders = true;
  bool _stretch = true;
  bool _walk = false;
  int _selectedBottomIndex = 0;

  int get _completed =>
      <bool>[_stretch, _walk, _read].where((value) => value).length;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _PhoneDemoShell(
      appKey: 'habits',
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
      content: _buildSelectedPage(theme),
      onBottomItemSelected: (index) =>
          setState(() => _selectedBottomIndex = index),
      selectedBottomIndex: _selectedBottomIndex,
      trailing: CharcoalIconButton(
        icon: const CharcoalIcon(CharcoalIcons.calendar),
        onPressed: () => setState(() => _selectedBottomIndex = 1),
        semanticLabel: 'Open Daylight calendar',
        size: CharcoalIconButtonSize.small,
      ),
    );
  }

  Widget _buildSelectedPage(CharcoalThemeData theme) =>
      switch (_selectedBottomIndex) {
        0 => _buildToday(theme),
        1 => _buildJourney(theme),
        2 => _buildInsights(theme),
        _ => _buildHabitProfile(theme),
      };

  Widget _pagePadding(CharcoalThemeData theme, Widget child) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.dimensions.space.component30,
      theme.dimensions.space.component25,
      theme.dimensions.space.component30,
      theme.dimensions.space.component20,
    ),
    child: child,
  );

  Widget _buildToday(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-today-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'MONDAY, AUGUST 17',
            title: 'A gentle day is still progress.',
          ),
          SizedBox(height: space.component25),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 340;
              return DecoratedBox(
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
                      compact ? space.component25 : space.component30,
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
                              ? space.component20
                              : space.component30,
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
                                          color:
                                              theme.colors.textOnNoticeDefault,
                                          fontWeight: FontWeight.w700,
                                        ),
                              ),
                              SizedBox(height: space.component10),
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
              );
            },
          ),
          SizedBox(height: space.component30),
          const _PhoneSectionTitle(title: 'Your habits'),
          SizedBox(height: space.component30),
          _HabitRow(
            key: const ValueKey<String>('agent-habit-stretch-row'),
            checked: _stretch,
            icon: CharcoalIcons.body,
            label: 'Morning stretch',
            onChanged: (value) => setState(() => _stretch = value),
            streak: '7 days',
          ),
          SizedBox(height: space.component30),
          _HabitRow(
            key: const ValueKey<String>('agent-habit-walk-row'),
            checked: _walk,
            icon: CharcoalIcons.location,
            label: 'Walk outside',
            onChanged: (value) => setState(() => _walk = value),
            streak: '3 days',
          ),
          SizedBox(height: space.component30),
          _HabitRow(
            key: const ValueKey<String>('agent-habit-read-row'),
            checked: _read,
            icon: CharcoalIcons.book,
            label: 'Read for 20 minutes',
            onChanged: (value) => setState(() => _read = value),
            streak: '5 days',
          ),
          SizedBox(height: space.component25),
          if (_completed == 3)
            _SimulationActionPanel(
              actionLabel: 'Plan tomorrow',
              description: 'You completed every gentle commitment for today.',
              onAction: () => setState(() => _selectedBottomIndex = 1),
              title: 'A complete day',
            )
          else
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: theme.colors.containerSecondaryDefault,
              ),
              child: Padding(
                padding: EdgeInsets.all(space.component25),
                child: Row(
                  children: <Widget>[
                    CharcoalIcon(
                      CharcoalIcons.bulbShine,
                      color: theme.colors.iconNoticeDefault,
                    ),
                    SizedBox(width: space.component20),
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
    );
  }

  Widget _buildJourney(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-journey-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'YOUR JOURNEY',
            title: 'A week made from small moments',
          ),
          SizedBox(height: space.component25),
          for (final day in <(String, String)>[
            ('Monday', '$_completed of 3 complete'),
            ('Sunday', '3 of 3 complete'),
            ('Saturday', '2 of 3 complete'),
            ('Friday', '3 of 3 complete'),
          ]) ...<Widget>[
            _PhoneSurface(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      day.$1,
                      style: theme.textStyles.captionMediumBold.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                  ),
                  Text(
                    day.$2,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: space.component20),
          ],
          CharcoalButton(
            key: const ValueKey<String>('agent-habits-return-today'),
            fullWidth: true,
            onPressed: () => setState(() => _selectedBottomIndex = 0),
            child: const Text('Return to today'),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-insights-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'INSIGHTS',
            title: 'Notice what is already working',
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message: 'This week: ${14 + _completed} habits completed',
          ),
          SizedBox(height: space.component20),
          const _SimulationStatus(message: 'Strongest rhythm: Morning stretch'),
          SizedBox(height: space.component20),
          const _SimulationStatus(message: 'Kindest streak: 7 gentle days'),
        ],
      ),
    );
  }

  Widget _buildHabitProfile(CharcoalThemeData theme) {
    final space = theme.dimensions.space;
    return _pagePadding(
      theme,
      Column(
        key: const ValueKey<String>('agent-habits-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _PhonePageHeading(
            eyebrow: 'PROFILE',
            title: 'Make Daylight feel like yours',
          ),
          SizedBox(height: space.component25),
          CharcoalSwitch(
            label: const Text('Gentle evening reminder'),
            onChanged: (value) => setState(() => _reminders = value),
            value: _reminders,
          ),
          SizedBox(height: space.component25),
          _SimulationStatus(
            message: _reminders
                ? 'Evening reminders arrive at 8:30 PM.'
                : 'Evening reminders are paused.',
          ),
        ],
      ),
    );
  }
}

final class _PhoneDemoShell extends StatelessWidget {
  const _PhoneDemoShell({
    required this.appKey,
    required this.appLabel,
    required this.bottomItems,
    required this.brand,
    required this.brandColor,
    required this.brandForeground,
    required this.brandMark,
    required this.content,
    required this.onBottomItemSelected,
    required this.selectedBottomIndex,
    required this.trailing,
  });

  final String appKey;
  final String appLabel;
  final List<_BottomItem> bottomItems;
  final String brand;
  final Color brandColor;
  final Color brandForeground;
  final String brandMark;
  final Widget content;
  final ValueChanged<int> onBottomItemSelected;
  final int selectedBottomIndex;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
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
                    horizontal: space.component30,
                    vertical: space.component25,
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
                      SizedBox(width: space.component20),
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
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey<String>('agent-$appKey-scroll'),
                child: content,
              ),
            ),
            _MobileBottomBar(
              appKey: appKey,
              items: bottomItems,
              onSelected: onBottomItemSelected,
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
  const _MobileBottomBar({
    required this.appKey,
    required this.items,
    required this.onSelected,
    required this.selectedIndex,
  });

  final String appKey;
  final List<_BottomItem> items;
  final ValueChanged<int> onSelected;
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
                  appKey: appKey,
                  item: items[index],
                  onPressed: () => onSelected(index),
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
  const _BottomNavItem({
    required this.appKey,
    required this.item,
    required this.onPressed,
    required this.selected,
  });

  final String appKey;
  final _BottomItem item;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      key: ValueKey<String>('agent-$appKey-nav-${item.label.toLowerCase()}'),
      onPressed: onPressed,
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

final class _PhonePageHeading extends StatelessWidget {
  const _PhonePageHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textSecondaryDefault,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: space.component10),
        Text(
          title,
          style: theme.textStyles.headingXxs.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
      ],
    );
  }
}

final class _PhoneSectionTitle extends StatelessWidget {
  const _PhoneSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Text(
      title,
      style: theme.textStyles.captionMediumBold.copyWith(
        color: theme.colors.textDefault,
      ),
    );
  }
}

final class _SimulationStatus extends StatelessWidget {
  const _SimulationStatus({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.containerSecondaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.component20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.checkCircle,
              color: theme.colors.iconSecondaryDefault,
              size: 18,
            ),
            SizedBox(width: space.component20),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SimulationActionPanel extends StatelessWidget {
  const _SimulationActionPanel({
    required this.actionLabel,
    required this.description,
    required this.onAction,
    required this.title,
    this.actionEnabled = true,
    this.child,
  });

  final bool actionEnabled;
  final String actionLabel;
  final Widget? child;
  final String description;
  final VoidCallback onAction;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          if (child != null) ...<Widget>[
            SizedBox(height: space.component25),
            child!,
          ],
          SizedBox(height: space.component25),
          CharcoalButton(
            fullWidth: true,
            onPressed: actionEnabled ? onAction : null,
            variant: CharcoalButtonVariant.primary,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

final class _SimulationEmptyState extends StatelessWidget {
  const _SimulationEmptyState({required this.description, required this.title});

  final String description;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIcon(
            CharcoalIcons.search,
            color: theme.colors.iconSecondaryDefault,
          ),
          SizedBox(height: space.component20),
          Text(
            title,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
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
    required this.onOpen,
    required this.onSave,
    required this.price,
    required this.saveKey,
    required this.saved,
    required this.tone,
    super.key,
  });

  final String name;
  final VoidCallback onOpen;
  final VoidCallback onSave;
  final String price;
  final Key saveKey;
  final bool saved;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return _PhoneSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalClickable(
            onPressed: onOpen,
            semanticLabel: 'Open $name',
            builder: (context, states) => AnimatedOpacity(
              duration: CharcoalMotion.resolveDuration(
                context,
                CharcoalMotion.fast,
              ),
              opacity: states.contains(WidgetState.pressed) ? 0.76 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(theme.dimensions.radius.m),
                ),
                child: _DemoArtwork(height: 72, tone: tone),
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
                  key: saveKey,
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
  const _QuickAction({
    required this.action,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.selected,
  });

  final _WalletAction action;
  final CharcoalIconData icon;
  final String label;
  final ValueChanged<_WalletAction> onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      children: <Widget>[
        CharcoalIconButton(
          key: ValueKey<String>('agent-wallet-action-${action.name}'),
          icon: CharcoalIcon(icon),
          onPressed: () => onPressed(action),
          selected: selected,
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
    final space = theme.dimensions.space;
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
          SizedBox(width: space.component20),
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
          SizedBox(width: space.component20),
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
    final space = theme.dimensions.space;
    return _PhoneSurface(
      padding: EdgeInsets.symmetric(
        horizontal: space.component30,
        vertical: space.component20,
      ),
      child: Row(
        children: <Widget>[
          CharcoalIcon(
            icon,
            color: theme.colors.iconSecondaryDefault,
            size: 20,
          ),
          SizedBox(width: space.component30),
          Expanded(
            child: CharcoalCheckbox(
              label: Text(label),
              onChanged: onChanged,
              rounded: true,
              semanticLabel: label,
              value: checked,
            ),
          ),
          SizedBox(width: space.component20),
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
