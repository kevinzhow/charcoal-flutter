import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'field_label.dart';
import 'field_ring.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _TextAreaSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const horizontalInset = 9.0;
  static const counterBottomInset = 9.0;
  static const lineHeight = 22.0;
  static const verticalChrome = 18.0;
  static const focusRingWidth = 4.0;
}

/// A fixed-row, multiline Charcoal V2 text input.
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

  void _updateState(WidgetState state, bool value) {
    _statesController.update(state, value);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final states = Set<WidgetState>.unmodifiable(_statesController.value);
    final focused = states.contains(WidgetState.focused);
    final ringColor = widget.invalid ? theme.colors.borderNegative : theme.colors.borderFocusLegacy;
    final textStyle = charcoalTypographyStyle(
      context,
      color: theme.colors.textSecondaryDefault,
      size: CharcoalTypographySize.size14,
    );
    final scaledLineHeight = MediaQuery.textScalerOf(
      context,
    ).scale(_TextAreaSpec.lineHeight);
    final textHeight = scaledLineHeight * widget.rows;
    final containerHeight =
        scaledLineHeight * (widget.rows + (widget.showCount ? 1 : 0)) +
        _TextAreaSpec.verticalChrome;
    final fieldGap = theme.dimensions.space.component10;
    final topInset = theme.dimensions.space.component20;
    final radius = theme.dimensions.radius.s;
    final background = resolveCharcoalStateColor(
      states,
      normal: theme.colors.containerSecondaryDefaultA,
      hovered: theme.colors.containerSecondaryHoverA,
      pressed: theme.colors.containerSecondaryPressA,
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
      keyboardType: TextInputType.multiline,
      maxLines: widget.rows,
      minLines: widget.rows,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly || widget.disabled,
      selectionColor: theme.colors.borderFocusLegacy,
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
          duration: CharcoalMotion.resolveDuration(
            context,
            _TextAreaSpec.animationDuration,
          ),
          radius: radius,
          visible: focused || widget.invalid,
          width: _TextAreaSpec.focusRingWidth,
          child: AnimatedContainer(
            duration: CharcoalMotion.resolveDuration(
              context,
              _TextAreaSpec.animationDuration,
            ),
            curve: CharcoalMotion.standardCurve,
            height: containerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: background,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: _TextAreaSpec.horizontalInset,
                  right: _TextAreaSpec.horizontalInset,
                  top: topInset,
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
                            style: textStyle.copyWith(
                              color: theme.colors.textPlaceholderDefault,
                            ),
                          ),
                        ),
                      editable,
                    ],
                  ),
                ),
                if (widget.showCount)
                  Positioned(
                    right: topInset,
                    bottom: _TextAreaSpec.counterBottomInset,
                    child: Text(
                      widget.maxLength == null
                          ? '${_controller.text.runes.length}'
                          : '${_controller.text.runes.length}/${widget.maxLength}',
                      style: textStyle.copyWith(
                        color: theme.colors.textTertiaryDefault,
                      ),
                    ),
                  ),
              ],
            ),
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
        duration: CharcoalMotion.resolveDuration(
          context,
          _TextAreaSpec.animationDuration,
        ),
        opacity: widget.disabled ? charcoalDisabledOpacity : 1,
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
              SizedBox(height: fieldGap),
            ],
            ExcludeFocus(
              excluding: widget.disabled,
              child: IgnorePointer(ignoring: widget.disabled, child: input),
            ),
            if (assistiveText != null && assistiveText.isNotEmpty) ...<Widget>[
              SizedBox(height: fieldGap),
              Text(
                assistiveText,
                style: charcoalTypographyStyle(
                  context,
                  color: widget.invalid
                      ? theme.colors.textNegativeDefault
                      : theme.colors.textSecondaryDefault,
                  size: CharcoalTypographySize.size14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
