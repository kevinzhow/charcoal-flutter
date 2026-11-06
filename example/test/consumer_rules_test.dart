import 'package:flutter_test/flutter_test.dart';

// The consumer rule set R1-R9 is versioned with the library; this is how an application adopts it.
import '../../packages/charcoal_ui/test/support/guard.dart';

/// The Agent Ready examples under `lib/agent_examples/` stand in for application code: agents read
/// them through the catalog, the CLI and MCP as the right way to build a page. They are held to the
/// consumer rules R1-R9 (docs/guards.md) like an application, so a new colour, text style, size,
/// decoration, theme read or raw Material control in them fails CI.
///
/// The Showcase pages under `lib/showcase/` are the library's own demo and are not scanned.
void main() {
  const root = 'lib/agent_examples';

  /// Rules waived for one file, with the reason. Only theme demonstrations and the simulated
  /// network may be listed here.
  const exemptions = <String, ({Set<String> rules, String reason})>{
    // Theme demonstration: scopes a pack to its subtree with Theme(buildCharcoalThemeData(..))
    // and reads CharcoalTheme.of for one text style. Its doc comment and catalog entry say so.
    'theme_typography_example.dart': (
      rules: {'R1', 'R2'},
      reason: 'theme demonstration',
    ),
    // The simulated backend: request latency is product behaviour, not a visual value.
    'simulated_latency.dart': (
      rules: {'R6'},
      reason: 'simulated network latency',
    ),
  };

  /// Files written before the examples were brought to the consumer rules. This list may only
  /// shrink: a listed file that no longer violates a rule must be removed from it, and a new file
  /// is checked from the start.
  const pending = <String>{
    'app_examples_page.dart',
    'mobile_app_gallery.dart',
    'mobile_apps/daylight/daylight_demo.dart',
    'mobile_apps/daylight/pages/daylight_plan_pages.dart',
    'mobile_apps/daylight/pages/daylight_secondary_pages.dart',
    'mobile_apps/daylight/pages/daylight_today_page.dart',
    'mobile_apps/daylight/widgets/daylight_habit_card.dart',
    'mobile_apps/daylight/widgets/daylight_item_group.dart',
    'mobile_apps/lumen/lumen_demo.dart',
    'mobile_apps/lumen/pages/lumen_secondary_pages.dart',
    'mobile_apps/lumen/pages/lumen_task_pages.dart',
    'mobile_apps/lumen/pages/lumen_wallet_page.dart',
    'mobile_apps/lumen/previews/lumen_component_previews.dart',
    'mobile_apps/lumen/widgets/lumen_wallet_components.dart',
    'mobile_apps/nook/nook_demo.dart',
    'mobile_apps/nook/pages/nook_checkout_pages.dart',
    'mobile_apps/nook/pages/nook_collection_page.dart',
    'mobile_apps/nook/pages/nook_product_page.dart',
    'mobile_apps/nook/pages/nook_profile_page.dart',
    'mobile_apps/nook/previews/nook_component_previews.dart',
    'mobile_apps/nook/widgets/nook_product_card.dart',
    'mobile_apps/shared/demo_components.dart',
    'mobile_apps/shared/demo_shell.dart',
    'previews/platform_previews.dart',
    'previews/preview_support.dart',
    'previews/shared_component_previews.dart',
  };

  final files = {
    for (final file in dartFiles(root))
      file.path.substring(root.length + 1): file,
  };

  List<GuardHit> scan(String relative, {Set<String> skip = const {}}) =>
      scanText(
        '$root/$relative',
        files[relative]!.readAsStringSync(),
        consumerRules,
        skipRules: skip,
      );

  test('the Agent Ready examples follow the consumer rules R1-R7', () {
    final hits = <GuardHit>[
      for (final relative in files.keys)
        if (!pending.contains(relative))
          ...scan(relative, skip: exemptions[relative]?.rules ?? const {}),
    ];
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('every exemption is still needed and names an existing file', () {
    for (final MapEntry(key: relative, value: exemption)
        in exemptions.entries) {
      expect(
        files,
        contains(relative),
        reason: '$relative: remove the exemption',
      );
      final used = scan(relative).map((hit) => hit.rule).toSet();
      expect(
        used,
        containsAll(exemption.rules),
        reason: '$relative no longer needs ${exemption.rules.difference(used)}',
      );
      expect(exemption.reason, isNotEmpty);
    }
  });

  test('the pending list only shrinks', () {
    for (final relative in pending) {
      expect(
        files,
        contains(relative),
        reason: '$relative: remove it from pending',
      );
      expect(
        scan(relative),
        isNotEmpty,
        reason: '$relative follows the rules now: remove it from pending',
      );
    }
  });

  test('R9: no escape-hatch pragma anywhere in the examples', () {
    final used = [
      for (final MapEntry(key: relative, value: file) in files.entries)
        if (countAllowPragmas(file.readAsStringSync()) > 0) relative,
    ];
    expect(used, isEmpty);
  });

  test('the guard catches a planted violation in a new example file', () {
    final hits = scanText(
      '$root/new_example.dart',
      "import 'package:flutter/material.dart';\n"
          'final s = TextStyle(color: Color(0xFF010203), fontSize: 12);\n'
          'final p = EdgeInsets.all(8);\n',
      consumerRules,
    );
    expect(
      hits.map((hit) => hit.rule).toSet(),
      containsAll(<String>{'R1', 'R3', 'R4', 'R6'}),
    );
  });
}
