import 'package:flutter/material.dart';

/// A slider in the theme's primary colour.
///
/// A themed Material `Slider` (the Charcoal slider theme colours the track and thumb), wrapped in
/// a transparent `Material` so it works on any page. [onChanged] receives every drag value; a null
/// callback disables the slider.
class CharcoalSlider extends StatelessWidget {
  /// Creates a slider for [value] between [min] and [max].
  const CharcoalSlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.semanticLabel,
    super.key,
  });

  /// The current value.
  final double value;

  /// Reports the dragged value; null disables the slider.
  final ValueChanged<double>? onChanged;

  /// The lowest value.
  final double min;

  /// The highest value.
  final double max;

  /// Number of discrete steps, or null for a continuous slider.
  final int? divisions;

  /// The bubble shown while dragging.
  final String? label;

  /// Semantics label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Semantics(
        container: semanticLabel != null,
        label: semanticLabel,
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
