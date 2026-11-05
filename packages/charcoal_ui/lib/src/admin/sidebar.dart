import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'brand_mark.dart';

/// The fixed-width sidebar of an admin shell: a [brand] header, a scrolling list of destination
/// groups, and an optional [footer] (usually the account tile) above a rule.
///
/// Build the destinations from `CharcoalNavigationItem` with
/// `CharcoalNavigationItemVariant.sidebar`, grouped in `CharcoalSidebarGroup`s.
final class CharcoalSidebar extends StatelessWidget {
  /// Creates a sidebar.
  const CharcoalSidebar({required this.brand, required this.children, this.footer, super.key});

  /// The header, usually a `CharcoalSidebarBrand`.
  final Widget brand;

  /// The scrolling content, usually `CharcoalSidebarGroup`s.
  final List<Widget> children;

  /// A pinned bottom section.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final inset = theme.sizes.sidebarInset;
    final space = theme.space;
    final rule = BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        width: theme.sizes.sidebarWidth,
        decoration: BoxDecoration(
          color: theme.colors.background,
          border: Border(right: rule),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(inset, inset, inset, space.md), child: brand),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(space.md, space.xs, space.md, space.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
              ),
            ),
            if (footer != null)
              DecoratedBox(
                decoration: BoxDecoration(border: Border(top: rule)),
                child: Padding(padding: EdgeInsets.all(space.md), child: footer),
              ),
          ],
        ),
      ),
    );
  }
}

/// The brand header of a [CharcoalSidebar]: a primary-coloured mark with one letter, and the
/// product [title].
final class CharcoalSidebarBrand extends StatelessWidget {
  /// Creates a header.
  const CharcoalSidebarBrand({required this.mark, required this.title, super.key});

  /// The letter drawn in the mark.
  final String mark;

  /// The product name.
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      children: <Widget>[
        CharcoalBrandMark(mark),
        SizedBox(width: theme.space.sm),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: theme.style(CharcoalTextRole.sectionTitle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

/// A titled group of sidebar destinations with the design's tight gap between items.
final class CharcoalSidebarGroup extends StatelessWidget {
  /// Creates a group; a null [title] makes the ungrouped primary destinations.
  const CharcoalSidebarGroup({required this.children, this.title, super.key});

  /// The destinations, usually sidebar `CharcoalNavigationItem`s.
  final List<Widget> children;

  /// The group heading.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: theme.space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(theme.space.md, 0, theme.space.md, theme.space.sm),
              child: Semantics(
                header: true,
                child: Text(title!, style: theme.style(CharcoalTextRole.caption)),
              ),
            ),
          for (final child in children)
            Padding(
              padding: EdgeInsets.only(bottom: theme.space.xxs),
              child: child,
            ),
        ],
      ),
    );
  }
}
