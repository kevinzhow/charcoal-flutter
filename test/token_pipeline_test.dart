import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/dart_token_generator.dart';
import '../tool/src/token_pipeline.dart';

void main() {
  test('checked-in sources exactly reproduce generated artifacts', () async {
    final problems = await TokenPipeline(Directory.current).check();
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('component recipe additions cannot be silently ignored', () async {
    final pipeline = TokenPipeline(Directory.current);
    final bundle = await pipeline.loadBundle();
    final recipes = decodeComponentRecipes(await File('tokens/components.json').readAsString());
    final button = recipes['button']! as Map<String, dynamic>;
    button['misspelled-new-value'] = '4px';

    expect(
      () => DartTokenGenerator(bundle: bundle, componentRecipes: recipes).render(),
      throwsA(
        predicate<Object>(
          (error) => error.toString().contains('button.misspelled-new-value'),
        ),
      ),
    );
  });
}
