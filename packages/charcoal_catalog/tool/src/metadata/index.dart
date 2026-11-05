import 'actions.dart';
import 'admin.dart';
import 'feedback.dart';
import 'fields.dart';
import 'forms.dart';
import 'layout.dart';
import 'navigation.dart';
import 'overlays.dart';
import 'patterns.dart';
import 'rules.dart';
import 'supporting.dart';
import 'theme.dart';

final class ComponentMetadata {
  const ComponentMetadata({
    required this.category,
    required this.summary,
    required this.keywords,
    required this.useWhen,
    required this.avoidWhen,
    required this.accessibility,
    required this.responsiveBehavior,
    this.interactionStates = const <String>[],
    this.feedbackResponsibilities = const <String>[],
    required this.tokenRoles,
    required this.relatedComponents,
    required this.companionDeclarations,
    required this.examples,
  });

  final String category;
  final String summary;
  final List<String> keywords;
  final List<String> useWhen;
  final List<String> avoidWhen;
  final List<String> accessibility;
  final List<String> responsiveBehavior;
  final List<String> interactionStates;
  final List<String> feedbackResponsibilities;
  final List<String> tokenRoles;
  final List<String> relatedComponents;
  final List<String> companionDeclarations;
  final List<ExampleMetadata> examples;
}

final class ExampleMetadata {
  const ExampleMetadata({
    required this.id,
    required this.title,
    required this.description,
    required this.sourcePath,
  });

  final String id;
  final String title;
  final String description;
  final String sourcePath;
}

/// All component metadata, merged from the per-family fragment files.
const Map<String, ComponentMetadata> componentMetadata = <String, ComponentMetadata>{
  ...themeMetadata,
  ...actionsMetadata,
  ...adminMetadata,
  ...feedbackMetadata,
  ...formsMetadata,
  ...layoutMetadata,
  ...supportingMetadata,
  ...fieldsMetadata,
  ...navigationMetadata,
  ...overlaysMetadata,
  ...patternsMetadata,
  ...rulesMetadata,
};
