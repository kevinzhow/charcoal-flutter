part of '../bloom.dart';

/// Shared single-line composer for comments, direct messages, and story replies.
///
/// It owns draft lifecycle and aligns the field with a medium send target, so
/// every reply surface has the same geometry and feedback.
final class _BloomReplyBar extends StatefulWidget {
  const _BloomReplyBar({
    required this.fieldKey,
    required this.fieldSemanticLabel,
    required this.onSend,
    required this.placeholder,
    required this.sendKey,
    required this.sendSemanticLabel,
    this.prefix,
  });

  final Key fieldKey;
  final String fieldSemanticLabel;
  final ValueChanged<String> onSend;
  final String placeholder;
  final Widget? prefix;
  final Key sendKey;
  final String sendSemanticLabel;

  @override
  State<_BloomReplyBar> createState() => _BloomReplyBarState();
}

final class _BloomReplyBarState extends State<_BloomReplyBar> {
  final TextEditingController _controller = TextEditingController();
  var _draft = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.component20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: CharcoalTextField(
                key: widget.fieldKey,
                controller: _controller,
                label: widget.fieldSemanticLabel,
                onChanged: (value) => setState(() => _draft = value),
                onSubmitted: (_) => _send(),
                placeholder: widget.placeholder,
                prefix: widget.prefix,
                textInputAction: TextInputAction.send,
              ),
            ),
            SizedBox(width: space.component20),
            CharcoalIconButton(
              key: widget.sendKey,
              icon: const CharcoalIcon(CharcoalIcons.send),
              onPressed: _draft.trim().isEmpty ? null : _send,
              semanticLabel: widget.sendSemanticLabel,
              size: CharcoalIconButtonSize.medium,
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    final text = _draft.trim();
    if (text.isEmpty) return;
    _controller.clear();
    setState(() => _draft = '');
    widget.onSend(text);
  }
}
