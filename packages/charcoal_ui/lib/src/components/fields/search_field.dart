import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import 'text_field.dart';

/// A text field with a search icon and a clear affordance.
///
/// The clear button appears while there is text and [onClear] is set; it calls [onClear] (the
/// caller decides whether that also empties the controller).
class CharcoalSearchField extends StatefulWidget {
  /// A search field over [controller].
  const CharcoalSearchField({
    required this.controller,
    this.autofocus = false,
    this.clearLabel = 'Clear',
    this.disabled = false,
    this.focusNode,
    this.icon = CharcoalIcons.search,
    this.label = '',
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.placeholder,
    super.key,
  });

  /// The query text.
  final TextEditingController controller;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Spoken label of the clear button; pass the localized string.
  final String clearLabel;

  /// Whether the field ignores input.
  final bool disabled;

  /// The focus node.
  final FocusNode? focusNode;

  /// The leading icon.
  final CharcoalIconData icon;

  /// The accessible label.
  final String label;

  /// Called when the query changes.
  final ValueChanged<String>? onChanged;

  /// Called by the clear button; null hides the button.
  final VoidCallback? onClear;

  /// Called when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Text shown while the query is empty.
  final String? placeholder;

  @override
  State<CharcoalSearchField> createState() => _CharcoalSearchFieldState();
}

class _CharcoalSearchFieldState extends State<CharcoalSearchField> {
  @override
  void initState() {
    super.initState();
    // The clear affordance depends on the text, so listen rather than relying on every caller to
    // rebuild from onChanged.
    widget.controller.addListener(_onText);
  }

  @override
  void didUpdateWidget(CharcoalSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onText);
      widget.controller.addListener(_onText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onText);
    super.dispose();
  }

  void _onText() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final iconSize = theme.metrics.textField.iconSize;
    final showClear = widget.onClear != null && widget.controller.text.isNotEmpty;
    return CharcoalTextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      disabled: widget.disabled,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.text,
      label: widget.label,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      placeholder: widget.placeholder,
      prefix: CharcoalIcon(widget.icon, size: iconSize),
      suffix: showClear
          ? CharcoalClickable(
              onPressed: widget.onClear,
              semanticLabel: widget.clearLabel,
              builder: (context, states) => CharcoalIcon(
                CharcoalIcons.x,
                size: iconSize,
                color: states.contains(WidgetState.pressed)
                    ? theme.colors.iconTertiaryPress
                    : states.contains(WidgetState.hovered)
                    ? theme.colors.iconTertiaryHover
                    : theme.colors.iconTertiary,
              ),
            )
          : null,
      textInputAction: TextInputAction.search,
    );
  }
}
