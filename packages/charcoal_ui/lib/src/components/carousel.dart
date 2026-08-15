import 'dart:math' as math;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/component_tokens.dart';
import 'clickable.dart';
import 'icon_button.dart';

enum CharcoalCarouselSize { small, medium }

typedef CharcoalCarouselSemanticLabelBuilder = String Function(int index, int itemCount);

/// A horizontally paged Charcoal V2 carousel.
///
/// The carousel must receive a bounded height from its parent. Small carousels
/// default to full-page slides and indicators; medium carousels default to a
/// partial next-slide preview and overlay navigation buttons.
final class CharcoalCarousel extends StatefulWidget {
  const CharcoalCarousel({
    required this.children,
    this.allowImplicitScrolling = false,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.gap,
    this.initialPage = 0,
    this.onPageChanged,
    this.physics,
    this.previousSemanticLabel = 'Previous',
    this.semanticLabel = 'Carousel',
    this.semanticLabelBuilder,
    this.showIndicators,
    this.showNavigationButtons,
    this.size = CharcoalCarouselSize.medium,
    this.nextSemanticLabel = 'Next',
    this.viewportFraction,
    super.key,
  }) : assert(initialPage >= 0),
       assert(viewportFraction == null || (viewportFraction > 0 && viewportFraction <= 1));

  final List<Widget> children;
  final bool allowImplicitScrolling;
  final bool autofocus;
  final PageController? controller;
  final FocusNode? focusNode;
  final double? gap;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;
  final ScrollPhysics? physics;
  final String previousSemanticLabel;
  final String semanticLabel;
  final CharcoalCarouselSemanticLabelBuilder? semanticLabelBuilder;
  final bool? showIndicators;
  final bool? showNavigationButtons;
  final CharcoalCarouselSize size;
  final String nextSemanticLabel;
  final double? viewportFraction;

  @override
  State<CharcoalCarousel> createState() => _CharcoalCarouselState();
}

final class _CharcoalCarouselState extends State<CharcoalCarousel> {
  PageController? _internalController;
  double? _internalViewportFraction;
  late FocusNode _focusNode;
  late int _currentPage;
  bool _focusVisible = false;

  bool get _ownsFocusNode => widget.focusNode == null;
  int get _lastPage => widget.children.isEmpty ? 0 : widget.children.length - 1;

  @override
  void initState() {
    super.initState();
    assert(widget.children.isNotEmpty);
    assert(widget.initialPage < widget.children.length);
    _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'CharcoalCarousel');
    _currentPage = math.min(widget.initialPage, _lastPage);
  }

  @override
  void didUpdateWidget(CharcoalCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.children.isNotEmpty);
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'CharcoalCarousel');
    }
    if (widget.children.length <= _currentPage) {
      _currentPage = _lastPage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.children.isNotEmpty && _controller.hasClients) {
          _controller.jumpToPage(_currentPage);
        }
      });
    }
    if (oldWidget.controller != widget.controller && widget.controller != null) {
      final oldInternal = _internalController;
      _internalController = null;
      _internalViewportFraction = null;
      if (oldInternal != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => oldInternal.dispose());
      }
      _currentPage = math.min(widget.controller!.initialPage, _lastPage);
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  PageController get _controller => widget.controller ?? _internalController!;

  void _ensureInternalController(double viewportFraction) {
    if (widget.controller != null) {
      return;
    }
    if (_internalController != null && _internalViewportFraction == viewportFraction) {
      return;
    }
    final oldController = _internalController;
    final page = oldController?.hasClients == true
        ? oldController!.page?.round() ?? _currentPage
        : _currentPage;
    _internalController = PageController(
      initialPage: math.min(page, _lastPage),
      viewportFraction: viewportFraction,
    );
    _internalViewportFraction = viewportFraction;
    if (oldController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => oldController.dispose());
    }
  }

  Future<void> _animateTo(int page) async {
    if (widget.children.isEmpty ||
        !_controller.hasClients ||
        page < 0 ||
        page >= widget.children.length) {
      return;
    }
    final tokens = CharcoalTheme.of(context).components.carousel;
    await _controller.animateToPage(
      page,
      duration: tokens.scrollDuration,
      curve: CharcoalMotion.emphasizedCurve,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final textDirection = Directionality.of(context);
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _animateTo(_currentPage + (textDirection == TextDirection.ltr ? 1 : -1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _animateTo(_currentPage + (textDirection == TextDirection.ltr ? -1 : 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      _animateTo(0);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      _animateTo(widget.children.length - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handlePageChanged(int page) {
    setState(() => _currentPage = page);
    widget.onPageChanged?.call(page);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.carousel;
    if (widget.children.isEmpty) {
      return Semantics(
        container: true,
        label: widget.semanticLabel,
        child: const SizedBox.shrink(),
      );
    }
    final viewportFraction =
        widget.viewportFraction ??
        (widget.size == CharcoalCarouselSize.small ? 1 : tokens.mediumViewportFraction);
    _ensureInternalController(viewportFraction);
    final gap = widget.gap ?? tokens.defaultGap;
    final showIndicators = widget.showIndicators ?? widget.size == CharcoalCarouselSize.small;
    final showNavigation =
        widget.showNavigationButtons ?? widget.size == CharcoalCarouselSize.medium;
    final canPrevious = _currentPage > 0;
    final canNext = _currentPage < widget.children.length - 1;

    final viewport = AnimatedContainer(
      curve: CharcoalMotion.standardCurve,
      duration: tokens.animationDuration,
      decoration: BoxDecoration(
        boxShadow: _focusVisible
            ? <BoxShadow>[
                BoxShadow(color: tokens.focusRingColor, spreadRadius: tokens.focusRingWidth),
              ]
            : const <BoxShadow>[],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            allowImplicitScrolling: widget.allowImplicitScrolling,
            controller: _controller,
            itemCount: widget.children.length,
            onPageChanged: _handlePageChanged,
            padEnds: widget.size == CharcoalCarouselSize.medium,
            physics: widget.physics,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: gap / 2),
              child: Semantics(
                container: true,
                label: widget.semanticLabelBuilder?.call(index, widget.children.length),
                child: widget.children[index],
              ),
            ),
          ),
          if (showNavigation) ...<Widget>[
            PositionedDirectional(
              start: tokens.navigationInset,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CarouselNavigationButton(
                  backwards: true,
                  enabled: canPrevious,
                  onPressed: () => _animateTo(_currentPage - 1),
                  semanticLabel: widget.previousSemanticLabel,
                ),
              ),
            ),
            PositionedDirectional(
              end: tokens.navigationInset,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CarouselNavigationButton(
                  backwards: false,
                  enabled: canNext,
                  onPressed: () => _animateTo(_currentPage + 1),
                  semanticLabel: widget.nextSemanticLabel,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: _handleKeyEvent,
        child: FocusableActionDetector(
          autofocus: widget.autofocus,
          focusNode: _focusNode,
          onShowFocusHighlight: (visible) => setState(() => _focusVisible = visible),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: viewport),
              if (showIndicators)
                SizedBox(
                  height: tokens.indicatorHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (var index = 0; index < widget.children.length; index++) ...<Widget>[
                        if (index > 0) SizedBox(width: tokens.indicatorGap),
                        _CarouselIndicator(
                          active: index == _currentPage,
                          onPressed: () => _animateTo(index),
                          semanticLabel:
                              widget.semanticLabelBuilder?.call(index, widget.children.length) ??
                              '${index + 1}/${widget.children.length}',
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _CarouselNavigationButton extends StatelessWidget {
  const _CarouselNavigationButton({
    required this.backwards,
    required this.enabled,
    required this.onPressed,
    required this.semanticLabel,
  });

  final bool backwards;
  final bool enabled;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final pointsLeft = backwards == (direction == TextDirection.ltr);
    return ExcludeSemantics(
      excluding: !enabled,
      child: IgnorePointer(
        ignoring: !enabled,
        child: AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: CharcoalTheme.of(context).components.carousel.animationDuration,
          opacity: enabled ? 1 : 0,
          child: CharcoalIconButton(
            icon: CharcoalIcon(
              pointsLeft ? CharcoalIcons16.chevronLeft : CharcoalIcons16.chevronRight,
            ),
            onPressed: enabled ? onPressed : null,
            semanticLabel: semanticLabel,
            size: CharcoalIconButtonSize.small,
            variant: CharcoalIconButtonVariant.overlay,
          ),
        ),
      ),
    );
  }
}

final class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({
    required this.active,
    required this.onPressed,
    required this.semanticLabel,
  });

  final bool active;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = CharcoalTheme.of(context).components.carousel;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      selected: active,
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        return AnimatedContainer(
          curve: CharcoalMotion.standardCurve,
          duration: tokens.animationDuration,
          width: tokens.indicatorSize,
          height: tokens.indicatorSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.indicatorRadius),
            boxShadow: focused
                ? <BoxShadow>[
                    BoxShadow(color: tokens.focusRingColor, spreadRadius: tokens.focusRingWidth),
                  ]
                : const <BoxShadow>[],
            color: active ? tokens.indicatorActiveColor : tokens.indicatorColor.resolve(states),
          ),
        );
      },
    );
  }
}
