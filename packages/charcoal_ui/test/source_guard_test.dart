import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/guard.dart';

/// The library's source guard: nothing in `lib/src` outside the paths below may contain a literal
/// colour, type or size, read `ThemeData` directly, import Cupertino, or use an unnamed ratio.
/// Every value belongs in `packages/charcoal_theme/lib/src/{contract,packs}` or the tokens.
///
/// The rule set is tested against fixtures (one bad file hitting every rule, one good file hitting
/// none), and the consumer rule set R1-R9 that applications adopt is versioned and tested here too.

/// Pre-Material code that is being replaced family by family. Shrinks to empty; each entry must
/// exist (a stale entry fails the test, so the list cannot rot).
const libraryExcluded = <String>['components/', 'legacy/', 'previews/', 'theme/'];

/// Family folders inside an excluded directory that are already migrated and so ARE guarded.
/// Each Phase 2 batch appends its folders here.
const libraryGuarded = <String>[
  // 2A actions and selection
  'components/actions/',
  'components/selection/',
  'components/status/',
  // 2B fields and text
  'components/fields/',
  'components/text/',
  // 2C overlays and feedback
  'components/overlays/',
  'components/feedback/',
  'components/carousel/',
];

void main() {
  final root = Directory.current.path; // packages/charcoal_ui
  final src = '$root/lib/src';

  Map<int, Set<String>> expectations(List<String> lines) => {
    for (var i = 0; i < lines.length; i++)
      if (RegExp(r'expect:\s*([A-Z0-9,]+)\s*$').firstMatch(lines[i]) case final m?)
        i + 1: m.group(1)!.split(',').toSet(),
  };

  void checkFixture(String name, List<GuardRule> rules, {required bool bad}) {
    final text = File('$root/test/support/fixtures/$name').readAsStringSync();
    final lines = text.split('\n');
    final hits = scanText(name, text, rules);
    final byLine = <int, Set<String>>{};
    for (final h in hits) {
      byLine.putIfAbsent(h.line, () => {}).add(h.rule);
    }
    if (!bad) {
      expect(byLine, isEmpty, reason: hits.join('\n'));
      return;
    }
    expect(byLine, expectations(lines), reason: hits.join('\n'));
    // Every rule id of the set is exercised by the fixture.
    final covered = byLine.values.expand((s) => s).toSet();
    expect(covered, rules.map((r) => r.id).toSet());
  }

  group('library rules', () {
    test('catch every rule in the bad fixture', () {
      checkFixture('library_bad.dart.txt', libraryRules, bad: true);
    });

    test('pass the good fixture', () {
      checkFixture('library_good.dart.txt', libraryRules, bad: false);
    });

    test('lib/src contains no literals, theme reads or unnamed ratios', () {
      final hits = <GuardHit>[];
      for (final file in dartFiles(src)) {
        final relative = file.path.substring(src.length + 1);
        if (libraryExcluded.any(relative.startsWith) && !libraryGuarded.any(relative.startsWith)) {
          continue;
        }
        hits.addAll(scanText('lib/src/$relative', file.readAsStringSync(), libraryRules));
      }
      expect(hits, isEmpty, reason: hits.join('\n'));
    });

    test('exclusions are real directories', () {
      for (final dir in libraryExcluded) {
        expect(
          Directory('$src/$dir').existsSync(),
          isTrue,
          reason: '$dir no longer exists; remove it from libraryExcluded',
        );
      }
    });

    test('the allow pragma is not used and does not exempt anything', () {
      final used = [
        for (final f in dartFiles('$root/lib'))
          if (countAllowPragmas(f.readAsStringSync()) > 0) f.path,
      ];
      expect(used, isEmpty);
    });

    test('scanning a temp library finds a planted literal', () {
      final dir = Directory.systemTemp.createTempSync('charcoal_guard');
      addTearDown(() => dir.deleteSync(recursive: true));
      File('${dir.path}/planted.dart').writeAsStringSync('final x = Color(0xFF010203);\n');
      final hits = [
        for (final f in dartFiles(dir.path))
          ...scanText(f.path, f.readAsStringSync(), libraryRules),
      ];
      expect(hits.map((h) => h.rule), contains('L1'));
    });
  });

  group('consumer rules R1-R9', () {
    test('catch every rule in the bad fixture', () {
      checkFixture('consumer_bad.dart.txt', consumerRules, bad: true);
    });

    test('pass the good fixture', () {
      checkFixture('consumer_good.dart.txt', consumerRules, bad: false);
    });

    test('R8 pubspec', () {
      const good = 'dependencies:\n  charcoal_ui:\n    git:\n      url: x\n      ref: abc\n';
      const bad =
          'dependencies:\n  charcoal_ui:\n    path: ../x\n  myopay_theme:\n    path: y\n  charcoal_tokens:\n    path: z\n';
      expect(checkConsumerPubspec(good), isEmpty);
      expect(checkConsumerPubspec(bad), hasLength(3));
    });

    test('R9 counts the pragma', () {
      expect(countAllowPragmas('a\nb // theme-guard: allow\n'), 1);
      expect(countAllowPragmas('a\nb\n'), 0);
    });
  });
}
