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
/// [controller] holds the field's text; [submit] validates all fields and submits the form (see
/// [showCharcoalFormDialog]), so an input can wire it to its "done" action.
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
/// for missing fields from their labels. [requiredText] is the marker shown after the label of
/// required fields; pass the localized string.
///
/// Without [onSubmit] the dialog closes as soon as the values are valid. With it, the dialog
/// stays open while [onSubmit] runs on the valid values: the submit button shows
/// [submittingLabel], and the fields, buttons, close button, barrier and back gesture are
/// disabled. When [onSubmit] completes the dialog closes with the values; when it throws, the
/// dialog stays open with everything the user entered and shows [errorMessage] of the error
/// (its `toString()` by default) in place of the validation message, so the user can correct
/// the input and submit again instead of retyping it.
Future<Map<String, String>?> showCharcoalFormDialog(
  BuildContext context, {
  required String title,
  required List<CharcoalFormDialogField> fields,
  String submitLabel = 'Save',
  String cancelLabel = 'Cancel',
  String requiredText = '*Required',
  String? description,
  String Function(List<String> labels)? requiredMessage,
  Future<void> Function(Map<String, String> values)? onSubmit,
  String submittingLabel = 'Saving…',
  String Function(Object error)? errorMessage,
}) => showCharcoalDialog<Map<String, String>>(
  context: context,
  barrierDismissible: onSubmit == null,
  builder: (dialogContext) => _FormDialog(
    title: title,
    fields: fields,
    submitLabel: submitLabel,
    cancelLabel: cancelLabel,
    requiredText: requiredText,
    description: description,
    requiredMessage: requiredMessage ?? (labels) => 'Please fill in ${labels.join(', ')}',
    onSubmit: onSubmit,
    submittingLabel: submittingLabel,
    errorMessage: errorMessage ?? (error) => error.toString(),
  ),
);

class _FormDialog extends StatefulWidget {
  const _FormDialog({
    required this.title,
    required this.fields,
    required this.submitLabel,
    required this.cancelLabel,
    required this.requiredText,
    required this.requiredMessage,
    required this.submittingLabel,
    required this.errorMessage,
    this.description,
    this.onSubmit,
  });

  final String title;
  final List<CharcoalFormDialogField> fields;
  final String submitLabel;
  final String cancelLabel;
  final String requiredText;
  final String? description;
  final String Function(List<String> labels) requiredMessage;
  final Future<void> Function(Map<String, String> values)? onSubmit;
  final String submittingLabel;
  final String Function(Object error) errorMessage;

  @override
  State<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<_FormDialog> {
  late final Map<String, TextEditingController> _controllers = <String, TextEditingController>{
    for (final field in widget.fields)
      field.key: TextEditingController(text: field.initialValue ?? ''),
  };
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final missing = widget.fields
        .where((f) => f.required && _controllers[f.key]!.text.trim().isEmpty)
        .map((f) => f.label)
        .toList();
    if (missing.isNotEmpty) {
      setState(() => _error = widget.requiredMessage(missing));
      return;
    }
    for (final field in widget.fields) {
      final message = field.validator?.call(
        _controllers[field.key]!.text.trim(),
      );
      if (message != null) {
        setState(() => _error = message);
        return;
      }
    }
    final values = <String, String>{
      for (final entry in _controllers.entries) entry.key: entry.value.text.trim(),
    };
    final onSubmit = widget.onSubmit;
    if (onSubmit == null) {
      Navigator.of(context).pop(values);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await onSubmit(values);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = widget.errorMessage(error);
      });
      return;
    }
    // Navigator.pop is not held back by the PopScope, which only blocks dismissal by the user.
    if (mounted) Navigator.of(context).pop(values);
  }

  Widget _buildField(BuildContext context, CharcoalFormDialogField field) {
    final controller = _controllers[field.key]!;
    if (field.builder != null) return field.builder!(context, controller, () => _submit());
    if (field.multiline) {
      return CharcoalTextArea(
        controller: controller,
        label: field.label,
        showLabel: true,
        required: field.required,
        requiredText: widget.requiredText,
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
      requiredText: widget.requiredText,
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
    return PopScope(
      canPop: !_submitting,
      child: CharcoalDialog(
        title: widget.title,
        showCloseButton: !_submitting,
        onDismiss: _submitting ? null : () => Navigator.of(context).maybePop(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: theme.metrics.modal.actionPadding,
        ),
        actions: <Widget>[
          CharcoalButton(
            variant: CharcoalButtonVariant.primary,
            fullWidth: true,
            onPressed: _submitting ? null : _submit,
            child: Text(
              _submitting ? widget.submittingLabel : widget.submitLabel,
            ),
          ),
          CharcoalButton(
            fullWidth: true,
            onPressed: _submitting ? null : () => Navigator.of(context).pop(),
            child: Text(widget.cancelLabel),
          ),
        ],
        child: FocusScope(
          descendantsAreFocusable: !_submitting,
          child: AbsorbPointer(
            absorbing: _submitting,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.description != null) ...<Widget>[
                  Text(
                    widget.description!,
                    style: theme.style(
                      CharcoalTextRole.body,
                      color: theme.colors.textSecondary,
                    ),
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
                        style: theme.style(
                          CharcoalTextRole.caption,
                          color: theme.colors.textNegative,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
