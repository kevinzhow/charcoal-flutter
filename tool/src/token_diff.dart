import 'dart:convert';

import 'token_model.dart';

final class TokenChange {
  const TokenChange({required this.path, this.before, this.after});

  final String path;
  final Object? before;
  final Object? after;
}

final class TokenDiff {
  const TokenDiff({
    required this.added,
    required this.removed,
    required this.changed,
    this.affectedPackNames = const <String, List<String>>{},
  });

  factory TokenDiff.between(
    Map<String, Object>? beforeSnapshot,
    Map<String, Object> afterSnapshot, {
    Map<String, Set<String>> packReferences = const <String, Set<String>>{},
  }) {
    final before = _flattenSnapshot(beforeSnapshot);
    final after = _flattenSnapshot(afterSnapshot);
    final beforeKeys = before.keys.toSet();
    final afterKeys = after.keys.toSet();

    final addedKeys = afterKeys.difference(beforeKeys).toList()..sort();
    final removedKeys = beforeKeys.difference(afterKeys).toList()..sort();
    final sharedKeys = beforeKeys.intersection(afterKeys).toList()..sort();

    // Tokens are `light.<category>.<key>`; pack mappings are `<category>.<key>`.
    String bare(String path) => path.substring(path.indexOf('.') + 1);
    final affected = <String, Set<String>>{};
    for (final key in <String>[...removedKeys, ...changedKeys(before, after, sharedKeys)]) {
      final names = packReferences[bare(key)];
      if (names != null) {
        affected.putIfAbsent(bare(key), () => <String>{}).addAll(names);
      }
    }

    return TokenDiff(
      affectedPackNames: <String, List<String>>{
        for (final entry in affected.entries) entry.key: (entry.value.toList()..sort()),
      },
      added: <TokenChange>[
        for (final key in addedKeys) TokenChange(path: key, after: after[key]),
      ],
      removed: <TokenChange>[
        for (final key in removedKeys) TokenChange(path: key, before: before[key]),
      ],
      changed: <TokenChange>[
        for (final key in sharedKeys)
          if (before[key] != after[key])
            TokenChange(path: key, before: before[key], after: after[key]),
      ],
    );
  }

  final List<TokenChange> added;
  final List<TokenChange> removed;
  final List<TokenChange> changed;

  /// Token path (without mode) to the pack names that read it, for removed or changed tokens.
  final Map<String, List<String>> affectedPackNames;

  bool get isEmpty => added.isEmpty && removed.isEmpty && changed.isEmpty;

  String renderMarkdown({String? upstreamCommit}) {
    final output = StringBuffer()
      ..writeln('# Charcoal V2 token update')
      ..writeln()
      ..writeln(
        upstreamCommit == null
            ? 'Compared with the committed snapshot.'
            : 'Upstream commit: `$upstreamCommit`.',
      )
      ..writeln()
      ..writeln('| Change | Count |')
      ..writeln('| --- | ---: |')
      ..writeln('| Added | ${added.length} |')
      ..writeln('| Removed | ${removed.length} |')
      ..writeln('| Changed | ${changed.length} |');

    if (isEmpty) {
      output
        ..writeln()
        ..writeln('No token changes detected.');
      return output.toString();
    }

    _writeSection(output, 'Added', added, (change) => '`${change.path}` = `${change.after}`');
    _writeSection(output, 'Removed', removed, (change) => '`${change.path}` = `${change.before}`');
    _writeSection(
      output,
      'Changed',
      changed,
      (change) => '`${change.path}`: `${change.before}` → `${change.after}`',
    );
    if (affectedPackNames.isNotEmpty) {
      output
        ..writeln()
        ..writeln('## Pack roles affected')
        ..writeln();
      final tokens = affectedPackNames.keys.toList()..sort();
      for (final token in tokens.take(200)) {
        output.writeln('- `$token`: ${affectedPackNames[token]!.map((n) => '`$n`').join(', ')}');
      }
      if (tokens.length > 200) {
        output.writeln('- …and ${tokens.length - 200} more.');
      }
    }
    return output.toString();
  }
}

List<String> changedKeys(
  Map<String, Object> before,
  Map<String, Object> after,
  List<String> shared,
) => <String>[
  for (final key in shared)
    if (before[key] != after[key]) key,
];

Map<String, Object> decodeSnapshot(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map<String, dynamic>) {
    throw const TokenGenerationException('tokens/snapshot.json must contain a JSON object.');
  }
  return decoded.cast<String, Object>();
}

Map<String, Object> _flattenSnapshot(Map<String, Object>? snapshot) {
  if (snapshot == null) {
    return <String, Object>{};
  }
  final result = <String, Object>{};
  for (final mode in <String>['light', 'dark']) {
    final values = snapshot[mode];
    if (values is! Map<String, dynamic>) {
      continue;
    }
    for (final entry in values.entries) {
      final value = entry.value;
      if (value is String || value is num) {
        result['$mode.${entry.key}'] = value as Object;
      }
    }
  }
  return result;
}

void _writeSection(
  StringBuffer output,
  String title,
  List<TokenChange> changes,
  String Function(TokenChange change) format,
) {
  if (changes.isEmpty) {
    return;
  }
  output
    ..writeln()
    ..writeln('## $title')
    ..writeln();
  const detailLimit = 200;
  for (final change in changes.take(detailLimit)) {
    output.writeln('- ${format(change)}');
  }
  if (changes.length > detailLimit) {
    output.writeln('- …and ${changes.length - detailLimit} more.');
  }
}
