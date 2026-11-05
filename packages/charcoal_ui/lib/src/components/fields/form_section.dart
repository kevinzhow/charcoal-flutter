import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A titled group of fields with consistent vertical rhythm.
///
/// The title uses the section-title role, the optional [caption] the caption role. The section
/// leaves `space.xxl` below itself, so consecutive sections need no spacers.
class CharcoalFormSection extends StatelessWidget {
  /// A section with [title] and [children].
  const CharcoalFormSection({
    required this.title,
    required this.children,
    this.caption,
    super.key,
  });

  /// The heading.
  final String title;

  /// Muted text under the heading.
  final String? caption;

  /// The fields, separated by `space.md`.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Padding(
      padding: EdgeInsets.only(bottom: space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Semantics(
            header: true,
            container: true,
            child: Text(title, style: theme.style(CharcoalTextRole.sectionTitle)),
          ),
          if (caption != null) ...<Widget>[
            SizedBox(height: space.xs),
            Text(caption!, style: theme.style(CharcoalTextRole.caption)),
          ],
          SizedBox(height: space.md),
          for (var i = 0; i < children.length; i++)
            Padding(
              padding: i == children.length - 1
                  ? EdgeInsets.zero
                  : EdgeInsets.only(bottom: space.md),
              child: children[i],
            ),
        ],
      ),
    );
  }
}
