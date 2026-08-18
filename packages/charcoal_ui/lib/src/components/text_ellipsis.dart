import 'package:flutter/widgets.dart';

/// A small explicit wrapper for Charcoal's text truncation behavior.
///
/// The complete [data] remains available to accessibility by default even
/// when it is visually truncated. Use [semanticLabel] only when the spoken
/// wording needs additional context; it must not be empty.
final class CharcoalTextEllipsis extends StatelessWidget {
  const CharcoalTextEllipsis(
    this.data, {
    this.maxLines = 1,
    this.semanticLabel,
    this.style,
    this.textAlign,
    super.key,
  }) : assert(maxLines > 0),
       assert(semanticLabel == null || semanticLabel != '');

  final String data;
  final int maxLines;
  final String? semanticLabel;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => Text(
    data,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    semanticsLabel: semanticLabel,
    softWrap: true,
    style: style,
    textAlign: textAlign,
  );
}
