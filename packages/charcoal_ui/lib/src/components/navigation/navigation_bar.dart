import 'dart:math' as math;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../app/charcoal_scaffold.dart' show CharcoalContextualHeight;

/// A page-level navigation bar with a centred title and balanced edge slots.
///
/// The bar owns navigation structure, surface and title alignment. Supply a `CharcoalIconButton`
/// or another appropriately sized control in [leading] and [trailing]; both edge slots always have
/// the same width so the title stays centred. The bar grows with the text scale, and system
/// safe-area padding remains the responsibility of the surrounding app shell.
///
/// ```dart
/// CharcoalNavigationBar(
///   title: const Text('Settings'),
///   leading: CharcoalIconButton(
///     icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
///     onPressed: Navigator.of(context).maybePop,
///     semanticLabel: 'Back',
///   ),
/// )
/// ```
final class CharcoalNavigationBar extends StatelessWidget
    implements PreferredSizeWidget, CharcoalContextualHeight {
  /// Creates a bar with [title] in the middle.
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

  /// A back, close or contextual leading control.
  final Widget? leading;

  /// Optional label for the navigation region.
  final String? semanticLabel;

  /// Whether a subtle divider separates the bar from scrolling content.
  final bool showDivider;

  /// One action or a compact row of related actions.
  final Widget? trailing;

  /// The baseline height of the default pack. A [PreferredSizeWidget] cannot read the theme, so
  /// [heightFor] is the real value; `CharcoalScaffold` asks for it.
  @override
  Size get preferredSize => Size.fromHeight(charcoalLightPack.metrics.navigationBar.height);

  /// The bar height for the current theme and text scale.
  @override
  double heightFor(BuildContext context) {
    final metrics = CharcoalTheme.of(context).metrics.navigationBar;
    return math.max(
      metrics.height,
      MediaQuery.textScalerOf(context).scale(metrics.titleScaleBase) + metrics.verticalChrome,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.navigationBar;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: theme.colors.borderSubtle,
                    width: theme.borders.hairline,
                  ),
                )
              : null,
          color: theme.colors.background,
        ),
        child: SizedBox(
          height: heightFor(context),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalInset = theme.space.lg;
              final availableWidth = math.max(0.0, constraints.maxWidth - horizontalInset * 2);
              final preferredEdgeExtent = math.max(
                theme.sizes.controlLg,
                (availableWidth - metrics.minTitleExtent) / 2,
              );
              final edgeExtent = math.min(
                availableWidth / 2,
                math.min(theme.sizes.controlLg * 2, preferredEdgeExtent),
              );
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                child: Row(
                  children: <Widget>[
                    _Slot(
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
                            style: theme.style(
                              CharcoalTextRole.captionBold,
                              color: theme.colors.text,
                            ),
                            child: title,
                          ),
                        ),
                      ),
                    ),
                    _Slot(
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

final class _Slot extends StatelessWidget {
  const _Slot({required this.alignment, required this.child, required this.extent});

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
