import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The width class of a field in a filter bar or form.
enum CharcoalFieldWidth {
  /// Exactly `sizes.fieldWidthCompact`, for a filter dropdown beside others.
  compact,

  /// At most `sizes.formMaxWidth`, for a form field that should not stretch across a wide page.
  standard,

  /// The full width the parent offers.
  full,
}

/// Gives a field (`CharcoalTextField`, `CharcoalDropdown`, `CharcoalSearchField`...) a width class.
///
/// One wrapper instead of a `width` parameter on every field, so the three classes mean the same
/// thing everywhere. It does not change the field's height or its label and assistive text.
///
/// ```dart
/// CharcoalFieldBox(width: CharcoalFieldWidth.compact, child: CharcoalDropdown<int>(...))
/// ```
final class CharcoalFieldBox extends StatelessWidget {
  /// Applies [width] to [child].
  const CharcoalFieldBox({required this.child, this.width = CharcoalFieldWidth.full, super.key});

  /// The field.
  final Widget child;

  /// The width class.
  final CharcoalFieldWidth width;

  @override
  Widget build(BuildContext context) {
    final sizes = CharcoalTheme.of(context).sizes;
    return switch (width) {
      CharcoalFieldWidth.compact => SizedBox(width: sizes.fieldWidthCompact, child: child),
      CharcoalFieldWidth.standard => ConstrainedBox(
        constraints: BoxConstraints(maxWidth: sizes.formMaxWidth),
        child: child,
      ),
      CharcoalFieldWidth.full => child,
    };
  }
}
