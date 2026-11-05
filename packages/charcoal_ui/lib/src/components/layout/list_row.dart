import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/layout.dart';
import '../text/text_tone.dart';
import 'selectable.dart';

/// The minimum height of a [CharcoalListRow].
enum CharcoalListRowHeight {
  /// `sizes.rowMinHeightCompact`, for dense lists.
  compact,

  /// `sizes.rowMinHeight`, the default.
  regular,

  /// `sizes.rowMinHeightTall`, for rows with a leading avatar and two lines.
  tall,
}

/// One row of a `CharcoalList`.
///
/// Everything but [title] is optional, so the same row serves projects, users, roles, providers
/// and logs. A null [onPressed] renders a static row that is not a button (its actions are
/// trailing widgets); otherwise the row is a button with a trailing chevron ([showChevron]).
///
/// Selection is the persistent layer of the row's single decoration; hover and press are blended
/// on top of it, so a held row never reads as a second selected row. The state layer, the focus
/// outline and the rule below the row live in that one decoration: hover, focus, press and
/// selection never move the row's bounds, icon centres or text baselines.
///
/// With `crossAxisAlignment: CrossAxisAlignment.start` (a tall row with a [body]) the leading
/// widget and the chevron sit at the top, `space.xs` below the row's padding so they line up with
/// the first text line. [verticalPadding] makes the row roomier, [subtitleRole] and [subtitleTone]
/// promote the second line to running text, and [body] adds a free slot (chips, say) under it.
///
/// ```dart
/// CharcoalListRow(
///   title: 'Alice',
///   subtitle: 'alice@example.com',
///   trailing: const [CharcoalChip('admin')],
///   onPressed: () => open('alice'),
/// )
/// ```
final class CharcoalListRow extends StatelessWidget {
  /// Creates a row with [title].
  const CharcoalListRow({
    required this.title,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.details,
    this.height = CharcoalListRowHeight.regular,
    this.body,
    this.leading,
    this.onPressed,
    this.selected = false,
    this.showChevron = true,
    this.statesController,
    this.subtitle,
    this.subtitleGap,
    this.subtitleMaxLines = 2,
    this.subtitleRole = CharcoalTextRole.caption,
    this.subtitleTone,
    this.titleMonospace = false,
    this.titleTrailing,
    this.trailing = const <Widget>[],
    this.verticalPadding = CharcoalSpace.sm,
    super.key,
  }) : assert(subtitleMaxLines > 0);

  /// The primary line.
  final String title;

  /// How the leading, text block and trailing widgets align across the row.
  final CrossAxisAlignment crossAxisAlignment;

  /// Selectable secondary text below the whole row content, e.g. a payload or error.
  final String? details;

  /// The minimum height.
  final CharcoalListRowHeight height;

  /// A widget before the text, usually a `CharcoalAvatar` or an icon.
  final Widget? leading;

  /// Called on activation; null makes the row static.
  final VoidCallback? onPressed;

  /// Whether this is the current row.
  final bool selected;

  /// Whether an interactive row shows its trailing chevron.
  final bool showChevron;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  /// The caption line under the title.
  final String? subtitle;

  /// The space between title and [subtitle]; none when null.
  final CharcoalSpace? subtitleGap;

  /// Maximum number of [subtitle] lines.
  final int subtitleMaxLines;

  /// The type role of [subtitle].
  final CharcoalTextRole subtitleRole;

  /// The colour of [subtitle]; the role's colour when null.
  final CharcoalTextTone? subtitleTone;

  /// A widget under the title and subtitle inside the text block, usually a `CharcoalWrap` of
  /// chips.
  final Widget? body;

  /// Whether the title uses the monospace family (identifiers, keys).
  final bool titleMonospace;

  /// Inline widgets on the title line itself, which wrap with the title instead of sitting at
  /// the far end of the row.
  final List<Widget>? titleTrailing;

  /// Widgets between the text block and the chevron, usually chips.
  final List<Widget> trailing;

  /// The space above and below the content.
  final CharcoalSpace verticalPadding;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) return _paint(context, const <WidgetState>{});
    return CharcoalClickable(
      onPressed: onPressed,
      selected: selected,
      semanticLabel: title,
      statesController: statesController,
      builder: _paint,
    );
  }

  Widget _paint(BuildContext context, Set<WidgetState> states) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final space = theme.space;
    final base = selected ? theme.tone(CharcoalTone.info).surface : colors.background;
    final overlay = states.contains(WidgetState.pressed)
        ? colors.pressOverlay
        : states.contains(WidgetState.hovered)
        ? colors.hoverOverlay
        : null;
    final background = overlay == null ? base : Color.alphaBlend(overlay, base);
    final minHeight = switch (height) {
      CharcoalListRowHeight.compact => theme.sizes.rowMinHeightCompact,
      CharcoalListRowHeight.regular => theme.sizes.rowMinHeight,
      CharcoalListRowHeight.tall => theme.sizes.rowMinHeightTall,
    };
    final titleStyle = theme.style(
      CharcoalTextRole.bodyBold,
      color: colors.text,
      mono: titleMonospace,
    );
    final inlineTrailing = titleTrailing;
    // At the top of a tall row the leading widget and chevron line up with the first text line.
    final topInset = crossAxisAlignment == CrossAxisAlignment.start ? space.xs : 0.0;

    return AnimatedContainer(
      duration: theme.duration(context, theme.motion.fast),
      curve: theme.motion.curve,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: EdgeInsets.symmetric(horizontal: space.xs, vertical: verticalPadding.of(space)),
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: theme.borders.hairline),
        ),
      ),
      // Painted over the row without taking part in layout.
      foregroundDecoration: states.contains(WidgetState.focused)
          ? BoxDecoration(
              border: Border.all(color: colors.borderFocus, width: theme.borders.hairline),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: crossAxisAlignment,
            children: <Widget>[
              if (leading != null) ...<Widget>[
                Padding(
                  padding: EdgeInsets.only(top: topInset),
                  child: leading,
                ),
                SizedBox(width: space.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (inlineTrailing == null || inlineTrailing.isEmpty)
                      Text(title, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
                    else
                      Wrap(
                        spacing: space.sm,
                        runSpacing: space.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(title, style: titleStyle),
                          ...inlineTrailing,
                        ],
                      ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: subtitleGap?.of(space) ?? 0),
                        child: Text(
                          subtitle!,
                          style: theme.style(subtitleRole, color: subtitleTone?.resolve(colors)),
                          maxLines: subtitleMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (body != null)
                      Padding(
                        padding: EdgeInsets.only(top: space.xs),
                        child: body,
                      ),
                  ],
                ),
              ),
              if (trailing.isNotEmpty) ...<Widget>[
                SizedBox(width: space.md),
                Wrap(
                  spacing: space.sm,
                  runSpacing: space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: trailing,
                ),
              ],
              if (showChevron && onPressed != null) ...<Widget>[
                SizedBox(width: space.sm),
                Padding(
                  padding: EdgeInsets.only(top: topInset),
                  child: CharcoalIcon(
                    CharcoalIcons16.chevronRight,
                    size: theme.sizes.iconSm,
                    color: colors.iconTertiary,
                    matchTextDirection: true,
                  ),
                ),
              ],
            ],
          ),
          if (details != null)
            Padding(
              padding: EdgeInsets.only(top: space.sm),
              child: CharcoalSelectable(
                child: Text(details!, style: theme.style(CharcoalTextRole.caption)),
              ),
            ),
        ],
      ),
    );
  }
}
