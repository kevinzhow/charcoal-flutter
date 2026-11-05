/// The Material-based Charcoal API, under construction (migration batches 1B onward).
///
/// This library coexists with the pre-Material `package:charcoal_ui/charcoal_ui.dart` because both
/// define `CharcoalApp`, `CharcoalTheme`, `CharcoalPageRoute`, `CharcoalScaffold` and
/// `CharcoalClickable`. Import only one of them in a file. When the legacy components are gone
/// (end of phase 2) the contents of this file replace `charcoal_ui.dart`, and `src/legacy/`,
/// `src/theme/` and the old `src/components/` are deleted.
library;

export 'package:charcoal_theme/charcoal_theme.dart';

export 'src/app/charcoal_app.dart';
export 'src/app/charcoal_page_route.dart';
export 'src/app/charcoal_scaffold.dart';
export 'src/app/charcoal_text_defaults.dart';
// actions and selection
export 'src/components/actions/button.dart';
export 'src/components/actions/icon_button.dart';
export 'src/components/actions/link_button.dart';
export 'src/components/actions/switching_button.dart';
export 'src/components/selection/checkbox.dart';
export 'src/components/selection/multi_select.dart';
export 'src/components/selection/radio.dart';
export 'src/components/selection/segmented_control.dart';
export 'src/components/selection/selection_box.dart';
export 'src/components/selection/slider.dart';
export 'src/components/selection/switch.dart';
export 'src/components/status/chip.dart';
export 'src/components/status/status_dot.dart';
export 'src/components/status/tag_item.dart';
export 'src/foundation/charcoal_clickable.dart';
export 'src/foundation/interaction_state.dart';
export 'src/foundation/layout.dart';
