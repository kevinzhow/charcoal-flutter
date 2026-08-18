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

const Map<String, ComponentMetadata> componentMetadata = <String, ComponentMetadata>{
  'CharcoalTheme': ComponentMetadata(
    category: 'Foundation',
    summary: 'Propagates one coherent Charcoal token set through a Widgets-layer subtree.',
    keywords: <String>[
      'dark theme',
      'inherited theme',
      'light theme',
      'scoped theme',
      'semantic tokens',
      'theme data',
    ],
    useWhen: <String>[
      'A package-level subtree needs Charcoal colors, dimensions, typography, and brightness without Material or Cupertino dependencies.',
      'An isolated specimen or audited section needs one scoped token override while the rest of the application keeps its current theme.',
    ],
    avoidWhen: <String>[
      'CharcoalApp already owns the application root; pass lightTheme, darkTheme, and themeMode there instead of adding a duplicate root wrapper.',
      'One component needs an ad hoc visual tweak; prefer its semantic API or a narrowly audited token override rather than nesting themes throughout the tree.',
      'Only brightness is changing while colors and typography remain from another mode; construct a coherent light or dark data set instead.',
      'User preference persistence or platform-mode observation is required; those remain application state owned by CharcoalApp and its caller.',
    ],
    accessibility: <String>[
      'The theme adds no semantics by itself; components remain responsible for labels, roles, states, focus, and feedback.',
      'Any custom token set must preserve readable color relationships and perceivable interaction states in every supported mode.',
      'Keep ambient MediaQuery text scaling, reduced motion, directionality, and platform accessibility settings outside the token object intact.',
    ],
    responsiveBehavior: <String>[
      'CharcoalTheme owns no layout; descendants resolve dimensions and typography from the nearest scoped data.',
      'As an InheritedTheme it is captured across framework overlay boundaries so menus, dialogs, and other captured subtrees retain the exact scope.',
      'Replace data atomically when a mode or scoped override changes so all dependents rebuild from one consistent frame.',
    ],
    interactionStates: <String>[
      'light data',
      'dark data',
      'scoped override',
      'captured overlay',
      'data replacement',
    ],
    feedbackResponsibilities: <String>[
      'Owns dependency propagation and captured-theme continuity for colors, dimensions, typography, and brightness.',
      'The caller owns mode selection, preference persistence, system observation, override audits, and any transition between data sets.',
    ],
    tokenRoles: <String>[
      'backgroundDefault',
      'textDefault',
      'space.layout40',
      'text.font-family/sans',
    ],
    relatedComponents: <String>[
      'CharcoalApp',
      'CharcoalTypography',
      'CharcoalTextEllipsis',
    ],
    companionDeclarations: <String>['CharcoalThemeData'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'theme-scoped-typography',
        title: 'Scoped coherent light and dark token sets',
        description: 'Replaces one complete scoped theme while semantic and numeric typography resolve from the same frame.',
        sourcePath: 'example/lib/agent_examples/theme_typography_example.dart',
      ),
    ],
  ),
  'CharcoalTypography': ComponentMetadata(
    category: 'Content',
    summary: 'Applies Charcoal’s audited numeric component type scale without suppressing ambient text scaling.',
    keywords: <String>[
      'component typography',
      'dynamic type',
      'font size',
      'monospace',
      'numeric type scale',
      'text style',
    ],
    useWhen: <String>[
      'A source-aligned component label needs one of the numeric 10, 12, 14, 16, or 20 styles with regular or bold weight.',
      'A short code-like value needs the upstream single-line monospace variant.',
    ],
    avoidWhen: <String>[
      'A page heading, paragraph, caption, or information hierarchy needs a semantic role; use CharcoalTheme.of(context).textStyles instead.',
      'Text has a product-specific visual style unrelated to a reviewed Charcoal component; compose an audited TextStyle from semantic theme roles.',
      'Content must remain multiline while monospace is true; the upstream monospace variant is deliberately single-line.',
    ],
    accessibility: <String>[
      'Ambient MediaQuery text scaling remains active; never pre-scale fontSize or wrap the subtree in a fixed TextScaler.',
      'singleLine and monospace truncate visually, so keep the complete spoken label available and provide a visible route to essential hidden content.',
      'Choose color from a semantic text role that remains readable on the actual surface instead of selecting a raw palette value.',
    ],
    responsiveBehavior: <String>[
      'The authored font and line measurements remain 10/18, 12/20, 14/22, 16/24, and 20/28 before ambient scaling.',
      'Multiline proportional text wraps within parent constraints; singleLine and monospace use one-line ellipsis.',
      'textAlign follows ambient directionality, including start and end behavior in RTL.',
    ],
    interactionStates: <String>[
      'regular',
      'bold',
      'proportional multiline',
      'proportional single-line',
      'monospace single-line',
      'scaled text',
      'RTL',
    ],
    feedbackResponsibilities: <String>[
      'Owns numeric component font size, line height, weight, runtime family mapping, wrapping mode, and inherited alignment.',
      'The caller owns semantic hierarchy, copy, localization, surface color selection, truncation recovery, and content changes.',
    ],
    tokenRoles: <String>[
      'text.font-family/sans',
      'text.font-weight/regular',
      'text.font-weight/bold',
      'textDefaultText1',
    ],
    relatedComponents: <String>[
      'CharcoalTheme',
      'CharcoalTextEllipsis',
      'CharcoalFieldLabel',
    ],
    companionDeclarations: <String>[
      'CharcoalTypographySize',
      'CharcoalTypographyWeight',
      'charcoalTypographyStyle',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'typography-semantic-and-numeric',
        title: 'Semantic hierarchy with a numeric component label',
        description: 'Keeps page hierarchy on semantic theme styles while a reviewed component label uses the numeric scale.',
        sourcePath: 'example/lib/agent_examples/theme_typography_example.dart',
      ),
    ],
  ),
  'CharcoalTextEllipsis': ComponentMetadata(
    category: 'Content',
    summary:
        'Truncates plain text to a positive line limit while preserving complete spoken content.',
    keywords: <String>[
      'clamp text',
      'ellipsis',
      'line limit',
      'multiline truncation',
      'overflow text',
      'truncate label',
    ],
    useWhen: <String>[
      'A known plain-text label or summary must reserve one or more lines inside a constrained card, row, or grid item.',
      'The complete string remains available to accessibility and the product provides visible detail elsewhere when the hidden portion is essential.',
    ],
    avoidWhen: <String>[
      'The complete text is required to make a decision and no visible expansion, detail page, or other recovery exists.',
      'Rich text, inline actions, selectable content, or editable input must be truncated; use the owning text composition instead.',
      'A tooltip should appear automatically only when overflow occurs; this wrapper deliberately does not measure or add overlay behavior.',
    ],
    accessibility: <String>[
      'Without semanticLabel, Flutter exposes the complete data string even when pixels are ellipsized.',
      'Use a non-empty semanticLabel only to add spoken context, not to replace meaningful visible content with unrelated wording.',
      'For essential hidden text, provide a visible disclosure or destination for pointer, touch, keyboard, and assistive users.',
    ],
    responsiveBehavior: <String>[
      'The parent supplies available width; maxLines stays positive and soft wrapping fills each line before the terminal ellipsis.',
      'Ambient text scaling may cause earlier truncation without changing the line contract.',
      'Text alignment and ellipsis placement follow ambient LTR or RTL directionality.',
    ],
    interactionStates: <String>[
      'untruncated',
      'single-line truncated',
      'multiline truncated',
      'scaled text',
      'RTL',
      'semantic override',
    ],
    feedbackResponsibilities: <String>[
      'Owns plain-text line clamping, ellipsis, wrapping, alignment, and optional spoken-label forwarding.',
      'The caller owns width, typography, localization, deciding whether truncation is acceptable, and access to essential full content.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalTypography',
      'CharcoalTooltip',
      'CharcoalTextField',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'text-ellipsis-project-title',
        title: 'Scaled multiline project title',
        description:
            'Limits a long localized title to two lines while retaining its complete spoken form.',
        sourcePath: 'example/lib/agent_examples/theme_typography_example.dart',
      ),
    ],
  ),
  'CharcoalApp': ComponentMetadata(
    category: 'Application',
    summary: 'Hosts a Charcoal application with Navigator or Router navigation and shared platform infrastructure.',
    keywords: <String>[
      'app shell',
      'declarative routing',
      'localization',
      'navigator',
      'restoration',
      'router',
      'theme',
    ],
    useWhen: <String>[
      'A standalone Flutter application needs Charcoal theme, navigation, localization, shortcuts, and restoration at its root.',
      'Declarative routing or deep links need the same Charcoal infrastructure as imperative Navigator routes.',
    ],
    avoidWhen: <String>[
      'Only a subtree needs a theme override; wrap that subtree in CharcoalTheme instead.',
      'A nested flow needs its own Navigator; keep the application shell at the root and add a nested Navigator locally.',
    ],
    accessibility: <String>[
      'Pass localization delegates and supported locales so framework and product labels resolve from the active locale.',
      'Verify the complete application with platform assistive technology instead of treating the app shell as an accessibility substitute.',
    ],
    responsiveBehavior: <String>[
      'The default ScrollBehavior follows Flutter platform conventions and can be replaced at the application boundary.',
      'Shortcuts and actions apply to the complete app so touch, pointer, and keyboard paths share destination state.',
      'Use the builder above Navigator or Router for app-wide responsive policy rather than replacing route identity.',
    ],
    interactionStates: <String>[
      'light',
      'dark',
      'restoring',
    ],
    feedbackResponsibilities: <String>[
      'Owns the effective theme, root scroll policy, Hero controller, locale, shortcuts, and restoration scope.',
      'The application owns route definitions, deep-link parsing, durable destination state, and product localization resources.',
    ],
    tokenRoles: <String>['backgroundDefault', 'containerPrimaryDefault', 'textDefault'],
    relatedComponents: <String>[
      'CharcoalPageRoute',
      'CharcoalTheme',
      'CharcoalNavigationBar',
      'CharcoalTabBar',
    ],
    companionDeclarations: <String>['CharcoalThemeMode'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'app-router',
        title: 'Router-backed application shell',
        description: 'Installs a declarative Router with Charcoal theme, localization, scrolling, shortcuts, and restoration infrastructure.',
        sourcePath: 'example/lib/agent_examples/app_example.dart',
      ),
    ],
  ),
  'CharcoalPageRoute': ComponentMetadata(
    category: 'Navigation',
    summary: 'Pushes an opaque Charcoal page with native iOS edge-back and Android predictive-back behavior.',
    keywords: <String>[
      'android predictive back',
      'back gesture',
      'ios swipe back',
      'navigation',
      'page route',
      'route transition',
    ],
    useWhen: <String>[
      'A detail, drill-in, or transient task belongs on a real Navigator stack.',
      'The page must preserve Charcoal motion while honoring native platform back gestures.',
    ],
    avoidWhen: <String>[
      'A top-level destination is changing; update the stable app-shell owner without pushing a route.',
      'The task is a bounded dialog or sheet; use showCharcoalModal instead.',
    ],
    accessibility: <String>[
      'Use PopScope.canPop to publish guarded navigation state before a platform gesture begins.',
      'Fullscreen dialogs and blocked routes do not expose an interactive iOS back gesture.',
      'The route scopes page semantics while the caller remains responsible for an explicit back action.',
    ],
    responsiveBehavior: <String>[
      'Native iOS uses a leading-edge interactive transition and respects RTL directionality.',
      'Native Android consumes predictive-back progress from either system edge.',
      'Android hosts set android:enableOnBackInvokedCallback="true" on the application or activity.',
      'Web and desktop platforms retain opaque Charcoal shared-axis motion without installing mobile edge gestures.',
    ],
    interactionStates: <String>[
      'entering',
      'active',
      'back gesture started',
      'back gesture updating',
      'back gesture cancelled',
      'back gesture committed',
      'exiting',
    ],
    feedbackResponsibilities: <String>[
      'Owns page motion, gesture progress, cancellation recovery, and committed Navigator pop.',
      'The caller owns route-stack state, unsaved-change guards, and durable completion semantics.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalApp',
      'CharcoalNavigationBar',
      'CharcoalTabBar',
    ],
    companionDeclarations: <String>['CharcoalPageTransitionAxis'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'page-route-platform-back',
        title: 'Platform-adaptive detail route',
        description: 'Pushes a real detail page whose back interaction follows iOS and Android platform gestures.',
        sourcePath: 'example/lib/agent_examples/page_route_example.dart',
      ),
    ],
  ),
  'CharcoalButton': ComponentMetadata(
    category: 'Actions',
    summary: 'Runs an action with Charcoal interaction states, sizing, and visual variants.',
    keywords: <String>['action', 'button', 'call to action', 'cta', 'submit'],
    useWhen: <String>[
      'The user initiates an immediate action such as saving, continuing, or deleting.',
      'A leading or trailing icon needs to remain aligned with a text label.',
    ],
    avoidWhen: <String>[
      'Navigation is better represented by CharcoalNavigationItem.',
      'The action should look like inline text; use CharcoalLinkButton instead.',
    ],
    accessibility: <String>[
      'Pass semanticLabel when child content does not describe the action on its own.',
      'Leave selected null for a regular action; pass false or true only for a controlled toggle that must expose explicit selection semantics.',
      'A null onPressed value exposes the disabled state and removes interaction.',
    ],
    responsiveBehavior: <String>[
      'Set fullWidth on compact layouts when the action should fill its parent constraint.',
      'Let the parent choose available width; do not hard-code the component height.',
    ],
    interactionStates: <String>['idle', 'hovered', 'focused', 'pressed', 'selected', 'disabled'],
    feedbackResponsibilities: <String>[
      'Owns pointer, focus, pressed, selected, and disabled presentation.',
      'The caller owns progress, success, failure, recovery, and the durable action result.',
    ],
    tokenRoles: <String>[
      'space.targetS',
      'space.targetM',
      'space.component10',
      'space.component30',
      'space.component40',
      'radius.oval',
    ],
    relatedComponents: <String>['CharcoalIconButton', 'CharcoalLinkButton'],
    companionDeclarations: <String>['CharcoalButtonVariant', 'CharcoalButtonSize'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'button-basic',
        title: 'Primary and secondary actions',
        description: 'A compact action row that becomes full-width when constrained.',
        sourcePath: 'example/lib/agent_examples/button_example.dart',
      ),
    ],
  ),
  'CharcoalClickable': ComponentMetadata(
    category: 'Actions',
    summary: 'Supplies platform-aware pointer, keyboard, focus, semantics, and state plumbing for an audited custom control.',
    keywords: <String>[
      'custom control',
      'focus',
      'interaction primitive',
      'keyboard activation',
      'pressed state',
      'whole surface action',
    ],
    useWhen: <String>[
      'Component and pattern discovery found no higher-level Charcoal control and one custom surface must act as a single action.',
      'A design-system maintainer is implementing a reusable Charcoal control that needs the shared interaction and semantics lifecycle.',
    ],
    avoidWhen: <String>[
      'A Charcoal button, icon button, selection control, navigation item, tab, tag, pagination item, or carousel affordance already expresses the interaction.',
      'The surface contains multiple independent actions; keep those controls separate instead of nesting them under one clickable region.',
      'Only hover styling or layout is needed; use Flutter layout and pointer primitives without inventing an action role.',
    ],
    accessibility: <String>[
      'Set semanticButton, semanticRole, checked, toggled, selected, expanded, and validationResult to describe the actual control rather than its visual shape.',
      'Provide semanticLabel when visible descendants do not form one clear action label, and never hide meaningful state only in decoration.',
      'Default keyboard activation follows ambient Flutter platform conventions; set keyboardActivationEnabled false only when an owning composite handles and tests the complete key map.',
      'Render an unmistakable focus state and a bounded pressed response without moving, resizing, or replacing the control.',
    ],
    responsiveBehavior: <String>[
      'CharcoalClickable intentionally owns no geometry or color; the authored control must enforce a suitable semantic target and use role-appropriate tokens.',
      'Keep target bounds, child alignment, and text baselines stable through pointer down, cancellation, keyboard activation, focus, hover, selection, and disablement.',
      'Let labels wrap or truncate according to the authored component contract and verify supported text scaling and compact constraints.',
    ],
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'pointer pressed',
      'keyboard pressed',
      'selected',
      'checked',
      'toggled',
      'expanded',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns state dispatch, pointer cancellation, platform keyboard intents, a perceivable keyboard press pulse, focus visibility, cursor, and semantics actions.',
      'The builder owns all visual geometry and state styling; the caller owns controlled values, action progress, failure, recovery, and durable results.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalButton',
      'CharcoalIconButton',
      'CharcoalNavigationItem',
      'CharcoalCheckbox',
      'CharcoalTabBar',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'clickable-whole-surface-action',
        title: 'Audited whole-surface action',
        description: 'Uses the interaction primitive only after higher-level controls cannot express a single custom project surface.',
        sourcePath: 'example/lib/agent_examples/clickable_example.dart',
      ),
    ],
  ),
  'CharcoalIconButton': ComponentMetadata(
    category: 'Actions',
    summary:
        'Runs a compact icon-only action or controlled toggle with explicit accessible naming.',
    keywords: <String>[
      'icon action',
      'icon button',
      'toolbar action',
      'toggle action',
    ],
    useWhen: <String>[
      'A familiar icon represents a compact action in a navigation bar, toolbar, card, or overlay.',
      'An icon-only toggle such as save, like, visibility, or mute has one parent-owned selected value.',
    ],
    avoidWhen: <String>[
      'The icon is ambiguous or the action is primary; use a labeled CharcoalButton.',
      'The action can be expressed clearly as low-emphasis text; use CharcoalLinkButton.',
    ],
    accessibility: <String>[
      'Provide semanticLabel for the action unless the icon supplies an equally clear semantic name.',
      'Update semanticLabel when a toggle changes so it continues to describe the next action, such as Save item and Remove saved item.',
      'Leave selected null for a regular action; pass false or true for a controlled toggle so both states are explicit.',
      'A null onPressed value exposes the disabled state and removes pointer and keyboard activation.',
    ],
    responsiveBehavior: <String>[
      'Use medium for standalone mobile actions; smaller source-authored sizes are dense secondary affordances and require audited target separation.',
      'The icon stays centered in fixed 20, 32, or 40 logical-pixel circular geometry.',
      'Use the overlay variant only when the control sits on imagery or another authored on-image surface.',
    ],
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'pressed',
      'selected',
      'unselected',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns pointer, keyboard, focus, pressed, selected, disabled, normal-surface, and overlay-surface presentation.',
      'Reports activation without mutating the toggle value; the caller owns atomic state, action progress, failure, recovery, and durable results.',
    ],
    tokenRoles: <String>[
      'space.targetS',
      'space.targetM',
      'radius.oval',
      'containerHoverA',
      'containerPressA',
      'containerOnImgDefault',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalButton',
      'CharcoalLinkButton',
      'CharcoalTooltip',
      'CharcoalNavigationBar',
    ],
    companionDeclarations: <String>[
      'CharcoalIconButtonVariant',
      'CharcoalIconButtonSize',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'icon-button-actions',
        title: 'Named icon actions and toggle',
        description: 'Separates a one-shot icon action from a parent-owned save toggle with action-oriented labels.',
        sourcePath: 'example/lib/agent_examples/action_controls_example.dart',
      ),
    ],
  ),
  'CharcoalLinkButton': ComponentMetadata(
    category: 'Actions',
    summary:
        'Runs a low-emphasis text action with intrinsic width and a stable interaction target.',
    keywords: <String>[
      'clear action',
      'link button',
      'low emphasis action',
      'text action',
    ],
    useWhen: <String>[
      'A secondary action such as Clear, Skip, Cancel, or Learn more should remain text-only.',
      'A compact action needs button behavior without a filled background.',
    ],
    avoidWhen: <String>[
      'The text opens a web URL or document link; use a real link semantic and platform navigation behavior.',
      'The action is primary, destructive, or needs an icon; use CharcoalButton.',
    ],
    accessibility: <String>[
      'Use concise visible action text; semanticLabel is only needed when that text lacks necessary context.',
      'The component intentionally exposes button rather than link semantics because onPressed runs an application action.',
      'A null onPressed value exposes disabled state and removes pointer and keyboard activation.',
    ],
    responsiveBehavior: <String>[
      'The component stays intrinsic-width in loose layouts and honors a tight width supplied by its parent.',
      'Its source-authored 40 logical-pixel minimum height remains stable while text scales vertically when needed.',
    ],
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'pressed',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns text color, focus, pressed, disabled, keyboard, and pointer presentation.',
      'The caller owns progress, success, failure, navigation effects, and durable action results.',
    ],
    tokenRoles: <String>[
      'space.targetM',
      'space.component30',
      'radius.s',
      'textDefault',
      'textHover',
      'textTertiaryDefault',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalButton',
      'CharcoalIconButton',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'link-button-action',
        title: 'Low-emphasis text action',
        description:
            'Runs a clear action without turning application behavior into hyperlink semantics.',
        sourcePath: 'example/lib/agent_examples/action_controls_example.dart',
      ),
    ],
  ),
  'CharcoalSwitchingButton': ComponentMetadata(
    category: 'Actions',
    summary: 'Keeps two action variants at one stable size while exposing only the active button.',
    keywords: <String>[
      'action state',
      'follow button',
      'stable button size',
      'swap action',
      'switching button',
    ],
    useWhen: <String>[
      'One location alternates between two complete Charcoal buttons, such as Follow and Unfollow, and must reserve the larger geometry before state changes.',
      'Each state has its own action label, callback, visual variant, and focus presentation while the parent owns one boolean value.',
    ],
    avoidWhen: <String>[
      'The control changes one setting and should expose switch semantics; use CharcoalSwitch.',
      'One button remains the same action while progress is pending; keep that action disabled or place it under CharcoalSpinnerOverlay.',
      'More than two states or non-button content must change; model the state explicitly in normal layout instead.',
    ],
    accessibility: <String>[
      'Give each button an action-oriented label that describes what activation does next, not only the current state.',
      'Only the visible branch participates in semantics and keyboard focus; the wrapper deliberately adds no anonymous toggle node.',
      'Use selected on the child button only when the action itself is a controlled toggle; switching layout alone is not selection semantics.',
    ],
    responsiveBehavior: <String>[
      'The wrapper always takes the maximum width and height of both registered buttons so state changes do not shift surrounding layout.',
      'Both labels participate in layout under ambient text scaling; verify the larger translated label at the narrowest supported constraint.',
      'Hidden branches retain widget state but stop ticking animations until selected again.',
    ],
    interactionStates: <String>[
      'off action visible',
      'on action visible',
      'visible action focused',
      'visible action pressed',
      'visible action disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns stable maximum geometry plus active-branch painting, focus, semantics, and ticker visibility.',
      'Each child owns its button visuals and activation; the caller owns the boolean value, pending work, failure, recovery, and durable result.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalButton',
      'CharcoalSwitch',
      'CharcoalSpinnerOverlay',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'switching-button-publish-state',
        title: 'Stable publish and unpublish actions',
        description: 'Keeps the two action variants stable while asynchronous progress and durable state remain caller-owned.',
        sourcePath: 'example/lib/agent_examples/async_action_example.dart',
      ),
    ],
  ),
  'CharcoalFieldLabel': ComponentMetadata(
    category: 'Forms',
    summary: 'Composes visible field naming, required copy, and trailing metadata without owning input semantics.',
    keywords: <String>[
      'character count',
      'field label',
      'form metadata',
      'required marker',
      'sub label',
      'visible label',
    ],
    useWhen: <String>[
      'A custom form composition needs a visible label plus localized required copy or trailing metadata such as a character count.',
      'The associated control already exposes its own semantic label, required state, validation, and value.',
    ],
    avoidWhen: <String>[
      'CharcoalTextField or CharcoalTextArea can render the same label through showLabel; prefer that owned composition.',
      'A semantic association with an input is missing; visible text does not label a custom control by itself.',
      'The copy is validation, correction, or general advice; use the field assistiveText API or CharcoalHintText as appropriate.',
      'The content is a section heading rather than form metadata; use CharcoalTypography.',
    ],
    accessibility: <String>[
      'Pass the same label to the associated input semantics; this component deliberately owns only visible hierarchy.',
      'When required is true, localize requiredText and also expose required on the associated form control.',
      'Keep subLabel supplementary because it may truncate or move to a following line under constrained layouts.',
      'Do not repeat validation in requiredText or subLabel; keep one actionable correction beside the affected field.',
    ],
    responsiveBehavior: <String>[
      'With sufficient width, the label and required copy stay leading while subLabel remains directionally trailing.',
      'When available width becomes insufficient relative to text scaling, required copy and subLabel move onto additional lines instead of overflowing.',
      'Wide layouts retain the compact source row even with enlarged text when the content still fits.',
      'Logical reading order remains label, required copy, then supplementary metadata in LTR and RTL.',
    ],
    interactionStates: <String>[
      'label only',
      'required',
      'with sub-label',
      'compact',
      'scaled text',
      'RTL',
    ],
    feedbackResponsibilities: <String>[
      'Owns visible label typography, required copy, supplementary metadata, truncation, and responsive line arrangement.',
      'The associated control owns semantic labeling, required and invalid state, focus, value, correction, and submission feedback.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'space.component20',
      'textDefaultText1',
      'textSecondaryDefault',
      'textTertiaryDefault',
    ],
    relatedComponents: <String>[
      'CharcoalTextField',
      'CharcoalTextArea',
      'CharcoalHintText',
      'CharcoalTypography',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'field-label-visible-form-metadata',
        title: 'Visible field metadata with semantic input ownership',
        description: 'Keeps required and trailing metadata visible while the associated input owns required semantics and value.',
        sourcePath: 'example/lib/agent_examples/form_guidance_example.dart',
      ),
    ],
  ),
  'CharcoalTextField': ComponentMetadata(
    category: 'Forms',
    summary: 'Collects a single line of text with Charcoal labels, validation, and assistive text.',
    keywords: <String>['field', 'form', 'input', 'text entry', 'validation'],
    useWhen: <String>[
      'A form needs a single-line text value.',
      'The field needs a visible label, validation state, or assistive message.',
    ],
    avoidWhen: <String>[
      'The value spans multiple lines; use CharcoalTextArea.',
      'The value comes from a fixed option set; use CharcoalDropdown.',
    ],
    accessibility: <String>[
      'Use a meaningful label and keep it visible for forms that need persistent context.',
      'Pair invalid with assistiveText; the field exposes both the invalid result and correction as input semantics.',
      'Set required only when the value is mandatory; the same state is exposed visually and to assistive technology.',
      'Provide localized requiredText when the visible required marker includes copy.',
    ],
    responsiveBehavior: <String>[
      'The field expands to the width supplied by its parent.',
      'Constrain forms to a readable width on desktop instead of sizing the field directly.',
    ],
    interactionStates: <String>['empty', 'editing', 'focused', 'invalid', 'disabled'],
    feedbackResponsibilities: <String>[
      'Owns focus, invalid, assistive-text, and disabled presentation exposed by its API.',
      'The caller owns validation timing, submission progress, persistence, and recovery.',
    ],
    tokenRoles: <String>[
      'space.component20',
      'radius.s',
      'containerSecondaryDefaultA',
      'borderFocusLegacy',
      'borderNegative',
    ],
    relatedComponents: <String>['CharcoalTextArea', 'CharcoalFieldLabel', 'CharcoalHintText'],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'text-field-validation',
        title: 'Labeled text field',
        description: 'A controlled account-name field with validation guidance.',
        sourcePath: 'example/lib/agent_examples/text_field_example.dart',
      ),
    ],
  ),
  'CharcoalTextArea': ComponentMetadata(
    category: 'Forms',
    summary: 'Collects fixed-row multiline text with labels, validation, and character guidance.',
    keywords: <String>['description', 'form', 'long text', 'multiline', 'text area', 'validation'],
    useWhen: <String>[
      'A form value needs multiple visible lines, such as a description, message, or report.',
      'The value benefits from a character count or a stable row count while editing.',
    ],
    avoidWhen: <String>[
      'The value is naturally a single line; use CharcoalTextField.',
      'The value comes from a fixed option set; use CharcoalDropdown or CharcoalMultiSelect.',
    ],
    accessibility: <String>[
      'Use a meaningful label and set required only when the multiline value is mandatory.',
      'Pair invalid with assistiveText; the area exposes multiline, required, invalid, and correction semantics.',
      'Keep the assistive message actionable instead of repeating that the value is invalid.',
      'Provide localized requiredText when the visible required marker includes copy.',
    ],
    responsiveBehavior: <String>[
      'The area expands to the width supplied by its parent and scales row height with the system text size.',
      'Constrain long-form editors to a readable width on desktop rather than hard-coding the component width.',
    ],
    interactionStates: <String>[
      'empty',
      'editing',
      'focused',
      'hovered',
      'pressed',
      'invalid',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns multiline editing, character-count, focus, invalid, assistive-text, and disabled presentation.',
      'The caller owns validation timing, submission progress, persistence, and recovery.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'space.component20',
      'radius.s',
      'containerSecondaryDefaultA',
      'borderFocusLegacy',
      'borderNegative',
    ],
    relatedComponents: <String>[
      'CharcoalTextField',
      'CharcoalFieldLabel',
      'CharcoalHintText',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'text-area-validation',
        title: 'Validated multiline description',
        description: 'A controlled description area with character guidance and actionable invalid feedback.',
        sourcePath: 'example/lib/agent_examples/text_area_example.dart',
      ),
    ],
  ),
  'CharcoalCheckbox': ComponentMetadata(
    category: 'Forms',
    summary: 'Toggles one independent boolean choice in a controlled form or checklist.',
    keywords: <String>[
      'boolean input',
      'checkbox',
      'checklist',
      'consent',
      'multiple choice',
    ],
    useWhen: <String>[
      'One or more independent choices may each be turned on or off.',
      'A form needs an explicit acknowledgement or optional inclusion choice.',
    ],
    avoidWhen: <String>[
      'Exactly one option in a group may be selected; use CharcoalRadio.',
      'A setting takes effect immediately outside form submission; use CharcoalSwitch.',
    ],
    accessibility: <String>[
      'Provide a visible label, or semanticLabel when the surrounding content already supplies the visible name.',
      'Checked, disabled, and invalid states are exposed through input semantics.',
      'When invalid is true, place an actionable correction beside the checkbox or its form group.',
    ],
    responsiveBehavior: <String>[
      'The source-authored 20-pixel indicator remains fixed while a text label wraps within parent constraints.',
      'Let the surrounding form provide readable width and sufficient separation between stacked choices.',
    ],
    interactionStates: <String>[
      'unchecked',
      'checked',
      'hovered',
      'focused',
      'pressed',
      'invalid',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns indicator, pointer, focus, checked, invalid, and disabled presentation.',
      'Reports the proposed inverse value; the caller owns controlled state, validation timing, persistence, and recovery.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'radius.s',
      'radius.oval',
      'containerPrimaryDefault',
      'borderDefault',
      'borderFocusLegacy',
      'borderNegative',
    ],
    relatedComponents: <String>[
      'CharcoalRadio',
      'CharcoalSwitch',
      'CharcoalMultiSelect',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'checkbox-controlled',
        title: 'Independent controlled choice',
        description: 'Keeps an optional form choice in parent-owned state alongside related selection controls.',
        sourcePath: 'example/lib/agent_examples/selection_controls_example.dart',
      ),
    ],
  ),
  'CharcoalMultiSelect': ComponentMetadata(
    category: 'Forms',
    summary: 'Toggles one option in a visibly named, parent-controlled multi-selection group.',
    keywords: <String>[
      'batch selection',
      'collection selection',
      'media selection',
      'multiple choice',
      'multi select',
    ],
    useWhen: <String>[
      'Several related options may be selected independently and the caller owns one selected value set.',
      'A collection or media surface needs Charcoal\'s circular multi-selection indicator, including the overlay treatment over artwork.',
    ],
    avoidWhen: <String>[
      'One independent boolean form choice or acknowledgement is needed; use CharcoalCheckbox.',
      'Exactly one value may be selected; use CharcoalRadio, CharcoalSegmentedControl, or CharcoalDropdown.',
      'A collapsed searchable multi-value picker is required; this option component does not own a popup, search, chips, or select-all behavior.',
    ],
    accessibility: <String>[
      'Give every option a visible label, or semanticLabel when an artwork overlay already provides the visible context.',
      'Place related options in one visibly and semantically named group; keep each option as an explicit semantic child.',
      'Checked, disabled, and invalid states are exposed through input semantics, and Space follows the ambient Flutter activation path.',
      'When the group is invalid, pass invalid to its options and keep one actionable group-level correction visible as a live result.',
    ],
    responsiveBehavior: <String>[
      'The source-authored 20-pixel indicator remains fixed while a text label wraps within parent constraints.',
      'Stack options when labels or text scaling no longer fit a compact horizontal composition.',
      'Use overlay only over media, and do not clip the option row because its HUD, focus, and invalid rings paint outside the indicator.',
    ],
    interactionStates: <String>[
      'unselected',
      'selected',
      'hovered',
      'focused',
      'pressed',
      'invalid',
      'disabled',
      'media overlay',
    ],
    feedbackResponsibilities: <String>[
      'Owns one option\'s pointer, keyboard, focus, checked, invalid, disabled, and overlay presentation.',
      'Reports the proposed inverse value; the caller owns the selected set, group label, validation timing, persistence, and durable result.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'radius.oval',
      'containerPrimaryDefault',
      'containerNeutralDefault',
      'containerOnImgDefault',
      'borderHud',
      'borderFocusLegacy',
      'borderNegative',
      'iconOnPrimaryDefault',
    ],
    relatedComponents: <String>[
      'CharcoalCheckbox',
      'CharcoalRadio',
      'CharcoalDropdown',
      'CharcoalFieldLabel',
    ],
    companionDeclarations: <String>['CharcoalMultiSelectVariant'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'multi-select-controlled-group',
        title: 'Named controlled multi-selection group',
        description: 'Owns one selected set, keeps every option explicit, and exposes actionable group validation.',
        sourcePath: 'example/lib/agent_examples/multi_select_example.dart',
      ),
    ],
  ),
  'CharcoalRadio': ComponentMetadata(
    category: 'Forms',
    summary: 'Selects one controlled value from a mutually exclusive group.',
    keywords: <String>[
      'exclusive choice',
      'option group',
      'radio',
      'single choice',
      'single selection',
    ],
    useWhen: <String>[
      'A short set of choices should remain visible and exactly one value may be selected.',
      'The form benefits from comparing every option before submission.',
    ],
    avoidWhen: <String>[
      'Choices are independent; use CharcoalCheckbox.',
      'The option set is long or needs secondary descriptions; use CharcoalDropdown.',
    ],
    accessibility: <String>[
      'Give every option a distinct visible label and place related radios in one named semantic group.',
      'Each option exposes checked state and mutually exclusive group membership.',
      'When invalid is true, the option exposes invalid input semantics; keep one actionable group-level correction visible.',
    ],
    responsiveBehavior: <String>[
      'The source-authored 20-pixel indicator remains fixed while a text label wraps within parent constraints.',
      'Stack options when labels or text scaling no longer fit a compact horizontal composition.',
    ],
    interactionStates: <String>[
      'unselected',
      'selected',
      'hovered',
      'focused',
      'pressed',
      'invalid',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns option interaction plus selected, focused, invalid, and disabled presentation.',
      'Reports its value without mutating the group; the caller owns the single groupValue, validation, and downstream result.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'radius.oval',
      'containerPrimaryDefault',
      'borderDefault',
      'borderFocusLegacy',
      'borderNegative',
    ],
    relatedComponents: <String>[
      'CharcoalCheckbox',
      'CharcoalDropdown',
      'CharcoalSegmentedControl',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'radio-controlled-group',
        title: 'Named controlled option group',
        description: 'Keeps one audience value in a parent and exposes the related options as a named group.',
        sourcePath: 'example/lib/agent_examples/selection_controls_example.dart',
      ),
    ],
  ),
  'CharcoalSwitch': ComponentMetadata(
    category: 'Forms',
    summary: 'Changes one controlled on/off setting with immediate effect.',
    keywords: <String>[
      'boolean setting',
      'on off',
      'preferences',
      'settings',
      'switch',
      'toggle',
    ],
    useWhen: <String>[
      'A boolean setting takes effect as soon as the user changes it.',
      'The current on or off state must remain visible beside its setting label.',
    ],
    avoidWhen: <String>[
      'The value is accepted as part of a later form submission; use CharcoalCheckbox.',
      'The user chooses exactly one value from several options; use CharcoalRadio or CharcoalDropdown.',
    ],
    accessibility: <String>[
      'Provide a visible label, or semanticLabel when visible context already names the setting.',
      'The control exposes toggled and disabled semantics and supports pointer plus keyboard activation.',
      'A null onChanged value disables interaction without dimming the readable label.',
    ],
    responsiveBehavior: <String>[
      'The native 51 by 31 track remains fixed while the leading label uses the remaining width.',
      'Give long labels a constrained parent so they wrap without displacing the track.',
    ],
    interactionStates: <String>[
      'off',
      'on',
      'hovered',
      'focused',
      'pressed',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns track, thumb, pointer, focus, toggled, and disabled presentation.',
      'Reports the proposed inverse value; the caller owns immediate persistence, failure recovery, and any dependent content.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'space.component20',
      'radius.oval',
      'containerPrimaryDefault',
      'containerNeutralDefault',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalCheckbox',
      'CharcoalRadio',
      'CharcoalSegmentedControl',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'switch-controlled-setting',
        title: 'Immediate controlled setting',
        description:
            'Keeps an immediate notification preference in the same parent-owned settings model.',
        sourcePath: 'example/lib/agent_examples/selection_controls_example.dart',
      ),
    ],
  ),
  'CharcoalDropdown': ComponentMetadata(
    category: 'Forms',
    summary: 'Selects one value from a controlled list using a Charcoal popup menu.',
    keywords: <String>['combobox', 'dropdown', 'menu', 'option', 'select'],
    useWhen: <String>[
      'The user must choose one item from a fixed list that is too long for segmented control.',
      'Secondary option descriptions help distinguish similar choices.',
    ],
    avoidWhen: <String>[
      'Two to four short options benefit from direct visibility; use CharcoalSegmentedControl.',
      'Multiple values may be selected; use CharcoalMultiSelect.',
    ],
    accessibility: <String>[
      'Supply a visible label for form use and keep option labels unique and descriptive.',
      'Disabled options stay discoverable but cannot be selected.',
      'Pair invalid with assistiveText so the trigger announces the invalid result and correction together.',
      'Set required only when a selection is mandatory; the same state is exposed visually and semantically.',
      'Provide localized requiredText when the visible required marker includes copy.',
    ],
    responsiveBehavior: <String>[
      'The popup matches the trigger width and chooses the available vertical direction.',
      'Let the parent constrain trigger width on small and large screens.',
    ],
    interactionStates: <String>[
      'closed',
      'open',
      'focused',
      'selected',
      'invalid',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns popup visibility, option interaction, focus, and disabled option presentation.',
      'The caller owns selected-value persistence and downstream results or validation.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'space.layout30',
      'radius.s',
      'containerSecondaryDefaultA',
    ],
    relatedComponents: <String>['CharcoalMultiSelect', 'CharcoalSegmentedControl'],
    companionDeclarations: <String>['CharcoalDropdownOption'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'dropdown-controlled',
        title: 'Controlled dropdown',
        description: 'A labeled single-selection field whose state is owned by its parent.',
        sourcePath: 'example/lib/agent_examples/dropdown_example.dart',
      ),
    ],
  ),
  'CharcoalSegmentedControl': ComponentMetadata(
    category: 'Selection',
    summary: 'Switches between a small set of mutually exclusive values.',
    keywords: <String>['filter', 'segmented', 'single selection', 'tabs', 'toggle'],
    useWhen: <String>[
      'Two to four short choices should remain visible and immediately selectable.',
      'The choice changes a local view, filter, or compact setting.',
    ],
    avoidWhen: <String>[
      'The choices navigate between major destinations; use navigation components.',
      'The option set is long or labels require descriptions; use CharcoalDropdown.',
    ],
    accessibility: <String>[
      'Provide semanticLabel for the group when surrounding text does not name it.',
      'Each segment exposes checked state within a mutually exclusive group.',
    ],
    responsiveBehavior: <String>[
      'Use fullWidth when compact layouts need equal segments across available width.',
      'Use uniformSegmentWidth for equal fixed segments without filling the parent.',
    ],
    interactionStates: <String>['selected', 'unselected', 'focused', 'disabled'],
    feedbackResponsibilities: <String>[
      'Owns group selection and focus presentation for the controlled value.',
      'The caller owns loading, empty results, and persistence caused by selection.',
    ],
    tokenRoles: <String>[
      'space.targetS',
      'space.component30',
      'radius.xl',
      'containerSecondaryDefaultA',
      'containerPrimaryDefault',
    ],
    relatedComponents: <String>['CharcoalDropdown', 'CharcoalRadio'],
    companionDeclarations: <String>['CharcoalSegment'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'segmented-controlled',
        title: 'Responsive segmented control',
        description: 'A controlled view switcher that fills compact layouts.',
        sourcePath: 'example/lib/agent_examples/segmented_control_example.dart',
      ),
    ],
  ),
  'CharcoalNavigationBar': ComponentMetadata(
    category: 'Navigation',
    summary:
        'Provides page-level title context with balanced leading and trailing navigation slots.',
    keywords: <String>[
      'app bar',
      'back navigation',
      'header',
      'navigation bar',
      'toolbar',
    ],
    useWhen: <String>[
      'A page needs a stable title plus back, close, or contextual actions.',
      'A hierarchical mobile flow needs its current destination to remain visible.',
    ],
    avoidWhen: <String>[
      'The control switches between top-level destinations; use a tab bar or navigation items.',
      'The content only needs a section heading inside the page body.',
    ],
    accessibility: <String>[
      'Keep the title concise; it is exposed as a semantic header.',
      'Give icon-only leading and trailing controls explicit semantic labels.',
    ],
    responsiveBehavior: <String>[
      'The title remains geometrically centered while edge slots contract on narrow widths.',
      'Keep edge actions compact and place system safe-area padding outside the component.',
    ],
    interactionStates: <String>['page context', 'leading action', 'trailing action'],
    feedbackResponsibilities: <String>[
      'Owns title geometry and layout slots but not navigation state.',
      'The caller owns back, close, destination, and contextual-action outcomes.',
    ],
    tokenRoles: <String>[
      'space.targetL',
      'space.component30',
      'borderSecondary',
      'backgroundDefault',
    ],
    relatedComponents: <String>[
      'CharcoalIconButton',
      'CharcoalNavigationItem',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'navigation-bar-detail',
        title: 'Detail navigation bar',
        description: 'A centered destination title with back navigation and one contextual action.',
        sourcePath: 'example/lib/agent_examples/navigation_bar_example.dart',
      ),
    ],
  ),
  'CharcoalNavigationItem': ComponentMetadata(
    category: 'Navigation',
    summary: 'Selects one stable top-level destination in a sidebar, drawer, or navigation list.',
    keywords: <String>[
      'destination',
      'drawer item',
      'navigation item',
      'primary navigation',
      'sidebar',
      'top level navigation',
    ],
    useWhen: <String>[
      'A wide layout exposes stable top-level destinations in a sidebar or drawer.',
      'The selected destination and page content are controlled by one app-shell state owner.',
    ],
    avoidWhen: <String>[
      'The action opens a detail or transient task; push a CharcoalPageRoute instead.',
      'The choice only changes a local filter or compact view; use CharcoalSegmentedControl.',
    ],
    accessibility: <String>[
      'Every enabled item exposes button, focus, and explicit selected or unselected semantics.',
      'Wrap the destination collection in a named navigation semantic region.',
      'Use semanticLabel when icons, badges, or trailing content add meaning not present in the visible label.',
    ],
    responsiveBehavior: <String>[
      'The item fills its parent width and retains a 40 logical-pixel minimum height.',
      'Leading, label, and trailing geometry remains fixed through hover, focus, press, cancellation, and selection.',
      'Move the same controlled destination state to CharcoalTabBar when compact constraints no longer support a sidebar.',
      'Long labels use one-line ellipsis; keep destination names concise and localizable.',
    ],
    interactionStates: <String>[
      'selected',
      'unselected',
      'hovered',
      'focused',
      'pressed',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns persistent selection presentation on one layer and transient hover, focus, and press feedback on another.',
      'Keeps geometry stable and reports activation without mutating routes or destination state.',
      'The caller atomically updates the previous and next selected semantics plus content in the first painted frame.',
      'The caller owns destination state preservation and all detail, task, replacement, pop, and back effects.',
    ],
    tokenRoles: <String>[
      'space.targetM',
      'space.targetXs',
      'space.component20',
      'space.component25',
      'radius.m',
      'containerSecondaryDefault',
      'containerSecondaryHoverA',
      'containerSecondaryPressA',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalTabBar',
      'CharcoalNavigationBar',
      'CharcoalPageRoute',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'navigation-item-adaptive-destinations',
        title: 'Adaptive controlled destinations',
        description: 'Shares one destination owner between a wide sidebar and compact tab bar without changing the route stack.',
        sourcePath: 'example/lib/agent_examples/navigation_item_example.dart',
      ),
    ],
  ),
  'CharcoalTabBar': ComponentMetadata(
    category: 'Navigation',
    summary: 'Switches between stable top-level destinations without owning or mutating the route stack.',
    keywords: <String>[
      'bottom navigation',
      'destination',
      'navigation tabs',
      'primary navigation',
      'tab bar',
    ],
    useWhen: <String>[
      'A compact application exposes two to five stable top-level destinations.',
      'Destination selection must remain controlled by one app-shell state owner.',
    ],
    avoidWhen: <String>[
      'Choices switch a local filter or view; use CharcoalSegmentedControl.',
      'The action opens a detail, task, or durable result; use the app route stack instead.',
    ],
    accessibility: <String>[
      'The bar and its destinations expose tab-bar and tab roles with one explicit selected item.',
      'Use a full semanticLabel when a visible badge adds information to the destination label.',
    ],
    responsiveBehavior: <String>[
      'Destinations share the available width and retain a 64 logical-pixel baseline height.',
      'State layers preserve each destination rectangle plus icon and label alignment; they never loosen the content constraints.',
      'The bar grows for text scaling; use CharcoalNavigationItem when a large layout moves navigation to a sidebar.',
      'Place system safe-area padding in the surrounding app shell.',
    ],
    interactionStates: <String>[
      'selected',
      'unselected',
      'hovered',
      'focused',
      'pressed',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns a touch lifecycle where pointer down paints an independent pressed layer, cancellation has no persistent effect, and an accepted tap reports selection; owns badge rendering.',
      'Commits controlled persistent selection atomically without reusing the transient interaction tween.',
      'Keeps target bounds, icon and label centers, and text baselines invariant across interaction states.',
      'The caller owns one destination state source plus route-stack effects, state preservation, and back behavior.',
    ],
    tokenRoles: <String>[
      'space.layout60',
      'containerSecondaryDefaultA',
      'containerSecondaryHoverA',
      'containerSecondaryPressA',
      'borderFocusLegacy',
      'containerNegativeDefault',
    ],
    relatedComponents: <String>[
      'CharcoalNavigationBar',
      'CharcoalNavigationItem',
      'CharcoalSegmentedControl',
    ],
    companionDeclarations: <String>['CharcoalTabItem'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'tab-bar-controlled',
        title: 'Controlled top-level destinations',
        description: 'A stable destination value updates app-shell content without prescribing a route push.',
        sourcePath: 'example/lib/agent_examples/tab_bar_example.dart',
      ),
    ],
  ),
  'CharcoalCarousel': ComponentMetadata(
    category: 'Navigation',
    summary: 'Presents a short, non-auto-rotating horizontal sequence across touch, pointer, keyboard, and assistive input.',
    keywords: <String>[
      'carousel',
      'featured content',
      'gallery',
      'page indicator',
      'slide',
      'swipe',
    ],
    useWhen: <String>[
      'A short set of related featured, media, or explanatory items benefits from direct swiping and optional neighboring-page context.',
      'The sequence remains meaningful without automatic rotation and the caller can provide a bounded height for every supported layout.',
    ],
    avoidWhen: <String>[
      'The user is moving between stable application destinations; use CharcoalTabBar or CharcoalNavigationItem.',
      'A finite result collection needs direct access to numbered pages; use CharcoalPagination.',
      'A long or unbounded collection must remain simultaneously discoverable; use a scrollable list or gallery instead.',
      'Only one static item exists or essential information would become hidden in an unvisited slide.',
    ],
    accessibility: <String>[
      'Name the carousel region and use semanticLabelBuilder to localize each zero-based slide and indicator position.',
      'Give every image and action inside a slide its own meaningful label; the carousel does not replace child semantics.',
      'Arrow keys follow reading direction, Home and End reach boundaries, indicators expose selection, and unavailable boundary controls leave semantics and focus traversal.',
      'Keyboard focus reveals overlay navigation before focus enters its buttons, so a focused control never becomes visually hidden.',
    ],
    responsiveBehavior: <String>[
      'The parent supplies a bounded height; small shows one full page and indicators, while medium defaults to a partial neighbor and overlay navigation.',
      'Touch and trackpad users swipe the viewport without depending on hover; pointer hover and focus-within reveal desktop navigation.',
      'A long indicator row scrolls horizontally instead of overflowing compact constraints, but keep carousel sequences intentionally short.',
      'Slides, chevrons, and horizontal arrow keys follow ambient LTR or RTL direction.',
    ],
    interactionStates: <String>[
      'idle',
      'dragging',
      'settling',
      'hovered',
      'focus within',
      'current page',
      'first page',
      'last page',
    ],
    feedbackResponsibilities: <String>[
      'Owns viewport motion, the internal current page, selected indicators, boundary availability, and navigation feedback when no controller is supplied.',
      'An external PageController owns the first painted page and viewport fraction; the caller owns that controller lifecycle and observes accepted pages through onPageChanged.',
      'The caller owns slide loading, errors, action outcomes, live page context when needed, routes, and durable product state.',
    ],
    tokenRoles: <String>[
      'space.targetM',
      'space.component20',
      'radius.oval',
      'borderFocusLegacy',
      'borderFocus1',
      'textDefault',
      'textTertiaryDefault',
    ],
    relatedComponents: <String>[
      'CharcoalIconButton',
      'CharcoalPagination',
      'CharcoalTabBar',
    ],
    companionDeclarations: <String>['CharcoalCarouselSize'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'carousel-responsive-featured-guides',
        title: 'Responsive featured guides',
        description: 'Preserves reported page context while the same carousel moves between compact full-page and wide neighboring-page layouts.',
        sourcePath: 'example/lib/agent_examples/carousel_example.dart',
      ),
    ],
  ),
  'CharcoalPagination': ComponentMetadata(
    category: 'Navigation',
    summary: 'Requests a page from a finite ordered collection while the caller owns results and navigation state.',
    keywords: <String>[
      'current page',
      'finite results',
      'next page',
      'page navigation',
      'pagination',
      'previous page',
    ],
    useWhen: <String>[
      'A large ordered result collection has a known page count and users need direct access to nearby or boundary pages.',
      'The current page, loaded results, and optional URL state are controlled by one parent.',
    ],
    avoidWhen: <String>[
      'Content continues without a known page count; use an explicit load-more or infinite-results pattern.',
      'The control advances media or featured content; use CharcoalCarousel.',
      'The choice changes a top-level destination; use CharcoalTabBar or CharcoalNavigationItem.',
    ],
    accessibility: <String>[
      'Give the group and previous and next actions localized semantic labels that describe the paged content.',
      'The current page is selected and non-interactive, available page numbers are buttons, and ellipses are excluded from semantics.',
      'At the first and last page, the unavailable boundary arrow keeps layout space but leaves semantics and keyboard focus order.',
    ],
    responsiveBehavior: <String>[
      'The page window automatically contracts from seven to five to three slots while preserving both boundary pages.',
      'Provide at least two navigation targets plus three page slots; use CharcoalPaginationSize.small in audited dense layouts.',
      'Previous and next chevrons follow ambient LTR or RTL text direction.',
    ],
    interactionStates: <String>[
      'current',
      'available',
      'hovered',
      'focused',
      'pressed',
      'disabled',
      'first page',
      'last page',
    ],
    feedbackResponsibilities: <String>[
      'Owns the visible page window, current-page presentation, boundary visibility, interaction state, and requested one-indexed page.',
      'The caller owns the accepted current page, loading and error feedback, result replacement, scroll or focus restoration, and URL history.',
    ],
    tokenRoles: <String>[
      'space.targetS',
      'space.targetM',
      'radius.oval',
      'containerHudDefault',
      'containerSecondaryDefault',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalCarousel',
      'CharcoalNavigationItem',
      'CharcoalTabBar',
    ],
    companionDeclarations: <String>['CharcoalPaginationSize'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'pagination-controlled-results',
        title: 'Adaptive controlled result pages',
        description: 'Keeps result context and the accepted page in one parent while the page window adapts to compact constraints.',
        sourcePath: 'example/lib/agent_examples/pagination_example.dart',
      ),
    ],
  ),
  'CharcoalTagItem': ComponentMetadata(
    category: 'Selection',
    summary: 'Toggles one compact topic or filter while the caller owns the selected tag set.',
    keywords: <String>[
      'active tag',
      'category filter',
      'compact filter',
      'removable tag',
      'tag',
      'translated tag',
    ],
    useWhen: <String>[
      'A compact topic, category, or search filter needs one whole-surface action and an optional caller-controlled selected state.',
      'A source label benefits from a short translated label or artwork while remaining one semantic control.',
    ],
    avoidWhen: <String>[
      'The value is non-interactive metadata; render text instead of presenting button and selected semantics.',
      'A form needs a named multi-selection group, validation, or a conventional check indicator; use CharcoalMultiSelect.',
      'The trailing icon must run an action independent from the label; use separate, explicitly named controls instead of nesting actions.',
      'The content is an application destination or numbered result page; use CharcoalNavigationItem, CharcoalTabBar, or CharcoalPagination.',
    ],
    accessibility: <String>[
      'Keep status and the selected tag set controlled by one parent; normal and inactive expose selected false, while active exposes selected true.',
      'The active remove icon is decorative and remains part of the tag action, so it never creates a second focus stop or ambiguous nested semantics.',
      'Use semanticLabel when the visual source and translated labels do not clearly identify the tag in context; the default combines both visible labels.',
      'Set onPressed to null only when the complete tag action is unavailable; disabled opacity, focus removal, and semantics stay synchronized.',
    ],
    responsiveBehavior: <String>[
      'Place related tags in Wrap with semantic spacing so each whole tag moves to a new run instead of being split.',
      'Long source and translated labels ellipsize within the component maximum and shrink under compact finite constraints.',
      'Small and medium are baseline heights that grow for accessibility text scaling; a translated label always uses medium.',
      'Directional padding keeps the active icon at the trailing edge in both LTR and RTL layouts.',
    ],
    interactionStates: <String>[
      'normal',
      'active',
      'inactive',
      'hovered',
      'focused',
      'pressed',
      'disabled',
      'translated',
      'image background',
    ],
    feedbackResponsibilities: <String>[
      'Owns selected semantics, the active remove affordance, label truncation, transient interaction colors, focus ring, and disabled presentation.',
      'The caller owns the selected tag set, accepted add or remove outcome, filter results, loading and error feedback, and any route or URL synchronization.',
    ],
    tokenRoles: <String>[
      'space.targetS',
      'space.targetM',
      'space.component20',
      'space.component30',
      'space.component40',
      'radius.s',
      'containerSecondaryDefault',
      'containerOnImgDefault',
      'containerHoverA',
      'containerPressA',
      'textOnPrimaryDefault',
      'textOnOnImgDefault',
      'textSecondaryDefault',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalMultiSelect',
      'CharcoalButton',
      'CharcoalTextEllipsis',
    ],
    companionDeclarations: <String>[
      'CharcoalTagItemSize',
      'CharcoalTagItemStatus',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'tag-item-controlled-filters',
        title: 'Controlled tag filter collection',
        description: 'Keeps one selected set in the parent while translated and compact tags remain whole, reversible actions.',
        sourcePath: 'example/lib/agent_examples/tag_item_example.dart',
      ),
    ],
  ),
  'CharcoalTooltip': ComponentMetadata(
    category: 'Overlays',
    summary: 'Adds brief, non-interactive context to an anchored control across pointer, focus, and touch input.',
    keywords: <String>[
      'anchored help',
      'hover label',
      'tooltip',
      'touch hint',
    ],
    useWhen: <String>[
      'A compact control benefits from a short supplementary label or explanation that is not required to complete the task.',
      'The same brief context must be available from hover, keyboard focus, and touch without changing page layout.',
    ],
    avoidWhen: <String>[
      'The information is essential, corrective, or a validation result; keep it inline with the affected content.',
      'The surface needs interactive content or persistent detail; use CharcoalAnchoredBalloon or a page-level disclosure.',
      'The user must make a blocking decision; use CharcoalDialog.',
    ],
    accessibility: <String>[
      'Keep message concise and ensure the anchor still has its own action label; the message is exposed as tooltip semantics.',
      'Do not place interactive content in a tooltip because the rendered surface intentionally ignores pointer input.',
      'A focus-triggered tooltip dismisses with Escape without moving focus from its anchor.',
    ],
    responsiveBehavior: <String>[
      'The surface wraps within maxWidth, respects screen insets, and follows its anchor while scrolling.',
      'Automatic placement prefers below and then above; set position only when the surrounding composition requires an audited side.',
      'Keep the message short enough to remain supplementary under text scaling instead of turning the tooltip into a reading surface.',
    ],
    interactionStates: <String>[
      'hidden',
      'waiting',
      'hovered',
      'focused',
      'touch triggered',
      'visible',
      'dismissing',
    ],
    feedbackResponsibilities: <String>[
      'Owns delayed presentation, anchor tracking, collision handling, semantic annotation, and dismissal.',
      'The caller owns the anchor action, durable guidance, errors, progress, and results.',
    ],
    tokenRoles: <String>[
      'containerHudDefault',
      'textOnHudDefault',
      'space.component10',
      'space.component25',
      'radius.s',
    ],
    relatedComponents: <String>[
      'CharcoalAnchoredBalloon',
      'CharcoalBalloon',
      'CharcoalHintText',
      'CharcoalIconButton',
    ],
    companionDeclarations: <String>['CharcoalOverlayPosition'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'anchored-overlay-controls',
        title: 'Brief and persistent anchored context',
        description: 'Separates non-interactive tooltip help from persistent and controlled balloon content.',
        sourcePath: 'example/lib/agent_examples/overlay_controls_example.dart',
      ),
    ],
  ),
  'CharcoalBalloon': ComponentMetadata(
    category: 'Overlays',
    summary: 'Renders a persistent speech surface when the caller already owns its layout and directional relationship.',
    keywords: <String>[
      'callout',
      'persistent hint',
      'speech balloon',
    ],
    useWhen: <String>[
      'A short callout must remain visible in an authored layout and point toward nearby content.',
      'The caller already owns placement and optionally needs an action or explicit close affordance.',
    ],
    avoidWhen: <String>[
      'The surface must follow a moving trigger and choose a collision-safe position; use CharcoalAnchoredBalloon.',
      'The message is brief, supplementary, and transient; use CharcoalTooltip.',
      'The content is a blocking task or requires focus containment; use CharcoalDialog.',
    ],
    accessibility: <String>[
      'Provide semanticLabel when the child does not state the callout purpose on its own.',
      'The optional close affordance supports pointer, Tab traversal, Enter, and Space activation with visible focus.',
      'Every action widget owns its label and result; the balloon is a non-modal semantic container.',
    ],
    responsiveBehavior: <String>[
      'Content wraps within maxWidth while component-owned padding and tail geometry remain stable.',
      'Choose position for the authored relationship and use arrowCenter only when the caller has measured the target.',
      'For automatic placement, screen insets, and scroll tracking, use CharcoalAnchoredBalloon.',
    ],
    interactionStates: <String>[
      'visible',
      'action focused',
      'action pressed',
      'close focused',
      'dismissed',
    ],
    feedbackResponsibilities: <String>[
      'Owns surface, tail, readable width, semantic grouping, and close-control interaction feedback.',
      'The caller owns visibility, placement in the surrounding layout, action outcomes, and durable state.',
    ],
    tokenRoles: <String>[
      'containerPrimaryDefault',
      'textOnPrimaryDefault',
      'containerOnImgDefault',
      'space.component25',
      'space.component30',
      'radius.xl',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalAnchoredBalloon',
      'CharcoalTooltip',
      'CharcoalDialog',
    ],
    companionDeclarations: <String>['CharcoalOverlayPosition'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'anchored-overlay-controls',
        title: 'Brief and persistent anchored context',
        description: 'Separates non-interactive tooltip help from persistent and controlled balloon content.',
        sourcePath: 'example/lib/agent_examples/overlay_controls_example.dart',
      ),
    ],
  ),
  'CharcoalAnchoredBalloon': ComponentMetadata(
    category: 'Overlays',
    summary: 'Tracks an anchor and presents persistent details or actions with controlled or internal visibility.',
    keywords: <String>[
      'anchored callout',
      'coach mark',
      'popover',
      'persistent details',
    ],
    useWhen: <String>[
      'An anchor opens persistent explanatory content or a small related action and the surface must follow that anchor.',
      'One parent-owned value must coordinate the trigger label, keyboard activation, outside dismissal, and visible surface.',
    ],
    avoidWhen: <String>[
      'Only a brief non-interactive label is needed; use CharcoalTooltip.',
      'The caller already owns static layout and directional placement; use CharcoalBalloon.',
      'The content is a menu, blocking decision, form, or multi-step task; use the appropriate selection control, dialog, or page.',
    ],
    accessibility: <String>[
      'For an interactive anchor, prefer controlled visibility with showOnTap false and toggle visible from the anchor action so pointer and keyboard activation share one path.',
      'Update the anchor semantic label to describe the next action, such as Show details or Hide details.',
      'Escape dismisses from the focused anchor or a focused balloon action; the close affordance supports keyboard activation.',
      'Do not claim modal focus containment: move blocking or focus-trapped work to CharcoalDialog.',
    ],
    responsiveBehavior: <String>[
      'Placement prefers below, above, right, then left before choosing the largest remaining area.',
      'The surface respects screen insets, wraps within maxWidth, and follows the anchor while it scrolls.',
      'Use dismissOnTapOutside deliberately; persistent teaching content may remain open while contextual details commonly dismiss outside.',
    ],
    interactionStates: <String>[
      'hidden',
      'opening',
      'visible',
      'action focused',
      'closing',
    ],
    feedbackResponsibilities: <String>[
      'Owns anchor tracking, collision-safe placement, presentation motion, close feedback, optional timeout, and dismissal requests.',
      'In controlled usage the caller owns the visible value, trigger activation, dynamic label, action result, and durable state.',
    ],
    tokenRoles: <String>[
      'containerPrimaryDefault',
      'textOnPrimaryDefault',
      'containerOnImgDefault',
      'space.layout30',
      'radius.xl',
      'borderFocusLegacy',
    ],
    relatedComponents: <String>[
      'CharcoalBalloon',
      'CharcoalTooltip',
      'CharcoalButton',
      'CharcoalDialog',
    ],
    companionDeclarations: <String>['CharcoalOverlayPosition'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'anchored-overlay-controls',
        title: 'Brief and persistent anchored context',
        description: 'Separates non-interactive tooltip help from persistent and controlled balloon content.',
        sourcePath: 'example/lib/agent_examples/overlay_controls_example.dart',
      ),
    ],
  ),
  'CharcoalDialog': ComponentMetadata(
    category: 'Overlays',
    summary: 'Presents a short, blocking decision in a centered dialog or adaptive bottom-sheet surface.',
    keywords: <String>[
      'bottom sheet',
      'confirmation',
      'dialog',
      'modal',
      'overlay',
      'prompt',
    ],
    useWhen: <String>[
      'The user must confirm, choose, or acknowledge a short self-contained task before returning.',
      'The same content needs centered and bottom-sheet presentation styles.',
    ],
    avoidWhen: <String>[
      'The message is transient and does not require focus; use CharcoalToast or CharcoalSnackBar.',
      'The task involves browsing content, repeated actions, text composition, or nested navigation; use a page or route.',
      'The task belongs to a bounded embedded surface without its own Navigator; add a local Navigator or keep the interaction inline.',
    ],
    accessibility: <String>[
      'Use a concise title and a barrierLabel that describes dismissal.',
      'Do not make a destructive or mandatory decision barrier-dismissible.',
    ],
    responsiveBehavior: <String>[
      'Use CharcoalModalStyle.bottomSheet for compact mobile presentation where appropriate.',
      'Size constrains readable content width; maxWidth can narrow a specific workflow.',
      'showCharcoalModal targets the root Navigator by default; set useRootNavigator to false only from a context under the intended nested Navigator.',
    ],
    interactionStates: <String>['presenting', 'open', 'dismissing', 'dismissed'],
    feedbackResponsibilities: <String>[
      'Owns modal focus containment, presentation, dismissal, and surface semantics.',
      'The caller owns task validation, progress, success, failure, and returned result.',
    ],
    tokenRoles: <String>[
      'paragraphWidth.s',
      'paragraphWidth.l',
      'space.layout40',
      'space.layout100',
      'space.targetL',
    ],
    relatedComponents: <String>['CharcoalToast', 'CharcoalSnackBar'],
    companionDeclarations: <String>[
      'showCharcoalDialog',
      'showCharcoalModal',
      'CharcoalDialogSize',
      'CharcoalModalStyle',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'dialog-launcher',
        title: 'Open an adaptive modal',
        description: 'Launches a dialog with Charcoal content and action widgets.',
        sourcePath: 'example/lib/agent_examples/modal_example.dart',
      ),
    ],
  ),
  'CharcoalLoadingSpinner': ComponentMetadata(
    category: 'Utility',
    summary:
        'Announces and renders an indeterminate wait with Charcoal source geometry and motion.',
    keywords: <String>[
      'busy indicator',
      'indeterminate progress',
      'loading',
      'loading spinner',
      'progress feedback',
      'wait state',
    ],
    useWhen: <String>[
      'A bounded operation is in progress but cannot report meaningful completion percentage.',
      'The caller already owns placement, interaction blocking, lifecycle, and the durable outcome.',
    ],
    avoidWhen: <String>[
      'Progress can be measured; use a determinate progress treatment that reports its value.',
      'The wait must block an existing subtree; use CharcoalSpinnerOverlay so pointer, focus, and semantics are coordinated.',
      'The operation may take indefinitely without explanation, cancellation, timeout, error, or recovery in the surrounding experience.',
    ],
    accessibility: <String>[
      'Pass a localized, non-empty semanticLabel that names the pending operation when Loading is not sufficient context.',
      'The component exposes one live-region loading-spinner node; its expanding circle is excluded as decorative presentation.',
      'Do not infer completion from once: the caller must remove the spinner and expose the actual result when work finishes.',
    ],
    responsiveBehavior: <String>[
      'The default circle is 48 logical pixels with 16 logical pixels of padding; valid size and padding overrides remain caller-constrained.',
      'The indicator has no text geometry and does not grow with text scaling; the surrounding composition owns compact placement.',
      'When animations are disabled, it becomes a stable midpoint frame instead of repeating motion.',
      'Transparent removes the surface fill but retains the source shadow contract.',
    ],
    interactionStates: <String>[
      'repeating',
      'once',
      'reduced motion',
      'default surface',
      'transparent surface',
      'custom size',
    ],
    feedbackResponsibilities: <String>[
      'Owns the indeterminate expansion and fade, loading-spinner semantics, source surface, and reduced-motion frame.',
      'The caller owns operation state, blocking policy, cancellation, timeout, error, retry, completion, and durable result.',
    ],
    tokenRoles: <String>[
      'space.targetL',
      'space.component30',
      'radius.m',
      'backgroundDefault',
      'iconTertiaryDefault',
    ],
    relatedComponents: <String>[
      'CharcoalSpinnerOverlay',
      'CharcoalSwitchingButton',
      'CharcoalButton',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'loading-spinner-publish-state',
        title: 'Named indeterminate publish progress',
        description: 'Announces a bounded wait while the owning example records completion as durable page state.',
        sourcePath: 'example/lib/agent_examples/async_action_example.dart',
      ),
    ],
  ),
  'CharcoalSpinnerOverlay': ComponentMetadata(
    category: 'Utility',
    summary: 'Centers named loading feedback over a subtree with explicit blocking or passthrough behavior.',
    keywords: <String>[
      'blocking loading',
      'busy overlay',
      'loading mask',
      'spinner overlay',
      'subtree progress',
    ],
    useWhen: <String>[
      'A bounded subtree must remain in place while one indeterminate operation temporarily blocks stale interaction.',
      'Background refresh should remain visible while the underlying content is deliberately safe to use through interactionPassthrough.',
    ],
    avoidWhen: <String>[
      'Only an inline status is needed; place CharcoalLoadingSpinner in normal layout.',
      'The operation navigates to a new destination, replaces the complete app, or needs modal decisions; use the corresponding route, page, or dialog state.',
      'A transparent visual overlay is being used as unexplained indefinite blocking; keep progress bounded and provide failure and recovery outside the component.',
    ],
    accessibility: <String>[
      'Set semanticLabel to a localized operation name such as Publishing draft; the internal spinner exposes the loading-spinner live region.',
      'The default blocking mode removes the child subtree from pointer input, keyboard focus, and accessibility traversal until visible becomes false.',
      'interactionPassthrough preserves all child input and semantics, so enable it only when every underlying action is safe during the operation.',
    ],
    responsiveBehavior: <String>[
      'The overlay occupies exactly the child bounds and centers the spinner without adding modal dimming or changing child geometry.',
      'spinnerSize changes only the source circle while the spinner retains its component-owned padding and surface.',
      'Presentation fade and scale become immediate when animations are disabled.',
    ],
    interactionStates: <String>[
      'hidden',
      'appearing',
      'blocking visible',
      'passthrough visible',
      'disappearing',
      'reduced motion',
    ],
    feedbackResponsibilities: <String>[
      'Owns centering, presentation motion, loading semantics, and consistent pointer, focus, and semantic blocking policy.',
      'The caller owns visible, the operation-specific label, passthrough safety, timeout, error, retry, and durable completion state.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalLoadingSpinner',
      'CharcoalSwitchingButton',
      'CharcoalDialog',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'spinner-overlay-publish-action',
        title: 'Blocking publish progress with durable result',
        description: 'Blocks stale publish actions, announces the operation, then restores the correct next action after completion.',
        sourcePath: 'example/lib/agent_examples/async_action_example.dart',
      ),
    ],
  ),
  'CharcoalHintText': ComponentMetadata(
    category: 'Feedback',
    summary:
        'Keeps optional page or section guidance visible with an optional, clearly named action.',
    keywords: <String>[
      'advisory message',
      'contextual guidance',
      'help text',
      'hint',
      'page tip',
      'section guidance',
    ],
    useWhen: <String>[
      'A page or section benefits from brief, persistent advice that remains useful before and after nearby interaction.',
      'The advice may include one small action and the caller owns whether the complete hint remains visible.',
    ],
    avoidWhen: <String>[
      'The message reports invalid input or explains a correction; use the field assistiveText API so validation stays associated with the input.',
      'The feedback is a transient success or failure result; use CharcoalToast or CharcoalSnackBar and keep durable results in the page.',
      'The content needs multiple actions, disclosure state, or anchored interactive detail; use CharcoalBalloon or a regular page section.',
      'Only a control label is missing; label the control directly instead of adding surrounding hint copy.',
    ],
    accessibility: <String>[
      'Keep the primary message meaningful without the decorative information icon and give an optional action explicit visible text.',
      'The message remains normal document content rather than an automatic live region; announce only an action result that truly changed.',
      'When visible is false, message, subtitle, icon, and action all leave layout and semantics together.',
      'Do not encode error, warning, or success meaning only through a custom icon because HintText has no validation role.',
    ],
    responsiveBehavior: <String>[
      'Without an action the surface remains intrinsic-width unless maxWidth is infinity; the parent controls page-level placement.',
      'An action remains inline when scaled copy has sufficient room and moves below only when available width becomes insufficient.',
      'Message and icon remain directionally leading while the optional action stays trailing in LTR and RTL.',
      'Copy and subtitle wrap with ambient text scaling; place unusually long guidance in normal page content instead.',
    ],
    interactionStates: <String>[
      'visible',
      'hidden',
      'message only',
      'with subtitle',
      'with action',
      'compact stacked action',
      'scaled text',
      'RTL',
    ],
    feedbackResponsibilities: <String>[
      'Owns the advisory surface, authored information icon, copy layout, optional action placement, visibility removal, and responsive wrapping.',
      'The caller owns visible state, action outcome, live or durable result feedback, validation, persistence, and recovery.',
    ],
    tokenRoles: <String>[
      'space.component10',
      'space.component25',
      'space.component30',
      'radius.m',
      'containerSecondaryDefault',
      'textDefault',
      'iconDefault',
    ],
    relatedComponents: <String>[
      'CharcoalFieldLabel',
      'CharcoalTextField',
      'CharcoalTooltip',
      'CharcoalToast',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'hint-text-controlled-advice',
        title: 'Optional advisory guidance with one outcome',
        description: 'Keeps advice separate from validation and removes the complete hint after its controlled action succeeds.',
        sourcePath: 'example/lib/agent_examples/form_guidance_example.dart',
      ),
    ],
  ),
  'CharcoalToast': ComponentMetadata(
    category: 'Feedback',
    summary: 'Shows a compact positive or negative live-region notification.',
    keywords: <String>['alert', 'feedback', 'notification', 'success', 'toast'],
    useWhen: <String>[
      'A completed action needs brief success or error feedback.',
      'The feedback can disappear automatically without blocking the workflow.',
    ],
    avoidWhen: <String>[
      'The message needs a thumbnail or neutral bordered surface; use CharcoalSnackBar.',
      'The user must make a decision before continuing; use CharcoalDialog.',
    ],
    accessibility: <String>[
      'The message is exposed as a live region; use semanticLabel only when it needs clarification.',
      'Do not rely on success or error color as the only meaning in custom leading content.',
    ],
    responsiveBehavior: <String>[
      'The overlay respects horizontal screen insets and a configurable maximum width.',
      'Choose CharcoalPopupEdge based on nearby persistent navigation and safe areas.',
      'Feedback targets the root Overlay by default; set useRootOverlay to false from a context under a deliberately bounded nested Overlay.',
    ],
    interactionStates: <String>['appearing', 'visible', 'dismissing'],
    feedbackResponsibilities: <String>[
      'Owns transient presentation and success or error visual semantics.',
      'The caller must keep durable or corrective information in the page rather than only in a toast.',
    ],
    tokenRoles: <String>[
      'containerPositiveDefault',
      'containerNegativeDefault',
      'space.component20',
      'space.component40',
      'borderWidth.l',
    ],
    relatedComponents: <String>['CharcoalSnackBar', 'CharcoalDialog'],
    companionDeclarations: <String>[
      'showCharcoalToast',
      'CharcoalToastController',
      'CharcoalToastVariant',
      'CharcoalPopupEdge',
      'CharcoalToastAnimationConfiguration',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'toast-and-snackbar',
        title: 'Transient feedback',
        description: 'Shows toast and snackbar overlays from a context with an Overlay.',
        sourcePath: 'example/lib/agent_examples/feedback_example.dart',
      ),
    ],
  ),
  'CharcoalSnackBar': ComponentMetadata(
    category: 'Feedback',
    summary: 'Shows a bordered, optionally illustrated transient notification.',
    keywords: <String>['alert', 'feedback', 'notification', 'snackbar', 'thumbnail'],
    useWhen: <String>[
      'Transient feedback needs a neutral bordered surface, action, or thumbnail.',
      'The notification may be dismissed with a drag gesture.',
    ],
    avoidWhen: <String>[
      'Success or error feedback should be visually compact; use CharcoalToast.',
      'The user must make a decision before continuing; use CharcoalDialog.',
    ],
    accessibility: <String>[
      'The message is exposed as a live region; keep it short and self-contained.',
      'Any action widget needs its own accessible label and adequate target size.',
    ],
    responsiveBehavior: <String>[
      'The overlay respects horizontal screen insets and a configurable maximum width.',
      'The thumbnail keeps its component-defined size while message content flexes.',
      'Feedback targets the root Overlay by default; set useRootOverlay to false from a context under a deliberately bounded nested Overlay.',
    ],
    interactionStates: <String>['appearing', 'visible', 'action invoked', 'dismissed'],
    feedbackResponsibilities: <String>[
      'Owns transient message, optional action, dismissal, and overlay presentation.',
      'The caller owns the action outcome and information that must remain after dismissal.',
    ],
    tokenRoles: <String>[
      'borderDefault',
      'borderWidth.m',
      'space.component25',
      'space.component30',
      'space.layout60',
    ],
    relatedComponents: <String>['CharcoalToast', 'CharcoalDialog'],
    companionDeclarations: <String>[
      'showCharcoalSnackBar',
      'CharcoalToastController',
      'CharcoalPopupEdge',
      'CharcoalToastAnimationConfiguration',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'toast-and-snackbar',
        title: 'Transient feedback',
        description: 'Shows toast and snackbar overlays from a context with an Overlay.',
        sourcePath: 'example/lib/agent_examples/feedback_example.dart',
      ),
    ],
  ),
};
