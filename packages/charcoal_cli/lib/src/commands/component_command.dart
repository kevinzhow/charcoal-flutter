import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../catalog_search.dart';
import '../environment.dart';
import '../runner.dart';

final class ComponentCommand extends CharcoalCommand {
  ComponentCommand(super.environment);

  @override
  String get description =>
      'Print structured API guidance and executable examples for a component.';

  @override
  String get name => 'component';

  @override
  String get invocation => 'charcoal component <name>';

  @override
  bool get takesArguments => true;

  @override
  int run() {
    final query = argResults!.rest.join(' ').trim();
    if (query.isEmpty) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        'component requires a component name.',
        exitCode: ExitCode.usage.code,
      );
    }
    final search = CharcoalCatalogSearch(charcoalCatalog);
    final component = search.exact(query);
    if (component == null) {
      throw CharcoalCliFailure(
        'ERR_UNKNOWN_COMPONENT',
        'No component named "$query" exists in charcoal_ui ${charcoalCatalog.libraryVersion}.',
        suggestions: search.suggestions(query),
      );
    }
    environment.result('component', component.toJson(), text: _componentText(component));
    return ExitCode.success.code;
  }
}

String _componentText(CharcoalComponentDoc component) {
  final buffer = StringBuffer()
    ..writeln('${component.name} [${component.category}]')
    ..writeln(component.summary)
    ..writeln()
    ..writeln('Import: ${component.import}')
    ..writeln('Documentation: ${component.documentationLevel.name}');
  if (component.useWhen.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('Use when:');
    for (final item in component.useWhen) {
      buffer.writeln('- $item');
    }
  }
  if (component.avoidWhen.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('Avoid when:');
    for (final item in component.avoidWhen) {
      buffer.writeln('- $item');
    }
  }
  buffer
    ..writeln()
    ..writeln('Public API:');
  for (final api in component.apis) {
    buffer.writeln('- ${api.signature}');
  }
  if (component.accessibility.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('Accessibility:');
    for (final item in component.accessibility) {
      buffer.writeln('- $item');
    }
  }
  if (component.responsiveBehavior.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('Responsive behavior:');
    for (final item in component.responsiveBehavior) {
      buffer.writeln('- $item');
    }
  }
  for (final example in component.examples) {
    buffer
      ..writeln()
      ..writeln('Example: ${example.title} (${example.sourcePath})')
      ..writeln(example.source.trimRight());
  }
  return buffer.toString().trimRight();
}
