import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show TimeOfDay, showDatePicker, showTimePicker;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import 'field_support.dart';

/// Picks a moment for a [CharcoalDateTimeField]; returns null when cancelled.
typedef CharcoalDateTimePicker = Future<DateTime?> Function(
  BuildContext context,
  DateTime? current,
);

/// Years either side of today offered by the default picker.
const _pickerYearSpan = 5;

/// Formats [value] as `2026-09-13 14:20` in local time: the one date-time format of Charcoal forms.
String formatCharcoalDateTime(DateTime value) {
  final local = value.toLocal();
  return '${formatCharcoalDate(local)} '
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

/// Formats [value] as `2026-09-13` in local time, for values where the time of day is noise.
String formatCharcoalDate(DateTime value) {
  final local = value.toLocal();
  return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

/// Formats [value] as `14:20` in local time.
String formatCharcoalTime(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

/// What a [CharcoalDateTimeField] picks and shows.
enum CharcoalDateTimeMode {
  /// A calendar date, shown as `2026-09-13`; the picked value is midnight local time.
  date,

  /// A date then a time, shown as `2026-09-13 14:20`.
  dateTime,

  /// A time of day, shown as `14:20`; the date part is that of the current value, or today.
  time;

  /// Formats [value] for this mode.
  String format(DateTime value) => switch (this) {
    CharcoalDateTimeMode.date => formatCharcoalDate(value),
    CharcoalDateTimeMode.dateTime => formatCharcoalDateTime(value),
    CharcoalDateTimeMode.time => formatCharcoalTime(value),
  };
}

/// Opens the platform date picker on [current] (today when null).
///
/// The picker spans [_pickerYearSpan] years either side of today, widened to the day of [current]
/// when that lies outside: the platform picker rejects an initial date outside its range, and a
/// stored value can be older or further ahead than the span.
Future<DateTime?> _showDatePicker(BuildContext context, DateTime? current) {
  final now = DateTime.now();
  final initial = current ?? now;
  final first = DateTime(now.year - _pickerYearSpan);
  final last = DateTime(now.year + _pickerYearSpan);
  final initialDay = DateTime(initial.year, initial.month, initial.day);
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: initialDay.isBefore(first) ? initialDay : first,
    lastDate: initialDay.isAfter(last) ? initialDay : last,
  );
}

Future<DateTime?> _pickDate(BuildContext context, DateTime? current) async {
  final date = await _showDatePicker(context, current);
  return date == null ? null : DateTime(date.year, date.month, date.day);
}

Future<DateTime?> _pickTime(BuildContext context, DateTime? current) async {
  final base = current ?? DateTime.now();
  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(base));
  return time == null ? null : DateTime(base.year, base.month, base.day, time.hour, time.minute);
}

Future<DateTime?> _pickDateAndTime(BuildContext context, DateTime? current) async {
  final date = await _showDatePicker(context, current);
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(current ?? DateTime.now()),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// A date, date-and-time or time picker rendered as a field ([mode]).
///
/// Shows the chosen moment with a clear affordance, because an accidentally set time can silently
/// hide content from everyone. Tapping opens [picker] (the platform date then time dialogs by
/// default).
class CharcoalDateTimeField extends StatelessWidget {
  /// A field labelled [label] showing [value].
  const CharcoalDateTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.clearText = 'Clear',
    this.emptyText = 'Not set',
    this.hint,
    this.mode = CharcoalDateTimeMode.dateTime,
    this.picker,
    super.key,
  });

  /// The label above the field.
  final String label;

  /// The chosen moment, or null.
  final DateTime? value;

  /// Called with the picked moment, or null when cleared; null disables the field.
  final ValueChanged<DateTime?>? onChanged;

  /// Label of the clear button; pass the localized string.
  final String clearText;

  /// Text shown while [value] is null; pass the localized string.
  final String emptyText;

  /// Muted text under the field.
  final String? hint;

  /// What the field picks and shows.
  final CharcoalDateTimeMode mode;

  /// Opens the picker; replace to use another dialog. Defaults to the platform dialogs of [mode].
  final CharcoalDateTimePicker? picker;

  Future<void> _pick(BuildContext context) async {
    final open =
        picker ??
        switch (mode) {
          CharcoalDateTimeMode.date => _pickDate,
          CharcoalDateTimeMode.dateTime => _pickDateAndTime,
          CharcoalDateTimeMode.time => _pickTime,
        };
    final picked = await open(context, value);
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final enabled = onChanged != null;
    final current = value;
    Widget surface(Set<WidgetState> states, Widget child) => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.sm),
        color: resolveCharcoalStateColor(
          states,
          normal: colors.fillSecondary,
          hovered: colors.fillSecondaryHover,
          pressed: colors.fillSecondaryPress,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: theme.sizes.controlMd),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.space.sm),
          child: child,
        ),
      ),
    );
    return CharcoalFieldFrame(
      label: label,
      showLabel: true,
      assistiveText: hint,
      field: Row(
        children: <Widget>[
          Expanded(
            child: CharcoalClickable(
              onPressed: enabled ? () => _pick(context) : null,
              semanticLabel: label,
              semanticValue: current == null ? emptyText : mode.format(current),
              builder: (context, states) => surface(
                states,
                Row(
                  children: <Widget>[
                    CharcoalIcon(
                      mode == CharcoalDateTimeMode.date
                          ? CharcoalIcons.calendar
                          : CharcoalIcons.history,
                      color: colors.iconSecondary,
                      size: theme.metrics.textField.iconSize,
                    ),
                    SizedBox(width: theme.metrics.textField.contentGap),
                    Expanded(
                      child: Text(
                        current == null ? emptyText : mode.format(current),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.style(
                          CharcoalTextRole.size14,
                          color: current == null ? colors.textPlaceholder : colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (current != null && enabled) ...<Widget>[
            SizedBox(width: theme.space.sm),
            CharcoalClickable(
              onPressed: () => onChanged!(null),
              semanticLabel: clearText,
              builder: (context, states) => surface(
                states,
                Center(
                  widthFactor: 1,
                  child: Text(
                    clearText,
                    style: theme.style(
                      CharcoalTextRole.size14,
                      bold: true,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
