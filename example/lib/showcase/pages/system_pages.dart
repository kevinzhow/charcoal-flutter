import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'token_pipeline_page.dart';

// Owner: batch 3 (docs/tooling). Add a ShowcasePage here to register it.
final List<ShowcasePage> systemPages = <ShowcasePage>[
  ShowcasePage(
    id: 'token-pipeline',
    title: 'Token pipeline',
    section: ShowcaseSection.system,
    icon: CharcoalIcons.syncIcon,
    order: 10,
    builder: (context) => const TokenPipelinePage(),
  ),
];
