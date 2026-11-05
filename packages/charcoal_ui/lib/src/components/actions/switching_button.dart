import 'package:flutter/widgets.dart';

/// Shows one of two registered buttons without changing the layout size.
///
/// The Flutter counterpart of Charcoal iOS's `CharcoalSwitchingButton`. Both children stay laid
/// out, so the widget reserves the larger of the two geometries; [isOn] selects which one is
/// painted, focusable, animated and exposed to semantics. Each visible button owns its own action
/// semantics; this layout wrapper adds no separate toggle node.
final class CharcoalSwitchingButton extends StatelessWidget {
  /// Creates a switching button from the two states' buttons.
  const CharcoalSwitchingButton({
    required this.isOn,
    required this.offButton,
    required this.onButton,
    super.key,
  });

  /// Whether [onButton] is the visible branch.
  final bool isOn;

  /// The button shown while [isOn] is false.
  final Widget offButton;

  /// The button shown while [isOn] is true.
  final Widget onButton;

  @override
  Widget build(BuildContext context) {
    Widget branch({required bool visible, required Widget child}) => ExcludeFocus(
      excluding: !visible,
      child: ExcludeSemantics(
        excluding: !visible,
        child: TickerMode(enabled: visible, child: child),
      ),
    );

    return IndexedStack(
      alignment: Alignment.center,
      index: isOn ? 0 : 1,
      children: <Widget>[
        branch(visible: isOn, child: onButton),
        branch(visible: !isOn, child: offButton),
      ],
    );
  }
}
