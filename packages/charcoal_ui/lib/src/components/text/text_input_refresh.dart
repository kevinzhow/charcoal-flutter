import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Tells the macOS text input plugin to take key input again after the window was resized.
///
/// The macOS engine routes keystrokes to the input method only while its text input view is the
/// key responder, which `TextInput.show` establishes. A resized window can leave that behind: the
/// connection is intact (same client, no `clearClient`), but typing produces no editing state until
/// the next `show`, which a click on the field sends. So after the window metrics changed, the
/// focused editor asks for the keyboard once more. `show` on a live connection changes no text,
/// selection or composing range.
///
/// macOS only. It acts on whatever editor has the primary focus; every `CharcoalEditableText`
/// calls [retain] when it mounts and [release] when it unmounts, and the observer listens only
/// while at least one is mounted. Ported from Raft Flutter's `RaftTextInputRefresh`.
final class CharcoalTextInputRefresh with WidgetsBindingObserver {
  CharcoalTextInputRefresh._();

  static final _instance = CharcoalTextInputRefresh._();

  int _users = 0;
  Size? _size;

  /// Counts one more editor that wants the refresh; the first one starts listening.
  static void retain() {
    if (_instance._users++ > 0) return;
    _instance._size = _viewSize;
    WidgetsBinding.instance.addObserver(_instance);
  }

  /// Counts one editor less; the last one stops listening.
  static void release() {
    assert(_instance._users > 0, 'CharcoalTextInputRefresh.release without retain');
    if (--_instance._users > 0) return;
    WidgetsBinding.instance.removeObserver(_instance);
  }

  /// How many editors hold the refresh now.
  @visibleForTesting
  static int get debugUsers => _instance._users;

  static Size? get _viewSize =>
      WidgetsBinding.instance.platformDispatcher.implicitView?.physicalSize;

  @override
  void didChangeMetrics() {
    if (defaultTargetPlatform != TargetPlatform.macOS) return;
    final size = _viewSize;
    if (size == _size) return;
    _size = size;
    // After the frame: the new layout is in place and the plugin has the new editable geometry.
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  void _refresh() {
    final field = FocusManager.instance.primaryFocus?.context
        ?.findAncestorStateOfType<EditableTextState>();
    if (field == null || !field.mounted) return;
    field.requestKeyboard();
  }
}
