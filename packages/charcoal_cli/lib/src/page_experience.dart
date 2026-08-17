import 'package:charcoal_catalog/charcoal_catalog.dart';

const int charcoalPageExperienceSpecVersion = 1;

final class CharcoalPageSpecValidation {
  const CharcoalPageSpecValidation({required this.pageId, required this.problems});

  final String? pageId;
  final List<String> problems;

  bool get valid => problems.isEmpty;

  Map<String, Object?> toJson() => <String, Object?>{
    'valid': valid,
    'pageId': pageId,
    'problems': problems,
  };
}

Map<String, Object?> buildCharcoalPageExperienceTemplate({
  String pageId = 'replace-with-stable-page-id',
  String title = 'Replace with page title',
  CharcoalCatalog? catalog,
}) {
  final activeCatalog = catalog ?? charcoalCatalog;
  return <String, Object?>{
    'schemaVersion': charcoalPageExperienceSpecVersion,
    'catalogSchemaVersion': activeCatalog.schemaVersion,
    'libraryVersion': activeCatalog.libraryVersion,
    'page': <String, Object?>{
      'id': pageId,
      'title': title,
      'userContext': 'Describe who is here, what brought them here, and relevant constraints.',
      'platforms': <String>['compact', 'standard'],
      'assumptions': <String>['Replace with an evidence-backed assumption or remove it.'],
      'intents': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'primary-outcome',
          'priority': 'primary',
          'goal': 'Describe the user outcome without naming a control.',
          'successSignal': 'Describe the visible or persistent evidence of success.',
        },
      ],
      'information': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'primary-context',
          'intentIds': <String>['primary-outcome'],
          'content': 'Describe the information needed for the primary decision.',
          'placement': 'Describe where it appears relative to the action.',
          'visibility': 'Describe the states in which it is visible.',
        },
      ],
      'reuse': <Map<String, Object?>>[
        <String, Object?>{
          'need': 'Describe the UI or behavior being composed.',
          'resolution': 'local-composition',
          'references': <String>['CharcoalTypography'],
          'rationale': 'Record Catalog searches and explain why this reuse level is correct.',
        },
      ],
      'interactions': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'complete-primary-outcome',
          'intentId': 'primary-outcome',
          'trigger': 'Describe the user action and precondition.',
          'states': <String>['ready', 'complete'],
          'transitions': <Map<String, Object?>>[
            <String, Object?>{
              'from': 'ready',
              'event': 'User completes the primary action',
              'to': 'complete',
            },
          ],
        },
      ],
      'feedback': <Map<String, Object?>>[
        <String, Object?>{
          'interactionId': 'complete-primary-outcome',
          'state': 'complete',
          'immediate': 'Describe immediate acknowledgement.',
          'persistent': 'Describe where the result remains visible.',
          'recovery': 'State N/A with a reason or describe recovery.',
          'announcement': 'Describe semantic announcement or state N/A with a reason.',
        },
      ],
      'bestPractices': <Map<String, Object?>>[
        <String, Object?>{
          'area': 'hierarchy and navigation',
          'decision': 'Describe the page-specific design decision.',
          'evidence': 'Describe repository or runtime evidence.',
        },
      ],
      'verification': <Map<String, Object?>>[
        <String, Object?>{
          'scenario': 'Primary outcome',
          'viewport': 'compact 390x844',
          'steps': <String>['Describe the first interaction step.'],
          'expected': <String>['Describe the observable result.'],
        },
      ],
    },
  };
}

CharcoalPageSpecValidation validateCharcoalPageExperienceSpec(
  Map<String, Object?> spec, {
  CharcoalCatalog? catalog,
}) {
  final activeCatalog = catalog ?? charcoalCatalog;
  final problems = <String>[];
  if (spec['schemaVersion'] != charcoalPageExperienceSpecVersion) {
    problems.add('schemaVersion must equal $charcoalPageExperienceSpecVersion.');
  }
  if (spec['catalogSchemaVersion'] != activeCatalog.schemaVersion) {
    problems.add('catalogSchemaVersion must equal ${activeCatalog.schemaVersion}.');
  }
  if (spec['libraryVersion'] != activeCatalog.libraryVersion) {
    problems.add('libraryVersion must equal ${activeCatalog.libraryVersion}.');
  }
  final page = _object(spec['page'], 'page', problems);
  if (page == null) return CharcoalPageSpecValidation(pageId: null, problems: problems);
  final pageId = _requiredString(page, 'id', 'page', problems);
  for (final key in <String>['title', 'userContext']) {
    _requiredString(page, key, 'page', problems);
  }
  _stringList(page, 'platforms', 'page', problems, allowEmpty: false);
  _stringList(page, 'assumptions', 'page', problems, allowEmpty: true);

  final intents = _objectList(page, 'intents', 'page', problems);
  final intentIds = <String>{};
  final primaryIds = <String>{};
  for (final (index, intent) in intents.indexed) {
    final context = 'page.intents[$index]';
    final id = _requiredString(intent, 'id', context, problems);
    if (id != null && !intentIds.add(id)) problems.add('$context.id must be unique.');
    final priority = _requiredString(intent, 'priority', context, problems);
    if (priority != null &&
        !const <String>{'primary', 'secondary', 'support', 'recovery'}.contains(priority)) {
      problems.add('$context.priority is not supported.');
    }
    if (id != null && priority == 'primary') primaryIds.add(id);
    _requiredString(intent, 'goal', context, problems);
    _requiredString(intent, 'successSignal', context, problems);
  }
  if (primaryIds.isEmpty) problems.add('page.intents must contain at least one primary intent.');

  final information = _objectList(page, 'information', 'page', problems);
  final informedIntents = <String>{};
  final informationIds = <String>{};
  for (final (index, item) in information.indexed) {
    final context = 'page.information[$index]';
    final id = _requiredString(item, 'id', context, problems);
    if (id != null && !informationIds.add(id)) problems.add('$context.id must be unique.');
    final references = _stringList(item, 'intentIds', context, problems, allowEmpty: false);
    for (final intentId in references) {
      if (!intentIds.contains(intentId)) {
        problems.add('$context.intentIds references unknown intent "$intentId".');
      } else {
        informedIntents.add(intentId);
      }
    }
    for (final key in <String>['content', 'placement', 'visibility']) {
      _requiredString(item, key, context, problems);
    }
  }
  for (final primaryId in primaryIds.difference(informedIntents)) {
    problems.add('Primary intent "$primaryId" has no information or action placement.');
  }

  final reuse = _objectList(page, 'reuse', 'page', problems);
  for (final (index, item) in reuse.indexed) {
    final context = 'page.reuse[$index]';
    _requiredString(item, 'need', context, problems);
    final resolution = _requiredString(item, 'resolution', context, problems);
    if (resolution != null &&
        !const <String>{
          'component',
          'pattern',
          'shared-composition',
          'local-composition',
          'new-component',
        }.contains(resolution)) {
      problems.add('$context.resolution is not supported.');
    }
    final references = _stringList(item, 'references', context, problems, allowEmpty: false);
    if (resolution == 'component') {
      for (final reference in references) {
        if (activeCatalog.componentNamed(reference) == null) {
          problems.add('$context references unknown component "$reference".');
        }
      }
    } else if (resolution == 'pattern') {
      for (final reference in references) {
        if (activeCatalog.patternNamed(reference) == null) {
          problems.add('$context references unknown pattern "$reference".');
        }
      }
    } else {
      for (final reference in references.where((value) => value.startsWith('Charcoal'))) {
        if (activeCatalog.componentNamed(reference) == null) {
          problems.add('$context references unknown Charcoal component "$reference".');
        }
      }
    }
    _requiredString(item, 'rationale', context, problems);
  }

  final interactions = _objectList(page, 'interactions', 'page', problems);
  final interactionIds = <String>{};
  for (final (index, item) in interactions.indexed) {
    final context = 'page.interactions[$index]';
    final id = _requiredString(item, 'id', context, problems);
    if (id != null && !interactionIds.add(id)) problems.add('$context.id must be unique.');
    final intentId = _requiredString(item, 'intentId', context, problems);
    if (intentId != null && !intentIds.contains(intentId)) {
      problems.add('$context.intentId references unknown intent "$intentId".');
    }
    _requiredString(item, 'trigger', context, problems);
    final states = _stringList(item, 'states', context, problems, allowEmpty: false).toSet();
    final transitions = _objectList(item, 'transitions', context, problems);
    for (final (transitionIndex, transition) in transitions.indexed) {
      final transitionContext = '$context.transitions[$transitionIndex]';
      final from = _requiredString(transition, 'from', transitionContext, problems);
      final to = _requiredString(transition, 'to', transitionContext, problems);
      _requiredString(transition, 'event', transitionContext, problems);
      if (from != null && !states.contains(from)) {
        problems.add('$transitionContext.from is not declared in states.');
      }
      if (to != null && !states.contains(to)) {
        problems.add('$transitionContext.to is not declared in states.');
      }
    }
  }

  final feedback = _objectList(page, 'feedback', 'page', problems);
  final feedbackInteractions = <String>{};
  for (final (index, item) in feedback.indexed) {
    final context = 'page.feedback[$index]';
    final interactionId = _requiredString(item, 'interactionId', context, problems);
    if (interactionId != null && !interactionIds.contains(interactionId)) {
      problems.add('$context.interactionId references unknown interaction "$interactionId".');
    } else if (interactionId != null) {
      feedbackInteractions.add(interactionId);
    }
    for (final key in <String>['state', 'immediate', 'persistent', 'recovery', 'announcement']) {
      _requiredString(item, key, context, problems);
    }
  }
  for (final interactionId in interactionIds.difference(feedbackInteractions)) {
    problems.add('Interaction "$interactionId" has no feedback entry.');
  }

  final practices = _objectList(page, 'bestPractices', 'page', problems);
  for (final (index, item) in practices.indexed) {
    final context = 'page.bestPractices[$index]';
    for (final key in <String>['area', 'decision', 'evidence']) {
      _requiredString(item, key, context, problems);
    }
  }
  final verification = _objectList(page, 'verification', 'page', problems);
  for (final (index, item) in verification.indexed) {
    final context = 'page.verification[$index]';
    _requiredString(item, 'scenario', context, problems);
    _requiredString(item, 'viewport', context, problems);
    _stringList(item, 'steps', context, problems, allowEmpty: false);
    _stringList(item, 'expected', context, problems, allowEmpty: false);
  }

  _findPlaceholders(page, 'page', problems);
  return CharcoalPageSpecValidation(pageId: pageId, problems: problems);
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
  List<String> problems,
) {
  final value = parent[key];
  if (value is! List<Object?> ||
      value.isEmpty ||
      value.any((item) => item is! Map<String, Object?>)) {
    problems.add('$context.$key must be a non-empty object array.');
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
