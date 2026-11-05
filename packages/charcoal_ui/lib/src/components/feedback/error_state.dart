import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../actions/button.dart';
import 'banner.dart';

/// An error banner with a retry affordance.
///
/// A negative-tone [CharcoalBanner] showing [message]; when [onRetry] is set a small button
/// labelled [retryLabel] sits at its end.
class CharcoalErrorState extends StatelessWidget {
  /// Creates an error state showing [message].
  const CharcoalErrorState({
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    super.key,
  });

  /// What went wrong.
  final String message;

  /// Called by the retry button; null hides it.
  final VoidCallback? onRetry;

  /// The retry button's label.
  final String retryLabel;

  @override
  Widget build(BuildContext context) => CharcoalBanner(
    message: message,
    tone: CharcoalTone.negative,
    icon: CharcoalIcons.warn,
    action: onRetry == null
        ? null
        : CharcoalButton(
            size: CharcoalButtonSize.small,
            onPressed: onRetry,
            child: Text(retryLabel),
          ),
  );
}
