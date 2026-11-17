import 'package:charcoal_theme/charcoal_theme.dart';

/// The horizontal inset of a section card's header and body, and of the first and last cells of a
/// data table, for a surface [width] wide.
///
/// `space.xl`, or `space.lg` on a surface narrower than `sizes.sidebarBreakpoint`, so a table in a
/// flush card lines up with the card's title at every width.
double charcoalSectionInset(CharcoalTheme theme, double width) =>
    width < theme.sizes.sidebarBreakpoint ? theme.space.lg : theme.space.xl;
