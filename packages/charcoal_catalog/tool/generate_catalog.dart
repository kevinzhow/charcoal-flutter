import 'dart:io';

import 'src/catalog_generator.dart';

void main(List<String> arguments) {
  final unknownArguments = arguments.where((argument) => argument != '--check').toList();
  if (unknownArguments.isNotEmpty) {
    stderr.writeln(
      'Usage: dart run packages/charcoal_catalog/tool/generate_catalog.dart [--check]',
    );
    exitCode = 64;
    return;
  }

  final check = arguments.contains('--check');
  final root = findWorkspaceRoot(Directory.current);
  final generated = buildCatalog(root);
  final outputs = <String, String>{
    catalogJsonPath(root): generated.json,
    catalogDartPath(root): generated.dartSource,
  };
  var stale = false;
  for (final entry in outputs.entries) {
    final file = File(entry.key);
    if (check) {
      if (!file.existsSync() || file.readAsStringSync() != entry.value) {
        stderr.writeln('Stale generated catalog output: ${file.path}');
        stale = true;
      }
      continue;
    }
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
  }
  if (stale) {
    stderr.writeln('Run the catalog generator and commit its output.');
    exitCode = 1;
    return;
  }
  if (!check) {
    stdout.writeln(
      'Generated ${generated.catalog.components.length} components '
      '(${generated.catalog.coverage.curatedComponents} curated).',
    );
  }
}
