import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'field_label.dart';

/// A fixed-row, multiline Charcoal V2 text input.
///
/// It intentionally shares the generated TextField recipe so single-line and
/// multiline fields cannot drift when foundation tokens are updated.
final class CharcoalTextArea extends StatefulWidget {
  const CharcoalTextArea({
    this.assistiveText,
    this.autofocus = false,
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
    this.rows = 4,
    this.showCount = false,
    this.showLabel = false,
    this.subLabel,
    super.key,
  }) : assert(maxLength == null || maxLength > 0),
       assert(rows > 0);

  final String? assistiveText;
  final bool autofocus;
  final TextEditingController? controller;
  final bool disabled;
  final FocusNode? focusNode;
  final bool invalid;
  final String label;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final bool readOnly;
  final bool required;
  final String requiredText;
  final int rows;
  final bool showCount;
  final bool showLabel;
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
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleTextChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChanged);
    }
    _syncDisabledState();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _statesController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChanged() {
    _statesController.update(WidgetState.focused, _focusNode.hasFocus);
    if (mounted) {
      setState(() {});
    }
  }

  void _syncDisabledState() {
    _statesController.update(WidgetState.disabled, widget.disabled);
    if (widget.disabled && _focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.textField;
    final states = Set<WidgetState>.unmodifiable(_statesController.value);
    final focused = states.contains(WidgetState.focused);
    final ringColor = widget.invalid ? tokens.invalidRingColor : tokens.focusRingColor;
    final textStyle = TextStyle(
      color: tokens.foregroundColor,
      fontFamily: theme.typography.fontFamily.sans,
      fontSize: tokens.fontSize,
      fontWeight: tokens.fontWeight,
      height: tokens.lineHeight / tokens.fontSize,
      leadingDistribution: TextLeadingDistribution.even,
    );
    final textHeight = tokens.lineHeight * widget.rows;
    final counterHeight = widget.showCount ? tokens.lineHeight + tokens.gap : 0;
    final containerHeight = textHeight + counterHeight + tokens.paddingHorizontal * 2;

    final editable = EditableText(
      autofocus: widget.autofocus,
      backgroundCursorColor: theme.colors.backgroundDefault,
      controller: _controller,
      cursorColor: theme.colors.containerPrimaryDefault,
      focusNode: _focusNode,
      inputFormatters: widget.maxLength == null
          ? null
          : <TextInputFormatter>[LengthLimitingTextInputFormatter(widget.maxLength)],
      keyboardAppearance: theme.brightness,
      keyboardType: TextInputType.multiline,
      maxLines: widget.rows,
      minLines: widget.rows,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly || widget.disabled,
      selectionColor: tokens.focusRingColor,
      style: textStyle,
      textInputAction: TextInputAction.newline,
    );

    final input = MouseRegion(
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.text,
      onEnter: (_) => _statesController.update(WidgetState.hovered, !widget.disabled),
      onExit: (_) => _statesController.update(WidgetState.hovered, false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : _focusNode.requestFocus,
        child: AnimatedContainer(
          duration: tokens.animationDuration,
          curve: CharcoalMotion.standardCurve,
          height: containerHeight,
          padding: EdgeInsets.all(tokens.paddingHorizontal),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
            boxShadow: focused || widget.invalid
                ? <BoxShadow>[
                    BoxShadow(color: ringColor, spreadRadius: tokens.focusRingWidth),
                  ]
                : const <BoxShadow>[],
            color: tokens.background.resolve(states),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: textHeight,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    if (_controller.text.isEmpty && widget.placeholder != null)
                      IgnorePointer(
                        child: Text(
                          widget.placeholder!,
                          maxLines: widget.rows,
                          overflow: TextOverflow.clip,
                          style: textStyle.copyWith(color: tokens.placeholderColor),
                        ),
                      ),
                    editable,
                  ],
                ),
              ),
              if (widget.showCount) ...<Widget>[
                SizedBox(height: tokens.gap),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.maxLength == null
                        ? '${_controller.text.runes.length}'
                        : '${_controller.text.runes.length}/${widget.maxLength}',
                    style: textStyle.copyWith(color: tokens.counterColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    final assistiveText = widget.assistiveText;
    return Semantics(
      enabled: !widget.disabled,
      label: widget.label.isEmpty ? null : widget.label,
      readOnly: widget.readOnly,
      textField: true,
      child: AnimatedOpacity(
        curve: CharcoalMotion.standardCurve,
        duration: tokens.animationDuration,
        opacity: widget.disabled ? tokens.disabledOpacity : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.showLabel) ...<Widget>[
              CharcoalFieldLabel(
                label: widget.label,
                required: widget.required,
                requiredText: widget.requiredText,
                subLabel: widget.subLabel,
              ),
              SizedBox(height: tokens.gap),
            ],
            ExcludeFocus(
              excluding: widget.disabled,
              child: IgnorePointer(ignoring: widget.disabled, child: input),
            ),
            if (assistiveText != null && assistiveText.isNotEmpty) ...<Widget>[
              SizedBox(height: tokens.gap),
              Text(
                assistiveText,
                style: theme.textStyles.captionMedium.copyWith(
                  color: widget.invalid
                      ? tokens.invalidAssistiveTextColor
                      : tokens.assistiveTextColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
