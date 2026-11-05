import 'index.dart';

/// Catalog metadata fragment: supporting building blocks that applications do not use directly.
const Map<String, ComponentMetadata> supportingMetadata = <String, ComponentMetadata>{
  'CharcoalEditableText': ComponentMetadata(
    category: 'Supporting',
    summary: 'Supporting building block: the editing surface inside CharcoalTextField and CharcoalTextArea (caret, selection, context menu). Applications use those fields instead.',
    keywords: <String>[
      'editable text',
      'input engine',
      'caret',
      'selection',
      'supporting',
    ],
    useWhen: <String>[
      'A library author builds a new field and needs the audited Charcoal editing behaviour without decoration.',
    ],
    avoidWhen: <String>[
      'Any application screen: use CharcoalTextField, CharcoalTextArea or CharcoalSearchField, which add the label, ring, counter and semantics.',
    ],
    accessibility: <String>[
      'It supplies caret, selection and the Charcoal context menu; the owning field must supply label and semantics.',
    ],
    responsiveBehavior: <String>[
      'Wraps and scrolls per maxLines; scroll padding comes from the theme.',
    ],
    interactionStates: <String>[
      'focused',
      'selecting',
      'read only',
      'obscured',
    ],
    feedbackResponsibilities: <String>[
      'Owns text editing behaviour.',
      'The owning field owns decoration, label, validation and counter.',
    ],
    tokenRoles: <String>[
      'colors.focusRing',
    ],
    relatedComponents: <String>[
      'CharcoalTextField',
      'CharcoalTextArea',
      'CharcoalSelectionToolbar',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[],
  ),
  'CharcoalFieldRing': ComponentMetadata(
    category: 'Supporting',
    summary: 'Supporting building block: the outside focus or validation ring drawn around a field. Fields draw it themselves; applications do not.',
    keywords: <String>[
      'focus ring',
      'validation ring',
      'halo',
      'supporting',
    ],
    useWhen: <String>[
      'A library author builds a custom field that needs the standard external ring.',
    ],
    avoidWhen: <String>[
      'Any application screen: the Charcoal fields already show the ring.',
    ],
    accessibility: <String>[
      'The ring is decorative; focus and invalid state must also be exposed through semantics.',
    ],
    responsiveBehavior: <String>[
      'It paints outside the child bounds and never changes layout.',
    ],
    interactionStates: <String>[
      'hidden',
      'visible',
    ],
    feedbackResponsibilities: <String>[
      'Owns the ring painting and fade.',
      'The owner decides when it is visible.',
    ],
    tokenRoles: <String>[
      'colors.focusRing',
      'borders.focusHalo',
    ],
    relatedComponents: <String>[
      'CharcoalTextField',
      'CharcoalDropdown',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[],
  ),
  'CharcoalSelectionBox': ComponentMetadata(
    category: 'Supporting',
    summary: 'Supporting building block: the non-interactive checkbox glyph used by batch selection and multi-select rows. Applications use CharcoalCheckbox or CharcoalMultiSelect.',
    keywords: <String>[
      'selection box',
      'check glyph',
      'supporting',
    ],
    useWhen: <String>[
      'A library list row needs the check indicator in selection mode.',
    ],
    avoidWhen: <String>[
      'Any interactive checkbox: use CharcoalCheckbox, which adds semantics and focus.',
    ],
    accessibility: <String>[
      'It is decorative; the owning row exposes the selected state.',
    ],
    responsiveBehavior: <String>[
      'Fixed indicator slot from the theme.',
    ],
    interactionStates: <String>[
      'unselected',
      'selected',
    ],
    feedbackResponsibilities: <String>[
      'Owns the glyph and its states.',
      'The owner owns tap handling and semantics.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.border',
      'sizes.indicatorSlot',
    ],
    relatedComponents: <String>[
      'CharcoalCheckbox',
      'CharcoalMultiSelect',
      'CharcoalBatchBar',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[],
  ),
  'CharcoalSelectionToolbar': ComponentMetadata(
    category: 'Supporting',
    summary: 'Supporting building block: the floating Cut / Copy / Paste menu over a text selection. The Charcoal fields install it as their context menu.',
    keywords: <String>[
      'selection toolbar',
      'context menu',
      'cut copy paste',
      'supporting',
    ],
    useWhen: <String>[
      'A library author builds a custom editing surface that needs the Charcoal context menu.',
    ],
    avoidWhen: <String>[
      'Any application screen: the Charcoal text fields already show it.',
    ],
    accessibility: <String>[
      'Entries are buttons with their label; disabled entries are announced as disabled.',
    ],
    responsiveBehavior: <String>[
      'It stays in the safe area above the keyboard and scrolls when large text does not fit.',
    ],
    interactionStates: <String>[
      'visible',
    ],
    feedbackResponsibilities: <String>[
      'Owns placement and entry presentation.',
      'The owner owns the entries and their actions.',
    ],
    tokenRoles: <String>[
      'colors.background',
      'colors.borderSubtle',
    ],
    relatedComponents: <String>[
      'CharcoalEditableText',
      'CharcoalTextField',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[],
  ),
  'CharcoalOverlayAnchorTracker': ComponentMetadata(
    category: 'Supporting',
    summary: 'Supporting building block: reports the global rectangle of its child after layout so a balloon or tooltip can follow it.',
    keywords: <String>[
      'anchor',
      'tracker',
      'overlay position',
      'supporting',
    ],
    useWhen: <String>[
      'A library overlay must follow the position of its trigger while the page scrolls.',
    ],
    avoidWhen: <String>[
      'Any application screen: use CharcoalTooltip or CharcoalBalloon, which track their anchor.',
    ],
    accessibility: <String>[
      'It adds no semantics.',
    ],
    responsiveBehavior: <String>[
      'Reports only when the rectangle changes.',
    ],
    interactionStates: <String>[
      'tracking',
    ],
    feedbackResponsibilities: <String>[
      'Owns rectangle tracking.',
      'The owner owns what the rectangle drives.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalBalloon',
      'CharcoalTooltip',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[],
  ),
  'CharcoalTextDefaults': ComponentMetadata(
    category: 'Supporting',
    summary: 'Supporting building block: installs the theme default text and icon style for a subtree. CharcoalApp already applies it at the root.',
    keywords: <String>[
      'text defaults',
      'default text style',
      'icon theme',
      'supporting',
    ],
    useWhen: <String>[
      'Charcoal widgets are embedded under a host that has its own text defaults.',
    ],
    avoidWhen: <String>[
      'A normal Charcoal application: CharcoalApp installs the defaults.',
    ],
    accessibility: <String>[
      'Text still follows the system text scale.',
    ],
    responsiveBehavior: <String>[
      'No layout of its own.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the ambient text and icon defaults.',
      'The host owns where Charcoal content begins.',
    ],
    tokenRoles: <String>[
      'colors.text',
      'colors.icon',
    ],
    relatedComponents: <String>[
      'CharcoalApp',
      'CharcoalText',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[],
  ),
};
