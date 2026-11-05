import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'card.dart';

/// A stat tile: small label, large value, optional status, footnote and action.
final class CharcoalStatCard extends StatelessWidget {
  /// Creates a tile showing [value] under [label].
  const CharcoalStatCard({
    required this.label,
    required this.value,
    this.action,
    this.footnote,
    this.status,
    this.statusTone = CharcoalTone.neutral,
    super.key,
  });

  /// The caption above the value.
  final String label;

  /// The headline figure.
  final String value;

  /// A widget under the footnote, aligned to the start, usually a link button.
  final Widget? action;

  /// A caption under the value.
  final String? footnote;

  /// A short status at the end of the label row.
  final String? status;

  /// The colour family of [status].
  final CharcoalTone statusTone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return CharcoalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(label, style: theme.style(CharcoalTextRole.caption))),
              if (status != null)
                Text(
                  status!,
                  style: theme.style(
                    CharcoalTextRole.captionBold,
                    color: theme.tone(statusTone).foreground,
                  ),
                ),
            ],
          ),
          SizedBox(height: space.sm),
          Text(
            value,
            style: theme.style(CharcoalTextRole.sectionTitle),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (footnote != null) ...<Widget>[
            SizedBox(height: space.xs),
            Text(footnote!, style: theme.style(CharcoalTextRole.caption)),
          ],
          if (action != null) ...<Widget>[
            SizedBox(height: space.sm),
            Align(alignment: AlignmentDirectional.centerStart, child: action),
          ],
        ],
      ),
    );
  }
}
