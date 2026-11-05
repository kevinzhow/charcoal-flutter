import 'package:charcoal_icons/charcoal_icons.dart';

import '../../agent_examples/app_examples_page.dart';
import '../registry.dart';

// Owner: P3C (application examples). Add a ShowcasePage here to register it.
final List<ShowcasePage> appsPages = <ShowcasePage>[
  ShowcasePage(
    id: 'agent-ready-apps',
    title: 'Agent Ready apps',
    section: ShowcaseSection.home,
    icon: CharcoalIcons.layout,
    order: 10,
    builder: (context) => const AgentAppExamplesPage(),
  ),
];
