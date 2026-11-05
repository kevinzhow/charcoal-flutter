import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../components/actions/icon_button.dart';
import '../components/feedback/progress_ring.dart';
import '../components/text/charcoal_text.dart';
import '../components/text/text_tone.dart';
import '../foundation/charcoal_clickable.dart';
import 'admin_shell.dart';

/// How wide the content column of a [CharcoalPage] may grow.
enum CharcoalPageWidth {
  /// `sizes.contentMaxWidth`, the default for lists and detail pages.
  standard,

  /// `sizes.contentWideMaxWidth`, for tables and dense forms.
  wide,

  /// No limit: the content fills the page.
  full,
}

/// The chrome and content column of one admin page.
///
/// Every page of an admin app, a destination root or a pushed detail, is a `CharcoalPage`, so
/// each owns its title, back affordance and contextual actions; the surrounding
/// [CharcoalAdminShell] owns only the navigation chrome.
///
/// In the standard layout the page starts with an optional back link ([onBack], [backLabel]), the
/// [title] and [subtitle], and the [actions] at the far end. In the compact layout (the shell shows
/// its bottom bar) the title moves into a top bar with a back button and [compactTrailing], and the
/// [actions] wrap above the content. Which layout applies follows the enclosing shell unless
/// [compact] says otherwise, and a page outside a shell goes compact below
/// `sizes.sidebarBreakpoint`.
///
/// The content column is centred, limited to [maxWidth], and inset by the page insets of the
/// layout; the page scrolls unless [scrollable] is false, for content that scrolls itself.
/// [header] is pinned between the title block and [child] (a tab strip, say). A [banner] replaces
/// [child] altogether, for a page that cannot be used yet (missing credentials). [busy] covers the
/// page with a dimmed, blocking progress ring.
///
/// ```dart
/// CharcoalPage(
///   title: 'Users',
///   subtitle: 'Accounts and quotas',
///   actions: [CharcoalButton(onPressed: invite, child: const Text('Invite'))],
///   child: usersList,
/// )
/// ```
final class CharcoalPage extends StatelessWidget {
  /// Creates a page.
  const CharcoalPage({
    required this.title,
    required this.child,
    this.actions = const <Widget>[],
    this.backLabel = 'Back',
    this.banner,
    this.busy = false,
    this.busyLabel = 'Loading',
    this.compact,
    this.compactTrailing,
    this.header,
    this.maxWidth = CharcoalPageWidth.standard,
    this.onBack,
    this.scrollable = true,
    this.showBack,
    this.subtitle,
    super.key,
  });

  /// The page title.
  final String title;

  /// The page content.
  final Widget child;

  /// Buttons for this page's own actions, never navigation.
  final List<Widget> actions;

  /// The label of the back link and the semantic label of the compact back button.
  final String backLabel;

  /// Shown in place of [child] when non-null, e.g. a `CharcoalBanner` asking for credentials.
  final Widget? banner;

  /// Whether a blocking progress ring covers the page.
  final bool busy;

  /// What assistive technology announces while [busy].
  final String busyLabel;

  /// Whether to use the compact layout; follows the enclosing `CharcoalAdminShell`, or the width
  /// of the page, when null.
  final bool? compact;

  /// A widget at the end of the compact top bar, shown on a root page only (when there is no back
  /// button), e.g. a `CharcoalChip` naming the active region.
  final Widget? compactTrailing;

  /// Content pinned between the title block and [child].
  final Widget? header;

  /// How wide the content column may grow.
  final CharcoalPageWidth maxWidth;

  /// Replaces the default pop of the back affordance, for a page that reports a result back.
  final VoidCallback? onBack;

  /// Whether the page scrolls; pages that scroll their own body set it to false.
  final bool scrollable;

  /// Whether to show the back affordance; defaults to whether the page's navigator can pop.
  final bool? showBack;

  /// The line under the title.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final explicit = compact ?? CharcoalAdminLayout.compactOf(context);
    if (explicit != null) return _build(context, compact: explicit);
    final breakpoint = CharcoalTheme.of(context).sizes.sidebarBreakpoint;
    return LayoutBuilder(
      builder: (context, constraints) =>
          _build(context, compact: constraints.maxWidth < breakpoint),
    );
  }

  Widget _build(BuildContext context, {required bool compact}) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final sizes = theme.sizes;
    // `ModalRoute.of` subscribes to the route, so the back affordance follows the stack.
    final canPop =
        showBack ?? ModalRoute.of(context)?.canPop ?? Navigator.maybeOf(context)?.canPop() ?? false;
    void back() => onBack != null ? onBack!() : Navigator.of(context).maybePop();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // On compact the title lives in the top bar, so the column starts at the actions.
        if (!compact) ...<Widget>[
          _StandardHeader(
            title: title,
            subtitle: subtitle,
            actions: actions,
            backLabel: canPop ? backLabel : null,
            onBack: back,
          ),
          SizedBox(height: space.xl),
        ] else if (actions.isNotEmpty) ...<Widget>[
          Wrap(spacing: space.sm, runSpacing: space.sm, children: actions),
          SizedBox(height: space.xl),
        ],
        if (header != null) ...<Widget>[header!, SizedBox(height: space.xl)],
        banner ?? child,
      ],
    );

    final limit = switch (maxWidth) {
      CharcoalPageWidth.standard => sizes.contentMaxWidth,
      CharcoalPageWidth.wide => sizes.contentWideMaxWidth,
      CharcoalPageWidth.full => double.infinity,
    };
    final padded = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: limit),
        child: Padding(
          padding: compact
              ? EdgeInsets.fromLTRB(space.lg, space.lg, space.lg, space.xl)
              : EdgeInsets.fromLTRB(
                  sizes.pageInsetWide,
                  space.xxl,
                  sizes.pageInsetWide,
                  space.xxxl,
                ),
          child: content,
        ),
      ),
    );

    return _BusyOverlay(
      visible: busy,
      label: busyLabel,
      child: ColoredBox(
        color: theme.colors.background,
        child: Column(
          children: <Widget>[
            if (compact)
              _TopBar(
                title: title,
                leading: canPop
                    ? CharcoalIconButton(
                        icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
                        semanticLabel: backLabel,
                        onPressed: back,
                      )
                    : null,
                trailing: canPop ? null : compactTrailing,
              ),
            Expanded(
              child: scrollable ? SingleChildScrollView(child: padded) : padded,
            ),
          ],
        ),
      ),
    );
  }
}

/// The standard-width header: back link, page title, subtitle, actions.
class _StandardHeader extends StatelessWidget {
  const _StandardHeader({
    required this.title,
    required this.actions,
    required this.onBack,
    this.backLabel,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final String? backLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).space;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (backLabel != null)
                Padding(
                  padding: EdgeInsets.only(bottom: space.sm),
                  child: _BackLink(label: backLabel!, onPressed: onBack),
                ),
              Semantics(
                header: true,
                child: CharcoalText(title, role: CharcoalTextRole.pageTitle),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: space.xs),
                  child: CharcoalText(
                    subtitle!,
                    tone: CharcoalTextTone.tertiary,
                  ),
                ),
            ],
          ),
        ),
        if (actions.isNotEmpty) ...<Widget>[
          SizedBox(width: space.lg),
          Wrap(
            spacing: space.sm,
            runSpacing: space.sm,
            alignment: WrapAlignment.end,
            children: actions,
          ),
        ],
      ],
    );
  }
}

/// The compact layout's top bar: optional leading, centred title, optional trailing.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, this.leading, this.trailing});

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      height: theme.sizes.controlLg,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.sizes.controlLg),
            child: Semantics(
              header: true,
              child: CharcoalText(
                title,
                role: CharcoalTextRole.sectionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (leading != null) PositionedDirectional(start: theme.space.xs, child: leading!),
          if (trailing != null) PositionedDirectional(end: theme.space.xs, child: trailing!),
        ],
      ),
    );
  }
}

/// A back affordance whose hover and press states are component-owned.
class _BackLink extends StatelessWidget {
  const _BackLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: label,
      builder: (context, states) {
        final active = states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered);
        final color = active ? theme.colors.text : theme.colors.textSecondary;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.chevronLeft,
              size: theme.sizes.iconSm,
              color: color,
            ),
            SizedBox(width: theme.space.xs),
            Text(
              label,
              style: theme.style(CharcoalTextRole.bodyBold, color: color),
            ),
          ],
        );
      },
    );
  }
}

/// Dims and blocks [child] with a progress ring while [visible].
class _BusyOverlay extends StatelessWidget {
  const _BusyOverlay({
    required this.visible,
    required this.label,
    required this.child,
  });

  final bool visible;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Stack(
      children: <Widget>[
        ExcludeFocus(excluding: visible, child: child),
        if (visible)
          Positioned.fill(
            child: ColoredBox(
              color: theme.colors.scrim,
              child: Center(child: CharcoalProgressRing(semanticLabel: label)),
            ),
          ),
      ],
    );
  }
}
