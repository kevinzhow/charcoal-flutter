/// The Material-based Charcoal API, under construction (migration batches 1B onward).
///
/// This library coexists with the pre-Material `package:charcoal_ui/charcoal_ui.dart` because both
/// define `CharcoalApp`, `CharcoalTheme`, `CharcoalPageRoute`, `CharcoalScaffold` and
/// `CharcoalClickable`. Import only one of them in a file. When the legacy components are gone
/// (end of phase 2) the contents of this file replace `charcoal_ui.dart`, and `src/legacy/`,
/// `src/theme/` and the old `src/components/` are deleted.
library;

export 'package:charcoal_theme/charcoal_theme.dart';

// Families: actions and selection (2A), fields and text (2B), navigation and layout (2D),
// foundation, app. Admin pieces of 2D are in `admin.dart`.
// overlays and feedback
export 'src/app/charcoal_app.dart';
export 'src/app/charcoal_page_route.dart';
export 'src/app/charcoal_scaffold.dart';
export 'src/app/charcoal_text_defaults.dart';
export 'src/components/actions/button.dart';
export 'src/components/actions/icon_button.dart';
export 'src/components/actions/link_button.dart';
export 'src/components/actions/switching_button.dart';
export 'src/components/carousel/carousel.dart';
export 'src/components/feedback/banner.dart';
export 'src/components/feedback/empty_state.dart';
export 'src/components/feedback/error_state.dart';
export 'src/components/feedback/loading_spinner.dart';
export 'src/components/feedback/loading_state.dart';
export 'src/components/feedback/spinner_overlay.dart';
export 'src/components/fields/date_time_field.dart';
export 'src/components/fields/dropdown.dart';
export 'src/components/fields/field_label.dart';
export 'src/components/fields/field_ring.dart';
export 'src/components/fields/form_field.dart';
export 'src/components/fields/form_section.dart';
export 'src/components/fields/hint_text.dart';
export 'src/components/fields/search_field.dart';
export 'src/components/fields/switch_field.dart';
export 'src/components/fields/text_area.dart';
export 'src/components/fields/text_field.dart';
export 'src/components/icons/icon_view.dart';
export 'src/components/layout/action_tile.dart';
export 'src/components/layout/avatar.dart';
export 'src/components/layout/card.dart';
export 'src/components/layout/divider.dart';
export 'src/components/layout/field_box.dart';
export 'src/components/layout/list.dart';
export 'src/components/layout/list_row.dart';
export 'src/components/layout/section_header.dart';
export 'src/components/navigation/navigation_bar.dart';
export 'src/components/navigation/navigation_item.dart';
export 'src/components/navigation/pagination.dart';
export 'src/components/navigation/tab_bar.dart';
export 'src/components/overlays/balloon.dart';
export 'src/components/overlays/choice_dialog.dart';
export 'src/components/overlays/code_block.dart';
export 'src/components/overlays/code_dialog.dart';
export 'src/components/overlays/confirm_dialog.dart';
export 'src/components/overlays/dialog.dart';
export 'src/components/overlays/form_dialog.dart';
export 'src/components/overlays/modal.dart';
export 'src/components/overlays/overlay_anchor_tracker.dart';
export 'src/components/overlays/overlay_position.dart';
export 'src/components/overlays/popup_shape.dart';
export 'src/components/overlays/snack_bar.dart';
export 'src/components/overlays/toast.dart';
export 'src/components/overlays/toast_presentation.dart';
export 'src/components/overlays/tooltip.dart';
export 'src/components/selection/checkbox.dart';
export 'src/components/selection/multi_select.dart';
export 'src/components/selection/radio.dart';
export 'src/components/selection/segmented_control.dart';
export 'src/components/selection/selection_box.dart';
export 'src/components/selection/slider.dart';
export 'src/components/selection/switch.dart';
export 'src/components/status/badge.dart';
export 'src/components/status/chip.dart';
export 'src/components/status/status_dot.dart';
export 'src/components/status/tag_item.dart';
export 'src/components/text/charcoal_text.dart';
export 'src/components/text/selection_toolbar.dart';
export 'src/components/text/text_editing.dart';
export 'src/components/text/text_ellipsis.dart';
export 'src/components/text/text_tone.dart';
export 'src/components/text/typography.dart';
export 'src/foundation/charcoal_clickable.dart';
export 'src/foundation/charcoal_wrap.dart';
export 'src/foundation/interaction_state.dart';
export 'src/foundation/layout.dart';
