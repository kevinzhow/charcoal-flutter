// `charcoal_pack.g.dart` is exactly what the generator writes from the committed JSON.
import 'dart:io';

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter_test/flutter_test.dart';

Directory _repositoryRoot() {
  var dir = Directory.current;
  while (!File('${dir.path}/tool/tokens.dart').existsSync()) {
    dir = dir.parent;
  }
  return dir;
}

void main() {
  test('`dart run tool/tokens.dart check` is green (pack included)', () async {
    final result = await Process.run('dart', <String>[
      'run',
      'tool/tokens.dart',
      'check',
    ], workingDirectory: _repositoryRoot().path);
    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('the generated file says so and is not hand-written', () {
    final source = File(
      '${_repositoryRoot().path}/packages/charcoal_theme/lib/src/packs/charcoal_pack.g.dart',
    ).readAsStringSync();
    expect(source, startsWith('// GENERATED CODE - DO NOT MODIFY BY HAND.'));
    expect(source, contains('const CharcoalThemePack charcoalLightPack'));
    expect(source, contains('const CharcoalThemePack charcoalDarkPack'));
  });

  test('the committed packs are const and named', () {
    expect(charcoalLightPack.name, 'charcoal');
    expect(charcoalDarkPack.name, 'charcoal');
  });
}
