import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'colors_page.dart';
import 'dimensions_page.dart';
import 'icons_page.dart';
import 'roles_page.dart';
import 'supporting_page.dart';
import 'typography_page.dart';

// Owner: batch 2B (fields and text; foundations). Add a ShowcasePage here to
// register it; do not edit registry.dart.
final List<ShowcasePage> foundationPages = <ShowcasePage>[
  ShowcasePage(
    id: 'colors',
    title: 'Colors',
    section: ShowcaseSection.foundation,
    icon: CharcoalIcons.color,
    order: 10,
    builder: (context) => const ColorsPage(),
  ),
  ShowcasePage(
    id: 'typography',
    title: 'Typography',
    section: ShowcaseSection.foundation,
    icon: CharcoalIcons.text,
    order: 20,
    builder: (context) => const TypographyPage(),
  ),
  ShowcasePage(
    id: 'dimensions',
    title: 'Dimensions',
    section: ShowcaseSection.foundation,
    icon: CharcoalIcons.ruler,
    order: 30,
    builder: (context) => const DimensionsPage(),
  ),
  ShowcasePage(
    id: 'roles',
    title: 'Roles',
    section: ShowcaseSection.foundation,
    icon: CharcoalIcons.gridview,
    order: 50,
    builder: (context) => const RolesPage(),
  ),
  ShowcasePage(
    id: 'icons',
    title: 'Icons',
    section: ShowcaseSection.foundation,
    icon: CharcoalIcons.images,
    order: 40,
    builder: (context) => const IconsPage(),
  ),
  ShowcasePage(
    id: 'supporting',
    title: 'Supporting',
    section: ShowcaseSection.foundation,
    icon: CharcoalIcons.setting,
    order: 60,
    builder: (context) => const SupportingPage(),
  ),
];
