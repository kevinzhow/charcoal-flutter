import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../actions/control_support.dart';
import '../actions/icon_button.dart';

/// The visual target size of a [CharcoalPagination].
enum CharcoalPaginationSize {
  /// A compact target for dense surfaces with limited horizontal space.
  small,

  /// The default target for page-level pagination.
  medium,
}

String _defaultPageLabel(int page) => 'Page $page';

/// A one-indexed, controlled pagination component for a finite collection.
///
/// [currentPage] remains owned by the caller. Activating a page or navigation button only requests
/// a new value through [onPageChanged]; the caller updates the visible results, loading and error
/// feedback, scroll or focus position, and any URL state before rebuilding with the accepted page.
///
/// The default form shows a window of page buttons. [CharcoalPagination.compact] shows only
/// previous / next with the position ("3 / 12") between them, for admin lists.
final class CharcoalPagination extends StatelessWidget {
  /// Creates a page-window pagination.
  const CharcoalPagination({
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    this.maxVisiblePages = 7,
    this.nextLabel = 'Next page',
    this.pageLabel = _defaultPageLabel,
    this.previousLabel = 'Previous page',
    this.semanticLabel = 'Pagination',
    this.size = CharcoalPaginationSize.medium,
    super.key,
  }) : compact = false,
       assert(pageCount > 0),
       assert(currentPage > 0 && currentPage <= pageCount),
       assert(maxVisiblePages >= 3 && maxVisiblePages % 2 == 1);

  /// Creates previous / next paging with the current position between the buttons.
  ///
  /// The buttons stay in place and are disabled at the ends instead of disappearing.
  const CharcoalPagination.compact({
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    this.nextLabel = 'Next page',
    this.previousLabel = 'Previous page',
    this.semanticLabel = 'Pagination',
    this.size = CharcoalPaginationSize.medium,
    super.key,
  }) : compact = true,
       maxVisiblePages = 3,
       pageLabel = _defaultPageLabel,
       assert(pageCount > 0),
       assert(currentPage > 0 && currentPage <= pageCount);

  /// The selected one-indexed page.
  final int currentPage;

  /// The total number of pages in the finite collection.
  final int pageCount;

  /// Called with the requested one-indexed page.
  ///
  /// When null, all page actions are disabled.
  final ValueChanged<int>? onPageChanged;

  /// Maximum number of page-window slots, including ellipses.
  ///
  /// The effective odd value decreases to five or three when the available width cannot fit this
  /// upper bound at the selected [size].
  final int maxVisiblePages;

  /// Accessible name for the next-page action.
  final String nextLabel;

  /// Accessible name of a page button, given its number.
  final String Function(int page) pageLabel;

  /// Accessible name for the previous-page action.
  final String previousLabel;

  /// Accessible name for the pagination group.
  final String semanticLabel;

  /// The visual target size used by every item.
  final CharcoalPaginationSize size;

  /// Whether this is the previous / next form.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final iconSize = switch (size) {
      CharcoalPaginationSize.small => CharcoalIconButtonSize.small,
      CharcoalPaginationSize.medium => CharcoalIconButtonSize.medium,
    };
    final itemExtent = _extent(theme, size);
    final previous = onPageChanged == null ? null : () => onPageChanged!(currentPage - 1);
    final next = onPageChanged == null ? null : () => onPageChanged!(currentPage + 1);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: compact
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _NavigationButton(
                  backwards: true,
                  onPressed: currentPage > 1 ? previous : null,
                  semanticLabel: previousLabel,
                  size: iconSize,
                  visible: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.space.sm),
                  child: Text(
                    '$currentPage / $pageCount',
                    style: theme.style(CharcoalTextRole.body, color: theme.colors.textSecondary),
                  ),
                ),
                _NavigationButton(
                  backwards: false,
                  onPressed: currentPage < pageCount ? next : null,
                  semanticLabel: nextLabel,
                  size: iconSize,
                  visible: true,
                ),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final effectiveMaxVisiblePages = _effectiveMaxVisiblePages(
                  availableWidth: constraints.maxWidth,
                  itemExtent: itemExtent,
                  requested: maxVisiblePages,
                );
                final items = _visibleItems(currentPage, pageCount, effectiveMaxVisiblePages);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _NavigationButton(
                      backwards: true,
                      onPressed: previous,
                      semanticLabel: previousLabel,
                      size: iconSize,
                      visible: currentPage > 1,
                    ),
                    for (final item in items)
                      if (item == null)
                        _Ellipsis(size: size)
                      else
                        _Page(
                          current: item == currentPage,
                          label: pageLabel(item),
                          onPressed: onPageChanged == null ? null : () => onPageChanged!(item),
                          page: item,
                          size: size,
                        ),
                    _NavigationButton(
                      backwards: false,
                      onPressed: next,
                      semanticLabel: nextLabel,
                      size: iconSize,
                      visible: currentPage < pageCount,
                    ),
                  ],
                );
              },
            ),
    );
  }
}

double _extent(CharcoalTheme theme, CharcoalPaginationSize size) => switch (size) {
  CharcoalPaginationSize.small => theme.sizes.controlSm,
  CharcoalPaginationSize.medium => theme.sizes.controlMd,
};

final class _Page extends StatelessWidget {
  const _Page({
    required this.current,
    required this.label,
    required this.onPressed,
    required this.page,
    required this.size,
  });

  final bool current;
  final String label;
  final VoidCallback? onPressed;
  final int page;
  final CharcoalPaginationSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final dimension = _extent(theme, size);
    final radius = BorderRadius.circular(theme.metrics.pagination.cornerRadius);
    final duration = theme.duration(context, theme.motion.standard);
    if (current) {
      return Semantics(
        excludeSemantics: true,
        label: label,
        selected: true,
        child: SizedBox.square(
          dimension: dimension,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: radius, color: colors.hud),
            child: Center(
              child: Text(
                '$page',
                style: theme.style(CharcoalTextRole.bodyBold, color: colors.textOnHud),
              ),
            ),
          ),
        ),
      );
    }

    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: label,
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final pressed = states.contains(WidgetState.pressed);
        final hovered = states.contains(WidgetState.hovered);
        final background = pressed
            ? colors.surfaceTertiaryPress
            : hovered
            ? colors.surfaceSecondary
            : colors.restOverlay;
        final foreground = pressed ? colors.textTertiaryPress : colors.textTertiary;
        return CharcoalDisabledFade(
          disabled: states.contains(WidgetState.disabled),
          child: AnimatedContainer(
            curve: theme.motion.curve,
            duration: duration,
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: charcoalHaloShadow(theme, visible: focused),
              color: background,
            ),
            child: Center(
              child: Text(
                '$page',
                style: theme.style(CharcoalTextRole.bodyBold, color: foreground),
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _Ellipsis extends StatelessWidget {
  const _Ellipsis({required this.size});

  final CharcoalPaginationSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: _extent(theme, size),
        child: Center(
          child: Text(
            '\u2026',
            style: theme.style(CharcoalTextRole.bodyBold, color: theme.colors.textTertiary),
          ),
        ),
      ),
    );
  }
}

final class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.backwards,
    required this.onPressed,
    required this.semanticLabel,
    required this.size,
    required this.visible,
  });

  final bool backwards;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final CharcoalIconButtonSize size;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final pointsLeft = backwards == (Directionality.of(context) == TextDirection.ltr);
    return ExcludeSemantics(
      excluding: !visible,
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedOpacity(
          duration: theme.duration(context, theme.motion.standard),
          opacity: visible ? 1 : 0,
          child: CharcoalIconButton(
            icon: CharcoalIcon(
              pointsLeft ? CharcoalIcons16.chevronLeft : CharcoalIcons16.chevronRight,
            ),
            onPressed: visible ? onPressed : null,
            semanticLabel: semanticLabel,
            size: size,
          ),
        ),
      ),
    );
  }
}

int _effectiveMaxVisiblePages({
  required double availableWidth,
  required double itemExtent,
  required int requested,
}) {
  if (!availableWidth.isFinite) return requested;
  final availablePageSlots = (availableWidth / itemExtent).floor() - 2;
  final capped = availablePageSlots.clamp(3, requested);
  return capped.isEven ? capped - 1 : capped;
}

List<int?> _visibleItems(int current, int total, int maxVisible) {
  if (total <= maxVisible) {
    return <int?>[for (var page = 1; page <= total; page++) page];
  }
  if (maxVisible == 3) {
    if (current <= 2) {
      return <int?>[1, 2, total];
    }
    if (current >= total - 1) {
      return <int?>[1, total - 1, total];
    }
    return <int?>[1, current, total];
  }
  final edgeWindow = maxVisible - 2;
  if (current <= edgeWindow - 1) {
    return <int?>[
      for (var page = 1; page <= edgeWindow; page++) page,
      null,
      total,
    ];
  }
  if (current >= total - edgeWindow + 2) {
    return <int?>[
      1,
      null,
      for (var page = total - edgeWindow + 1; page <= total; page++) page,
    ];
  }
  final siblingCount = (maxVisible - 5) ~/ 2;
  return <int?>[
    1,
    null,
    for (var page = current - siblingCount; page <= current + siblingCount; page++) page,
    null,
    total,
  ];
}
