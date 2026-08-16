import 'package:flutter/foundation.dart';
import 'package:flutter_skill/flutter_skill.dart';

import 'main.dart' as showcase;

void main() {
  if (kDebugMode) {
    FlutterSkillBinding.ensureInitialized(autoEnableIndicators: false);
  }
  showcase.runCharcoalShowcase();
}
