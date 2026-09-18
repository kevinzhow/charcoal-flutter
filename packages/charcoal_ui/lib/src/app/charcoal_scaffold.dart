import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../components/navigation_bar.dart';
import '../theme/charcoal_theme.dart';

/// Coordinates a page's navigation, content, system insets, and keyboard.
///
/// The background always fills the window, including system-bar regions. By
/// default interactive content stays within the safe area. Set [bodySafeArea]
/// to false for full-bleed content, and apply [SafeArea] to its controls.
/// [navigationBar] and [bottomBar] keep their own safe areas in either mode.
/// Scrolling bodies receive a [ScrollNotificationObserver] for selection
/// overlays and caret visibility. The host owns its system UI display mode.
final class CharcoalScaffold extends StatelessWidget {
  /// Creates a page with optional navigation and bottom controls.
  const CharcoalScaffold({
    required this.body,
    this.navigationBar,
    this.bottomBar,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.bodySafeArea = true,
    this.extendBodyBehindNavigationBar = false,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  /// The page content, normally a scrollable on small screens.
  final Widget body;

  /// The page navigation, including its preferred content height.
  final PreferredSizeWidget? navigationBar;

  /// The controls placed below the body and above the keyboard or bottom inset.
  final Widget? bottomBar;

  /// The full-window background, including space behind system bars.
  final Color? backgroundColor;

  /// The system-bar appearance override for this page.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether the body avoids system intrusions automatically.
  final bool bodySafeArea;

  /// Whether the body paints behind the navigation bar.
  ///
  /// The body's [MediaQuery.padding] exposes the covered top extent so a
  /// scrolling body can keep its first item clear of navigation controls.
  final bool extendBodyBehindNavigationBar;

  /// Whether the page shrinks above the software keyboard.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final media = MediaQuery.of(context);
    final background = backgroundColor ?? theme.colors.backgroundDefault;
    final darkBackground = background.computeLuminance() < 0.179;
    final style =
        systemOverlayStyle ??
        (darkBackground ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
          statusBarColor: const Color(0x00000000),
          systemNavigationBarColor: const Color(0x00000000),
          systemNavigationBarDividerColor: const Color(0x00000000),
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
        );
    final keyboard = resizeToAvoidBottomInset ? media.viewInsets.bottom : 0.0;
    final remaining = media.copyWith(
      viewInsets: resizeToAvoidBottomInset
          ? media.viewInsets.copyWith(bottom: 0)
          : media.viewInsets,
      // A keyboard consumes the bottom safe area; do not reserve it twice.
      padding: media.padding.copyWith(bottom: math.max(0, media.padding.bottom - keyboard)),
    );
    final barHeight = navigationBar is CharcoalNavigationBar
        ? (navigationBar! as CharcoalNavigationBar).heightFor(context)
        : navigationBar?.preferredSize.height ?? 0;
    final topExtent = navigationBar == null ? 0.0 : media.padding.top + barHeight;
    Widget content = body;
    if (bodySafeArea) {
      content = SafeArea(
        top: navigationBar == null,
        bottom: bottomBar == null,
        child: content,
      );
    }
    final bodyMedia = remaining.removePadding(
      removeTop: navigationBar != null,
      removeBottom: bottomBar != null,
    );
    content = MediaQuery(
      data: extendBodyBehindNavigationBar && navigationBar != null
          ? bodyMedia.copyWith(padding: bodyMedia.padding.copyWith(top: topExtent))
          : bodyMedia,
      child: content,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: ColoredBox(
        color: background,
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboard),
          child: MediaQuery(
            data: remaining,
            child: ScrollNotificationObserver(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          top: extendBodyBehindNavigationBar ? 0 : topExtent,
                          child: content,
                        ),
                        if (navigationBar != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: SafeArea(
                              bottom: false,
                              child: SizedBox(height: barHeight, child: navigationBar),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (bottomBar != null) SafeArea(top: false, child: bottomBar!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Configures the host's system UI display mode before starting an application.
///
/// Edge-to-edge keeps system bars visible while allowing backgrounds behind
/// them. Immersive modes request hidden bars where supported by the host;
/// Android SDK restrictions can override that request. Appearance belongs to
/// each [CharcoalScaffold], independently of this application-wide setting.
Future<void> configureCharcoalSystemUi({SystemUiMode mode = SystemUiMode.edgeToEdge}) =>
    SystemChrome.setEnabledSystemUIMode(mode);
