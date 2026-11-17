import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../actions/button.dart';
import '../text/text_tone.dart';
import 'divider.dart';
import 'section_inset.dart';

/// One titled section of a page on a raised card: a header with the [title], an optional
/// [caption] and the section's own [actions], above a body of [children].
///
/// The header and the body share one horizontal inset, `space.xl` (`space.lg` on a card narrower
/// than `sizes.sidebarBreakpoint`), and a hairline separates them. The [actions] sit at the end
/// of the header, aligned with the title's first line. The body stacks [children] with `space.md`
/// between them; [dividers] puts a hairline in the middle of each gap instead. [flush] drops the
/// body's insets and gaps, so a `CharcoalDataTable` or a list reaches the card edges (a
/// `CharcoalDataTable` lines its cells up with the title by itself). A card without [children] is
/// a header alone, such as a switch with its explanation.
///
/// The surface looks like the raised `CharcoalCard`: page colour, hairline outline, `radius.md`.
/// The content is clipped to it and the outline is painted over it, so a flush row's hover
/// background and its bottom rule run under the outline instead of doubling it. Stack sections
/// with `CharcoalGap(CharcoalSpace.lg)` between them.
///
/// ```dart
/// CharcoalSectionCard(
///   title: 'Rules',
///   caption: 'Checked from top to bottom; the first match wins',
///   actions: [CharcoalButton(size: CharcoalButtonSize.small, onPressed: add, child: Text('Add rule'))],
///   flush: true,
///   children: [rulesTable],
/// )
/// ```
final class CharcoalSectionCard extends StatelessWidget {
  /// Creates a section titled [title] around [children].
  const CharcoalSectionCard({
    required this.title,
    required this.children,
    this.actions = const <Widget>[],
    this.caption,
    this.dividers = false,
    this.flush = false,
    super.key,
  });

  /// The section heading.
  final String title;

  /// The body content, top to bottom; empty for a header-only card.
  final List<Widget> children;

  /// The section's own actions at the end of the header, usually small buttons.
  final List<Widget> actions;

  /// A line of explanation under the title.
  final String? caption;

  /// Whether a hairline separates consecutive [children].
  final bool dividers;

  /// Whether the body drops its insets and gaps so [children] reach the card edges.
  final bool flush;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final space = theme.space;
    final radius = BorderRadius.circular(theme.radius.md);
    // The raised CharcoalCard look, with the outline painted over the clipped content: a flush
    // row's background and bottom rule run under the outline instead of doubling it.
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderSubtle, width: theme.borders.hairline),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: ColoredBox(
          color: colors.background,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final inset = charcoalSectionInset(theme, constraints.maxWidth);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: inset, vertical: space.lg),
                    child: _SectionHeader(
                      title: title,
                      caption: caption,
                      actions: actions,
                      width: constraints.maxWidth - inset * 2,
                    ),
                  ),
                  if (children.isNotEmpty) ...<Widget>[
                    const CharcoalDivider(),
                    Padding(
                      padding: flush
                          ? EdgeInsets.zero
                          : EdgeInsets.symmetric(horizontal: inset, vertical: space.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (var i = 0; i < children.length; i++) ...<Widget>[
                            if (i > 0) ..._separator(space),
                            children[i],
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _separator(CharcoalSpaceScale space) {
    if (flush) return dividers ? const <Widget>[CharcoalDivider()] : const <Widget>[];
    final gap = SizedBox(height: space.md);
    return dividers ? <Widget>[gap, const CharcoalDivider(), gap] : <Widget>[gap];
  }
}

/// A [CharcoalSectionCard] for an irreversible action, such as deleting the record the page
/// shows: the [title], a [description] of what is lost, and one negative-toned action.
///
/// Put it last on the page. [onPressed] should ask for confirmation (`showCharcoalConfirm`)
/// before it acts; null disables the action.
final class CharcoalDangerZone extends StatelessWidget {
  /// Creates a danger zone whose action is labelled [actionLabel].
  const CharcoalDangerZone({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  /// What the action does, e.g. "Delete flag".
  final String title;

  /// What is lost and what to do instead, e.g. "Its 2 rules are deleted too. To pause it, turn
  /// off the kill switch."
  final String description;

  /// The button label, e.g. "Delete".
  final String actionLabel;

  /// Called by the button; null disables it.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => CharcoalSectionCard(
    title: title,
    caption: description,
    actions: <Widget>[
      CharcoalButton(
        size: CharcoalButtonSize.small,
        labelTone: CharcoalTextTone.negative,
        leading: const CharcoalIcon(CharcoalIcons.delete),
        onPressed: onPressed,
        child: Text(actionLabel),
      ),
    ],
    children: const <Widget>[],
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.caption,
    required this.actions,
    required this.width,
  });

  final String title;
  final String? caption;
  final List<Widget> actions;

  /// The width of the header row.
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Row(
      // The actions' labels share the title's baseline; an action without text sits at the top.
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Semantics(
                header: true,
                child: Text(title, style: theme.style(CharcoalTextRole.sectionTitle)),
              ),
              if (caption case final caption?) ...<Widget>[
                SizedBox(height: space.xxs),
                Text(caption, style: theme.style(CharcoalTextRole.caption)),
              ],
            ],
          ),
        ),
        if (actions.isNotEmpty) ...<Widget>[
          SizedBox(width: space.md),
          // At most half the header, so a long label or a large text scale shortens the actions
          // instead of pushing them past the card edge.
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width / 2),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: space.sm,
              runSpacing: space.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: actions,
            ),
          ),
        ],
      ],
    );
  }
}
