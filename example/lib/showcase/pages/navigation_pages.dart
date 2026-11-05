import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'navigation_page.dart';

// Owner: batch 2D (navigation and layout). Add a ShowcasePage here to
// register it; do not edit registry.dart.
final List<ShowcasePage> navigationPages = <ShowcasePage>[
  ShowcasePage(
    id: 'navigation',
    title: 'Navigation',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.compass,
    order: 40,
    builder: (context) => const NavigationPage(),
  ),
];
