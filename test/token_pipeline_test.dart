import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/dart_token_generator.dart';
import '../tool/src/token_pipeline.dart';

void main() {
  test('checked-in sources exactly reproduce generated artifacts', () async {
    final problems = await TokenPipeline(Directory.current).check();
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('generator emits only foundation token artifacts', () async {
    final pipeline = TokenPipeline(Directory.current);
    final bundle = await pipeline.loadBundle();
    expect(
      DartTokenGenerator(bundle: bundle).render().map((artifact) => artifact.relativePath),
      <String>[
        'packages/charcoal_tokens/lib/src/generated/charcoal_color_tokens.g.dart',
        'packages/charcoal_tokens/lib/src/generated/charcoal_dimension_tokens.g.dart',
        'packages/charcoal_tokens/lib/src/generated/charcoal_typography_tokens.g.dart',
      ],
    );
  });
}
