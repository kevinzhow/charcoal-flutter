import 'package:flutter/semantics.dart' show SemanticsRole, SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef CharcoalClickableBuilder = Widget Function(
  BuildContext context,
  Set<WidgetState> states,
);

/// A Widgets-layer interaction primitive shared by all Charcoal controls.
///
/// It centralizes pointer, keyboard, focus, hover, disabled, and selected states
/// without relying on Material's InkWell or CupertinoButton.
final class CharcoalClickable extends StatefulWidget {
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

  final CharcoalClickableBuilder builder;
  final VoidCallback? onPressed;
  final bool autofocus;
  final bool? checked;
  final bool? expanded;
  final FocusNode? focusNode;
  final bool inMutuallyExclusiveGroup;
  final bool keyboardActivationEnabled;
  final ValueChanged<bool>? onFocusChange;
  final FocusOnKeyEventCallback? onKeyEvent;
  final bool semanticButton;
  final String? semanticHint;
  final String? semanticLabel;
  final SemanticsRole? semanticRole;
  final String? semanticValue;
  final bool selected;
  final WidgetStatesController? statesController;
  final bool? toggled;
  final SemanticsValidationResult validationResult;

  @override
  State<CharcoalClickable> createState() => _CharcoalClickableState();
}

final class _CharcoalClickableState extends State<CharcoalClickable> {
  WidgetStatesController? _internalStatesController;

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
      if (oldWidget.statesController == null) {
        _internalStatesController!.dispose();
        _internalStatesController = null;
      }
      if (widget.statesController == null) {
        _internalStatesController = WidgetStatesController();
      }
    }
    _syncPersistentStates();
  }

  @override
  void dispose() {
    _internalStatesController?.dispose();
    super.dispose();
  }

  void _syncPersistentStates() {
    _statesController
      ..update(WidgetState.disabled, !_enabled)
      ..update(WidgetState.selected, widget.selected);
    if (!_enabled) {
      _statesController.update(WidgetState.pressed, false);
    }
  }

  void _activate() => widget.onPressed?.call();

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
            actions: _enabled
                ? <Type, Action<Intent>>{
                    ActivateIntent: CallbackAction<ActivateIntent>(
                      onInvoke: (_) {
                        _activate();
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
            shortcuts: widget.keyboardActivationEnabled
                ? const <ShortcutActivator, Intent>{
                    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
                  }
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _enabled ? _activate : null,
              onTapCancel: _enabled
                  ? () => _statesController.update(WidgetState.pressed, false)
                  : null,
              onTapDown: _enabled
                  ? (_) => _statesController.update(WidgetState.pressed, true)
                  : null,
              onTapUp: _enabled
                  ? (_) => _statesController.update(WidgetState.pressed, false)
                  : null,
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
