import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../runner.dart';

final class DesignRulesCommand extends CharcoalCommand {
  DesignRulesCommand(super.environment);

  @override
  String get description =>
      'Print the versioned page-design questions and five-stage verification process.';

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
        'process': charcoalCatalog.designProcess
            .map((stage) => stage.toJson())
            .toList(growable: false),
      },
      text:
          '${charcoalCatalog.designRules.map(
            (rule) => '${rule.order}. ${rule.question}\n'
                '   Output: ${rule.requiredOutput}\n'
                '   Complete when: ${rule.validation}',
          ).join('\n\n')}\n\n'
          'Verification process\n'
          '${charcoalCatalog.designProcess.map(
            (stage) => '${stage.order}. ${stage.title}: ${stage.goal}',
          ).join('\n')}',
    );
    return ExitCode.success.code;
  }
}
