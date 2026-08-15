import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'field_label.dart';

/// A single-line Charcoal V2 text field built on [EditableText].
final class CharcoalTextField extends StatefulWidget {
  const CharcoalTextField({
    this.assistiveText,
    this.autofocus = false,
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

  final String? assistiveText;
  final bool autofocus;
  final TextEditingController? controller;
  final bool disabled;
  final FocusNode? focusNode;
  final bool invalid;
  final TextInputType? keyboardType;
  final String label;
  final int? maxLength;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final Widget? prefix;
  final bool readOnly;
  final bool required;
  final String requiredText;
  final bool showCount;
  final bool showLabel;
  final Widget? subLabel;
  final Widget? suffix;
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
    final background = tokens.background.resolve(states);
    final ringVisible = focused || widget.invalid;
    final ringColor = widget.invalid ? tokens.invalidRingColor : tokens.focusRingColor;
    final textStyle = TextStyle(
      color: tokens.foregroundColor,
      fontFamily: theme.typography.fontFamily.sans,
      fontSize: tokens.fontSize,
      fontWeight: tokens.fontWeight,
      height: tokens.lineHeight / tokens.fontSize,
      leadingDistribution: TextLeadingDistribution.even,
    );

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
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly || widget.disabled,
      selectionColor: tokens.focusRingColor,
      style: textStyle,
      textInputAction: widget.textInputAction,
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
          height: tokens.height,
          padding: EdgeInsets.symmetric(horizontal: tokens.paddingHorizontal),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
            boxShadow: ringVisible
                ? <BoxShadow>[
                    BoxShadow(color: ringColor, spreadRadius: tokens.focusRingWidth),
                  ]
                : const <BoxShadow>[],
            color: background,
          ),
          child: Row(
            children: <Widget>[
              if (widget.prefix != null) ...<Widget>[
                IconTheme(
                  data: IconThemeData(color: tokens.foregroundColor, size: tokens.fontSize),
                  child: widget.prefix!,
                ),
                SizedBox(width: tokens.gap),
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
                          style: textStyle.copyWith(color: tokens.placeholderColor),
                        ),
                      ),
                    editable,
                  ],
                ),
              ),
              if (widget.suffix != null || widget.showCount) ...<Widget>[
                SizedBox(width: tokens.gap),
                if (widget.suffix != null)
                  IconTheme(
                    data: IconThemeData(color: tokens.foregroundColor, size: tokens.fontSize),
                    child: widget.suffix!,
                  ),
                if (widget.suffix != null && widget.showCount) SizedBox(width: tokens.gap),
                if (widget.showCount)
                  Text(
                    widget.maxLength == null
                        ? '${_controller.text.runes.length}'
                        : '${_controller.text.runes.length}/${widget.maxLength}',
                    style: textStyle.copyWith(color: tokens.counterColor),
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
