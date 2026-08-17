import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A real [Page] used by the embedded Agent Ready applications.
///
/// The route reads the latest page builder from its settings so business-state
/// updates can rebuild an existing route without replacing its route object.
final class AgentExamplePage extends Page<void> {
  const AgentExamplePage({
    required this.builder,
    required super.key,
    required super.name,
    this.axis = CharcoalPageTransitionAxis.horizontal,
    this.fullscreenDialog = false,
    this.listenable,
    this.onDidPop,
  });

  final CharcoalPageTransitionAxis axis;
  final WidgetBuilder builder;
  final bool fullscreenDialog;
  final Listenable? listenable;
  final VoidCallback? onDidPop;

  @override
  Route<void> createRoute(BuildContext context) {
    late final CharcoalPageRoute<void> route;
    route = CharcoalPageRoute<void>(
      axis: axis,
      builder: (context) {
        final page = route.settings as AgentExamplePage;
        final listenable = page.listenable;
        if (listenable == null) return page.builder(context);
        return ListenableBuilder(
          listenable: listenable,
          builder: (context, _) {
            final currentPage = route.settings as AgentExamplePage;
            return currentPage.builder(context);
          },
        );
      },
      fullscreenDialog: fullscreenDialog,
      settings: this,
    );
    return route;
  }
}

/// Owns the nested route stack and durable page-storage bucket for one demo.
final class AgentExampleNavigator extends StatefulWidget {
  const AgentExampleNavigator({
    required this.appKey,
    required this.pages,
    super.key,
  }) : assert(pages.length > 0);

  final String appKey;
  final List<AgentExamplePage> pages;

  @override
  State<AgentExampleNavigator> createState() => _AgentExampleNavigatorState();
}

/// A route-local scroll view whose offset survives destination replacement.
final class AgentExamplePageScrollView extends StatefulWidget {
  const AgentExamplePageScrollView({
    required this.child,
    required this.storageKey,
    super.key,
  });

  final Widget child;
  final String storageKey;

  @override
  State<AgentExamplePageScrollView> createState() =>
      _AgentExamplePageScrollViewState();
}

final class _AgentExamplePageScrollViewState
    extends State<AgentExamplePageScrollView> {
  ScrollController? _controller;
  _AgentExampleNavigationStorage? _storage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _storage ??= _AgentExampleNavigationStorage.of(context);
    _controller ??= ScrollController(
      initialScrollOffset: _storage!.offsetFor(widget.storageKey),
      keepScrollOffset: false,
    )..addListener(_saveOffset);
  }

  @override
  void didUpdateWidget(AgentExamplePageScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.storageKey == widget.storageKey) return;
    _saveOffsetFor(oldWidget.storageKey);
    _controller
      ?..removeListener(_saveOffset)
      ..dispose();
    _controller = ScrollController(
      initialScrollOffset: _storage!.offsetFor(widget.storageKey),
      keepScrollOffset: false,
    )..addListener(_saveOffset);
  }

  @override
  void dispose() {
    _saveOffset();
    _controller
      ?..removeListener(_saveOffset)
      ..dispose();
    super.dispose();
  }

  void _saveOffset() {
    _saveOffsetFor(widget.storageKey);
  }

  void _saveOffsetFor(String storageKey) {
    final controller = _controller;
    if (controller != null && controller.hasClients) {
      _storage?.saveOffset(storageKey, controller.position.pixels);
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: _controller,
    key: PageStorageKey<String>(widget.storageKey),
    child: widget.child,
  );
}

final class _AgentExampleNavigatorState extends State<AgentExampleNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  final Map<String, double> _scrollOffsets = <String, double>{};
  bool _navigatorCanHandlePop = false;

  @override
  Widget build(BuildContext context) => _AgentExampleNavigationStorage(
    offsets: _scrollOffsets,
    child: PageStorage(
      bucket: _pageStorageBucket,
      child: PopScope<void>(
        canPop: widget.pages.length == 1 && !_navigatorCanHandlePop,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _navigatorKey.currentState?.maybePop();
        },
        child: NotificationListener<NavigationNotification>(
          onNotification: (notification) {
            if (_navigatorCanHandlePop != notification.canHandlePop) {
              setState(() {
                _navigatorCanHandlePop = notification.canHandlePop;
              });
            }
            return false;
          },
          child: KeyedSubtree(
            key: ValueKey<String>('agent-${widget.appKey}-navigator'),
            child: Navigator(
              key: _navigatorKey,
              onDidRemovePage: (page) {
                if (page case AgentExamplePage(:final onDidPop)) {
                  onDidPop?.call();
                }
              },
              pages: widget.pages,
            ),
          ),
        ),
      ),
    ),
  );
}

final class _AgentExampleNavigationStorage extends InheritedWidget {
  const _AgentExampleNavigationStorage({
    required super.child,
    required this.offsets,
  });

  final Map<String, double> offsets;

  double offsetFor(String key) => offsets[key] ?? 0;

  void saveOffset(String key, double offset) {
    offsets[key] = offset;
  }

  static _AgentExampleNavigationStorage of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_AgentExampleNavigationStorage>()!;

  @override
  bool updateShouldNotify(_AgentExampleNavigationStorage oldWidget) => false;
}
