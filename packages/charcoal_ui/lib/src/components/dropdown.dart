import 'dart:math' as math;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/component_tokens.dart';
import 'clickable.dart';
import 'field_label.dart';

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
      final theme = CharcoalTheme.of(context);
      final tokens = theme.components.dropdown;
      final origin = renderObject.localToGlobal(Offset.zero);
      final viewport = MediaQuery.maybeSizeOf(context);
      _menuWidth = renderObject.size.width;
      _menuMaxHeight = tokens.menuMaxHeight;
      _openAbove = false;
      if (viewport != null) {
        final viewportMargin = tokens.optionPaddingHorizontal;
        final below = math.max(
          0.0,
          viewport.height - origin.dy - renderObject.size.height - tokens.menuGap - viewportMargin,
        );
        final above = math.max(0.0, origin.dy - tokens.menuGap - viewportMargin);
        final estimatedHeight = math.min(
          tokens.menuMaxHeight,
          widget.options.length * tokens.optionMinHeight + tokens.menuPaddingVertical * 2,
        );
        _openAbove = below < estimatedHeight && above > below;
        _menuMaxHeight = math.min(tokens.menuMaxHeight, _openAbove ? above : below);
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
          duration: CharcoalTheme.of(context).components.dropdown.animationDuration,
          curve: CharcoalMotion.emphasizedCurve,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.dropdown;
    final selectedIndex = _selectedIndex;
    final selectedOption = selectedIndex == null ? null : widget.options[selectedIndex];
    final isPlaceholder = selectedOption == null;
    final visibleText = selectedOption?.label ?? widget.placeholder ?? '';
    final assistiveText = widget.assistiveText;

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
                final background = tokens.background.resolve(states);
                final ringColor = widget.invalid ? tokens.invalidRingColor : tokens.focusRingColor;
                return AnimatedContainer(
                  duration: tokens.animationDuration,
                  curve: CharcoalMotion.standardCurve,
                  height: tokens.height,
                  padding: EdgeInsets.symmetric(horizontal: tokens.paddingHorizontal),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radius),
                    boxShadow: focused || widget.invalid
                        ? <BoxShadow>[
                            BoxShadow(
                              color: ringColor,
                              spreadRadius: tokens.focusRingWidth,
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
                            color: isPlaceholder ? tokens.placeholderColor : tokens.foregroundColor,
                            fontFamily: theme.typography.fontFamily.sans,
                            fontSize: tokens.fontSize,
                            fontWeight: tokens.fontWeight,
                            height: tokens.lineHeight / tokens.fontSize,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                      SizedBox(width: tokens.gap),
                      CharcoalIcon(
                        CharcoalIcons16.chevronDown,
                        color: tokens.iconColor,
                        size: tokens.iconSize,
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
      duration: tokens.animationDuration,
      opacity: _enabled ? 1 : tokens.disabledOpacity,
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
            SizedBox(height: tokens.gap),
          ],
          dropdown,
          if (assistiveText != null && assistiveText.isNotEmpty) ...<Widget>[
            SizedBox(height: tokens.gap),
            Text(
              assistiveText,
              style: theme.textStyles.captionMedium.copyWith(
                color: widget.invalid
                    ? tokens.invalidAssistiveTextColor
                    : tokens.assistiveTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final direction = Directionality.of(context);
    final start = direction == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight;
    final targetAnchor = _openAbove ? Alignment(start.x, -1) : Alignment(start.x, 1);
    final followerAnchor = _openAbove ? Alignment(start.x, 1) : Alignment(start.x, -1);
    final tokens = CharcoalTheme.of(context).components.dropdown;
    final width = _menuWidth > 0
        ? _menuWidth
        : MediaQuery.maybeSizeOf(context)?.width ?? tokens.menuMaxHeight;

    return CompositedTransformFollower(
      followerAnchor: followerAnchor,
      link: _layerLink,
      offset: Offset(0, _openAbove ? -tokens.menuGap : tokens.menuGap),
      showWhenUnlinked: false,
      targetAnchor: targetAnchor,
      child: TapRegion(
        groupId: _tapRegionGroup,
        child: SizedBox(
          width: width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: tokens.menuBorderColor,
                width: tokens.menuBorderWidth,
              ),
              borderRadius: BorderRadius.circular(tokens.menuRadius),
              color: tokens.menuBackgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(tokens.menuRadius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: _menuMaxHeight > 0 ? _menuMaxHeight : tokens.menuMaxHeight,
                ),
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: tokens.menuPaddingVertical),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (var index = 0; index < widget.options.length; index++)
                          _buildOption(context, index, tokens),
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

  Widget _buildOption(BuildContext context, int index, CharcoalDropdownTokens tokens) {
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
            duration: tokens.animationDuration,
            opacity: disabled ? tokens.optionDisabledOpacity : 1,
            child: AnimatedContainer(
              duration: tokens.animationDuration,
              curve: CharcoalMotion.standardCurve,
              constraints: BoxConstraints(minHeight: tokens.optionMinHeight),
              padding: EdgeInsets.symmetric(horizontal: tokens.optionPaddingHorizontal),
              color: tokens.optionBackground.resolve(effectiveStates),
              child: Row(
                children: <Widget>[
                  SizedBox.square(
                    dimension: tokens.iconSize,
                    child: selected
                        ? CharcoalIcon(
                            CharcoalIcons.check,
                            color: tokens.optionCheckColor,
                            size: tokens.iconSize,
                          )
                        : null,
                  ),
                  SizedBox(width: tokens.optionGap),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: tokens.menuPaddingVertical),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            option.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: tokens.optionPrimaryColor,
                              fontFamily: theme.typography.fontFamily.sans,
                              fontSize: tokens.fontSize,
                              fontWeight: tokens.fontWeight,
                              height: tokens.lineHeight / tokens.fontSize,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          if (option.secondary case final secondary?) ...<Widget>[
                            Text(
                              secondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: tokens.optionSecondaryColor,
                                fontFamily: theme.typography.fontFamily.sans,
                                fontSize: tokens.optionSecondaryFontSize,
                                fontWeight: tokens.fontWeight,
                                height:
                                    tokens.optionSecondaryLineHeight /
                                    tokens.optionSecondaryFontSize,
                                leadingDistribution: TextLeadingDistribution.even,
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
