/// Test support for Charcoal UI and for applications built on it.
///
/// [extremePack] is a hostile theme pack for proving that widgets read the theme; [CharcoalScene]
/// is the unit the extreme-theme and layout-audit tests iterate over (one registry entry per
/// component family scene).
library;

import 'package:flutter/widgets.dart';

export 'package:charcoal_theme/testing.dart' show extremePack;

/// A named piece of UI that the extreme-theme and layout-audit tests mount.
///
/// Each component family contributes scenes (`test/support/scene_<family>.dart`) that show every
/// variant and state of the family. [build] must use only Charcoal widgets, so everything painted
/// can be traced to the active pack.
class CharcoalScene {
  /// Creates a scene.
  const CharcoalScene({required this.name, required this.build, this.size = const Size(900, 900)});

  /// Unique name, used in test descriptions.
  final String name;

  /// Logical window size for the extreme-theme test.
  final Size size;

  /// Builds the scene content.
  final WidgetBuilder build;
}
