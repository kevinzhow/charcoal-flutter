import 'package:charcoal_catalog/src/model.dart';

const List<CharcoalDesignRuleDoc> pageDesignRules = <CharcoalDesignRuleDoc>[
  CharcoalDesignRuleDoc(
    id: 'user-intent',
    order: 1,
    question: 'What intentions does the user have on the current page?',
    requiredOutput: 'An intent inventory with user context, goal, and success signal.',
    validation: 'Every visible section supports a stated intent or necessary system constraint.',
  ),
  CharcoalDesignRuleDoc(
    id: 'intent-priority',
    order: 2,
    question: 'How should those intentions be prioritized?',
    requiredOutput: 'Primary, secondary, support, and recovery priorities.',
    validation: 'The primary outcome is identifiable without reading every control.',
  ),
  CharcoalDesignRuleDoc(
    id: 'information-placement',
    order: 3,
    question: 'Does the page provide and place the information needed for each intention?',
    requiredOutput: 'A map from information and actions to intent, placement, and visibility.',
    validation: 'Decision and recovery information appears where it is needed.',
  ),
  CharcoalDesignRuleDoc(
    id: 'necessary-reuse',
    order: 4,
    question: 'Are components and compositions reused at the correct level?',
    requiredOutput: 'A reviewed reuse decision backed by component and pattern searches.',
    validation: 'No cataloged component or pattern is silently duplicated.',
  ),
  CharcoalDesignRuleDoc(
    id: 'interaction-states',
    order: 5,
    question: 'Which interactions and state transitions can occur?',
    requiredOutput: 'Triggers, preconditions, states, transitions, and escape or retry paths.',
    validation: 'No supported action leaves the interface unexplained or unrecoverable.',
  ),
  CharcoalDesignRuleDoc(
    id: 'interaction-feedback',
    order: 6,
    question: 'Does every interaction receive proportionate feedback?',
    requiredOutput: 'Immediate, persistent, failure, recovery, and announcement feedback.',
    validation: 'Every interaction has feedback for each applicable terminal or error state.',
  ),
  CharcoalDesignRuleDoc(
    id: 'experience-expectations',
    order: 7,
    question: 'Does the design follow page and platform best practices and user expectations?',
    requiredOutput: 'Page-specific decisions with responsive, accessibility, and runtime evidence.',
    validation: 'Primary, boundary, and supported layout scenarios are exercised at runtime.',
  ),
];

const List<CharcoalDesignStageDoc> pageDesignProcess = <CharcoalDesignStageDoc>[
  CharcoalDesignStageDoc(
    id: 'surface-inventory',
    order: 1,
    title: 'Surface inventory',
    goal: 'Define the complete application surface and the experience contract before implementation.',
    requiredEvidence: <String>[
      'Every destination, detail, task, modal, sheet, overlay, and durable result is listed.',
      'Every surface names its user intents, meaningful states, source owner, and Page Experience Spec.',
      'Transitions make every listed surface reachable from the application entry surface.',
    ],
    exitCriteria: <String>[
      'No visible or interactive surface is outside the inventory.',
      'The inventory distinguishes unsupported product ideas from implemented interactions.',
    ],
  ),
  CharcoalDesignStageDoc(
    id: 'component-preview',
    order: 2,
    title: 'Reusable component preview',
    goal: 'Verify public and application-shared building blocks before page composition.',
    requiredEvidence: <String>[
      'Relevant component states are interactive in focused Widget Previews.',
      'Color-owning components are reviewed in light and dark brightness.',
    ],
    exitCriteria: <String>[
      'Reusable behavior, geometry, semantics, and state ownership are coherent in isolation.',
    ],
  ),
  CharcoalDesignStageDoc(
    id: 'page-state-preview',
    order: 3,
    title: 'Deterministic page-state preview',
    goal: 'Make the real page hierarchy and every meaningful state reviewable without launching the full app.',
    requiredEvidence: <String>[
      'The production page and real state owner are used with deterministic scenario factories.',
      'Each inventoried state is previewed at every supported layout class.',
    ],
    exitCriteria: <String>[
      'Initial, boundary or recovery, and durable-result states are covered where applicable.',
      'No preview-only duplicate page implementation exists.',
    ],
  ),
  CharcoalDesignStageDoc(
    id: 'integrated-runtime',
    order: 4,
    title: 'Integrated runtime verification',
    goal: 'Verify behavior that an isolated Widget Preview cannot prove.',
    requiredEvidence: <String>[
      'Primary and recovery journeys exercise navigation, back behavior, overlays, and persistent state.',
      'Relevant input, accessibility, text scaling, and platform integration are exercised.',
    ],
    exitCriteria: <String>[
      'The smallest sufficient full-app run confirms every cross-surface boundary in scope.',
    ],
  ),
  CharcoalDesignStageDoc(
    id: 'app-wide-review',
    order: 5,
    title: 'App-wide final review',
    goal: 'Review every surface and the application as a coherent experience before claiming Agent Ready.',
    requiredEvidence: <String>[
      'Every surface has a pass or changes-required verdict for all seven design rules.',
      'Navigation, hierarchy, product copy, responsive behavior, and accessibility are reviewed across surfaces.',
      'The final review explicitly covers every inventoried surface and records open findings.',
    ],
    exitCriteria: <String>[
      'Every surface and cross-surface check passes.',
      'No open finding remains and the machine-readable App Experience Review validates as ready.',
    ],
  ),
];

const List<CharcoalPatternDoc> componentPatterns = <CharcoalPatternDoc>[
  CharcoalPatternDoc(
    id: 'adaptive-app-shell',
    category: 'Navigation',
    summary: 'Keeps page identity, top-level destinations, and contextual actions stable across an app flow.',
    keywords: <String>['app shell', 'bottom navigation', 'page header', 'responsive navigation'],
    useWhen: <String>[
      'An application has stable top-level destinations and page-specific content.',
      'Compact and large layouts must preserve the same destination state.',
    ],
    avoidWhen: <String>[
      'A gallery or section only needs a heading rather than application navigation.',
    ],
    components: <String>[
      'CharcoalNavigationBar',
      'CharcoalTabBar',
      'CharcoalNavigationItem',
      'CharcoalIconButton',
    ],
    composition: <String>[
      'Keep destination selection in one state owner above the page body.',
      'Commit the controlled destination, selected visuals and semantics, and page content atomically in the first painted frame; do not mirror selection locally or repair it from route state after paint.',
      'Treat top-level destination selection as a no-stack-effect state update; do not push a route, replace the root page, or change its stable page key.',
      'Push details and transient tasks, replace a completed task with its durable result when prior steps must not return, and pop or dismiss through platform back behavior.',
      'Preserve destination-owned scroll positions, drafts, and selections when moving between top-level destinations.',
      'Place contextual actions in the current page; do not change top-level destination selection.',
      'Use CharcoalTabBar on compact layouts and CharcoalNavigationItem in large-layout sidebars without resetting destination state.',
    ],
    interactionStates: <String>[
      'destination selected with no stack effect',
      'detail pushed',
      'transient task pushed',
      'durable result replaces task',
      'back pops or dismisses',
    ],
    feedback: <String>[
      'Persistent selection switches atomically; hover, focus, and press may animate without tweening through stale selected state.',
      'Back or close returns to the prior destination without clearing unrelated state.',
    ],
    accessibility: <String>[
      'Expose one selected destination and explicit labels for icon-only actions.',
      'Preserve focus order and selected semantics when navigation placement changes.',
    ],
    responsiveBehavior: <String>[
      'Switch navigation placement from constraints, not device or orientation checks.',
    ],
  ),
  CharcoalPatternDoc(
    id: 'searchable-collection',
    category: 'Discovery',
    summary: 'Combines search, optional filtering, result context, and recoverable empty results.',
    keywords: <String>['catalog', 'filter', 'product discovery', 'search results'],
    useWhen: <String>[
      'Users browse a collection and may narrow it by query or a small set of filters.',
    ],
    avoidWhen: <String>[
      'The collection is short and fully visible without search or filtering.',
    ],
    components: <String>[
      'CharcoalTextField',
      'CharcoalSegmentedControl',
      'CharcoalClickable',
      'CharcoalIconButton',
    ],
    composition: <String>[
      'Keep query and filter state in the collection owner.',
      'Place result count or category context immediately before the results.',
      'Preserve the query in an empty state and offer a nearby clear or alternate-filter recovery.',
    ],
    interactionStates: <String>['browsing', 'filtering', 'results', 'empty results', 'detail'],
    feedback: <String>[
      'Update result context with the query or selected filter.',
      'Empty results explain what was retained and how to recover.',
    ],
    accessibility: <String>[
      'Name the search field and filter group; expose saved state on result actions.',
    ],
    responsiveBehavior: <String>[
      'Adjust result columns from available width while keeping readable card widths.',
    ],
  ),
  CharcoalPatternDoc(
    id: 'contextual-composer',
    category: 'Communication',
    summary: 'Keeps reply or message context visible while sharing input, validation, send, and retry behavior.',
    keywords: <String>['comment', 'composer', 'message', 'reply', 'send'],
    useWhen: <String>[
      'A user writes a message or reply whose destination and surrounding context matter.',
    ],
    avoidWhen: <String>[
      'The task is a long standalone document or a generic single-value form field.',
    ],
    components: <String>['CharcoalTextArea', 'CharcoalIconButton', 'CharcoalButton'],
    composition: <String>[
      'Share the input and action skeleton while injecting conversation-specific context and send behavior.',
      'Retain authored text when sending fails and keep retry next to the error.',
    ],
    interactionStates: <String>['empty', 'editing', 'disabled', 'sending', 'sent', 'failed'],
    feedback: <String>[
      'Disable send for invalid input, acknowledge progress, and retain text on failure.',
    ],
    accessibility: <String>[
      'Label the destination, input, and send action; announce non-focus-moving send results.',
    ],
    responsiveBehavior: <String>[
      'Keep primary context visible and move the action without shrinking the input below readability.',
    ],
  ),
  CharcoalPatternDoc(
    id: 'financial-action-flow',
    category: 'Transactions',
    summary: 'Separates selecting a financial action, entering trusted details, reviewing, and confirming the result.',
    keywords: <String>['money transfer', 'payment', 'send money', 'top up', 'transaction'],
    useWhen: <String>[
      'An action changes a balance or creates a durable financial transaction.',
    ],
    avoidWhen: <String>[
      'The action is reversible, low-risk, and contains no amount or recipient decision.',
    ],
    components: <String>[
      'CharcoalTextField',
      'CharcoalButton',
      'CharcoalSegmentedControl',
      'CharcoalDialog',
    ],
    composition: <String>[
      'Collect recipient and amount before presenting a clear review step.',
      'Keep balance impact and destination visible at confirmation.',
      'Record the successful result in persistent activity, not only transient feedback.',
    ],
    interactionStates: <String>[
      'ready',
      'editing',
      'invalid',
      'review',
      'submitting',
      'success',
      'failed',
    ],
    feedback: <String>[
      'Explain invalid input inline and show a durable receipt after success.',
      'Retain entered values and offer retry when submission fails.',
    ],
    accessibility: <String>[
      'Keep field labels visible and announce the confirmed amount and recipient.',
    ],
    responsiveBehavior: <String>[
      'Use a focused compact flow and a constrained review surface on large widths.',
    ],
  ),
  CharcoalPatternDoc(
    id: 'daily-checklist',
    category: 'Progress',
    summary: 'Presents a breathable set of daily commitments with progress, completion, undo, and next-step feedback.',
    keywords: <String>['checklist', 'daily habits', 'progress', 'tasks', 'todo'],
    useWhen: <String>[
      'Users complete a small, meaningful set of items during the current day or session.',
    ],
    avoidWhen: <String>[
      'Items are a dense backlog requiring sorting, bulk selection, or complex metadata.',
    ],
    components: <String>['CharcoalCheckbox', 'CharcoalButton', 'CharcoalTypography'],
    composition: <String>[
      'Give each item enough vertical separation to scan label, supporting context, and completion state.',
      'Keep progress near the list and reveal the next action only when it becomes relevant.',
      'Allow a completed item to be unchecked without losing other progress.',
    ],
    interactionStates: <String>['incomplete', 'partially complete', 'complete', 'reopened'],
    feedback: <String>[
      'Update progress immediately and provide completion feedback without blocking continued review.',
    ],
    accessibility: <String>[
      'Expose each item label and checked state; do not rely on decoration alone.',
    ],
    responsiveBehavior: <String>[
      'Constrain the checklist for reading on large widths and preserve touch targets on compact widths.',
    ],
  ),
  CharcoalPatternDoc(
    id: 'empty-state-recovery',
    category: 'Feedback',
    summary:
        'Explains why content is absent and provides the most useful recovery or creation action.',
    keywords: <String>['empty', 'no results', 'no saved items', 'recovery', 'zero state'],
    useWhen: <String>[
      'A collection or result can legitimately contain no content.',
    ],
    avoidWhen: <String>[
      'Content is merely loading or failed to load; preserve those distinct states.',
    ],
    components: <String>['CharcoalTypography', 'CharcoalButton'],
    composition: <String>[
      'State what is empty, why when known, and one relevant next action.',
      'Keep query or filter context visible when it explains the empty result.',
    ],
    interactionStates: <String>['empty', 'recovering', 'content'],
    feedback: <String>[
      'Recovery updates the same content region so cause and result remain connected.',
    ],
    accessibility: <String>[
      'Use a meaningful heading and make the recovery action reachable in reading order.',
    ],
    responsiveBehavior: <String>[
      'Keep copy readable and action width appropriate to the available constraint.',
    ],
  ),
];
