import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'icon_button.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _PaginationSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const cornerRadius = 20.0;
  static const focusRingWidth = 4.0;
}

enum CharcoalPaginationSize { small, medium }

/// A one-indexed, controlled pagination component.
final class CharcoalPagination extends StatelessWidget {
  const CharcoalPagination({
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    this.maxVisiblePages = 7,
    this.nextLabel = 'Next page',
    this.previousLabel = 'Previous page',
    this.semanticLabel = 'Pagination',
    this.size = CharcoalPaginationSize.medium,
    super.key,
  }) : assert(pageCount > 0),
       assert(currentPage > 0 && currentPage <= pageCount),
       assert(maxVisiblePages >= 3 && maxVisiblePages % 2 == 1);

  final int currentPage;
  final int pageCount;
  final ValueChanged<int>? onPageChanged;

  /// Maximum number of numbered page buttons, as an odd value of at least 3.
  final int maxVisiblePages;
  final String nextLabel;
  final String previousLabel;
  final String semanticLabel;
  final CharcoalPaginationSize size;

  @override
  Widget build(BuildContext context) {
    final iconSize = switch (size) {
      CharcoalPaginationSize.small => CharcoalIconButtonSize.small,
      CharcoalPaginationSize.medium => CharcoalIconButtonSize.medium,
    };
    final items = _visibleItems(currentPage, pageCount, maxVisiblePages);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _PaginationNavigationButton(
            backwards: true,
            onPressed: onPageChanged == null ? null : () => onPageChanged!(currentPage - 1),
            semanticLabel: previousLabel,
            size: iconSize,
            visible: currentPage > 1,
          ),
          for (final item in items)
            if (item == null)
              _PaginationEllipsis(size: size)
            else
              _PaginationPage(
                current: item == currentPage,
                onPressed: onPageChanged == null ? null : () => onPageChanged!(item),
                page: item,
                size: size,
              ),
          _PaginationNavigationButton(
            backwards: false,
            onPressed: onPageChanged == null ? null : () => onPageChanged!(currentPage + 1),
            semanticLabel: nextLabel,
            size: iconSize,
            visible: currentPage < pageCount,
          ),
        ],
      ),
    );
  }
}

final class _PaginationPage extends StatelessWidget {
  const _PaginationPage({
    required this.current,
    required this.onPressed,
    required this.page,
    required this.size,
  });

  final bool current;
  final VoidCallback? onPressed;
  final int page;
  final CharcoalPaginationSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final dimension = switch (size) {
      CharcoalPaginationSize.small => theme.dimensions.space.targetS,
      CharcoalPaginationSize.medium => theme.dimensions.space.targetM,
    };
    final textStyle = charcoalTypographyStyle(
      context,
      size: CharcoalTypographySize.size14,
      weight: CharcoalTypographyWeight.bold,
    );
    if (current) {
      return Semantics(
        label: 'Page $page',
        selected: true,
        child: SizedBox.square(
          dimension: dimension,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _PaginationSpec.cornerRadius,
              ),
              color: theme.colors.containerHudDefault,
            ),
            child: Center(
              child: Text(
                '$page',
                style: textStyle.copyWith(color: theme.colors.textOnHudDefault),
              ),
            ),
          ),
        ),
      );
    }

    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: 'Page $page',
      builder: (context, states) {
        final disabled = states.contains(WidgetState.disabled);
        final focused = states.contains(WidgetState.focused);
        final pressed = states.contains(WidgetState.pressed);
        final hovered = states.contains(WidgetState.hovered);
        final background = pressed
            ? theme.colors.containerTertiaryPress
            : hovered
            ? theme.colors.containerSecondaryDefault
            : theme.colors.containerDefaultA;
        final foreground = pressed
            ? theme.colors.textTertiaryPress
            : theme.colors.textTertiaryDefault;
        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: CharcoalMotion.resolveDuration(
            context,
            _PaginationSpec.animationDuration,
          ),
          opacity: disabled ? charcoalDisabledOpacity : 1,
          child: AnimatedContainer(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              _PaginationSpec.animationDuration,
            ),
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _PaginationSpec.cornerRadius,
              ),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: theme.colors.borderFocusLegacy,
                        spreadRadius: _PaginationSpec.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: Center(
              child: Text('$page', style: textStyle.copyWith(color: foreground)),
            ),
          ),
        );
      },
    );
  }
}

final class _PaginationEllipsis extends StatelessWidget {
  const _PaginationEllipsis({required this.size});

  final CharcoalPaginationSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final dimension = switch (size) {
      CharcoalPaginationSize.small => theme.dimensions.space.targetS,
      CharcoalPaginationSize.medium => theme.dimensions.space.targetM,
    };
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: dimension,
        child: Center(
          child: Text(
            '…',
            style: charcoalTypographyStyle(
              context,
              color: theme.colors.textTertiaryDefault,
              size: CharcoalTypographySize.size14,
              weight: CharcoalTypographyWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

final class _PaginationNavigationButton extends StatelessWidget {
  const _PaginationNavigationButton({
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
  Widget build(BuildContext context) => ExcludeSemantics(
    excluding: !visible,
    child: IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: CharcoalMotion.resolveDuration(
          context,
          _PaginationSpec.animationDuration,
        ),
        opacity: visible ? 1 : 0,
        child: CharcoalIconButton(
          icon: CharcoalIcon(
            backwards ? CharcoalIcons16.chevronLeft : CharcoalIcons16.chevronRight,
          ),
          onPressed: onPressed,
          semanticLabel: semanticLabel,
          size: size,
        ),
      ),
    ),
  );
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
