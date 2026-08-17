import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../runner.dart';

final class DesignRulesCommand extends CharcoalCommand {
  DesignRulesCommand(super.environment);

  @override
  String get description => 'Print the versioned page-design questions and completion criteria.';

  @override
  String get name => 'design-rules';

  @override
  int run() {
    environment.result(
      'designRules',
      <String, Object?>{
        'catalogSchemaVersion': charcoalCatalog.schemaVersion,
        'libraryVersion': charcoalCatalog.libraryVersion,
        'rules': charcoalCatalog.designRules.map((rule) => rule.toJson()).toList(growable: false),
      },
      text: charcoalCatalog.designRules
          .map(
            (rule) =>
                '${rule.order}. ${rule.question}\n'
                '   Output: ${rule.requiredOutput}\n'
                '   Complete when: ${rule.validation}',
          )
          .join('\n\n'),
    );
    return ExitCode.success.code;
  }
}
