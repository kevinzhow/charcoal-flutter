import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'text_tone.dart';

/// A run of text in a Charcoal type role.
///
/// The one place application code reads typography from: it resolves [role] against the active
/// pack, so no size, weight or family appears at the call site. Text scaling is inherited.
class CharcoalText extends StatelessWidget {
  /// Shows [data] in [role].
  const CharcoalText(
    this.data, {
    this.role = CharcoalTextRole.body,
    this.bold = false,
    this.color,
    this.maxLines,
    this.mono = false,
    this.overflow,
    this.semanticLabel,
    this.softWrap,
    this.textAlign,
    this.tone,
    super.key,
  }) : assert(maxLines == null || maxLines > 0),
       assert(color == null || tone == null, 'Pass either color or tone, not both'),
       assert(semanticLabel == null || semanticLabel != '');

  /// The text.
  final String data;

  /// The type role.
  final CharcoalTextRole role;

  /// Whether to use the pack's bold weight.
  final bool bold;

  /// Colour; defaults to the role's colour in the pack. For the library's own components;
  /// applications name a [tone] instead.
  final Color? color;

  /// Maximum number of lines.
  final int? maxLines;

  /// Whether to use the pack's monospace family.
  final bool mono;

  /// How to handle overflow.
  final TextOverflow? overflow;

  /// Spoken replacement for [data].
  final String? semanticLabel;

  /// Whether the text wraps at soft line breaks.
  final bool? softWrap;

  /// Alignment of the text.
  final TextAlign? textAlign;

  /// The semantic colour; defaults to the role's colour in the pack. Exclusive with [color].
  final CharcoalTextTone? tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticLabel,
      softWrap: softWrap,
      style: theme.style(role, color: tone?.resolve(theme.colors) ?? color, bold: bold, mono: mono),
      textAlign: textAlign,
    );
  }
}
