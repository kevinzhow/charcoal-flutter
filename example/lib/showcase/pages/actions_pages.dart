import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'actions_next_host.dart';
import 'buttons_page.dart';
import 'selection_page.dart';
import 'tags_page.dart';

// Owner: batch 2A (actions and selection). Add a ShowcasePage here to
// register it; do not edit registry.dart.
final List<ShowcasePage> actionsPages = <ShowcasePage>[
  ShowcasePage(
    id: 'buttons',
    title: 'Buttons',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.click,
    order: 10,
    builder: (context) => const ActionsNextHost(child: ButtonsPage()),
  ),
  ShowcasePage(
    id: 'selection',
    title: 'Selection',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.checkCircle,
    order: 20,
    builder: (context) => const ActionsNextHost(child: SelectionPage()),
  ),
  ShowcasePage(
    id: 'tags',
    title: 'Tags',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.hashTag,
    order: 25,
    builder: (context) => const ActionsNextHost(child: TagsPage()),
  ),
];
