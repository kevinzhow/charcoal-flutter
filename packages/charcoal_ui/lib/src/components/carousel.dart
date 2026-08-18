import 'dart:math' as math;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'icon_button.dart';
import 'interaction_state.dart';

abstract final class _CarouselSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const navigationFadeDuration = Duration(milliseconds: 400);
  static const scrollDuration = Duration(milliseconds: 300);
  static const mediumViewportFraction = 0.75;
  static const navigationZoneWidth = 72.0;
  static const focusRingWidth = 4.0;
}

/// The layout behavior of a [CharcoalCarousel].
enum CharcoalCarouselSize {
  /// Shows one full-width page and page indicators by default.
  small,

  /// Shows a partial neighboring page and overlay navigation by default.
  medium,
}

/// Builds an accessible label for a zero-based slide [index].
typedef CharcoalCarouselSemanticLabelBuilder = String Function(int index, int itemCount);

/// A horizontally paged Charcoal V2 carousel.
///
/// The carousel must receive a bounded height from its parent. Small carousels
/// default to full-page slides and indicators; medium carousels default to a
/// partial next-slide preview and overlay navigation buttons.
///
/// Touch and trackpad input swipe the viewport. Arrow, Home, and End keys act
/// while the carousel has keyboard focus, and navigation direction follows the
/// ambient [Directionality]. The component never auto-rotates content.
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
       assert(gap == null || gap >= 0),
       assert(viewportFraction == null || (viewportFraction > 0 && viewportFraction <= 1));

  /// The ordered slides. At least one slide is required.
  final List<Widget> children;

  /// Whether offscreen pages may respond to accessibility show-on-screen requests.
  final bool allowImplicitScrolling;

  /// Whether the carousel requests focus when it is first mounted.
  final bool autofocus;

  /// An optional externally owned page controller.
  ///
  /// When supplied, its initial page and viewport fraction take precedence over
  /// [initialPage] and [viewportFraction]. The carousel never disposes it.
  final PageController? controller;

  /// An optional externally owned focus node.
  final FocusNode? focusNode;

  /// The non-negative logical-pixel gap between slides.
  final double? gap;

  /// The zero-based initial page used by the internal controller.
  final int initialPage;

  /// Called after touch, keyboard, indicator, controller, or button navigation
  /// accepts a different zero-based page.
  final ValueChanged<int>? onPageChanged;

  /// Optional scroll physics for the page viewport.
  final ScrollPhysics? physics;

  /// Accessible name for the previous-page action.
  final String previousSemanticLabel;

  /// Accessible name for the carousel region.
  final String semanticLabel;

  /// Optional localized label shared by each slide and its indicator.
  final CharcoalCarouselSemanticLabelBuilder? semanticLabelBuilder;

  /// Whether to show page indicators, overriding the [size] default.
  final bool? showIndicators;

  /// Whether to show overlay navigation buttons, overriding the [size] default.
  final bool? showNavigationButtons;

  /// The default viewport and control treatment.
  final CharcoalCarouselSize size;

  /// Accessible name for the next-page action.
  final String nextSemanticLabel;

  /// The page fraction used only when the carousel owns its controller.
  final double? viewportFraction;

  @override
  State<CharcoalCarousel> createState() => _CharcoalCarouselState();
}

final class _CharcoalCarouselState extends State<CharcoalCarousel> {
  PageController? _internalController;
  double? _internalViewportFraction;
  late FocusNode _focusNode;
  late int _currentPage;
  bool _focusWithin = false;
  bool _focusVisible = false;
  bool _hovered = false;

  bool get _ownsFocusNode => widget.focusNode == null;
  int get _lastPage => widget.children.isEmpty ? 0 : widget.children.length - 1;

  @override
  void initState() {
    super.initState();
    assert(widget.children.isNotEmpty);
    assert(widget.initialPage < widget.children.length);
    _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'CharcoalCarousel');
    _currentPage = math.min(
      widget.controller?.initialPage ?? widget.initialPage,
      _lastPage,
    );
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
    await _controller.animateToPage(
      page,
      duration: CharcoalMotion.resolveDuration(
        context,
        _CarouselSpec.scrollDuration,
      ),
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

  void _handleFocusWithinChanged(bool focused) {
    if (_focusWithin == focused) return;
    setState(() => _focusWithin = focused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    if (widget.children.isEmpty) {
      return Semantics(
        container: true,
        label: widget.semanticLabel,
        child: const SizedBox.shrink(),
      );
    }
    final viewportFraction =
        widget.viewportFraction ??
        (widget.size == CharcoalCarouselSize.small ? 1 : _CarouselSpec.mediumViewportFraction);
    _ensureInternalController(viewportFraction);
    final gap = widget.gap ?? 0;
    final showIndicators = widget.showIndicators ?? widget.size == CharcoalCarouselSize.small;
    final showNavigation =
        widget.showNavigationButtons ?? widget.size == CharcoalCarouselSize.medium;
    final canPrevious = _currentPage > 0;
    final canNext = _currentPage < widget.children.length - 1;

    final viewport = AnimatedContainer(
      curve: CharcoalMotion.standardCurve,
      duration: CharcoalMotion.resolveDuration(
        context,
        _CarouselSpec.animationDuration,
      ),
      decoration: BoxDecoration(
        boxShadow: _focusVisible
            ? <BoxShadow>[
                BoxShadow(
                  color: theme.colors.borderFocusLegacy,
                  spreadRadius: _CarouselSpec.focusRingWidth,
                ),
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
              start: 0,
              top: 0,
              bottom: 0,
              width: _CarouselSpec.navigationZoneWidth,
              child: _CarouselNavigationButton(
                backwards: true,
                enabled: canPrevious,
                onPressed: () => _animateTo(_currentPage - 1),
                semanticLabel: widget.previousSemanticLabel,
                visible: _hovered || _focusWithin,
              ),
            ),
            PositionedDirectional(
              end: 0,
              top: 0,
              bottom: 0,
              width: _CarouselSpec.navigationZoneWidth,
              child: _CarouselNavigationButton(
                backwards: false,
                enabled: canNext,
                onPressed: () => _animateTo(_currentPage + 1),
                semanticLabel: widget.nextSemanticLabel,
                visible: _hovered || _focusWithin,
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
        onFocusChange: _handleFocusWithinChanged,
        onKeyEvent: _handleKeyEvent,
        child: FocusableActionDetector(
          autofocus: widget.autofocus,
          focusNode: _focusNode,
          onShowFocusHighlight: (visible) => setState(() => _focusVisible = visible),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: viewport),
                if (showIndicators)
                  SizedBox(
                    height: theme.dimensions.space.targetM,
                    child: _CarouselIndicators(
                      currentPage: _currentPage,
                      itemCount: widget.children.length,
                      onSelected: _animateTo,
                      semanticLabelBuilder: widget.semanticLabelBuilder,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _CarouselIndicators extends StatelessWidget {
  const _CarouselIndicators({
    required this.currentPage,
    required this.itemCount,
    required this.onSelected,
    required this.semanticLabelBuilder,
  });

  final int currentPage;
  final int itemCount;
  final ValueChanged<int> onSelected;
  final CharcoalCarouselSemanticLabelBuilder? semanticLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final dotSize = theme.dimensions.space.component20;
    final gap = theme.dimensions.space.component20;
    final edgeInset = theme.dimensions.space.component20;
    final contentWidth = itemCount * dotSize + math.max(0, itemCount - 1) * gap;

    Row indicators() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var index = 0; index < itemCount; index++) ...<Widget>[
          if (index > 0) SizedBox(width: gap),
          _CarouselIndicator(
            active: index == currentPage,
            onPressed: () => onSelected(index),
            semanticLabel:
                semanticLabelBuilder?.call(index, itemCount) ?? '${index + 1}/$itemCount',
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final needsScrolling =
            constraints.maxWidth.isFinite && contentWidth + edgeInset * 2 > constraints.maxWidth;
        if (!needsScrolling) return Center(child: indicators());
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: edgeInset),
          scrollDirection: Axis.horizontal,
          child: indicators(),
        );
      },
    );
  }
}

final class _CarouselNavigationButton extends StatelessWidget {
  const _CarouselNavigationButton({
    required this.backwards,
    required this.enabled,
    required this.onPressed,
    required this.semanticLabel,
    required this.visible,
  });

  final bool backwards;
  final bool enabled;
  final VoidCallback onPressed;
  final String semanticLabel;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final pointsLeft = backwards == (direction == TextDirection.ltr);
    return ExcludeSemantics(
      excluding: !enabled || !visible,
      child: IgnorePointer(
        ignoring: !enabled || !visible,
        child: AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: CharcoalMotion.resolveDuration(
            context,
            _CarouselSpec.navigationFadeDuration,
          ),
          opacity: enabled && visible ? 1 : 0,
          child: Center(
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
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      selected: active,
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final dotSize = theme.dimensions.space.component20;
        final outlineWidth = theme.dimensions.borderWidth.l;
        final outlineOffset = theme.dimensions.borderWidth.l;
        final outlineExtent = outlineWidth + outlineOffset;
        return SizedBox.square(
          dimension: dotSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              AnimatedContainer(
                curve: CharcoalMotion.standardCurve,
                duration: CharcoalMotion.resolveDuration(
                  context,
                  _CarouselSpec.animationDuration,
                ),
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.oval,
                  ),
                  color: active
                      ? theme.colors.textDefault
                      : resolveCharcoalStateColor(
                          states,
                          normal: theme.colors.textTertiaryDefault,
                          hovered: theme.colors.textSecondaryDefault,
                          pressed: theme.colors.textDefault,
                          disabled: theme.colors.textTertiaryDefault,
                        ),
                ),
              ),
              Positioned(
                left: -outlineExtent,
                top: -outlineExtent,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration: CharcoalMotion.resolveDuration(
                      context,
                      _CarouselSpec.animationDuration,
                    ),
                    opacity: focused ? 1 : 0,
                    child: Container(
                      width: dotSize + outlineExtent * 2,
                      height: dotSize + outlineExtent * 2,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colors.borderFocus1,
                          width: outlineWidth,
                        ),
                        borderRadius: BorderRadius.circular(
                          theme.dimensions.radius.oval,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
