import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'selectable.dart';

/// The width of the label column of [CharcoalInfoRows].
enum CharcoalInfoLabelWidth {
  /// `sizes.infoLabelWidthNarrow`.
  narrow,

  /// `sizes.infoLabelWidth`.
  regular,

  /// `sizes.infoLabelWidthWide`.
  wide,

  /// `sizes.infoLabelWidthExtraWide`.
  extraWide,
}

/// A key/value table: a tertiary label, and a selectable value, per ruled row.
///
/// Each entry is a `(label, value)` record. Values can be selected and copied with the pointer.
///
/// ```dart
/// const CharcoalInfoRows([('Email', 'alice@example.com'), ('Plan', 'Pro')])
/// ```
final class CharcoalInfoRows extends StatelessWidget {
  /// Creates a table of [rows].
  const CharcoalInfoRows(
    this.rows, {
    this.labelWidth = CharcoalInfoLabelWidth.regular,
    this.mono = false,
    super.key,
  });

  /// The `(label, value)` pairs in display order.
  final List<(String, String)> rows;

  /// The width of the label column.
  final CharcoalInfoLabelWidth labelWidth;

  /// Whether the values use the monospace family (identifiers, keys, JSON).
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final rule = BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline);
    final labelExtent = switch (labelWidth) {
      CharcoalInfoLabelWidth.narrow => theme.sizes.infoLabelWidthNarrow,
      CharcoalInfoLabelWidth.regular => theme.sizes.infoLabelWidth,
      CharcoalInfoLabelWidth.wide => theme.sizes.infoLabelWidthWide,
      CharcoalInfoLabelWidth.extraWide => theme.sizes.infoLabelWidthExtraWide,
    };
    return CharcoalSelectable(
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: rule)),
        child: Column(
          children: <Widget>[
            for (final (label, value) in rows)
              DecoratedBox(
                decoration: BoxDecoration(border: Border(bottom: rule)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: theme.space.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: labelExtent,
                        child: Text(
                          label,
                          style: theme.style(
                            CharcoalTextRole.body,
                            color: theme.colors.textTertiary,
                          ),
                        ),
                      ),
                      SizedBox(width: theme.space.lg),
                      Expanded(
                        child: Text(value, style: theme.style(CharcoalTextRole.body, mono: mono)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
