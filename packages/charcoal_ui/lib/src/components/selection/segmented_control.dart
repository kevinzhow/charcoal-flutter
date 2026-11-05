import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';

/// One option of a [CharcoalSegmentedControl].
final class CharcoalSegment<T> {
  /// Creates a segment for [value] showing [child].
  const CharcoalSegment({required this.value, required this.child, this.enabled = true});

  /// The value reported when the segment is chosen.
  final T value;

  /// The label, usually a `Text`; it is styled by the control.
  final Widget child;

  /// Whether this segment can be chosen.
  final bool enabled;
}

/// A controlled, single-selection segmented control: a pill track with the chosen segment filled.
///
/// Selection is atomic: the previous and next segment change in the same frame as [value]. The
/// layout is intrinsic by default, [uniformSegmentWidth] gives every segment the same minimum
/// width and [fullWidth] spreads the segments across the parent. A null [onChanged] disables the
/// whole control.
///
/// When the segments are wider than the space the control is given it scrolls horizontally: the
/// chosen segment is scrolled into view whenever [value] changes (and on first build), and the
/// track fades out at each edge that has segments beyond it, so off-screen segments are visible
/// as such. A control that fits never scrolls and shows no fade.
final class CharcoalSegmentedControl<T> extends StatefulWidget {
  /// Creates a segmented control; at least two [segments] are required.
  const CharcoalSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.fullWidth = false,
    this.semanticLabel,
    this.uniformSegmentWidth = false,
    super.key,
  }) : assert(segments.length > 1);

  /// The options, in display order.
  final List<CharcoalSegment<T>> segments;

  /// The currently selected value.
  final T value;

  /// Reports the chosen value; null disables the control.
  final ValueChanged<T>? onChanged;

  /// Whether the control fills the width its parent offers.
  final bool fullWidth;

  /// Semantics label of the group.
  final String? semanticLabel;

  /// Whether every segment gets the same width.
  final bool uniformSegmentWidth;

  @override
  State<CharcoalSegmentedControl<T>> createState() => _CharcoalSegmentedControlState<T>();
}

final class _CharcoalSegmentedControlState<T> extends State<CharcoalSegmentedControl<T>> {
  final List<GlobalKey> _keys = <GlobalKey>[];
  final ScrollController _controller = ScrollController();
  bool _fadeStart = false;
  bool _fadeEnd = false;

  @override
  void initState() {
    super.initState();
    _revealSelected(animate: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CharcoalSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _revealSelected(animate: true);
  }

  void _revealSelected({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final index = widget.segments.indexWhere((s) => s.value == widget.value);
      if (index < 0 || index >= _keys.length) return;
      final target = _keys[index].currentContext?.findRenderObject();
      if (target == null || !_controller.hasClients) return;
      final theme = CharcoalTheme.of(context);
      // Only this control's own list scrolls; an enclosing page stays where it is.
      _controller.position.ensureVisible(
        target,
        alignment: 0.5,
        duration: animate ? theme.duration(context, theme.motion.standard) : Duration.zero,
        curve: theme.motion.curve,
      );
    });
  }

  bool _onMetrics(ScrollMetrics metrics) {
    final start = metrics.extentBefore > 0;
    final end = metrics.extentAfter > 0;
    if (start != _fadeStart || end != _fadeEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _fadeStart = start;
            _fadeEnd = end;
          });
        }
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final segments = widget.segments;
    while (_keys.length < segments.length) {
      _keys.add(GlobalKey());
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radius.xl),
          color: theme.colors.fillSecondary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.radius.xl),
          child: LayoutBuilder(builder: (context, constraints) => _track(context, constraints)),
        ),
      ),
    );
  }

  Widget _track(BuildContext context, BoxConstraints constraints) {
    final theme = CharcoalTheme.of(context);
    final segments = widget.segments;
    final minWidth = theme.metrics.segmented.uniformSegmentMinWidth;
    final bounded = constraints.hasBoundedWidth;
    // A full-width control gives each segment at least an equal share; wider ones grow and the
    // control scrolls instead of squeezing labels.
    final share = bounded && widget.fullWidth ? constraints.maxWidth / segments.length : 0.0;
    final children = <Widget>[
      for (var i = 0; i < segments.length; i++)
        if (widget.fullWidth)
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: share > minWidth ? share : minWidth),
            child: KeyedSubtree(key: _keys[i], child: _buildSegment(context, segments[i])),
          )
        else if (widget.uniformSegmentWidth)
          SizedBox(
            width: minWidth,
            child: KeyedSubtree(key: _keys[i], child: _buildSegment(context, segments[i])),
          )
        else
          KeyedSubtree(key: _keys[i], child: _buildSegment(context, segments[i])),
    ];
    final row = Row(mainAxisSize: MainAxisSize.min, children: children);
    if (!bounded) return row;
    final fade = theme.space.xl;
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) => _onMetrics(n.metrics),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onMetrics(n.metrics),
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) {
            final f = rect.width <= 0 ? 0.0 : fade / rect.width;
            return LinearGradient(
              colors: <Color>[
                _fadeStart ? CharcoalColorRoles.transparent : theme.colors.background,
                theme.colors.background,
                theme.colors.background,
                _fadeEnd ? CharcoalColorRoles.transparent : theme.colors.background,
              ],
              stops: <double>[0, f, 1 - f, 1],
            ).createShader(rect);
          },
          // A horizontal list fills its cross axis, so the track's height is stated: every
          // segment is `sizes.controlSm` high.
          child: SizedBox(
            height: theme.sizes.controlSm,
            child: ListView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: <Widget>[row],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(BuildContext context, CharcoalSegment<T> segment) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final selected = segment.value == widget.value;
    final enabled = segment.enabled && widget.onChanged != null;
    return CharcoalClickable(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      onPressed: enabled ? () => widget.onChanged!(segment.value) : null,
      semanticButton: false,
      builder: (context, states) {
        return Opacity(
          opacity: enabled ? 1 : theme.metrics.clickable.disabledOpacity,
          child: Container(
            height: theme.sizes.controlSm,
            padding: EdgeInsets.symmetric(horizontal: theme.space.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.xl),
              color: selected ? colors.primary : null,
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.style(
                CharcoalTextRole.size14,
                color: selected ? colors.textOnPrimary : colors.textSecondary,
              ),
              child: segment.child,
            ),
          ),
        );
      },
    );
  }
}
