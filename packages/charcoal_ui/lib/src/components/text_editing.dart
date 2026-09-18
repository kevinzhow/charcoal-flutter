import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'text_selection_toolbar.dart';

// Shared editing behavior for single-line and multiline fields. Flutter owns
// gesture recognition, IME, selection geometry, clipboard policy and undo.
final class CharcoalEditableText extends StatefulWidget {
  const CharcoalEditableText({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.style,
    required this.cursorColor,
    required this.backgroundCursorColor,
    required this.selectionColor,
    required this.keyboardAppearance,
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
    this.scrollPadding = const EdgeInsets.all(20),
    this.undoController,
    this.restorationId,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final TextStyle style;
  final Color cursorColor;
  final Color backgroundCursorColor;
  final Color? selectionColor;
  final Brightness keyboardAppearance;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final int? minLines;
  final Iterable<String>? autofillHints;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool enableInteractiveSelection;
  final EdgeInsets scrollPadding;
  final UndoHistoryController? undoController;
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
    final apple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    return _gestures.buildGestureDetector(
      behavior: HitTestBehavior.translucent,
      child: EditableText(
        key: editableTextKey,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: widget.style,
        cursorColor: widget.cursorColor,
        backgroundCursorColor: widget.backgroundCursorColor,
        selectionColor: widget.selectionColor,
        keyboardAppearance: widget.keyboardAppearance,
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
        scrollPadding: widget.scrollPadding,
        enableInteractiveSelection: selectionEnabled,
        rendererIgnoresPointer: true,
        cursorRadius: apple ? const Radius.circular(2) : null,
        cursorOpacityAnimates: defaultTargetPlatform == TargetPlatform.iOS,
        paintCursorAboveText: apple,
        selectionControls: selectionEnabled ? _selectionControls : null,
        contextMenuBuilder: selectionEnabled ? widget.contextMenuBuilder : null,
        onSelectionChanged: _selectionChanged,
        showSelectionHandles: _showHandles,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        magnifierConfiguration: const TextMagnifierConfiguration(
          magnifierBuilder: _buildMagnifier,
        ),
      ),
    );
  }
}

final _selectionControls = _CharcoalSelectionControls();

final class _CharcoalSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  @override
  Size getHandleSize(double textLineHeight) => const Size(22, 22);

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) =>
      const Offset(11, 0);

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final color = CharcoalTheme.of(context).colors.containerPrimaryDefault;
    return GestureDetector(
      key: ValueKey('charcoal-selection-handle-${type.name}'),
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox.square(
        dimension: 22,
        child: Align(
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const SizedBox.square(dimension: 14),
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
      const size = Size(112, 48);
      final left = (focal.dx - size.width / 2)
          .clamp(0.0, math.max(0.0, overlay.size.width - size.width))
          .toDouble();
      final top = math.max(MediaQuery.paddingOf(context).top, focal.dy - 76.0);
      return Positioned(
        left: left,
        top: top,
        child: IgnorePointer(
          child: RawMagnifier(
            size: size,
            magnificationScale: 1.3,
            focalPointOffset: focal - Offset(left + size.width / 2, top + size.height / 2),
            decoration: MagnifierDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.colors.borderSecondary),
                borderRadius: BorderRadius.circular(theme.dimensions.radius.s),
              ),
            ),
          ),
        ),
      );
    },
  );
}
