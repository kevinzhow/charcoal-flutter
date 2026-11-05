import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show DialogRoute;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dialog.dart';

/// Presents [builder]'s page as a modal route with the Charcoal barrier and entrance.
///
/// This is Material's `DialogRoute` with Charcoal's transition: a centred dialog fades in from
/// `metrics.modal.initialScale`, a bottom sheet slides up. With reduced motion only the fade
/// remains. Escape dismisses when [barrierDismissible] is true. The ambient `ThemeData` is carried
/// into the route, so a dialog opened below a nested `Theme` keeps that theme.
///
/// Keep [useRootNavigator] enabled for application-level modal tasks. Set it to false when
/// [context] belongs to a deliberately bounded nested navigator, such as an embedded app preview
/// whose modal must stay inside that surface.
Future<T?> showCharcoalDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss dialog',
  Duration? duration,
  CharcoalModalStyle style = CharcoalModalStyle.center,
  bool useRootNavigator = true,
}) {
  assert(duration == null || !duration.isNegative);
  final theme = CharcoalTheme.of(context);
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push<T>(
    CharcoalDialogRoute<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      builder: builder,
      enterDuration: duration ?? theme.motion.overlay,
      exitDuration: duration ?? theme.metrics.modal.exitFadeDuration,
      initialScale: theme.metrics.modal.initialScale,
      style: style,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierColor: theme.colors.barrier,
    ),
  );
}

/// Convenience API that constructs the correctly paired route and [CharcoalDialog] surface.
///
/// ```dart
/// final saved = await showCharcoalModal<bool>(
///   context: context,
///   title: 'Discard changes',
///   child: const Text('Your edits will be lost.'),
///   actions: [
///     CharcoalButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard')),
///   ],
/// );
/// ```
Future<T?> showCharcoalModal<T>({
  required BuildContext context,
  required Widget child,
  List<Widget> actions = const <Widget>[],
  bool barrierDismissible = true,
  Widget? closeIcon,
  Duration? duration,
  double? maxWidth,
  CharcoalDialogSize size = CharcoalDialogSize.medium,
  CharcoalModalStyle style = CharcoalModalStyle.center,
  String? title,
  bool useRootNavigator = true,
}) => showCharcoalDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  duration: duration,
  style: style,
  useRootNavigator: useRootNavigator,
  builder: (dialogContext) => CharcoalDialog(
    actions: actions,
    closeIcon: closeIcon,
    maxWidth: maxWidth,
    onDismiss: barrierDismissible ? () => Navigator.of(dialogContext).maybePop() : null,
    showCloseButton: barrierDismissible,
    size: size,
    style: style,
    title: title,
    child: child,
  ),
);

/// The route behind [showCharcoalDialog]: Material's `DialogRoute` with Charcoal's entrance.
final class CharcoalDialogRoute<T> extends DialogRoute<T> {
  /// Creates a route that shows [builder]'s page.
  CharcoalDialogRoute({
    required super.context,
    required WidgetBuilder builder,
    required this.enterDuration,
    required this.exitDuration,
    required this.initialScale,
    required this.style,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.settings,
    super.themes,
  }) : super(
         useSafeArea: false,
         builder: (context) => _DismissShortcut(
           barrierDismissible: barrierDismissible,
           child: Builder(builder: builder),
         ),
       );

  /// Duration of the entrance.
  final Duration enterDuration;

  /// Duration of the exit fade.
  final Duration exitDuration;

  /// Scale a centred dialog enters from.
  final double initialScale;

  /// Centred card or bottom sheet.
  final CharcoalModalStyle style;

  @override
  Duration get transitionDuration => enterDuration;

  @override
  Duration get reverseTransitionDuration => exitDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    final fade = FadeTransition(opacity: curved, child: child);
    if (MediaQuery.disableAnimationsOf(context)) return fade;
    return switch (style) {
      CharcoalModalStyle.center => FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: initialScale, end: 1).animate(curved),
          child: child,
        ),
      ),
      CharcoalModalStyle.bottomSheet => FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: child,
        ),
      ),
    };
  }
}

class _DismissShortcut extends StatelessWidget {
  const _DismissShortcut({required this.barrierDismissible, required this.child});

  final bool barrierDismissible;
  final Widget child;

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (_) {
            if (barrierDismissible) Navigator.of(context).maybePop();
            return null;
          },
        ),
      },
      child: child,
    ),
  );
}
