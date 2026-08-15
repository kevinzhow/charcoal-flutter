import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/component_tokens.dart';
import 'clickable.dart';
import 'icon_button.dart';

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
       assert(maxVisiblePages >= 5);

  final int currentPage;
  final int pageCount;
  final ValueChanged<int>? onPageChanged;
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
          CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons16.chevronLeft),
            onPressed: currentPage == 1 || onPageChanged == null
                ? null
                : () => onPageChanged!(currentPage - 1),
            semanticLabel: previousLabel,
            size: iconSize,
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
          CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons16.chevronRight),
            onPressed: currentPage == pageCount || onPageChanged == null
                ? null
                : () => onPageChanged!(currentPage + 1),
            semanticLabel: nextLabel,
            size: iconSize,
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
    final textStyle = theme.textStyles.captionMediumBold;
    if (current) {
      return Semantics(
        label: 'Page $page',
        selected: true,
        child: SizedBox.square(
          dimension: dimension,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
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
          duration: theme.components.button.animationDuration,
          opacity: disabled ? theme.components.button.disabledOpacity : 1,
          child: AnimatedContainer(
            curve: CharcoalMotion.standardCurve,
            duration: theme.components.button.animationDuration,
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: theme.components.button.focusRingColor,
                        spreadRadius: theme.components.button.focusRingWidth,
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
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textTertiaryDefault,
            ),
          ),
        ),
      ),
    );
  }
}

List<int?> _visibleItems(int current, int total, int maxVisible) {
  if (total <= maxVisible) {
    return <int?>[for (var page = 1; page <= total; page++) page];
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
