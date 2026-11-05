import 'index.dart';

/// Catalog metadata fragment: actions.
const Map<String, ComponentMetadata> actionsMetadata = <String, ComponentMetadata>{
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
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'pressed',
      'selected',
      'disabled',
    ],
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
    companionDeclarations: <String>[
      'CharcoalButtonVariant',
      'CharcoalButtonSize',
    ],
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
    relatedComponents: <String>['CharcoalButton', 'CharcoalIconButton'],
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
};
