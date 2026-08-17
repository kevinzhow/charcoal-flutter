/// The documentation depth available for a catalog entry.
enum CharcoalDocumentationLevel {
  /// API data was generated from the public Dart source.
  generated,

  /// Usage guidance and executable examples were reviewed by maintainers.
  curated,
}

/// Whether a token expresses a design role or an implementation palette primitive.
enum CharcoalTokenTier { semantic, primitive }

/// The public foundation group that owns a token.
enum CharcoalTokenKind { color, dimension, typography }

/// A stable snapshot of the public Charcoal UI component surface.
final class CharcoalCatalog {
  const CharcoalCatalog({
    required this.schemaVersion,
    required this.libraryName,
    required this.libraryVersion,
    required this.designRules,
    required this.patterns,
    required this.components,
    required this.tokens,
    required this.coverage,
  });

  factory CharcoalCatalog.fromJson(Map<String, Object?> json) {
    return CharcoalCatalog(
      schemaVersion: json['schemaVersion'] as int,
      libraryName: json['libraryName'] as String,
      libraryVersion: json['libraryVersion'] as String,
      designRules: (json['designRules'] as List<Object?>)
          .map((value) => CharcoalDesignRuleDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      patterns: (json['patterns'] as List<Object?>)
          .map((value) => CharcoalPatternDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      components: (json['components'] as List<Object?>)
          .map((value) => CharcoalComponentDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      tokens: (json['tokens'] as List<Object?>)
          .map((value) => CharcoalTokenDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      coverage: CharcoalCatalogCoverage.fromJson(json['coverage'] as Map<String, Object?>),
    );
  }

  final int schemaVersion;
  final String libraryName;
  final String libraryVersion;
  final List<CharcoalDesignRuleDoc> designRules;
  final List<CharcoalPatternDoc> patterns;
  final List<CharcoalComponentDoc> components;
  final List<CharcoalTokenDoc> tokens;
  final CharcoalCatalogCoverage coverage;

  CharcoalComponentDoc? componentNamed(String name) {
    final normalized = name.toLowerCase();
    for (final component in components) {
      if (component.name.toLowerCase() == normalized) return component;
    }
    return null;
  }

  CharcoalPatternDoc? patternNamed(String id) {
    final normalized = id.toLowerCase();
    for (final pattern in patterns) {
      if (pattern.id.toLowerCase() == normalized) return pattern;
    }
    return null;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'schemaVersion': schemaVersion,
    'libraryName': libraryName,
    'libraryVersion': libraryVersion,
    'coverage': coverage.toJson(),
    'designRules': designRules.map((rule) => rule.toJson()).toList(growable: false),
    'patterns': patterns.map((pattern) => pattern.toJson()).toList(growable: false),
    'components': components.map((component) => component.toJson()).toList(growable: false),
    'tokens': tokens.map((token) => token.toJson()).toList(growable: false),
  };
}

/// Summary numbers make partial documentation explicit to both people and tools.
final class CharcoalCatalogCoverage {
  const CharcoalCatalogCoverage({
    required this.publicComponents,
    required this.curatedComponents,
    required this.componentsWithExamples,
    required this.curatedPatterns,
    required this.publicTokens,
    required this.semanticTokens,
  });

  factory CharcoalCatalogCoverage.fromJson(Map<String, Object?> json) {
    return CharcoalCatalogCoverage(
      publicComponents: json['publicComponents'] as int,
      curatedComponents: json['curatedComponents'] as int,
      componentsWithExamples: json['componentsWithExamples'] as int,
      curatedPatterns: json['curatedPatterns'] as int,
      publicTokens: json['publicTokens'] as int,
      semanticTokens: json['semanticTokens'] as int,
    );
  }

  final int publicComponents;
  final int curatedComponents;
  final int componentsWithExamples;
  final int curatedPatterns;
  final int publicTokens;
  final int semanticTokens;

  Map<String, Object?> toJson() => <String, Object?>{
    'publicComponents': publicComponents,
    'curatedComponents': curatedComponents,
    'componentsWithExamples': componentsWithExamples,
    'curatedPatterns': curatedPatterns,
    'publicTokens': publicTokens,
    'semanticTokens': semanticTokens,
  };
}

/// One page-level design question with the output and evidence required from an agent.
final class CharcoalDesignRuleDoc {
  const CharcoalDesignRuleDoc({
    required this.id,
    required this.order,
    required this.question,
    required this.requiredOutput,
    required this.validation,
  });

  factory CharcoalDesignRuleDoc.fromJson(Map<String, Object?> json) {
    return CharcoalDesignRuleDoc(
      id: json['id'] as String,
      order: json['order'] as int,
      question: json['question'] as String,
      requiredOutput: json['requiredOutput'] as String,
      validation: json['validation'] as String,
    );
  }

  final String id;
  final int order;
  final String question;
  final String requiredOutput;
  final String validation;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'order': order,
    'question': question,
    'requiredOutput': requiredOutput,
    'validation': validation,
  };
}

/// A reviewed, reusable multi-component composition contract.
///
/// Patterns document page-level composition and state ownership; they are not runtime recipes.
final class CharcoalPatternDoc {
  const CharcoalPatternDoc({
    required this.id,
    required this.category,
    required this.summary,
    required this.keywords,
    required this.useWhen,
    required this.avoidWhen,
    required this.components,
    required this.composition,
    required this.interactionStates,
    required this.feedback,
    required this.accessibility,
    required this.responsiveBehavior,
  });

  factory CharcoalPatternDoc.fromJson(Map<String, Object?> json) {
    return CharcoalPatternDoc(
      id: json['id'] as String,
      category: json['category'] as String,
      summary: json['summary'] as String,
      keywords: _strings(json['keywords']),
      useWhen: _strings(json['useWhen']),
      avoidWhen: _strings(json['avoidWhen']),
      components: _strings(json['components']),
      composition: _strings(json['composition']),
      interactionStates: _strings(json['interactionStates']),
      feedback: _strings(json['feedback']),
      accessibility: _strings(json['accessibility']),
      responsiveBehavior: _strings(json['responsiveBehavior']),
    );
  }

  final String id;
  final String category;
  final String summary;
  final List<String> keywords;
  final List<String> useWhen;
  final List<String> avoidWhen;
  final List<String> components;
  final List<String> composition;
  final List<String> interactionStates;
  final List<String> feedback;
  final List<String> accessibility;
  final List<String> responsiveBehavior;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'category': category,
    'summary': summary,
    'keywords': keywords,
    'useWhen': useWhen,
    'avoidWhen': avoidWhen,
    'components': components,
    'composition': composition,
    'interactionStates': interactionStates,
    'feedback': feedback,
    'accessibility': accessibility,
    'responsiveBehavior': responsiveBehavior,
  };
}

/// One generated foundation token with its exact Flutter accessor and resolved values.
final class CharcoalTokenDoc {
  const CharcoalTokenDoc({
    required this.path,
    required this.dartAccessor,
    required this.kind,
    required this.tier,
    required this.valueType,
    required this.lightValue,
    required this.darkValue,
    required this.guidance,
  });

  factory CharcoalTokenDoc.fromJson(Map<String, Object?> json) {
    return CharcoalTokenDoc(
      path: json['path'] as String,
      dartAccessor: json['dartAccessor'] as String,
      kind: CharcoalTokenKind.values.byName(json['kind'] as String),
      tier: CharcoalTokenTier.values.byName(json['tier'] as String),
      valueType: json['valueType'] as String,
      lightValue: json['lightValue'] as String,
      darkValue: json['darkValue'] as String,
      guidance: json['guidance'] as String,
    );
  }

  final String path;
  final String dartAccessor;
  final CharcoalTokenKind kind;
  final CharcoalTokenTier tier;
  final String valueType;
  final String lightValue;
  final String darkValue;
  final String guidance;

  Map<String, Object?> toJson() => <String, Object?>{
    'path': path,
    'dartAccessor': dartAccessor,
    'kind': kind.name,
    'tier': tier.name,
    'valueType': valueType,
    'lightValue': lightValue,
    'darkValue': darkValue,
    'guidance': guidance,
  };
}

/// One discoverable Charcoal component and the context needed to use it safely.
final class CharcoalComponentDoc {
  const CharcoalComponentDoc({
    required this.name,
    required this.category,
    required this.summary,
    required this.import,
    required this.sourcePath,
    required this.documentationLevel,
    required this.keywords,
    required this.useWhen,
    required this.avoidWhen,
    required this.accessibility,
    required this.responsiveBehavior,
    required this.interactionStates,
    required this.feedbackResponsibilities,
    required this.tokenRoles,
    required this.relatedComponents,
    required this.apis,
    required this.examples,
  });

  factory CharcoalComponentDoc.fromJson(Map<String, Object?> json) {
    return CharcoalComponentDoc(
      name: json['name'] as String,
      category: json['category'] as String,
      summary: json['summary'] as String,
      import: json['import'] as String,
      sourcePath: json['sourcePath'] as String,
      documentationLevel: CharcoalDocumentationLevel.values.byName(
        json['documentationLevel'] as String,
      ),
      keywords: _strings(json['keywords']),
      useWhen: _strings(json['useWhen']),
      avoidWhen: _strings(json['avoidWhen']),
      accessibility: _strings(json['accessibility']),
      responsiveBehavior: _strings(json['responsiveBehavior']),
      interactionStates: _strings(json['interactionStates']),
      feedbackResponsibilities: _strings(json['feedbackResponsibilities']),
      tokenRoles: _strings(json['tokenRoles']),
      relatedComponents: _strings(json['relatedComponents']),
      apis: (json['apis'] as List<Object?>)
          .map((value) => CharcoalApiDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      examples: (json['examples'] as List<Object?>)
          .map((value) => CharcoalExampleDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
    );
  }

  final String name;
  final String category;
  final String summary;
  final String import;
  final String sourcePath;
  final CharcoalDocumentationLevel documentationLevel;
  final List<String> keywords;
  final List<String> useWhen;
  final List<String> avoidWhen;
  final List<String> accessibility;
  final List<String> responsiveBehavior;
  final List<String> interactionStates;
  final List<String> feedbackResponsibilities;
  final List<String> tokenRoles;
  final List<String> relatedComponents;
  final List<CharcoalApiDoc> apis;
  final List<CharcoalExampleDoc> examples;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'category': category,
    'summary': summary,
    'import': import,
    'sourcePath': sourcePath,
    'documentationLevel': documentationLevel.name,
    'keywords': keywords,
    'useWhen': useWhen,
    'avoidWhen': avoidWhen,
    'accessibility': accessibility,
    'responsiveBehavior': responsiveBehavior,
    'interactionStates': interactionStates,
    'feedbackResponsibilities': feedbackResponsibilities,
    'tokenRoles': tokenRoles,
    'relatedComponents': relatedComponents,
    'apis': apis.map((api) => api.toJson()).toList(growable: false),
    'examples': examples.map((example) => example.toJson()).toList(growable: false),
  };
}

/// A public constructor, top-level function, enum, or companion type.
final class CharcoalApiDoc {
  const CharcoalApiDoc({
    required this.name,
    required this.kind,
    required this.signature,
    this.parameters = const <CharcoalParameterDoc>[],
    this.enumValues = const <String>[],
  });

  factory CharcoalApiDoc.fromJson(Map<String, Object?> json) {
    return CharcoalApiDoc(
      name: json['name'] as String,
      kind: json['kind'] as String,
      signature: json['signature'] as String,
      parameters: (json['parameters'] as List<Object?>)
          .map((value) => CharcoalParameterDoc.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      enumValues: _strings(json['enumValues']),
    );
  }

  final String name;
  final String kind;
  final String signature;
  final List<CharcoalParameterDoc> parameters;
  final List<String> enumValues;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'kind': kind,
    'signature': signature,
    'parameters': parameters.map((parameter) => parameter.toJson()).toList(growable: false),
    'enumValues': enumValues,
  };
}

/// Structured constructor or function parameter data for code-generation clients.
final class CharcoalParameterDoc {
  const CharcoalParameterDoc({
    required this.name,
    required this.type,
    required this.required,
    required this.named,
    this.defaultValue,
  });

  factory CharcoalParameterDoc.fromJson(Map<String, Object?> json) {
    return CharcoalParameterDoc(
      name: json['name'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      named: json['named'] as bool,
      defaultValue: json['defaultValue'] as String?,
    );
  }

  final String name;
  final String type;
  final bool required;
  final bool named;
  final String? defaultValue;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'type': type,
    'required': required,
    'named': named,
    if (defaultValue != null) 'defaultValue': defaultValue,
  };
}

/// Compilable source copied from the repository at catalog generation time.
final class CharcoalExampleDoc {
  const CharcoalExampleDoc({
    required this.id,
    required this.title,
    required this.description,
    required this.sourcePath,
    required this.source,
  });

  factory CharcoalExampleDoc.fromJson(Map<String, Object?> json) {
    return CharcoalExampleDoc(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      sourcePath: json['sourcePath'] as String,
      source: json['source'] as String,
    );
  }

  final String id;
  final String title;
  final String description;
  final String sourcePath;
  final String source;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'title': title,
    'description': description,
    'sourcePath': sourcePath,
    'source': source,
  };
}

List<String> _strings(Object? value) => (value as List<Object?>).cast<String>();
