import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../actions/icon_button.dart';
import '../layout/selectable.dart';
import '../overlays/toast.dart';

/// An identifier the reader may need elsewhere, such as a record ID: the [text] in the caption
/// monospace role, selectable, followed by a small copy button.
///
/// The button writes the whole [text] to the clipboard and confirms with a Charcoal toast showing
/// [copiedMessage]. In a narrow space the text ends with an ellipsis; the button still copies all
/// of it.
///
/// ```dart
/// CharcoalCopyableText(
///   text: flag.id,
///   copyLabel: 'Copy ID',
///   copiedMessage: 'ID copied',
/// )
/// ```
final class CharcoalCopyableText extends StatelessWidget {
  /// Shows [text] with a copy button labelled [copyLabel].
  const CharcoalCopyableText({
    required this.text,
    required this.copyLabel,
    required this.copiedMessage,
    super.key,
  });

  /// The value shown and copied.
  final String text;

  /// The spoken label of the copy button, e.g. "Copy ID"; pass the localized string.
  final String copyLabel;

  /// The toast shown after copying, e.g. "ID copied"; pass the localized string.
  final String copiedMessage;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    showCharcoalToast(context: context, message: copiedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: CharcoalSelectable(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.style(CharcoalTextRole.captionMono),
            ),
          ),
        ),
        SizedBox(width: theme.space.xxs),
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.copy),
          semanticLabel: copyLabel,
          size: CharcoalIconButtonSize.extraSmall,
          onPressed: () => _copy(context),
        ),
      ],
    );
  }
}
