import 'dart:convert';
import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:path/path.dart' as p;

import 'page_experience.dart';

const int charcoalAppExperienceReviewVersion = 2;

const Set<String> charcoalAppTransitionStackEffects = <String>{
  'none',
  'push',
  'replace',
  'pop',
  'present',
  'dismiss',
};

const Set<String> charcoalAppReviewAreas = <String>{
  'navigation',
  'hierarchy',
  'product-copy',
  'responsive',
  'accessibility',
};

/// Structural and readiness results for a complete application experience.
final class CharcoalAppExperienceReviewValidation {
  const CharcoalAppExperienceReviewValidation({
    required this.appId,
    required this.problems,
    required this.blockers,
  });

  final String? appId;
  final List<String> problems;
  final List<String> blockers;

  bool get valid => problems.isEmpty;
  bool get ready => valid && blockers.isEmpty;

  Map<String, Object?> toJson() => <String, Object?>{
    'valid': valid,
    'ready': ready,
    'appId': appId,
    'problems': problems,
    'blockers': blockers,
  };
}

Map<String, Object?> buildCharcoalAppExperienceReviewTemplate({
  String appId = 'replace-with-stable-app-id',
  String title = 'Replace with app title',
  CharcoalCatalog? catalog,
}) {
  final activeCatalog = catalog ?? charcoalCatalog;
  return <String, Object?>{
    'schemaVersion': charcoalAppExperienceReviewVersion,
    'catalogSchemaVersion': activeCatalog.schemaVersion,
    'libraryVersion': activeCatalog.libraryVersion,
    'application': <String, Object?>{
      'id': appId,
      'title': title,
      'entrySurfaceId': 'home',
      'supportedLayouts': <String>['compact', 'standard'],
      'stateInventories': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'app-destinations',
          'sourcePath': 'lib/app_destination.dart',
          'enumName': 'AppDestination',
          'mappings': <Map<String, Object?>>[
            <String, Object?>{'value': 'home', 'surfaceId': 'home'},
          ],
          'ignored': const <Map<String, Object?>>[],
        },
      ],
      'surfaces': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'home',
          'title': 'Home',
          'kind': 'destination',
          'widget': 'ReplaceWithHomePage',
          'sourcePath': 'lib/home_page.dart',
          'runtimeKey': 'replace-with-home-runtime-key',
          'specPath': 'agent/page-specs/home.json',
          'intentIds': <String>['primary-outcome'],
          'states': <String>['content'],
          'previews': <Map<String, Object?>>[
            <String, Object?>{
              'name': 'Home',
              'state': 'content',
              'sourcePath': 'lib/previews/home_page_previews.dart',
              'layouts': <String>['compact', 'standard'],
            },
          ],
          'review': <String, Object?>{
            'verdict': 'changes-required',
            'rules': <Map<String, Object?>>[
              for (final rule in activeCatalog.designRules)
                <String, Object?>{
                  'id': rule.id,
                  'verdict': 'changes-required',
                  'evidence': 'Replace with page-specific evidence for ${rule.id}.',
                },
            ],
            'findings': <String>['Replace with a concrete finding or remove it after resolution.'],
          },
        },
      ],
      'transitions': const <Map<String, Object?>>[],
      'runtimeScenarios': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'primary-journey',
          'testName': 'Replace with the exact executable test name',
          'sourcePath': 'test/app_experience_test.dart',
          'surfaceIds': <String>['home'],
          'verdict': 'changes-required',
          'evidence': 'Replace with the runtime behavior verified by the executable test.',
        },
      ],
      'finalReview': <String, Object?>{
        'verdict': 'changes-required',
        'reviewedSurfaceIds': <String>['home'],
        'checks': <Map<String, Object?>>[
          for (final area in charcoalAppReviewAreas)
            <String, Object?>{
              'area': area,
              'verdict': 'changes-required',
              'evidence': 'Replace with cross-surface $area evidence.',
            },
        ],
        'openFindings': <String>['Resolve every finding before claiming Agent Ready.'],
      },
    },
  };
}

CharcoalAppExperienceReviewValidation validateCharcoalAppExperienceReview(
  Map<String, Object?> review, {
  CharcoalCatalog? catalog,
  Directory? projectRoot,
}) {
  final activeCatalog = catalog ?? charcoalCatalog;
  final problems = <String>[];
  final blockers = <String>[];
  if (review['schemaVersion'] != charcoalAppExperienceReviewVersion) {
    problems.add('schemaVersion must equal $charcoalAppExperienceReviewVersion.');
  }
  if (review['catalogSchemaVersion'] != activeCatalog.schemaVersion) {
    problems.add('catalogSchemaVersion must equal ${activeCatalog.schemaVersion}.');
  }
  if (review['libraryVersion'] != activeCatalog.libraryVersion) {
    problems.add('libraryVersion must equal ${activeCatalog.libraryVersion}.');
  }

  final application = _object(review['application'], 'application', problems);
  if (application == null) {
    return CharcoalAppExperienceReviewValidation(
      appId: null,
      problems: problems,
      blockers: blockers,
    );
  }
  final appId = _requiredString(application, 'id', 'application', problems);
  _requiredString(application, 'title', 'application', problems);
  final entrySurfaceId = _requiredString(
    application,
    'entrySurfaceId',
    'application',
    problems,
  );
  final supportedLayouts = _stringList(
    application,
    'supportedLayouts',
    'application',
    problems,
    allowEmpty: false,
  ).toSet();

  final surfaces = _objectList(application, 'surfaces', 'application', problems);
  final surfaceIds = <String>{};
  final surfaceKinds = <String, String>{};
  final surfaceRuntimeKeys = <String, String>{};
  final runtimeKeys = <String>{};
  final previewNames = <String>{};
  for (final (index, surface) in surfaces.indexed) {
    final context = 'application.surfaces[$index]';
    final id = _requiredString(surface, 'id', context, problems);
    if (id != null && !surfaceIds.add(id)) problems.add('$context.id must be unique.');
    _requiredString(surface, 'title', context, problems);
    final kind = _requiredString(surface, 'kind', context, problems);
    if (kind != null &&
        !const <String>{
          'destination',
          'detail',
          'task',
          'modal',
          'sheet',
          'overlay',
          'result',
        }.contains(kind)) {
      problems.add('$context.kind is not supported.');
    }
    if (id != null && kind != null) surfaceKinds[id] = kind;
    final widget = _requiredString(surface, 'widget', context, problems);
    final sourcePath = _requiredString(surface, 'sourcePath', context, problems);
    final runtimeKey = _requiredString(surface, 'runtimeKey', context, problems);
    if (runtimeKey != null && !runtimeKeys.add(runtimeKey)) {
      problems.add('$context.runtimeKey must be unique.');
    }
    if (id != null && runtimeKey != null) surfaceRuntimeKeys[id] = runtimeKey;
    final specPath = _requiredString(surface, 'specPath', context, problems);
    final intentIds = _stringList(
      surface,
      'intentIds',
      context,
      problems,
      allowEmpty: false,
    );
    final states = _stringList(surface, 'states', context, problems, allowEmpty: false).toSet();

    if (projectRoot != null) {
      final source = _projectFile(projectRoot, sourcePath, '$context.sourcePath', problems);
      if (source != null && source.existsSync()) {
        final sourceText = source.readAsStringSync();
        if (widget != null && !sourceText.contains('class $widget')) {
          problems.add('$context.widget "$widget" is not declared in $sourcePath.');
        }
        if (runtimeKey != null && !sourceText.contains(runtimeKey)) {
          problems.add('$context.runtimeKey "$runtimeKey" is not present in $sourcePath.');
        }
      }

      final specFile = _projectFile(projectRoot, specPath, '$context.specPath', problems);
      if (specFile != null && specFile.existsSync()) {
        final spec = _readObject(specFile, '$context.specPath', problems);
        if (spec != null) {
          final report = validateCharcoalPageExperienceSpec(spec, catalog: activeCatalog);
          for (final problem in report.problems) {
            problems.add('$context.specPath: $problem');
          }
          final specIntentIds = _intentIds(spec);
          for (final intentId in intentIds.where((value) => !specIntentIds.contains(value))) {
            problems.add(
              '$context.intentIds references "$intentId", which is absent from $specPath.',
            );
          }
          final specLayouts = _pageLayouts(spec);
          final missingSpecLayouts = supportedLayouts.difference(specLayouts);
          if (missingSpecLayouts.isNotEmpty) {
            problems.add(
              '$context.specPath does not support application layouts: ${_sorted(missingSpecLayouts)}.',
            );
          }
        }
      }
    }

    final previews = _objectList(surface, 'previews', context, problems);
    final previewCoverage = <String, Set<String>>{};
    for (final (previewIndex, preview) in previews.indexed) {
      final previewContext = '$context.previews[$previewIndex]';
      final name = _requiredString(preview, 'name', previewContext, problems);
      if (name != null && !previewNames.add(name)) {
        problems.add('$previewContext.name must be unique within the application.');
      }
      final state = _requiredString(preview, 'state', previewContext, problems);
      if (state != null && !states.contains(state)) {
        problems.add('$previewContext.state "$state" is not declared by the surface.');
      }
      final layouts = _stringList(
        preview,
        'layouts',
        previewContext,
        problems,
        allowEmpty: false,
      ).toSet();
      if (state != null) previewCoverage.putIfAbsent(state, () => <String>{}).addAll(layouts);
      for (final layout in layouts.where((value) => !supportedLayouts.contains(value))) {
        problems.add('$previewContext.layouts contains unsupported layout "$layout".');
      }
      final previewPath = _requiredString(preview, 'sourcePath', previewContext, problems);
      if (projectRoot != null) {
        final previewFile = _projectFile(
          projectRoot,
          previewPath,
          '$previewContext.sourcePath',
          problems,
        );
        if (previewFile != null && previewFile.existsSync() && name != null) {
          final sourceText = previewFile.readAsStringSync();
          final annotation = RegExp("state:\\s*['\"]${RegExp.escape(name)}['\"]");
          if (!annotation.hasMatch(sourceText)) {
            problems.add('$previewContext.name "$name" has no AgentPagePreview in $previewPath.');
          }
        }
      }
    }
    for (final state in states) {
      final missingLayouts = supportedLayouts.difference(
        previewCoverage[state] ?? const <String>{},
      );
      if (missingLayouts.isNotEmpty) {
        problems.add(
          '$context state "$state" lacks previews for: ${missingLayouts.toList()..sort()}.',
        );
      }
    }

    final surfaceReview = _object(surface['review'], '$context.review', problems);
    if (surfaceReview != null) {
      final verdict = _verdict(surfaceReview, '$context.review', problems);
      final rules = _objectList(surfaceReview, 'rules', '$context.review', problems);
      final ruleIds = <String>{};
      for (final (ruleIndex, rule) in rules.indexed) {
        final ruleContext = '$context.review.rules[$ruleIndex]';
        final ruleId = _requiredString(rule, 'id', ruleContext, problems);
        if (ruleId != null && !ruleIds.add(ruleId)) problems.add('$ruleContext.id must be unique.');
        final ruleVerdict = _verdict(rule, ruleContext, problems);
        _requiredString(rule, 'evidence', ruleContext, problems);
        if (ruleVerdict == 'changes-required') {
          blockers.add('${id ?? context}: design rule ${ruleId ?? ruleIndex} requires changes.');
        }
      }
      final expectedRuleIds = activeCatalog.designRules.map((rule) => rule.id).toSet();
      final missingRules = expectedRuleIds.difference(ruleIds);
      final unknownRules = ruleIds.difference(expectedRuleIds);
      if (missingRules.isNotEmpty) {
        problems.add('$context.review.rules is missing: ${_sorted(missingRules)}.');
      }
      if (unknownRules.isNotEmpty) {
        problems.add('$context.review.rules contains unknown IDs: ${_sorted(unknownRules)}.');
      }
      final findings = _stringList(
        surfaceReview,
        'findings',
        '$context.review',
        problems,
        allowEmpty: true,
      );
      if (verdict == 'changes-required') {
        blockers.add('${id ?? context}: surface review requires changes.');
      }
      for (final finding in findings) {
        blockers.add('${id ?? context}: $finding');
      }
    }
  }

  if (entrySurfaceId != null && !surfaceIds.contains(entrySurfaceId)) {
    problems.add('application.entrySurfaceId references unknown surface "$entrySurfaceId".');
  }

  final stateInventories = _objectList(
    application,
    'stateInventories',
    'application',
    problems,
  );
  final inventoryIds = <String>{};
  final inventoryCoveredSurfaces = <String>{};
  for (final (index, inventory) in stateInventories.indexed) {
    final context = 'application.stateInventories[$index]';
    final inventoryId = _requiredString(inventory, 'id', context, problems);
    if (inventoryId != null && !inventoryIds.add(inventoryId)) {
      problems.add('$context.id must be unique.');
    }
    final sourcePath = _requiredString(inventory, 'sourcePath', context, problems);
    final enumName = _requiredString(inventory, 'enumName', context, problems);
    final declaredValues = <String>{};
    final mappings = _objectList(inventory, 'mappings', context, problems);
    for (final (mappingIndex, mapping) in mappings.indexed) {
      final mappingContext = '$context.mappings[$mappingIndex]';
      final value = _requiredString(mapping, 'value', mappingContext, problems);
      if (value != null && !declaredValues.add(value)) {
        problems.add('$mappingContext.value must be unique within the inventory.');
      }
      final surfaceId = _requiredString(mapping, 'surfaceId', mappingContext, problems);
      if (surfaceId != null && !surfaceIds.contains(surfaceId)) {
        problems.add('$mappingContext.surfaceId references unknown surface "$surfaceId".');
      } else if (surfaceId != null) {
        inventoryCoveredSurfaces.add(surfaceId);
      }
    }
    final ignored = _objectList(
      inventory,
      'ignored',
      context,
      problems,
      allowEmpty: true,
    );
    for (final (ignoredIndex, item) in ignored.indexed) {
      final ignoredContext = '$context.ignored[$ignoredIndex]';
      final value = _requiredString(item, 'value', ignoredContext, problems);
      if (value != null && !declaredValues.add(value)) {
        problems.add('$ignoredContext.value duplicates a mapped or ignored value.');
      }
      _requiredString(item, 'reason', ignoredContext, problems);
    }
    if (projectRoot != null) {
      final source = _projectFile(projectRoot, sourcePath, '$context.sourcePath', problems);
      if (source != null && source.existsSync() && enumName != null) {
        final actualValues = _dartEnumValues(source.readAsStringSync(), enumName);
        if (actualValues == null) {
          problems.add('$context.enumName "$enumName" is not declared in $sourcePath.');
        } else {
          final missingValues = actualValues.difference(declaredValues);
          final unknownValues = declaredValues.difference(actualValues);
          if (missingValues.isNotEmpty) {
            problems.add('$context does not inventory enum values: ${_sorted(missingValues)}.');
          }
          if (unknownValues.isNotEmpty) {
            problems.add('$context inventories unknown enum values: ${_sorted(unknownValues)}.');
          }
        }
      }
    }
  }
  final surfacesMissingState = surfaceIds.difference(inventoryCoveredSurfaces);
  if (surfacesMissingState.isNotEmpty) {
    problems.add(
      'State inventories do not map surfaces: ${_sorted(surfacesMissingState)}.',
    );
  }

  final transitions = _objectList(
    application,
    'transitions',
    'application',
    problems,
    allowEmpty: surfaceIds.length <= 1,
  );
  final adjacency = <String, Set<String>>{};
  final transitionIds = <String>{};
  final transitionScenarioRefs =
      <({String context, String from, List<String> scenarioIds, String to})>[];
  for (final (index, transition) in transitions.indexed) {
    final context = 'application.transitions[$index]';
    final id = _requiredString(transition, 'id', context, problems);
    if (id != null && !transitionIds.add(id)) {
      problems.add('$context.id must be unique.');
    }
    final from = _requiredString(transition, 'from', context, problems);
    final to = _requiredString(transition, 'to', context, problems);
    _requiredString(transition, 'trigger', context, problems);
    final stackEffect = _requiredString(
      transition,
      'stackEffect',
      context,
      problems,
    );
    if (stackEffect != null && !charcoalAppTransitionStackEffects.contains(stackEffect)) {
      problems.add(
        '$context.stackEffect must be one of: '
        '${_sorted(charcoalAppTransitionStackEffects)}.',
      );
    }
    _requiredString(transition, 'statePreservation', context, problems);
    _requiredString(transition, 'backBehavior', context, problems);
    final scenarioIds = _stringList(
      transition,
      'runtimeScenarioIds',
      context,
      problems,
      allowEmpty: false,
    );
    if (from != null && !surfaceIds.contains(from)) problems.add('$context.from is unknown.');
    if (to != null && !surfaceIds.contains(to)) problems.add('$context.to is unknown.');
    if (from != null && to != null) {
      adjacency.putIfAbsent(from, () => <String>{}).add(to);
      transitionScenarioRefs.add((
        context: context,
        from: from,
        scenarioIds: scenarioIds,
        to: to,
      ));
      if (surfaceKinds[from] == 'destination' &&
          surfaceKinds[to] == 'destination' &&
          stackEffect != 'none') {
        problems.add(
          '$context.stackEffect must be "none" between top-level destinations.',
        );
      }
    }
  }
  if (entrySurfaceId != null && surfaceIds.contains(entrySurfaceId)) {
    final reachable = <String>{entrySurfaceId};
    final pending = <String>[entrySurfaceId];
    while (pending.isNotEmpty) {
      final current = pending.removeLast();
      for (final next in adjacency[current] ?? const <String>{}) {
        if (reachable.add(next)) pending.add(next);
      }
    }
    final unreachable = surfaceIds.difference(reachable);
    if (unreachable.isNotEmpty) {
      problems.add('Surfaces are unreachable from "$entrySurfaceId": ${_sorted(unreachable)}.');
    }
  }

  final runtimeScenarios = _objectList(
    application,
    'runtimeScenarios',
    'application',
    problems,
  );
  final runtimeCovered = <String>{};
  final runtimeScenarioIds = <String>{};
  final runtimeScenarioSurfaces = <String, Set<String>>{};
  for (final (index, scenario) in runtimeScenarios.indexed) {
    final context = 'application.runtimeScenarios[$index]';
    final scenarioId = _requiredString(scenario, 'id', context, problems);
    if (scenarioId != null && !runtimeScenarioIds.add(scenarioId)) {
      problems.add('$context.id must be unique.');
    }
    final testName = _requiredString(scenario, 'testName', context, problems);
    final sourcePath = _requiredString(scenario, 'sourcePath', context, problems);
    final scenarioSurfaceIds = _stringList(
      scenario,
      'surfaceIds',
      context,
      problems,
      allowEmpty: false,
    );
    if (scenarioId != null) {
      runtimeScenarioSurfaces[scenarioId] = scenarioSurfaceIds.toSet();
    }
    final verdict = _verdict(scenario, context, problems);
    _requiredString(scenario, 'evidence', context, problems);
    if (verdict == 'changes-required') {
      blockers.add(
        '${appId ?? 'application'}: runtime scenario ${scenario['id']} requires changes.',
      );
    }
    File? testFile;
    if (projectRoot != null) {
      testFile = _projectFile(projectRoot, sourcePath, '$context.sourcePath', problems);
    }
    final testText = testFile != null && testFile.existsSync() ? testFile.readAsStringSync() : null;
    if (testText != null && testName != null && !testText.contains(testName)) {
      problems.add('$context.testName "$testName" is absent from $sourcePath.');
    }
    for (final surfaceId in scenarioSurfaceIds) {
      if (!surfaceIds.contains(surfaceId)) {
        problems.add('$context.surfaceIds references unknown surface "$surfaceId".');
        continue;
      }
      runtimeCovered.add(surfaceId);
      final runtimeKey = surfaceRuntimeKeys[surfaceId];
      if (testText != null && runtimeKey != null && !testText.contains(runtimeKey)) {
        problems.add('$context does not exercise runtimeKey "$runtimeKey" for $surfaceId.');
      }
    }
  }
  final missingRuntime = surfaceIds.difference(runtimeCovered);
  if (missingRuntime.isNotEmpty) {
    problems.add('Runtime scenarios do not cover: ${_sorted(missingRuntime)}.');
  }
  for (final transition in transitionScenarioRefs) {
    for (final scenarioId in transition.scenarioIds) {
      final coveredSurfaces = runtimeScenarioSurfaces[scenarioId];
      if (coveredSurfaces == null) {
        problems.add(
          '${transition.context}.runtimeScenarioIds references unknown scenario '
          '"$scenarioId".',
        );
        continue;
      }
      final missing = <String>{
        transition.from,
        transition.to,
      }.difference(coveredSurfaces);
      if (missing.isNotEmpty) {
        problems.add(
          '${transition.context}.runtimeScenarioIds scenario "$scenarioId" '
          'does not cover transition surfaces: ${_sorted(missing)}.',
        );
      }
    }
  }

  final finalReview = _object(application['finalReview'], 'application.finalReview', problems);
  if (finalReview != null) {
    final verdict = _verdict(finalReview, 'application.finalReview', problems);
    final reviewedIds = _stringList(
      finalReview,
      'reviewedSurfaceIds',
      'application.finalReview',
      problems,
      allowEmpty: false,
    ).toSet();
    final missing = surfaceIds.difference(reviewedIds);
    final unknown = reviewedIds.difference(surfaceIds);
    if (missing.isNotEmpty) problems.add('application.finalReview omits: ${_sorted(missing)}.');
    if (unknown.isNotEmpty) {
      problems.add('application.finalReview contains unknown surfaces: ${_sorted(unknown)}.');
    }
    final checks = _objectList(finalReview, 'checks', 'application.finalReview', problems);
    final areas = <String>{};
    for (final (index, check) in checks.indexed) {
      final context = 'application.finalReview.checks[$index]';
      final area = _requiredString(check, 'area', context, problems);
      if (area != null && !areas.add(area)) problems.add('$context.area must be unique.');
      final checkVerdict = _verdict(check, context, problems);
      _requiredString(check, 'evidence', context, problems);
      if (checkVerdict == 'changes-required') {
        blockers.add('${appId ?? 'application'}: final $area check requires changes.');
      }
    }
    final missingAreas = charcoalAppReviewAreas.difference(areas);
    final unknownAreas = areas.difference(charcoalAppReviewAreas);
    if (missingAreas.isNotEmpty) {
      problems.add('application.finalReview.checks is missing: ${_sorted(missingAreas)}.');
    }
    if (unknownAreas.isNotEmpty) {
      problems.add(
        'application.finalReview.checks contains unknown areas: ${_sorted(unknownAreas)}.',
      );
    }
    final openFindings = _stringList(
      finalReview,
      'openFindings',
      'application.finalReview',
      problems,
      allowEmpty: true,
    );
    if (verdict == 'changes-required') {
      blockers.add('${appId ?? 'application'}: final review requires changes.');
    }
    for (final finding in openFindings) {
      blockers.add('${appId ?? 'application'}: $finding');
    }
  }

  _findPlaceholders(application, 'application', problems);
  return CharcoalAppExperienceReviewValidation(
    appId: appId,
    problems: problems,
    blockers: blockers.toSet().toList(growable: false),
  );
}

String? _verdict(Map<String, Object?> value, String context, List<String> problems) {
  final verdict = _requiredString(value, 'verdict', context, problems);
  if (verdict != null && verdict != 'pass' && verdict != 'changes-required') {
    problems.add('$context.verdict must be pass or changes-required.');
  }
  return verdict;
}

File? _projectFile(
  Directory root,
  String? requestedPath,
  String context,
  List<String> problems,
) {
  if (requestedPath == null) return null;
  final rootPath = p.normalize(root.absolute.path);
  final path = p.normalize(
    p.isAbsolute(requestedPath) ? requestedPath : p.join(rootPath, requestedPath),
  );
  if (!p.isWithin(rootPath, path)) {
    problems.add('$context must stay inside the project.');
    return null;
  }
  final file = File(path);
  if (!file.existsSync()) problems.add('$context does not exist: $requestedPath.');
  return file;
}

Map<String, Object?>? _readObject(File file, String context, List<String> problems) {
  try {
    final value = jsonDecode(file.readAsStringSync());
    if (value is Map<String, Object?>) return value;
    problems.add('$context must contain a JSON object.');
  } on FormatException catch (error) {
    problems.add('$context contains invalid JSON: ${error.message}.');
  }
  return null;
}

Set<String> _intentIds(Map<String, Object?> spec) {
  final page = spec['page'];
  if (page is! Map<String, Object?>) return const <String>{};
  final intents = page['intents'];
  if (intents is! List<Object?>) return const <String>{};
  return <String>{
    for (final intent in intents)
      if (intent is Map<String, Object?> && intent['id'] is String) intent['id']! as String,
  };
}

Set<String> _pageLayouts(Map<String, Object?> spec) {
  final page = spec['page'];
  if (page is! Map<String, Object?>) return const <String>{};
  final platforms = page['platforms'];
  if (platforms is! List<Object?>) return const <String>{};
  return platforms.whereType<String>().toSet();
}

Set<String>? _dartEnumValues(String source, String enumName) {
  final match = RegExp(
    'enum\\s+${RegExp.escape(enumName)}\\s*\\{([^}]*)\\}',
    dotAll: true,
  ).firstMatch(source);
  if (match == null) return null;
  final values = <String>{};
  for (final rawValue in match.group(1)!.split(',')) {
    final value = RegExp(r'[A-Za-z_]\w*').firstMatch(rawValue)?.group(0);
    if (value != null) values.add(value);
  }
  return values;
}

Map<String, Object?>? _object(Object? value, String context, List<String> problems) {
  if (value is Map<String, Object?>) return value;
  problems.add('$context must be an object.');
  return null;
}

List<Map<String, Object?>> _objectList(
  Map<String, Object?> parent,
  String key,
  String context,
  List<String> problems, {
  bool allowEmpty = false,
}) {
  final value = parent[key];
  if (value is! List<Object?> ||
      (!allowEmpty && value.isEmpty) ||
      value.any((item) => item is! Map<String, Object?>)) {
    problems.add('$context.$key must be ${allowEmpty ? 'an' : 'a non-empty'} object array.');
    return const <Map<String, Object?>>[];
  }
  return value.cast<Map<String, Object?>>();
}

String? _requiredString(
  Map<String, Object?> parent,
  String key,
  String context,
  List<String> problems,
) {
  final value = parent[key];
  if (value is String && value.trim().isNotEmpty) return value.trim();
  problems.add('$context.$key must be a non-empty string.');
  return null;
}

List<String> _stringList(
  Map<String, Object?> parent,
  String key,
  String context,
  List<String> problems, {
  required bool allowEmpty,
}) {
  final value = parent[key];
  if (value is! List<Object?> ||
      (!allowEmpty && value.isEmpty) ||
      value.any((item) => item is! String || item.trim().isEmpty)) {
    problems.add('$context.$key must be ${allowEmpty ? 'a' : 'a non-empty'} string array.');
    return const <String>[];
  }
  final values = value.cast<String>();
  if (values.toSet().length != values.length) {
    problems.add('$context.$key must not contain duplicates.');
  }
  return values;
}

String _sorted(Iterable<String> values) {
  final sorted = values.toList()..sort();
  return sorted.join(', ');
}

void _findPlaceholders(Object? value, String context, List<String> problems) {
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized.contains('replace with') ||
        normalized.contains('replace-with') ||
        normalized.startsWith('describe ')) {
      problems.add('$context still contains template placeholder "$value".');
    }
    return;
  }
  if (value is List<Object?>) {
    for (final (index, item) in value.indexed) {
      _findPlaceholders(item, '$context[$index]', problems);
    }
    return;
  }
  if (value is Map<String, Object?>) {
    for (final entry in value.entries) {
      _findPlaceholders(entry.value, '$context.${entry.key}', problems);
    }
  }
}
