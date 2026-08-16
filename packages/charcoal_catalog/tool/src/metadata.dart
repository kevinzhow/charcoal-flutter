final class ComponentMetadata {
  const ComponentMetadata({
    required this.category,
    required this.summary,
    required this.keywords,
    required this.useWhen,
    required this.avoidWhen,
    required this.accessibility,
    required this.responsiveBehavior,
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
  'CharcoalDialog': ComponentMetadata(
    category: 'Overlays',
    summary: 'Presents focused content in a centered dialog or adaptive bottom-sheet surface.',
    keywords: <String>['bottom sheet', 'dialog', 'modal', 'overlay', 'prompt'],
    useWhen: <String>[
      'The user must complete or acknowledge a focused task before returning.',
      'The same content needs centered and bottom-sheet presentation styles.',
    ],
    avoidWhen: <String>[
      'The message is transient and does not require focus; use CharcoalToast or CharcoalSnackBar.',
      'A full page is needed for a long or deeply navigable workflow.',
    ],
    accessibility: <String>[
      'Use a concise title and a barrierLabel that describes dismissal.',
      'Do not make a destructive or mandatory decision barrier-dismissible.',
    ],
    responsiveBehavior: <String>[
      'Use CharcoalModalStyle.bottomSheet for compact mobile presentation where appropriate.',
      'Size constrains readable content width; maxWidth can narrow a specific workflow.',
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
