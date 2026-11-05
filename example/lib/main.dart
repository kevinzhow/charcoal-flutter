import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import 'showcase/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCharcoalSystemUi();
  runCharcoalShowcase();
}

void runCharcoalShowcase() => runApp(const CharcoalShowcaseApp());
