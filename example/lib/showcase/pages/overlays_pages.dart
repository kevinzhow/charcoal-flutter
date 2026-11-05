import 'package:charcoal_icons/charcoal_icons.dart';

import '../registry.dart';
import 'content_page.dart';
import 'feedback_page.dart';

// Owner: batch 2C (overlays and feedback). Add a ShowcasePage here to
// register it; do not edit registry.dart.
final List<ShowcasePage> overlaysPages = <ShowcasePage>[
  ShowcasePage(
    id: 'content',
    title: 'Content',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.image,
    order: 50,
    builder: (context) => const ContentPage(),
  ),
  ShowcasePage(
    id: 'feedback',
    title: 'Feedback',
    section: ShowcaseSection.components,
    icon: CharcoalIcons.alert,
    order: 60,
    builder: (context) => const FeedbackPage(),
  ),
];
