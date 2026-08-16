import 'dart:math' as math;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'field_label.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _DropdownSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const menuMaxHeight = 280.0;
  static const focusRingWidth = 4.0;
  static const iconSize = 16.0;
  static const labelFontSize = 14.0;
  static const labelLineHeight = 22.0;
}

/// One selectable value in a [CharcoalDropdown].
final class CharcoalDropdownOption<T> {
  const CharcoalDropdownOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.secondary,
  });

  final T value;
  final String label;
  final bool enabled;
  final String? secondary;
}

/// A controlled Charcoal V2 dropdown built without Material or Cupertino.
final class CharcoalDropdown<T> extends StatefulWidget {
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

  final List<CharcoalDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? assistiveText;
  final bool autofocus;
  final bool disabled;
  final FocusNode? focusNode;
  final bool invalid;
  final String label;
  final String? placeholder;
  final bool required;
  final String requiredText;
  final bool showLabel;
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
      _close(restoreFocus: true);
    } else {
      _open();
    }
  }

  void _open() {
    final renderObject = _triggerKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final dimensions = CharcoalTheme.of(context).dimensions;
      final menuGap = dimensions.space.component10;
      final viewportMargin = dimensions.space.layout30;
      final origin = renderObject.localToGlobal(Offset.zero);
      final viewport = MediaQuery.maybeSizeOf(context);
      _menuWidth = renderObject.size.width;
      _menuMaxHeight = _DropdownSpec.menuMaxHeight;
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
          _DropdownSpec.menuMaxHeight,
          widget.options.length * dimensions.space.targetM + dimensions.space.component30,
        );
        _openAbove = below < estimatedHeight && above > below;
        _menuMaxHeight = math.min(
          _DropdownSpec.menuMaxHeight,
          _openAbove ? above : below,
        );
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
    }
  }

  void _select(int index) {
    final option = widget.options[index];
    if (!_enabled || !option.enabled) {
      return;
    }
    widget.onChanged!(option.value);
    _close(restoreFocus: true);
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
          _select(activeIndex);
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
        Scrollable.ensureVisible(
          activeContext,
          alignment: 0.5,
          duration: CharcoalMotion.resolveDuration(
            context,
            _DropdownSpec.animationDuration,
          ),
          curve: CharcoalMotion.emphasizedCurve,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final selectedIndex = _selectedIndex;
    final selectedOption = selectedIndex == null ? null : widget.options[selectedIndex];
    final isPlaceholder = selectedOption == null;
    final visibleText = selectedOption?.label ?? widget.placeholder ?? '';
    final assistiveText = widget.assistiveText;
    final fieldGap = theme.dimensions.space.component10;

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
            child: CharcoalClickable(
              autofocus: widget.autofocus,
              expanded: _isOpen,
              focusNode: _focusNode,
              keyboardActivationEnabled: false,
              onFocusChange: (focused) {
                if (!focused && _isOpen) {
                  _close();
                }
              },
              onKeyEvent: _handleKeyEvent,
              onPressed: _enabled ? _toggle : null,
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
                  normal: theme.colors.containerSecondaryDefaultA,
                  hovered: theme.colors.containerSecondaryHoverA,
                  pressed: theme.colors.containerSecondaryPressA,
                  focused: theme.colors.containerSecondaryDefaultA,
                  selected: theme.colors.containerSecondaryPressA,
                );
                final ringColor = widget.invalid
                    ? theme.colors.borderNegative
                    : theme.colors.borderFocusLegacy;
                return AnimatedContainer(
                  duration: CharcoalMotion.resolveDuration(
                    context,
                    _DropdownSpec.animationDuration,
                  ),
                  curve: CharcoalMotion.standardCurve,
                  height: theme.dimensions.space.targetM,
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.dimensions.space.component20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.s,
                    ),
                    boxShadow: focused || widget.invalid
                        ? <BoxShadow>[
                            BoxShadow(
                              color: ringColor,
                              spreadRadius: _DropdownSpec.focusRingWidth,
                            ),
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
                          style: TextStyle(
                            color: isPlaceholder
                                ? theme.colors.textPlaceholderDefault
                                : theme.colors.textDefault,
                            fontFamily: theme.typography.fontFamily.sans,
                            fontSize: _DropdownSpec.labelFontSize,
                            fontWeight: theme.typography.fontWeight.regular,
                            height: _DropdownSpec.labelLineHeight / _DropdownSpec.labelFontSize,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                      SizedBox(width: fieldGap),
                      CharcoalIcon(
                        CharcoalIcons16.chevronDown,
                        color: theme.colors.iconSecondaryDefault,
                        size: _DropdownSpec.iconSize,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    return AnimatedOpacity(
      curve: CharcoalMotion.standardCurve,
      duration: CharcoalMotion.resolveDuration(
        context,
        _DropdownSpec.animationDuration,
      ),
      opacity: _enabled ? 1 : charcoalDisabledOpacity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.showLabel) ...<Widget>[
            CharcoalFieldLabel(
              label: widget.label,
              required: widget.required,
              requiredText: widget.requiredText,
              subLabel: widget.subLabel,
            ),
            SizedBox(height: fieldGap),
          ],
          dropdown,
          if (assistiveText != null && assistiveText.isNotEmpty) ...<Widget>[
            SizedBox(height: fieldGap),
            Text(
              assistiveText,
              style: charcoalTypographyStyle(
                context,
                color: widget.invalid
                    ? theme.colors.textNegativeDefault
                    : theme.colors.textSecondaryDefault,
                size: CharcoalTypographySize.size14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final direction = Directionality.of(context);
    final start = direction == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight;
    final targetAnchor = _openAbove ? Alignment(start.x, -1) : Alignment(start.x, 1);
    final followerAnchor = _openAbove ? Alignment(start.x, 1) : Alignment(start.x, -1);
    final width = _menuWidth > 0
        ? _menuWidth
        : MediaQuery.maybeSizeOf(context)?.width ?? _DropdownSpec.menuMaxHeight;
    final menuGap = theme.dimensions.space.component10;
    final menuRadius = theme.dimensions.radius.m;

    return CompositedTransformFollower(
      followerAnchor: followerAnchor,
      link: _layerLink,
      offset: Offset(0, _openAbove ? -menuGap : menuGap),
      showWhenUnlinked: false,
      targetAnchor: targetAnchor,
      child: TapRegion(
        groupId: _tapRegionGroup,
        child: SizedBox(
          width: width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colors.borderSecondary,
                width: theme.dimensions.borderWidth.m,
              ),
              borderRadius: BorderRadius.circular(menuRadius),
              color: theme.colors.backgroundDefault,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(menuRadius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: _menuMaxHeight > 0 ? _menuMaxHeight : _DropdownSpec.menuMaxHeight,
                ),
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: theme.dimensions.space.component20,
                    ),
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
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              _DropdownSpec.animationDuration,
            ),
            opacity: disabled ? charcoalDisabledOpacity : 1,
            child: AnimatedContainer(
              duration: CharcoalMotion.resolveDuration(
                context,
                _DropdownSpec.animationDuration,
              ),
              curve: CharcoalMotion.standardCurve,
              constraints: BoxConstraints(
                minHeight: theme.dimensions.space.targetM,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: theme.dimensions.space.component30,
              ),
              color: resolveCharcoalStateColor(
                effectiveStates,
                normal: theme.colors.backgroundDefault,
                hovered: theme.colors.containerSecondaryDefault,
                pressed: theme.colors.containerSecondaryPress,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox.square(
                    dimension: _DropdownSpec.iconSize,
                    child: selected
                        ? CharcoalIcon(
                            CharcoalIcons.check,
                            color: theme.colors.iconSecondaryDefault,
                            size: _DropdownSpec.iconSize,
                          )
                        : null,
                  ),
                  SizedBox(width: theme.dimensions.space.component10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: theme.dimensions.space.component20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            option.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: charcoalTypographyStyle(
                              context,
                              color: theme.colors.textSecondaryDefault,
                              size: CharcoalTypographySize.size14,
                            ),
                          ),
                          if (option.secondary case final secondary?) ...<Widget>[
                            Text(
                              secondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: charcoalTypographyStyle(
                                context,
                                color: theme.colors.textTertiaryDefault,
                                size: CharcoalTypographySize.size12,
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
