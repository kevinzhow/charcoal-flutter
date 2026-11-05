import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'buttons_page.dart';
import 'selection_page.dart';

// Owner: batch 2A (actions and selection). Add a ShowcasePage here to
// register it; do not edit registry.dart.
final List<ShowcasePage> actionsPages = <ShowcasePage>[
  ShowcasePage(
    id: 'buttons',
    title: 'Buttons',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.click,
    order: 10,
    builder: (context) => const ButtonsPage(),
  ),
  ShowcasePage(
    id: 'selection',
    title: 'Selection',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.checkCircle,
    order: 20,
    builder: (context) => const SelectionPage(),
  ),
];
