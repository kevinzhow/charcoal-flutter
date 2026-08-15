import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';

enum CharcoalPageTransitionAxis { horizontal, vertical }

/// An opaque shared-axis route transition for Charcoal applications.
///
/// The route never fades through a transparent frame and disables route
/// snapshotting, avoiding the bright flash that can occur on desktop surfaces.
final class CharcoalPageRoute<T> extends PageRouteBuilder<T> {
  CharcoalPageRoute({
    required WidgetBuilder builder,
    CharcoalPageTransitionAxis axis = CharcoalPageTransitionAxis.horizontal,
    super.fullscreenDialog = false,
    super.maintainState = true,
    super.requestFocus,
    super.reverseTransitionDuration = CharcoalMotion.routeReverse,
    super.settings,
    super.transitionDuration = CharcoalMotion.routeForward,
  }) : super(
         allowSnapshotting: false,
         pageBuilder: (context, animation, secondaryAnimation) => builder(context),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           if (MediaQuery.disableAnimationsOf(context)) {
             return child;
           }
           final textDirection = Directionality.of(context);
           final direction = textDirection == TextDirection.rtl ? -1.0 : 1.0;
           final incomingOffset = switch (axis) {
             CharcoalPageTransitionAxis.horizontal => Offset(0.035 * direction, 0),
             CharcoalPageTransitionAxis.vertical => const Offset(0, 0.025),
           };
           final outgoingOffset = switch (axis) {
             CharcoalPageTransitionAxis.horizontal => Offset(-0.012 * direction, 0),
             CharcoalPageTransitionAxis.vertical => const Offset(0, -0.008),
           };
           final incoming = Tween<Offset>(
             begin: incomingOffset,
             end: Offset.zero,
           ).chain(CurveTween(curve: CharcoalMotion.emphasizedCurve)).animate(animation);
           final outgoing =
               Tween<Offset>(
                     begin: Offset.zero,
                     end: outgoingOffset,
                   )
                   .chain(CurveTween(curve: CharcoalMotion.standardCurve))
                   .animate(
                     secondaryAnimation,
                   );
           return ClipRect(
             child: SlideTransition(
               position: outgoing,
               child: SlideTransition(position: incoming, child: child),
             ),
           );
         },
       );
}
