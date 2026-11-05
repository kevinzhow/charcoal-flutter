import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'progress_ring.dart';

/// A centred progress ring for a loading page region.
///
/// Fills the width it is given and adds `space.xxxl` above and below, so replacing the region's
/// content with it does not collapse the layout. The ring is a [CharcoalProgressRing]: the quiet
/// indicator of admin pages, announced with [semanticLabel].
class CharcoalLoadingState extends StatelessWidget {
  /// Creates a loading state.
  const CharcoalLoadingState({this.semanticLabel = 'Loading', super.key});

  /// What assistive technology announces.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.space.xxxl),
      child: Center(child: CharcoalProgressRing(semanticLabel: semanticLabel)),
    );
  }
}
