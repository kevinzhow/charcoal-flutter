import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';

/// A collapsible group for rarely used content, such as the optional fields of a form under
/// "More options".
///
/// Collapsed it is one line: a chevron, the [title] and the [summary] of what the hidden content
/// is set to (for example "Visibility: server only · Enabled after creation"), so the reader
/// knows the defaults without opening it. Pressing the line expands it to show [child] below the
/// title; the summary hides while the content itself is visible. The line is a button announced
/// as expanded or collapsed. Opening and closing animate the height unless the platform asks for
/// reduced motion. While collapsed the content keeps its state but cannot take focus.
///
/// ```dart
/// CharcoalDisclosure(
///   title: 'More options',
///   summary: 'Visibility: server only · Enabled after creation · No description',
///   child: Column(children: [visibilityField, descriptionField, enabledCheckbox]),
/// )
/// ```
final class CharcoalDisclosure extends StatefulWidget {
  /// Creates a disclosure titled [title] around [child].
  const CharcoalDisclosure({
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.summary,
    super.key,
  });

  /// The line that opens and closes the content, e.g. "More options".
  final String title;

  /// The hidden content.
  final Widget child;

  /// Whether the content is shown when the disclosure first builds.
  final bool initiallyExpanded;

  /// One line after the title, shown while collapsed, that summarises the hidden content.
  final String? summary;

  @override
  State<CharcoalDisclosure> createState() => _CharcoalDisclosureState();
}

final class _CharcoalDisclosureState extends State<CharcoalDisclosure>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: _expanded ? 1 : 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    final theme = CharcoalTheme.of(context);
    setState(() => _expanded = !_expanded);
    _controller.duration = theme.duration(context, theme.motion.standard);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final space = theme.space;
    final summary = widget.summary;
    final header = MergeSemantics(
      child: CharcoalClickable(
        expanded: _expanded,
        onPressed: _toggle,
        builder: (context, states) {
          final active =
              states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed);
          final color = active ? colors.text : colors.textSecondary;
          final chevron = theme.sizes.iconSm;
          // A long title wraps; the summary takes what is left of the line and ends with an
          // ellipsis.
          return LayoutBuilder(
            builder: (context, constraints) => Row(
              children: <Widget>[
                CharcoalIcon(
                  _expanded ? CharcoalIcons16.chevronDown : CharcoalIcons16.chevronRight,
                  size: chevron,
                  color: color,
                  matchTextDirection: !_expanded,
                ),
                SizedBox(width: space.xs),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth - chevron - space.xs,
                  ),
                  child: Text(
                    widget.title,
                    style: theme.style(CharcoalTextRole.bodyBold, color: color),
                  ),
                ),
                if (summary != null && !_expanded)
                  Flexible(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: space.sm),
                      child: Text(
                        summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.style(CharcoalTextRole.body, color: colors.textTertiary),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
    final body = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ClipRect(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          heightFactor: theme.motion.curve.transform(_controller.value),
          child: Visibility(visible: !_controller.isDismissed, maintainState: true, child: child!),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: space.md),
        child: widget.child,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[header, body],
    );
  }
}
