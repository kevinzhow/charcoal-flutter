import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

final class ShowcaseDirectionalPageTransition extends StatelessWidget {
  const ShowcaseDirectionalPageTransition({
    super.key,
    required this.animation,
    required this.child,
    required this.direction,
  });

  final Animation<double> animation;
  final Widget child;
  final double direction;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (context, child) {
      final progress = CharcoalMotion.emphasizedCurve.transform(
        animation.value,
      );
      final exiting = animation.status == AnimationStatus.reverse;
      final distance = exiting ? -0.006 : 0.012;
      return FractionalTranslation(
        translation: Offset(direction * distance * (1 - progress), 0),
        child: child,
      );
    },
  );
}

final class ShowcasePageViewport extends StatelessWidget {
  const ShowcasePageViewport({
    required this.child,
    required this.compact,
    required this.controller,
    required this.page,
    super.key,
  });

  final Widget child;
  final bool compact;
  final ScrollController controller;
  final String page;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return RepaintBoundary(
      child: ColoredBox(
        color: theme.colors.backgroundSecondary,
        child: RawScrollbar(
          controller: controller,
          crossAxisMargin: compact ? 2 : 4,
          fadeDuration: CharcoalMotion.standard,
          interactive: !compact,
          radius: Radius.circular(theme.dimensions.radius.oval),
          thickness: compact ? 3 : 6,
          thumbColor: theme.colors.containerTertiaryDefault,
          child: SingleChildScrollView(
            key: ValueKey<String>('page-scroll-$page'),
            controller: controller,
            padding: compact
                ? const EdgeInsets.fromLTRB(16, 20, 16, 32)
                : const EdgeInsets.fromLTRB(32, 30, 32, 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
