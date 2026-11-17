import 'dart:math' as math;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'selection_toolbar.dart';
import 'text_input_refresh.dart';

/// Whether an input method is composing in [value], such as the marked text of a Chinese or
/// Japanese input method.
///
/// While it is, Enter, Escape and the arrow keys belong to the input method: they confirm the
/// composition, cancel it or pick a candidate. A key handler above a text input must leave them
/// alone, or the key submits a form, closes a dialog or moves a list instead. Charcoal's own text
/// inputs already pass these keys on; use this to guard an application's own handlers.
bool charcoalIsComposing(TextEditingValue value) =>
    value.composing.isValid && !value.composing.isCollapsed;

/// The keys an input method owns while it composes.
final _inputMethodKeys = <LogicalKeyboardKey>{
  LogicalKeyboardKey.enter,
  LogicalKeyboardKey.numpadEnter,
  LogicalKeyboardKey.escape,
  LogicalKeyboardKey.arrowUp,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.arrowLeft,
  LogicalKeyboardKey.arrowRight,
};

/// Shared editing behaviour for single-line and multiline Charcoal fields.
///
/// Flutter owns gesture recognition, IME, selection geometry, clipboard policy and undo; this
/// widget supplies the Charcoal selection handles, magnifier and editing menu, with every colour
/// and measure read from the active pack. Fields place it inside their own decoration.
///
/// While an input method composes ([charcoalIsComposing]), Enter, Escape and the arrow keys skip
/// every handler above the editor and go to the platform, so a dialog's Escape or a list's arrow
/// keys cannot take them from the input method. On macOS the editor also holds
/// [CharcoalTextInputRefresh], which re-attaches the input method after the window is resized.
final class CharcoalEditableText extends StatefulWidget {
  /// Creates the editable text of a field.
  const CharcoalEditableText({
    required this.controller,
    required this.focusNode,
    required this.style,
    this.selectionColor,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.autofillHints,
    this.contextMenuBuilder = buildCharcoalTextContextMenu,
    this.enableInteractiveSelection = true,
    this.scrollPadding,
    this.undoController,
    this.restorationId,
    super.key,
  });

  /// The text being edited.
  final TextEditingController controller;

  /// The focus node of the field.
  final FocusNode focusNode;

  /// The text style.
  final TextStyle style;

  /// Selection highlight colour; null paints none.
  final Color? selectionColor;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Whether the text can be changed.
  final bool readOnly;

  /// Whether to mask the text.
  final bool obscureText;

  /// The keyboard type.
  final TextInputType? keyboardType;

  /// The keyboard action button.
  final TextInputAction? textInputAction;

  /// Input transformations.
  final List<TextInputFormatter>? inputFormatters;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Maximum number of lines.
  final int maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Platform autofill hints.
  final Iterable<String>? autofillHints;

  /// The editing menu builder, or null to disable the menu.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Whether touch and pointer gestures may change the selection.
  final bool enableInteractiveSelection;

  /// Space kept around the caret when scrolling it into view; null uses
  /// `metrics.textEditing.scrollPadding` on every side.
  final EdgeInsets? scrollPadding;

  /// Optional undo controller.
  final UndoHistoryController? undoController;

  /// State restoration id.
  final String? restorationId;

  @override
  State<CharcoalEditableText> createState() => _CharcoalEditableTextState();
}

final class _CharcoalEditableTextState extends State<CharcoalEditableText>
    implements TextSelectionGestureDetectorBuilderDelegate {
  @override
  final editableTextKey = GlobalKey<EditableTextState>();
  late final _gestures = TextSelectionGestureDetectorBuilder(delegate: this);
  bool _showHandles = false;
  _CharcoalSelectionControls? _controls;

  @override
  void initState() {
    super.initState();
    CharcoalTextInputRefresh.retain();
  }

  @override
  void dispose() {
    CharcoalTextInputRefresh.release();
    super.dispose();
  }

  KeyEventResult _leaveComposingKeys(FocusNode node, KeyEvent event) =>
      charcoalIsComposing(widget.controller.value) && _inputMethodKeys.contains(event.logicalKey)
      ? KeyEventResult.skipRemainingHandlers
      : KeyEventResult.ignored;

  // The controls object is compared by identity on every rebuild; keep one per metrics value so a
  // rebuild during a selection does not tear down the handles and the menu.
  _CharcoalSelectionControls _controlsFor(CharcoalTextEditingMetrics metrics) {
    final current = _controls;
    if (current != null && current.metrics == metrics) return current;
    return _controls = _CharcoalSelectionControls(metrics);
  }

  @override
  bool get forcePressEnabled => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  bool get selectionEnabled => widget.enableInteractiveSelection;

  void _selectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    final show =
        _gestures.shouldShowSelectionToolbar &&
        _gestures.shouldShowSelectionHandles &&
        cause != SelectionChangedCause.keyboard &&
        !(widget.readOnly && selection.isCollapsed) &&
        widget.controller.text.isNotEmpty;
    if (_showHandles != show) setState(() => _showHandles = show);
    if (cause == SelectionChangedCause.longPress) {
      editableTextKey.currentState?.bringIntoView(selection.extent);
    }
    if (cause == SelectionChangedCause.drag &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux)) {
      editableTextKey.currentState?.hideToolbar();
    }
  }

  void _handleSelectionHandleTapped() {
    if (widget.controller.selection.isCollapsed) {
      editableTextKey.currentState?.toggleToolbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.textEditing;
    final apple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    final editor = _gestures.buildGestureDetector(
      behavior: HitTestBehavior.translucent,
      child: EditableText(
        key: editableTextKey,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: widget.style,
        cursorColor: theme.colors.primary,
        backgroundCursorColor: theme.colors.background,
        selectionColor: widget.selectionColor,
        keyboardAppearance: theme.brightness,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        autofillHints: widget.autofillHints,
        undoController: widget.undoController,
        restorationId: widget.restorationId,
        scrollPadding: widget.scrollPadding ?? EdgeInsets.all(metrics.scrollPadding),
        enableInteractiveSelection: selectionEnabled,
        rendererIgnoresPointer: true,
        cursorRadius: apple ? Radius.circular(metrics.cursorRadius) : null,
        cursorOpacityAnimates: defaultTargetPlatform == TargetPlatform.iOS,
        paintCursorAboveText: apple,
        selectionControls: selectionEnabled ? _controlsFor(metrics) : null,
        contextMenuBuilder: selectionEnabled ? widget.contextMenuBuilder : null,
        onSelectionChanged: _selectionChanged,
        showSelectionHandles: _showHandles,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        magnifierConfiguration: const TextMagnifierConfiguration(
          magnifierBuilder: _buildMagnifier,
        ),
      ),
    );
    // The editor's focus node is the child of this one, so a key the editor leaves unhandled
    // reaches this handler before any ancestor's shortcuts.
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onKeyEvent: _leaveComposingKeys,
      child: editor,
    );
  }
}

final class _CharcoalSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  _CharcoalSelectionControls(this.metrics);

  final CharcoalTextEditingMetrics metrics;

  @override
  Size getHandleSize(double textLineHeight) => Size.square(metrics.handleSize);

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) =>
      Offset(metrics.handleAnchorX, 0);

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final color = CharcoalTheme.of(context).colors.primary;
    return GestureDetector(
      key: ValueKey('charcoal-selection-handle-${type.name}'),
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox.fromSize(
        size: Size.square(metrics.handleSize),
        child: Align(
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: SizedBox.fromSize(size: Size.square(metrics.handleInnerSize)),
          ),
        ),
      ),
    );
  }
}

Widget? _buildMagnifier(
  BuildContext context,
  MagnifierController controller,
  ValueNotifier<MagnifierInfo> info,
) {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.android)) {
    return null;
  }
  final theme = CharcoalTheme.of(context);
  final metrics = theme.metrics.textEditing;
  return ValueListenableBuilder<MagnifierInfo>(
    valueListenable: info,
    builder: (context, value, _) {
      final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
      final focal = overlay.globalToLocal(
        Offset(
          value.globalGesturePosition.dx.clamp(value.fieldBounds.left, value.fieldBounds.right),
          value.currentLineBoundaries.center.dy,
        ),
      );
      final size = Size(metrics.magnifierWidth, metrics.magnifierHeight);
      final left = (focal.dx - size.width / 2)
          .clamp(0.0, math.max(0.0, overlay.size.width - size.width))
          .toDouble();
      final top = math.max(
        MediaQuery.paddingOf(context).top,
        focal.dy - metrics.magnifierFocalOffset,
      );
      return Positioned(
        left: left,
        top: top,
        child: IgnorePointer(
          child: RawMagnifier(
            size: size,
            magnificationScale: metrics.magnifierScale,
            focalPointOffset: focal - Offset(left + size.width / 2, top + size.height / 2),
            decoration: MagnifierDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline),
                borderRadius: BorderRadius.circular(theme.radius.sm),
              ),
            ),
          ),
        ),
      );
    },
  );
}
