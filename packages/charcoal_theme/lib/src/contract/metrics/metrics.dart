// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

import 'artwork.dart';
import 'balloon.dart';
import 'button.dart';
import 'carousel.dart';
import 'checkbox.dart';
import 'clickable.dart';
import 'dropdown.dart';
import 'field.dart';
import 'hint.dart';
import 'icon_button.dart';
import 'modal.dart';
import 'multi_select.dart';
import 'navigation_bar.dart';
import 'navigation_item.dart';
import 'page_route.dart';
import 'pagination.dart';
import 'popup.dart';
import 'radio.dart';
import 'scaffold.dart';
import 'segmented.dart';
import 'selection_toolbar.dart';
import 'spinner.dart';
import 'switch.dart';
import 'tab_bar.dart';
import 'tag.dart';
import 'text_area.dart';
import 'text_editing.dart';
import 'text_field.dart';
import 'toast.dart';
import 'tooltip.dart';

export 'artwork.dart';
export 'balloon.dart';
export 'button.dart';
export 'carousel.dart';
export 'checkbox.dart';
export 'clickable.dart';
export 'dropdown.dart';
export 'field.dart';
export 'hint.dart';
export 'icon_button.dart';
export 'modal.dart';
export 'multi_select.dart';
export 'navigation_bar.dart';
export 'navigation_item.dart';
export 'page_route.dart';
export 'pagination.dart';
export 'popup.dart';
export 'radio.dart';
export 'scaffold.dart';
export 'segmented.dart';
export 'selection_toolbar.dart';
export 'spinner.dart';
export 'switch.dart';
export 'tab_bar.dart';
export 'tag.dart';
export 'text_area.dart';
export 'text_editing.dart';
export 'text_field.dart';
export 'toast.dart';
export 'tooltip.dart';

/// Component geometry that is not a shared scale, one typed block per component family.
///
/// Replaces the private `_*Spec` constants of the pre-Material `charcoal_ui`. Component code reads
/// these; it never writes the numbers.
@immutable
class CharcoalMetrics {
  /// Creates the full set.
  const CharcoalMetrics({
    required this.button,
    required this.iconButton,
    required this.switchToggle,
    required this.checkbox,
    required this.radio,
    required this.multiSelect,
    required this.segmented,
    required this.tag,
    required this.field,
    required this.textField,
    required this.textArea,
    required this.dropdown,
    required this.hint,
    required this.spinner,
    required this.modal,
    required this.toast,
    required this.tooltip,
    required this.balloon,
    required this.carousel,
    required this.pagination,
    required this.navigationItem,
    required this.tabBar,
    required this.navigationBar,
    required this.clickable,
    required this.popup,
    required this.textEditing,
    required this.selectionToolbar,
    required this.pageRoute,
    required this.scaffold,
    required this.artwork,
  });

  /// Geometry of the pill button beyond the shared control heights.
  final CharcoalButtonMetrics button;

  /// Icon-button hit areas and glyph sizes.
  final CharcoalIconButtonMetrics iconButton;

  /// The 51x31 switch (UISwitch geometry used by Charcoal SwiftUI).
  final CharcoalSwitchMetrics switchToggle;

  /// Checkbox box, check glyph and focus offsets.
  final CharcoalCheckboxMetrics checkbox;

  /// Radio button.
  final CharcoalRadioMetrics radio;

  /// Multi-select selection box.
  final CharcoalMultiSelectMetrics multiSelect;

  /// Segmented control.
  final CharcoalSegmentedMetrics segmented;

  /// Tag item.
  final CharcoalTagMetrics tag;

  /// Field label and secondary label.
  final CharcoalFieldMetrics field;

  /// Single-line text field.
  final CharcoalTextFieldMetrics textField;

  /// Multi-line text area.
  final CharcoalTextAreaMetrics textArea;

  /// Dropdown trigger and menu.
  final CharcoalDropdownMetrics dropdown;

  /// Hint text and its info glyph.
  final CharcoalHintMetrics hint;

  /// Loading spinner and its overlay.
  final CharcoalSpinnerMetrics spinner;

  /// Dialog and bottom sheet.
  final CharcoalModalMetrics modal;

  /// Toast and snack bar.
  final CharcoalToastMetrics toast;

  /// Tooltip bubble.
  final CharcoalTooltipMetrics tooltip;

  /// Balloon (popover with arrow and close).
  final CharcoalBalloonMetrics balloon;

  /// Carousel.
  final CharcoalCarouselMetrics carousel;

  /// Pagination.
  final CharcoalPaginationMetrics pagination;

  /// Navigation row.
  final CharcoalNavigationItemMetrics navigationItem;

  /// Bottom tab bar.
  final CharcoalTabBarMetrics tabBar;

  /// Top navigation bar.
  final CharcoalNavigationBarMetrics navigationBar;

  /// Shared interaction behaviour.
  final CharcoalClickableMetrics clickable;

  /// Popup shape painter (tooltip and balloon outline).
  final CharcoalPopupMetrics popup;

  /// Text editing chrome shared by fields: cursor, handles, magnifier.
  final CharcoalTextEditingMetrics textEditing;

  /// Text selection toolbar placement.
  final CharcoalSelectionToolbarMetrics selectionToolbar;

  /// Page transition and predictive back.
  final CharcoalPageRouteMetrics pageRoute;

  /// Scaffold and system chrome.
  final CharcoalScaffoldMetrics scaffold;

  /// Placeholder artwork for content without an image.
  final CharcoalArtworkMetrics artwork;

  /// A copy with the given families replaced.
  CharcoalMetrics copyWith({
    CharcoalButtonMetrics? button,
    CharcoalIconButtonMetrics? iconButton,
    CharcoalSwitchMetrics? switchToggle,
    CharcoalCheckboxMetrics? checkbox,
    CharcoalRadioMetrics? radio,
    CharcoalMultiSelectMetrics? multiSelect,
    CharcoalSegmentedMetrics? segmented,
    CharcoalTagMetrics? tag,
    CharcoalFieldMetrics? field,
    CharcoalTextFieldMetrics? textField,
    CharcoalTextAreaMetrics? textArea,
    CharcoalDropdownMetrics? dropdown,
    CharcoalHintMetrics? hint,
    CharcoalSpinnerMetrics? spinner,
    CharcoalModalMetrics? modal,
    CharcoalToastMetrics? toast,
    CharcoalTooltipMetrics? tooltip,
    CharcoalBalloonMetrics? balloon,
    CharcoalCarouselMetrics? carousel,
    CharcoalPaginationMetrics? pagination,
    CharcoalNavigationItemMetrics? navigationItem,
    CharcoalTabBarMetrics? tabBar,
    CharcoalNavigationBarMetrics? navigationBar,
    CharcoalClickableMetrics? clickable,
    CharcoalPopupMetrics? popup,
    CharcoalTextEditingMetrics? textEditing,
    CharcoalSelectionToolbarMetrics? selectionToolbar,
    CharcoalPageRouteMetrics? pageRoute,
    CharcoalScaffoldMetrics? scaffold,
    CharcoalArtworkMetrics? artwork,
  }) => CharcoalMetrics(
    button: button ?? this.button,
    iconButton: iconButton ?? this.iconButton,
    switchToggle: switchToggle ?? this.switchToggle,
    checkbox: checkbox ?? this.checkbox,
    radio: radio ?? this.radio,
    multiSelect: multiSelect ?? this.multiSelect,
    segmented: segmented ?? this.segmented,
    tag: tag ?? this.tag,
    field: field ?? this.field,
    textField: textField ?? this.textField,
    textArea: textArea ?? this.textArea,
    dropdown: dropdown ?? this.dropdown,
    hint: hint ?? this.hint,
    spinner: spinner ?? this.spinner,
    modal: modal ?? this.modal,
    toast: toast ?? this.toast,
    tooltip: tooltip ?? this.tooltip,
    balloon: balloon ?? this.balloon,
    carousel: carousel ?? this.carousel,
    pagination: pagination ?? this.pagination,
    navigationItem: navigationItem ?? this.navigationItem,
    tabBar: tabBar ?? this.tabBar,
    navigationBar: navigationBar ?? this.navigationBar,
    clickable: clickable ?? this.clickable,
    popup: popup ?? this.popup,
    textEditing: textEditing ?? this.textEditing,
    selectionToolbar: selectionToolbar ?? this.selectionToolbar,
    pageRoute: pageRoute ?? this.pageRoute,
    scaffold: scaffold ?? this.scaffold,
    artwork: artwork ?? this.artwork,
  );

  /// Every family by name, each as its own field map.
  Map<String, Map<String, Object?>> toMap() => <String, Map<String, Object?>>{
    'button': button.toMap(),
    'iconButton': iconButton.toMap(),
    'switchToggle': switchToggle.toMap(),
    'checkbox': checkbox.toMap(),
    'radio': radio.toMap(),
    'multiSelect': multiSelect.toMap(),
    'segmented': segmented.toMap(),
    'tag': tag.toMap(),
    'field': field.toMap(),
    'textField': textField.toMap(),
    'textArea': textArea.toMap(),
    'dropdown': dropdown.toMap(),
    'hint': hint.toMap(),
    'spinner': spinner.toMap(),
    'modal': modal.toMap(),
    'toast': toast.toMap(),
    'tooltip': tooltip.toMap(),
    'balloon': balloon.toMap(),
    'carousel': carousel.toMap(),
    'pagination': pagination.toMap(),
    'navigationItem': navigationItem.toMap(),
    'tabBar': tabBar.toMap(),
    'navigationBar': navigationBar.toMap(),
    'clickable': clickable.toMap(),
    'popup': popup.toMap(),
    'textEditing': textEditing.toMap(),
    'selectionToolbar': selectionToolbar.toMap(),
    'pageRoute': pageRoute.toMap(),
    'scaffold': scaffold.toMap(),
    'artwork': artwork.toMap(),
  };

  /// Inverse of [toMap].
  static CharcoalMetrics fromMap(Map<String, Map<String, Object?>> map) => CharcoalMetrics(
    button: CharcoalButtonMetrics.fromMap(map['button']!),
    iconButton: CharcoalIconButtonMetrics.fromMap(map['iconButton']!),
    switchToggle: CharcoalSwitchMetrics.fromMap(map['switchToggle']!),
    checkbox: CharcoalCheckboxMetrics.fromMap(map['checkbox']!),
    radio: CharcoalRadioMetrics.fromMap(map['radio']!),
    multiSelect: CharcoalMultiSelectMetrics.fromMap(map['multiSelect']!),
    segmented: CharcoalSegmentedMetrics.fromMap(map['segmented']!),
    tag: CharcoalTagMetrics.fromMap(map['tag']!),
    field: CharcoalFieldMetrics.fromMap(map['field']!),
    textField: CharcoalTextFieldMetrics.fromMap(map['textField']!),
    textArea: CharcoalTextAreaMetrics.fromMap(map['textArea']!),
    dropdown: CharcoalDropdownMetrics.fromMap(map['dropdown']!),
    hint: CharcoalHintMetrics.fromMap(map['hint']!),
    spinner: CharcoalSpinnerMetrics.fromMap(map['spinner']!),
    modal: CharcoalModalMetrics.fromMap(map['modal']!),
    toast: CharcoalToastMetrics.fromMap(map['toast']!),
    tooltip: CharcoalTooltipMetrics.fromMap(map['tooltip']!),
    balloon: CharcoalBalloonMetrics.fromMap(map['balloon']!),
    carousel: CharcoalCarouselMetrics.fromMap(map['carousel']!),
    pagination: CharcoalPaginationMetrics.fromMap(map['pagination']!),
    navigationItem: CharcoalNavigationItemMetrics.fromMap(map['navigationItem']!),
    tabBar: CharcoalTabBarMetrics.fromMap(map['tabBar']!),
    navigationBar: CharcoalNavigationBarMetrics.fromMap(map['navigationBar']!),
    clickable: CharcoalClickableMetrics.fromMap(map['clickable']!),
    popup: CharcoalPopupMetrics.fromMap(map['popup']!),
    textEditing: CharcoalTextEditingMetrics.fromMap(map['textEditing']!),
    selectionToolbar: CharcoalSelectionToolbarMetrics.fromMap(map['selectionToolbar']!),
    pageRoute: CharcoalPageRouteMetrics.fromMap(map['pageRoute']!),
    scaffold: CharcoalScaffoldMetrics.fromMap(map['scaffold']!),
    artwork: CharcoalArtworkMetrics.fromMap(map['artwork']!),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalMetrics &&
          other.button == button &&
          other.iconButton == iconButton &&
          other.switchToggle == switchToggle &&
          other.checkbox == checkbox &&
          other.radio == radio &&
          other.multiSelect == multiSelect &&
          other.segmented == segmented &&
          other.tag == tag &&
          other.field == field &&
          other.textField == textField &&
          other.textArea == textArea &&
          other.dropdown == dropdown &&
          other.hint == hint &&
          other.spinner == spinner &&
          other.modal == modal &&
          other.toast == toast &&
          other.tooltip == tooltip &&
          other.balloon == balloon &&
          other.carousel == carousel &&
          other.pagination == pagination &&
          other.navigationItem == navigationItem &&
          other.tabBar == tabBar &&
          other.navigationBar == navigationBar &&
          other.clickable == clickable &&
          other.popup == popup &&
          other.textEditing == textEditing &&
          other.selectionToolbar == selectionToolbar &&
          other.pageRoute == pageRoute &&
          other.scaffold == scaffold &&
          other.artwork == artwork;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    button,
    iconButton,
    switchToggle,
    checkbox,
    radio,
    multiSelect,
    segmented,
    tag,
    field,
    textField,
    textArea,
    dropdown,
    hint,
    spinner,
    modal,
    toast,
    tooltip,
    balloon,
    carousel,
    pagination,
    navigationItem,
    tabBar,
    navigationBar,
    clickable,
    popup,
    textEditing,
    selectionToolbar,
    pageRoute,
    scaffold,
    artwork,
  ]);
}
