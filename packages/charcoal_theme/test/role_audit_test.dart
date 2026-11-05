// Proves docs/theme-contract.md section 8 covers every read in the pre-Material charcoal_ui and
// that every mapping target is a real contract name.
//
// Files of charcoal_ui that already import package:charcoal_theme are migrated (phase 2) and are
// skipped: their reads use contract names directly.
import 'dart:io';

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter_test/flutter_test.dart';

const _sourceRoots = <String>[
  '../charcoal_ui/lib/src/components',
  '../charcoal_ui/lib/src/app',
];

class _Row {
  _Row(this.section, this.cells);
  final String section;
  final List<String> cells;

  String get read => _ticks(cells[0]).first;
  List<String> get targets => cells.length > 2 ? _ticks(cells[2]) : const <String>[];
  bool get exempt => cells.length > 2 && cells[2].trim() == 'exempt';
}

List<String> _ticks(String cell) =>
    RegExp(r'`([^`]+)`').allMatches(cell).map((m) => m.group(1)!).toList();

List<_Row> _rows() {
  final rows = <_Row>[];
  var section = '';
  for (final line in File('../../docs/theme-contract.md').readAsLinesSync()) {
    if (line.startsWith('#')) {
      section = line;
      continue;
    }
    final inAudit = RegExp(r'^### 8\.[1-5]').hasMatch(section);
    if (!inAudit || !line.startsWith('|') || line.contains('| --- |')) {
      continue;
    }
    final cells = line.substring(1, line.length - 1).split('|').map((c) => c.trim()).toList();
    if (cells.first == 'Read') continue;
    rows.add(_Row(section, cells));
  }
  return rows;
}

List<File> _legacySources() {
  final files = <File>[];
  for (final root in _sourceRoots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync()) {
      if (entity is File &&
          entity.path.endsWith('.dart') &&
          !entity.readAsStringSync().contains('package:charcoal_theme')) {
        files.add(entity);
      }
    }
  }
  return files;
}

String _stem(File f) => f.uri.pathSegments.last.replaceAll('.dart', '');

void main() {
  final rows = _rows();
  final flat = temporaryLightPack.toFlatMap();
  final known = <String>{
    ...flat.keys,
    'colors.transparent',
    // A type role stands for its size, line height and weight.
    for (final role in CharcoalTextRole.values) 'typography.${role.name}',
  };
  final documentedReads = rows.map((r) => r.read).toSet();
  final sources = _legacySources();

  test('the audit tables parse', () {
    expect(rows.where((r) => r.section.startsWith('### 8.1')), isNotEmpty);
    expect(rows.where((r) => r.section.startsWith('### 8.4')), isNotEmpty);
  });

  test('every mapping target is a contract name (or an explicit exemption)', () {
    final bad = <String>[];
    for (final row in rows) {
      if (row.exempt) continue;
      if (row.targets.isEmpty) bad.add('${row.read}: no target');
      for (final target in row.targets) {
        if (!known.contains(target)) bad.add('${row.read}: unknown target $target');
      }
    }
    expect(bad, isEmpty);
  });

  test('every contract name is documented', () {
    final text = File('../../docs/theme-contract.md').readAsStringSync();
    final missing = <String>[];
    for (final key in flat.keys) {
      final parts = key.split('.');
      final prefix = parts.sublist(0, parts.length - 1).join('.');
      final isTypographyRole = key.startsWith('typography.') && parts.length == 3;
      if (!text.contains('`$key`') && !(isTypographyRole && text.contains('`$prefix`'))) {
        missing.add(key);
      }
    }
    expect(missing, isEmpty);
  });

  test('every colors.X read in the old components is mapped', () {
    final read = <String>{};
    for (final file in sources) {
      read.addAll(
        RegExp(r'colors\.([A-Za-z0-9]+)')
            .allMatches(file.readAsStringSync())
            .map((m) => m.group(1)!),
      );
    }
    final missing = read.where((a) => !documentedReads.contains('theme.colors.$a')).toList();
    expect(missing, isEmpty);
    if (sources.isNotEmpty) {
      // Pre-migration snapshot: 74 distinct reads.
      expect(read.length, lessThanOrEqualTo(74));
    }
  });

  test('every dimension accessor in the old components is mapped', () {
    final read = <String>{};
    final pattern = RegExp(
      r'\b(?:dimensions\.)?(space|radius|borderWidth|paragraphWidth)\.'
      r'((?:component|layout|target|focus)\w*|l|m|s|xl|oval|xs)\b',
    );
    for (final file in sources) {
      for (final m in pattern.allMatches(file.readAsStringSync())) {
        read.add('${m.group(1)}.${m.group(2)}');
      }
    }
    final missing = read.where((a) => !documentedReads.contains('theme.dimensions.$a')).toList();
    expect(missing, isEmpty);
  });

  test('every private static const in the old components is mapped', () {
    final read = <String>{};
    for (final file in sources) {
      final text = file.readAsStringSync();
      for (final m in RegExp(r'^\s+static const (\w+) = ', multiLine: true).allMatches(text)) {
        read.add('${_stem(file)}.dart#${m.group(1)}');
      }
      if (_stem(file) == 'interaction_state' && text.contains('charcoalDisabledOpacity')) {
        read.add('interaction_state.dart#charcoalDisabledOpacity');
      }
    }
    final missing = read.where((a) => !documentedReads.contains(a)).toList();
    expect(missing, isEmpty);
  });

  test('raw colour literals in the old components are all accounted for', () {
    // Mirrors test/architecture_test.dart at the repository root, plus the app/ directory.
    final found = <String>{};
    for (final file in sources) {
      for (final m in RegExp(r'Color\(\s*(0x[0-9A-Fa-f]{8})').allMatches(file.readAsStringSync())) {
        found.add('${_stem(file)}.dart ${m.group(1)}');
      }
    }
    const accounted = <String>{
      'checkbox.dart 0x00000000',
      'checkbox.dart 0xFFFFFFFF',
      'hint_text.dart 0xFF858585',
      'loading_spinner.dart 0x1A000000',
      'modal.dart 0x99000000',
      'tag_item.dart 0xFF7ACCB1',
      'charcoal_page_route.dart 0xFF000000',
      'charcoal_scaffold.dart 0x00000000',
    };
    expect(found.difference(accounted), isEmpty);
  });
}
