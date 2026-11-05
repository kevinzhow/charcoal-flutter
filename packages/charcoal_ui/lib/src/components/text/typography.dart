import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Applies a Charcoal type role to every [Text] below it.
///
/// This is the widget form of the numeric type ladder (`CharcoalTextRole.size10` ... `size20`) and
/// of the named roles. Flutter's ambient `MediaQuery.textScalerOf` is left intact, so the styles
/// follow Dynamic Type and accessibility scaling. Use [CharcoalText] for a single run of text.
class CharcoalTypography extends StatelessWidget {
  /// Applies [role] to [child].
  ///
  /// [singleLine] and [monospace] truncate with an ellipsis after one line. [bold] selects the
  /// pack's bold weight instead of the role's own.
  const CharcoalTypography({
    required this.child,
    this.role = CharcoalTextRole.size14,
    this.bold = false,
    this.color,
    this.monospace = false,
    this.singleLine = false,
    this.textAlign,
    super.key,
  });

  /// The subtree that inherits the style.
  final Widget child;

  /// The type role.
  final CharcoalTextRole role;

  /// Whether to use the pack's bold weight.
  final bool bold;

  /// Text colour; defaults to the role's colour.
  final Color? color;

  /// Whether to use the pack's monospace family. Implies a single line.
  final bool monospace;

  /// Whether to limit the text to one line with an ellipsis.
  final bool singleLine;

  /// Alignment of the text.
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => DefaultTextStyle.merge(
    maxLines: singleLine || monospace ? 1 : null,
    overflow: singleLine || monospace ? TextOverflow.ellipsis : null,
    style: CharcoalTheme.of(context).style(role, color: color, bold: bold, mono: monospace),
    textAlign: textAlign,
    child: child,
  );
}
