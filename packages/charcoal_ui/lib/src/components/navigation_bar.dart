import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

abstract final class _NavigationBarSpec {
  static const height = 56.0;
  static const minTitleExtent = 96.0;
}

/// A page-level navigation bar with a centered title and balanced edge slots.
///
/// The bar owns navigation structure, surface, and title alignment. Supply
/// [CharcoalIconButton] or another appropriately sized control in [leading]
/// and [trailing]. System safe-area padding remains the responsibility of the
/// surrounding app shell.
final class CharcoalNavigationBar extends StatelessWidget {
  const CharcoalNavigationBar({
    required this.title,
    this.leading,
    this.semanticLabel,
    this.showDivider = true,
    this.trailing,
    super.key,
  });

  /// The concise page or destination title.
  final Widget title;

  /// A back, close, or contextual leading control.
  final Widget? leading;

  /// Optional label for the navigation region.
  final String? semanticLabel;

  /// Whether a subtle divider separates the bar from scrolling content.
  final bool showDivider;

  /// One action or a compact row of related actions.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: theme.colors.borderSecondary,
                    width: theme.dimensions.borderWidth.m,
                  ),
                )
              : null,
          color: theme.colors.backgroundDefault,
        ),
        child: SizedBox(
          height: _NavigationBarSpec.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalInset = space.component30;
              final availableWidth = math.max(
                0.0,
                constraints.maxWidth - horizontalInset * 2,
              );
              final preferredEdgeExtent = math.max(
                space.targetL,
                (availableWidth - _NavigationBarSpec.minTitleExtent) / 2,
              );
              final edgeExtent = math.min(
                availableWidth / 2,
                math.min(space.targetL * 2, preferredEdgeExtent),
              );
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                child: Row(
                  children: <Widget>[
                    _NavigationBarSlot(
                      alignment: AlignmentDirectional.centerStart,
                      extent: edgeExtent,
                      child: leading,
                    ),
                    Expanded(
                      child: Center(
                        child: Semantics(
                          header: true,
                          child: DefaultTextStyle(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyles.captionMediumBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                            child: title,
                          ),
                        ),
                      ),
                    ),
                    _NavigationBarSlot(
                      alignment: AlignmentDirectional.centerEnd,
                      extent: edgeExtent,
                      child: trailing,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _NavigationBarSlot extends StatelessWidget {
  const _NavigationBarSlot({
    required this.alignment,
    required this.child,
    required this.extent,
  });

  final AlignmentGeometry alignment;
  final Widget? child;
  final double extent;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: extent,
    child: ClipRect(
      child: Align(alignment: alignment, child: child),
    ),
  );
}
