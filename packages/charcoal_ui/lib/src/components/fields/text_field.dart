import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../text/selection_toolbar.dart';
import '../text/text_editing.dart';
import 'field_ring.dart';
import 'field_support.dart';

/// A single-line Charcoal text field built on [EditableText].
///
/// The field paints its own fill, an external focus ring (it never moves the box) and a
/// grapheme-based counter. [invalid], [required] and an actionable [assistiveText] are reflected
/// in the field's semantics. Selection handles, magnifier and the editing menu come from
/// [CharcoalEditableText].
final class CharcoalTextField extends StatefulWidget {
  /// Creates a text field.
  const CharcoalTextField({
    this.assistiveText,
    this.autofocus = false,
    this.autofillHints,
    this.contextMenuBuilder = buildCharcoalTextContextMenu,
    this.enableInteractiveSelection = true,
    this.inputFormatters,
    this.scrollPadding,
    this.undoController,
    this.controller,
    this.disabled = false,
    this.focusNode,
    this.invalid = false,
    this.keyboardType,
    this.label = '',
    this.maxLength,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.prefix,
    this.readOnly = false,
    this.required = false,
    this.requiredText = '*Required',
    this.showCount = false,
    this.showLabel = false,
    this.subLabel,
    this.suffix,
    this.textInputAction,
    super.key,
  }) : assert(maxLength == null || maxLength > 0);

  /// Helper text below the field; announced as the hint when [invalid].
  final String? assistiveText;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// The platform autofill hints for this input.
  final Iterable<String>? autofillHints;

  /// The editing menu builder, or `null` to disable the menu.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Whether touch and pointer gestures may change the selection.
  final bool enableInteractiveSelection;

  /// The input transformations applied before the length limit.
  final List<TextInputFormatter>? inputFormatters;

  /// The space kept around the caret when scrolling it into view.
  final EdgeInsets? scrollPadding;

  /// The optional controller for editing undo and redo.
  final UndoHistoryController? undoController;

  /// The text; the field owns one when null.
  final TextEditingController? controller;

  /// Whether the field ignores input, focus and pointer.
  final bool disabled;

  /// The focus node; the field owns one when null.
  final FocusNode? focusNode;

  /// Whether the content is invalid: shows the negative ring and assistive colour.
  final bool invalid;

  /// The keyboard type.
  final TextInputType? keyboardType;

  /// The accessible label, also shown above the field when [showLabel].
  final String label;

  /// Maximum length in grapheme-compatible units (see `LengthLimitingTextInputFormatter`).
  final int? maxLength;

  /// Whether to mask the text.
  final bool obscureText;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Text shown while the field is empty.
  final String? placeholder;

  /// Leading affordance, such as an icon.
  final Widget? prefix;

  /// Whether the text is selectable but not editable.
  final bool readOnly;

  /// Whether the field is required.
  final bool required;

  /// The required marker text; pass the localized string.
  final String requiredText;

  /// Whether to show the character counter inside the field.
  final bool showCount;

  /// Whether to show the label above the field.
  final bool showLabel;

  /// Trailing label metadata.
  final Widget? subLabel;

  /// Trailing affordance, such as a clear button.
  final Widget? suffix;

  /// The keyboard action button.
  final TextInputAction? textInputAction;

  @override
  State<CharcoalTextField> createState() => _CharcoalTextFieldState();
}

final class _CharcoalTextFieldState extends State<CharcoalTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final WidgetStatesController _statesController = WidgetStatesController();

  bool get _ownsController => widget.controller == null;
  bool get _ownsFocusNode => widget.focusNode == null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
    _syncDisabledState();
  }

  @override
  void didUpdateWidget(CharcoalTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleTextChanged);
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleTextChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChanged);
    }
    _syncDisabledState();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    _statesController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    _statesController.update(WidgetState.focused, _focusNode.hasFocus);
    if (mounted) setState(() {});
  }

  void _syncDisabledState() {
    _statesController.update(WidgetState.disabled, widget.disabled);
    if (widget.disabled && _focusNode.hasFocus) _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.textField;
    final focused = _statesController.value.contains(WidgetState.focused);
    final duration = theme.duration(context, theme.motion.standard);
    final ringColor = widget.invalid ? colors.borderNegative : colors.focusRing;
    final textStyle = theme.style(CharcoalTextRole.size14, color: colors.textSecondary);
    final iconTheme = IconThemeData(color: colors.textSecondary, size: metrics.iconSize);

    final editable = CharcoalEditableText(
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints,
      contextMenuBuilder: widget.contextMenuBuilder,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      scrollPadding: widget.scrollPadding,
      undoController: widget.undoController,
      controller: _controller,
      focusNode: _focusNode,
      inputFormatters: <TextInputFormatter>[
        ...?widget.inputFormatters,
        if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly || widget.disabled,
      selectionColor: focused ? colors.focusRing : null,
      style: textStyle,
      textInputAction: widget.textInputAction,
    );

    final input = MouseRegion(
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : _focusNode.requestFocus,
        child: CharcoalFieldRing(
          color: ringColor,
          duration: duration,
          radius: theme.radius.sm,
          visible: focused || widget.invalid,
          child: AnimatedContainer(
            duration: duration,
            curve: theme.motion.curve,
            padding: EdgeInsets.symmetric(
              horizontal: theme.space.sm,
              vertical: metrics.verticalPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.sm),
              color: colors.fillSecondary,
            ),
            child: Row(
              children: <Widget>[
                if (widget.prefix != null) ...<Widget>[
                  IconTheme(data: iconTheme, child: widget.prefix!),
                  SizedBox(width: metrics.contentGap),
                ],
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      if (_controller.text.isEmpty && widget.placeholder != null)
                        IgnorePointer(
                          child: Text(
                            widget.placeholder!,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: textStyle.copyWith(color: colors.textPlaceholder),
                          ),
                        ),
                      editable,
                    ],
                  ),
                ),
                if (widget.suffix != null || widget.showCount) ...<Widget>[
                  SizedBox(width: metrics.contentGap),
                  if (widget.suffix != null) IconTheme(data: iconTheme, child: widget.suffix!),
                  if (widget.suffix != null && widget.showCount)
                    SizedBox(width: metrics.contentGap),
                  if (widget.showCount)
                    Text(
                      charcoalFieldCountText(_controller.text, widget.maxLength),
                      style: textStyle.copyWith(
                        color: widget.invalid ? colors.textNegative : colors.textTertiary,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    final assistiveText = widget.assistiveText;
    final errorHint = widget.invalid && assistiveText != null && assistiveText.isNotEmpty
        ? assistiveText
        : null;
    return Semantics(
      enabled: !widget.disabled,
      hint: errorHint,
      isRequired: widget.required ? true : null,
      label: widget.label.isEmpty ? null : widget.label,
      readOnly: widget.readOnly,
      textField: true,
      validationResult: widget.invalid
          ? SemanticsValidationResult.invalid
          : SemanticsValidationResult.none,
      child: AnimatedOpacity(
        curve: theme.motion.curve,
        duration: duration,
        opacity: widget.disabled ? theme.metrics.clickable.disabledOpacity : 1,
        child: CharcoalFieldFrame(
          assistiveText: assistiveText,
          invalid: widget.invalid,
          label: widget.label,
          required: widget.required,
          requiredText: widget.requiredText,
          showLabel: widget.showLabel,
          subLabel: widget.subLabel,
          field: ExcludeFocus(
            excluding: widget.disabled,
            child: IgnorePointer(ignoring: widget.disabled, child: input),
          ),
        ),
      ),
    );
  }
}
