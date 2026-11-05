import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';
import '../actions/button.dart';
import '../fields/text_area.dart';
import '../fields/text_field.dart';
import 'dialog.dart';
import 'modal.dart';

/// Builds the input widget of one [CharcoalFormDialogField].
///
/// [controller] holds the field's text; [submit] validates all fields and closes the dialog, so an
/// input can wire it to its "done" action.
typedef CharcoalFormFieldBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
  VoidCallback submit,
);

/// One entry of a [showCharcoalFormDialog] form.
///
/// Without a [builder] the field is a `CharcoalTextField` (a `CharcoalTextArea` when [multiline])
/// with [label], [placeholder] and [hint]; pass a [builder] for a dropdown or any custom input.
@immutable
class CharcoalFormDialogField {
  /// Creates a field whose input is made by [builder].
  const CharcoalFormDialogField({
    required this.key,
    required this.label,
    this.builder,
    this.hint,
    this.initialValue,
    this.keyboardType,
    this.multiline = false,
    this.obscureText = false,
    this.placeholder,
    this.required = false,
    this.validator,
  });

  /// The key under which the trimmed value appears in the result.
  final String key;

  /// The field's name, used in the "please fill in" message.
  final String label;

  /// Makes a custom input around the shared controller; null uses the default text input.
  final CharcoalFormFieldBuilder? builder;

  /// Assistive text under the default input.
  final String? hint;

  /// Keyboard of the default input.
  final TextInputType? keyboardType;

  /// Whether the default input is a multi-line text area.
  final bool multiline;

  /// Whether the default input hides its text.
  final bool obscureText;

  /// Placeholder of the default input.
  final String? placeholder;

  /// The text the field starts with.
  final String? initialValue;

  /// Whether submission is blocked while the field is empty.
  final bool required;

  /// Returns an error message for a trimmed value, or null when it is acceptable.
  final String? Function(String value)? validator;
}

/// A compact create or edit dialog. Resolves the entered values (trimmed, by field key), or null
/// when dismissed.
///
/// Required fields and validators run on submit; the first problem is shown inline under the
/// fields, in the negative text colour. The body scrolls when the keyboard or a short window
/// leaves too little room, while the buttons stay reachable. [requiredMessage] builds the message
/// for missing fields from their labels.
Future<Map<String, String>?> showCharcoalFormDialog(
  BuildContext context, {
  required String title,
  required List<CharcoalFormDialogField> fields,
  String submitLabel = 'Save',
  String cancelLabel = 'Cancel',
  String? description,
  String Function(List<String> labels)? requiredMessage,
}) => showCharcoalDialog<Map<String, String>>(
  context: context,
  builder: (dialogContext) => _FormDialog(
    title: title,
    fields: fields,
    submitLabel: submitLabel,
    cancelLabel: cancelLabel,
    description: description,
    requiredMessage: requiredMessage ?? (labels) => 'Please fill in ${labels.join(', ')}',
  ),
);

class _FormDialog extends StatefulWidget {
  const _FormDialog({
    required this.title,
    required this.fields,
    required this.submitLabel,
    required this.cancelLabel,
    required this.requiredMessage,
    this.description,
  });

  final String title;
  final List<CharcoalFormDialogField> fields;
  final String submitLabel;
  final String cancelLabel;
  final String? description;
  final String Function(List<String> labels) requiredMessage;

  @override
  State<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<_FormDialog> {
  late final Map<String, TextEditingController> _controllers = <String, TextEditingController>{
    for (final field in widget.fields)
      field.key: TextEditingController(text: field.initialValue ?? ''),
  };
  String? _error;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final missing = widget.fields
        .where((f) => f.required && _controllers[f.key]!.text.trim().isEmpty)
        .map((f) => f.label)
        .toList();
    if (missing.isNotEmpty) {
      setState(() => _error = widget.requiredMessage(missing));
      return;
    }
    for (final field in widget.fields) {
      final message = field.validator?.call(_controllers[field.key]!.text.trim());
      if (message != null) {
        setState(() => _error = message);
        return;
      }
    }
    Navigator.of(context).pop(<String, String>{
      for (final entry in _controllers.entries) entry.key: entry.value.text.trim(),
    });
  }

  Widget _buildField(BuildContext context, CharcoalFormDialogField field) {
    final controller = _controllers[field.key]!;
    if (field.builder != null) return field.builder!(context, controller, _submit);
    if (field.multiline) {
      return CharcoalTextArea(
        controller: controller,
        label: field.label,
        showLabel: true,
        required: field.required,
        placeholder: field.placeholder,
        assistiveText: field.hint,
        rows: 3,
      );
    }
    return CharcoalTextField(
      controller: controller,
      label: field.label,
      showLabel: true,
      required: field.required,
      placeholder: field.placeholder,
      assistiveText: field.hint,
      obscureText: field.obscureText,
      keyboardType: field.keyboardType,
      onSubmitted: (_) => _submit(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalDialog(
      title: widget.title,
      showCloseButton: true,
      onDismiss: () => Navigator.of(context).maybePop(),
      contentPadding: EdgeInsets.symmetric(horizontal: theme.metrics.modal.actionPadding),
      actions: <Widget>[
        CharcoalButton(
          variant: CharcoalButtonVariant.primary,
          fullWidth: true,
          onPressed: _submit,
          child: Text(widget.submitLabel),
        ),
        CharcoalButton(
          fullWidth: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.description != null) ...<Widget>[
            Text(
              widget.description!,
              style: theme.style(CharcoalTextRole.body, color: theme.colors.textSecondary),
            ),
            CharcoalGap.vertical(CharcoalSpace.md),
          ],
          for (var i = 0; i < widget.fields.length; i++) ...<Widget>[
            if (i > 0) CharcoalGap.vertical(CharcoalSpace.md),
            _buildField(context, widget.fields[i]),
          ],
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(top: theme.space.sm),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _error!,
                  style: theme.style(CharcoalTextRole.caption, color: theme.colors.textNegative),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
