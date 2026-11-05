import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A section heading with an optional caption and trailing action.
///
/// The caption sits beside the title and wraps below it when there is not enough room; [action]
/// stays at the end of the row, aligned to the bottom of the title.
final class CharcoalSectionHeader extends StatelessWidget {
  /// Creates a heading with [title].
  const CharcoalSectionHeader(this.title, {this.action, this.caption, super.key});

  /// The heading text.
  final String title;

  /// A widget at the end of the row, usually a small button.
  final Widget? action;

  /// Secondary text beside the title.
  final String? caption;

  Widget? _captionText(CharcoalTheme theme) =>
      caption == null ? null : Text(caption!, style: theme.style(CharcoalTextRole.caption));

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Wrap(
            spacing: theme.space.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Semantics(
                header: true,
                child: Text(title, style: theme.style(CharcoalTextRole.sectionTitle)),
              ),
              ?_captionText(theme),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}
