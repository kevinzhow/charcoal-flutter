import 'dart:async';

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../registry.dart';
import 'header.dart';
import 'mobile_navigation.dart';
import 'page_viewport.dart';
import 'sidebar.dart';

/// The responsive showcase frame: sidebar and header on wide screens, a
/// collapsible navigation panel on narrow ones. The page itself comes from the
/// registry; the router owns which page is selected.
final class ShowcaseShell extends StatefulWidget {
  const ShowcaseShell({
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.onPageSelected,
    required this.pageId,
    super.key,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  /// Asks the router to show the page with this id.
  final ValueChanged<String> onPageSelected;

  /// Id of the page to show; owned by the router.
  final String pageId;

  @override
  State<ShowcaseShell> createState() => ShowcaseShellState();
}

final class ShowcaseShellState extends State<ShowcaseShell> {
  static const _desktopLayoutMinWidth = 1024.0;

  final Map<String, double> _scrollOffsets = <String, double>{};
  final Set<ScrollController> _retiredScrollControllers = <ScrollController>{};
  final Set<Timer> _retireTimers = <Timer>{};
  ScrollController _scrollController = ScrollController();

  bool _mobileNavigationOpen = false;
  double _pageTransitionDirection = 1;

  @override
  void dispose() {
    for (final timer in _retireTimers) {
      timer.cancel();
    }
    _retireTimers.clear();
    _scrollController.dispose();
    for (final controller in _retiredScrollControllers) {
      controller.dispose();
    }
    _retiredScrollControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ShowcaseNavigation(
      select: _select,
      child: CharcoalScaffold(
        backgroundColor: theme.colors.backgroundDefault,
        body: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= _desktopLayoutMinWidth
              ? _buildDesktopShell(context, theme)
              : _buildMobileShell(context, theme),
        ),
      ),
    );
  }

  Widget _buildDesktopShell(BuildContext context, CharcoalThemeData theme) =>
      ColoredBox(
        key: const ValueKey<String>('showcase-desktop-shell'),
        color: theme.colors.backgroundSecondary,
        child: Row(
          children: <Widget>[
            ShowcaseSidebar(selected: widget.pageId, onSelected: _select),
            const ShowcaseSidebarDivider(),
            Expanded(
              child: Column(
                children: <Widget>[
                  ShowcaseHeader(
                    darkMode: widget.darkMode,
                    onDarkModeChanged: widget.onDarkModeChanged,
                    title: _page.title,
                  ),
                  Expanded(child: _buildPageSwitcher(context, compact: false)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildMobileShell(BuildContext context, CharcoalThemeData theme) =>
      PopScope<void>(
        canPop: !_mobileNavigationOpen,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _mobileNavigationOpen) {
            setState(() => _mobileNavigationOpen = false);
          }
        },
        child: SafeArea(
          child: ColoredBox(
            key: const ValueKey<String>('showcase-mobile-shell'),
            color: theme.colors.backgroundSecondary,
            child: Column(
              children: <Widget>[
                ShowcaseMobileHeader(
                  darkMode: widget.darkMode,
                  navigationOpen: _mobileNavigationOpen,
                  onDarkModeChanged: widget.onDarkModeChanged,
                  onNavigationToggle: () => setState(
                    () => _mobileNavigationOpen = !_mobileNavigationOpen,
                  ),
                  title: _page.title,
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ExcludeSemantics(
                        excluding: _mobileNavigationOpen,
                        child: IgnorePointer(
                          ignoring: _mobileNavigationOpen,
                          child: _buildPageSwitcher(context, compact: true),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: CharcoalMotion.resolveDuration(
                          context,
                          CharcoalMotion.standard,
                        ),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(-0.04, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: CharcoalMotion.emphasizedCurve,
                                  ),
                                ),
                            child: child,
                          ),
                        ),
                        child: _mobileNavigationOpen
                            ? ShowcaseMobileNavigationPanel(
                                key: const ValueKey<String>(
                                  'showcase-mobile-navigation',
                                ),
                                onSelected: _select,
                                selected: widget.pageId,
                              )
                            : const SizedBox.shrink(
                                key: ValueKey<String>(
                                  'showcase-mobile-navigation-closed',
                                ),
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

  Widget _buildPageSwitcher(BuildContext context, {required bool compact}) =>
      ClipRect(
        key: const ValueKey<String>('showcase-page-viewport-clip'),
        child: AnimatedSwitcher(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.standard,
          ),
          layoutBuilder: (currentChild, previousChildren) => Stack(
            fit: StackFit.expand,
            children: <Widget>[...previousChildren, ?currentChild],
          ),
          transitionBuilder: (child, animation) =>
              ShowcaseDirectionalPageTransition(
                animation: animation,
                direction: _pageTransitionDirection,
                child: child,
              ),
          child: ShowcasePageViewport(
            key: ValueKey<String>('page-${_page.id}'),
            compact: compact,
            controller: _scrollController,
            page: _page.id,
            child: Builder(builder: _page.builder),
          ),
        ),
      );

  ShowcasePage get _page =>
      showcasePageById(widget.pageId) ?? showcasePageById(showcaseHomeId)!;

  void _select(String id) {
    if (_mobileNavigationOpen) setState(() => _mobileNavigationOpen = false);
    if (id != widget.pageId) widget.onPageSelected(id);
  }

  @override
  void didUpdateWidget(ShowcaseShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId == widget.pageId) return;
    // Remember where the outgoing page was scrolled and give the incoming one
    // its own controller so the outgoing page does not jump during the
    // transition. This also covers browser back/forward.
    if (_scrollController.hasClients) {
      _scrollOffsets[oldWidget.pageId] = _scrollController.offset;
    }
    final outgoingController = _scrollController;
    final order = showcasePages.map((page) => page.id).toList();
    _pageTransitionDirection =
        order.indexOf(widget.pageId) >= order.indexOf(oldWidget.pageId)
        ? 1
        : -1;
    _mobileNavigationOpen = false;
    _scrollController = ScrollController(
      initialScrollOffset: _scrollOffsets[widget.pageId] ?? 0,
    );
    _retiredScrollControllers.add(outgoingController);
    late final Timer timer;
    timer = Timer(
      CharcoalMotion.standard + const Duration(milliseconds: 50),
      () {
        _retireTimers.remove(timer);
        if (_retiredScrollControllers.remove(outgoingController)) {
          outgoingController.dispose();
        }
      },
    );
    _retireTimers.add(timer);
  }
}
