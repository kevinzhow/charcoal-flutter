import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import 'pages/actions_pages.dart';
import 'pages/apps_pages.dart';
import 'pages/fields_pages.dart';
import 'pages/foundation_pages.dart';
import 'pages/navigation_pages.dart';
import 'pages/overlays_pages.dart';
import 'pages/system_pages.dart';
import 'shell/overview.dart';

/// Sidebar group of a [ShowcasePage].
enum ShowcaseSection {
  home(''),
  foundation('FOUNDATION'),
  components('COMPONENTS'),
  system('SYSTEM');

  const ShowcaseSection(this.label);

  /// Upper-case sidebar heading; empty for the unlabeled top group.
  final String label;
}

/// One destination of the showcase: a sidebar entry, a hash route and a page.
///
/// Pages are registered in the per-family `pages/<family>_pages.dart` files
/// and merged by [showcasePages]. Each family owns exactly one of those files,
/// so independent batches never edit the same list.
final class ShowcasePage {
  const ShowcasePage({
    required this.id,
    required this.title,
    required this.section,
    required this.icon,
    required this.order,
    required this.builder,
  });

  /// URL slug (`/#/<id>`) and stable identity. Lower-case, `-` separated.
  final String id;

  /// Sidebar label and header title. Also used in the `nav-<title>` test key.
  final String title;

  final ShowcaseSection section;
  final CharcoalIconData icon;

  /// Position inside [section]; lower first. Leave gaps (10, 20, ...) so a
  /// page can be inserted without renumbering the others.
  final int order;

  final WidgetBuilder builder;
}

/// Id of the page shown when the URL names no registered page.
const showcaseHomeId = 'overview';

/// The overview is a shell page rather than a family page.
final ShowcasePage _overviewPage = ShowcasePage(
  id: showcaseHomeId,
  title: 'Overview',
  section: ShowcaseSection.home,
  icon: CharcoalIcons.home,
  order: 0,
  builder: (context) => const ShowcaseOverviewPage(),
);

/// Every registered page, sorted by section then [ShowcasePage.order] then id.
final List<ShowcasePage> showcasePages = _sorted(<ShowcasePage>[
  _overviewPage,
  ...appsPages,
  ...foundationPages,
  ...actionsPages,
  ...fieldsPages,
  ...navigationPages,
  ...overlaysPages,
  ...systemPages,
]);

List<ShowcasePage> _sorted(List<ShowcasePage> pages) {
  final sorted = List<ShowcasePage>.of(pages)
    ..sort((a, b) {
      final bySection = a.section.index.compareTo(b.section.index);
      if (bySection != 0) return bySection;
      final byOrder = a.order.compareTo(b.order);
      return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
    });
  assert(
    sorted.map((page) => page.id).toSet().length == sorted.length,
    'Showcase page ids must be unique.',
  );
  return List<ShowcasePage>.unmodifiable(sorted);
}

/// Looks a page up by [ShowcasePage.id]; null when unknown.
ShowcasePage? showcasePageById(String id) {
  for (final page in showcasePages) {
    if (page.id == id) return page;
  }
  return null;
}

/// Pages grouped by section in sidebar order (empty sections omitted).
List<(ShowcaseSection, List<ShowcasePage>)> get showcaseSections => [
  for (final section in ShowcaseSection.values)
    if (showcasePages.any((page) => page.section == section))
      (
        section,
        [
          for (final page in showcasePages)
            if (page.section == section) page,
        ],
      ),
];

/// Lets pages ask the shell to open another page.
final class ShowcaseNavigation extends InheritedWidget {
  const ShowcaseNavigation({
    required this.select,
    required super.child,
    super.key,
  });

  final ValueChanged<String> select;

  static ValueChanged<String> of(BuildContext context) {
    final navigation = context
        .dependOnInheritedWidgetOfExactType<ShowcaseNavigation>();
    assert(navigation != null, 'No ShowcaseNavigation above this context.');
    return navigation!.select;
  }

  @override
  bool updateShouldNotify(ShowcaseNavigation oldWidget) =>
      select != oldWidget.select;
}
