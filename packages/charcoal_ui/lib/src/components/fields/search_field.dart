import 'dart:async';

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../text/text_editing.dart';
import 'text_field.dart';

/// A text field with a search icon and a clear affordance.
///
/// The clear button appears while there is text and [onClear] is set. It is disabled during
/// composition. The caller decides whether [onClear] empties the controller.
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

  /// Reports user edits after any active input method composition finishes.
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
  late TextEditingValue _previousValue;
  int _queryRevision = 0;

  bool get _isComposing => charcoalIsComposing(widget.controller.value);

  bool get _canClear =>
      !widget.disabled &&
      widget.onClear != null &&
      widget.controller.text.isNotEmpty &&
      !_isComposing;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.controller.value;
    widget.controller.addListener(_onEditingValueChanged);
  }

  @override
  void didUpdateWidget(CharcoalSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onEditingValueChanged);
      _previousValue = widget.controller.value;
      _queryRevision++;
      widget.controller.addListener(_onEditingValueChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onEditingValueChanged);
    super.dispose();
  }

  void _onEditingValueChanged() {
    final controller = widget.controller;
    final previous = _previousValue;
    final next = controller.value;
    _previousValue = next;

    final wasComposing = charcoalIsComposing(previous);
    final isComposing = charcoalIsComposing(next);
    if (previous.text != next.text || wasComposing != isComposing) {
      _queryRevision++;
    }
    if (previous.text.isEmpty != next.text.isEmpty || wasComposing != isComposing) {
      setState(() {});
    }
    if (wasComposing && !isComposing && previous.text == next.text) {
      // Flutter reads back the text after notifying controller listeners. Let that finish
      // before calling onChanged, which may itself write to the controller.
      final revision = _queryRevision;
      scheduleMicrotask(() {
        if (mounted &&
            identical(controller, widget.controller) &&
            revision == _queryRevision &&
            controller.text == next.text &&
            !_isComposing) {
          widget.onChanged?.call(next.text);
        }
      });
    }
  }

  void _onQueryChanged(String query) {
    if (!_isComposing) widget.onChanged?.call(query);
  }

  void _clear() {
    // A pending tap can activate before the composing update rebuilds the button.
    if (_canClear) widget.onClear?.call();
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
      onChanged: _onQueryChanged,
      onSubmitted: widget.onSubmitted,
      placeholder: widget.placeholder,
      prefix: CharcoalIcon(widget.icon, size: iconSize),
      suffix: showClear
          ? TextFieldTapRegion(
              child: CharcoalClickable(
                onPressed: _canClear ? _clear : null,
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
              ),
            )
          : null,
      textInputAction: TextInputAction.search,
    );
  }
}
