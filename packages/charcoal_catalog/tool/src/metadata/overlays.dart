import 'index.dart';

/// Catalog metadata fragment: overlays.
const Map<String, ComponentMetadata> overlaysMetadata = <String, ComponentMetadata>{
  'CharcoalTooltip': ComponentMetadata(
    category: 'Overlays',
    summary: 'Adds brief, non-interactive context to an anchored control across pointer, focus, and touch input.',
    keywords: <String>['anchored help', 'hover label', 'tooltip', 'touch hint'],
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
      'colors.hud',
      'colors.textOnHud',
      'space.xs',
      'space.md',
      'radius.sm',
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
    keywords: <String>['callout', 'persistent hint', 'speech balloon'],
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
      'colors.primary',
      'colors.textOnPrimary',
      'colors.fillOnImage',
      'space.md',
      'space.lg',
      'radius.xl',
      'colors.focusRing',
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
      'colors.primary',
      'colors.textOnPrimary',
      'colors.fillOnImage',
      'radius.xl',
      'colors.focusRing',
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
    interactionStates: <String>[
      'presenting',
      'open',
      'dismissing',
      'dismissed',
    ],
    feedbackResponsibilities: <String>[
      'Owns modal focus containment, presentation, dismissal, and surface semantics.',
      'The caller owns task validation, progress, success, failure, and returned result.',
    ],
    tokenRoles: <String>[
      'sizes.dialogMaxWidth',
      'sizes.controlLg',
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
    category: 'Feedback',
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
      'CharcoalLoadingSpinner.inline is the metrics.spinner.inlineSize circle with no surface or padding, to sit beside a line of small text such as a delivery status.',
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
      'sizes.controlLg',
      'space.lg',
      'radius.md',
      'colors.background',
      'colors.iconTertiary',
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
    category: 'Feedback',
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
      'space.xs',
      'space.md',
      'space.lg',
      'radius.md',
      'colors.surfaceSecondary',
      'colors.text',
      'colors.icon',
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
      'colors.positive',
      'colors.negative',
      'space.sm',
      'space.xl',
      'borders.thick',
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
    keywords: <String>[
      'alert',
      'feedback',
      'notification',
      'snackbar',
      'thumbnail',
    ],
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
    interactionStates: <String>[
      'appearing',
      'visible',
      'action invoked',
      'dismissed',
    ],
    feedbackResponsibilities: <String>[
      'Owns transient message, optional action, dismissal, and overlay presentation.',
      'The caller owns the action outcome and information that must remain after dismissal.',
    ],
    tokenRoles: <String>[
      'colors.border',
      'borders.hairline',
      'space.md',
      'space.lg',
      'space.xxxl',
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
