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
      'Pair invalid with assistiveText that explains how to correct the value.',
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
    ],
    responsiveBehavior: <String>[
      'The popup matches the trigger width and chooses the available vertical direction.',
      'Let the parent constrain trigger width on small and large screens.',
    ],
    interactionStates: <String>['closed', 'open', 'focused', 'selected', 'disabled'],
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
