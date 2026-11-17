import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../actions/control_support.dart';
import '../layout/row_surface.dart';
import 'radio_indicator.dart';

/// One option of [CharcoalRadioCards].
@immutable
final class CharcoalRadioCardOption<T> {
  /// An option for [value] titled [title].
  const CharcoalRadioCardOption({
    required this.value,
    required this.title,
    this.description,
    this.enabled = true,
    this.trailing,
  });

  /// The value this option stands for; unique within the group.
  final T value;

  /// The option's name.
  final String title;

  /// What choosing it means, under the title.
  final String? description;

  /// Whether the option can be chosen. A disabled option stays readable but is greyed and
  /// skipped by the arrow keys.
  final bool enabled;

  /// A widget at the end of the card, such as a status chip.
  final Widget? trailing;
}

/// A single choice among a few options that each need a sentence of explanation, shown as
/// stacked cards with a radio indicator, a title and a description.
///
/// The caller owns [value] and replaces it from [onChanged]; the previous and next cards change in
/// the same frame. The chosen card is filled with the info surface and outlined in the selected
/// border colour. The group is one tab stop (the chosen option, or the first enabled one); the
/// arrow keys move the choice to the next or previous enabled option, wrapping, as in a radio
/// group, and Space or Enter chooses the focused option. A null [onChanged] disables every option.
///
/// Frame it with `CharcoalFormField` for a label, required or optional marker and help text.
///
/// ```dart
/// CharcoalRadioCards<String>(
///   value: endpoint,
///   onChanged: (value) => setState(() => endpoint = value),
///   options: const [
///     CharcoalRadioCardOption(value: '', title: 'Not set', description: 'Keep the current routing'),
///     CharcoalRadioCardOption(value: 'x3k9', title: 'Whisper large-v3', description: 'x3k9'),
///   ],
/// )
/// ```
final class CharcoalRadioCards<T> extends StatefulWidget {
  /// Creates the cards for [options] with [value] chosen.
  const CharcoalRadioCards({
    required this.value,
    required this.options,
    this.onChanged,
    super.key,
  });

  /// The chosen value, or null for none.
  final T? value;

  /// The options, top to bottom.
  final List<CharcoalRadioCardOption<T>> options;

  /// Reports the value of the option the user chooses; null disables the group.
  final ValueChanged<T>? onChanged;

  @override
  State<CharcoalRadioCards<T>> createState() => _CharcoalRadioCardsState<T>();
}

final class _CharcoalRadioCardsState<T> extends State<CharcoalRadioCards<T>> {
  final List<FocusNode> _nodes = <FocusNode>[];

  bool _enabled(int index) => widget.onChanged != null && widget.options[index].enabled;

  void _syncNodes() {
    while (_nodes.length > widget.options.length) {
      _nodes.removeLast().dispose();
    }
    while (_nodes.length < widget.options.length) {
      _nodes.add(FocusNode(debugLabel: 'CharcoalRadioCards option ${_nodes.length}'));
    }
    // One tab stop: the chosen option, or the first enabled one.
    final chosen = widget.options.indexWhere((option) => option.value == widget.value);
    final stop = chosen >= 0 && _enabled(chosen)
        ? chosen
        : Iterable<int>.generate(widget.options.length).where(_enabled).firstOrNull;
    for (var i = 0; i < _nodes.length; i++) {
      _nodes[i].skipTraversal = i != stop;
    }
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return KeyEventResult.ignored;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final step = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowDown => 1,
      LogicalKeyboardKey.arrowUp => -1,
      LogicalKeyboardKey.arrowRight => rtl ? -1 : 1,
      LogicalKeyboardKey.arrowLeft => rtl ? 1 : -1,
      _ => 0,
    };
    final onChanged = widget.onChanged;
    final current = _nodes.indexWhere((node) => node.hasPrimaryFocus);
    if (step == 0 || onChanged == null || current < 0) return KeyEventResult.ignored;
    final count = widget.options.length;
    for (var offset = 1; offset < count; offset++) {
      final next = (current + step * offset) % count;
      if (!_enabled(next)) continue;
      onChanged(widget.options[next].value);
      _nodes[next].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    _syncNodes();
    final space = CharcoalTheme.of(context).space;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onKeyEvent: _handleKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < widget.options.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: space.sm),
            _card(i),
          ],
        ],
      ),
    );
  }

  Widget _card(int index) {
    final option = widget.options[index];
    final selected = option.value == widget.value;
    final onChanged = widget.onChanged;
    return MergeSemantics(
      child: CharcoalClickable(
        checked: selected,
        focusNode: _nodes[index],
        inMutuallyExclusiveGroup: true,
        onPressed: _enabled(index) ? () => onChanged!(option.value) : null,
        semanticButton: false,
        builder: (context, states) =>
            _RadioCard(option: option, selected: selected, states: states),
      ),
    );
  }
}

class _RadioCard extends StatelessWidget {
  const _RadioCard({required this.option, required this.selected, required this.states});

  final CharcoalRadioCardOption<Object?> option;
  final bool selected;
  final Set<WidgetState> states;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final space = theme.space;
    final disabled = states.contains(WidgetState.disabled);
    final titleStyle = theme.style(
      CharcoalTextRole.bodyBold,
      color: disabled ? colors.textTertiary : colors.text,
    );
    // The indicator sits on the title's first line.
    final line = MediaQuery.textScalerOf(context).scale(titleStyle.fontSize!) * titleStyle.height!;
    final indicatorTop = ((line - theme.metrics.radio.controlSize) / 2).clamp(0.0, line);
    final border = states.contains(WidgetState.focused)
        ? colors.borderFocus
        : selected
        ? colors.borderSelected
        : colors.borderSubtle;
    return AnimatedContainer(
      duration: theme.duration(context, theme.motion.fast),
      curve: theme.motion.curve,
      padding: EdgeInsets.all(space.md),
      decoration: BoxDecoration(
        color: charcoalRowFill(
          theme,
          disabled ? const <WidgetState>{} : states,
          selected: selected,
        ),
        border: Border.all(color: border, width: theme.borders.hairline),
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: indicatorTop),
            child: CharcoalDisabledFade(
              disabled: disabled,
              child: CharcoalRadioIndicator(selected: selected, states: states),
            ),
          ),
          SizedBox(width: space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(option.title, style: titleStyle),
                if (option.description case final description?) ...<Widget>[
                  SizedBox(height: space.xxs),
                  Text(
                    description,
                    style: theme.style(
                      CharcoalTextRole.caption,
                      color: disabled ? colors.textTertiary : colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (option.trailing case final trailing?) ...<Widget>[
            SizedBox(width: space.md),
            trailing,
          ],
        ],
      ),
    );
  }
}
