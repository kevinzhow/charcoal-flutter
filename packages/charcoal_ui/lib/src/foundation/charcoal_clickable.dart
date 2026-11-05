import 'dart:async';

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsRole, SemanticsValidationResult;
import 'package:flutter/widgets.dart';

/// Builds the content of a [CharcoalClickable] for the current interaction [states].
typedef CharcoalClickableBuilder = Widget Function(BuildContext context, Set<WidgetState> states);

/// The interaction primitive under every custom-painted Charcoal control.
///
/// It centralizes pointer, keyboard, focus, hover, disabled and selected states and hands them to
/// [builder], which composites its own state layers into its own decoration, so state changes
/// cannot move bounds, icon centres or baselines. The clickable paints nothing, owns no colour and
/// no geometry, and needs no `Material` ancestor.
///
/// * Pressing only sets `WidgetState.pressed`; a cancelled press leaves nothing behind and
///   [onPressed] runs on release, never on down.
/// * Keyboard activation follows the ambient shortcuts, including Web's button-specific Enter
///   intent, and shows the pressed state for `metrics.clickable.keyboardActivationDuration`.
/// * A null [onPressed] disables it: no activation, `disabled` state, basic cursor, and the
///   semantics node reports disabled.
///
/// Prefer a higher-level Charcoal component when one expresses the interaction.
class CharcoalClickable extends StatefulWidget {
  /// Creates a clickable that renders [builder] and calls [onPressed] on activation.
  const CharcoalClickable({
    required this.builder,
    required this.onPressed,
    this.autofocus = false,
    this.checked,
    this.expanded,
    this.focusNode,
    this.inMutuallyExclusiveGroup = false,
    this.keyboardActivationEnabled = true,
    this.onFocusChange,
    this.onKeyEvent,
    this.semanticButton = true,
    this.semanticHint,
    this.semanticLabel,
    this.semanticRole,
    this.semanticValue,
    this.selected = false,
    this.statesController,
    this.toggled,
    this.validationResult = SemanticsValidationResult.none,
    super.key,
  });

  /// Builds the content for the current states.
  final CharcoalClickableBuilder builder;

  /// Called on activation; null disables the control.
  final VoidCallback? onPressed;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Semantics: checked state of a checkbox or radio.
  final bool? checked;

  /// Semantics: expanded state of a disclosure.
  final bool? expanded;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Semantics: part of a mutually exclusive group.
  final bool inMutuallyExclusiveGroup;

  /// Whether ambient activation intents (Enter, Space) can invoke [onPressed].
  ///
  /// Disable only when an owning composite implements and tests its full key map. Pointer and assistive-technology semantics stay available.
  final bool keyboardActivationEnabled;

  /// Called when focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Key handler wrapped around the control.
  final FocusOnKeyEventCallback? onKeyEvent;

  /// Whether the semantics node is a button.
  final bool semanticButton;

  /// Semantics hint.
  final String? semanticHint;

  /// Semantics label; when set it replaces the label of the content.
  final String? semanticLabel;

  /// Semantics role.
  final SemanticsRole? semanticRole;

  /// Semantics value.
  final String? semanticValue;

  /// Whether the control is in a selected state.
  final bool selected;

  /// Controller to observe or drive the states from outside.
  final WidgetStatesController? statesController;

  /// Semantics: toggled state of a switch.
  final bool? toggled;

  /// Semantics validation result.
  final SemanticsValidationResult validationResult;

  @override
  State<CharcoalClickable> createState() => _CharcoalClickableState();
}

class _CharcoalClickableState extends State<CharcoalClickable> {
  WidgetStatesController? _internalStatesController;
  Timer? _keyboardActivationTimer;
  WidgetStatesController? _keyboardActivationStatesController;

  WidgetStatesController get _statesController =>
      widget.statesController ?? _internalStatesController!;

  bool get _enabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    if (widget.statesController == null) {
      _internalStatesController = WidgetStatesController();
    }
    _syncPersistentStates();
  }

  @override
  void didUpdateWidget(CharcoalClickable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      _cancelKeyboardActivation();
      if (oldWidget.statesController == null) {
        _internalStatesController!.dispose();
        _internalStatesController = null;
      }
      if (widget.statesController == null) {
        _internalStatesController = WidgetStatesController();
      }
    }
    if (!widget.keyboardActivationEnabled) {
      _cancelKeyboardActivation();
    }
    _syncPersistentStates();
  }

  @override
  void dispose() {
    _cancelKeyboardActivation();
    _internalStatesController?.dispose();
    super.dispose();
  }

  void _syncPersistentStates() {
    if (!_enabled) {
      _cancelKeyboardActivation();
    }
    _statesController
      ..update(WidgetState.disabled, !_enabled)
      ..update(WidgetState.selected, widget.selected);
    if (!_enabled) {
      _statesController.update(WidgetState.pressed, false);
    }
  }

  void _activate() => widget.onPressed?.call();

  void _activateFromKeyboard() {
    _cancelKeyboardActivation();
    final statesController = _statesController;
    _keyboardActivationStatesController = statesController;
    statesController.update(WidgetState.pressed, true);
    _activate();
    _keyboardActivationTimer = Timer(
      CharcoalTheme.of(context).metrics.clickable.keyboardActivationDuration,
      () {
        _keyboardActivationTimer = null;
        _keyboardActivationStatesController = null;
        statesController.update(WidgetState.pressed, false);
      },
    );
  }

  void _cancelKeyboardActivation() {
    _keyboardActivationTimer?.cancel();
    _keyboardActivationTimer = null;
    _keyboardActivationStatesController?.update(WidgetState.pressed, false);
    _keyboardActivationStatesController = null;
  }

  void _handleTapDown(TapDownDetails details) {
    _cancelKeyboardActivation();
    _statesController.update(WidgetState.pressed, true);
  }

  void _handleTapEnd() {
    _statesController.update(WidgetState.pressed, false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<WidgetState>>(
      valueListenable: _statesController,
      builder: (context, states, _) {
        final effectiveStates = Set<WidgetState>.unmodifiable(states);
        final interactive = Semantics(
          button: widget.semanticButton,
          checked: widget.checked,
          enabled: _enabled,
          expanded: widget.expanded,
          excludeSemantics: widget.semanticLabel != null,
          hint: widget.semanticHint,
          inMutuallyExclusiveGroup: widget.inMutuallyExclusiveGroup,
          label: widget.semanticLabel,
          onCollapse: _enabled && widget.expanded == true ? _activate : null,
          onExpand: _enabled && widget.expanded == false ? _activate : null,
          onTap: _enabled ? _activate : null,
          role: widget.semanticRole,
          // SemanticsRole.tab requires an explicit selected value for every
          // tab. Other mutually exclusive controls expose their state through
          // checked unless they opt into selected themselves.
          selected: widget.semanticRole == SemanticsRole.tab || widget.selected
              ? widget.selected
              : null,
          toggled: widget.toggled,
          validationResult: widget.validationResult,
          value: widget.semanticValue,
          child: FocusableActionDetector(
            actions: _enabled && widget.keyboardActivationEnabled
                ? <Type, Action<Intent>>{
                    ActivateIntent: CallbackAction<ActivateIntent>(
                      onInvoke: (_) {
                        _activateFromKeyboard();
                        return null;
                      },
                    ),
                    if (widget.semanticButton || widget.semanticRole == SemanticsRole.tab)
                      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                        onInvoke: (_) {
                          _activateFromKeyboard();
                          return null;
                        },
                      ),
                  }
                : null,
            autofocus: widget.autofocus,
            enabled: _enabled,
            focusNode: widget.focusNode,
            mouseCursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            onShowFocusHighlight: (value) => _statesController.update(WidgetState.focused, value),
            onShowHoverHighlight: (value) => _statesController.update(WidgetState.hovered, value),
            onFocusChange: widget.onFocusChange,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _enabled ? _activate : null,
              onTapCancel: _enabled ? _handleTapEnd : null,
              onTapDown: _enabled ? _handleTapDown : null,
              onTapUp: _enabled ? (_) => _handleTapEnd() : null,
              child: widget.builder(context, effectiveStates),
            ),
          ),
        );
        final onKeyEvent = widget.onKeyEvent;
        return onKeyEvent == null
            ? interactive
            : Focus(canRequestFocus: false, onKeyEvent: onKeyEvent, child: interactive);
      },
    );
  }
}
