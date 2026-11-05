import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';
import '../actions/button.dart';
import '../fields/search_field.dart';
import 'dialog.dart';
import 'modal.dart';
import 'toast.dart';

/// Builds the keyword filter input of a [showCharcoalCodeDialog]; [controller] holds its text.
typedef CharcoalCodeFilterBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
);

/// A monospace viewer for a log, a JSON config or a list of failures.
///
/// [filterable] adds a keyword filter above the block, the only practical way to read a long log;
/// it uses a `CharcoalSearchField` unless [filterBuilder] makes the input. A copy button copies what is shown (all lines, or
/// the lines matching the filter) and confirms with a toast. The block is bounded by
/// `sizes.codeViewportMaxHeight` and scrolls inside the dialog.
///
/// Resolves true when the optional primary button ([primaryLabel]) is taken, false otherwise.
Future<bool> showCharcoalCodeDialog(
  BuildContext context, {
  required String title,
  required String code,
  String? subtitle,
  bool filterable = false,
  CharcoalCodeFilterBuilder? filterBuilder,
  String? primaryLabel,
  String closeLabel = 'Close',
  bool danger = false,
  String copyAllLabel = 'Copy all',
  String copyFilteredLabel = 'Copy filtered',
  String copiedAllMessage = 'Copied',
  String copiedFilteredMessage = 'Copied filtered lines',
  String noMatchLabel = 'No matching lines',
  String filterPlaceholder = 'Filter by keyword',
}) async {
  final result = await showCharcoalDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final theme = CharcoalTheme.of(dialogContext);
      return CharcoalDialog(
        title: title,
        maxWidth: theme.sizes.dialogWideMaxWidth,
        showCloseButton: true,
        onDismiss: () => Navigator.of(dialogContext).maybePop(false),
        contentPadding: EdgeInsets.symmetric(horizontal: theme.metrics.modal.actionPadding),
        actions: <Widget>[
          if (primaryLabel != null) ...<Widget>[
            CharcoalButton(
              variant: danger ? CharcoalButtonVariant.danger : CharcoalButtonVariant.primary,
              fullWidth: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(primaryLabel),
            ),
            CharcoalButton(
              fullWidth: true,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(closeLabel),
            ),
          ],
        ],
        child: _CodeBody(
          code: code,
          subtitle: subtitle,
          filterable: filterable,
          filterBuilder: filterBuilder,
          copyAllLabel: copyAllLabel,
          copyFilteredLabel: copyFilteredLabel,
          copiedAllMessage: copiedAllMessage,
          copiedFilteredMessage: copiedFilteredMessage,
          noMatchLabel: noMatchLabel,
          filterPlaceholder: filterPlaceholder,
        ),
      );
    },
  );
  return result ?? false;
}

class _CodeBody extends StatefulWidget {
  const _CodeBody({
    required this.code,
    required this.filterable,
    required this.copyAllLabel,
    required this.copyFilteredLabel,
    required this.copiedAllMessage,
    required this.copiedFilteredMessage,
    required this.noMatchLabel,
    required this.filterPlaceholder,
    this.filterBuilder,
    this.subtitle,
  });

  final String code;
  final bool filterable;
  final CharcoalCodeFilterBuilder? filterBuilder;
  final String? subtitle;
  final String copyAllLabel;
  final String copyFilteredLabel;
  final String copiedAllMessage;
  final String copiedFilteredMessage;
  final String noMatchLabel;
  final String filterPlaceholder;

  @override
  State<_CodeBody> createState() => _CodeBodyState();
}

class _CodeBodyState extends State<_CodeBody> {
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter.addListener(_changed);
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  bool get _filtered => widget.filterable && _filter.text.trim().isNotEmpty;

  /// The lines matching the filter, or every line when there is none.
  String get _matchedCode {
    final needle = _filter.text.trim().toLowerCase();
    if (!_filtered) return widget.code;
    return widget.code.split('\n').where((line) => line.toLowerCase().contains(needle)).join('\n');
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _matchedCode));
    if (!mounted) return;
    showCharcoalToast(
      context: context,
      message: _filtered ? widget.copiedFilteredMessage : widget.copiedAllMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final matched = _matchedCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.subtitle != null) ...<Widget>[
          Text(
            widget.subtitle!,
            style: theme.style(CharcoalTextRole.body, color: theme.colors.textSecondary),
          ),
          CharcoalGap.vertical(CharcoalSpace.md),
        ],
        if (widget.filterable) ...<Widget>[
          widget.filterBuilder?.call(context, _filter) ??
              CharcoalSearchField(
                controller: _filter,
                icon: CharcoalIcons.funnel,
                placeholder: widget.filterPlaceholder,
                onClear: _filter.clear,
              ),
          CharcoalGap.vertical(CharcoalSpace.sm),
        ],
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: CharcoalButton(
            size: CharcoalButtonSize.small,
            leading: CharcoalIcon(CharcoalIcons.copy),
            onPressed: _copy,
            child: Text(_filtered ? widget.copyFilteredLabel : widget.copyAllLabel),
          ),
        ),
        CharcoalGap.vertical(CharcoalSpace.xs),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: theme.sizes.codeViewportMaxHeight),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(theme.space.md),
            decoration: BoxDecoration(
              color: theme.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(theme.radius.md),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                matched.isEmpty ? widget.noMatchLabel : matched,
                style: theme.style(CharcoalTextRole.captionMono, color: theme.colors.text),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
