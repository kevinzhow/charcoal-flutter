import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/pack_generator.dart';
import '../tool/src/token_diff.dart';
import '../tool/src/token_model.dart';
import '../tool/src/token_pipeline.dart';

void main() {
  late TokenBundle bundle;
  late PackContract contract;
  late Map<String, dynamic> pack;

  setUpAll(() async {
    bundle = await TokenPipeline(Directory.current).loadBundle();
    contract = PackContract.load(Directory.current);
  });

  setUp(() {
    pack = jsonDecode(File(packSourcePath).readAsStringSync()) as Map<String, dynamic>;
  });

  PackGenerator generatorFor(Map<String, dynamic> json) =>
      PackGenerator(bundle: bundle, packJson: jsonEncode(json), contract: contract);

  void expectRejected(Pattern message) => expect(
    () => generatorFor(pack).render(),
    throwsA(
      isA<TokenGenerationException>().having((e) => e.message, 'message', contains(message)),
    ),
  );

  Map<String, dynamic> section(String name) => pack[name] as Map<String, dynamic>;

  test('the checked-in pack renders and covers the whole contract', () {
    final artifact = generatorFor(pack).render();
    expect(artifact.relativePath, packOutputPath);
    for (final role in contract.colors) {
      expect(artifact.contents, contains('    $role: Color(0x'));
    }
    expect(contract.colors, hasLength(88));
    expect(contract.textRoles, hasLength(27));
  });

  test('rendering is deterministic', () {
    expect(generatorFor(pack).render().contents, generatorFor(pack).render().contents);
  });

  test('unknown token reference fails', () {
    section('colors')['primary'] = '{color.does-not-exist}';
    expectRejected('Unknown token reference {color.does-not-exist}');
  });

  test('unknown token reference in a dimension fails', () {
    section('space')['xs'] = '{space.nope}';
    expectRejected('Unknown token reference {space.nope}');
  });

  test('contract colour role without a mapping fails', () {
    section('colors').remove('primary');
    expectRejected('Contract colour roles without a mapping: primary');
  });

  test('contract scale entry without a mapping fails', () {
    section('sizes').remove('iconSm');
    expectRejected('Contract sizes entries without a mapping: iconSm');
  });

  test('contract text role without a mapping fails', () {
    ((pack['typography'] as Map<String, dynamic>)['roles'] as Map<String, dynamic>).remove('body');
    expectRejected('Contract text roles without a mapping: body');
  });

  test('mapping for an unknown colour role fails', () {
    section('colors')['notARole'] = '{color.background/default}';
    expectRejected('colour roles the contract does not have: notARole');
  });

  test('mapping for an unknown scale entry fails', () {
    section('radius')['notAStep'] = 3;
    expectRejected('radius entries the contract does not have: notAStep');
  });

  test('a role mapped twice fails', () {
    section('extensions')['primary'] = <String, dynamic>{'light': '#FF000000', 'dark': '#FF000000'};
    expectRejected('both "colors" and "extensions": primary');
  });

  test('light/dark key mismatch fails', () {
    (section('extensions')['barrier'] as Map<String, dynamic>)
      ..remove('dark')
      ..['night'] = '#FF000000';
    expectRejected('Light/dark key mismatch');
  });

  test('extension without both modes fails', () {
    section('extensions')['barrier'] = '#99000000';
    expectRejected('must give both modes');
  });

  test('extension with only one mode fails', () {
    (section('extensions')['barrier'] as Map<String, dynamic>).remove('dark');
    expectRejected('Light/dark key mismatch');
  });

  test('a literal colour outside extensions fails', () {
    section('colors')['primary'] = '#FF0096FA';
    expectRejected('literal colours belong in "extensions"');
  });

  test('a malformed extension colour fails', () {
    (section('extensions')['barrier'] as Map<String, dynamic>)['light'] = 'red';
    expectRejected('use a token reference or #AARRGGBB');
  });

  test('a bad duration fails', () {
    section('motion')['fast'] = '2 seconds';
    expectRejected('must be a duration');
  });

  test('a non-numeric size fails', () {
    section('sizes')['iconSm'] = 'big';
    expectRejected('must be a number or a token reference');
  });

  test('unknown top-level key fails', () {
    pack['colours'] = <String, dynamic>{};
    expectRejected('unknown top-level keys: colours');
  });

  test('invalid JSON fails', () {
    expect(
      () => PackGenerator(bundle: bundle, packJson: '{', contract: contract).render(),
      throwsA(isA<TokenGenerationException>()),
    );
  });

  test('token references are collected for the diff', () {
    final generator = generatorFor(pack)..render();
    expect(generator.references['color.container/primary/default'], contains('colors.primary'));
    expect(generator.references['space.component/10'], contains('space.xs'));
  });

  test('the diff names the pack roles a changed token affects', () {
    final generator = generatorFor(pack)..render();
    final before = <String, Object>{
      'light': <String, Object>{'color.container/primary/default': 'rgba(0, 150, 250, 1)'},
      'dark': <String, Object>{},
    };
    final after = <String, Object>{
      'light': <String, Object>{'color.container/primary/default': 'rgba(0, 0, 0, 1)'},
      'dark': <String, Object>{},
    };
    final diff = TokenDiff.between(before, after, packReferences: generator.references);
    expect(diff.affectedPackNames['color.container/primary/default'], contains('colors.primary'));
    expect(diff.renderMarkdown(), contains('## Pack roles affected'));
  });
}
