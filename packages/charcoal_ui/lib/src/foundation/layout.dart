import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A step of the theme's spacing scale.
///
/// Layout code names a step; the number comes from the active pack
/// (`CharcoalTheme.space`). Pages and components never write a spacing literal.
enum CharcoalSpace {
  /// `space.xxs`: hairline gaps.
  xxs,

  /// `space.xs`: icon and label, title and subtitle.
  xs,

  /// `space.sm`: sibling controls.
  sm,

  /// `space.md`: form fields.
  md,

  /// `space.lg`: card padding.
  lg,

  /// `space.xl`: dialog padding.
  xl,

  /// `space.xxl`: section separation.
  xxl,

  /// `space.xxxl`: page-level breathing room.
  xxxl;

  /// This step's extent in [scale].
  double of(CharcoalSpaceScale scale) => switch (this) {
    CharcoalSpace.xxs => scale.xxs,
    CharcoalSpace.xs => scale.xs,
    CharcoalSpace.sm => scale.sm,
    CharcoalSpace.md => scale.md,
    CharcoalSpace.lg => scale.lg,
    CharcoalSpace.xl => scale.xl,
    CharcoalSpace.xxl => scale.xxl,
    CharcoalSpace.xxxl => scale.xxxl,
  };

  /// This step's extent under the theme in [context].
  double resolve(BuildContext context) => of(CharcoalTheme.of(context).space);
}

/// An empty box of one spacing step, in the main axis of its parent flex.
///
/// Inside a [Row] it is [step] wide, inside a [Column] it is [step] high. Use
/// [CharcoalGap.horizontal] or [CharcoalGap.vertical] outside a flex.
class CharcoalGap extends StatelessWidget {
  /// A gap of [step] along the parent's main axis.
  const CharcoalGap(this.step, {super.key}) : _axis = null;

  /// A gap of [step] wide.
  const CharcoalGap.horizontal(this.step, {super.key}) : _axis = Axis.horizontal;

  /// A gap of [step] high.
  const CharcoalGap.vertical(this.step, {super.key}) : _axis = Axis.vertical;

  /// The spacing step.
  final CharcoalSpace step;

  final Axis? _axis;

  @override
  Widget build(BuildContext context) {
    final extent = step.resolve(context);
    // Without an explicit axis the gap follows the nearest enclosing flex (a Row, a Column or any
    // other Flex), like Flutter's Spacer.
    var axis = _axis;
    if (axis == null) {
      context.visitAncestorElements((element) {
        final widget = element.widget;
        if (widget is Flex) {
          axis = widget.direction;
          return false;
        }
        return true;
      });
    }
    return axis == Axis.horizontal ? SizedBox(width: extent) : SizedBox(height: extent);
  }
}

/// [EdgeInsets] built from spacing steps. Not a widget; resolve with a [BuildContext].
@immutable
class CharcoalInset {
  /// The same [step] on every side.
  const CharcoalInset.all(CharcoalSpace step)
    : left = step,
      top = step,
      right = step,
      bottom = step;

  /// [horizontal] on left and right, [vertical] on top and bottom.
  const CharcoalInset.symmetric({CharcoalSpace? horizontal, CharcoalSpace? vertical})
    : left = horizontal,
      top = vertical,
      right = horizontal,
      bottom = vertical;

  /// Individual sides; a null side is zero.
  const CharcoalInset.only({this.left, this.top, this.right, this.bottom});

  /// Left step, or null for zero.
  final CharcoalSpace? left;

  /// Top step, or null for zero.
  final CharcoalSpace? top;

  /// Right step, or null for zero.
  final CharcoalSpace? right;

  /// Bottom step, or null for zero.
  final CharcoalSpace? bottom;

  /// The insets under the theme in [context].
  EdgeInsets resolve(BuildContext context) {
    final scale = CharcoalTheme.of(context).space;
    return EdgeInsets.only(
      left: left?.of(scale) ?? 0,
      top: top?.of(scale) ?? 0,
      right: right?.of(scale) ?? 0,
      bottom: bottom?.of(scale) ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CharcoalInset &&
      other.left == left &&
      other.top == top &&
      other.right == right &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);
}

/// [Padding] whose insets are spacing steps of the active theme.
class CharcoalPadding extends StatelessWidget {
  /// Pads [child] by [padding].
  const CharcoalPadding({required this.padding, this.child, super.key});

  /// The same [step] on every side.
  CharcoalPadding.all(CharcoalSpace step, {this.child, super.key})
    : padding = CharcoalInset.all(step);

  /// The insets, as steps.
  final CharcoalInset padding;

  /// The padded widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(padding: padding.resolve(context), child: child);
}
