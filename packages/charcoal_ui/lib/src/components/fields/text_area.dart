import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/interaction_state.dart';
import '../text/selection_toolbar.dart';
import '../text/text_editing.dart';
import 'field_ring.dart';
import 'field_support.dart';

/// A fixed-row, multiline Charcoal text input.
///
/// The box height follows `lineHeight x rows + chrome` under the ambient text scale, plus one
/// line while the counter is shown. [invalid], [required] and an actionable [assistiveText] are
/// reflected in the area's semantics.
final class CharcoalTextArea extends StatefulWidget {
  /// Creates a text area of [rows] lines; null uses `metrics.textArea.defaultRows`.
  const CharcoalTextArea({
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
    this.label = '',
    this.maxLength,
    this.onChanged,
    this.placeholder,
    this.readOnly = false,
    this.required = false,
    this.requiredText = '*Required',
    this.rows,
    this.showCount = false,
    this.showLabel = false,
    this.subLabel,
    super.key,
  }) : assert(maxLength == null || maxLength > 0),
       assert(rows == null || rows > 0);

  /// Helper text below the area; announced as the hint when [invalid].
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

  /// The text; the area owns one when null.
  final TextEditingController? controller;

  /// Whether the area ignores input, focus and pointer.
  final bool disabled;

  /// The focus node; the area owns one when null.
  final FocusNode? focusNode;

  /// Whether the content is invalid.
  final bool invalid;

  /// The accessible label, also shown above the area when [showLabel].
  final String label;

  /// Maximum length.
  final int? maxLength;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Text shown while the area is empty.
  final String? placeholder;

  /// Whether the text is selectable but not editable.
  final bool readOnly;

  /// Whether the area is required.
  final bool required;

  /// The required marker text; pass the localized string.
  final String requiredText;

  /// Number of visible lines; null uses `metrics.textArea.defaultRows`.
  final int? rows;

  /// Whether to show the character counter inside the area.
  final bool showCount;

  /// Whether to show the label above the area.
  final bool showLabel;

  /// Trailing label metadata.
  final Widget? subLabel;

  @override
  State<CharcoalTextArea> createState() => _CharcoalTextAreaState();
}

final class _CharcoalTextAreaState extends State<CharcoalTextArea> {
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
  void didUpdateWidget(CharcoalTextArea oldWidget) {
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

  void _updateState(WidgetState state, bool value) {
    _statesController.update(state, value);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.textArea;
    final rows = widget.rows ?? metrics.defaultRows;
    final states = Set<WidgetState>.unmodifiable(_statesController.value);
    final focused = states.contains(WidgetState.focused);
    final duration = theme.duration(context, theme.motion.standard);
    final ringColor = widget.invalid ? colors.borderNegative : colors.focusRing;
    final textStyle = theme.style(CharcoalTextRole.size14, color: colors.textSecondary);
    final scaledLineHeight = MediaQuery.textScalerOf(context).scale(metrics.lineHeight);
    final textHeight = scaledLineHeight * rows;
    final containerHeight =
        scaledLineHeight * (rows + (widget.showCount ? 1 : 0)) + metrics.verticalChrome;
    final topInset = theme.space.sm;
    final background = resolveCharcoalStateColor(
      states,
      normal: colors.fillSecondary,
      hovered: colors.fillSecondaryHover,
      pressed: colors.fillSecondaryPress,
    );

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
      keyboardType: TextInputType.multiline,
      maxLines: rows,
      minLines: rows,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly || widget.disabled,
      selectionColor: focused ? colors.focusRing : null,
      style: textStyle,
      textInputAction: TextInputAction.newline,
    );

    final input = MouseRegion(
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.text,
      onEnter: (_) => _updateState(WidgetState.hovered, !widget.disabled),
      onExit: (_) => _updateState(WidgetState.hovered, false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : _focusNode.requestFocus,
        onTapCancel: widget.disabled ? null : () => _updateState(WidgetState.pressed, false),
        onTapDown: widget.disabled ? null : (_) => _updateState(WidgetState.pressed, true),
        onTapUp: widget.disabled ? null : (_) => _updateState(WidgetState.pressed, false),
        child: CharcoalFieldRing(
          color: ringColor,
          duration: duration,
          radius: theme.radius.sm,
          visible: focused || widget.invalid,
          child: AnimatedContainer(
            duration: duration,
            curve: theme.motion.curve,
            height: containerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.sm),
              color: background,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: metrics.horizontalInset,
                  right: metrics.horizontalInset,
                  top: topInset,
                  height: textHeight,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      if (_controller.text.isEmpty && widget.placeholder != null)
                        IgnorePointer(
                          child: Text(
                            widget.placeholder!,
                            maxLines: rows,
                            overflow: TextOverflow.clip,
                            style: textStyle.copyWith(color: colors.textPlaceholder),
                          ),
                        ),
                      editable,
                    ],
                  ),
                ),
                if (widget.showCount)
                  Positioned(
                    right: topInset,
                    bottom: metrics.counterBottomInset,
                    child: Text(
                      charcoalFieldCountText(_controller.text, widget.maxLength),
                      style: textStyle.copyWith(color: colors.textTertiary),
                    ),
                  ),
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
      multiline: true,
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
