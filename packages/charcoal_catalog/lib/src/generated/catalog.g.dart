// GENERATED CODE - DO NOT MODIFY BY HAND.

const String generatedCatalogJson = r'''{
  "schemaVersion": 4,
  "libraryName": "charcoal_ui",
  "libraryVersion": "0.1.0",
  "coverage": {
    "publicComponents": 34,
    "curatedComponents": 34,
    "componentsWithExamples": 34,
    "curatedPatterns": 6,
    "publicTokens": 502,
    "semanticTokens": 226
  },
  "designRules": [
    {
      "id": "user-intent",
      "order": 1,
      "question": "What intentions does the user have on the current page?",
      "requiredOutput": "An intent inventory with user context, goal, and success signal.",
      "validation": "Every visible section supports a stated intent or necessary system constraint."
    },
    {
      "id": "intent-priority",
      "order": 2,
      "question": "How should those intentions be prioritized?",
      "requiredOutput": "Primary, secondary, support, and recovery priorities.",
      "validation": "The primary outcome is identifiable without reading every control."
    },
    {
      "id": "information-placement",
      "order": 3,
      "question": "Does the page provide and place the information needed for each intention?",
      "requiredOutput": "A map from information and actions to intent, placement, and visibility.",
      "validation": "Decision and recovery information appears where it is needed."
    },
    {
      "id": "necessary-reuse",
      "order": 4,
      "question": "Are components and compositions reused at the correct level?",
      "requiredOutput": "A reviewed reuse decision backed by component and pattern searches.",
      "validation": "No cataloged component or pattern is silently duplicated."
    },
    {
      "id": "interaction-states",
      "order": 5,
      "question": "Which interactions and state transitions can occur?",
      "requiredOutput": "Triggers, preconditions, states, transitions, and escape or retry paths.",
      "validation": "No supported action leaves the interface unexplained or unrecoverable."
    },
    {
      "id": "interaction-feedback",
      "order": 6,
      "question": "Does every interaction receive proportionate feedback?",
      "requiredOutput": "Immediate, persistent, failure, recovery, and announcement feedback.",
      "validation": "Every interaction has feedback for each applicable terminal or error state."
    },
    {
      "id": "experience-expectations",
      "order": 7,
      "question": "Does the design follow page and platform best practices and user expectations?",
      "requiredOutput": "Page-specific decisions with responsive, accessibility, and runtime evidence.",
      "validation": "Primary, boundary, and supported layout scenarios are exercised at runtime."
    }
  ],
  "designProcess": [
    {
      "id": "surface-inventory",
      "order": 1,
      "title": "Surface inventory",
      "goal": "Define the complete application surface and the experience contract before implementation.",
      "requiredEvidence": [
        "Every destination, detail, task, modal, sheet, overlay, and durable result is listed.",
        "Every surface names its user intents, meaningful states, source owner, and Page Experience Spec.",
        "Transitions make every listed surface reachable from the application entry surface."
      ],
      "exitCriteria": [
        "No visible or interactive surface is outside the inventory.",
        "The inventory distinguishes unsupported product ideas from implemented interactions."
      ]
    },
    {
      "id": "component-preview",
      "order": 2,
      "title": "Reusable component preview",
      "goal": "Verify public and application-shared building blocks before page composition.",
      "requiredEvidence": [
        "Relevant component states are interactive in focused Widget Previews.",
        "Color-owning components are reviewed in light and dark brightness."
      ],
      "exitCriteria": [
        "Reusable behavior, geometry, semantics, and state ownership are coherent in isolation."
      ]
    },
    {
      "id": "page-state-preview",
      "order": 3,
      "title": "Deterministic page-state preview",
      "goal": "Make the real page hierarchy and every meaningful state reviewable without launching the full app.",
      "requiredEvidence": [
        "The production page and real state owner are used with deterministic scenario factories.",
        "Each inventoried state is previewed at every supported layout class."
      ],
      "exitCriteria": [
        "Initial, boundary or recovery, and durable-result states are covered where applicable.",
        "No preview-only duplicate page implementation exists."
      ]
    },
    {
      "id": "integrated-runtime",
      "order": 4,
      "title": "Integrated runtime verification",
      "goal": "Verify behavior that an isolated Widget Preview cannot prove.",
      "requiredEvidence": [
        "Primary and recovery journeys exercise navigation, back behavior, overlays, and persistent state.",
        "Relevant input, accessibility, text scaling, and platform integration are exercised."
      ],
      "exitCriteria": [
        "The smallest sufficient full-app run confirms every cross-surface boundary in scope."
      ]
    },
    {
      "id": "app-wide-review",
      "order": 5,
      "title": "App-wide final review",
      "goal": "Review every surface and the application as a coherent experience before claiming Agent Ready.",
      "requiredEvidence": [
        "Every surface has a pass or changes-required verdict for all seven design rules.",
        "Navigation, hierarchy, product copy, responsive behavior, and accessibility are reviewed across surfaces.",
        "The final review explicitly covers every inventoried surface and records open findings."
      ],
      "exitCriteria": [
        "Every surface and cross-surface check passes.",
        "No open finding remains and the machine-readable App Experience Review validates as ready."
      ]
    }
  ],
  "patterns": [
    {
      "id": "adaptive-app-shell",
      "category": "Navigation",
      "summary": "Keeps page identity, top-level destinations, and contextual actions stable across an app flow.",
      "keywords": [
        "app shell",
        "bottom navigation",
        "page header",
        "responsive navigation"
      ],
      "useWhen": [
        "An application has stable top-level destinations and page-specific content.",
        "Compact and large layouts must preserve the same destination state."
      ],
      "avoidWhen": [
        "A gallery or section only needs a heading rather than application navigation."
      ],
      "components": [
        "CharcoalPageRoute",
        "CharcoalNavigationBar",
        "CharcoalTabBar",
        "CharcoalNavigationItem",
        "CharcoalIconButton"
      ],
      "composition": [
        "Keep destination selection in one state owner above the page body.",
        "Commit the controlled destination, selected visuals and semantics, and page content atomically in the first painted frame; do not mirror selection locally or repair it from route state after paint.",
        "On touch input, let pointer down change only the target pressed layer, let cancellation clear it without selecting, and commit the controlled destination only after the tap is accepted.",
        "Keep transient state layers paint-only: destination bounds, sibling allocation, icon and label centers, and text baselines must not move through hover, focus, press, cancellation, or selection.",
        "Treat top-level destination selection as a no-stack-effect state update; do not push a route, replace the root page, or change its stable page key.",
        "Push details and transient tasks with CharcoalPageRoute, replace a completed task with its durable result when prior steps must not return, and pop or dismiss through platform back behavior.",
        "On native iOS, verify the leading-edge gesture follows the pointer and can both cancel and commit; on native Android, verify predictive-back start, update, cancel, and commit drive the active Route before any stack mutation.",
        "Preserve destination-owned scroll positions, drafts, and selections when moving between top-level destinations.",
        "Place contextual actions in the current page; do not change top-level destination selection.",
        "Use CharcoalTabBar on compact layouts and CharcoalNavigationItem in large-layout sidebars without resetting destination state."
      ],
      "interactionStates": [
        "destination selected with no stack effect",
        "detail pushed",
        "transient task pushed",
        "durable result replaces task",
        "back pops or dismisses"
      ],
      "feedback": [
        "Persistent selection switches atomically; hover, focus, and press animate on a distinct state layer without tweening through stale selected state or resembling a second selection.",
        "State feedback preserves destination geometry and alignment.",
        "Back or close returns to the prior destination without clearing unrelated state."
      ],
      "accessibility": [
        "Expose one selected destination and explicit labels for icon-only actions.",
        "Preserve focus order and selected semantics when navigation placement changes."
      ],
      "responsiveBehavior": [
        "Switch navigation placement from constraints, not device or orientation checks."
      ]
    },
    {
      "id": "searchable-collection",
      "category": "Discovery",
      "summary": "Combines search, optional filtering, result context, and recoverable empty results.",
      "keywords": [
        "catalog",
        "filter",
        "product discovery",
        "search results"
      ],
      "useWhen": [
        "Users browse a collection and may narrow it by query or a small set of filters."
      ],
      "avoidWhen": [
        "The collection is short and fully visible without search or filtering."
      ],
      "components": [
        "CharcoalTextField",
        "CharcoalSegmentedControl",
        "CharcoalClickable",
        "CharcoalIconButton"
      ],
      "composition": [
        "Keep query and filter state in the collection owner.",
        "Place result count or category context immediately before the results.",
        "Preserve the query in an empty state and offer a nearby clear or alternate-filter recovery."
      ],
      "interactionStates": [
        "browsing",
        "filtering",
        "results",
        "empty results",
        "detail"
      ],
      "feedback": [
        "Update result context with the query or selected filter.",
        "Empty results explain what was retained and how to recover."
      ],
      "accessibility": [
        "Name the search field and filter group; expose saved state on result actions."
      ],
      "responsiveBehavior": [
        "Adjust result columns from available width while keeping readable card widths."
      ]
    },
    {
      "id": "contextual-composer",
      "category": "Communication",
      "summary": "Keeps reply or message context visible while sharing input, validation, send, and retry behavior.",
      "keywords": [
        "comment",
        "composer",
        "message",
        "reply",
        "send"
      ],
      "useWhen": [
        "A user writes a message or reply whose destination and surrounding context matter."
      ],
      "avoidWhen": [
        "The task is a long standalone document or a generic single-value form field."
      ],
      "components": [
        "CharcoalTextArea",
        "CharcoalIconButton",
        "CharcoalButton"
      ],
      "composition": [
        "Share the input and action skeleton while injecting conversation-specific context and send behavior.",
        "Retain authored text when sending fails and keep retry next to the error."
      ],
      "interactionStates": [
        "empty",
        "editing",
        "disabled",
        "sending",
        "sent",
        "failed"
      ],
      "feedback": [
        "Disable send for invalid input, acknowledge progress, and retain text on failure."
      ],
      "accessibility": [
        "Label the destination, input, and send action; announce non-focus-moving send results."
      ],
      "responsiveBehavior": [
        "Keep primary context visible and move the action without shrinking the input below readability."
      ]
    },
    {
      "id": "financial-action-flow",
      "category": "Transactions",
      "summary": "Separates selecting a financial action, entering trusted details, reviewing, and confirming the result.",
      "keywords": [
        "money transfer",
        "payment",
        "send money",
        "top up",
        "transaction"
      ],
      "useWhen": [
        "An action changes a balance or creates a durable financial transaction."
      ],
      "avoidWhen": [
        "The action is reversible, low-risk, and contains no amount or recipient decision."
      ],
      "components": [
        "CharcoalTextField",
        "CharcoalButton",
        "CharcoalSegmentedControl",
        "CharcoalDialog"
      ],
      "composition": [
        "Collect recipient and amount before presenting a clear review step.",
        "Keep balance impact and destination visible at confirmation.",
        "Record the successful result in persistent activity, not only transient feedback."
      ],
      "interactionStates": [
        "ready",
        "editing",
        "invalid",
        "review",
        "submitting",
        "success",
        "failed"
      ],
      "feedback": [
        "Explain invalid input inline and show a durable receipt after success.",
        "Retain entered values and offer retry when submission fails."
      ],
      "accessibility": [
        "Keep field labels visible and announce the confirmed amount and recipient."
      ],
      "responsiveBehavior": [
        "Use a focused compact flow and a constrained review surface on large widths."
      ]
    },
    {
      "id": "daily-checklist",
      "category": "Progress",
      "summary": "Presents a breathable set of daily commitments with progress, completion, undo, and next-step feedback.",
      "keywords": [
        "checklist",
        "daily habits",
        "progress",
        "tasks",
        "todo"
      ],
      "useWhen": [
        "Users complete a small, meaningful set of items during the current day or session."
      ],
      "avoidWhen": [
        "Items are a dense backlog requiring sorting, bulk selection, or complex metadata."
      ],
      "components": [
        "CharcoalCheckbox",
        "CharcoalButton",
        "CharcoalTypography"
      ],
      "composition": [
        "Give each item enough vertical separation to scan label, supporting context, and completion state.",
        "Keep progress near the list and reveal the next action only when it becomes relevant.",
        "Allow a completed item to be unchecked without losing other progress."
      ],
      "interactionStates": [
        "incomplete",
        "partially complete",
        "complete",
        "reopened"
      ],
      "feedback": [
        "Update progress immediately and provide completion feedback without blocking continued review."
      ],
      "accessibility": [
        "Expose each item label and checked state; do not rely on decoration alone."
      ],
      "responsiveBehavior": [
        "Constrain the checklist for reading on large widths and preserve touch targets on compact widths."
      ]
    },
    {
      "id": "empty-state-recovery",
      "category": "Feedback",
      "summary": "Explains why content is absent and provides the most useful recovery or creation action.",
      "keywords": [
        "empty",
        "no results",
        "no saved items",
        "recovery",
        "zero state"
      ],
      "useWhen": [
        "A collection or result can legitimately contain no content."
      ],
      "avoidWhen": [
        "Content is merely loading or failed to load; preserve those distinct states."
      ],
      "components": [
        "CharcoalTypography",
        "CharcoalButton"
      ],
      "composition": [
        "State what is empty, why when known, and one relevant next action.",
        "Keep query or filter context visible when it explains the empty result."
      ],
      "interactionStates": [
        "empty",
        "recovering",
        "content"
      ],
      "feedback": [
        "Recovery updates the same content region so cause and result remain connected."
      ],
      "accessibility": [
        "Use a meaningful heading and make the recovery action reachable in reading order."
      ],
      "responsiveBehavior": [
        "Keep copy readable and action width appropriate to the available constraint."
      ]
    }
  ],
  "components": [
    {
      "name": "CharcoalAnchoredBalloon",
      "category": "Overlays",
      "summary": "Tracks an anchor and presents persistent details or actions with controlled or internal visibility.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/balloon.dart",
      "documentationLevel": "curated",
      "keywords": [
        "anchored callout",
        "coach mark",
        "popover",
        "persistent details"
      ],
      "useWhen": [
        "An anchor opens persistent explanatory content or a small related action and the surface must follow that anchor.",
        "One parent-owned value must coordinate the trigger label, keyboard activation, outside dismissal, and visible surface."
      ],
      "avoidWhen": [
        "Only a brief non-interactive label is needed; use CharcoalTooltip.",
        "The caller already owns static layout and directional placement; use CharcoalBalloon.",
        "The content is a menu, blocking decision, form, or multi-step task; use the appropriate selection control, dialog, or page."
      ],
      "accessibility": [
        "For an interactive anchor, prefer controlled visibility with showOnTap false and toggle visible from the anchor action so pointer and keyboard activation share one path.",
        "Update the anchor semantic label to describe the next action, such as Show details or Hide details.",
        "Escape dismisses from the focused anchor or a focused balloon action; the close affordance supports keyboard activation.",
        "Do not claim modal focus containment: move blocking or focus-trapped work to CharcoalDialog."
      ],
      "responsiveBehavior": [
        "Placement prefers below, above, right, then left before choosing the largest remaining area.",
        "The surface respects screen insets, wraps within maxWidth, and follows the anchor while it scrolls.",
        "Use dismissOnTapOutside deliberately; persistent teaching content may remain open while contextual details commonly dismiss outside."
      ],
      "interactionStates": [
        "hidden",
        "opening",
        "visible",
        "action focused",
        "closing"
      ],
      "feedbackResponsibilities": [
        "Owns anchor tracking, collision-safe placement, presentation motion, close feedback, optional timeout, and dismissal requests.",
        "In controlled usage the caller owns the visible value, trigger activation, dynamic label, action result, and durable state."
      ],
      "tokenRoles": [
        "containerPrimaryDefault",
        "textOnPrimaryDefault",
        "containerOnImgDefault",
        "space.layout30",
        "radius.xl",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalBalloon",
        "CharcoalTooltip",
        "CharcoalButton",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalAnchoredBalloon",
          "kind": "constructor",
          "signature": "CharcoalAnchoredBalloon({required this.anchor, required this.message, this.action, this.dismissIcon, this.dismissAfter, this.dismissOnTapOutside = false, this.maxWidth, this.onVisibilityChanged, this.showOnTap = true, this.visible, super.key})",
          "parameters": [
            {
              "name": "anchor",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissAfter",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissOnTapOutside",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onVisibilityChanged",
              "type": "ValueChanged<bool>?",
              "required": false,
              "named": true
            },
            {
              "name": "showOnTap",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "visible",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalOverlayPosition",
          "kind": "enum",
          "signature": "enum CharcoalOverlayPosition { top, right, bottom, left }",
          "parameters": [],
          "enumValues": [
            "top",
            "right",
            "bottom",
            "left"
          ]
        }
      ],
      "examples": [
        {
          "id": "anchored-overlay-controls",
          "title": "Brief and persistent anchored context",
          "description": "Separates non-interactive tooltip help from persistent and controlled balloon content.",
          "sourcePath": "example/lib/agent_examples/overlay_controls_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Separates brief tooltip context, persistent callouts, and anchored details.\nfinal class AgentOverlayControlsExample extends StatefulWidget {\n  const AgentOverlayControlsExample({super.key});\n\n  @override\n  State<AgentOverlayControlsExample> createState() =>\n      _AgentOverlayControlsExampleState();\n}\n\nfinal class _AgentOverlayControlsExampleState\n    extends State<AgentOverlayControlsExample> {\n  bool _detailsVisible = false;\n  String _status = 'No overlay action yet';\n\n  void _setDetailsVisible(bool visible) {\n    if (_detailsVisible == visible) return;\n    setState(() {\n      _detailsVisible = visible;\n      _status = visible\n          ? 'Publishing details open'\n          : 'Publishing details closed';\n    });\n  }\n\n  void _reviewSettings() {\n    setState(() {\n      _detailsVisible = false;\n      _status = 'Settings review requested';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Anchored context', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Text(_status, style: theme.textStyles.captionMedium),\n        SizedBox(height: space.layout40),\n        const Align(\n          alignment: AlignmentDirectional.centerStart,\n          child: CharcoalBalloon(\n            position: CharcoalOverlayPosition.left,\n            semanticLabel: 'Publishing guidance',\n            child: Text('Drafts remain private until you publish.'),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        Wrap(\n          crossAxisAlignment: WrapCrossAlignment.center,\n          spacing: space.component30,\n          runSpacing: space.component30,\n          children: <Widget>[\n            CharcoalTooltip(\n              message: 'Copies a shareable link',\n              child: CharcoalIconButton(\n                icon: const CharcoalIcon(CharcoalIcons.link),\n                onPressed: () => setState(() => _status = 'Share link copied'),\n                semanticLabel: 'Copy share link',\n              ),\n            ),\n            CharcoalAnchoredBalloon(\n              action: CharcoalLinkButton(\n                onPressed: _reviewSettings,\n                child: const Text('Review settings'),\n              ),\n              anchor: CharcoalButton(\n                leading: const CharcoalIcon(CharcoalIcons.questionCircle),\n                onPressed: () => _setDetailsVisible(!_detailsVisible),\n                semanticLabel: _detailsVisible\n                    ? 'Hide publishing details'\n                    : 'Show publishing details',\n                child: const Text('Publishing details'),\n              ),\n              dismissOnTapOutside: true,\n              message: 'Only workspace owners can publish this draft.',\n              onVisibilityChanged: _setDetailsVisible,\n              showOnTap: false,\n              visible: _detailsVisible,\n            ),\n          ],\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalApp",
      "category": "Application",
      "summary": "Hosts a Charcoal application with Navigator or Router navigation and shared platform infrastructure.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/app/charcoal_app.dart",
      "documentationLevel": "curated",
      "keywords": [
        "app shell",
        "declarative routing",
        "localization",
        "navigator",
        "restoration",
        "router",
        "theme"
      ],
      "useWhen": [
        "A standalone Flutter application needs Charcoal theme, navigation, localization, shortcuts, and restoration at its root.",
        "Declarative routing or deep links need the same Charcoal infrastructure as imperative Navigator routes."
      ],
      "avoidWhen": [
        "Only a subtree needs a theme override; wrap that subtree in CharcoalTheme instead.",
        "A nested flow needs its own Navigator; keep the application shell at the root and add a nested Navigator locally."
      ],
      "accessibility": [
        "Pass localization delegates and supported locales so framework and product labels resolve from the active locale.",
        "Verify the complete application with platform assistive technology instead of treating the app shell as an accessibility substitute."
      ],
      "responsiveBehavior": [
        "The default ScrollBehavior follows Flutter platform conventions and can be replaced at the application boundary.",
        "Shortcuts and actions apply to the complete app so touch, pointer, and keyboard paths share destination state.",
        "Use the builder above Navigator or Router for app-wide responsive policy rather than replacing route identity."
      ],
      "interactionStates": [
        "light",
        "dark",
        "restoring"
      ],
      "feedbackResponsibilities": [
        "Owns the effective theme, root scroll policy, Hero controller, locale, shortcuts, and restoration scope.",
        "The application owns route definitions, deep-link parsing, durable destination state, and product localization resources."
      ],
      "tokenRoles": [
        "backgroundDefault",
        "containerPrimaryDefault",
        "textDefault"
      ],
      "relatedComponents": [
        "CharcoalPageRoute",
        "CharcoalTheme",
        "CharcoalNavigationBar",
        "CharcoalTabBar"
      ],
      "apis": [
        {
          "name": "CharcoalApp",
          "kind": "constructor",
          "signature": "CharcoalApp({this.navigatorKey, this.home, this.routes = const <String, WidgetBuilder>{}, this.initialRoute, this.onGenerateRoute, this.onGenerateInitialRoutes, this.onUnknownRoute, this.navigatorObservers = const <NavigatorObserver>[], this.builder, this.title = '', this.onGenerateTitle, this.theme, this.darkTheme, this.themeMode = CharcoalThemeMode.system, this.locale, this.localizationsDelegates, this.localeListResolutionCallback, this.localeResolutionCallback, this.supportedLocales = const <Locale>[Locale('en', 'US')], this.debugShowCheckedModeBanner = false, this.shortcuts, this.actions, this.restorationScopeId, this.scrollBehavior, this.pageRouteBuilder, super.key})",
          "parameters": [
            {
              "name": "navigatorKey",
              "type": "GlobalKey<NavigatorState>?",
              "required": false,
              "named": true
            },
            {
              "name": "home",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "routes",
              "type": "Map<String, WidgetBuilder>",
              "required": false,
              "named": true,
              "defaultValue": "const <String, WidgetBuilder>{}"
            },
            {
              "name": "initialRoute",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "onGenerateRoute",
              "type": "RouteFactory?",
              "required": false,
              "named": true
            },
            {
              "name": "onGenerateInitialRoutes",
              "type": "InitialRouteListFactory?",
              "required": false,
              "named": true
            },
            {
              "name": "onUnknownRoute",
              "type": "RouteFactory?",
              "required": false,
              "named": true
            },
            {
              "name": "navigatorObservers",
              "type": "List<NavigatorObserver>",
              "required": false,
              "named": true,
              "defaultValue": "const <NavigatorObserver>[]"
            },
            {
              "name": "builder",
              "type": "TransitionBuilder?",
              "required": false,
              "named": true
            },
            {
              "name": "title",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "onGenerateTitle",
              "type": "GenerateAppTitle?",
              "required": false,
              "named": true
            },
            {
              "name": "theme",
              "type": "CharcoalThemeData?",
              "required": false,
              "named": true
            },
            {
              "name": "darkTheme",
              "type": "CharcoalThemeData?",
              "required": false,
              "named": true
            },
            {
              "name": "themeMode",
              "type": "CharcoalThemeMode",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalThemeMode.system"
            },
            {
              "name": "locale",
              "type": "Locale?",
              "required": false,
              "named": true
            },
            {
              "name": "localizationsDelegates",
              "type": "Iterable<LocalizationsDelegate<dynamic>>?",
              "required": false,
              "named": true
            },
            {
              "name": "localeListResolutionCallback",
              "type": "LocaleListResolutionCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "localeResolutionCallback",
              "type": "LocaleResolutionCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "supportedLocales",
              "type": "Iterable<Locale>",
              "required": false,
              "named": true,
              "defaultValue": "const <Locale>[Locale('en', 'US')]"
            },
            {
              "name": "debugShowCheckedModeBanner",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "shortcuts",
              "type": "Map<ShortcutActivator, Intent>?",
              "required": false,
              "named": true
            },
            {
              "name": "actions",
              "type": "Map<Type, Action<Intent>>?",
              "required": false,
              "named": true
            },
            {
              "name": "restorationScopeId",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "scrollBehavior",
              "type": "ScrollBehavior?",
              "required": false,
              "named": true
            },
            {
              "name": "pageRouteBuilder",
              "type": "PageRouteFactory?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalApp.router",
          "kind": "constructor",
          "signature": "CharcoalApp.router({this.routeInformationProvider, this.routeInformationParser, this.routerDelegate, this.routerConfig, this.backButtonDispatcher, this.builder, this.title = '', this.onGenerateTitle, this.theme, this.darkTheme, this.themeMode = CharcoalThemeMode.system, this.locale, this.localizationsDelegates, this.localeListResolutionCallback, this.localeResolutionCallback, this.supportedLocales = const <Locale>[Locale('en', 'US')], this.debugShowCheckedModeBanner = false, this.shortcuts, this.actions, this.restorationScopeId, this.scrollBehavior, super.key})",
          "parameters": [
            {
              "name": "routeInformationProvider",
              "type": "RouteInformationProvider?",
              "required": false,
              "named": true
            },
            {
              "name": "routeInformationParser",
              "type": "RouteInformationParser<Object>?",
              "required": false,
              "named": true
            },
            {
              "name": "routerDelegate",
              "type": "RouterDelegate<Object>?",
              "required": false,
              "named": true
            },
            {
              "name": "routerConfig",
              "type": "RouterConfig<Object>?",
              "required": false,
              "named": true
            },
            {
              "name": "backButtonDispatcher",
              "type": "BackButtonDispatcher?",
              "required": false,
              "named": true
            },
            {
              "name": "builder",
              "type": "TransitionBuilder?",
              "required": false,
              "named": true
            },
            {
              "name": "title",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "onGenerateTitle",
              "type": "GenerateAppTitle?",
              "required": false,
              "named": true
            },
            {
              "name": "theme",
              "type": "CharcoalThemeData?",
              "required": false,
              "named": true
            },
            {
              "name": "darkTheme",
              "type": "CharcoalThemeData?",
              "required": false,
              "named": true
            },
            {
              "name": "themeMode",
              "type": "CharcoalThemeMode",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalThemeMode.system"
            },
            {
              "name": "locale",
              "type": "Locale?",
              "required": false,
              "named": true
            },
            {
              "name": "localizationsDelegates",
              "type": "Iterable<LocalizationsDelegate<dynamic>>?",
              "required": false,
              "named": true
            },
            {
              "name": "localeListResolutionCallback",
              "type": "LocaleListResolutionCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "localeResolutionCallback",
              "type": "LocaleResolutionCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "supportedLocales",
              "type": "Iterable<Locale>",
              "required": false,
              "named": true,
              "defaultValue": "const <Locale>[Locale('en', 'US')]"
            },
            {
              "name": "debugShowCheckedModeBanner",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "shortcuts",
              "type": "Map<ShortcutActivator, Intent>?",
              "required": false,
              "named": true
            },
            {
              "name": "actions",
              "type": "Map<Type, Action<Intent>>?",
              "required": false,
              "named": true
            },
            {
              "name": "restorationScopeId",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "scrollBehavior",
              "type": "ScrollBehavior?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalThemeMode",
          "kind": "enum",
          "signature": "enum CharcoalThemeMode { system, light, dark }",
          "parameters": [],
          "enumValues": [
            "system",
            "light",
            "dark"
          ]
        }
      ],
      "examples": [
        {
          "id": "app-router",
          "title": "Router-backed application shell",
          "description": "Installs a declarative Router with Charcoal theme, localization, scrolling, shortcuts, and restoration infrastructure.",
          "sourcePath": "example/lib/agent_examples/app_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Hosts a declarative router inside Charcoal's complete application boundary.\nfinal class AgentCharcoalAppExample extends StatelessWidget {\n  const AgentCharcoalAppExample({\n    required this.routerConfig,\n    required this.localizationsDelegates,\n    required this.supportedLocales,\n    super.key,\n  });\n\n  final RouterConfig<Object> routerConfig;\n  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;\n  final Iterable<Locale> supportedLocales;\n\n  @override\n  Widget build(BuildContext context) => CharcoalApp.router(\n    routerConfig: routerConfig,\n    localizationsDelegates: localizationsDelegates,\n    supportedLocales: supportedLocales,\n    restorationScopeId: 'charcoal-example-app',\n    title: 'Charcoal',\n  );\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalBalloon",
      "category": "Overlays",
      "summary": "Renders a persistent speech surface when the caller already owns its layout and directional relationship.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/balloon.dart",
      "documentationLevel": "curated",
      "keywords": [
        "callout",
        "persistent hint",
        "speech balloon"
      ],
      "useWhen": [
        "A short callout must remain visible in an authored layout and point toward nearby content.",
        "The caller already owns placement and optionally needs an action or explicit close affordance."
      ],
      "avoidWhen": [
        "The surface must follow a moving trigger and choose a collision-safe position; use CharcoalAnchoredBalloon.",
        "The message is brief, supplementary, and transient; use CharcoalTooltip.",
        "The content is a blocking task or requires focus containment; use CharcoalDialog."
      ],
      "accessibility": [
        "Provide semanticLabel when the child does not state the callout purpose on its own.",
        "The optional close affordance supports pointer, Tab traversal, Enter, and Space activation with visible focus.",
        "Every action widget owns its label and result; the balloon is a non-modal semantic container."
      ],
      "responsiveBehavior": [
        "Content wraps within maxWidth while component-owned padding and tail geometry remain stable.",
        "Choose position for the authored relationship and use arrowCenter only when the caller has measured the target.",
        "For automatic placement, screen insets, and scroll tracking, use CharcoalAnchoredBalloon."
      ],
      "interactionStates": [
        "visible",
        "action focused",
        "action pressed",
        "close focused",
        "dismissed"
      ],
      "feedbackResponsibilities": [
        "Owns surface, tail, readable width, semantic grouping, and close-control interaction feedback.",
        "The caller owns visibility, placement in the surrounding layout, action outcomes, and durable state."
      ],
      "tokenRoles": [
        "containerPrimaryDefault",
        "textOnPrimaryDefault",
        "containerOnImgDefault",
        "space.component25",
        "space.component30",
        "radius.xl",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalAnchoredBalloon",
        "CharcoalTooltip",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalBalloon",
          "kind": "constructor",
          "signature": "CharcoalBalloon({required this.child, this.action, this.arrowCenter, this.dismissIcon, this.maxWidth, this.onDismiss, this.position = CharcoalOverlayPosition.top, this.semanticLabel, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "arrowCenter",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onDismiss",
              "type": "VoidCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "position",
              "type": "CharcoalOverlayPosition",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalOverlayPosition.top"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalOverlayPosition",
          "kind": "enum",
          "signature": "enum CharcoalOverlayPosition { top, right, bottom, left }",
          "parameters": [],
          "enumValues": [
            "top",
            "right",
            "bottom",
            "left"
          ]
        }
      ],
      "examples": [
        {
          "id": "anchored-overlay-controls",
          "title": "Brief and persistent anchored context",
          "description": "Separates non-interactive tooltip help from persistent and controlled balloon content.",
          "sourcePath": "example/lib/agent_examples/overlay_controls_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Separates brief tooltip context, persistent callouts, and anchored details.\nfinal class AgentOverlayControlsExample extends StatefulWidget {\n  const AgentOverlayControlsExample({super.key});\n\n  @override\n  State<AgentOverlayControlsExample> createState() =>\n      _AgentOverlayControlsExampleState();\n}\n\nfinal class _AgentOverlayControlsExampleState\n    extends State<AgentOverlayControlsExample> {\n  bool _detailsVisible = false;\n  String _status = 'No overlay action yet';\n\n  void _setDetailsVisible(bool visible) {\n    if (_detailsVisible == visible) return;\n    setState(() {\n      _detailsVisible = visible;\n      _status = visible\n          ? 'Publishing details open'\n          : 'Publishing details closed';\n    });\n  }\n\n  void _reviewSettings() {\n    setState(() {\n      _detailsVisible = false;\n      _status = 'Settings review requested';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Anchored context', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Text(_status, style: theme.textStyles.captionMedium),\n        SizedBox(height: space.layout40),\n        const Align(\n          alignment: AlignmentDirectional.centerStart,\n          child: CharcoalBalloon(\n            position: CharcoalOverlayPosition.left,\n            semanticLabel: 'Publishing guidance',\n            child: Text('Drafts remain private until you publish.'),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        Wrap(\n          crossAxisAlignment: WrapCrossAlignment.center,\n          spacing: space.component30,\n          runSpacing: space.component30,\n          children: <Widget>[\n            CharcoalTooltip(\n              message: 'Copies a shareable link',\n              child: CharcoalIconButton(\n                icon: const CharcoalIcon(CharcoalIcons.link),\n                onPressed: () => setState(() => _status = 'Share link copied'),\n                semanticLabel: 'Copy share link',\n              ),\n            ),\n            CharcoalAnchoredBalloon(\n              action: CharcoalLinkButton(\n                onPressed: _reviewSettings,\n                child: const Text('Review settings'),\n              ),\n              anchor: CharcoalButton(\n                leading: const CharcoalIcon(CharcoalIcons.questionCircle),\n                onPressed: () => _setDetailsVisible(!_detailsVisible),\n                semanticLabel: _detailsVisible\n                    ? 'Hide publishing details'\n                    : 'Show publishing details',\n                child: const Text('Publishing details'),\n              ),\n              dismissOnTapOutside: true,\n              message: 'Only workspace owners can publish this draft.',\n              onVisibilityChanged: _setDetailsVisible,\n              showOnTap: false,\n              visible: _detailsVisible,\n            ),\n          ],\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalButton",
      "category": "Actions",
      "summary": "Runs an action with Charcoal interaction states, sizing, and visual variants.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/button.dart",
      "documentationLevel": "curated",
      "keywords": [
        "action",
        "button",
        "call to action",
        "cta",
        "submit"
      ],
      "useWhen": [
        "The user initiates an immediate action such as saving, continuing, or deleting.",
        "A leading or trailing icon needs to remain aligned with a text label."
      ],
      "avoidWhen": [
        "Navigation is better represented by CharcoalNavigationItem.",
        "The action should look like inline text; use CharcoalLinkButton instead."
      ],
      "accessibility": [
        "Pass semanticLabel when child content does not describe the action on its own.",
        "Leave selected null for a regular action; pass false or true only for a controlled toggle that must expose explicit selection semantics.",
        "A null onPressed value exposes the disabled state and removes interaction."
      ],
      "responsiveBehavior": [
        "Set fullWidth on compact layouts when the action should fill its parent constraint.",
        "Let the parent choose available width; do not hard-code the component height."
      ],
      "interactionStates": [
        "idle",
        "hovered",
        "focused",
        "pressed",
        "selected",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns pointer, focus, pressed, selected, and disabled presentation.",
        "The caller owns progress, success, failure, recovery, and the durable action result."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.targetM",
        "space.component10",
        "space.component30",
        "space.component40",
        "radius.oval"
      ],
      "relatedComponents": [
        "CharcoalIconButton",
        "CharcoalLinkButton"
      ],
      "apis": [
        {
          "name": "CharcoalButton",
          "kind": "constructor",
          "signature": "CharcoalButton({required this.child, required this.onPressed, this.autofocus = false, this.focusNode, this.fullWidth = false, this.leading, this.primaryColor, this.semanticLabel, this.selected, this.size = CharcoalButtonSize.medium, this.statesController, this.trailing, this.variant = CharcoalButtonVariant.normal, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "fullWidth",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "primaryColor",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalButtonSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalButtonSize.medium"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "trailing",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalButtonVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalButtonVariant.normal"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalButtonVariant",
          "kind": "enum",
          "signature": "enum CharcoalButtonVariant { normal, primary, overlay, danger, navigation }",
          "parameters": [],
          "enumValues": [
            "normal",
            "primary",
            "overlay",
            "danger",
            "navigation"
          ]
        },
        {
          "name": "CharcoalButtonSize",
          "kind": "enum",
          "signature": "enum CharcoalButtonSize { small, medium }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium"
          ]
        }
      ],
      "examples": [
        {
          "id": "button-basic",
          "title": "Primary and secondary actions",
          "description": "A compact action row that becomes full-width when constrained.",
          "sourcePath": "example/lib/agent_examples/button_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A responsive pair of primary and secondary actions.\nfinal class AgentButtonExample extends StatelessWidget {\n  const AgentButtonExample({\n    required this.onContinue,\n    required this.onCancel,\n    super.key,\n  });\n\n  final VoidCallback onContinue;\n  final VoidCallback onCancel;\n\n  @override\n  Widget build(BuildContext context) {\n    final gap = CharcoalTheme.of(context).dimensions.space.component20;\n    return LayoutBuilder(\n      builder: (context, constraints) {\n        final compact = constraints.maxWidth < 420;\n        final cancel = CharcoalButton(\n          fullWidth: compact,\n          onPressed: onCancel,\n          child: const Text('Cancel'),\n        );\n        final submit = CharcoalButton(\n          fullWidth: compact,\n          onPressed: onContinue,\n          variant: CharcoalButtonVariant.primary,\n          child: const Text('Continue'),\n        );\n        if (compact) {\n          return Column(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            mainAxisSize: MainAxisSize.min,\n            children: <Widget>[\n              submit,\n              SizedBox(height: gap),\n              cancel,\n            ],\n          );\n        }\n        return Row(\n          mainAxisSize: MainAxisSize.min,\n          children: <Widget>[\n            cancel,\n            SizedBox(width: gap),\n            submit,\n          ],\n        );\n      },\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalCarousel",
      "category": "Navigation",
      "summary": "Presents a short, non-auto-rotating horizontal sequence across touch, pointer, keyboard, and assistive input.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/carousel.dart",
      "documentationLevel": "curated",
      "keywords": [
        "carousel",
        "featured content",
        "gallery",
        "page indicator",
        "slide",
        "swipe"
      ],
      "useWhen": [
        "A short set of related featured, media, or explanatory items benefits from direct swiping and optional neighboring-page context.",
        "The sequence remains meaningful without automatic rotation and the caller can provide a bounded height for every supported layout."
      ],
      "avoidWhen": [
        "The user is moving between stable application destinations; use CharcoalTabBar or CharcoalNavigationItem.",
        "A finite result collection needs direct access to numbered pages; use CharcoalPagination.",
        "A long or unbounded collection must remain simultaneously discoverable; use a scrollable list or gallery instead.",
        "Only one static item exists or essential information would become hidden in an unvisited slide."
      ],
      "accessibility": [
        "Name the carousel region and use semanticLabelBuilder to localize each zero-based slide and indicator position.",
        "Give every image and action inside a slide its own meaningful label; the carousel does not replace child semantics.",
        "Arrow keys follow reading direction, Home and End reach boundaries, indicators expose selection, and unavailable boundary controls leave semantics and focus traversal.",
        "Keyboard focus reveals overlay navigation before focus enters its buttons, so a focused control never becomes visually hidden."
      ],
      "responsiveBehavior": [
        "The parent supplies a bounded height; small shows one full page and indicators, while medium defaults to a partial neighbor and overlay navigation.",
        "Touch and trackpad users swipe the viewport without depending on hover; pointer hover and focus-within reveal desktop navigation.",
        "A long indicator row scrolls horizontally instead of overflowing compact constraints, but keep carousel sequences intentionally short.",
        "Slides, chevrons, and horizontal arrow keys follow ambient LTR or RTL direction."
      ],
      "interactionStates": [
        "idle",
        "dragging",
        "settling",
        "hovered",
        "focus within",
        "current page",
        "first page",
        "last page"
      ],
      "feedbackResponsibilities": [
        "Owns viewport motion, the internal current page, selected indicators, boundary availability, and navigation feedback when no controller is supplied.",
        "An external PageController owns the first painted page and viewport fraction; the caller owns that controller lifecycle and observes accepted pages through onPageChanged.",
        "The caller owns slide loading, errors, action outcomes, live page context when needed, routes, and durable product state."
      ],
      "tokenRoles": [
        "space.targetM",
        "space.component20",
        "radius.oval",
        "borderFocusLegacy",
        "borderFocus1",
        "textDefault",
        "textTertiaryDefault"
      ],
      "relatedComponents": [
        "CharcoalIconButton",
        "CharcoalPagination",
        "CharcoalTabBar"
      ],
      "apis": [
        {
          "name": "CharcoalCarousel",
          "kind": "constructor",
          "signature": "CharcoalCarousel({required this.children, this.allowImplicitScrolling = false, this.autofocus = false, this.controller, this.focusNode, this.gap, this.initialPage = 0, this.onPageChanged, this.physics, this.previousSemanticLabel = 'Previous', this.semanticLabel = 'Carousel', this.semanticLabelBuilder, this.showIndicators, this.showNavigationButtons, this.size = CharcoalCarouselSize.medium, this.nextSemanticLabel = 'Next', this.viewportFraction, super.key})",
          "parameters": [
            {
              "name": "children",
              "type": "List<Widget>",
              "required": true,
              "named": true
            },
            {
              "name": "allowImplicitScrolling",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "controller",
              "type": "PageController?",
              "required": false,
              "named": true
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "gap",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "initialPage",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "0"
            },
            {
              "name": "onPageChanged",
              "type": "ValueChanged<int>?",
              "required": false,
              "named": true
            },
            {
              "name": "physics",
              "type": "ScrollPhysics?",
              "required": false,
              "named": true
            },
            {
              "name": "previousSemanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Previous'"
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Carousel'"
            },
            {
              "name": "semanticLabelBuilder",
              "type": "CharcoalCarouselSemanticLabelBuilder?",
              "required": false,
              "named": true
            },
            {
              "name": "showIndicators",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "showNavigationButtons",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalCarouselSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalCarouselSize.medium"
            },
            {
              "name": "nextSemanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Next'"
            },
            {
              "name": "viewportFraction",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalCarouselSize",
          "kind": "enum",
          "signature": "enum CharcoalCarouselSize { small, medium }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium"
          ]
        }
      ],
      "examples": [
        {
          "id": "carousel-responsive-featured-guides",
          "title": "Responsive featured guides",
          "description": "Preserves reported page context while the same carousel moves between compact full-page and wide neighboring-page layouts.",
          "sourcePath": "example/lib/agent_examples/carousel_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A responsive featured-content carousel with caller-owned page context.\nfinal class AgentCarouselExample extends StatefulWidget {\n  const AgentCarouselExample({super.key});\n\n  @override\n  State<AgentCarouselExample> createState() => _AgentCarouselExampleState();\n}\n\nfinal class _AgentCarouselExampleState extends State<AgentCarouselExample> {\n  static const _guides = <({String title, String description})>[\n    (\n      title: 'Build a calm first run',\n      description: 'Introduce one decision before revealing advanced tools.',\n    ),\n    (\n      title: 'Keep navigation truthful',\n      description: 'Stable destinations switch state; detail work uses routes.',\n    ),\n    (\n      title: 'Make recovery explicit',\n      description:\n          'Errors explain what remains safe and the next useful action.',\n    ),\n    (\n      title: 'Verify every input path',\n      description:\n          'Touch, pointer, keyboard, and assistive actions share outcomes.',\n    ),\n  ];\n\n  int _currentPage = 0;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    final colors = <Color>[\n      theme.colors.containerSecondaryDefault,\n      theme.colors.containerNeutralDefault,\n      theme.colors.containerTertiaryDefault,\n      theme.colors.containerSecondaryDefaultA,\n    ];\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Featured guides', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: true,\n          child: Text(\n            'Guide ${_currentPage + 1} of ${_guides.length}: '\n            '${_guides[_currentPage].title}',\n            style: theme.textStyles.captionMedium.copyWith(\n              color: theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        LayoutBuilder(\n          builder: (context, constraints) {\n            final compact = constraints.maxWidth < 480;\n            return SizedBox(\n              height: 200,\n              child: CharcoalCarousel(\n                gap: compact ? 0 : space.component20,\n                onPageChanged: (page) => setState(() => _currentPage = page),\n                semanticLabel: 'Featured guides',\n                semanticLabelBuilder: (index, itemCount) =>\n                    'Guide ${index + 1} of $itemCount: ${_guides[index].title}',\n                showIndicators: true,\n                size: compact\n                    ? CharcoalCarouselSize.small\n                    : CharcoalCarouselSize.medium,\n                children: <Widget>[\n                  for (var index = 0; index < _guides.length; index++)\n                    _GuideSlide(\n                      color: colors[index],\n                      description: _guides[index].description,\n                      title: _guides[index].title,\n                    ),\n                ],\n              ),\n            );\n          },\n        ),\n      ],\n    );\n  }\n}\n\nfinal class _GuideSlide extends StatelessWidget {\n  const _GuideSlide({\n    required this.color,\n    required this.description,\n    required this.title,\n  });\n\n  final Color color;\n  final String description;\n  final String title;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return DecoratedBox(\n      decoration: BoxDecoration(\n        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n        color: color,\n      ),\n      child: Padding(\n        padding: EdgeInsets.all(space.layout30),\n        child: Column(\n          crossAxisAlignment: CrossAxisAlignment.start,\n          mainAxisAlignment: MainAxisAlignment.center,\n          children: <Widget>[\n            Text(title, style: theme.textStyles.bodyBold),\n            SizedBox(height: space.component20),\n            Text(\n              description,\n              maxLines: 3,\n              overflow: TextOverflow.ellipsis,\n              style: theme.textStyles.captionMedium.copyWith(\n                color: theme.colors.textSecondaryDefault,\n              ),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalCheckbox",
      "category": "Forms",
      "summary": "Toggles one independent boolean choice in a controlled form or checklist.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/checkbox.dart",
      "documentationLevel": "curated",
      "keywords": [
        "boolean input",
        "checkbox",
        "checklist",
        "consent",
        "multiple choice"
      ],
      "useWhen": [
        "One or more independent choices may each be turned on or off.",
        "A form needs an explicit acknowledgement or optional inclusion choice."
      ],
      "avoidWhen": [
        "Exactly one option in a group may be selected; use CharcoalRadio.",
        "A setting takes effect immediately outside form submission; use CharcoalSwitch."
      ],
      "accessibility": [
        "Provide a visible label, or semanticLabel when the surrounding content already supplies the visible name.",
        "Checked, disabled, and invalid states are exposed through input semantics.",
        "When invalid is true, place an actionable correction beside the checkbox or its form group."
      ],
      "responsiveBehavior": [
        "The source-authored 20-pixel indicator remains fixed while a text label wraps within parent constraints.",
        "Let the surrounding form provide readable width and sufficient separation between stacked choices."
      ],
      "interactionStates": [
        "unchecked",
        "checked",
        "hovered",
        "focused",
        "pressed",
        "invalid",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns indicator, pointer, focus, checked, invalid, and disabled presentation.",
        "Reports the proposed inverse value; the caller owns controlled state, validation timing, persistence, and recovery."
      ],
      "tokenRoles": [
        "space.component10",
        "radius.s",
        "radius.oval",
        "containerPrimaryDefault",
        "borderDefault",
        "borderFocusLegacy",
        "borderNegative"
      ],
      "relatedComponents": [
        "CharcoalRadio",
        "CharcoalSwitch",
        "CharcoalMultiSelect"
      ],
      "apis": [
        {
          "name": "CharcoalCheckbox",
          "kind": "constructor",
          "signature": "CharcoalCheckbox({required this.value, required this.onChanged, this.autofocus = false, this.focusNode, this.invalid = false, this.label, this.rounded = false, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "value",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<bool>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "rounded",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "checkbox-controlled",
          "title": "Independent controlled choice",
          "description": "Keeps an optional form choice in parent-owned state alongside related selection controls.",
          "sourcePath": "example/lib/agent_examples/selection_controls_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _Audience { everyone, followers, private }\n\n/// Parent-owned checkbox, radio, and switch state with distinct responsibilities.\nfinal class AgentSelectionControlsExample extends StatefulWidget {\n  const AgentSelectionControlsExample({super.key});\n\n  @override\n  State<AgentSelectionControlsExample> createState() =>\n      _AgentSelectionControlsExampleState();\n}\n\nfinal class _AgentSelectionControlsExampleState\n    extends State<AgentSelectionControlsExample> {\n  _Audience _audience = _Audience.followers;\n  bool _saveDrafts = true;\n  bool _releaseNotifications = true;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Publishing preferences', style: theme.textStyles.headingS),\n        SizedBox(height: space.component30),\n        CharcoalCheckbox(\n          value: _saveDrafts,\n          onChanged: (value) => setState(() => _saveDrafts = value),\n          label: const Text('Save drafts automatically'),\n        ),\n        SizedBox(height: space.layout40),\n        Text('Audience', style: theme.textStyles.bodyBold),\n        SizedBox(height: space.component20),\n        Semantics(\n          container: true,\n          explicitChildNodes: true,\n          label: 'Audience options',\n          child: Column(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            children: <Widget>[\n              CharcoalRadio<_Audience>(\n                value: _Audience.everyone,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Everyone'),\n              ),\n              SizedBox(height: space.component30),\n              CharcoalRadio<_Audience>(\n                value: _Audience.followers,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Followers'),\n              ),\n              SizedBox(height: space.component30),\n              CharcoalRadio<_Audience>(\n                value: _Audience.private,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Only me'),\n              ),\n            ],\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalSwitch(\n          value: _releaseNotifications,\n          onChanged: (value) => setState(() => _releaseNotifications = value),\n          label: const Text('Release notifications'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalClickable",
      "category": "Actions",
      "summary": "Supplies platform-aware pointer, keyboard, focus, semantics, and state plumbing for an audited custom control.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/clickable.dart",
      "documentationLevel": "curated",
      "keywords": [
        "custom control",
        "focus",
        "interaction primitive",
        "keyboard activation",
        "pressed state",
        "whole surface action"
      ],
      "useWhen": [
        "Component and pattern discovery found no higher-level Charcoal control and one custom surface must act as a single action.",
        "A design-system maintainer is implementing a reusable Charcoal control that needs the shared interaction and semantics lifecycle."
      ],
      "avoidWhen": [
        "A Charcoal button, icon button, selection control, navigation item, tab, tag, pagination item, or carousel affordance already expresses the interaction.",
        "The surface contains multiple independent actions; keep those controls separate instead of nesting them under one clickable region.",
        "Only hover styling or layout is needed; use Flutter layout and pointer primitives without inventing an action role."
      ],
      "accessibility": [
        "Set semanticButton, semanticRole, checked, toggled, selected, expanded, and validationResult to describe the actual control rather than its visual shape.",
        "Provide semanticLabel when visible descendants do not form one clear action label, and never hide meaningful state only in decoration.",
        "Default keyboard activation follows ambient Flutter platform conventions; set keyboardActivationEnabled false only when an owning composite handles and tests the complete key map.",
        "Render an unmistakable focus state and a bounded pressed response without moving, resizing, or replacing the control."
      ],
      "responsiveBehavior": [
        "CharcoalClickable intentionally owns no geometry or color; the authored control must enforce a suitable semantic target and use role-appropriate tokens.",
        "Keep target bounds, child alignment, and text baselines stable through pointer down, cancellation, keyboard activation, focus, hover, selection, and disablement.",
        "Let labels wrap or truncate according to the authored component contract and verify supported text scaling and compact constraints."
      ],
      "interactionStates": [
        "idle",
        "hovered",
        "focused",
        "pointer pressed",
        "keyboard pressed",
        "selected",
        "checked",
        "toggled",
        "expanded",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns state dispatch, pointer cancellation, platform keyboard intents, a perceivable keyboard press pulse, focus visibility, cursor, and semantics actions.",
        "The builder owns all visual geometry and state styling; the caller owns controlled values, action progress, failure, recovery, and durable results."
      ],
      "tokenRoles": [],
      "relatedComponents": [
        "CharcoalButton",
        "CharcoalIconButton",
        "CharcoalNavigationItem",
        "CharcoalCheckbox",
        "CharcoalTabBar"
      ],
      "apis": [
        {
          "name": "CharcoalClickable",
          "kind": "constructor",
          "signature": "CharcoalClickable({required this.builder, required this.onPressed, this.autofocus = false, this.checked, this.expanded, this.focusNode, this.inMutuallyExclusiveGroup = false, this.keyboardActivationEnabled = true, this.onFocusChange, this.onKeyEvent, this.semanticButton = true, this.semanticHint, this.semanticLabel, this.semanticRole, this.semanticValue, this.selected = false, this.statesController, this.toggled, this.validationResult = SemanticsValidationResult.none, super.key})",
          "parameters": [
            {
              "name": "builder",
              "type": "CharcoalClickableBuilder",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "checked",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "expanded",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "inMutuallyExclusiveGroup",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "keyboardActivationEnabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "onFocusChange",
              "type": "ValueChanged<bool>?",
              "required": false,
              "named": true
            },
            {
              "name": "onKeyEvent",
              "type": "FocusOnKeyEventCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticButton",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "semanticHint",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticRole",
              "type": "SemanticsRole?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticValue",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "toggled",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "validationResult",
              "type": "SemanticsValidationResult",
              "required": false,
              "named": true,
              "defaultValue": "SemanticsValidationResult.none"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "clickable-whole-surface-action",
          "title": "Audited whole-surface action",
          "description": "Uses the interaction primitive only after higher-level controls cannot express a single custom project surface.",
          "sourcePath": "example/lib/agent_examples/clickable_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// An audited whole-surface action for a case with no higher-level component.\nfinal class AgentClickableSurfaceExample extends StatefulWidget {\n  const AgentClickableSurfaceExample({super.key});\n\n  @override\n  State<AgentClickableSurfaceExample> createState() =>\n      _AgentClickableSurfaceExampleState();\n}\n\nfinal class _AgentClickableSurfaceExampleState\n    extends State<AgentClickableSurfaceExample> {\n  String _status = 'No project opened';\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Whole-surface action', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Text(_status, style: theme.textStyles.captionMedium),\n        SizedBox(height: space.layout40),\n        CharcoalClickable(\n          onPressed: () => setState(() => _status = 'Moonlit Lake opened'),\n          semanticLabel: 'Open Moonlit Lake project',\n          builder: (context, states) {\n            final focused = states.contains(WidgetState.focused);\n            final hovered = states.contains(WidgetState.hovered);\n            final pressed = states.contains(WidgetState.pressed);\n            final background = pressed\n                ? theme.colors.containerSecondaryPressA\n                : hovered || focused\n                ? theme.colors.containerSecondaryHoverA\n                : theme.colors.backgroundDefault;\n            final border = focused\n                ? theme.colors.borderFocus1\n                : pressed\n                ? theme.colors.borderPress\n                : hovered\n                ? theme.colors.borderHover\n                : theme.colors.borderSecondary;\n            return AnimatedContainer(\n              curve: CharcoalMotion.standardCurve,\n              duration: CharcoalMotion.resolveDuration(\n                context,\n                CharcoalMotion.fast,\n              ),\n              constraints: BoxConstraints(\n                minHeight: theme.dimensions.space.targetL,\n              ),\n              padding: EdgeInsets.all(space.component30),\n              decoration: BoxDecoration(\n                border: Border.all(\n                  color: border,\n                  width: theme.dimensions.borderWidth.m,\n                ),\n                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n                color: background,\n              ),\n              child: Row(\n                children: <Widget>[\n                  CharcoalIcon(\n                    CharcoalIcons.image,\n                    color: theme.colors.iconDefault,\n                  ),\n                  SizedBox(width: space.component30),\n                  Expanded(\n                    child: Column(\n                      crossAxisAlignment: CrossAxisAlignment.start,\n                      mainAxisSize: MainAxisSize.min,\n                      children: <Widget>[\n                        Text('Moonlit Lake', style: theme.textStyles.bodyBold),\n                        SizedBox(height: space.component10),\n                        Text(\n                          'Illustration · updated today',\n                          style: theme.textStyles.captionSmall.copyWith(\n                            color: theme.colors.textSecondaryDefault,\n                          ),\n                        ),\n                      ],\n                    ),\n                  ),\n                  SizedBox(width: space.component20),\n                  CharcoalIcon(\n                    CharcoalIcons.chevronRight,\n                    color: theme.colors.iconTertiaryDefault,\n                    size: 16,\n                  ),\n                ],\n              ),\n            );\n          },\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalDialog",
      "category": "Overlays",
      "summary": "Presents a short, blocking decision in a centered dialog or adaptive bottom-sheet surface.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/modal.dart",
      "documentationLevel": "curated",
      "keywords": [
        "bottom sheet",
        "confirmation",
        "dialog",
        "modal",
        "overlay",
        "prompt"
      ],
      "useWhen": [
        "The user must confirm, choose, or acknowledge a short self-contained task before returning.",
        "The same content needs centered and bottom-sheet presentation styles."
      ],
      "avoidWhen": [
        "The message is transient and does not require focus; use CharcoalToast or CharcoalSnackBar.",
        "The task involves browsing content, repeated actions, text composition, or nested navigation; use a page or route.",
        "The task belongs to a bounded embedded surface without its own Navigator; add a local Navigator or keep the interaction inline."
      ],
      "accessibility": [
        "Use a concise title and a barrierLabel that describes dismissal.",
        "Do not make a destructive or mandatory decision barrier-dismissible."
      ],
      "responsiveBehavior": [
        "Use CharcoalModalStyle.bottomSheet for compact mobile presentation where appropriate.",
        "Size constrains readable content width; maxWidth can narrow a specific workflow.",
        "showCharcoalModal targets the root Navigator by default; set useRootNavigator to false only from a context under the intended nested Navigator."
      ],
      "interactionStates": [
        "presenting",
        "open",
        "dismissing",
        "dismissed"
      ],
      "feedbackResponsibilities": [
        "Owns modal focus containment, presentation, dismissal, and surface semantics.",
        "The caller owns task validation, progress, success, failure, and returned result."
      ],
      "tokenRoles": [
        "paragraphWidth.s",
        "paragraphWidth.l",
        "space.layout40",
        "space.layout100",
        "space.targetL"
      ],
      "relatedComponents": [
        "CharcoalToast",
        "CharcoalSnackBar"
      ],
      "apis": [
        {
          "name": "CharcoalDialog",
          "kind": "constructor",
          "signature": "CharcoalDialog({required this.child, this.actions = const <Widget>[], this.closeIcon, this.contentPadding = EdgeInsets.zero, this.maxWidth, this.onDismiss, this.showCloseButton = false, this.size = CharcoalDialogSize.medium, this.style = CharcoalModalStyle.center, this.title, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "actions",
              "type": "List<Widget>",
              "required": false,
              "named": true,
              "defaultValue": "const <Widget>[]"
            },
            {
              "name": "closeIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "contentPadding",
              "type": "EdgeInsetsGeometry",
              "required": false,
              "named": true,
              "defaultValue": "EdgeInsets.zero"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onDismiss",
              "type": "VoidCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "showCloseButton",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalDialogSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalDialogSize.medium"
            },
            {
              "name": "style",
              "type": "CharcoalModalStyle",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalModalStyle.center"
            },
            {
              "name": "title",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalDialog",
          "kind": "function",
          "signature": "Future<T?> showCharcoalDialog<T>({required BuildContext context, required WidgetBuilder builder, bool barrierDismissible = true, String barrierLabel = 'Dismiss dialog', Duration? duration, CharcoalModalStyle style = CharcoalModalStyle.center, bool useRootNavigator = true})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "builder",
              "type": "WidgetBuilder",
              "required": true,
              "named": true
            },
            {
              "name": "barrierDismissible",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "barrierLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Dismiss dialog'"
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "style",
              "type": "CharcoalModalStyle",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalModalStyle.center"
            },
            {
              "name": "useRootNavigator",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalModal",
          "kind": "function",
          "signature": "Future<T?> showCharcoalModal<T>({required BuildContext context, required Widget child, List<Widget> actions = const <Widget>[], bool barrierDismissible = true, Widget? closeIcon, Duration? duration, double? maxWidth, CharcoalDialogSize size = CharcoalDialogSize.medium, CharcoalModalStyle style = CharcoalModalStyle.center, String? title, bool useRootNavigator = true})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "actions",
              "type": "List<Widget>",
              "required": false,
              "named": true,
              "defaultValue": "const <Widget>[]"
            },
            {
              "name": "barrierDismissible",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "closeIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalDialogSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalDialogSize.medium"
            },
            {
              "name": "style",
              "type": "CharcoalModalStyle",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalModalStyle.center"
            },
            {
              "name": "title",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "useRootNavigator",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalDialogSize",
          "kind": "enum",
          "signature": "enum CharcoalDialogSize { small, medium, large }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium",
            "large"
          ]
        },
        {
          "name": "CharcoalModalStyle",
          "kind": "enum",
          "signature": "enum CharcoalModalStyle { center, bottomSheet }",
          "parameters": [],
          "enumValues": [
            "center",
            "bottomSheet"
          ]
        }
      ],
      "examples": [
        {
          "id": "dialog-launcher",
          "title": "Open an adaptive modal",
          "description": "Launches a dialog with Charcoal content and action widgets.",
          "sourcePath": "example/lib/agent_examples/modal_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Opens the same modal task as a dialog or bottom sheet based on available width.\nfinal class AgentModalExample extends StatelessWidget {\n  const AgentModalExample({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return CharcoalButton(\n      onPressed: () => _openModal(context),\n      variant: CharcoalButtonVariant.primary,\n      child: const Text('Review changes'),\n    );\n  }\n\n  Future<void> _openModal(BuildContext context) async {\n    final compact = MediaQuery.sizeOf(context).width < 600;\n    await showCharcoalModal<void>(\n      actions: <Widget>[\n        CharcoalButton(\n          onPressed: () => Navigator.of(context).pop(),\n          variant: CharcoalButtonVariant.primary,\n          child: const Text('Done'),\n        ),\n      ],\n      child: const CharcoalTypography(\n        child: Text(\n          'Your profile and visibility changes are ready to publish.',\n        ),\n      ),\n      context: context,\n      style: compact\n          ? CharcoalModalStyle.bottomSheet\n          : CharcoalModalStyle.center,\n      title: 'Review changes',\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalDropdown",
      "category": "Forms",
      "summary": "Selects one value from a controlled list using a Charcoal popup menu.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/dropdown.dart",
      "documentationLevel": "curated",
      "keywords": [
        "combobox",
        "dropdown",
        "menu",
        "option",
        "select"
      ],
      "useWhen": [
        "The user must choose one item from a fixed list that is too long for segmented control.",
        "Secondary option descriptions help distinguish similar choices."
      ],
      "avoidWhen": [
        "Two to four short options benefit from direct visibility; use CharcoalSegmentedControl.",
        "Multiple values may be selected; use CharcoalMultiSelect."
      ],
      "accessibility": [
        "Supply a visible label for form use and keep option labels unique and descriptive.",
        "Disabled options stay discoverable but cannot be selected.",
        "Pair invalid with assistiveText so the trigger announces the invalid result and correction together.",
        "Set required only when a selection is mandatory; the same state is exposed visually and semantically.",
        "Provide localized requiredText when the visible required marker includes copy."
      ],
      "responsiveBehavior": [
        "The popup matches the trigger width and chooses the available vertical direction.",
        "Let the parent constrain trigger width on small and large screens."
      ],
      "interactionStates": [
        "closed",
        "open",
        "focused",
        "selected",
        "invalid",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns popup visibility, option interaction, focus, and disabled option presentation.",
        "The caller owns selected-value persistence and downstream results or validation."
      ],
      "tokenRoles": [
        "space.component10",
        "space.layout30",
        "radius.s",
        "containerSecondaryDefaultA"
      ],
      "relatedComponents": [
        "CharcoalMultiSelect",
        "CharcoalSegmentedControl"
      ],
      "apis": [
        {
          "name": "CharcoalDropdown",
          "kind": "constructor",
          "signature": "CharcoalDropdown({required this.options, required this.value, required this.onChanged, this.assistiveText, this.autofocus = false, this.disabled = false, this.focusNode, this.invalid = false, this.label = '', this.placeholder, this.required = false, this.requiredText = '*Required', this.showLabel = false, this.subLabel, super.key})",
          "parameters": [
            {
              "name": "options",
              "type": "List<CharcoalDropdownOption<T>>",
              "required": true,
              "named": true
            },
            {
              "name": "value",
              "type": "T?",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "assistiveText",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "disabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "placeholder",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "showLabel",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalDropdownOption",
          "kind": "supportingType",
          "signature": "CharcoalDropdownOption({required this.value, required this.label, this.enabled = true, this.secondary})",
          "parameters": [
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "enabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "secondary",
              "type": "String?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "dropdown-controlled",
          "title": "Controlled dropdown",
          "description": "A labeled single-selection field whose state is owned by its parent.",
          "sourcePath": "example/lib/agent_examples/dropdown_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _Visibility { everyone, followers, private }\n\n/// A parent-owned single selection with descriptive options.\nfinal class AgentDropdownExample extends StatefulWidget {\n  const AgentDropdownExample({super.key});\n\n  @override\n  State<AgentDropdownExample> createState() => _AgentDropdownExampleState();\n}\n\nfinal class _AgentDropdownExampleState extends State<AgentDropdownExample> {\n  _Visibility? _value = _Visibility.everyone;\n\n  static const _options = <CharcoalDropdownOption<_Visibility>>[\n    CharcoalDropdownOption(\n      value: _Visibility.everyone,\n      label: 'Everyone',\n      secondary: 'Visible to anyone',\n    ),\n    CharcoalDropdownOption(\n      value: _Visibility.followers,\n      label: 'Followers',\n      secondary: 'Visible to your followers',\n    ),\n    CharcoalDropdownOption(\n      value: _Visibility.private,\n      label: 'Only me',\n      secondary: 'Keep this private',\n    ),\n  ];\n\n  @override\n  Widget build(BuildContext context) {\n    return CharcoalDropdown<_Visibility>(\n      label: 'Visibility',\n      onChanged: (value) => setState(() => _value = value),\n      options: _options,\n      showLabel: true,\n      value: _value,\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalFieldLabel",
      "category": "Forms",
      "summary": "Composes visible field naming, required copy, and trailing metadata without owning input semantics.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/field_label.dart",
      "documentationLevel": "curated",
      "keywords": [
        "character count",
        "field label",
        "form metadata",
        "required marker",
        "sub label",
        "visible label"
      ],
      "useWhen": [
        "A custom form composition needs a visible label plus localized required copy or trailing metadata such as a character count.",
        "The associated control already exposes its own semantic label, required state, validation, and value."
      ],
      "avoidWhen": [
        "CharcoalTextField or CharcoalTextArea can render the same label through showLabel; prefer that owned composition.",
        "A semantic association with an input is missing; visible text does not label a custom control by itself.",
        "The copy is validation, correction, or general advice; use the field assistiveText API or CharcoalHintText as appropriate.",
        "The content is a section heading rather than form metadata; use CharcoalTypography."
      ],
      "accessibility": [
        "Pass the same label to the associated input semantics; this component deliberately owns only visible hierarchy.",
        "When required is true, localize requiredText and also expose required on the associated form control.",
        "Keep subLabel supplementary because it may truncate or move to a following line under constrained layouts.",
        "Do not repeat validation in requiredText or subLabel; keep one actionable correction beside the affected field."
      ],
      "responsiveBehavior": [
        "With sufficient width, the label and required copy stay leading while subLabel remains directionally trailing.",
        "When available width becomes insufficient relative to text scaling, required copy and subLabel move onto additional lines instead of overflowing.",
        "Wide layouts retain the compact source row even with enlarged text when the content still fits.",
        "Logical reading order remains label, required copy, then supplementary metadata in LTR and RTL."
      ],
      "interactionStates": [
        "label only",
        "required",
        "with sub-label",
        "compact",
        "scaled text",
        "RTL"
      ],
      "feedbackResponsibilities": [
        "Owns visible label typography, required copy, supplementary metadata, truncation, and responsive line arrangement.",
        "The associated control owns semantic labeling, required and invalid state, focus, value, correction, and submission feedback."
      ],
      "tokenRoles": [
        "space.component10",
        "space.component20",
        "textDefaultText1",
        "textSecondaryDefault",
        "textTertiaryDefault"
      ],
      "relatedComponents": [
        "CharcoalTextField",
        "CharcoalTextArea",
        "CharcoalHintText",
        "CharcoalTypography"
      ],
      "apis": [
        {
          "name": "CharcoalFieldLabel",
          "kind": "constructor",
          "signature": "CharcoalFieldLabel({required this.label, this.required = false, this.requiredText = '*Required', this.subLabel, this.weight = CharcoalTypographyWeight.bold, super.key})",
          "parameters": [
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "weight",
              "type": "CharcoalTypographyWeight",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographyWeight.bold"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "field-label-visible-form-metadata",
          "title": "Visible field metadata with semantic input ownership",
          "description": "Keeps required and trailing metadata visible while the associated input owns required semantics and value.",
          "sourcePath": "example/lib/agent_examples/form_guidance_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Visible field metadata and optional guidance with one controlled outcome.\nfinal class AgentFormGuidanceExample extends StatefulWidget {\n  const AgentFormGuidanceExample({super.key});\n\n  @override\n  State<AgentFormGuidanceExample> createState() =>\n      _AgentFormGuidanceExampleState();\n}\n\nfinal class _AgentFormGuidanceExampleState\n    extends State<AgentFormGuidanceExample> {\n  final TextEditingController _controller = TextEditingController();\n  bool _showGuidance = true;\n  String? _status;\n\n  @override\n  void dispose() {\n    _controller.dispose();\n    super.dispose();\n  }\n\n  void _applyExample() {\n    setState(() {\n      _controller.text = 'https://example.com/portfolio';\n      _showGuidance = false;\n      _status = 'Example portfolio URL applied.';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Public profile', style: theme.textStyles.headingS),\n        SizedBox(height: space.layout40),\n        const CharcoalFieldLabel(\n          label: 'Portfolio URL',\n          required: true,\n          requiredText: 'Required',\n          subLabel: Text('Public'),\n        ),\n        SizedBox(height: space.component20),\n        CharcoalTextField(\n          controller: _controller,\n          label: 'Portfolio URL',\n          placeholder: 'https://example.com/your-name',\n          required: true,\n        ),\n        SizedBox(height: space.component20),\n        CharcoalHintText(\n          action: CharcoalButton(\n            onPressed: _applyExample,\n            size: CharcoalButtonSize.small,\n            variant: CharcoalButtonVariant.primary,\n            child: const Text('Use example'),\n          ),\n          alignment: Alignment.centerLeft,\n          maxWidth: double.infinity,\n          subtitle: const Text('You can replace it before publishing.'),\n          visible: _showGuidance,\n          child: const Text('Add a complete URL including https://.'),\n        ),\n        if (_status case final status?) ...<Widget>[\n          SizedBox(height: space.component20),\n          Semantics(\n            liveRegion: true,\n            child: Text(\n              status,\n              style: theme.textStyles.captionMedium.copyWith(\n                color: theme.colors.textSecondaryDefault,\n              ),\n            ),\n          ),\n        ],\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalHintText",
      "category": "Feedback",
      "summary": "Keeps optional page or section guidance visible with an optional, clearly named action.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/hint_text.dart",
      "documentationLevel": "curated",
      "keywords": [
        "advisory message",
        "contextual guidance",
        "help text",
        "hint",
        "page tip",
        "section guidance"
      ],
      "useWhen": [
        "A page or section benefits from brief, persistent advice that remains useful before and after nearby interaction.",
        "The advice may include one small action and the caller owns whether the complete hint remains visible."
      ],
      "avoidWhen": [
        "The message reports invalid input or explains a correction; use the field assistiveText API so validation stays associated with the input.",
        "The feedback is a transient success or failure result; use CharcoalToast or CharcoalSnackBar and keep durable results in the page.",
        "The content needs multiple actions, disclosure state, or anchored interactive detail; use CharcoalBalloon or a regular page section.",
        "Only a control label is missing; label the control directly instead of adding surrounding hint copy."
      ],
      "accessibility": [
        "Keep the primary message meaningful without the decorative information icon and give an optional action explicit visible text.",
        "The message remains normal document content rather than an automatic live region; announce only an action result that truly changed.",
        "When visible is false, message, subtitle, icon, and action all leave layout and semantics together.",
        "Do not encode error, warning, or success meaning only through a custom icon because HintText has no validation role."
      ],
      "responsiveBehavior": [
        "Without an action the surface remains intrinsic-width unless maxWidth is infinity; the parent controls page-level placement.",
        "An action remains inline when scaled copy has sufficient room and moves below only when available width becomes insufficient.",
        "Message and icon remain directionally leading while the optional action stays trailing in LTR and RTL.",
        "Copy and subtitle wrap with ambient text scaling; place unusually long guidance in normal page content instead."
      ],
      "interactionStates": [
        "visible",
        "hidden",
        "message only",
        "with subtitle",
        "with action",
        "compact stacked action",
        "scaled text",
        "RTL"
      ],
      "feedbackResponsibilities": [
        "Owns the advisory surface, authored information icon, copy layout, optional action placement, visibility removal, and responsive wrapping.",
        "The caller owns visible state, action outcome, live or durable result feedback, validation, persistence, and recovery."
      ],
      "tokenRoles": [
        "space.component10",
        "space.component25",
        "space.component30",
        "radius.m",
        "containerSecondaryDefault",
        "textDefault",
        "iconDefault"
      ],
      "relatedComponents": [
        "CharcoalFieldLabel",
        "CharcoalTextField",
        "CharcoalTooltip",
        "CharcoalToast"
      ],
      "apis": [
        {
          "name": "CharcoalHintText",
          "kind": "constructor",
          "signature": "CharcoalHintText({required this.child, this.action, this.alignment = Alignment.center, this.icon, this.maxWidth, this.subtitle, this.visible = true, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "alignment",
              "type": "Alignment",
              "required": false,
              "named": true,
              "defaultValue": "Alignment.center"
            },
            {
              "name": "icon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "subtitle",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "visible",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "hint-text-controlled-advice",
          "title": "Optional advisory guidance with one outcome",
          "description": "Keeps advice separate from validation and removes the complete hint after its controlled action succeeds.",
          "sourcePath": "example/lib/agent_examples/form_guidance_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Visible field metadata and optional guidance with one controlled outcome.\nfinal class AgentFormGuidanceExample extends StatefulWidget {\n  const AgentFormGuidanceExample({super.key});\n\n  @override\n  State<AgentFormGuidanceExample> createState() =>\n      _AgentFormGuidanceExampleState();\n}\n\nfinal class _AgentFormGuidanceExampleState\n    extends State<AgentFormGuidanceExample> {\n  final TextEditingController _controller = TextEditingController();\n  bool _showGuidance = true;\n  String? _status;\n\n  @override\n  void dispose() {\n    _controller.dispose();\n    super.dispose();\n  }\n\n  void _applyExample() {\n    setState(() {\n      _controller.text = 'https://example.com/portfolio';\n      _showGuidance = false;\n      _status = 'Example portfolio URL applied.';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Public profile', style: theme.textStyles.headingS),\n        SizedBox(height: space.layout40),\n        const CharcoalFieldLabel(\n          label: 'Portfolio URL',\n          required: true,\n          requiredText: 'Required',\n          subLabel: Text('Public'),\n        ),\n        SizedBox(height: space.component20),\n        CharcoalTextField(\n          controller: _controller,\n          label: 'Portfolio URL',\n          placeholder: 'https://example.com/your-name',\n          required: true,\n        ),\n        SizedBox(height: space.component20),\n        CharcoalHintText(\n          action: CharcoalButton(\n            onPressed: _applyExample,\n            size: CharcoalButtonSize.small,\n            variant: CharcoalButtonVariant.primary,\n            child: const Text('Use example'),\n          ),\n          alignment: Alignment.centerLeft,\n          maxWidth: double.infinity,\n          subtitle: const Text('You can replace it before publishing.'),\n          visible: _showGuidance,\n          child: const Text('Add a complete URL including https://.'),\n        ),\n        if (_status case final status?) ...<Widget>[\n          SizedBox(height: space.component20),\n          Semantics(\n            liveRegion: true,\n            child: Text(\n              status,\n              style: theme.textStyles.captionMedium.copyWith(\n                color: theme.colors.textSecondaryDefault,\n              ),\n            ),\n          ),\n        ],\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalIconButton",
      "category": "Actions",
      "summary": "Runs a compact icon-only action or controlled toggle with explicit accessible naming.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/icon_button.dart",
      "documentationLevel": "curated",
      "keywords": [
        "icon action",
        "icon button",
        "toolbar action",
        "toggle action"
      ],
      "useWhen": [
        "A familiar icon represents a compact action in a navigation bar, toolbar, card, or overlay.",
        "An icon-only toggle such as save, like, visibility, or mute has one parent-owned selected value."
      ],
      "avoidWhen": [
        "The icon is ambiguous or the action is primary; use a labeled CharcoalButton.",
        "The action can be expressed clearly as low-emphasis text; use CharcoalLinkButton."
      ],
      "accessibility": [
        "Provide semanticLabel for the action unless the icon supplies an equally clear semantic name.",
        "Update semanticLabel when a toggle changes so it continues to describe the next action, such as Save item and Remove saved item.",
        "Leave selected null for a regular action; pass false or true for a controlled toggle so both states are explicit.",
        "A null onPressed value exposes the disabled state and removes pointer and keyboard activation."
      ],
      "responsiveBehavior": [
        "Use medium for standalone mobile actions; smaller source-authored sizes are dense secondary affordances and require audited target separation.",
        "The icon stays centered in fixed 20, 32, or 40 logical-pixel circular geometry.",
        "Use the overlay variant only when the control sits on imagery or another authored on-image surface."
      ],
      "interactionStates": [
        "idle",
        "hovered",
        "focused",
        "pressed",
        "selected",
        "unselected",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns pointer, keyboard, focus, pressed, selected, disabled, normal-surface, and overlay-surface presentation.",
        "Reports activation without mutating the toggle value; the caller owns atomic state, action progress, failure, recovery, and durable results."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.targetM",
        "radius.oval",
        "containerHoverA",
        "containerPressA",
        "containerOnImgDefault",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalButton",
        "CharcoalLinkButton",
        "CharcoalTooltip",
        "CharcoalNavigationBar"
      ],
      "apis": [
        {
          "name": "CharcoalIconButton",
          "kind": "constructor",
          "signature": "CharcoalIconButton({required this.icon, required this.onPressed, this.autofocus = false, this.focusNode, this.semanticLabel, this.selected, this.size = CharcoalIconButtonSize.medium, this.statesController, this.variant = CharcoalIconButtonVariant.normal, super.key})",
          "parameters": [
            {
              "name": "icon",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalIconButtonSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalIconButtonSize.medium"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalIconButtonVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalIconButtonVariant.normal"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalIconButtonVariant",
          "kind": "enum",
          "signature": "enum CharcoalIconButtonVariant { normal, overlay }",
          "parameters": [],
          "enumValues": [
            "normal",
            "overlay"
          ]
        },
        {
          "name": "CharcoalIconButtonSize",
          "kind": "enum",
          "signature": "enum CharcoalIconButtonSize { extraSmall, small, medium }",
          "parameters": [],
          "enumValues": [
            "extraSmall",
            "small",
            "medium"
          ]
        }
      ],
      "examples": [
        {
          "id": "icon-button-actions",
          "title": "Named icon actions and toggle",
          "description": "Separates a one-shot icon action from a parent-owned save toggle with action-oriented labels.",
          "sourcePath": "example/lib/agent_examples/action_controls_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Named one-shot actions, a controlled icon toggle, and a text-only action.\nfinal class AgentActionControlsExample extends StatefulWidget {\n  const AgentActionControlsExample({super.key});\n\n  @override\n  State<AgentActionControlsExample> createState() =>\n      _AgentActionControlsExampleState();\n}\n\nfinal class _AgentActionControlsExampleState\n    extends State<AgentActionControlsExample> {\n  bool _saved = false;\n  String _status = 'No action yet';\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Item actions', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Text(_status, style: theme.textStyles.captionMedium),\n        SizedBox(height: space.layout40),\n        Wrap(\n          crossAxisAlignment: WrapCrossAlignment.center,\n          spacing: space.component30,\n          runSpacing: space.component30,\n          children: <Widget>[\n            CharcoalIconButton(\n              icon: const CharcoalIcon(CharcoalIcons.bookmark),\n              onPressed: () {\n                setState(() {\n                  _saved = !_saved;\n                  _status = _saved ? 'Item saved' : 'Item removed from saved';\n                });\n              },\n              selected: _saved,\n              semanticLabel: _saved ? 'Remove saved item' : 'Save item',\n            ),\n            CharcoalIconButton(\n              icon: const CharcoalIcon(CharcoalIcons.search),\n              onPressed: () => setState(() => _status = 'Search opened'),\n              semanticLabel: 'Search related items',\n            ),\n            const CharcoalIconButton(\n              icon: CharcoalIcon(CharcoalIcons.dotsHorizontal),\n              onPressed: null,\n              semanticLabel: 'More actions unavailable',\n            ),\n          ],\n        ),\n        SizedBox(height: space.layout40),\n        Align(\n          alignment: AlignmentDirectional.centerStart,\n          child: CharcoalLinkButton(\n            onPressed: () => setState(() => _status = 'Filters cleared'),\n            child: const Text('Clear filters'),\n          ),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalLinkButton",
      "category": "Actions",
      "summary": "Runs a low-emphasis text action with intrinsic width and a stable interaction target.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/button.dart",
      "documentationLevel": "curated",
      "keywords": [
        "clear action",
        "link button",
        "low emphasis action",
        "text action"
      ],
      "useWhen": [
        "A secondary action such as Clear, Skip, Cancel, or Learn more should remain text-only.",
        "A compact action needs button behavior without a filled background."
      ],
      "avoidWhen": [
        "The text opens a web URL or document link; use a real link semantic and platform navigation behavior.",
        "The action is primary, destructive, or needs an icon; use CharcoalButton."
      ],
      "accessibility": [
        "Use concise visible action text; semanticLabel is only needed when that text lacks necessary context.",
        "The component intentionally exposes button rather than link semantics because onPressed runs an application action.",
        "A null onPressed value exposes disabled state and removes pointer and keyboard activation."
      ],
      "responsiveBehavior": [
        "The component stays intrinsic-width in loose layouts and honors a tight width supplied by its parent.",
        "Its source-authored 40 logical-pixel minimum height remains stable while text scales vertically when needed."
      ],
      "interactionStates": [
        "idle",
        "hovered",
        "focused",
        "pressed",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns text color, focus, pressed, disabled, keyboard, and pointer presentation.",
        "The caller owns progress, success, failure, navigation effects, and durable action results."
      ],
      "tokenRoles": [
        "space.targetM",
        "space.component30",
        "radius.s",
        "textDefault",
        "textHover",
        "textTertiaryDefault",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalButton",
        "CharcoalIconButton"
      ],
      "apis": [
        {
          "name": "CharcoalLinkButton",
          "kind": "constructor",
          "signature": "CharcoalLinkButton({required this.child, required this.onPressed, this.autofocus = false, this.focusNode, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "link-button-action",
          "title": "Low-emphasis text action",
          "description": "Runs a clear action without turning application behavior into hyperlink semantics.",
          "sourcePath": "example/lib/agent_examples/action_controls_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Named one-shot actions, a controlled icon toggle, and a text-only action.\nfinal class AgentActionControlsExample extends StatefulWidget {\n  const AgentActionControlsExample({super.key});\n\n  @override\n  State<AgentActionControlsExample> createState() =>\n      _AgentActionControlsExampleState();\n}\n\nfinal class _AgentActionControlsExampleState\n    extends State<AgentActionControlsExample> {\n  bool _saved = false;\n  String _status = 'No action yet';\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Item actions', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Text(_status, style: theme.textStyles.captionMedium),\n        SizedBox(height: space.layout40),\n        Wrap(\n          crossAxisAlignment: WrapCrossAlignment.center,\n          spacing: space.component30,\n          runSpacing: space.component30,\n          children: <Widget>[\n            CharcoalIconButton(\n              icon: const CharcoalIcon(CharcoalIcons.bookmark),\n              onPressed: () {\n                setState(() {\n                  _saved = !_saved;\n                  _status = _saved ? 'Item saved' : 'Item removed from saved';\n                });\n              },\n              selected: _saved,\n              semanticLabel: _saved ? 'Remove saved item' : 'Save item',\n            ),\n            CharcoalIconButton(\n              icon: const CharcoalIcon(CharcoalIcons.search),\n              onPressed: () => setState(() => _status = 'Search opened'),\n              semanticLabel: 'Search related items',\n            ),\n            const CharcoalIconButton(\n              icon: CharcoalIcon(CharcoalIcons.dotsHorizontal),\n              onPressed: null,\n              semanticLabel: 'More actions unavailable',\n            ),\n          ],\n        ),\n        SizedBox(height: space.layout40),\n        Align(\n          alignment: AlignmentDirectional.centerStart,\n          child: CharcoalLinkButton(\n            onPressed: () => setState(() => _status = 'Filters cleared'),\n            child: const Text('Clear filters'),\n          ),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalLoadingSpinner",
      "category": "Utility",
      "summary": "Announces and renders an indeterminate wait with Charcoal source geometry and motion.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/loading_spinner.dart",
      "documentationLevel": "curated",
      "keywords": [
        "busy indicator",
        "indeterminate progress",
        "loading",
        "loading spinner",
        "progress feedback",
        "wait state"
      ],
      "useWhen": [
        "A bounded operation is in progress but cannot report meaningful completion percentage.",
        "The caller already owns placement, interaction blocking, lifecycle, and the durable outcome."
      ],
      "avoidWhen": [
        "Progress can be measured; use a determinate progress treatment that reports its value.",
        "The wait must block an existing subtree; use CharcoalSpinnerOverlay so pointer, focus, and semantics are coordinated.",
        "The operation may take indefinitely without explanation, cancellation, timeout, error, or recovery in the surrounding experience."
      ],
      "accessibility": [
        "Pass a localized, non-empty semanticLabel that names the pending operation when Loading is not sufficient context.",
        "The component exposes one live-region loading-spinner node; its expanding circle is excluded as decorative presentation.",
        "Do not infer completion from once: the caller must remove the spinner and expose the actual result when work finishes."
      ],
      "responsiveBehavior": [
        "The default circle is 48 logical pixels with 16 logical pixels of padding; valid size and padding overrides remain caller-constrained.",
        "The indicator has no text geometry and does not grow with text scaling; the surrounding composition owns compact placement.",
        "When animations are disabled, it becomes a stable midpoint frame instead of repeating motion.",
        "Transparent removes the surface fill but retains the source shadow contract."
      ],
      "interactionStates": [
        "repeating",
        "once",
        "reduced motion",
        "default surface",
        "transparent surface",
        "custom size"
      ],
      "feedbackResponsibilities": [
        "Owns the indeterminate expansion and fade, loading-spinner semantics, source surface, and reduced-motion frame.",
        "The caller owns operation state, blocking policy, cancellation, timeout, error, retry, completion, and durable result."
      ],
      "tokenRoles": [
        "space.targetL",
        "space.component30",
        "radius.m",
        "backgroundDefault",
        "iconTertiaryDefault"
      ],
      "relatedComponents": [
        "CharcoalSpinnerOverlay",
        "CharcoalSwitchingButton",
        "CharcoalButton"
      ],
      "apis": [
        {
          "name": "CharcoalLoadingSpinner",
          "kind": "constructor",
          "signature": "CharcoalLoadingSpinner({this.color, this.once = false, this.padding, this.semanticLabel = 'Loading', this.size, this.transparent = false, super.key})",
          "parameters": [
            {
              "name": "color",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "once",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "padding",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Loading'"
            },
            {
              "name": "size",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "transparent",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "loading-spinner-publish-state",
          "title": "Named indeterminate publish progress",
          "description": "Announces a bounded wait while the owning example records completion as durable page state.",
          "sourcePath": "example/lib/agent_examples/async_action_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A bounded asynchronous action with blocking progress and a durable result.\nfinal class AgentAsyncActionExample extends StatefulWidget {\n  const AgentAsyncActionExample({super.key});\n\n  @override\n  State<AgentAsyncActionExample> createState() =>\n      _AgentAsyncActionExampleState();\n}\n\nfinal class _AgentAsyncActionExampleState\n    extends State<AgentAsyncActionExample> {\n  bool _published = false;\n  bool _saving = false;\n  bool _pendingPublished = false;\n  String _status = 'This draft is private.';\n\n  Future<void> _setPublished(bool published) async {\n    if (_saving || _published == published) return;\n    setState(() {\n      _pendingPublished = published;\n      _saving = true;\n    });\n    await Future<void>.delayed(const Duration(milliseconds: 300));\n    if (!mounted) return;\n    setState(() {\n      _published = published;\n      _saving = false;\n      _status = published ? 'Draft published.' : 'Draft returned to private.';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Publishing', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: true,\n          child: Text(\n            _status,\n            style: theme.textStyles.captionMedium.copyWith(\n              color: theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalSpinnerOverlay(\n          semanticLabel: _pendingPublished\n              ? 'Publishing draft'\n              : 'Returning draft to private',\n          visible: _saving,\n          child: DecoratedBox(\n            decoration: BoxDecoration(\n              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n              color: theme.colors.containerSecondaryDefault,\n            ),\n            child: Padding(\n              padding: EdgeInsets.all(space.layout40),\n              child: Column(\n                mainAxisSize: MainAxisSize.min,\n                children: <Widget>[\n                  Text(\n                    _published ? 'Published' : 'Private draft',\n                    style: theme.textStyles.bodyBold,\n                  ),\n                  SizedBox(height: space.component30),\n                  CharcoalSwitchingButton(\n                    isOn: _published,\n                    offButton: CharcoalButton(\n                      onPressed: () => _setPublished(true),\n                      semanticLabel: 'Publish draft',\n                      variant: CharcoalButtonVariant.primary,\n                      child: const Text('Publish'),\n                    ),\n                    onButton: CharcoalButton(\n                      onPressed: () => _setPublished(false),\n                      semanticLabel: 'Return published item to draft',\n                      child: const Text('Unpublish'),\n                    ),\n                  ),\n                ],\n              ),\n            ),\n          ),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalMultiSelect",
      "category": "Forms",
      "summary": "Toggles one option in a visibly named, parent-controlled multi-selection group.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/multi_select.dart",
      "documentationLevel": "curated",
      "keywords": [
        "batch selection",
        "collection selection",
        "media selection",
        "multiple choice",
        "multi select"
      ],
      "useWhen": [
        "Several related options may be selected independently and the caller owns one selected value set.",
        "A collection or media surface needs Charcoal's circular multi-selection indicator, including the overlay treatment over artwork."
      ],
      "avoidWhen": [
        "One independent boolean form choice or acknowledgement is needed; use CharcoalCheckbox.",
        "Exactly one value may be selected; use CharcoalRadio, CharcoalSegmentedControl, or CharcoalDropdown.",
        "A collapsed searchable multi-value picker is required; this option component does not own a popup, search, chips, or select-all behavior."
      ],
      "accessibility": [
        "Give every option a visible label, or semanticLabel when an artwork overlay already provides the visible context.",
        "Place related options in one visibly and semantically named group; keep each option as an explicit semantic child.",
        "Checked, disabled, and invalid states are exposed through input semantics, and Space follows the ambient Flutter activation path.",
        "When the group is invalid, pass invalid to its options and keep one actionable group-level correction visible as a live result."
      ],
      "responsiveBehavior": [
        "The source-authored 20-pixel indicator remains fixed while a text label wraps within parent constraints.",
        "Stack options when labels or text scaling no longer fit a compact horizontal composition.",
        "Use overlay only over media, and do not clip the option row because its HUD, focus, and invalid rings paint outside the indicator."
      ],
      "interactionStates": [
        "unselected",
        "selected",
        "hovered",
        "focused",
        "pressed",
        "invalid",
        "disabled",
        "media overlay"
      ],
      "feedbackResponsibilities": [
        "Owns one option's pointer, keyboard, focus, checked, invalid, disabled, and overlay presentation.",
        "Reports the proposed inverse value; the caller owns the selected set, group label, validation timing, persistence, and durable result."
      ],
      "tokenRoles": [
        "space.component10",
        "radius.oval",
        "containerPrimaryDefault",
        "containerNeutralDefault",
        "containerOnImgDefault",
        "borderHud",
        "borderFocusLegacy",
        "borderNegative",
        "iconOnPrimaryDefault"
      ],
      "relatedComponents": [
        "CharcoalCheckbox",
        "CharcoalRadio",
        "CharcoalDropdown",
        "CharcoalFieldLabel"
      ],
      "apis": [
        {
          "name": "CharcoalMultiSelect",
          "kind": "constructor",
          "signature": "CharcoalMultiSelect({required this.selected, required this.onChanged, this.autofocus = false, this.focusNode, this.invalid = false, this.label, this.semanticLabel, this.statesController, this.variant = CharcoalMultiSelectVariant.normal, super.key})",
          "parameters": [
            {
              "name": "selected",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<bool>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalMultiSelectVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalMultiSelectVariant.normal"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalMultiSelectVariant",
          "kind": "enum",
          "signature": "enum CharcoalMultiSelectVariant { normal, overlay }",
          "parameters": [],
          "enumValues": [
            "normal",
            "overlay"
          ]
        }
      ],
      "examples": [
        {
          "id": "multi-select-controlled-group",
          "title": "Named controlled multi-selection group",
          "description": "Owns one selected set, keeps every option explicit, and exposes actionable group validation.",
          "sourcePath": "example/lib/agent_examples/multi_select_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _ExportContent { originalFiles, sourceMetadata, previewImages }\n\n/// A named, validated multi-selection group with one parent-owned value set.\nfinal class AgentMultiSelectExample extends StatefulWidget {\n  const AgentMultiSelectExample({super.key});\n\n  @override\n  State<AgentMultiSelectExample> createState() =>\n      _AgentMultiSelectExampleState();\n}\n\nfinal class _AgentMultiSelectExampleState\n    extends State<AgentMultiSelectExample> {\n  static const _options = <({String label, _ExportContent value})>[\n    (label: 'Original files', value: _ExportContent.originalFiles),\n    (label: 'Source metadata', value: _ExportContent.sourceMetadata),\n    (label: 'Preview images', value: _ExportContent.previewImages),\n  ];\n\n  Set<_ExportContent> _selected = <_ExportContent>{\n    _ExportContent.originalFiles,\n  };\n  bool _reviewed = false;\n  String? _result;\n\n  bool get _invalid => _reviewed && _selected.isEmpty;\n\n  String get _selectionSummary {\n    final count = _selected.length;\n    return '$count content ${count == 1 ? 'type' : 'types'} selected.';\n  }\n\n  void _setSelected(_ExportContent value, {required bool selected}) {\n    final next = Set<_ExportContent>.of(_selected);\n    selected ? next.add(value) : next.remove(value);\n    setState(() {\n      _selected = next;\n      _reviewed = false;\n      _result = null;\n    });\n  }\n\n  void _prepareExport() {\n    setState(() {\n      _reviewed = true;\n      _result = _selected.isEmpty\n          ? null\n          : 'Export prepared with ${_selected.length} content '\n                '${_selected.length == 1 ? 'type' : 'types'}.';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Prepare download', style: theme.textStyles.headingS),\n        SizedBox(height: space.layout40),\n        const CharcoalFieldLabel(\n          label: 'Export contents',\n          required: true,\n          requiredText: 'Required',\n        ),\n        SizedBox(height: space.component20),\n        Semantics(\n          container: true,\n          explicitChildNodes: true,\n          label: 'Export content options',\n          child: Column(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            children: <Widget>[\n              for (var index = 0; index < _options.length; index++) ...<Widget>[\n                CharcoalMultiSelect(\n                  invalid: _invalid,\n                  label: Text(_options[index].label),\n                  onChanged: (selected) =>\n                      _setSelected(_options[index].value, selected: selected),\n                  selected: _selected.contains(_options[index].value),\n                ),\n                if (index != _options.length - 1)\n                  SizedBox(height: space.component30),\n              ],\n            ],\n          ),\n        ),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: _invalid || _result != null,\n          child: Text(\n            _invalid\n                ? 'Select at least one content type.'\n                : _result ?? _selectionSummary,\n            style: theme.textStyles.captionMedium.copyWith(\n              color: _invalid\n                  ? theme.colors.textNegativeDefault\n                  : theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalButton(\n          fullWidth: true,\n          onPressed: _prepareExport,\n          variant: CharcoalButtonVariant.primary,\n          child: const Text('Prepare export'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalNavigationBar",
      "category": "Navigation",
      "summary": "Provides page-level title context with balanced leading and trailing navigation slots.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/navigation_bar.dart",
      "documentationLevel": "curated",
      "keywords": [
        "app bar",
        "back navigation",
        "header",
        "navigation bar",
        "toolbar"
      ],
      "useWhen": [
        "A page needs a stable title plus back, close, or contextual actions.",
        "A hierarchical mobile flow needs its current destination to remain visible."
      ],
      "avoidWhen": [
        "The control switches between top-level destinations; use a tab bar or navigation items.",
        "The content only needs a section heading inside the page body."
      ],
      "accessibility": [
        "Keep the title concise; it is exposed as a semantic header.",
        "Give icon-only leading and trailing controls explicit semantic labels."
      ],
      "responsiveBehavior": [
        "The title remains geometrically centered while edge slots contract on narrow widths.",
        "Keep edge actions compact and place system safe-area padding outside the component."
      ],
      "interactionStates": [
        "page context",
        "leading action",
        "trailing action"
      ],
      "feedbackResponsibilities": [
        "Owns title geometry and layout slots but not navigation state.",
        "The caller owns back, close, destination, and contextual-action outcomes."
      ],
      "tokenRoles": [
        "space.targetL",
        "space.component30",
        "borderSecondary",
        "backgroundDefault"
      ],
      "relatedComponents": [
        "CharcoalIconButton",
        "CharcoalNavigationItem"
      ],
      "apis": [
        {
          "name": "CharcoalNavigationBar",
          "kind": "constructor",
          "signature": "CharcoalNavigationBar({required this.title, this.leading, this.semanticLabel, this.showDivider = true, this.trailing, super.key})",
          "parameters": [
            {
              "name": "title",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "showDivider",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "trailing",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "navigation-bar-detail",
          "title": "Detail navigation bar",
          "description": "A centered destination title with back navigation and one contextual action.",
          "sourcePath": "example/lib/agent_examples/navigation_bar_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A page-level bar with hierarchical back navigation and one trailing action.\nfinal class AgentNavigationBarExample extends StatelessWidget {\n  const AgentNavigationBarExample({\n    required this.onBack,\n    required this.onMore,\n    super.key,\n  });\n\n  final VoidCallback onBack;\n  final VoidCallback onMore;\n\n  @override\n  Widget build(BuildContext context) => CharcoalNavigationBar(\n    leading: CharcoalIconButton(\n      icon: const CharcoalIcon(CharcoalIcons.chevronLeft),\n      onPressed: onBack,\n      semanticLabel: 'Back to messages',\n      size: CharcoalIconButtonSize.small,\n    ),\n    semanticLabel: 'Conversation navigation',\n    title: const Text('Aki Kondo'),\n    trailing: CharcoalIconButton(\n      icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),\n      onPressed: onMore,\n      semanticLabel: 'Conversation actions',\n      size: CharcoalIconButtonSize.small,\n    ),\n  );\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalNavigationItem",
      "category": "Navigation",
      "summary": "Selects one stable top-level destination in a sidebar, drawer, or navigation list.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/navigation_item.dart",
      "documentationLevel": "curated",
      "keywords": [
        "destination",
        "drawer item",
        "navigation item",
        "primary navigation",
        "sidebar",
        "top level navigation"
      ],
      "useWhen": [
        "A wide layout exposes stable top-level destinations in a sidebar or drawer.",
        "The selected destination and page content are controlled by one app-shell state owner."
      ],
      "avoidWhen": [
        "The action opens a detail or transient task; push a CharcoalPageRoute instead.",
        "The choice only changes a local filter or compact view; use CharcoalSegmentedControl."
      ],
      "accessibility": [
        "Every enabled item exposes button, focus, and explicit selected or unselected semantics.",
        "Wrap the destination collection in a named navigation semantic region.",
        "Use semanticLabel when icons, badges, or trailing content add meaning not present in the visible label."
      ],
      "responsiveBehavior": [
        "The item fills its parent width and retains a 40 logical-pixel minimum height.",
        "Leading, label, and trailing geometry remains fixed through hover, focus, press, cancellation, and selection.",
        "Move the same controlled destination state to CharcoalTabBar when compact constraints no longer support a sidebar.",
        "Long labels use one-line ellipsis; keep destination names concise and localizable."
      ],
      "interactionStates": [
        "selected",
        "unselected",
        "hovered",
        "focused",
        "pressed",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns persistent selection presentation on one layer and transient hover, focus, and press feedback on another.",
        "Keeps geometry stable and reports activation without mutating routes or destination state.",
        "The caller atomically updates the previous and next selected semantics plus content in the first painted frame.",
        "The caller owns destination state preservation and all detail, task, replacement, pop, and back effects."
      ],
      "tokenRoles": [
        "space.targetM",
        "space.targetXs",
        "space.component20",
        "space.component25",
        "radius.m",
        "containerSecondaryDefault",
        "containerSecondaryHoverA",
        "containerSecondaryPressA",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalTabBar",
        "CharcoalNavigationBar",
        "CharcoalPageRoute"
      ],
      "apis": [
        {
          "name": "CharcoalNavigationItem",
          "kind": "constructor",
          "signature": "CharcoalNavigationItem({required this.child, required this.onPressed, this.autofocus = false, this.focusNode, this.leading, this.selected = false, this.semanticLabel, this.statesController, this.trailing, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "trailing",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "navigation-item-adaptive-destinations",
          "title": "Adaptive controlled destinations",
          "description": "Shares one destination owner between a wide sidebar and compact tab bar without changing the route stack.",
          "sourcePath": "example/lib/agent_examples/navigation_item_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/semantics.dart' show SemanticsRole;\nimport 'package:flutter/widgets.dart';\n\nenum _NavigationDestination { home, discover, messages }\n\n/// One destination owner shared by wide sidebar and compact tab-bar layouts.\n///\n/// Top-level selection updates content in place. Details and transient tasks\n/// still belong on the Navigator stack outside this example.\nfinal class AgentNavigationItemExample extends StatefulWidget {\n  const AgentNavigationItemExample({super.key});\n\n  @override\n  State<AgentNavigationItemExample> createState() =>\n      _AgentNavigationItemExampleState();\n}\n\nfinal class _AgentNavigationItemExampleState\n    extends State<AgentNavigationItemExample> {\n  _NavigationDestination _destination = _NavigationDestination.home;\n\n  void _select(_NavigationDestination destination) {\n    setState(() => _destination = destination);\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return SizedBox(\n      height: 320,\n      child: LayoutBuilder(\n        builder: (context, constraints) {\n          final content = ColoredBox(\n            color: theme.colors.containerSecondaryDefaultA,\n            child: Center(\n              child: Text(\n                'Current destination: ${_destination.name}',\n                style: theme.textStyles.bodyBold,\n              ),\n            ),\n          );\n          if (constraints.maxWidth < 600) {\n            return Column(\n              crossAxisAlignment: CrossAxisAlignment.stretch,\n              children: <Widget>[\n                Expanded(child: content),\n                CharcoalTabBar<_NavigationDestination>(\n                  items: const <CharcoalTabItem<_NavigationDestination>>[\n                    CharcoalTabItem<_NavigationDestination>(\n                      icon: CharcoalIcon(CharcoalIcons.home),\n                      label: 'Home',\n                      value: _NavigationDestination.home,\n                    ),\n                    CharcoalTabItem<_NavigationDestination>(\n                      icon: CharcoalIcon(CharcoalIcons.compass),\n                      label: 'Discover',\n                      value: _NavigationDestination.discover,\n                    ),\n                    CharcoalTabItem<_NavigationDestination>(\n                      badge: '3',\n                      icon: CharcoalIcon(CharcoalIcons.message),\n                      label: 'Messages',\n                      semanticLabel: 'Messages, 3 unread',\n                      value: _NavigationDestination.messages,\n                    ),\n                  ],\n                  onChanged: _select,\n                  semanticLabel: 'Primary destinations',\n                  value: _destination,\n                ),\n              ],\n            );\n          }\n\n          return Row(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            children: <Widget>[\n              SizedBox(\n                width: 240,\n                child: Semantics(\n                  container: true,\n                  explicitChildNodes: true,\n                  label: 'Primary destinations',\n                  role: SemanticsRole.navigation,\n                  child: Padding(\n                    padding: EdgeInsets.all(space.component20),\n                    child: Column(\n                      crossAxisAlignment: CrossAxisAlignment.stretch,\n                      children: <Widget>[\n                        CharcoalNavigationItem(\n                          leading: const CharcoalIcon(CharcoalIcons.home),\n                          onPressed: () => _select(_NavigationDestination.home),\n                          selected: _destination == _NavigationDestination.home,\n                          child: const Text('Home'),\n                        ),\n                        SizedBox(height: space.component20),\n                        CharcoalNavigationItem(\n                          leading: const CharcoalIcon(CharcoalIcons.compass),\n                          onPressed: () =>\n                              _select(_NavigationDestination.discover),\n                          selected:\n                              _destination == _NavigationDestination.discover,\n                          child: const Text('Discover'),\n                        ),\n                        SizedBox(height: space.component20),\n                        CharcoalNavigationItem(\n                          leading: const CharcoalIcon(CharcoalIcons.message),\n                          onPressed: () =>\n                              _select(_NavigationDestination.messages),\n                          selected:\n                              _destination == _NavigationDestination.messages,\n                          semanticLabel: 'Messages, 3 unread',\n                          trailing: const Text('3'),\n                          child: const Text('Messages'),\n                        ),\n                      ],\n                    ),\n                  ),\n                ),\n              ),\n              SizedBox(width: space.layout40),\n              Expanded(child: content),\n            ],\n          );\n        },\n      ),\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalPageRoute",
      "category": "Navigation",
      "summary": "Pushes an opaque Charcoal page with native iOS edge-back and Android predictive-back behavior.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/app/charcoal_page_route.dart",
      "documentationLevel": "curated",
      "keywords": [
        "android predictive back",
        "back gesture",
        "ios swipe back",
        "navigation",
        "page route",
        "route transition"
      ],
      "useWhen": [
        "A detail, drill-in, or transient task belongs on a real Navigator stack.",
        "The page must preserve Charcoal motion while honoring native platform back gestures."
      ],
      "avoidWhen": [
        "A top-level destination is changing; update the stable app-shell owner without pushing a route.",
        "The task is a bounded dialog or sheet; use showCharcoalModal instead."
      ],
      "accessibility": [
        "Use PopScope.canPop to publish guarded navigation state before a platform gesture begins.",
        "Fullscreen dialogs and blocked routes do not expose an interactive iOS back gesture.",
        "The route scopes page semantics while the caller remains responsible for an explicit back action."
      ],
      "responsiveBehavior": [
        "Native iOS uses a leading-edge interactive transition and respects RTL directionality.",
        "Native Android consumes predictive-back progress from either system edge.",
        "Android hosts set android:enableOnBackInvokedCallback=\"true\" on the application or activity.",
        "Web and desktop platforms retain opaque Charcoal shared-axis motion without installing mobile edge gestures."
      ],
      "interactionStates": [
        "entering",
        "active",
        "back gesture started",
        "back gesture updating",
        "back gesture cancelled",
        "back gesture committed",
        "exiting"
      ],
      "feedbackResponsibilities": [
        "Owns page motion, gesture progress, cancellation recovery, and committed Navigator pop.",
        "The caller owns route-stack state, unsaved-change guards, and durable completion semantics."
      ],
      "tokenRoles": [],
      "relatedComponents": [
        "CharcoalApp",
        "CharcoalNavigationBar",
        "CharcoalTabBar"
      ],
      "apis": [
        {
          "name": "CharcoalPageRoute",
          "kind": "constructor",
          "signature": "CharcoalPageRoute({required this.builder, this.axis = CharcoalPageTransitionAxis.horizontal, super.fullscreenDialog = false, this.maintainState = true, super.requestFocus, this.reverseTransitionDuration = CharcoalMotion.routeReverse, super.settings, this.transitionDuration = CharcoalMotion.routeForward})",
          "parameters": [
            {
              "name": "builder",
              "type": "WidgetBuilder",
              "required": true,
              "named": true
            },
            {
              "name": "axis",
              "type": "CharcoalPageTransitionAxis",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPageTransitionAxis.horizontal"
            },
            {
              "name": "fullscreenDialog",
              "type": "dynamic",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "maintainState",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "requestFocus",
              "type": "dynamic",
              "required": false,
              "named": true
            },
            {
              "name": "reverseTransitionDuration",
              "type": "Duration",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalMotion.routeReverse"
            },
            {
              "name": "settings",
              "type": "dynamic",
              "required": false,
              "named": true
            },
            {
              "name": "transitionDuration",
              "type": "Duration",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalMotion.routeForward"
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalPageTransitionAxis",
          "kind": "enum",
          "signature": "enum CharcoalPageTransitionAxis { horizontal, vertical }",
          "parameters": [],
          "enumValues": [
            "horizontal",
            "vertical"
          ]
        }
      ],
      "examples": [
        {
          "id": "page-route-platform-back",
          "title": "Platform-adaptive detail route",
          "description": "Pushes a real detail page whose back interaction follows iOS and Android platform gestures.",
          "sourcePath": "example/lib/agent_examples/page_route_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Pushes a real detail route with Charcoal's platform-adaptive back gesture.\nfinal class AgentPageRouteExample extends StatelessWidget {\n  const AgentPageRouteExample({super.key});\n\n  @override\n  Widget build(BuildContext context) => CharcoalButton(\n    onPressed: () => Navigator.of(context).push<void>(\n      CharcoalPageRoute<void>(builder: (_) => const _AccountDetailPage()),\n    ),\n    variant: CharcoalButtonVariant.primary,\n    child: const Text('Open account details'),\n  );\n}\n\nfinal class _AccountDetailPage extends StatelessWidget {\n  const _AccountDetailPage();\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    return ColoredBox(\n      color: theme.colors.backgroundDefault,\n      child: SafeArea(\n        child: Column(\n          crossAxisAlignment: CrossAxisAlignment.stretch,\n          children: <Widget>[\n            CharcoalNavigationBar(\n              leading: CharcoalIconButton(\n                icon: const CharcoalIcon(CharcoalIcons.chevronLeft),\n                onPressed: () => Navigator.of(context).pop(),\n                semanticLabel: 'Back to account',\n                size: CharcoalIconButtonSize.small,\n              ),\n              title: const Text('Account details'),\n            ),\n            Padding(\n              padding: EdgeInsets.all(theme.dimensions.space.layout40),\n              child: const Text(\n                'Your profile and security settings are up to date.',\n              ),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalPagination",
      "category": "Navigation",
      "summary": "Requests a page from a finite ordered collection while the caller owns results and navigation state.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/pagination.dart",
      "documentationLevel": "curated",
      "keywords": [
        "current page",
        "finite results",
        "next page",
        "page navigation",
        "pagination",
        "previous page"
      ],
      "useWhen": [
        "A large ordered result collection has a known page count and users need direct access to nearby or boundary pages.",
        "The current page, loaded results, and optional URL state are controlled by one parent."
      ],
      "avoidWhen": [
        "Content continues without a known page count; use an explicit load-more or infinite-results pattern.",
        "The control advances media or featured content; use CharcoalCarousel.",
        "The choice changes a top-level destination; use CharcoalTabBar or CharcoalNavigationItem."
      ],
      "accessibility": [
        "Give the group and previous and next actions localized semantic labels that describe the paged content.",
        "The current page is selected and non-interactive, available page numbers are buttons, and ellipses are excluded from semantics.",
        "At the first and last page, the unavailable boundary arrow keeps layout space but leaves semantics and keyboard focus order."
      ],
      "responsiveBehavior": [
        "The page window automatically contracts from seven to five to three slots while preserving both boundary pages.",
        "Provide at least two navigation targets plus three page slots; use CharcoalPaginationSize.small in audited dense layouts.",
        "Previous and next chevrons follow ambient LTR or RTL text direction."
      ],
      "interactionStates": [
        "current",
        "available",
        "hovered",
        "focused",
        "pressed",
        "disabled",
        "first page",
        "last page"
      ],
      "feedbackResponsibilities": [
        "Owns the visible page window, current-page presentation, boundary visibility, interaction state, and requested one-indexed page.",
        "The caller owns the accepted current page, loading and error feedback, result replacement, scroll or focus restoration, and URL history."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.targetM",
        "radius.oval",
        "containerHudDefault",
        "containerSecondaryDefault",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalCarousel",
        "CharcoalNavigationItem",
        "CharcoalTabBar"
      ],
      "apis": [
        {
          "name": "CharcoalPagination",
          "kind": "constructor",
          "signature": "CharcoalPagination({required this.currentPage, required this.pageCount, required this.onPageChanged, this.maxVisiblePages = 7, this.nextLabel = 'Next page', this.previousLabel = 'Previous page', this.semanticLabel = 'Pagination', this.size = CharcoalPaginationSize.medium, super.key})",
          "parameters": [
            {
              "name": "currentPage",
              "type": "int",
              "required": true,
              "named": true
            },
            {
              "name": "pageCount",
              "type": "int",
              "required": true,
              "named": true
            },
            {
              "name": "onPageChanged",
              "type": "ValueChanged<int>?",
              "required": true,
              "named": true
            },
            {
              "name": "maxVisiblePages",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "7"
            },
            {
              "name": "nextLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Next page'"
            },
            {
              "name": "previousLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Previous page'"
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Pagination'"
            },
            {
              "name": "size",
              "type": "CharcoalPaginationSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPaginationSize.medium"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalPaginationSize",
          "kind": "enum",
          "signature": "enum CharcoalPaginationSize { small, medium }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium"
          ]
        }
      ],
      "examples": [
        {
          "id": "pagination-controlled-results",
          "title": "Adaptive controlled result pages",
          "description": "Keeps result context and the accepted page in one parent while the page window adapts to compact constraints.",
          "sourcePath": "example/lib/agent_examples/pagination_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Controlled paged-result context that remains usable at compact widths.\nfinal class AgentPaginationExample extends StatefulWidget {\n  const AgentPaginationExample({super.key});\n\n  @override\n  State<AgentPaginationExample> createState() => _AgentPaginationExampleState();\n}\n\nfinal class _AgentPaginationExampleState extends State<AgentPaginationExample> {\n  static const _pageCount = 20;\n  static const _pageSize = 10;\n  static const _resultCount = 194;\n\n  int _currentPage = 8;\n\n  int get _firstResult => (_currentPage - 1) * _pageSize + 1;\n\n  int get _lastResult {\n    final candidate = _currentPage * _pageSize;\n    return candidate > _resultCount ? _resultCount : candidate;\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Search results', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: true,\n          child: Text(\n            'Results $_firstResult–$_lastResult of $_resultCount. '\n            'Page $_currentPage of $_pageCount.',\n            style: theme.textStyles.captionMedium.copyWith(\n              color: theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalPagination(\n          currentPage: _currentPage,\n          nextLabel: 'Next result page',\n          onPageChanged: (page) => setState(() => _currentPage = page),\n          pageCount: _pageCount,\n          previousLabel: 'Previous result page',\n          semanticLabel: 'Search result pages',\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalRadio",
      "category": "Forms",
      "summary": "Selects one controlled value from a mutually exclusive group.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/radio.dart",
      "documentationLevel": "curated",
      "keywords": [
        "exclusive choice",
        "option group",
        "radio",
        "single choice",
        "single selection"
      ],
      "useWhen": [
        "A short set of choices should remain visible and exactly one value may be selected.",
        "The form benefits from comparing every option before submission."
      ],
      "avoidWhen": [
        "Choices are independent; use CharcoalCheckbox.",
        "The option set is long or needs secondary descriptions; use CharcoalDropdown."
      ],
      "accessibility": [
        "Give every option a distinct visible label and place related radios in one named semantic group.",
        "Each option exposes checked state and mutually exclusive group membership.",
        "When invalid is true, the option exposes invalid input semantics; keep one actionable group-level correction visible."
      ],
      "responsiveBehavior": [
        "The source-authored 20-pixel indicator remains fixed while a text label wraps within parent constraints.",
        "Stack options when labels or text scaling no longer fit a compact horizontal composition."
      ],
      "interactionStates": [
        "unselected",
        "selected",
        "hovered",
        "focused",
        "pressed",
        "invalid",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns option interaction plus selected, focused, invalid, and disabled presentation.",
        "Reports its value without mutating the group; the caller owns the single groupValue, validation, and downstream result."
      ],
      "tokenRoles": [
        "space.component10",
        "radius.oval",
        "containerPrimaryDefault",
        "borderDefault",
        "borderFocusLegacy",
        "borderNegative"
      ],
      "relatedComponents": [
        "CharcoalCheckbox",
        "CharcoalDropdown",
        "CharcoalSegmentedControl"
      ],
      "apis": [
        {
          "name": "CharcoalRadio",
          "kind": "constructor",
          "signature": "CharcoalRadio({required this.value, required this.groupValue, required this.onChanged, this.autofocus = false, this.focusNode, this.invalid = false, this.label, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "groupValue",
              "type": "T?",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "radio-controlled-group",
          "title": "Named controlled option group",
          "description": "Keeps one audience value in a parent and exposes the related options as a named group.",
          "sourcePath": "example/lib/agent_examples/selection_controls_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _Audience { everyone, followers, private }\n\n/// Parent-owned checkbox, radio, and switch state with distinct responsibilities.\nfinal class AgentSelectionControlsExample extends StatefulWidget {\n  const AgentSelectionControlsExample({super.key});\n\n  @override\n  State<AgentSelectionControlsExample> createState() =>\n      _AgentSelectionControlsExampleState();\n}\n\nfinal class _AgentSelectionControlsExampleState\n    extends State<AgentSelectionControlsExample> {\n  _Audience _audience = _Audience.followers;\n  bool _saveDrafts = true;\n  bool _releaseNotifications = true;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Publishing preferences', style: theme.textStyles.headingS),\n        SizedBox(height: space.component30),\n        CharcoalCheckbox(\n          value: _saveDrafts,\n          onChanged: (value) => setState(() => _saveDrafts = value),\n          label: const Text('Save drafts automatically'),\n        ),\n        SizedBox(height: space.layout40),\n        Text('Audience', style: theme.textStyles.bodyBold),\n        SizedBox(height: space.component20),\n        Semantics(\n          container: true,\n          explicitChildNodes: true,\n          label: 'Audience options',\n          child: Column(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            children: <Widget>[\n              CharcoalRadio<_Audience>(\n                value: _Audience.everyone,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Everyone'),\n              ),\n              SizedBox(height: space.component30),\n              CharcoalRadio<_Audience>(\n                value: _Audience.followers,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Followers'),\n              ),\n              SizedBox(height: space.component30),\n              CharcoalRadio<_Audience>(\n                value: _Audience.private,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Only me'),\n              ),\n            ],\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalSwitch(\n          value: _releaseNotifications,\n          onChanged: (value) => setState(() => _releaseNotifications = value),\n          label: const Text('Release notifications'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSegmentedControl",
      "category": "Selection",
      "summary": "Switches between a small set of mutually exclusive values.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/segmented_control.dart",
      "documentationLevel": "curated",
      "keywords": [
        "filter",
        "segmented",
        "single selection",
        "tabs",
        "toggle"
      ],
      "useWhen": [
        "Two to four short choices should remain visible and immediately selectable.",
        "The choice changes a local view, filter, or compact setting."
      ],
      "avoidWhen": [
        "The choices navigate between major destinations; use navigation components.",
        "The option set is long or labels require descriptions; use CharcoalDropdown."
      ],
      "accessibility": [
        "Provide semanticLabel for the group when surrounding text does not name it.",
        "Each segment exposes checked state within a mutually exclusive group."
      ],
      "responsiveBehavior": [
        "Use fullWidth when compact layouts need equal segments across available width.",
        "Use uniformSegmentWidth for equal fixed segments without filling the parent."
      ],
      "interactionStates": [
        "selected",
        "unselected",
        "focused",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns group selection and focus presentation for the controlled value.",
        "The caller owns loading, empty results, and persistence caused by selection."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.component30",
        "radius.xl",
        "containerSecondaryDefaultA",
        "containerPrimaryDefault"
      ],
      "relatedComponents": [
        "CharcoalDropdown",
        "CharcoalRadio"
      ],
      "apis": [
        {
          "name": "CharcoalSegmentedControl",
          "kind": "constructor",
          "signature": "CharcoalSegmentedControl({required this.segments, required this.value, required this.onChanged, this.fullWidth = false, this.semanticLabel, this.uniformSegmentWidth = false, super.key})",
          "parameters": [
            {
              "name": "segments",
              "type": "List<CharcoalSegment<T>>",
              "required": true,
              "named": true
            },
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "fullWidth",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "uniformSegmentWidth",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalSegment",
          "kind": "supportingType",
          "signature": "CharcoalSegment({required this.value, required this.child, this.enabled = true})",
          "parameters": [
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "enabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "segmented-controlled",
          "title": "Responsive segmented control",
          "description": "A controlled view switcher that fills compact layouts.",
          "sourcePath": "example/lib/agent_examples/segmented_control_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _FeedMode { recent, popular, saved }\n\n/// A responsive, parent-owned view switcher.\nfinal class AgentSegmentedControlExample extends StatefulWidget {\n  const AgentSegmentedControlExample({super.key});\n\n  @override\n  State<AgentSegmentedControlExample> createState() =>\n      _AgentSegmentedControlExampleState();\n}\n\nfinal class _AgentSegmentedControlExampleState\n    extends State<AgentSegmentedControlExample> {\n  _FeedMode _value = _FeedMode.recent;\n\n  @override\n  Widget build(BuildContext context) {\n    return LayoutBuilder(\n      builder: (context, constraints) => CharcoalSegmentedControl<_FeedMode>(\n        fullWidth: constraints.maxWidth < 480,\n        onChanged: (value) => setState(() => _value = value),\n        segments: const <CharcoalSegment<_FeedMode>>[\n          CharcoalSegment(value: _FeedMode.recent, child: Text('Recent')),\n          CharcoalSegment(value: _FeedMode.popular, child: Text('Popular')),\n          CharcoalSegment(value: _FeedMode.saved, child: Text('Saved')),\n        ],\n        semanticLabel: 'Feed order',\n        value: _value,\n      ),\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSnackBar",
      "category": "Feedback",
      "summary": "Shows a bordered, optionally illustrated transient notification.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/toast.dart",
      "documentationLevel": "curated",
      "keywords": [
        "alert",
        "feedback",
        "notification",
        "snackbar",
        "thumbnail"
      ],
      "useWhen": [
        "Transient feedback needs a neutral bordered surface, action, or thumbnail.",
        "The notification may be dismissed with a drag gesture."
      ],
      "avoidWhen": [
        "Success or error feedback should be visually compact; use CharcoalToast.",
        "The user must make a decision before continuing; use CharcoalDialog."
      ],
      "accessibility": [
        "The message is exposed as a live region; keep it short and self-contained.",
        "Any action widget needs its own accessible label and adequate target size."
      ],
      "responsiveBehavior": [
        "The overlay respects horizontal screen insets and a configurable maximum width.",
        "The thumbnail keeps its component-defined size while message content flexes.",
        "Feedback targets the root Overlay by default; set useRootOverlay to false from a context under a deliberately bounded nested Overlay."
      ],
      "interactionStates": [
        "appearing",
        "visible",
        "action invoked",
        "dismissed"
      ],
      "feedbackResponsibilities": [
        "Owns transient message, optional action, dismissal, and overlay presentation.",
        "The caller owns the action outcome and information that must remain after dismissal."
      ],
      "tokenRoles": [
        "borderDefault",
        "borderWidth.m",
        "space.component25",
        "space.component30",
        "space.layout60"
      ],
      "relatedComponents": [
        "CharcoalToast",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalSnackBar",
          "kind": "constructor",
          "signature": "CharcoalSnackBar({required this.message, this.action, this.maxWidth, this.semanticLabel, this.thumbnail, super.key})",
          "parameters": [
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "thumbnail",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalSnackBar",
          "kind": "function",
          "signature": "CharcoalToastController showCharcoalSnackBar({required BuildContext context, required String message, Widget? action, CharcoalToastAnimationConfiguration animationConfiguration = CharcoalToastAnimationConfiguration.defaultConfiguration, Duration? duration, CharcoalPopupEdge edge = CharcoalPopupEdge.bottom, double? maxWidth, String? semanticLabel, double? screenEdgeSpacing, Widget? thumbnail, bool useRootOverlay = true})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "animationConfiguration",
              "type": "CharcoalToastAnimationConfiguration",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastAnimationConfiguration.defaultConfiguration"
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "edge",
              "type": "CharcoalPopupEdge",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPopupEdge.bottom"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "screenEdgeSpacing",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "thumbnail",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "useRootOverlay",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalToastController",
          "kind": "supportingType",
          "signature": "class CharcoalToastController",
          "parameters": [],
          "enumValues": []
        },
        {
          "name": "CharcoalPopupEdge",
          "kind": "enum",
          "signature": "enum CharcoalPopupEdge { top, bottom }",
          "parameters": [],
          "enumValues": [
            "top",
            "bottom"
          ]
        },
        {
          "name": "CharcoalToastAnimationConfiguration",
          "kind": "supportingType",
          "signature": "CharcoalToastAnimationConfiguration({this.enablePositionAnimation = true, this.opacityCurve = Curves.easeInOut, this.positionCurve = Curves.easeOutBack})",
          "parameters": [
            {
              "name": "enablePositionAnimation",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "opacityCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeInOut"
            },
            {
              "name": "positionCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeOutBack"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "toast-and-snackbar",
          "title": "Transient feedback",
          "description": "Shows toast and snackbar overlays from a context with an Overlay.",
          "sourcePath": "example/lib/agent_examples/feedback_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Launches transient feedback from a context that owns an Overlay.\nfinal class AgentFeedbackExample extends StatelessWidget {\n  const AgentFeedbackExample({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    final gap = CharcoalTheme.of(context).dimensions.space.component20;\n    return Wrap(\n      spacing: gap,\n      runSpacing: gap,\n      children: <Widget>[\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalToast(context: context, message: 'Changes saved'),\n          child: const Text('Show toast'),\n        ),\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalSnackBar(context: context, message: 'Draft restored'),\n          child: const Text('Show snackbar'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSpinnerOverlay",
      "category": "Utility",
      "summary": "Centers named loading feedback over a subtree with explicit blocking or passthrough behavior.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/loading_spinner.dart",
      "documentationLevel": "curated",
      "keywords": [
        "blocking loading",
        "busy overlay",
        "loading mask",
        "spinner overlay",
        "subtree progress"
      ],
      "useWhen": [
        "A bounded subtree must remain in place while one indeterminate operation temporarily blocks stale interaction.",
        "Background refresh should remain visible while the underlying content is deliberately safe to use through interactionPassthrough."
      ],
      "avoidWhen": [
        "Only an inline status is needed; place CharcoalLoadingSpinner in normal layout.",
        "The operation navigates to a new destination, replaces the complete app, or needs modal decisions; use the corresponding route, page, or dialog state.",
        "A transparent visual overlay is being used as unexplained indefinite blocking; keep progress bounded and provide failure and recovery outside the component."
      ],
      "accessibility": [
        "Set semanticLabel to a localized operation name such as Publishing draft; the internal spinner exposes the loading-spinner live region.",
        "The default blocking mode removes the child subtree from pointer input, keyboard focus, and accessibility traversal until visible becomes false.",
        "interactionPassthrough preserves all child input and semantics, so enable it only when every underlying action is safe during the operation."
      ],
      "responsiveBehavior": [
        "The overlay occupies exactly the child bounds and centers the spinner without adding modal dimming or changing child geometry.",
        "spinnerSize changes only the source circle while the spinner retains its component-owned padding and surface.",
        "Presentation fade and scale become immediate when animations are disabled."
      ],
      "interactionStates": [
        "hidden",
        "appearing",
        "blocking visible",
        "passthrough visible",
        "disappearing",
        "reduced motion"
      ],
      "feedbackResponsibilities": [
        "Owns centering, presentation motion, loading semantics, and consistent pointer, focus, and semantic blocking policy.",
        "The caller owns visible, the operation-specific label, passthrough safety, timeout, error, retry, and durable completion state."
      ],
      "tokenRoles": [],
      "relatedComponents": [
        "CharcoalLoadingSpinner",
        "CharcoalSwitchingButton",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalSpinnerOverlay",
          "kind": "constructor",
          "signature": "CharcoalSpinnerOverlay({required this.child, required this.visible, this.interactionPassthrough = false, this.semanticLabel = 'Loading', this.spinnerSize, this.transparentBackground = false, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "visible",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "interactionPassthrough",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Loading'"
            },
            {
              "name": "spinnerSize",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "transparentBackground",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "spinner-overlay-publish-action",
          "title": "Blocking publish progress with durable result",
          "description": "Blocks stale publish actions, announces the operation, then restores the correct next action after completion.",
          "sourcePath": "example/lib/agent_examples/async_action_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A bounded asynchronous action with blocking progress and a durable result.\nfinal class AgentAsyncActionExample extends StatefulWidget {\n  const AgentAsyncActionExample({super.key});\n\n  @override\n  State<AgentAsyncActionExample> createState() =>\n      _AgentAsyncActionExampleState();\n}\n\nfinal class _AgentAsyncActionExampleState\n    extends State<AgentAsyncActionExample> {\n  bool _published = false;\n  bool _saving = false;\n  bool _pendingPublished = false;\n  String _status = 'This draft is private.';\n\n  Future<void> _setPublished(bool published) async {\n    if (_saving || _published == published) return;\n    setState(() {\n      _pendingPublished = published;\n      _saving = true;\n    });\n    await Future<void>.delayed(const Duration(milliseconds: 300));\n    if (!mounted) return;\n    setState(() {\n      _published = published;\n      _saving = false;\n      _status = published ? 'Draft published.' : 'Draft returned to private.';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Publishing', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: true,\n          child: Text(\n            _status,\n            style: theme.textStyles.captionMedium.copyWith(\n              color: theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalSpinnerOverlay(\n          semanticLabel: _pendingPublished\n              ? 'Publishing draft'\n              : 'Returning draft to private',\n          visible: _saving,\n          child: DecoratedBox(\n            decoration: BoxDecoration(\n              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n              color: theme.colors.containerSecondaryDefault,\n            ),\n            child: Padding(\n              padding: EdgeInsets.all(space.layout40),\n              child: Column(\n                mainAxisSize: MainAxisSize.min,\n                children: <Widget>[\n                  Text(\n                    _published ? 'Published' : 'Private draft',\n                    style: theme.textStyles.bodyBold,\n                  ),\n                  SizedBox(height: space.component30),\n                  CharcoalSwitchingButton(\n                    isOn: _published,\n                    offButton: CharcoalButton(\n                      onPressed: () => _setPublished(true),\n                      semanticLabel: 'Publish draft',\n                      variant: CharcoalButtonVariant.primary,\n                      child: const Text('Publish'),\n                    ),\n                    onButton: CharcoalButton(\n                      onPressed: () => _setPublished(false),\n                      semanticLabel: 'Return published item to draft',\n                      child: const Text('Unpublish'),\n                    ),\n                  ),\n                ],\n              ),\n            ),\n          ),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSwitch",
      "category": "Forms",
      "summary": "Changes one controlled on/off setting with immediate effect.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/switch.dart",
      "documentationLevel": "curated",
      "keywords": [
        "boolean setting",
        "on off",
        "preferences",
        "settings",
        "switch",
        "toggle"
      ],
      "useWhen": [
        "A boolean setting takes effect as soon as the user changes it.",
        "The current on or off state must remain visible beside its setting label."
      ],
      "avoidWhen": [
        "The value is accepted as part of a later form submission; use CharcoalCheckbox.",
        "The user chooses exactly one value from several options; use CharcoalRadio or CharcoalDropdown."
      ],
      "accessibility": [
        "Provide a visible label, or semanticLabel when visible context already names the setting.",
        "The control exposes toggled and disabled semantics and supports pointer plus keyboard activation.",
        "A null onChanged value disables interaction without dimming the readable label."
      ],
      "responsiveBehavior": [
        "The native 51 by 31 track remains fixed while the leading label uses the remaining width.",
        "Give long labels a constrained parent so they wrap without displacing the track."
      ],
      "interactionStates": [
        "off",
        "on",
        "hovered",
        "focused",
        "pressed",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns track, thumb, pointer, focus, toggled, and disabled presentation.",
        "Reports the proposed inverse value; the caller owns immediate persistence, failure recovery, and any dependent content."
      ],
      "tokenRoles": [
        "space.component10",
        "space.component20",
        "radius.oval",
        "containerPrimaryDefault",
        "containerNeutralDefault",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalCheckbox",
        "CharcoalRadio",
        "CharcoalSegmentedControl"
      ],
      "apis": [
        {
          "name": "CharcoalSwitch",
          "kind": "constructor",
          "signature": "CharcoalSwitch({required this.value, required this.onChanged, this.autofocus = false, this.focusNode, this.label, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "value",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<bool>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "switch-controlled-setting",
          "title": "Immediate controlled setting",
          "description": "Keeps an immediate notification preference in the same parent-owned settings model.",
          "sourcePath": "example/lib/agent_examples/selection_controls_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _Audience { everyone, followers, private }\n\n/// Parent-owned checkbox, radio, and switch state with distinct responsibilities.\nfinal class AgentSelectionControlsExample extends StatefulWidget {\n  const AgentSelectionControlsExample({super.key});\n\n  @override\n  State<AgentSelectionControlsExample> createState() =>\n      _AgentSelectionControlsExampleState();\n}\n\nfinal class _AgentSelectionControlsExampleState\n    extends State<AgentSelectionControlsExample> {\n  _Audience _audience = _Audience.followers;\n  bool _saveDrafts = true;\n  bool _releaseNotifications = true;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Publishing preferences', style: theme.textStyles.headingS),\n        SizedBox(height: space.component30),\n        CharcoalCheckbox(\n          value: _saveDrafts,\n          onChanged: (value) => setState(() => _saveDrafts = value),\n          label: const Text('Save drafts automatically'),\n        ),\n        SizedBox(height: space.layout40),\n        Text('Audience', style: theme.textStyles.bodyBold),\n        SizedBox(height: space.component20),\n        Semantics(\n          container: true,\n          explicitChildNodes: true,\n          label: 'Audience options',\n          child: Column(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            children: <Widget>[\n              CharcoalRadio<_Audience>(\n                value: _Audience.everyone,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Everyone'),\n              ),\n              SizedBox(height: space.component30),\n              CharcoalRadio<_Audience>(\n                value: _Audience.followers,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Followers'),\n              ),\n              SizedBox(height: space.component30),\n              CharcoalRadio<_Audience>(\n                value: _Audience.private,\n                groupValue: _audience,\n                onChanged: (value) => setState(() => _audience = value),\n                label: const Text('Only me'),\n              ),\n            ],\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalSwitch(\n          value: _releaseNotifications,\n          onChanged: (value) => setState(() => _releaseNotifications = value),\n          label: const Text('Release notifications'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSwitchingButton",
      "category": "Actions",
      "summary": "Keeps two action variants at one stable size while exposing only the active button.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/button.dart",
      "documentationLevel": "curated",
      "keywords": [
        "action state",
        "follow button",
        "stable button size",
        "swap action",
        "switching button"
      ],
      "useWhen": [
        "One location alternates between two complete Charcoal buttons, such as Follow and Unfollow, and must reserve the larger geometry before state changes.",
        "Each state has its own action label, callback, visual variant, and focus presentation while the parent owns one boolean value."
      ],
      "avoidWhen": [
        "The control changes one setting and should expose switch semantics; use CharcoalSwitch.",
        "One button remains the same action while progress is pending; keep that action disabled or place it under CharcoalSpinnerOverlay.",
        "More than two states or non-button content must change; model the state explicitly in normal layout instead."
      ],
      "accessibility": [
        "Give each button an action-oriented label that describes what activation does next, not only the current state.",
        "Only the visible branch participates in semantics and keyboard focus; the wrapper deliberately adds no anonymous toggle node.",
        "Use selected on the child button only when the action itself is a controlled toggle; switching layout alone is not selection semantics."
      ],
      "responsiveBehavior": [
        "The wrapper always takes the maximum width and height of both registered buttons so state changes do not shift surrounding layout.",
        "Both labels participate in layout under ambient text scaling; verify the larger translated label at the narrowest supported constraint.",
        "Hidden branches retain widget state but stop ticking animations until selected again."
      ],
      "interactionStates": [
        "off action visible",
        "on action visible",
        "visible action focused",
        "visible action pressed",
        "visible action disabled"
      ],
      "feedbackResponsibilities": [
        "Owns stable maximum geometry plus active-branch painting, focus, semantics, and ticker visibility.",
        "Each child owns its button visuals and activation; the caller owns the boolean value, pending work, failure, recovery, and durable result."
      ],
      "tokenRoles": [],
      "relatedComponents": [
        "CharcoalButton",
        "CharcoalSwitch",
        "CharcoalSpinnerOverlay"
      ],
      "apis": [
        {
          "name": "CharcoalSwitchingButton",
          "kind": "constructor",
          "signature": "CharcoalSwitchingButton({required this.isOn, required this.offButton, required this.onButton, super.key})",
          "parameters": [
            {
              "name": "isOn",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "offButton",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onButton",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "switching-button-publish-state",
          "title": "Stable publish and unpublish actions",
          "description": "Keeps the two action variants stable while asynchronous progress and durable state remain caller-owned.",
          "sourcePath": "example/lib/agent_examples/async_action_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A bounded asynchronous action with blocking progress and a durable result.\nfinal class AgentAsyncActionExample extends StatefulWidget {\n  const AgentAsyncActionExample({super.key});\n\n  @override\n  State<AgentAsyncActionExample> createState() =>\n      _AgentAsyncActionExampleState();\n}\n\nfinal class _AgentAsyncActionExampleState\n    extends State<AgentAsyncActionExample> {\n  bool _published = false;\n  bool _saving = false;\n  bool _pendingPublished = false;\n  String _status = 'This draft is private.';\n\n  Future<void> _setPublished(bool published) async {\n    if (_saving || _published == published) return;\n    setState(() {\n      _pendingPublished = published;\n      _saving = true;\n    });\n    await Future<void>.delayed(const Duration(milliseconds: 300));\n    if (!mounted) return;\n    setState(() {\n      _published = published;\n      _saving = false;\n      _status = published ? 'Draft published.' : 'Draft returned to private.';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Publishing', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: true,\n          child: Text(\n            _status,\n            style: theme.textStyles.captionMedium.copyWith(\n              color: theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        CharcoalSpinnerOverlay(\n          semanticLabel: _pendingPublished\n              ? 'Publishing draft'\n              : 'Returning draft to private',\n          visible: _saving,\n          child: DecoratedBox(\n            decoration: BoxDecoration(\n              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n              color: theme.colors.containerSecondaryDefault,\n            ),\n            child: Padding(\n              padding: EdgeInsets.all(space.layout40),\n              child: Column(\n                mainAxisSize: MainAxisSize.min,\n                children: <Widget>[\n                  Text(\n                    _published ? 'Published' : 'Private draft',\n                    style: theme.textStyles.bodyBold,\n                  ),\n                  SizedBox(height: space.component30),\n                  CharcoalSwitchingButton(\n                    isOn: _published,\n                    offButton: CharcoalButton(\n                      onPressed: () => _setPublished(true),\n                      semanticLabel: 'Publish draft',\n                      variant: CharcoalButtonVariant.primary,\n                      child: const Text('Publish'),\n                    ),\n                    onButton: CharcoalButton(\n                      onPressed: () => _setPublished(false),\n                      semanticLabel: 'Return published item to draft',\n                      child: const Text('Unpublish'),\n                    ),\n                  ),\n                ],\n              ),\n            ),\n          ),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTabBar",
      "category": "Navigation",
      "summary": "Switches between stable top-level destinations without owning or mutating the route stack.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/tab_bar.dart",
      "documentationLevel": "curated",
      "keywords": [
        "bottom navigation",
        "destination",
        "navigation tabs",
        "primary navigation",
        "tab bar"
      ],
      "useWhen": [
        "A compact application exposes two to five stable top-level destinations.",
        "Destination selection must remain controlled by one app-shell state owner."
      ],
      "avoidWhen": [
        "Choices switch a local filter or view; use CharcoalSegmentedControl.",
        "The action opens a detail, task, or durable result; use the app route stack instead."
      ],
      "accessibility": [
        "The bar and its destinations expose tab-bar and tab roles with one explicit selected item.",
        "Use a full semanticLabel when a visible badge adds information to the destination label."
      ],
      "responsiveBehavior": [
        "Destinations share the available width and retain a 64 logical-pixel baseline height.",
        "State layers preserve each destination rectangle plus icon and label alignment; they never loosen the content constraints.",
        "The bar grows for text scaling; use CharcoalNavigationItem when a large layout moves navigation to a sidebar.",
        "Place system safe-area padding in the surrounding app shell."
      ],
      "interactionStates": [
        "selected",
        "unselected",
        "hovered",
        "focused",
        "pressed",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns a touch lifecycle where pointer down paints an independent pressed layer, cancellation has no persistent effect, and an accepted tap reports selection; owns badge rendering.",
        "Commits controlled persistent selection atomically without reusing the transient interaction tween.",
        "Keeps target bounds, icon and label centers, and text baselines invariant across interaction states.",
        "The caller owns one destination state source plus route-stack effects, state preservation, and back behavior."
      ],
      "tokenRoles": [
        "space.layout60",
        "containerSecondaryDefaultA",
        "containerSecondaryHoverA",
        "containerSecondaryPressA",
        "borderFocusLegacy",
        "containerNegativeDefault"
      ],
      "relatedComponents": [
        "CharcoalNavigationBar",
        "CharcoalNavigationItem",
        "CharcoalSegmentedControl"
      ],
      "apis": [
        {
          "name": "CharcoalTabBar",
          "kind": "constructor",
          "signature": "CharcoalTabBar({required this.items, required this.onChanged, required this.value, this.semanticLabel, super.key})",
          "parameters": [
            {
              "name": "items",
              "type": "List<CharcoalTabItem<T>>",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalTabItem",
          "kind": "supportingType",
          "signature": "CharcoalTabItem({required this.icon, required this.label, required this.value, this.badge, this.enabled = true, this.key, this.semanticLabel})",
          "parameters": [
            {
              "name": "icon",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "badge",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "enabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "tab-bar-controlled",
          "title": "Controlled top-level destinations",
          "description": "A stable destination value updates app-shell content without prescribing a route push.",
          "sourcePath": "example/lib/agent_examples/tab_bar_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _Destination { home, discover, messages, profile }\n\n/// A controlled top-level destination selector.\n///\n/// Selection updates the app shell in place. Detail and task actions should\n/// still use a real Navigator push, replace, or pop outside this component.\nfinal class AgentTabBarExample extends StatefulWidget {\n  const AgentTabBarExample({super.key});\n\n  @override\n  State<AgentTabBarExample> createState() => _AgentTabBarExampleState();\n}\n\nfinal class _AgentTabBarExampleState extends State<AgentTabBarExample> {\n  _Destination destination = _Destination.home;\n\n  @override\n  Widget build(BuildContext context) => Column(\n    mainAxisSize: MainAxisSize.min,\n    children: <Widget>[\n      SizedBox(\n        height: CharcoalTheme.of(context).dimensions.space.layout60,\n        child: Center(\n          child: Text(\n            'Current destination: ${destination.name}',\n            style: CharcoalTheme.of(context).textStyles.captionMedium,\n          ),\n        ),\n      ),\n      CharcoalTabBar<_Destination>(\n        items: const <CharcoalTabItem<_Destination>>[\n          CharcoalTabItem<_Destination>(\n            icon: CharcoalIcon(CharcoalIcons.home),\n            label: 'Home',\n            value: _Destination.home,\n          ),\n          CharcoalTabItem<_Destination>(\n            icon: CharcoalIcon(CharcoalIcons.compass),\n            label: 'Discover',\n            value: _Destination.discover,\n          ),\n          CharcoalTabItem<_Destination>(\n            badge: '3',\n            icon: CharcoalIcon(CharcoalIcons.message),\n            label: 'Messages',\n            semanticLabel: 'Messages, 3 unread',\n            value: _Destination.messages,\n          ),\n          CharcoalTabItem<_Destination>(\n            icon: CharcoalIcon(CharcoalIcons.personCircle),\n            label: 'Profile',\n            value: _Destination.profile,\n          ),\n        ],\n        onChanged: (value) => setState(() => destination = value),\n        semanticLabel: 'Primary destinations',\n        value: destination,\n      ),\n    ],\n  );\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTagItem",
      "category": "Selection",
      "summary": "Toggles one compact topic or filter while the caller owns the selected tag set.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/tag_item.dart",
      "documentationLevel": "curated",
      "keywords": [
        "active tag",
        "category filter",
        "compact filter",
        "removable tag",
        "tag",
        "translated tag"
      ],
      "useWhen": [
        "A compact topic, category, or search filter needs one whole-surface action and an optional caller-controlled selected state.",
        "A source label benefits from a short translated label or artwork while remaining one semantic control."
      ],
      "avoidWhen": [
        "The value is non-interactive metadata; render text instead of presenting button and selected semantics.",
        "A form needs a named multi-selection group, validation, or a conventional check indicator; use CharcoalMultiSelect.",
        "The trailing icon must run an action independent from the label; use separate, explicitly named controls instead of nesting actions.",
        "The content is an application destination or numbered result page; use CharcoalNavigationItem, CharcoalTabBar, or CharcoalPagination."
      ],
      "accessibility": [
        "Keep status and the selected tag set controlled by one parent; normal and inactive expose selected false, while active exposes selected true.",
        "The active remove icon is decorative and remains part of the tag action, so it never creates a second focus stop or ambiguous nested semantics.",
        "Use semanticLabel when the visual source and translated labels do not clearly identify the tag in context; the default combines both visible labels.",
        "Set onPressed to null only when the complete tag action is unavailable; disabled opacity, focus removal, and semantics stay synchronized."
      ],
      "responsiveBehavior": [
        "Place related tags in Wrap with semantic spacing so each whole tag moves to a new run instead of being split.",
        "Long source and translated labels ellipsize within the component maximum and shrink under compact finite constraints.",
        "Small and medium are baseline heights that grow for accessibility text scaling; a translated label always uses medium.",
        "Directional padding keeps the active icon at the trailing edge in both LTR and RTL layouts."
      ],
      "interactionStates": [
        "normal",
        "active",
        "inactive",
        "hovered",
        "focused",
        "pressed",
        "disabled",
        "translated",
        "image background"
      ],
      "feedbackResponsibilities": [
        "Owns selected semantics, the active remove affordance, label truncation, transient interaction colors, focus ring, and disabled presentation.",
        "The caller owns the selected tag set, accepted add or remove outcome, filter results, loading and error feedback, and any route or URL synchronization."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.targetM",
        "space.component20",
        "space.component30",
        "space.component40",
        "radius.s",
        "containerSecondaryDefault",
        "containerOnImgDefault",
        "containerHoverA",
        "containerPressA",
        "textOnPrimaryDefault",
        "textOnOnImgDefault",
        "textSecondaryDefault",
        "borderFocusLegacy"
      ],
      "relatedComponents": [
        "CharcoalMultiSelect",
        "CharcoalButton",
        "CharcoalTextEllipsis"
      ],
      "apis": [
        {
          "name": "CharcoalTagItem",
          "kind": "constructor",
          "signature": "CharcoalTagItem({required this.label, required this.onPressed, this.autofocus = false, this.backgroundColor, this.backgroundImage, this.focusNode, this.imageFit = BoxFit.cover, this.semanticLabel, this.size = CharcoalTagItemSize.medium, this.statesController, this.status = CharcoalTagItemStatus.normal, this.translatedLabel, super.key})",
          "parameters": [
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "backgroundColor",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "backgroundImage",
              "type": "ImageProvider<Object>?",
              "required": false,
              "named": true
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "imageFit",
              "type": "BoxFit",
              "required": false,
              "named": true,
              "defaultValue": "BoxFit.cover"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalTagItemSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTagItemSize.medium"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "status",
              "type": "CharcoalTagItemStatus",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTagItemStatus.normal"
            },
            {
              "name": "translatedLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalTagItemSize",
          "kind": "enum",
          "signature": "enum CharcoalTagItemSize { small, medium }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium"
          ]
        },
        {
          "name": "CharcoalTagItemStatus",
          "kind": "enum",
          "signature": "enum CharcoalTagItemStatus { normal, active, inactive }",
          "parameters": [],
          "enumValues": [
            "normal",
            "active",
            "inactive"
          ]
        }
      ],
      "examples": [
        {
          "id": "tag-item-controlled-filters",
          "title": "Controlled tag filter collection",
          "description": "Keeps one selected set in the parent while translated and compact tags remain whole, reversible actions.",
          "sourcePath": "example/lib/agent_examples/tag_item_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A compact, caller-controlled tag filter collection.\nfinal class AgentTagItemExample extends StatefulWidget {\n  const AgentTagItemExample({super.key});\n\n  @override\n  State<AgentTagItemExample> createState() => _AgentTagItemExampleState();\n}\n\nfinal class _AgentTagItemExampleState extends State<AgentTagItemExample> {\n  static const _tags = <({String id, String label, String? translation})>[\n    (id: 'landscape', label: '#landscape', translation: null),\n    (id: 'original', label: '#オリジナル', translation: 'original work'),\n    (id: 'character', label: '#character', translation: null),\n    (id: 'background', label: '#background-art', translation: null),\n  ];\n\n  final Set<String> _selectedTags = <String>{'landscape'};\n\n  void _toggleTag(String id) {\n    setState(() {\n      if (!_selectedTags.add(id)) {\n        _selectedTags.remove(id);\n      }\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    final selectedCount = _selectedTags.length;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Artwork filters', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Semantics(\n          liveRegion: true,\n          child: Text(\n            '$selectedCount ${selectedCount == 1 ? 'filter' : 'filters'} selected',\n            style: theme.textStyles.captionMedium.copyWith(\n              color: theme.colors.textSecondaryDefault,\n            ),\n          ),\n        ),\n        SizedBox(height: space.layout30),\n        Wrap(\n          spacing: space.component20,\n          runSpacing: space.component20,\n          children: <Widget>[\n            for (final tag in _tags)\n              CharcoalTagItem(\n                label: tag.label,\n                onPressed: () => _toggleTag(tag.id),\n                semanticLabel: '${tag.id} tag filter',\n                status: _selectedTags.contains(tag.id)\n                    ? CharcoalTagItemStatus.active\n                    : CharcoalTagItemStatus.normal,\n                translatedLabel: tag.translation,\n              ),\n          ],\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTextArea",
      "category": "Forms",
      "summary": "Collects fixed-row multiline text with labels, validation, and character guidance.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/text_area.dart",
      "documentationLevel": "curated",
      "keywords": [
        "description",
        "form",
        "long text",
        "multiline",
        "text area",
        "validation"
      ],
      "useWhen": [
        "A form value needs multiple visible lines, such as a description, message, or report.",
        "The value benefits from a character count or a stable row count while editing."
      ],
      "avoidWhen": [
        "The value is naturally a single line; use CharcoalTextField.",
        "The value comes from a fixed option set; use CharcoalDropdown or CharcoalMultiSelect."
      ],
      "accessibility": [
        "Use a meaningful label and set required only when the multiline value is mandatory.",
        "Pair invalid with assistiveText; the area exposes multiline, required, invalid, and correction semantics.",
        "Keep the assistive message actionable instead of repeating that the value is invalid.",
        "Provide localized requiredText when the visible required marker includes copy."
      ],
      "responsiveBehavior": [
        "The area expands to the width supplied by its parent and scales row height with the system text size.",
        "Constrain long-form editors to a readable width on desktop rather than hard-coding the component width."
      ],
      "interactionStates": [
        "empty",
        "editing",
        "focused",
        "hovered",
        "pressed",
        "invalid",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns multiline editing, character-count, focus, invalid, assistive-text, and disabled presentation.",
        "The caller owns validation timing, submission progress, persistence, and recovery."
      ],
      "tokenRoles": [
        "space.component10",
        "space.component20",
        "radius.s",
        "containerSecondaryDefaultA",
        "borderFocusLegacy",
        "borderNegative"
      ],
      "relatedComponents": [
        "CharcoalTextField",
        "CharcoalFieldLabel",
        "CharcoalHintText"
      ],
      "apis": [
        {
          "name": "CharcoalTextArea",
          "kind": "constructor",
          "signature": "CharcoalTextArea({this.assistiveText, this.autofocus = false, this.controller, this.disabled = false, this.focusNode, this.invalid = false, this.label = '', this.maxLength, this.onChanged, this.placeholder, this.readOnly = false, this.required = false, this.requiredText = '*Required', this.rows = 4, this.showCount = false, this.showLabel = false, this.subLabel, super.key})",
          "parameters": [
            {
              "name": "assistiveText",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "controller",
              "type": "TextEditingController?",
              "required": false,
              "named": true
            },
            {
              "name": "disabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "maxLength",
              "type": "int?",
              "required": false,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<String>?",
              "required": false,
              "named": true
            },
            {
              "name": "placeholder",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "readOnly",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "rows",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "4"
            },
            {
              "name": "showCount",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "showLabel",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "text-area-validation",
          "title": "Validated multiline description",
          "description": "A controlled description area with character guidance and actionable invalid feedback.",
          "sourcePath": "example/lib/agent_examples/text_area_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A controlled multiline field with actionable validation guidance.\nfinal class AgentTextAreaExample extends StatefulWidget {\n  const AgentTextAreaExample({super.key});\n\n  @override\n  State<AgentTextAreaExample> createState() => _AgentTextAreaExampleState();\n}\n\nfinal class _AgentTextAreaExampleState extends State<AgentTextAreaExample> {\n  String _value = '';\n\n  @override\n  Widget build(BuildContext context) {\n    final invalid = _value.isNotEmpty && _value.trim().length < 10;\n    return CharcoalTextArea(\n      assistiveText: invalid\n          ? 'Use at least 10 characters.'\n          : 'Explain the context and expected result.',\n      invalid: invalid,\n      label: 'Description',\n      maxLength: 500,\n      onChanged: (value) => setState(() => _value = value),\n      placeholder: 'Describe what happened',\n      required: true,\n      rows: 5,\n      showCount: true,\n      showLabel: true,\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTextEllipsis",
      "category": "Content",
      "summary": "Truncates plain text to a positive line limit while preserving complete spoken content.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/text_ellipsis.dart",
      "documentationLevel": "curated",
      "keywords": [
        "clamp text",
        "ellipsis",
        "line limit",
        "multiline truncation",
        "overflow text",
        "truncate label"
      ],
      "useWhen": [
        "A known plain-text label or summary must reserve one or more lines inside a constrained card, row, or grid item.",
        "The complete string remains available to accessibility and the product provides visible detail elsewhere when the hidden portion is essential."
      ],
      "avoidWhen": [
        "The complete text is required to make a decision and no visible expansion, detail page, or other recovery exists.",
        "Rich text, inline actions, selectable content, or editable input must be truncated; use the owning text composition instead.",
        "A tooltip should appear automatically only when overflow occurs; this wrapper deliberately does not measure or add overlay behavior."
      ],
      "accessibility": [
        "Without semanticLabel, Flutter exposes the complete data string even when pixels are ellipsized.",
        "Use a non-empty semanticLabel only to add spoken context, not to replace meaningful visible content with unrelated wording.",
        "For essential hidden text, provide a visible disclosure or destination for pointer, touch, keyboard, and assistive users."
      ],
      "responsiveBehavior": [
        "The parent supplies available width; maxLines stays positive and soft wrapping fills each line before the terminal ellipsis.",
        "Ambient text scaling may cause earlier truncation without changing the line contract.",
        "Text alignment and ellipsis placement follow ambient LTR or RTL directionality."
      ],
      "interactionStates": [
        "untruncated",
        "single-line truncated",
        "multiline truncated",
        "scaled text",
        "RTL",
        "semantic override"
      ],
      "feedbackResponsibilities": [
        "Owns plain-text line clamping, ellipsis, wrapping, alignment, and optional spoken-label forwarding.",
        "The caller owns width, typography, localization, deciding whether truncation is acceptable, and access to essential full content."
      ],
      "tokenRoles": [],
      "relatedComponents": [
        "CharcoalTypography",
        "CharcoalTooltip",
        "CharcoalTextField"
      ],
      "apis": [
        {
          "name": "CharcoalTextEllipsis",
          "kind": "constructor",
          "signature": "CharcoalTextEllipsis(this.data, {this.maxLines = 1, this.semanticLabel, this.style, this.textAlign, super.key})",
          "parameters": [
            {
              "name": "data",
              "type": "String",
              "required": true,
              "named": false
            },
            {
              "name": "maxLines",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "1"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "style",
              "type": "TextStyle?",
              "required": false,
              "named": true
            },
            {
              "name": "textAlign",
              "type": "TextAlign?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "text-ellipsis-project-title",
          "title": "Scaled multiline project title",
          "description": "Limits a long localized title to two lines while retaining its complete spoken form.",
          "sourcePath": "example/lib/agent_examples/theme_typography_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A scoped light/dark token specimen with semantic and numeric typography.\nfinal class AgentThemeTypographyExample extends StatefulWidget {\n  const AgentThemeTypographyExample({super.key});\n\n  @override\n  State<AgentThemeTypographyExample> createState() =>\n      _AgentThemeTypographyExampleState();\n}\n\nfinal class _AgentThemeTypographyExampleState\n    extends State<AgentThemeTypographyExample> {\n  static const projectTitle =\n      'Moonlit Garden Archive for the Northern Collection';\n  bool _dark = false;\n\n  @override\n  Widget build(BuildContext context) => CharcoalTheme(\n    data: _dark ? CharcoalThemeData.dark() : CharcoalThemeData.light(),\n    child: Builder(\n      builder: (context) {\n        final theme = CharcoalTheme.of(context);\n        final space = theme.dimensions.space;\n        return DecoratedBox(\n          decoration: BoxDecoration(\n            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n            color: theme.colors.backgroundDefault,\n          ),\n          child: Padding(\n            padding: EdgeInsets.all(space.layout40),\n            child: Column(\n              crossAxisAlignment: CrossAxisAlignment.stretch,\n              mainAxisSize: MainAxisSize.min,\n              children: <Widget>[\n                Text(\n                  'Project typography',\n                  style: theme.textStyles.headingXs.copyWith(\n                    color: theme.colors.textDefaultText1,\n                  ),\n                ),\n                SizedBox(height: space.component20),\n                const CharcoalTypography(\n                  size: CharcoalTypographySize.size12,\n                  weight: CharcoalTypographyWeight.bold,\n                  child: Text('CURATED COLLECTION'),\n                ),\n                SizedBox(height: space.component20),\n                CharcoalTextEllipsis(\n                  projectTitle,\n                  maxLines: 2,\n                  semanticLabel: 'Complete project title: $projectTitle',\n                  style: theme.textStyles.body.copyWith(\n                    color: theme.colors.textDefaultText1,\n                  ),\n                ),\n                SizedBox(height: space.layout40),\n                Semantics(\n                  liveRegion: true,\n                  child: Text(\n                    _dark\n                        ? 'Previewing dark theme.'\n                        : 'Previewing light theme.',\n                    style: theme.textStyles.captionMedium.copyWith(\n                      color: theme.colors.textSecondaryDefault,\n                    ),\n                  ),\n                ),\n                SizedBox(height: space.component30),\n                CharcoalButton(\n                  fullWidth: true,\n                  onPressed: () => setState(() => _dark = !_dark),\n                  semanticLabel: _dark\n                      ? 'Preview light theme'\n                      : 'Preview dark theme',\n                  variant: CharcoalButtonVariant.primary,\n                  child: Text(_dark ? 'Preview light' : 'Preview dark'),\n                ),\n              ],\n            ),\n          ),\n        );\n      },\n    ),\n  );\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTextField",
      "category": "Forms",
      "summary": "Collects a single line of text with Charcoal labels, validation, and assistive text.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/text_field.dart",
      "documentationLevel": "curated",
      "keywords": [
        "field",
        "form",
        "input",
        "text entry",
        "validation"
      ],
      "useWhen": [
        "A form needs a single-line text value.",
        "The field needs a visible label, validation state, or assistive message."
      ],
      "avoidWhen": [
        "The value spans multiple lines; use CharcoalTextArea.",
        "The value comes from a fixed option set; use CharcoalDropdown."
      ],
      "accessibility": [
        "Use a meaningful label and keep it visible for forms that need persistent context.",
        "Pair invalid with assistiveText; the field exposes both the invalid result and correction as input semantics.",
        "Set required only when the value is mandatory; the same state is exposed visually and to assistive technology.",
        "Provide localized requiredText when the visible required marker includes copy."
      ],
      "responsiveBehavior": [
        "The field expands to the width supplied by its parent.",
        "Constrain forms to a readable width on desktop instead of sizing the field directly."
      ],
      "interactionStates": [
        "empty",
        "editing",
        "focused",
        "invalid",
        "disabled"
      ],
      "feedbackResponsibilities": [
        "Owns focus, invalid, assistive-text, and disabled presentation exposed by its API.",
        "The caller owns validation timing, submission progress, persistence, and recovery."
      ],
      "tokenRoles": [
        "space.component20",
        "radius.s",
        "containerSecondaryDefaultA",
        "borderFocusLegacy",
        "borderNegative"
      ],
      "relatedComponents": [
        "CharcoalTextArea",
        "CharcoalFieldLabel",
        "CharcoalHintText"
      ],
      "apis": [
        {
          "name": "CharcoalTextField",
          "kind": "constructor",
          "signature": "CharcoalTextField({this.assistiveText, this.autofocus = false, this.controller, this.disabled = false, this.focusNode, this.invalid = false, this.keyboardType, this.label = '', this.maxLength, this.obscureText = false, this.onChanged, this.onSubmitted, this.placeholder, this.prefix, this.readOnly = false, this.required = false, this.requiredText = '*Required', this.showCount = false, this.showLabel = false, this.subLabel, this.suffix, this.textInputAction, super.key})",
          "parameters": [
            {
              "name": "assistiveText",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "controller",
              "type": "TextEditingController?",
              "required": false,
              "named": true
            },
            {
              "name": "disabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "keyboardType",
              "type": "TextInputType?",
              "required": false,
              "named": true
            },
            {
              "name": "label",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "maxLength",
              "type": "int?",
              "required": false,
              "named": true
            },
            {
              "name": "obscureText",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<String>?",
              "required": false,
              "named": true
            },
            {
              "name": "onSubmitted",
              "type": "ValueChanged<String>?",
              "required": false,
              "named": true
            },
            {
              "name": "placeholder",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "prefix",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "readOnly",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "showCount",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "showLabel",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "suffix",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "textInputAction",
              "type": "TextInputAction?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "text-field-validation",
          "title": "Labeled text field",
          "description": "A controlled account-name field with validation guidance.",
          "sourcePath": "example/lib/agent_examples/text_field_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/services.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A controlled field that exposes validation without replacing Charcoal internals.\nfinal class AgentTextFieldExample extends StatefulWidget {\n  const AgentTextFieldExample({super.key});\n\n  @override\n  State<AgentTextFieldExample> createState() => _AgentTextFieldExampleState();\n}\n\nfinal class _AgentTextFieldExampleState extends State<AgentTextFieldExample> {\n  String _value = '';\n\n  @override\n  Widget build(BuildContext context) {\n    final invalid = _value.isNotEmpty && _value.length < 3;\n    return CharcoalTextField(\n      assistiveText: invalid\n          ? 'Use at least 3 characters.'\n          : 'This appears on your profile.',\n      invalid: invalid,\n      label: 'Display name',\n      onChanged: (value) => setState(() => _value = value),\n      placeholder: 'Enter a name',\n      required: true,\n      showLabel: true,\n      textInputAction: TextInputAction.done,\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTheme",
      "category": "Foundation",
      "summary": "Propagates one coherent Charcoal token set through a Widgets-layer subtree.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/theme/charcoal_theme.dart",
      "documentationLevel": "curated",
      "keywords": [
        "dark theme",
        "inherited theme",
        "light theme",
        "scoped theme",
        "semantic tokens",
        "theme data"
      ],
      "useWhen": [
        "A package-level subtree needs Charcoal colors, dimensions, typography, and brightness without Material or Cupertino dependencies.",
        "An isolated specimen or audited section needs one scoped token override while the rest of the application keeps its current theme."
      ],
      "avoidWhen": [
        "CharcoalApp already owns the application root; pass lightTheme, darkTheme, and themeMode there instead of adding a duplicate root wrapper.",
        "One component needs an ad hoc visual tweak; prefer its semantic API or a narrowly audited token override rather than nesting themes throughout the tree.",
        "Only brightness is changing while colors and typography remain from another mode; construct a coherent light or dark data set instead.",
        "User preference persistence or platform-mode observation is required; those remain application state owned by CharcoalApp and its caller."
      ],
      "accessibility": [
        "The theme adds no semantics by itself; components remain responsible for labels, roles, states, focus, and feedback.",
        "Any custom token set must preserve readable color relationships and perceivable interaction states in every supported mode.",
        "Keep ambient MediaQuery text scaling, reduced motion, directionality, and platform accessibility settings outside the token object intact."
      ],
      "responsiveBehavior": [
        "CharcoalTheme owns no layout; descendants resolve dimensions and typography from the nearest scoped data.",
        "As an InheritedTheme it is captured across framework overlay boundaries so menus, dialogs, and other captured subtrees retain the exact scope.",
        "Replace data atomically when a mode or scoped override changes so all dependents rebuild from one consistent frame."
      ],
      "interactionStates": [
        "light data",
        "dark data",
        "scoped override",
        "captured overlay",
        "data replacement"
      ],
      "feedbackResponsibilities": [
        "Owns dependency propagation and captured-theme continuity for colors, dimensions, typography, and brightness.",
        "The caller owns mode selection, preference persistence, system observation, override audits, and any transition between data sets."
      ],
      "tokenRoles": [
        "backgroundDefault",
        "textDefault",
        "space.layout40",
        "text.font-family/sans"
      ],
      "relatedComponents": [
        "CharcoalApp",
        "CharcoalTypography",
        "CharcoalTextEllipsis"
      ],
      "apis": [
        {
          "name": "CharcoalTheme",
          "kind": "constructor",
          "signature": "CharcoalTheme({required this.data, required super.child, super.key})",
          "parameters": [
            {
              "name": "data",
              "type": "CharcoalThemeData",
              "required": true,
              "named": true
            },
            {
              "name": "child",
              "type": "dynamic",
              "required": true,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalThemeData.light",
          "kind": "supportingType",
          "signature": "CharcoalThemeData.light({CharcoalColorTokens? colors, CharcoalDimensionTokens? dimensions, CharcoalTypographyTokens? typography})",
          "parameters": [
            {
              "name": "colors",
              "type": "CharcoalColorTokens?",
              "required": false,
              "named": true
            },
            {
              "name": "dimensions",
              "type": "CharcoalDimensionTokens?",
              "required": false,
              "named": true
            },
            {
              "name": "typography",
              "type": "CharcoalTypographyTokens?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalThemeData.dark",
          "kind": "supportingType",
          "signature": "CharcoalThemeData.dark({CharcoalColorTokens? colors, CharcoalDimensionTokens? dimensions, CharcoalTypographyTokens? typography})",
          "parameters": [
            {
              "name": "colors",
              "type": "CharcoalColorTokens?",
              "required": false,
              "named": true
            },
            {
              "name": "dimensions",
              "type": "CharcoalDimensionTokens?",
              "required": false,
              "named": true
            },
            {
              "name": "typography",
              "type": "CharcoalTypographyTokens?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "theme-scoped-typography",
          "title": "Scoped coherent light and dark token sets",
          "description": "Replaces one complete scoped theme while semantic and numeric typography resolve from the same frame.",
          "sourcePath": "example/lib/agent_examples/theme_typography_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A scoped light/dark token specimen with semantic and numeric typography.\nfinal class AgentThemeTypographyExample extends StatefulWidget {\n  const AgentThemeTypographyExample({super.key});\n\n  @override\n  State<AgentThemeTypographyExample> createState() =>\n      _AgentThemeTypographyExampleState();\n}\n\nfinal class _AgentThemeTypographyExampleState\n    extends State<AgentThemeTypographyExample> {\n  static const projectTitle =\n      'Moonlit Garden Archive for the Northern Collection';\n  bool _dark = false;\n\n  @override\n  Widget build(BuildContext context) => CharcoalTheme(\n    data: _dark ? CharcoalThemeData.dark() : CharcoalThemeData.light(),\n    child: Builder(\n      builder: (context) {\n        final theme = CharcoalTheme.of(context);\n        final space = theme.dimensions.space;\n        return DecoratedBox(\n          decoration: BoxDecoration(\n            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n            color: theme.colors.backgroundDefault,\n          ),\n          child: Padding(\n            padding: EdgeInsets.all(space.layout40),\n            child: Column(\n              crossAxisAlignment: CrossAxisAlignment.stretch,\n              mainAxisSize: MainAxisSize.min,\n              children: <Widget>[\n                Text(\n                  'Project typography',\n                  style: theme.textStyles.headingXs.copyWith(\n                    color: theme.colors.textDefaultText1,\n                  ),\n                ),\n                SizedBox(height: space.component20),\n                const CharcoalTypography(\n                  size: CharcoalTypographySize.size12,\n                  weight: CharcoalTypographyWeight.bold,\n                  child: Text('CURATED COLLECTION'),\n                ),\n                SizedBox(height: space.component20),\n                CharcoalTextEllipsis(\n                  projectTitle,\n                  maxLines: 2,\n                  semanticLabel: 'Complete project title: $projectTitle',\n                  style: theme.textStyles.body.copyWith(\n                    color: theme.colors.textDefaultText1,\n                  ),\n                ),\n                SizedBox(height: space.layout40),\n                Semantics(\n                  liveRegion: true,\n                  child: Text(\n                    _dark\n                        ? 'Previewing dark theme.'\n                        : 'Previewing light theme.',\n                    style: theme.textStyles.captionMedium.copyWith(\n                      color: theme.colors.textSecondaryDefault,\n                    ),\n                  ),\n                ),\n                SizedBox(height: space.component30),\n                CharcoalButton(\n                  fullWidth: true,\n                  onPressed: () => setState(() => _dark = !_dark),\n                  semanticLabel: _dark\n                      ? 'Preview light theme'\n                      : 'Preview dark theme',\n                  variant: CharcoalButtonVariant.primary,\n                  child: Text(_dark ? 'Preview light' : 'Preview dark'),\n                ),\n              ],\n            ),\n          ),\n        );\n      },\n    ),\n  );\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalToast",
      "category": "Feedback",
      "summary": "Shows a compact positive or negative live-region notification.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/toast.dart",
      "documentationLevel": "curated",
      "keywords": [
        "alert",
        "feedback",
        "notification",
        "success",
        "toast"
      ],
      "useWhen": [
        "A completed action needs brief success or error feedback.",
        "The feedback can disappear automatically without blocking the workflow."
      ],
      "avoidWhen": [
        "The message needs a thumbnail or neutral bordered surface; use CharcoalSnackBar.",
        "The user must make a decision before continuing; use CharcoalDialog."
      ],
      "accessibility": [
        "The message is exposed as a live region; use semanticLabel only when it needs clarification.",
        "Do not rely on success or error color as the only meaning in custom leading content."
      ],
      "responsiveBehavior": [
        "The overlay respects horizontal screen insets and a configurable maximum width.",
        "Choose CharcoalPopupEdge based on nearby persistent navigation and safe areas.",
        "Feedback targets the root Overlay by default; set useRootOverlay to false from a context under a deliberately bounded nested Overlay."
      ],
      "interactionStates": [
        "appearing",
        "visible",
        "dismissing"
      ],
      "feedbackResponsibilities": [
        "Owns transient presentation and success or error visual semantics.",
        "The caller must keep durable or corrective information in the page rather than only in a toast."
      ],
      "tokenRoles": [
        "containerPositiveDefault",
        "containerNegativeDefault",
        "space.component20",
        "space.component40",
        "borderWidth.l"
      ],
      "relatedComponents": [
        "CharcoalSnackBar",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalToast",
          "kind": "constructor",
          "signature": "CharcoalToast({required this.message, this.action, this.leading, this.maxWidth, this.semanticLabel, this.variant = CharcoalToastVariant.success, super.key})",
          "parameters": [
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalToastVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastVariant.success"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalToast",
          "kind": "function",
          "signature": "CharcoalToastController showCharcoalToast({required BuildContext context, required String message, Widget? action, CharcoalToastAnimationConfiguration animationConfiguration = CharcoalToastAnimationConfiguration.defaultConfiguration, Duration? duration, CharcoalPopupEdge edge = CharcoalPopupEdge.bottom, Widget? leading, double? maxWidth, String? semanticLabel, double? screenEdgeSpacing, CharcoalToastVariant variant = CharcoalToastVariant.success, bool useRootOverlay = true})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "animationConfiguration",
              "type": "CharcoalToastAnimationConfiguration",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastAnimationConfiguration.defaultConfiguration"
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "edge",
              "type": "CharcoalPopupEdge",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPopupEdge.bottom"
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "screenEdgeSpacing",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalToastVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastVariant.success"
            },
            {
              "name": "useRootOverlay",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalToastController",
          "kind": "supportingType",
          "signature": "class CharcoalToastController",
          "parameters": [],
          "enumValues": []
        },
        {
          "name": "CharcoalToastVariant",
          "kind": "enum",
          "signature": "enum CharcoalToastVariant { success, error }",
          "parameters": [],
          "enumValues": [
            "success",
            "error"
          ]
        },
        {
          "name": "CharcoalPopupEdge",
          "kind": "enum",
          "signature": "enum CharcoalPopupEdge { top, bottom }",
          "parameters": [],
          "enumValues": [
            "top",
            "bottom"
          ]
        },
        {
          "name": "CharcoalToastAnimationConfiguration",
          "kind": "supportingType",
          "signature": "CharcoalToastAnimationConfiguration({this.enablePositionAnimation = true, this.opacityCurve = Curves.easeInOut, this.positionCurve = Curves.easeOutBack})",
          "parameters": [
            {
              "name": "enablePositionAnimation",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "opacityCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeInOut"
            },
            {
              "name": "positionCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeOutBack"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "toast-and-snackbar",
          "title": "Transient feedback",
          "description": "Shows toast and snackbar overlays from a context with an Overlay.",
          "sourcePath": "example/lib/agent_examples/feedback_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Launches transient feedback from a context that owns an Overlay.\nfinal class AgentFeedbackExample extends StatelessWidget {\n  const AgentFeedbackExample({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    final gap = CharcoalTheme.of(context).dimensions.space.component20;\n    return Wrap(\n      spacing: gap,\n      runSpacing: gap,\n      children: <Widget>[\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalToast(context: context, message: 'Changes saved'),\n          child: const Text('Show toast'),\n        ),\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalSnackBar(context: context, message: 'Draft restored'),\n          child: const Text('Show snackbar'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTooltip",
      "category": "Overlays",
      "summary": "Adds brief, non-interactive context to an anchored control across pointer, focus, and touch input.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/tooltip.dart",
      "documentationLevel": "curated",
      "keywords": [
        "anchored help",
        "hover label",
        "tooltip",
        "touch hint"
      ],
      "useWhen": [
        "A compact control benefits from a short supplementary label or explanation that is not required to complete the task.",
        "The same brief context must be available from hover, keyboard focus, and touch without changing page layout."
      ],
      "avoidWhen": [
        "The information is essential, corrective, or a validation result; keep it inline with the affected content.",
        "The surface needs interactive content or persistent detail; use CharcoalAnchoredBalloon or a page-level disclosure.",
        "The user must make a blocking decision; use CharcoalDialog."
      ],
      "accessibility": [
        "Keep message concise and ensure the anchor still has its own action label; the message is exposed as tooltip semantics.",
        "Do not place interactive content in a tooltip because the rendered surface intentionally ignores pointer input.",
        "A focus-triggered tooltip dismisses with Escape without moving focus from its anchor."
      ],
      "responsiveBehavior": [
        "The surface wraps within maxWidth, respects screen insets, and follows its anchor while scrolling.",
        "Automatic placement prefers below and then above; set position only when the surrounding composition requires an audited side.",
        "Keep the message short enough to remain supplementary under text scaling instead of turning the tooltip into a reading surface."
      ],
      "interactionStates": [
        "hidden",
        "waiting",
        "hovered",
        "focused",
        "touch triggered",
        "visible",
        "dismissing"
      ],
      "feedbackResponsibilities": [
        "Owns delayed presentation, anchor tracking, collision handling, semantic annotation, and dismissal.",
        "The caller owns the anchor action, durable guidance, errors, progress, and results."
      ],
      "tokenRoles": [
        "containerHudDefault",
        "textOnHudDefault",
        "space.component10",
        "space.component25",
        "radius.s"
      ],
      "relatedComponents": [
        "CharcoalAnchoredBalloon",
        "CharcoalBalloon",
        "CharcoalHintText",
        "CharcoalIconButton"
      ],
      "apis": [
        {
          "name": "CharcoalTooltip",
          "kind": "constructor",
          "signature": "CharcoalTooltip({required this.child, required this.message, this.dismissAfter, this.dismissOnTapOutside = true, this.maxWidth, this.onVisibilityChanged, this.position, this.showOnFocus = true, this.showOnHover = true, this.showOnTap = true, this.visible, this.waitDuration = _TooltipSpec.defaultWaitDuration, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "dismissAfter",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissOnTapOutside",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onVisibilityChanged",
              "type": "ValueChanged<bool>?",
              "required": false,
              "named": true
            },
            {
              "name": "position",
              "type": "CharcoalOverlayPosition?",
              "required": false,
              "named": true
            },
            {
              "name": "showOnFocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "showOnHover",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "showOnTap",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "visible",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "waitDuration",
              "type": "Duration",
              "required": false,
              "named": true,
              "defaultValue": "_TooltipSpec.defaultWaitDuration"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalOverlayPosition",
          "kind": "enum",
          "signature": "enum CharcoalOverlayPosition { top, right, bottom, left }",
          "parameters": [],
          "enumValues": [
            "top",
            "right",
            "bottom",
            "left"
          ]
        }
      ],
      "examples": [
        {
          "id": "anchored-overlay-controls",
          "title": "Brief and persistent anchored context",
          "description": "Separates non-interactive tooltip help from persistent and controlled balloon content.",
          "sourcePath": "example/lib/agent_examples/overlay_controls_example.dart",
          "source": "import 'package:charcoal_icons/charcoal_icons.dart';\nimport 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Separates brief tooltip context, persistent callouts, and anchored details.\nfinal class AgentOverlayControlsExample extends StatefulWidget {\n  const AgentOverlayControlsExample({super.key});\n\n  @override\n  State<AgentOverlayControlsExample> createState() =>\n      _AgentOverlayControlsExampleState();\n}\n\nfinal class _AgentOverlayControlsExampleState\n    extends State<AgentOverlayControlsExample> {\n  bool _detailsVisible = false;\n  String _status = 'No overlay action yet';\n\n  void _setDetailsVisible(bool visible) {\n    if (_detailsVisible == visible) return;\n    setState(() {\n      _detailsVisible = visible;\n      _status = visible\n          ? 'Publishing details open'\n          : 'Publishing details closed';\n    });\n  }\n\n  void _reviewSettings() {\n    setState(() {\n      _detailsVisible = false;\n      _status = 'Settings review requested';\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = CharcoalTheme.of(context);\n    final space = theme.dimensions.space;\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      mainAxisSize: MainAxisSize.min,\n      children: <Widget>[\n        Text('Anchored context', style: theme.textStyles.headingS),\n        SizedBox(height: space.component20),\n        Text(_status, style: theme.textStyles.captionMedium),\n        SizedBox(height: space.layout40),\n        const Align(\n          alignment: AlignmentDirectional.centerStart,\n          child: CharcoalBalloon(\n            position: CharcoalOverlayPosition.left,\n            semanticLabel: 'Publishing guidance',\n            child: Text('Drafts remain private until you publish.'),\n          ),\n        ),\n        SizedBox(height: space.layout40),\n        Wrap(\n          crossAxisAlignment: WrapCrossAlignment.center,\n          spacing: space.component30,\n          runSpacing: space.component30,\n          children: <Widget>[\n            CharcoalTooltip(\n              message: 'Copies a shareable link',\n              child: CharcoalIconButton(\n                icon: const CharcoalIcon(CharcoalIcons.link),\n                onPressed: () => setState(() => _status = 'Share link copied'),\n                semanticLabel: 'Copy share link',\n              ),\n            ),\n            CharcoalAnchoredBalloon(\n              action: CharcoalLinkButton(\n                onPressed: _reviewSettings,\n                child: const Text('Review settings'),\n              ),\n              anchor: CharcoalButton(\n                leading: const CharcoalIcon(CharcoalIcons.questionCircle),\n                onPressed: () => _setDetailsVisible(!_detailsVisible),\n                semanticLabel: _detailsVisible\n                    ? 'Hide publishing details'\n                    : 'Show publishing details',\n                child: const Text('Publishing details'),\n              ),\n              dismissOnTapOutside: true,\n              message: 'Only workspace owners can publish this draft.',\n              onVisibilityChanged: _setDetailsVisible,\n              showOnTap: false,\n              visible: _detailsVisible,\n            ),\n          ],\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTypography",
      "category": "Content",
      "summary": "Applies Charcoal’s audited numeric component type scale without suppressing ambient text scaling.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/typography.dart",
      "documentationLevel": "curated",
      "keywords": [
        "component typography",
        "dynamic type",
        "font size",
        "monospace",
        "numeric type scale",
        "text style"
      ],
      "useWhen": [
        "A source-aligned component label needs one of the numeric 10, 12, 14, 16, or 20 styles with regular or bold weight.",
        "A short code-like value needs the upstream single-line monospace variant."
      ],
      "avoidWhen": [
        "A page heading, paragraph, caption, or information hierarchy needs a semantic role; use CharcoalTheme.of(context).textStyles instead.",
        "Text has a product-specific visual style unrelated to a reviewed Charcoal component; compose an audited TextStyle from semantic theme roles.",
        "Content must remain multiline while monospace is true; the upstream monospace variant is deliberately single-line."
      ],
      "accessibility": [
        "Ambient MediaQuery text scaling remains active; never pre-scale fontSize or wrap the subtree in a fixed TextScaler.",
        "singleLine and monospace truncate visually, so keep the complete spoken label available and provide a visible route to essential hidden content.",
        "Choose color from a semantic text role that remains readable on the actual surface instead of selecting a raw palette value."
      ],
      "responsiveBehavior": [
        "The authored font and line measurements remain 10/18, 12/20, 14/22, 16/24, and 20/28 before ambient scaling.",
        "Multiline proportional text wraps within parent constraints; singleLine and monospace use one-line ellipsis.",
        "textAlign follows ambient directionality, including start and end behavior in RTL."
      ],
      "interactionStates": [
        "regular",
        "bold",
        "proportional multiline",
        "proportional single-line",
        "monospace single-line",
        "scaled text",
        "RTL"
      ],
      "feedbackResponsibilities": [
        "Owns numeric component font size, line height, weight, runtime family mapping, wrapping mode, and inherited alignment.",
        "The caller owns semantic hierarchy, copy, localization, surface color selection, truncation recovery, and content changes."
      ],
      "tokenRoles": [
        "text.font-family/sans",
        "text.font-weight/regular",
        "text.font-weight/bold",
        "textDefaultText1"
      ],
      "relatedComponents": [
        "CharcoalTheme",
        "CharcoalTextEllipsis",
        "CharcoalFieldLabel"
      ],
      "apis": [
        {
          "name": "CharcoalTypography",
          "kind": "constructor",
          "signature": "CharcoalTypography({required this.child, this.color, this.monospace = false, this.singleLine = false, this.size = CharcoalTypographySize.size14, this.textAlign, this.weight = CharcoalTypographyWeight.regular, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "color",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "monospace",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "singleLine",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalTypographySize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographySize.size14"
            },
            {
              "name": "textAlign",
              "type": "TextAlign?",
              "required": false,
              "named": true
            },
            {
              "name": "weight",
              "type": "CharcoalTypographyWeight",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographyWeight.regular"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalTypographySize",
          "kind": "enum",
          "signature": "enum CharcoalTypographySize { size10, size12, size14, size16, size20 }",
          "parameters": [],
          "enumValues": [
            "size10",
            "size12",
            "size14",
            "size16",
            "size20"
          ]
        },
        {
          "name": "CharcoalTypographyWeight",
          "kind": "enum",
          "signature": "enum CharcoalTypographyWeight { regular, bold }",
          "parameters": [],
          "enumValues": [
            "regular",
            "bold"
          ]
        },
        {
          "name": "charcoalTypographyStyle",
          "kind": "function",
          "signature": "TextStyle charcoalTypographyStyle(BuildContext context, {Color? color, bool monospace = false, CharcoalTypographySize size = CharcoalTypographySize.size14, CharcoalTypographyWeight weight = CharcoalTypographyWeight.regular})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": false
            },
            {
              "name": "color",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "monospace",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalTypographySize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographySize.size14"
            },
            {
              "name": "weight",
              "type": "CharcoalTypographyWeight",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographyWeight.regular"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "typography-semantic-and-numeric",
          "title": "Semantic hierarchy with a numeric component label",
          "description": "Keeps page hierarchy on semantic theme styles while a reviewed component label uses the numeric scale.",
          "sourcePath": "example/lib/agent_examples/theme_typography_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A scoped light/dark token specimen with semantic and numeric typography.\nfinal class AgentThemeTypographyExample extends StatefulWidget {\n  const AgentThemeTypographyExample({super.key});\n\n  @override\n  State<AgentThemeTypographyExample> createState() =>\n      _AgentThemeTypographyExampleState();\n}\n\nfinal class _AgentThemeTypographyExampleState\n    extends State<AgentThemeTypographyExample> {\n  static const projectTitle =\n      'Moonlit Garden Archive for the Northern Collection';\n  bool _dark = false;\n\n  @override\n  Widget build(BuildContext context) => CharcoalTheme(\n    data: _dark ? CharcoalThemeData.dark() : CharcoalThemeData.light(),\n    child: Builder(\n      builder: (context) {\n        final theme = CharcoalTheme.of(context);\n        final space = theme.dimensions.space;\n        return DecoratedBox(\n          decoration: BoxDecoration(\n            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),\n            color: theme.colors.backgroundDefault,\n          ),\n          child: Padding(\n            padding: EdgeInsets.all(space.layout40),\n            child: Column(\n              crossAxisAlignment: CrossAxisAlignment.stretch,\n              mainAxisSize: MainAxisSize.min,\n              children: <Widget>[\n                Text(\n                  'Project typography',\n                  style: theme.textStyles.headingXs.copyWith(\n                    color: theme.colors.textDefaultText1,\n                  ),\n                ),\n                SizedBox(height: space.component20),\n                const CharcoalTypography(\n                  size: CharcoalTypographySize.size12,\n                  weight: CharcoalTypographyWeight.bold,\n                  child: Text('CURATED COLLECTION'),\n                ),\n                SizedBox(height: space.component20),\n                CharcoalTextEllipsis(\n                  projectTitle,\n                  maxLines: 2,\n                  semanticLabel: 'Complete project title: $projectTitle',\n                  style: theme.textStyles.body.copyWith(\n                    color: theme.colors.textDefaultText1,\n                  ),\n                ),\n                SizedBox(height: space.layout40),\n                Semantics(\n                  liveRegion: true,\n                  child: Text(\n                    _dark\n                        ? 'Previewing dark theme.'\n                        : 'Previewing light theme.',\n                    style: theme.textStyles.captionMedium.copyWith(\n                      color: theme.colors.textSecondaryDefault,\n                    ),\n                  ),\n                ),\n                SizedBox(height: space.component30),\n                CharcoalButton(\n                  fullWidth: true,\n                  onPressed: () => setState(() => _dark = !_dark),\n                  semanticLabel: _dark\n                      ? 'Preview light theme'\n                      : 'Preview dark theme',\n                  variant: CharcoalButtonVariant.primary,\n                  child: Text(_dark ? 'Preview light' : 'Preview dark'),\n                ),\n              ],\n            ),\n          ),\n        );\n      },\n    ),\n  );\n}\n"
        }
      ]
    }
  ],
  "tokens": [
    {
      "path": "border-width.focus/1",
      "dartAccessor": "theme.dimensions.borderWidth.focus1",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "1px",
      "darkValue": "1px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "border-width.focus/2",
      "dartAccessor": "theme.dimensions.borderWidth.focus2",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "2px",
      "darkValue": "2px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "border-width.l",
      "dartAccessor": "theme.dimensions.borderWidth.l",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "2px",
      "darkValue": "2px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "border-width.m",
      "dartAccessor": "theme.dimensions.borderWidth.m",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "1px",
      "darkValue": "1px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "brand-color.booth",
      "dartAccessor": "CharcoalBrandColors.booth",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 77, 80, 1)",
      "darkValue": "rgba(252, 77, 80, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.comic",
      "dartAccessor": "CharcoalBrandColors.comic",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 196, 0, 1)",
      "darkValue": "rgba(255, 196, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.factory",
      "dartAccessor": "CharcoalBrandColors.factoryValue",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 184, 205, 1)",
      "darkValue": "rgba(0, 184, 205, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.pixiv",
      "dartAccessor": "CharcoalBrandColors.pixiv",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(0, 150, 250, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.premium",
      "dartAccessor": "CharcoalBrandColors.premium",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 158, 22, 1)",
      "darkValue": "rgba(253, 158, 22, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Cyan/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightCyan50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 162, 187, 1)",
      "darkValue": "rgba(1, 162, 187, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(193, 247, 230, 1)",
      "darkValue": "rgba(193, 247, 230, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(138, 234, 206, 1)",
      "darkValue": "rgba(138, 234, 206, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(88, 211, 179, 1)",
      "darkValue": "rgba(88, 211, 179, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(61, 189, 157, 1)",
      "darkValue": "rgba(61, 189, 157, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(229, 251, 244, 1)",
      "darkValue": "rgba(229, 251, 244, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(22, 165, 135, 1)",
      "darkValue": "rgba(22, 165, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(20, 131, 107, 1)",
      "darkValue": "rgba(20, 131, 107, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(13, 89, 72, 1)",
      "darkValue": "rgba(13, 89, 72, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(5, 62, 49, 1)",
      "darkValue": "rgba(5, 62, 49, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 38, 29, 1)",
      "darkValue": "rgba(1, 38, 29, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.background/default",
      "dartAccessor": "theme.colors.backgroundDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.background/overlay",
      "dartAccessor": "theme.colors.backgroundOverlay",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.325)",
      "darkValue": "rgba(0, 0, 0, 0.32)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.background/secondary",
      "dartAccessor": "theme.colors.backgroundSecondary",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.background/tertiary",
      "dartAccessor": "theme.colors.backgroundTertiary",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/default",
      "dartAccessor": "theme.colors.borderDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/default-text3",
      "dartAccessor": "theme.colors.borderDefaultText3",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/disable",
      "dartAccessor": "theme.colors.borderDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/focus/1",
      "dartAccessor": "theme.colors.borderFocus1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(114, 181, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/focus/2",
      "dartAccessor": "theme.colors.borderFocus2",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(188, 222, 252, 1)",
      "darkValue": "rgba(39, 84, 126, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/focus/legacy",
      "dartAccessor": "theme.colors.borderFocusLegacy",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 0.32)",
      "darkValue": "rgba(0, 150, 250, 0.32)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/hover",
      "dartAccessor": "theme.colors.borderHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(255, 255, 255, 0.44)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/hover-text3",
      "dartAccessor": "theme.colors.borderHoverText3",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(255, 255, 255, 0.44)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/hud",
      "dartAccessor": "theme.colors.borderHud",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/negative",
      "dartAccessor": "theme.colors.borderNegative",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(253, 206, 199, 1)",
      "darkValue": "rgba(136, 54, 46, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/press",
      "dartAccessor": "theme.colors.borderPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.683)",
      "darkValue": "rgba(255, 255, 255, 0.535)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/press-text3",
      "dartAccessor": "theme.colors.borderPressText3",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.683)",
      "darkValue": "rgba(255, 255, 255, 0.535)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/secondary",
      "dartAccessor": "theme.colors.borderSecondary",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/selected",
      "dartAccessor": "theme.colors.borderSelected",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(8, 114, 190, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/default",
      "dartAccessor": "theme.colors.containerDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/default-a",
      "dartAccessor": "theme.colors.containerDefaultA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0)",
      "darkValue": "rgba(255, 255, 255, 0)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/disable",
      "dartAccessor": "theme.colors.containerDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/discovery/default",
      "dartAccessor": "theme.colors.containerDiscoveryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(253, 91, 78, 1)",
      "darkValue": "rgba(197, 60, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/discovery/hover",
      "dartAccessor": "theme.colors.containerDiscoveryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(217, 88, 76, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/discovery/press",
      "dartAccessor": "theme.colors.containerDiscoveryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(233, 114, 102, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hover",
      "dartAccessor": "theme.colors.containerHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hover-a",
      "dartAccessor": "theme.colors.containerHoverA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hud/default",
      "dartAccessor": "theme.colors.containerHudDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hud/hover",
      "dartAccessor": "theme.colors.containerHudHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hud/press",
      "dartAccessor": "theme.colors.containerHudPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/negative/default",
      "dartAccessor": "theme.colors.containerNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(253, 91, 78, 1)",
      "darkValue": "rgba(197, 60, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/negative/hover",
      "dartAccessor": "theme.colors.containerNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(217, 88, 76, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/negative/press",
      "dartAccessor": "theme.colors.containerNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(233, 114, 102, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/neutral/default",
      "dartAccessor": "theme.colors.containerNeutralDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/neutral/hover",
      "dartAccessor": "theme.colors.containerNeutralHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/neutral/press",
      "dartAccessor": "theme.colors.containerNeutralPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(151, 151, 151, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/notice/default",
      "dartAccessor": "theme.colors.containerNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(254, 214, 61, 1)",
      "darkValue": "rgba(235, 178, 19, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/notice/hover",
      "dartAccessor": "theme.colors.containerNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(245, 183, 17, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/notice/press",
      "dartAccessor": "theme.colors.containerNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(231, 157, 20, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/on-img/default",
      "dartAccessor": "theme.colors.containerOnImgDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.325)",
      "darkValue": "rgba(0, 0, 0, 0.325)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/on-img/hover",
      "dartAccessor": "theme.colors.containerOnImgHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(0, 0, 0, 0.42)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/on-img/press",
      "dartAccessor": "theme.colors.containerOnImgPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(0, 0, 0, 0.555)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/positive/default",
      "dartAccessor": "theme.colors.containerPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(37, 170, 28, 1)",
      "darkValue": "rgba(13, 129, 5, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/positive/hover",
      "dartAccessor": "theme.colors.containerPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(58, 150, 52, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/positive/press",
      "dartAccessor": "theme.colors.containerPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(86, 169, 79, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/press",
      "dartAccessor": "theme.colors.containerPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/press-a",
      "dartAccessor": "theme.colors.containerPressA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/primary/default",
      "dartAccessor": "theme.colors.containerPrimaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(8, 114, 190, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/primary/hover",
      "dartAccessor": "theme.colors.containerPrimaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(55, 136, 208, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/primary/press",
      "dartAccessor": "theme.colors.containerPrimaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(24, 81, 130, 1)",
      "darkValue": "rgba(83, 156, 224, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/default",
      "dartAccessor": "theme.colors.containerSecondaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/default-a",
      "dartAccessor": "theme.colors.containerSecondaryDefaultA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/hover",
      "dartAccessor": "theme.colors.containerSecondaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/hover-a",
      "dartAccessor": "theme.colors.containerSecondaryHoverA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/press",
      "dartAccessor": "theme.colors.containerSecondaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(217, 217, 217, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/press-a",
      "dartAccessor": "theme.colors.containerSecondaryPressA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.15)",
      "darkValue": "rgba(255, 255, 255, 0.225)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/skeleton",
      "dartAccessor": "theme.colors.containerSkeleton",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/subtle",
      "dartAccessor": "theme.colors.containerSubtle",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 0.02)",
      "darkValue": "rgba(228, 228, 228, 0.02)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/default",
      "dartAccessor": "theme.colors.containerTertiaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/default-a",
      "dartAccessor": "theme.colors.containerTertiaryDefaultA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/hover",
      "dartAccessor": "theme.colors.containerTertiaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(217, 217, 217, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/hover-a",
      "dartAccessor": "theme.colors.containerTertiaryHoverA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.15)",
      "darkValue": "rgba(255, 255, 255, 0.225)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/press",
      "dartAccessor": "theme.colors.containerTertiaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/press-a",
      "dartAccessor": "theme.colors.containerTertiaryPressA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.24)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.dark/blue/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlueMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlueMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(36, 55, 73, 1)",
      "darkValue": "rgba(36, 55, 73, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(39, 84, 126, 1)",
      "darkValue": "rgba(39, 84, 126, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(8, 114, 190, 1)",
      "darkValue": "rgba(8, 114, 190, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(55, 136, 208, 1)",
      "darkValue": "rgba(55, 136, 208, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(33, 41, 50, 1)",
      "darkValue": "rgba(33, 41, 50, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(83, 156, 224, 1)",
      "darkValue": "rgba(83, 156, 224, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(114, 181, 245, 1)",
      "darkValue": "rgba(114, 181, 245, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(139, 193, 248, 1)",
      "darkValue": "rgba(139, 193, 248, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(166, 205, 245, 1)",
      "darkValue": "rgba(166, 205, 245, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(207, 230, 253, 1)",
      "darkValue": "rgba(207, 230, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreenMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreenMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(41, 59, 40, 1)",
      "darkValue": "rgba(41, 59, 40, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(39, 92, 35, 1)",
      "darkValue": "rgba(39, 92, 35, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(13, 129, 5, 1)",
      "darkValue": "rgba(13, 129, 5, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(58, 150, 52, 1)",
      "darkValue": "rgba(58, 150, 52, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(37, 43, 37, 1)",
      "darkValue": "rgba(37, 43, 37, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(86, 169, 79, 1)",
      "darkValue": "rgba(86, 169, 79, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(120, 194, 113, 1)",
      "darkValue": "rgba(120, 194, 113, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(141, 204, 135, 1)",
      "darkValue": "rgba(141, 204, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(161, 215, 155, 1)",
      "darkValue": "rgba(161, 215, 155, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(191, 241, 186, 1)",
      "darkValue": "rgba(191, 241, 186, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigoMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigoMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(48, 51, 74, 1)",
      "darkValue": "rgba(48, 51, 74, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(72, 76, 134, 1)",
      "darkValue": "rgba(72, 76, 134, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(96, 100, 199, 1)",
      "darkValue": "rgba(96, 100, 199, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(115, 123, 219, 1)",
      "darkValue": "rgba(115, 123, 219, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(39, 40, 46, 1)",
      "darkValue": "rgba(39, 40, 46, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(135, 143, 231, 1)",
      "darkValue": "rgba(135, 143, 231, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(160, 170, 249, 1)",
      "darkValue": "rgba(160, 170, 249, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(175, 184, 254, 1)",
      "darkValue": "rgba(175, 184, 254, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(192, 199, 248, 1)",
      "darkValue": "rgba(192, 199, 248, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(222, 227, 255, 1)",
      "darkValue": "rgba(222, 227, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagentaMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagentaMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(69, 44, 56, 1)",
      "darkValue": "rgba(69, 44, 56, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(124, 58, 91, 1)",
      "darkValue": "rgba(124, 58, 91, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(185, 64, 130, 1)",
      "darkValue": "rgba(185, 64, 130, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(202, 91, 149, 1)",
      "darkValue": "rgba(202, 91, 149, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(48, 36, 42, 1)",
      "darkValue": "rgba(48, 36, 42, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(220, 114, 168, 1)",
      "darkValue": "rgba(220, 114, 168, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(240, 146, 191, 1)",
      "darkValue": "rgba(240, 146, 191, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(243, 163, 200, 1)",
      "darkValue": "rgba(243, 163, 200, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(247, 184, 213, 1)",
      "darkValue": "rgba(247, 184, 213, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 217, 233, 1)",
      "darkValue": "rgba(253, 217, 233, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralAMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.8)",
      "darkValue": "rgba(0, 0, 0, 0.8)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralAMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.32)",
      "darkValue": "rgba(0, 0, 0, 0.32)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0)",
      "darkValue": "rgba(255, 255, 255, 0)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.225)",
      "darkValue": "rgba(255, 255, 255, 0.225)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.36)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.44)",
      "darkValue": "rgba(255, 255, 255, 0.44)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.045)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.535)",
      "darkValue": "rgba(255, 255, 255, 0.535)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.645)",
      "darkValue": "rgba(255, 255, 255, 0.645)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.7)",
      "darkValue": "rgba(255, 255, 255, 0.7)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.765)",
      "darkValue": "rgba(255, 255, 255, 0.765)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.88)",
      "darkValue": "rgba(255, 255, 255, 0.88)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(51, 51, 51, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(112, 112, 112, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(130, 130, 130, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(41, 41, 41, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(151, 151, 151, 1)",
      "darkValue": "rgba(151, 151, 151, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(175, 175, 175, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(188, 188, 188, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(202, 202, 202, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrangeMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrangeMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(72, 48, 38, 1)",
      "darkValue": "rgba(72, 48, 38, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(134, 58, 22, 1)",
      "darkValue": "rgba(134, 58, 22, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(188, 74, 14, 1)",
      "darkValue": "rgba(188, 74, 14, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(212, 97, 41, 1)",
      "darkValue": "rgba(212, 97, 41, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(48, 39, 34, 1)",
      "darkValue": "rgba(48, 39, 34, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(229, 121, 68, 1)",
      "darkValue": "rgba(229, 121, 68, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(246, 151, 107, 1)",
      "darkValue": "rgba(246, 151, 107, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(248, 170, 135, 1)",
      "darkValue": "rgba(248, 170, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(245, 188, 163, 1)",
      "darkValue": "rgba(245, 188, 163, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 221, 207, 1)",
      "darkValue": "rgba(252, 221, 207, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurpleMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurpleMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(56, 48, 71, 1)",
      "darkValue": "rgba(56, 48, 71, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(93, 68, 132, 1)",
      "darkValue": "rgba(93, 68, 132, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(131, 88, 194, 1)",
      "darkValue": "rgba(131, 88, 194, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(149, 110, 210, 1)",
      "darkValue": "rgba(149, 110, 210, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(42, 38, 49, 1)",
      "darkValue": "rgba(42, 38, 49, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(169, 133, 229, 1)",
      "darkValue": "rgba(169, 133, 229, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(191, 160, 246, 1)",
      "darkValue": "rgba(191, 160, 246, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(201, 176, 249, 1)",
      "darkValue": "rgba(201, 176, 249, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(210, 192, 245, 1)",
      "darkValue": "rgba(210, 192, 245, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(233, 223, 255, 1)",
      "darkValue": "rgba(233, 223, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkRedMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkRedMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(73, 47, 43, 1)",
      "darkValue": "rgba(73, 47, 43, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(136, 54, 46, 1)",
      "darkValue": "rgba(136, 54, 46, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(197, 60, 51, 1)",
      "darkValue": "rgba(197, 60, 51, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(217, 88, 76, 1)",
      "darkValue": "rgba(217, 88, 76, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(47, 39, 38, 1)",
      "darkValue": "rgba(47, 39, 38, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(233, 114, 102, 1)",
      "darkValue": "rgba(233, 114, 102, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 147, 134, 1)",
      "darkValue": "rgba(252, 147, 134, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 167, 155, 1)",
      "darkValue": "rgba(254, 167, 155, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(249, 186, 177, 1)",
      "darkValue": "rgba(249, 186, 177, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 219, 214, 1)",
      "darkValue": "rgba(254, 219, 214, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoiseMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoiseMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(26, 60, 58, 1)",
      "darkValue": "rgba(26, 60, 58, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 91, 88, 1)",
      "darkValue": "rgba(0, 91, 88, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 123, 118, 1)",
      "darkValue": "rgba(0, 123, 118, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 147, 142, 1)",
      "darkValue": "rgba(0, 147, 142, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(35, 42, 41, 1)",
      "darkValue": "rgba(35, 42, 41, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(32, 170, 164, 1)",
      "darkValue": "rgba(32, 170, 164, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(84, 193, 186, 1)",
      "darkValue": "rgba(84, 193, 186, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(118, 205, 199, 1)",
      "darkValue": "rgba(118, 205, 199, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(144, 213, 207, 1)",
      "darkValue": "rgba(144, 213, 207, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(180, 239, 234, 1)",
      "darkValue": "rgba(180, 239, 234, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellowMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellowMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(66, 51, 30, 1)",
      "darkValue": "rgba(66, 51, 30, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(109, 75, 31, 1)",
      "darkValue": "rgba(109, 75, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(153, 99, 8, 1)",
      "darkValue": "rgba(153, 99, 8, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(174, 121, 14, 1)",
      "darkValue": "rgba(174, 121, 14, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(44, 40, 35, 1)",
      "darkValue": "rgba(44, 40, 35, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(199, 140, 10, 1)",
      "darkValue": "rgba(199, 140, 10, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(222, 167, 29, 1)",
      "darkValue": "rgba(222, 167, 29, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(235, 178, 19, 1)",
      "darkValue": "rgba(235, 178, 19, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(238, 195, 92, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 225, 167, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.icon/default",
      "dartAccessor": "theme.colors.iconDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/disable",
      "dartAccessor": "theme.colors.iconDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/hover",
      "dartAccessor": "theme.colors.iconHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/negative/default",
      "dartAccessor": "theme.colors.iconNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(252, 147, 134, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/negative/hover",
      "dartAccessor": "theme.colors.iconNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(249, 186, 177, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/negative/press",
      "dartAccessor": "theme.colors.iconNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(103, 22, 17, 1)",
      "darkValue": "rgba(254, 219, 214, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/notice/default",
      "dartAccessor": "theme.colors.iconNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(161, 99, 9, 1)",
      "darkValue": "rgba(222, 167, 29, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/notice/hover",
      "dartAccessor": "theme.colors.iconNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(110, 72, 5, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/notice/press",
      "dartAccessor": "theme.colors.iconNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(74, 51, 7, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-negative/default",
      "dartAccessor": "theme.colors.iconOnNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-negative/hover",
      "dartAccessor": "theme.colors.iconOnNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-negative/press",
      "dartAccessor": "theme.colors.iconOnNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-neutral/default",
      "dartAccessor": "theme.colors.iconOnNeutralDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-neutral/hover",
      "dartAccessor": "theme.colors.iconOnNeutralHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-neutral/press",
      "dartAccessor": "theme.colors.iconOnNeutralPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-notice/default",
      "dartAccessor": "theme.colors.iconOnNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-notice/hover",
      "dartAccessor": "theme.colors.iconOnNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-notice/press",
      "dartAccessor": "theme.colors.iconOnNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-on-img/default",
      "dartAccessor": "theme.colors.iconOnOnImgDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-on-img/hover",
      "dartAccessor": "theme.colors.iconOnOnImgHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-on-img/press",
      "dartAccessor": "theme.colors.iconOnOnImgPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-positive/default",
      "dartAccessor": "theme.colors.iconOnPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-positive/hover",
      "dartAccessor": "theme.colors.iconOnPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-positive/press",
      "dartAccessor": "theme.colors.iconOnPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-primary/default",
      "dartAccessor": "theme.colors.iconOnPrimaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-primary/hover",
      "dartAccessor": "theme.colors.iconOnPrimaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-primary/press",
      "dartAccessor": "theme.colors.iconOnPrimaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/positive/default",
      "dartAccessor": "theme.colors.iconPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(120, 194, 113, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/positive/hover",
      "dartAccessor": "theme.colors.iconPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(161, 215, 155, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/positive/press",
      "dartAccessor": "theme.colors.iconPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(191, 241, 186, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/press",
      "dartAccessor": "theme.colors.iconPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/secondary/default",
      "dartAccessor": "theme.colors.iconSecondaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/secondary/hover",
      "dartAccessor": "theme.colors.iconSecondaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/secondary/press",
      "dartAccessor": "theme.colors.iconSecondaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/tertiary/default",
      "dartAccessor": "theme.colors.iconTertiaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/tertiary/hover",
      "dartAccessor": "theme.colors.iconTertiaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/tertiary/press",
      "dartAccessor": "theme.colors.iconTertiaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.light/blue/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(216, 235, 251, 1)",
      "darkValue": "rgba(216, 235, 251, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(188, 222, 252, 1)",
      "darkValue": "rgba(188, 222, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(137, 200, 253, 1)",
      "darkValue": "rgba(137, 200, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(85, 178, 253, 1)",
      "darkValue": "rgba(85, 178, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(236, 244, 253, 1)",
      "darkValue": "rgba(236, 244, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(0, 150, 250, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(31, 117, 188, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(24, 81, 130, 1)",
      "darkValue": "rgba(24, 81, 130, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(19, 58, 93, 1)",
      "darkValue": "rgba(19, 58, 93, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(3, 35, 63, 1)",
      "darkValue": "rgba(3, 35, 63, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(204, 243, 200, 1)",
      "darkValue": "rgba(204, 243, 200, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(164, 234, 157, 1)",
      "darkValue": "rgba(164, 234, 157, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(121, 214, 112, 1)",
      "darkValue": "rgba(121, 214, 112, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(80, 192, 72, 1)",
      "darkValue": "rgba(80, 192, 72, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(234, 248, 232, 1)",
      "darkValue": "rgba(234, 248, 232, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(37, 170, 28, 1)",
      "darkValue": "rgba(37, 170, 28, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(17, 131, 8, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(4, 93, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(7, 64, 4, 1)",
      "darkValue": "rgba(7, 64, 4, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 40, 0, 1)",
      "darkValue": "rgba(1, 40, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(226, 231, 253, 1)",
      "darkValue": "rgba(226, 231, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(210, 216, 252, 1)",
      "darkValue": "rgba(210, 216, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(181, 189, 253, 1)",
      "darkValue": "rgba(181, 189, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(156, 165, 252, 1)",
      "darkValue": "rgba(156, 165, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(241, 242, 253, 1)",
      "darkValue": "rgba(241, 242, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(129, 136, 253, 1)",
      "darkValue": "rgba(129, 136, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(95, 97, 222, 1)",
      "darkValue": "rgba(95, 97, 222, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(68, 70, 155, 1)",
      "darkValue": "rgba(68, 70, 155, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(45, 47, 109, 1)",
      "darkValue": "rgba(45, 47, 109, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(24, 24, 70, 1)",
      "darkValue": "rgba(24, 24, 70, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(251, 226, 237, 1)",
      "darkValue": "rgba(251, 226, 237, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 204, 226, 1)",
      "darkValue": "rgba(255, 204, 226, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(245, 173, 206, 1)",
      "darkValue": "rgba(245, 173, 206, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(250, 131, 192, 1)",
      "darkValue": "rgba(250, 131, 192, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 239, 244, 1)",
      "darkValue": "rgba(252, 239, 244, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(235, 95, 170, 1)",
      "darkValue": "rgba(235, 95, 170, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(196, 53, 135, 1)",
      "darkValue": "rgba(196, 53, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(141, 33, 96, 1)",
      "darkValue": "rgba(141, 33, 96, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(98, 27, 67, 1)",
      "darkValue": "rgba(98, 27, 67, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(59, 5, 37, 1)",
      "darkValue": "rgba(59, 5, 37, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0)",
      "darkValue": "rgba(0, 0, 0, 0)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(0, 0, 0, 0.09)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.15)",
      "darkValue": "rgba(0, 0, 0, 0.15)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.24)",
      "darkValue": "rgba(0, 0, 0, 0.24)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.325)",
      "darkValue": "rgba(0, 0, 0, 0.325)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(0, 0, 0, 0.047)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(0, 0, 0, 0.42)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(0, 0, 0, 0.555)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.683)",
      "darkValue": "rgba(0, 0, 0, 0.683)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.78)",
      "darkValue": "rgba(0, 0, 0, 0.78)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.88)",
      "darkValue": "rgba(0, 0, 0, 0.88)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(232, 232, 232, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(217, 217, 217, 1)",
      "darkValue": "rgba(217, 217, 217, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(194, 194, 194, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(172, 172, 172, 1)",
      "darkValue": "rgba(172, 172, 172, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(243, 243, 243, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(148, 148, 148, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(113, 113, 113, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(56, 56, 56, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 229, 211, 1)",
      "darkValue": "rgba(252, 229, 211, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 209, 177, 1)",
      "darkValue": "rgba(253, 209, 177, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 176, 121, 1)",
      "darkValue": "rgba(254, 176, 121, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 143, 53, 1)",
      "darkValue": "rgba(253, 143, 53, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 241, 229, 1)",
      "darkValue": "rgba(253, 241, 229, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(242, 105, 21, 1)",
      "darkValue": "rgba(242, 105, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(190, 79, 4, 1)",
      "darkValue": "rgba(190, 79, 4, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(132, 54, 7, 1)",
      "darkValue": "rgba(132, 54, 7, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(91, 38, 13, 1)",
      "darkValue": "rgba(91, 38, 13, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(55, 18, 2, 1)",
      "darkValue": "rgba(55, 18, 2, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(236, 229, 251, 1)",
      "darkValue": "rgba(236, 229, 251, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(224, 210, 253, 1)",
      "darkValue": "rgba(224, 210, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(207, 183, 253, 1)",
      "darkValue": "rgba(207, 183, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(190, 153, 253, 1)",
      "darkValue": "rgba(190, 153, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(244, 241, 252, 1)",
      "darkValue": "rgba(244, 241, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(173, 120, 252, 1)",
      "darkValue": "rgba(173, 120, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(143, 77, 225, 1)",
      "darkValue": "rgba(143, 77, 225, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(103, 39, 171, 1)",
      "darkValue": "rgba(103, 39, 171, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(70, 32, 115, 1)",
      "darkValue": "rgba(70, 32, 115, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(40, 16, 70, 1)",
      "darkValue": "rgba(40, 16, 70, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(250, 228, 225, 1)",
      "darkValue": "rgba(250, 228, 225, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 206, 199, 1)",
      "darkValue": "rgba(253, 206, 199, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 174, 163, 1)",
      "darkValue": "rgba(253, 174, 163, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 138, 124, 1)",
      "darkValue": "rgba(252, 138, 124, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 240, 237, 1)",
      "darkValue": "rgba(253, 240, 237, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 91, 78, 1)",
      "darkValue": "rgba(253, 91, 78, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(206, 54, 46, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(147, 33, 28, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(103, 22, 17, 1)",
      "darkValue": "rgba(103, 22, 17, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(66, 0, 1, 1)",
      "darkValue": "rgba(66, 0, 1, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(196, 240, 241, 1)",
      "darkValue": "rgba(196, 240, 241, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(152, 228, 229, 1)",
      "darkValue": "rgba(152, 228, 229, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(109, 204, 205, 1)",
      "darkValue": "rgba(109, 204, 205, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(63, 184, 186, 1)",
      "darkValue": "rgba(63, 184, 186, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(225, 249, 249, 1)",
      "darkValue": "rgba(225, 249, 249, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(27, 161, 163, 1)",
      "darkValue": "rgba(27, 161, 163, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(11, 126, 128, 1)",
      "darkValue": "rgba(11, 126, 128, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(3, 87, 89, 1)",
      "darkValue": "rgba(3, 87, 89, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 61, 62, 1)",
      "darkValue": "rgba(1, 61, 62, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 37, 37, 1)",
      "darkValue": "rgba(1, 37, 37, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(246, 232, 176, 1)",
      "darkValue": "rgba(246, 232, 176, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 214, 61, 1)",
      "darkValue": "rgba(254, 214, 61, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(245, 183, 17, 1)",
      "darkValue": "rgba(245, 183, 17, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(231, 157, 20, 1)",
      "darkValue": "rgba(231, 157, 20, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(250, 243, 221, 1)",
      "darkValue": "rgba(250, 243, 221, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(205, 131, 2, 1)",
      "darkValue": "rgba(205, 131, 2, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(161, 99, 9, 1)",
      "darkValue": "rgba(161, 99, 9, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(110, 72, 5, 1)",
      "darkValue": "rgba(110, 72, 5, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(74, 51, 7, 1)",
      "darkValue": "rgba(74, 51, 7, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(44, 28, 0, 1)",
      "darkValue": "rgba(44, 28, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.text/default",
      "dartAccessor": "theme.colors.textDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/default-text1",
      "dartAccessor": "theme.colors.textDefaultText1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/disable",
      "dartAccessor": "theme.colors.textDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/hover",
      "dartAccessor": "theme.colors.textHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/hover-text1",
      "dartAccessor": "theme.colors.textHoverText1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/info/default",
      "dartAccessor": "theme.colors.textInfoDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(114, 181, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/info/hover",
      "dartAccessor": "theme.colors.textInfoHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(24, 81, 130, 1)",
      "darkValue": "rgba(166, 205, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/info/press",
      "dartAccessor": "theme.colors.textInfoPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(19, 58, 93, 1)",
      "darkValue": "rgba(207, 230, 253, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/negative/default",
      "dartAccessor": "theme.colors.textNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(252, 147, 134, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/negative/hover",
      "dartAccessor": "theme.colors.textNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(249, 186, 177, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/negative/press",
      "dartAccessor": "theme.colors.textNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(103, 22, 17, 1)",
      "darkValue": "rgba(254, 219, 214, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/notice/default",
      "dartAccessor": "theme.colors.textNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(161, 99, 9, 1)",
      "darkValue": "rgba(222, 167, 29, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/notice/hover",
      "dartAccessor": "theme.colors.textNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(110, 72, 5, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/notice/press",
      "dartAccessor": "theme.colors.textNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(74, 51, 7, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-discovery/default",
      "dartAccessor": "theme.colors.textOnDiscoveryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-discovery/hover",
      "dartAccessor": "theme.colors.textOnDiscoveryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-discovery/press",
      "dartAccessor": "theme.colors.textOnDiscoveryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-hud/default",
      "dartAccessor": "theme.colors.textOnHudDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-hud/hover",
      "dartAccessor": "theme.colors.textOnHudHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-hud/press",
      "dartAccessor": "theme.colors.textOnHudPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-negative/default",
      "dartAccessor": "theme.colors.textOnNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-negative/hover",
      "dartAccessor": "theme.colors.textOnNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-negative/press",
      "dartAccessor": "theme.colors.textOnNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-notice/default",
      "dartAccessor": "theme.colors.textOnNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-notice/hover",
      "dartAccessor": "theme.colors.textOnNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-notice/press",
      "dartAccessor": "theme.colors.textOnNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-on-img/default",
      "dartAccessor": "theme.colors.textOnOnImgDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-on-img/hover",
      "dartAccessor": "theme.colors.textOnOnImgHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-on-img/press",
      "dartAccessor": "theme.colors.textOnOnImgPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-positive/default",
      "dartAccessor": "theme.colors.textOnPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-positive/hover",
      "dartAccessor": "theme.colors.textOnPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-positive/press",
      "dartAccessor": "theme.colors.textOnPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-primary/default",
      "dartAccessor": "theme.colors.textOnPrimaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-primary/hover",
      "dartAccessor": "theme.colors.textOnPrimaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-primary/press",
      "dartAccessor": "theme.colors.textOnPrimaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/placeholder/default",
      "dartAccessor": "theme.colors.textPlaceholderDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/placeholder/hover",
      "dartAccessor": "theme.colors.textPlaceholderHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/placeholder/press",
      "dartAccessor": "theme.colors.textPlaceholderPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/positive/default",
      "dartAccessor": "theme.colors.textPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(120, 194, 113, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/positive/hover",
      "dartAccessor": "theme.colors.textPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(161, 215, 155, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/positive/press",
      "dartAccessor": "theme.colors.textPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(7, 64, 4, 1)",
      "darkValue": "rgba(191, 241, 186, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/press",
      "dartAccessor": "theme.colors.textPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/press-text1",
      "dartAccessor": "theme.colors.textPressText1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/secondary/default",
      "dartAccessor": "theme.colors.textSecondaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/secondary/hover",
      "dartAccessor": "theme.colors.textSecondaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/secondary/press",
      "dartAccessor": "theme.colors.textSecondaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/tertiary/default",
      "dartAccessor": "theme.colors.textTertiaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/tertiary/hover",
      "dartAccessor": "theme.colors.textTertiaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/tertiary/press",
      "dartAccessor": "theme.colors.textTertiaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/visited/default",
      "dartAccessor": "theme.colors.textVisitedDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(103, 39, 171, 1)",
      "darkValue": "rgba(191, 160, 246, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/visited/hover",
      "dartAccessor": "theme.colors.textVisitedHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(70, 32, 115, 1)",
      "darkValue": "rgba(210, 192, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/visited/press",
      "dartAccessor": "theme.colors.textVisitedPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(40, 16, 70, 1)",
      "darkValue": "rgba(233, 223, 255, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "paragraph-width.l",
      "dartAccessor": "theme.dimensions.paragraphWidth.l",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "672px",
      "darkValue": "672px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.l-compact",
      "dartAccessor": "theme.dimensions.paragraphWidth.lCompact",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "588px",
      "darkValue": "588px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.l-cozy",
      "dartAccessor": "theme.dimensions.paragraphWidth.lCozy",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "924px",
      "darkValue": "924px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.m",
      "dartAccessor": "theme.dimensions.paragraphWidth.m",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "448px",
      "darkValue": "448px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.m-compact",
      "dartAccessor": "theme.dimensions.paragraphWidth.mCompact",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "392px",
      "darkValue": "392px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.m-cozy",
      "dartAccessor": "theme.dimensions.paragraphWidth.mCozy",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "616px",
      "darkValue": "616px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.s",
      "dartAccessor": "theme.dimensions.paragraphWidth.s",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "320px",
      "darkValue": "320px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.s-compact",
      "dartAccessor": "theme.dimensions.paragraphWidth.sCompact",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "280px",
      "darkValue": "280px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.s-cozy",
      "dartAccessor": "theme.dimensions.paragraphWidth.sCozy",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "588px",
      "darkValue": "588px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "radius.0",
      "dartAccessor": "theme.dimensions.radius.value0",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "0px",
      "darkValue": "0px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.l",
      "dartAccessor": "theme.dimensions.radius.l",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.m",
      "dartAccessor": "theme.dimensions.radius.m",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "8px",
      "darkValue": "8px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.oval",
      "dartAccessor": "theme.dimensions.radius.oval",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "999999px",
      "darkValue": "999999px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.s",
      "dartAccessor": "theme.dimensions.radius.s",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "4px",
      "darkValue": "4px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.xl",
      "dartAccessor": "theme.dimensions.radius.xl",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.xs",
      "dartAccessor": "theme.dimensions.radius.xs",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "2px",
      "darkValue": "2px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.xxl",
      "dartAccessor": "theme.dimensions.radius.xxl",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "space.component/0",
      "dartAccessor": "theme.dimensions.space.component0",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "0px",
      "darkValue": "0px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/10",
      "dartAccessor": "theme.dimensions.space.component10",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "4px",
      "darkValue": "4px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/20",
      "dartAccessor": "theme.dimensions.space.component20",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "8px",
      "darkValue": "8px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/25",
      "dartAccessor": "theme.dimensions.space.component25",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/30",
      "dartAccessor": "theme.dimensions.space.component30",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/40",
      "dartAccessor": "theme.dimensions.space.component40",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/50",
      "dartAccessor": "theme.dimensions.space.component50",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.layout/0",
      "dartAccessor": "theme.dimensions.space.layout0",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "0px",
      "darkValue": "0px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/10",
      "dartAccessor": "theme.dimensions.space.layout10",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "4px",
      "darkValue": "4px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/100",
      "dartAccessor": "theme.dimensions.space.layout100",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "440px",
      "darkValue": "440px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/20",
      "dartAccessor": "theme.dimensions.space.layout20",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "8px",
      "darkValue": "8px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/25",
      "dartAccessor": "theme.dimensions.space.layout25",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/30",
      "dartAccessor": "theme.dimensions.space.layout30",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/40",
      "dartAccessor": "theme.dimensions.space.layout40",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/50",
      "dartAccessor": "theme.dimensions.space.layout50",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/60",
      "dartAccessor": "theme.dimensions.space.layout60",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "64px",
      "darkValue": "64px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/70",
      "dartAccessor": "theme.dimensions.space.layout70",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "104px",
      "darkValue": "104px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/80",
      "dartAccessor": "theme.dimensions.space.layout80",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "168px",
      "darkValue": "168px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/90",
      "dartAccessor": "theme.dimensions.space.layout90",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "272px",
      "darkValue": "272px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.padding/padding-card",
      "dartAccessor": "theme.dimensions.space.paddingPaddingCard",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "space.target/l",
      "dartAccessor": "theme.dimensions.space.targetL",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "48px",
      "darkValue": "48px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "space.target/m",
      "dartAccessor": "theme.dimensions.space.targetM",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "space.target/s",
      "dartAccessor": "theme.dimensions.space.targetS",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "32px",
      "darkValue": "32px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "space.target/xs",
      "dartAccessor": "theme.dimensions.space.targetXs",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "text.font-family/sans",
      "dartAccessor": "theme.typography.fontFamily.sans",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "String",
      "lightValue": "Sarasa UI J",
      "darkValue": "Sarasa UI J",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/body",
      "dartAccessor": "theme.typography.fontSize.body",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/caption/m",
      "dartAccessor": "theme.typography.fontSize.captionM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "14px",
      "darkValue": "14px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/caption/s",
      "dartAccessor": "theme.typography.fontSize.captionS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/l",
      "dartAccessor": "theme.typography.fontSize.headingL",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/m",
      "dartAccessor": "theme.typography.fontSize.headingM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "25px",
      "darkValue": "25px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/s",
      "dartAccessor": "theme.typography.fontSize.headingS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "22px",
      "darkValue": "22px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xl",
      "dartAccessor": "theme.typography.fontSize.headingXl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "32px",
      "darkValue": "32px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xs",
      "dartAccessor": "theme.typography.fontSize.headingXs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "20px",
      "darkValue": "20px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxl",
      "dartAccessor": "theme.typography.fontSize.headingXxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "36px",
      "darkValue": "36px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxs",
      "dartAccessor": "theme.typography.fontSize.headingXxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "18px",
      "darkValue": "18px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxxl",
      "dartAccessor": "theme.typography.fontSize.headingXxxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxxs",
      "dartAccessor": "theme.typography.fontSize.headingXxxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "14px",
      "darkValue": "14px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/paragraph",
      "dartAccessor": "theme.typography.fontSize.paragraph",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-weight/bold",
      "dartAccessor": "theme.typography.fontWeight.bold",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "FontWeight",
      "lightValue": "700",
      "darkValue": "700",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-weight/regular",
      "dartAccessor": "theme.typography.fontWeight.regular",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "FontWeight",
      "lightValue": "400",
      "darkValue": "400",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/body",
      "dartAccessor": "theme.typography.lineHeight.body",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/caption/m",
      "dartAccessor": "theme.typography.lineHeight.captionM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "20px",
      "darkValue": "20px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/caption/s",
      "dartAccessor": "theme.typography.lineHeight.captionS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "18px",
      "darkValue": "18px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/l",
      "dartAccessor": "theme.typography.lineHeight.headingL",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "36px",
      "darkValue": "36px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/m",
      "dartAccessor": "theme.typography.lineHeight.headingM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "32px",
      "darkValue": "32px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/s",
      "dartAccessor": "theme.typography.lineHeight.headingS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xl",
      "dartAccessor": "theme.typography.lineHeight.headingXl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xs",
      "dartAccessor": "theme.typography.lineHeight.headingXs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxl",
      "dartAccessor": "theme.typography.lineHeight.headingXxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "44px",
      "darkValue": "44px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxs",
      "dartAccessor": "theme.typography.lineHeight.headingXxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxxl",
      "dartAccessor": "theme.typography.lineHeight.headingXxxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "52px",
      "darkValue": "52px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxxs",
      "dartAccessor": "theme.typography.lineHeight.headingXxxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "20px",
      "darkValue": "20px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/paragraph",
      "dartAccessor": "theme.typography.lineHeight.paragraph",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    }
  ]
}''';
