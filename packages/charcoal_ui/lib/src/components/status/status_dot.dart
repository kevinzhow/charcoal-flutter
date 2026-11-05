import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The leading dot that marks row status when not in selection mode.
///
/// It reserves the same slot (`sizes.indicatorSlot`) as `CharcoalSelectionBox`, so entering and
/// leaving selection mode cannot shift a row's content sideways. The dot colour comes from [tone].
class CharcoalStatusDot extends StatelessWidget {
  /// Creates a dot for [tone].
  const CharcoalStatusDot(this.tone, {super.key});

  /// The status the dot represents.
  final CharcoalTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox.square(
      dimension: theme.sizes.indicatorSlot,
      child: Center(
        child: Container(
          width: theme.sizes.statusDot,
          height: theme.sizes.statusDot,
          decoration: BoxDecoration(color: theme.tone(tone).dot, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
