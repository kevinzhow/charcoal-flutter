import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'admin_page.dart';
import 'layout_page.dart';
import 'navigation_page.dart';
import 'next_island.dart';

// Owner: batch 2D (navigation and layout). Add a ShowcasePage here to
// register it; do not edit registry.dart.
final List<ShowcasePage> navigationPages = <ShowcasePage>[
  ShowcasePage(
    id: 'navigation',
    title: 'Navigation',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.compass,
    order: 40,
    builder: (context) => const NextThemeIsland(child: NavigationPage()),
  ),
  ShowcasePage(
    id: 'layout',
    title: 'Layout',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.layer,
    order: 45,
    builder: (context) => const NextThemeIsland(child: LayoutPage()),
  ),
  ShowcasePage(
    id: 'admin',
    title: 'Admin',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.setting,
    order: 46,
    builder: (context) => const NextThemeIsland(child: AdminPage()),
  ),
];
