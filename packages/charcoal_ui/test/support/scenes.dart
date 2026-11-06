import 'package:charcoal_ui/testing.dart';

import 'scene_actions.dart';
import 'scene_content.dart';
import 'scene_fields.dart';
import 'scene_gaps.dart';
import 'scene_navigation.dart';
import 'scene_overlays.dart';
import 'scene_shell.dart';

/// Every scene the extreme-theme and layout-audit tests mount. One entry per component family
/// scene; 1B contributes the shell scenes, families append theirs.
final charcoalScenes = <CharcoalScene>[
  ...shellScenes,
  ...actionsScenes,
  ...fieldsScenes,
  ...overlaysScenes,
  ...navigationScenes,
  ...gapsScenes,
  ...contentScenes,
];
