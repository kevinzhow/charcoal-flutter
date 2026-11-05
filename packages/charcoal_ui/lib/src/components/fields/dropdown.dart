import 'dart:math' as math;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import 'field_support.dart';

/// One selectable value in a [CharcoalDropdown].
final class CharcoalDropdownOption<T> {
  /// An option shown as [label], with an optional [secondary] line.
  const CharcoalDropdownOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.secondary,
  });

  /// The value reported on selection; unique within a dropdown.
  final T value;

  /// The visible and spoken label.
  final String label;

  /// Whether the option can be chosen.
  final bool enabled;

  /// A second, tertiary-coloured line.
  final String? secondary;
}

/// A controlled Charcoal dropdown: a field-like trigger and an anchored, keyboard-navigable list.
///
/// The menu is an [OverlayPortal] anchored to the trigger; it opens on the side with more room,
/// closes on outside tap, Escape and focus loss, and returns focus to the trigger on keyboard
/// selection.
final class CharcoalDropdown<T> extends StatefulWidget {
  /// Creates a dropdown over [options] showing [value]; [onChanged] null disables it.
  const CharcoalDropdown({
    required this.options,
    required this.value,
    required this.onChanged,
    this.assistiveText,
    this.autofocus = false,
    this.disabled = false,
    this.focusNode,
    this.invalid = false,
    this.label = '',
    this.placeholder,
    this.required = false,
    this.requiredText = '*Required',
    this.showLabel = false,
    this.subLabel,
    super.key,
  });

  /// The choices, in order; must not be empty.
  final List<CharcoalDropdownOption<T>> options;

  /// The selected value, or null for none.
  final T? value;

  /// Called with the chosen value; null disables the dropdown.
  final ValueChanged<T>? onChanged;

  /// Helper text below the dropdown.
  final String? assistiveText;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Whether the dropdown ignores input and focus.
  final bool disabled;

  /// The focus node; the dropdown owns one when null.
  final FocusNode? focusNode;

  /// Whether the selection is invalid.
  final bool invalid;

  /// The accessible label, also shown above the dropdown when [showLabel].
  final String label;

  /// Text shown while nothing is selected.
  final String? placeholder;

  /// Whether a selection is required.
  final bool required;

  /// The required marker text; pass the localized string.
  final String requiredText;

  /// Whether to show the label above the dropdown.
  final bool showLabel;

  /// Trailing label metadata.
  final Widget? subLabel;

  @override
  State<CharcoalDropdown<T>> createState() => _CharcoalDropdownState<T>();
}

final class _CharcoalDropdownState<T> extends State<CharcoalDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController(
    debugLabel: 'CharcoalDropdown',
  );
  final WidgetStatesController _statesController = WidgetStatesController();
  final GlobalKey _triggerKey = GlobalKey();
  final Object _tapRegionGroup = Object();

  late FocusNode _focusNode;
  late List<GlobalKey> _optionKeys;
  bool _isOpen = false;
  bool _openAbove = false;
  double _menuMaxHeight = 0;
  double _menuWidth = 0;
  int? _activeIndex;

  bool get _ownsFocusNode => widget.focusNode == null;
  bool get _enabled => !widget.disabled && widget.onChanged != null;

  int? get _selectedIndex {
    final index = widget.options.indexWhere((option) => option.value == widget.value);
    return index < 0 ? null : index;
  }

  @override
  void initState() {
    super.initState();
    assert(widget.options.isNotEmpty);
    assert(_dropdownValuesAreUnique(widget.options));
    _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'CharcoalDropdown');
    _optionKeys = List<GlobalKey>.generate(widget.options.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(CharcoalDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.options.isNotEmpty);
    assert(_dropdownValuesAreUnique(widget.options));
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'CharcoalDropdown');
    }
    if (oldWidget.options.length != widget.options.length) {
      _optionKeys = List<GlobalKey>.generate(widget.options.length, (_) => GlobalKey());
    }
    if (!_enabled && _isOpen) {
      _isOpen = false;
      _overlayController.hide();
    } else if (_isOpen) {
      _activeIndex = _initialActiveIndex();
      _scheduleActiveOptionVisibility();
    }
  }

  @override
  void dispose() {
    _statesController.dispose();
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  int? _initialActiveIndex() {
    final selectedIndex = _selectedIndex;
    if (selectedIndex != null && widget.options[selectedIndex].enabled) {
      return selectedIndex;
    }
    final firstEnabled = widget.options.indexWhere((option) => option.enabled);
    return firstEnabled < 0 ? null : firstEnabled;
  }

  void _toggle() {
    if (!_enabled) {
      return;
    }
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final renderObject = _triggerKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final theme = CharcoalTheme.of(context);
      final maxHeight = theme.metrics.dropdown.menuMaxHeight;
      final menuGap = theme.space.xs;
      final viewportMargin = theme.space.lg;
      final origin = renderObject.localToGlobal(Offset.zero);
      final viewport = MediaQuery.maybeSizeOf(context);
      _menuWidth = renderObject.size.width;
      _menuMaxHeight = maxHeight;
      _openAbove = false;
      if (viewport != null) {
        final below = math.max(
          0.0,
          viewport.height - origin.dy - renderObject.size.height - menuGap - viewportMargin,
        );
        final above = math.max(
          0.0,
          origin.dy - menuGap - viewportMargin,
        );
        final estimatedHeight = math.min(
          maxHeight,
          widget.options.length * theme.sizes.controlMd + theme.space.lg,
        );
        _openAbove = below < estimatedHeight && above > below;
        _menuMaxHeight = math.min(maxHeight, _openAbove ? above : below);
      }
    }

    _focusNode.requestFocus();
    setState(() {
      _activeIndex = _initialActiveIndex();
      _isOpen = true;
    });
    _overlayController.show();
    _scheduleActiveOptionVisibility();
  }

  void _close({bool restoreFocus = false}) {
    if (!_isOpen) {
      return;
    }
    _overlayController.hide();
    setState(() {
      _isOpen = false;
      _activeIndex = null;
    });
    if (restoreFocus && _enabled) {
      _focusNode.requestFocus();
    } else if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _select(int index, {bool restoreFocus = false}) {
    final option = widget.options[index];
    if (!_enabled || !option.enabled) {
      return;
    }
    widget.onChanged!(option.value);
    _close(restoreFocus: restoreFocus);
  }

  void _moveActive(int delta) {
    final enabledIndices = <int>[
      for (var index = 0; index < widget.options.length; index++)
        if (widget.options[index].enabled) index,
    ];
    if (enabledIndices.isEmpty) {
      return;
    }
    final currentPosition = enabledIndices.indexOf(_activeIndex ?? -1);
    final nextPosition = currentPosition < 0
        ? (delta > 0 ? 0 : enabledIndices.length - 1)
        : (currentPosition + delta) % enabledIndices.length;
    setState(() => _activeIndex = enabledIndices[nextPosition]);
    _scheduleActiveOptionVisibility();
  }

  void _moveToBoundary({required bool first}) {
    final enabledIndices = <int>[
      for (var index = 0; index < widget.options.length; index++)
        if (widget.options[index].enabled) index,
    ];
    if (enabledIndices.isEmpty) {
      return;
    }
    setState(() => _activeIndex = first ? enabledIndices.first : enabledIndices.last);
    _scheduleActiveOptionVisibility();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape && _isOpen) {
      _close(restoreFocus: true);
      return KeyEventResult.handled;
    }
    if (!_enabled) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (!_isOpen) {
        _open();
      } else {
        _moveActive(event.logicalKey == LogicalKeyboardKey.arrowDown ? 1 : -1);
      }
      return KeyEventResult.handled;
    }
    if (_isOpen && event.logicalKey == LogicalKeyboardKey.home) {
      _moveToBoundary(first: true);
      return KeyEventResult.handled;
    }
    if (_isOpen && event.logicalKey == LogicalKeyboardKey.end) {
      _moveToBoundary(first: false);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_isOpen) {
        final activeIndex = _activeIndex;
        if (activeIndex != null) {
          _select(activeIndex, restoreFocus: true);
        }
      } else {
        _open();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _scheduleActiveOptionVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isOpen) {
        return;
      }
      final activeIndex = _activeIndex;
      if (activeIndex == null || activeIndex >= _optionKeys.length) {
        return;
      }
      final activeContext = _optionKeys[activeIndex].currentContext;
      if (activeContext != null) {
        final theme = CharcoalTheme.of(context);
        Scrollable.ensureVisible(
          activeContext,
          alignment: 0.5,
          duration: theme.duration(context, theme.motion.standard),
          curve: theme.motion.emphasizedCurve,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final selectedIndex = _selectedIndex;
    final selectedOption = selectedIndex == null ? null : widget.options[selectedIndex];
    final isPlaceholder = selectedOption == null;
    final visibleText = selectedOption?.label ?? widget.placeholder ?? '';
    final assistiveText = widget.assistiveText;
    final errorHint = widget.invalid && assistiveText != null && assistiveText.isNotEmpty
        ? assistiveText
        : null;
    final fieldGap = theme.space.xs;
    final iconSize = theme.metrics.dropdown.iconSize;
    final duration = theme.duration(context, theme.motion.standard);

    final dropdown = OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        key: _triggerKey,
        link: _layerLink,
        child: TapRegion(
          groupId: _tapRegionGroup,
          onTapOutside: _isOpen ? (_) => _close() : null,
          child: ExcludeFocus(
            excluding: !_enabled,
            child: Semantics(
              isRequired: widget.required ? true : null,
              child: CharcoalClickable(
                autofocus: widget.autofocus,
                expanded: _isOpen,
                focusNode: _focusNode,
                keyboardActivationEnabled: false,
                onFocusChange: (focused) {
                  if (!focused && _isOpen) _close();
                },
                onKeyEvent: _handleKeyEvent,
                onPressed: _enabled ? _toggle : null,
                semanticHint: errorHint,
                semanticLabel: widget.label.isEmpty ? null : widget.label,
                semanticValue: visibleText.isEmpty ? null : visibleText,
                selected: _isOpen,
                statesController: _statesController,
                validationResult: widget.invalid
                    ? SemanticsValidationResult.invalid
                    : SemanticsValidationResult.none,
                builder: (context, states) {
                  final focused = states.contains(WidgetState.focused);
                  final background = resolveCharcoalStateColor(
                    states,
                    normal: colors.fillSecondary,
                    hovered: colors.fillSecondaryHover,
                    pressed: colors.fillSecondaryPress,
                    focused: colors.fillSecondary,
                    selected: colors.fillSecondaryPress,
                  );
                  final ringColor = widget.invalid ? colors.borderNegative : colors.focusRing;
                  return AnimatedContainer(
                    // Expanded state is persistent UI state, not a transient hover tween. Switch
                    // it atomically when the menu opens or closes so the pressed surface cannot
                    // linger.
                    key: ValueKey<bool>(_isOpen),
                    duration: duration,
                    curve: theme.motion.curve,
                    height: theme.sizes.controlMd,
                    padding: EdgeInsets.symmetric(horizontal: theme.space.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(theme.radius.sm),
                      boxShadow: focused || widget.invalid
                          ? <BoxShadow>[
                              BoxShadow(color: ringColor, spreadRadius: theme.borders.focusHalo),
                            ]
                          : const <BoxShadow>[],
                      color: background,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            visibleText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.style(
                              CharcoalTextRole.size14,
                              color: isPlaceholder ? colors.textPlaceholder : colors.text,
                            ),
                          ),
                        ),
                        SizedBox(width: fieldGap),
                        CharcoalIcon(
                          CharcoalIcons16.chevronDown,
                          color: colors.iconSecondary,
                          size: iconSize,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    return AnimatedOpacity(
      curve: theme.motion.curve,
      duration: duration,
      opacity: _enabled ? 1 : theme.metrics.clickable.disabledOpacity,
      child: CharcoalFieldFrame(
        assistiveText: assistiveText,
        invalid: widget.invalid,
        label: widget.label,
        required: widget.required,
        requiredText: widget.requiredText,
        showLabel: widget.showLabel,
        subLabel: widget.subLabel,
        field: dropdown,
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final direction = Directionality.of(context);
    final start = direction == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight;
    final targetAnchor = _openAbove ? Alignment(start.x, -1) : Alignment(start.x, 1);
    final followerAnchor = _openAbove ? Alignment(start.x, 1) : Alignment(start.x, -1);
    final maxHeight = theme.metrics.dropdown.menuMaxHeight;
    final width = _menuWidth > 0 ? _menuWidth : MediaQuery.maybeSizeOf(context)?.width ?? maxHeight;
    final menuGap = theme.space.xs;
    final menuRadius = theme.radius.md;

    // OverlayPortal lays an unpositioned child out with the overlay's tight constraints. Give the
    // follower an explicit width and a loose height so the menu can shrink-wrap instead of
    // becoming a full-screen surface.
    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        followerAnchor: followerAnchor,
        link: _layerLink,
        offset: Offset(0, _openAbove ? -menuGap : menuGap),
        showWhenUnlinked: false,
        targetAnchor: targetAnchor,
        child: TapRegion(
          groupId: _tapRegionGroup,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.borderSubtle, width: theme.borders.hairline),
              borderRadius: BorderRadius.circular(menuRadius),
              color: theme.colors.background,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(menuRadius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: _menuMaxHeight > 0 ? _menuMaxHeight : maxHeight,
                ),
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: theme.space.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (var index = 0; index < widget.options.length; index++)
                          _buildOption(context, index),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final iconSize = theme.metrics.dropdown.iconSize;
    final duration = theme.duration(context, theme.motion.standard);
    final option = widget.options[index];
    final selected = index == _selectedIndex;
    final active = index == _activeIndex;
    return MouseRegion(
      key: _optionKeys[index],
      onEnter: option.enabled ? (_) => setState(() => _activeIndex = index) : null,
      child: CharcoalClickable(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        onPressed: _enabled && option.enabled ? () => _select(index) : null,
        semanticButton: false,
        semanticLabel: option.label,
        selected: selected,
        builder: (context, states) {
          final effectiveStates = active && !states.contains(WidgetState.disabled)
              ? <WidgetState>{...states, WidgetState.hovered}
              : states;
          final disabled = effectiveStates.contains(WidgetState.disabled);
          return AnimatedOpacity(
            curve: theme.motion.curve,
            duration: duration,
            opacity: disabled ? theme.metrics.clickable.disabledOpacity : 1,
            child: AnimatedContainer(
              duration: duration,
              curve: theme.motion.curve,
              constraints: BoxConstraints(minHeight: theme.sizes.controlMd),
              padding: EdgeInsets.symmetric(horizontal: theme.space.lg),
              color: resolveCharcoalStateColor(
                effectiveStates,
                normal: colors.background,
                hovered: colors.surfaceSecondary,
                pressed: colors.surfaceSecondaryPress,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox.square(
                    dimension: iconSize,
                    child: selected
                        ? CharcoalIcon(
                            CharcoalIcons.check,
                            color: colors.iconSecondary,
                            size: iconSize,
                          )
                        : null,
                  ),
                  SizedBox(width: theme.space.xs),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: theme.space.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            option.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.style(
                              CharcoalTextRole.size14,
                              color: colors.textSecondary,
                            ),
                          ),
                          if (option.secondary case final secondary?) ...<Widget>[
                            Text(
                              secondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.style(
                                CharcoalTextRole.size12,
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

bool _dropdownValuesAreUnique<T>(List<CharcoalDropdownOption<T>> options) {
  final values = <T>{};
  return options.every((option) => values.add(option.value));
}
