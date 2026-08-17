import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:charcoal_catalog/src/model.dart';
import 'package:path/path.dart' as p;

import 'design_guidance.dart';
import 'metadata.dart';

const Set<String> _widgetBaseTypes = <String>{
  'InheritedTheme',
  'SingleChildRenderObjectWidget',
  'StatefulWidget',
  'StatelessWidget',
};

final class GeneratedCatalog {
  const GeneratedCatalog({required this.catalog, required this.json, required this.dartSource});

  final CharcoalCatalog catalog;
  final String json;
  final String dartSource;
}

GeneratedCatalog buildCatalog(Directory workspaceRoot) {
  final uiRoot = Directory(p.join(workspaceRoot.path, 'packages', 'charcoal_ui'));
  final libraryFile = File(p.join(uiRoot.path, 'lib', 'charcoal_ui.dart'));
  if (!libraryFile.existsSync()) {
    throw StateError('Could not find packages/charcoal_ui/lib/charcoal_ui.dart.');
  }

  final libraryUnit = parseString(
    content: libraryFile.readAsStringSync(),
    path: libraryFile.path,
    throwIfDiagnostics: false,
  ).unit;
  final exportedFiles = libraryUnit.directives
      .whereType<ExportDirective>()
      .map((directive) => directive.uri.stringValue)
      .whereType<String>()
      .where((uri) => !uri.startsWith('package:'))
      .map((uri) => File(p.normalize(p.join(uiRoot.path, 'lib', uri))))
      .toList(growable: false);

  final declarationIndex = <String, _IndexedDeclaration>{};
  final widgetDeclarations = <_IndexedDeclaration>[];
  for (final file in exportedFiles) {
    if (!file.existsSync()) {
      throw StateError('Exported file does not exist: ${file.path}');
    }
    final unit = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    ).unit;
    final sourcePath = _relativePath(workspaceRoot, file);
    for (final declaration in unit.declarations) {
      final name = _declarationName(declaration);
      if (name == null || name.startsWith('_')) continue;
      declarationIndex[name] = _IndexedDeclaration(declaration, sourcePath);
      if (declaration case final ClassDeclaration classDeclaration) {
        final superclass = classDeclaration.extendsClause?.superclass.name.lexeme;
        if (name.startsWith('Charcoal') && _widgetBaseTypes.contains(superclass)) {
          widgetDeclarations.add(_IndexedDeclaration(classDeclaration, sourcePath));
        }
      }
    }
  }

  final components = <CharcoalComponentDoc>[];
  for (final indexed in widgetDeclarations) {
    final declaration = indexed.node as ClassDeclaration;
    final name = declaration.namePart.typeName.lexeme;
    final metadata = componentMetadata[name];
    final examples = <CharcoalExampleDoc>[];
    if (metadata != null) {
      for (final example in metadata.examples) {
        final exampleFile = File(p.join(workspaceRoot.path, example.sourcePath));
        if (!exampleFile.existsSync()) {
          throw StateError('Catalog example does not exist: ${example.sourcePath}');
        }
        examples.add(
          CharcoalExampleDoc(
            id: example.id,
            title: example.title,
            description: example.description,
            sourcePath: example.sourcePath,
            source: exampleFile.readAsStringSync(),
          ),
        );
      }
    }

    final apis = <CharcoalApiDoc>[
      ..._classApis(declaration, primary: true),
      if (metadata != null)
        for (final companionName in metadata.companionDeclarations)
          ..._companionApis(companionName, declarationIndex),
    ];
    components.add(
      CharcoalComponentDoc(
        name: name,
        category: metadata?.category ?? _categoryFor(indexed.sourcePath),
        summary: metadata?.summary ?? _summaryFor(declaration, name),
        import: 'package:charcoal_ui/charcoal_ui.dart',
        sourcePath: indexed.sourcePath,
        documentationLevel: metadata == null
            ? CharcoalDocumentationLevel.generated
            : CharcoalDocumentationLevel.curated,
        keywords: metadata?.keywords ?? _keywordsFor(name),
        useWhen: metadata?.useWhen ?? const <String>[],
        avoidWhen: metadata?.avoidWhen ?? const <String>[],
        accessibility: metadata?.accessibility ?? const <String>[],
        responsiveBehavior: metadata?.responsiveBehavior ?? const <String>[],
        interactionStates: metadata?.interactionStates ?? const <String>[],
        feedbackResponsibilities: metadata?.feedbackResponsibilities ?? const <String>[],
        tokenRoles: metadata?.tokenRoles ?? const <String>[],
        relatedComponents: metadata?.relatedComponents ?? const <String>[],
        apis: apis,
        examples: examples,
      ),
    );
  }
  components.sort((left, right) => left.name.compareTo(right.name));
  final componentNames = components.map((component) => component.name).toSet();
  for (final pattern in componentPatterns) {
    final unknown = pattern.components.where((name) => !componentNames.contains(name));
    if (unknown.isNotEmpty) {
      throw StateError('${pattern.id} references unknown components: ${unknown.join(', ')}.');
    }
  }
  final tokens = _buildTokens(workspaceRoot);

  final curatedCount = components
      .where((component) => component.documentationLevel == CharcoalDocumentationLevel.curated)
      .length;
  final exampleCount = components.where((component) => component.examples.isNotEmpty).length;
  final catalog = CharcoalCatalog(
    schemaVersion: 3,
    libraryName: 'charcoal_ui',
    libraryVersion: _packageVersion(File(p.join(uiRoot.path, 'pubspec.yaml'))),
    designRules: pageDesignRules,
    patterns: componentPatterns,
    coverage: CharcoalCatalogCoverage(
      publicComponents: components.length,
      curatedComponents: curatedCount,
      componentsWithExamples: exampleCount,
      curatedPatterns: componentPatterns.length,
      publicTokens: tokens.length,
      semanticTokens: tokens.where((token) => token.tier == CharcoalTokenTier.semantic).length,
    ),
    components: components,
    tokens: tokens,
  );
  final json = const JsonEncoder.withIndent('  ').convert(catalog.toJson());
  if (json.contains("'''")) {
    throw StateError("Catalog JSON cannot be embedded in a raw triple-quoted Dart string.");
  }
  final dartSource =
      '// GENERATED CODE - DO NOT MODIFY BY HAND.\n\n'
      "const String generatedCatalogJson = r'''$json''';\n";
  return GeneratedCatalog(catalog: catalog, json: '$json\n', dartSource: dartSource);
}

Directory findWorkspaceRoot(Directory start) {
  var current = start.absolute;
  while (true) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('charcoal_flutter_workspace')) {
      return current;
    }
    if (current.parent.path == current.path) {
      throw StateError('Could not find the charcoal_flutter_workspace root from ${start.path}.');
    }
    current = current.parent;
  }
}

String catalogJsonPath(Directory root) =>
    p.join(root.path, 'packages', 'charcoal_catalog', 'catalog', 'charcoal_catalog.json');

String catalogDartPath(Directory root) =>
    p.join(root.path, 'packages', 'charcoal_catalog', 'lib', 'src', 'generated', 'catalog.g.dart');

List<CharcoalTokenDoc> _buildTokens(Directory workspaceRoot) {
  final snapshotFile = File(p.join(workspaceRoot.path, 'tokens', 'snapshot.json'));
  final snapshot = jsonDecode(snapshotFile.readAsStringSync()) as Map<String, Object?>;
  final light = (snapshot['light']! as Map<String, Object?>).cast<String, Object?>();
  final dark = (snapshot['dark']! as Map<String, Object?>).cast<String, Object?>();
  final generatedRoot = p.join(
    workspaceRoot.path,
    'packages',
    'charcoal_tokens',
    'lib',
    'src',
    'generated',
  );
  final sources = <CharcoalTokenKind, String>{
    CharcoalTokenKind.color: File(
      p.join(generatedRoot, 'charcoal_color_tokens.g.dart'),
    ).readAsStringSync(),
    CharcoalTokenKind.dimension: File(
      p.join(generatedRoot, 'charcoal_dimension_tokens.g.dart'),
    ).readAsStringSync(),
    CharcoalTokenKind.typography: File(
      p.join(generatedRoot, 'charcoal_typography_tokens.g.dart'),
    ).readAsStringSync(),
  };
  final entryPattern = RegExp(
    r"Charcoal(?:Color|Dimension|Typography)TokenEntry(?:<[^>]+>)?\(\s*"
    r"path:\s*'([^']+)',\s*value:\s*([A-Za-z0-9_]+),?\s*\)",
    dotAll: true,
  );
  final tokens = <CharcoalTokenDoc>[];
  for (final source in sources.entries) {
    for (final match in entryPattern.allMatches(source.value)) {
      final path = match.group(1)!;
      final field = match.group(2)!;
      final lightValue = light[path];
      final darkValue = dark[path];
      if (lightValue == null || darkValue == null) {
        throw StateError('Generated token $path is missing from tokens/snapshot.json.');
      }
      final tier = _tokenTier(path, source.key);
      tokens.add(
        CharcoalTokenDoc(
          path: path,
          dartAccessor: _tokenAccessor(path, field, source.key, tier),
          kind: source.key,
          tier: tier,
          valueType: _tokenValueType(path, source.key),
          lightValue: lightValue.toString(),
          darkValue: darkValue.toString(),
          guidance: _tokenGuidance(path, source.key, tier),
        ),
      );
    }
  }
  tokens.sort((left, right) => left.path.compareTo(right.path));
  final paths = tokens.map((token) => token.path).toSet();
  if (paths.length != tokens.length) throw StateError('Generated token paths are not unique.');
  return tokens;
}

CharcoalTokenTier _tokenTier(String path, CharcoalTokenKind kind) {
  if (kind != CharcoalTokenKind.color) return CharcoalTokenTier.semantic;
  const semanticPrefixes = <String>[
    'color.background/',
    'color.border/',
    'color.container/',
    'color.icon/',
    'color.text/',
  ];
  return semanticPrefixes.any(path.startsWith)
      ? CharcoalTokenTier.semantic
      : CharcoalTokenTier.primitive;
}

String _tokenAccessor(
  String path,
  String field,
  CharcoalTokenKind kind,
  CharcoalTokenTier tier,
) {
  return switch (kind) {
    CharcoalTokenKind.color when tier == CharcoalTokenTier.semantic => 'theme.colors.$field',
    CharcoalTokenKind.color when path.startsWith('brand-color.') => 'CharcoalBrandColors.$field',
    CharcoalTokenKind.color => 'CharcoalPrimitiveColors.$field',
    CharcoalTokenKind.dimension => 'theme.dimensions.${_dimensionGroup(path)}.$field',
    CharcoalTokenKind.typography => 'theme.typography.${_typographyGroup(path)}.$field',
  };
}

String _dimensionGroup(String path) {
  if (path.startsWith('border-width.')) return 'borderWidth';
  if (path.startsWith('paragraph-width.')) return 'paragraphWidth';
  if (path.startsWith('radius.')) return 'radius';
  if (path.startsWith('space.')) return 'space';
  throw StateError('Unknown dimension token group: $path');
}

String _typographyGroup(String path) {
  if (path.startsWith('text.font-family/')) return 'fontFamily';
  if (path.startsWith('text.font-size/')) return 'fontSize';
  if (path.startsWith('text.font-weight/')) return 'fontWeight';
  if (path.startsWith('text.line-height/')) return 'lineHeight';
  throw StateError('Unknown typography token group: $path');
}

String _tokenValueType(String path, CharcoalTokenKind kind) {
  return switch (kind) {
    CharcoalTokenKind.color => 'Color',
    CharcoalTokenKind.dimension => 'logicalPixels',
    CharcoalTokenKind.typography when path.startsWith('text.font-family/') => 'String',
    CharcoalTokenKind.typography when path.startsWith('text.font-weight/') => 'FontWeight',
    CharcoalTokenKind.typography => 'logicalPixels',
  };
}

String _tokenGuidance(String path, CharcoalTokenKind kind, CharcoalTokenTier tier) {
  if (tier == CharcoalTokenTier.primitive) {
    return 'Palette primitive. Prefer a semantic theme role; use directly only for audited '
        'foundation work that cannot be expressed semantically.';
  }
  if (path.startsWith('space.layout/')) {
    return 'Layout spacing for page, section, and responsive composition outside component internals.';
  }
  if (path.startsWith('space.component/')) {
    return 'Component-scale spacing. Use for custom compositions; existing Charcoal components own '
        'their internal gaps.';
  }
  if (path.startsWith('space.target/')) {
    return 'Standard interaction target measurement. Do not force it onto a component with its own size API.';
  }
  if (path.startsWith('paragraph-width.')) {
    return 'Readable content-width constraint selected by layout density and available space.';
  }
  if (path.startsWith('radius.')) return 'Semantic corner radius for authored Charcoal surfaces.';
  if (path.startsWith('border-width.')) return 'Semantic border or focus-ring width.';
  if (kind == CharcoalTokenKind.typography) {
    return 'Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text.';
  }
  return 'Semantic color role. Select by UI meaning and state, not by its resolved light/dark value.';
}

List<CharcoalApiDoc> _companionApis(
  String name,
  Map<String, _IndexedDeclaration> declarations,
) {
  final indexed = declarations[name];
  if (indexed == null) throw StateError('Unknown companion declaration: $name');
  return switch (indexed.node) {
    final ClassDeclaration declaration => _classApis(declaration, primary: false),
    final EnumDeclaration declaration => <CharcoalApiDoc>[
      CharcoalApiDoc(
        name: name,
        kind: 'enum',
        signature:
            'enum $name { ${declaration.body.constants.map((value) => value.name.lexeme).join(', ')} }',
        enumValues: declaration.body.constants
            .map((value) => value.name.lexeme)
            .toList(growable: false),
      ),
    ],
    final FunctionDeclaration declaration => <CharcoalApiDoc>[
      _functionApi(declaration),
    ],
    _ => throw StateError('Unsupported companion declaration: $name'),
  };
}

List<CharcoalApiDoc> _classApis(ClassDeclaration declaration, {required bool primary}) {
  final className = declaration.namePart.typeName.lexeme;
  final fieldTypes = <String, String>{};
  for (final field in declaration.body.members.whereType<FieldDeclaration>()) {
    if (field.isStatic) continue;
    final type = field.fields.type?.toSource() ?? 'dynamic';
    for (final variable in field.fields.variables) {
      fieldTypes[variable.name.lexeme] = type;
    }
  }
  final constructors = declaration.body.members
      .whereType<ConstructorDeclaration>()
      .where((constructor) => constructor.name?.lexeme.startsWith('_') != true)
      .toList(growable: false);
  if (constructors.isEmpty) {
    return <CharcoalApiDoc>[
      CharcoalApiDoc(name: className, kind: 'supportingType', signature: 'class $className'),
    ];
  }
  return constructors
      .map((constructor) {
        final constructorName = constructor.name?.lexeme;
        final displayName = constructorName == null ? className : '$className.$constructorName';
        return CharcoalApiDoc(
          name: displayName,
          kind: primary ? 'constructor' : 'supportingType',
          signature: '$displayName${constructor.parameters.toSource()}',
          parameters: _parameters(constructor.parameters, fieldTypes),
        );
      })
      .toList(growable: false);
}

CharcoalApiDoc _functionApi(FunctionDeclaration declaration) {
  final expression = declaration.functionExpression;
  final parameters = expression.parameters;
  final typeParameters = expression.typeParameters?.toSource() ?? '';
  final returnType = declaration.returnType?.toSource() ?? 'dynamic';
  final parameterSource = parameters?.toSource() ?? '()';
  return CharcoalApiDoc(
    name: declaration.name.lexeme,
    kind: 'function',
    signature: '$returnType ${declaration.name.lexeme}$typeParameters$parameterSource',
    parameters: parameters == null
        ? const <CharcoalParameterDoc>[]
        : _parameters(parameters, const <String, String>{}),
  );
}

List<CharcoalParameterDoc> _parameters(
  FormalParameterList parameters,
  Map<String, String> fieldTypes,
) {
  return parameters.parameters
      .map((parameter) {
        final name = parameter.name?.lexeme ?? 'unnamed';
        final inferredType =
            parameter.type?.toSource() ?? fieldTypes[name] ?? (name == 'key' ? 'Key?' : 'dynamic');
        return CharcoalParameterDoc(
          name: name,
          type: inferredType,
          required: parameter.isRequired,
          named: parameter.isNamed,
          defaultValue: parameter.defaultClause?.value.toSource(),
        );
      })
      .toList(growable: false);
}

String? _declarationName(CompilationUnitMember declaration) {
  return switch (declaration) {
    final ClassDeclaration value => value.namePart.typeName.lexeme,
    final EnumDeclaration value => value.namePart.typeName.lexeme,
    final FunctionDeclaration value => value.name.lexeme,
    _ => null,
  };
}

String _summaryFor(ClassDeclaration declaration, String name) {
  final tokens = declaration.documentationComment?.tokens;
  if (tokens == null || tokens.isEmpty) return '$name from the public Charcoal UI API.';
  final lines = tokens
      .expand((token) => token.lexeme.split('\n'))
      .map((line) => line.replaceFirst(RegExp(r'^\s*///?\s?'), '').trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);
  return lines.isEmpty ? '$name from the public Charcoal UI API.' : lines.first;
}

List<String> _keywordsFor(String name) {
  final withoutPrefix = name.replaceFirst('Charcoal', '');
  final phrase = withoutPrefix.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (match) => '${match[1]} ${match[2]}',
  );
  return <String>[name.toLowerCase(), phrase.toLowerCase()];
}

String _categoryFor(String sourcePath) {
  if (sourcePath.contains('/app/')) return 'Application';
  if (sourcePath.contains('/theme/')) return 'Foundation';
  final fileName = p.basenameWithoutExtension(sourcePath);
  return switch (fileName) {
    'button' || 'icon_button' || 'clickable' => 'Actions',
    'checkbox' ||
    'dropdown' ||
    'multi_select' ||
    'radio' ||
    'switch' ||
    'text_area' ||
    'text_field' => 'Forms',
    'balloon' || 'modal' || 'toast' || 'tooltip' => 'Overlays',
    'carousel' || 'navigation_item' || 'pagination' => 'Navigation',
    'typography' || 'text_ellipsis' || 'hint_text' => 'Content',
    _ => 'Utility',
  };
}

String _packageVersion(File pubspec) {
  final match = RegExp(r'^version:\s*([^\s]+)\s*$', multiLine: true).firstMatch(
    pubspec.readAsStringSync(),
  );
  if (match == null) throw StateError('No version found in ${pubspec.path}.');
  return match.group(1)!;
}

String _relativePath(Directory root, File file) =>
    p.relative(file.path, from: root.path).replaceAll('\\', '/');

final class _IndexedDeclaration {
  const _IndexedDeclaration(this.node, this.sourcePath);

  final CompilationUnitMember node;
  final String sourcePath;
}
