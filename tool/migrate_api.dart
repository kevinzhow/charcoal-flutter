import 'dart:io';

import 'src/migrate_api.dart';

/// Applies `tool/migration/renames/*.json` to a source tree.
///
///     dart run tool/migrate_api.dart [--write] [--renames DIR] PATH...
///
/// Rewrites `package:charcoal_ui/next.dart` imports to `charcoal_ui.dart`, renames identifiers
/// (`ConsoleButton` -> `CharcoalButton`, ...), adds the `admin.dart` import where an admin
/// symbol is used, and reports everything it cannot do mechanically (different constructor shape,
/// renamed or inverted members, private imports). Without `--write` nothing is changed. Exit code
/// 0 when nothing needs a human, 1 when findings remain.
Future<void> main(List<String> arguments) async {
  var write = false;
  var renames = 'tool/migration/renames';
  final paths = <String>[];
  for (var i = 0; i < arguments.length; i++) {
    switch (arguments[i]) {
      case '--write':
        write = true;
      case '--renames':
        renames = arguments[++i];
      case '--help' || '-h':
        stdout.writeln('usage: dart run tool/migrate_api.dart [--write] [--renames DIR] PATH...');
        return;
      default:
        paths.add(arguments[i]);
    }
  }
  if (paths.isEmpty) {
    stderr.writeln('no paths given');
    exitCode = 64;
    return;
  }
  final migrator = ApiMigrator(RenameTable.load(Directory(renames)));
  var files = 0;
  var changed = 0;
  final findings = <MigrationFinding>[];
  for (final path in paths) {
    final type = FileSystemEntity.typeSync(path);
    final entries = type == FileSystemEntityType.directory
        ? Directory(path)
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
        : [File(path)];
    for (final file in entries) {
      files++;
      final source = file.readAsStringSync();
      final result = migrator.migrate(file.path, source);
      findings.addAll(result.findings);
      if (result.text != source) {
        changed++;
        if (write) file.writeAsStringSync(result.text);
      }
    }
  }
  for (final f in findings) {
    stdout.writeln(f);
  }
  stdout.writeln(
    '$files files, $changed ${write ? 'rewritten' : 'would change'}, ${findings.length} need a human.',
  );
  if (findings.isNotEmpty) exitCode = 1;
}
