import 'package:flutter/foundation.dart';
import 'package:flutter_skill/flutter_skill.dart';

import 'main.dart' as showcase;

Future<void> main() async {
  if (kDebugMode) {
    FlutterSkillBinding.ensureInitialized(autoEnableIndicators: false);
  }
  await showcase.main();
}
