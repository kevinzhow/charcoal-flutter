import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Keeps repeated Daylight surfaces on one compact, scannable rhythm.
///
/// Larger breathing space belongs around the group, where pages can express
/// hierarchy without making equivalent items feel unrelated.
final class DaylightItemGroup extends StatelessWidget {
  const DaylightItemGroup({required this.children, super.key})
    : assert(children.length > 0);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final itemGap = CharcoalTheme.of(context).dimensions.space.component20;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final (index, child) in children.indexed) ...<Widget>[
          if (index > 0) SizedBox(height: itemGap),
          child,
        ],
      ],
    );
  }
}
