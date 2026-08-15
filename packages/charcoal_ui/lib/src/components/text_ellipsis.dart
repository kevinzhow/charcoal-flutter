import 'package:flutter/widgets.dart';

/// A small explicit wrapper for Charcoal's text truncation behavior.
final class CharcoalTextEllipsis extends StatelessWidget {
  const CharcoalTextEllipsis(
    this.data, {
    this.maxLines = 1,
    this.semanticLabel,
    this.style,
    this.textAlign,
    super.key,
  }) : assert(maxLines > 0);

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
