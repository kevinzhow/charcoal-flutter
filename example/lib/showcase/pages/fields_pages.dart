import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'fields_page.dart';

// Owner: batch 2B (fields and text). Add a ShowcasePage here to register it;
// do not edit registry.dart.
final List<ShowcasePage> fieldsPages = <ShowcasePage>[
  ShowcasePage(
    id: 'fields',
    title: 'Fields',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.penText,
    order: 30,
    builder: (context) => const FieldsPage(),
  ),
];
