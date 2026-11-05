import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';

import '../text/text_tone.dart';

/// A block of monospace text on `colors.backgroundSecondary`: a log excerpt, a JSON payload, a
/// list of failures.
///
/// It is the one implementation behind `showCharcoalCodeDialog` and the inline code displays of
/// pages. [selectable] lets the user select and copy the text. [maxLines] clips a long text with
/// an ellipsis; [scrollable] instead bounds the block by `sizes.codeViewportMaxHeight` and
/// scrolls the text inside it. Use [CharcoalCodeBlock.lines] for a long log: its rows are built
/// lazily and the block fills the height it is given.
///
/// ```dart
/// CharcoalCodeBlock(const JsonEncoder.withIndent('  ').convert(payload))
/// ```
final class CharcoalCodeBlock extends StatelessWidget {
  /// Shows [text].
  const CharcoalCodeBlock(
    this.text, {
    this.maxLines,
    this.scrollable = false,
    this.selectable = true,
    this.tone = CharcoalTextTone.primary,
    this.trailing,
    this.field = false,
    super.key,
  }) : lines = null,
       assert(maxLines == null || maxLines > 0);

  /// Shows [lines], one selectable row each, built lazily.
  ///
  /// The block takes the height its parent gives it (put it in an `Expanded`) and scrolls.
  const CharcoalCodeBlock.lines(
    List<String> this.lines, {
    this.selectable = true,
    this.tone = CharcoalTextTone.primary,
    super.key,
  }) : text = '',
       trailing = null,
       field = false,
       maxLines = null,
       scrollable = true;

  /// The text.
  final String text;

  /// The rows of [CharcoalCodeBlock.lines]; null for a plain block.
  final List<String>? lines;

  /// Maximum number of lines; the rest is ellipsised. Ignored when [scrollable].
  final int? maxLines;

  /// Whether the text scrolls inside a block bounded by `sizes.codeViewportMaxHeight`.
  final bool scrollable;

  /// Whether the text can be selected.
  final bool selectable;

  /// The text colour.
  final CharcoalTextTone tone;

  /// Actions at the end of the block (copy, reveal, edit), beside the text.
  final Widget? trailing;

  /// The tighter look of a single value box, e.g. a secret key: `radius.sm`, and `space.sm`
  /// padding except `space.md` before the text.
  final bool field;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final style = theme.style(
      CharcoalTextRole.captionMono,
      color: tone.resolve(theme.colors),
    );
    final rows = lines;
    final decoration = BoxDecoration(
      color: theme.colors.backgroundSecondary,
      borderRadius: BorderRadius.circular(field ? theme.radius.sm : theme.radius.md),
    );
    if (rows != null) {
      return DecoratedBox(
        decoration: decoration,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: theme.space.md,
            vertical: theme.space.sm,
          ),
          itemCount: rows.length,
          itemBuilder: (context, index) => selectable
              ? SelectableText(rows[index], style: style)
              : Text(rows[index], style: style),
        ),
      );
    }
    final clip = scrollable ? null : maxLines;
    Widget body = selectable
        ? SelectableText(text, maxLines: clip, style: style)
        : Text(
            text,
            maxLines: clip,
            overflow: clip == null ? null : TextOverflow.ellipsis,
            style: style,
          );
    if (scrollable) body = SingleChildScrollView(child: body);
    if (trailing != null) {
      body = Row(
        children: <Widget>[
          Expanded(child: body),
          trailing!,
        ],
      );
    }
    final block = Container(
      width: double.infinity,
      padding: field
          ? EdgeInsets.fromLTRB(theme.space.md, theme.space.sm, theme.space.sm, theme.space.sm)
          : EdgeInsets.all(theme.space.md),
      decoration: decoration,
      child: body,
    );
    return scrollable
        ? ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: theme.sizes.codeViewportMaxHeight,
            ),
            child: block,
          )
        : block;
  }
}
