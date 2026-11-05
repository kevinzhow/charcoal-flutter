import 'index.dart';

/// Catalog metadata fragment: form composition.
const Map<String, ComponentMetadata> formsMetadata = <String, ComponentMetadata>{
  'CharcoalFormSection': ComponentMetadata(
    category: 'Forms',
    summary: 'A titled group of fields with consistent vertical rhythm and an optional caption.',
    keywords: <String>[
      'form',
      'section',
      'group',
      'settings',
      'fields',
    ],
    useWhen: <String>[
      'Several related fields belong together under one heading.',
      'A settings page splits into labelled groups.',
    ],
    avoidWhen: <String>[
      'One field only; use CharcoalFormField.',
      'The group is a list of navigable rows; use CharcoalList.',
    ],
    accessibility: <String>[
      'The title is a heading for the group; keep it unique on the page.',
    ],
    responsiveBehavior: <String>[
      'Fields stack in one column and take the width given; use CharcoalFieldBox for width classes.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns heading, caption and rhythm between children.',
      'The caller owns the fields, their values and validation.',
    ],
    tokenRoles: <String>[
      'typography.roles.sectionTitle.fontSize',
      'space.lg',
    ],
    relatedComponents: <String>[
      'CharcoalFormField',
      'CharcoalSectionHeader',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'form-section',
        title: 'Project settings sections',
        description: 'Two titled sections with fields, switch, date and search.',
        sourcePath: 'example/lib/agent_examples/form_section_example.dart',
      ),
    ],
  ),
  'CharcoalFormField': ComponentMetadata(
    category: 'Forms',
    summary: 'The styled shell around any control that needs a label, helper line, required or invalid state and an optional action.',
    keywords: <String>[
      'form field',
      'label',
      'helper',
      'required',
      'invalid',
      'shell',
    ],
    useWhen: <String>[
      'A control (text field, slider, dropdown) needs a visible label and assistive text.',
      'A field has a required marker or an inline correction message.',
    ],
    avoidWhen: <String>[
      'The control already has its own label slot (CharcoalSwitchField, CharcoalSearchField).',
      'A free-standing label without a control; use CharcoalText.',
    ],
    accessibility: <String>[
      'The label is associated with the child control; pass invalid and assistiveText so the error is announced.',
      'Required is conveyed in words (requiredText) as well as by the marker.',
    ],
    responsiveBehavior: <String>[
      'The label wraps on narrow widths and the helper line grows with text scale.',
    ],
    interactionStates: <String>[
      'idle',
      'invalid',
      'required',
    ],
    feedbackResponsibilities: <String>[
      'Owns label, helper, required and invalid presentation.',
      'The caller owns the control value, validation rule and submit.',
    ],
    tokenRoles: <String>[
      'colors.text',
      'colors.textNegative',
      'space.xs',
    ],
    relatedComponents: <String>[
      'CharcoalFormSection',
      'CharcoalFieldLabel',
      'CharcoalTextField',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'form-field',
        title: 'Validated name field',
        description: 'A required name field that turns invalid when empty.',
        sourcePath: 'example/lib/agent_examples/form_section_example.dart',
      ),
    ],
  ),
  'CharcoalSwitchField': ComponentMetadata(
    category: 'Forms',
    summary: 'A labelled switch with an optional hint line.',
    keywords: <String>[
      'switch',
      'toggle',
      'setting',
      'on off',
    ],
    useWhen: <String>[
      'A boolean setting needs a label and optional explanation.',
      'The change takes effect immediately.',
    ],
    avoidWhen: <String>[
      'Several independent options; use CharcoalCheckbox or CharcoalMultiSelect.',
      'A choice between named modes; use CharcoalSegmentedControl.',
    ],
    accessibility: <String>[
      'The label and state (on/off) are exposed together; keep the label a noun phrase.',
      'A null onChanged exposes the disabled state.',
    ],
    responsiveBehavior: <String>[
      'The label wraps; the switch stays aligned at the end.',
    ],
    interactionStates: <String>[
      'off',
      'on',
      'focused',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns label, hint and switch layout and state presentation.',
      'The caller owns the value, persistence and failure feedback.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.text',
      'colors.textSecondary',
    ],
    relatedComponents: <String>[
      'CharcoalSwitch',
      'CharcoalCheckbox',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'switch-field',
        title: 'Public toggle',
        description: 'A switch field with a hint.',
        sourcePath: 'example/lib/agent_examples/form_section_example.dart',
      ),
    ],
  ),
  'CharcoalSearchField': ComponentMetadata(
    category: 'Forms',
    summary: 'A text field with a search icon and a clear affordance.',
    keywords: <String>[
      'search',
      'filter',
      'find',
      'query',
    ],
    useWhen: <String>[
      'A list or page can be filtered by typed text.',
      'A search box needs a built-in clear button.',
    ],
    avoidWhen: <String>[
      'General text entry; use CharcoalTextField.',
      'A choice among known options; use CharcoalDropdown.',
    ],
    accessibility: <String>[
      'Provide a visible label and clearLabel; the icon is decorative.',
      'Focus returns to the field after clear.',
    ],
    responsiveBehavior: <String>[
      'The field takes the width given; place it in a CharcoalFieldBox to cap it.',
    ],
    interactionStates: <String>[
      'idle',
      'focused',
      'filled',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns the field chrome, search icon and clear button.',
      'The caller owns the controller, filtering and result feedback.',
    ],
    tokenRoles: <String>[
      'colors.fillSecondary',
      'colors.focusRing',
      'colors.iconTertiary',
    ],
    relatedComponents: <String>[
      'CharcoalTextField',
      'CharcoalDropdown',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'search-field',
        title: 'Preset search',
        description: 'A search field with clear in a form section.',
        sourcePath: 'example/lib/agent_examples/form_section_example.dart',
      ),
    ],
  ),
  'CharcoalDateTimeField': ComponentMetadata(
    category: 'Forms',
    summary: 'A date-and-time picker rendered as a field.',
    keywords: <String>[
      'date',
      'time',
      'picker',
      'schedule',
      'datetime',
    ],
    useWhen: <String>[
      'A moment (publish time, expiry) is chosen from calendar and clock dialogs.',
      'The value may be cleared.',
    ],
    avoidWhen: <String>[
      'Free text; use CharcoalTextField.',
      'Only a duration or count; use a number field.',
    ],
    accessibility: <String>[
      'The field exposes its label and current value as a button; opening the dialog moves focus to it.',
    ],
    responsiveBehavior: <String>[
      'The field width follows its parent; long dates wrap.',
    ],
    interactionStates: <String>[
      'empty',
      'filled',
      'focused',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns the field chrome, formatting and clear action.',
      'The caller owns the value, time zone semantics and validation.',
    ],
    tokenRoles: <String>[
      'colors.fillSecondary',
      'colors.text',
    ],
    relatedComponents: <String>[
      'CharcoalFormField',
      'CharcoalTextField',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'date-time-field',
        title: 'Publish time',
        description: 'An optional publish time field.',
        sourcePath: 'example/lib/agent_examples/form_section_example.dart',
      ),
    ],
  ),
  'CharcoalSlider': ComponentMetadata(
    category: 'Selection',
    summary: 'A slider in the theme primary colour for choosing a value in a range.',
    keywords: <String>[
      'slider',
      'range',
      'quality',
      'volume',
    ],
    useWhen: <String>[
      'A continuous or stepped numeric value is adjusted by dragging.',
      'Exact values are not required.',
    ],
    avoidWhen: <String>[
      'An exact number must be typed; use CharcoalTextField.',
      'Choosing one of a few named modes; use CharcoalSegmentedControl.',
    ],
    accessibility: <String>[
      'Provide semanticLabel; the value is exposed to assistive technology with increase and decrease actions.',
      'Keyboard arrows adjust the value.',
    ],
    responsiveBehavior: <String>[
      'It stretches to the width given; give it at least a target-size height.',
    ],
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'dragging',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns track, thumb and value label presentation.',
      'The caller owns the value, range and what changing it does.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.fillSecondary',
    ],
    relatedComponents: <String>[
      'CharcoalFormField',
      'CharcoalSegmentedControl',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'slider-quality',
        title: 'Export quality',
        description: 'A slider in a form field.',
        sourcePath: 'example/lib/agent_examples/form_section_example.dart',
      ),
    ],
  ),
};
