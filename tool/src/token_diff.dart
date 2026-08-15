import 'dart:convert';

import 'token_model.dart';

final class TokenChange {
  const TokenChange({required this.path, this.before, this.after});

  final String path;
  final Object? before;
  final Object? after;
}

final class TokenDiff {
  const TokenDiff({required this.added, required this.removed, required this.changed});

  factory TokenDiff.between(
    Map<String, Object>? beforeSnapshot,
    Map<String, Object> afterSnapshot,
  ) {
    final before = _flattenSnapshot(beforeSnapshot);
    final after = _flattenSnapshot(afterSnapshot);
    final beforeKeys = before.keys.toSet();
    final afterKeys = after.keys.toSet();

    final addedKeys = afterKeys.difference(beforeKeys).toList()..sort();
    final removedKeys = beforeKeys.difference(afterKeys).toList()..sort();
    final sharedKeys = beforeKeys.intersection(afterKeys).toList()..sort();

    return TokenDiff(
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
    return output.toString();
  }
}

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
