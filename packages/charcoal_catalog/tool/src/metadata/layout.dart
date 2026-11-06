import 'index.dart';

/// Catalog metadata fragment: layout, content and composition helpers.
const Map<String, ComponentMetadata> layoutMetadata = <String, ComponentMetadata>{
  'CharcoalCard': ComponentMetadata(
    category: 'Layout',
    summary: 'A surface that groups related content such as stats, a settings block or a feed post: filled, outlined, or raised from a grey page; the library owns its fill, radius, border and interaction states.',
    keywords: <String>[
      'card',
      'surface',
      'group',
      'panel',
      'container',
    ],
    useWhen: <String>[
      'Related content needs one visible grouping that stands apart from the page background.',
      'A stat, summary or settings block should read as a single unit.',
      'A post or tile stands on a grey page (CharcoalScaffold with CharcoalPageBackground.secondary); use raised, and highlighted for a new or unread item among them.',
      'One whole card is a single action; pass the states of the enclosing CharcoalClickable to states.',
    ],
    avoidWhen: <String>[
      'A divided list of repeated rows is clearer; use CharcoalList.',
      'Cards would nest inside cards; flatten the hierarchy with CharcoalSectionHeader instead.',
    ],
    accessibility: <String>[
      'A card adds no semantics of its own; give the content inside a heading or label so the group is announced.',
      'Interactive content keeps its own focus and semantics; a whole-card action is a CharcoalClickable with a semanticLabel whose states the card paints, never an unlabelled gesture.',
    ],
    responsiveBehavior: <String>[
      'The card fills the width its parent gives it; choose columns in the parent, not a fixed card width.',
      'Padding is a spacing step (CharcoalInset), so it follows the active theme and text scale.',
    ],
    interactionStates: <String>[
      'static',
      'hovered',
      'pressed',
      'focused',
    ],
    feedbackResponsibilities: <String>[
      'Owns the surface fill, corner radius, outline and raised options, inner padding, and the hover, press and focus visuals for the states it is given.',
      'The caller owns the content, its hierarchy, and any action it exposes.',
    ],
    tokenRoles: <String>[
      'colors.backgroundSecondary',
      'colors.surfaceSecondary',
      'colors.background',
      'colors.borderSubtle',
      'colors.border',
      'colors.borderFocus',
      'colors.hoverOverlay',
      'colors.pressOverlay',
      'radius.md',
      'space.lg',
    ],
    relatedComponents: <String>[
      'CharcoalList',
      'CharcoalSectionHeader',
      'CharcoalStatCard',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'card-group',
        title: 'Grouped actions on a card',
        description: 'Wraps action tiles in a padded card inside a section.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
      ExampleMetadata(
        id: 'card-whole-surface-action',
        title: 'A raised card as one action',
        description: 'Paints hover, press and focus of a CharcoalClickable on a raised card.',
        sourcePath: 'example/lib/agent_examples/clickable_example.dart',
      ),
    ],
  ),
  'CharcoalList': ComponentMetadata(
    category: 'Layout',
    summary: 'A divided list, the main content shape of data screens; rows are CharcoalListRow.',
    keywords: <String>[
      'list',
      'rows',
      'table',
      'divided list',
      'records',
    ],
    useWhen: <String>[
      'Several records of the same shape are scanned and opened one by one.',
      'A settings or navigation screen needs ruled rows with leading and trailing content.',
    ],
    avoidWhen: <String>[
      'Two or three facts about one record; use CharcoalInfoRows.',
      'Rows need free-form layouts or inline editing; compose a dedicated surface instead.',
    ],
    accessibility: <String>[
      'Each row exposes its title as its label and its tap as one action; keep row titles unique and meaningful.',
      'Do not put several independent actions inside one row without separate semantics.',
    ],
    responsiveBehavior: <String>[
      'The list takes the width it is given and rows grow in height with text scale.',
      'Use CharcoalListRowHeight to pick row density; never fix a row height in the caller.',
    ],
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'pressed',
      'selected',
    ],
    feedbackResponsibilities: <String>[
      'Owns row dividers, row height classes, selection and pointer feedback.',
      'The caller owns the data, ordering, paging, selection state and what a row opens.',
    ],
    tokenRoles: <String>[
      'colors.borderSubtle',
      'borders.hairline',
      'space.lg',
    ],
    relatedComponents: <String>[
      'CharcoalListRow',
      'CharcoalSectionHeader',
      'CharcoalBatchBar',
    ],
    companionDeclarations: <String>[
      'CharcoalListRowHeight',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'list-members',
        title: 'Member list with badges',
        description: 'Rows with avatar, role badge and an open action.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalListRow': ComponentMetadata(
    category: 'Layout',
    summary: 'One row of a CharcoalList: title, optional subtitle and details, leading and trailing content, optional chevron and press action.',
    keywords: <String>[
      'row',
      'list item',
      'record',
      'tile',
      'list row',
    ],
    useWhen: <String>[
      'A record is shown in a list and may open a detail page.',
      'The row needs a leading avatar or icon and trailing status, badge or action.',
    ],
    avoidWhen: <String>[
      'The row is not part of a list; use CharcoalNavigationItem for navigation or CharcoalCard for a standalone tile.',
      'Several actions compete inside one row; split them into the detail page.',
    ],
    accessibility: <String>[
      'The title (and subtitle) form the spoken label; an onPressed row is announced as a button.',
      'Hover, focus and pressed paint states never move the row bounds, so keyboard and pointer users see a stable layout.',
    ],
    responsiveBehavior: <String>[
      'Long titles wrap or ellipsize inside the row; text scale grows the row instead of clipping.',
      'Select a CharcoalListRowHeight class for density rather than padding by hand.',
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
      'Owns pointer, focus, pressed and selected presentation, chevron and trailing alignment.',
      'The caller owns the navigation or action, selection state and the meaning of trailing content.',
    ],
    tokenRoles: <String>[
      'colors.text',
      'colors.textSecondary',
      'colors.hoverOverlay',
      'colors.pressOverlay',
      'space.lg',
    ],
    relatedComponents: <String>[
      'CharcoalList',
      'CharcoalAvatar',
      'CharcoalBadge',
    ],
    companionDeclarations: <String>[
      'CharcoalListRowHeight',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'list-row-member',
        title: 'Row with avatar and role',
        description: 'A tappable member row with a trailing badge.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalSectionHeader': ComponentMetadata(
    category: 'Layout',
    summary: 'A section heading with an optional caption and a trailing action, used to title a block of a page.',
    keywords: <String>[
      'section',
      'heading',
      'title',
      'caption',
      'group title',
    ],
    useWhen: <String>[
      'A page has several blocks that each need a visible title and optional explanation.',
      'A block has one related action such as Add or View all.',
    ],
    avoidWhen: <String>[
      'The title is the page title; use CharcoalPage or CharcoalNavigationBar.',
      'A form needs a titled group of fields; CharcoalFormSection includes its own heading.',
    ],
    accessibility: <String>[
      'The title is exposed as a heading to assistive technology; keep it short and unique on the page.',
      'The trailing action keeps its own label and focus order after the title.',
    ],
    responsiveBehavior: <String>[
      'The action wraps below the title when width is tight instead of overflowing.',
      'Spacing between title, caption and action follows theme steps and text scale.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns heading typography, caption styling and action alignment.',
      'The caller owns the wording and what the action does.',
    ],
    tokenRoles: <String>[
      'typography.roles.sectionTitle.fontSize',
      'colors.textSecondary',
      'space.xs',
    ],
    relatedComponents: <String>[
      'CharcoalFormSection',
      'CharcoalCard',
      'CharcoalList',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'section-header',
        title: 'Titled block',
        description: 'A section header with caption above grouped actions.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalDivider': ComponentMetadata(
    category: 'Layout',
    summary: 'A hairline rule across the width it is given.',
    keywords: <String>[
      'divider',
      'separator',
      'rule',
      'hairline',
    ],
    useWhen: <String>[
      'Two groups in a column need a visible break that a gap alone does not give.',
      'A custom list-like layout needs the same rule colour the library lists use.',
    ],
    avoidWhen: <String>[
      'Rows already sit in a CharcoalList, which draws its own dividers.',
      'Whitespace (CharcoalGap) is enough to separate the groups.',
    ],
    accessibility: <String>[
      'The divider is decorative and excluded from semantics.',
      'Do not rely on the rule alone to convey a grouping that matters; label the groups.',
    ],
    responsiveBehavior: <String>[
      'It stretches to the available width and has a fixed hairline thickness from the theme.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the rule colour and thickness.',
      'The caller owns where the break is meaningful.',
    ],
    tokenRoles: <String>[
      'colors.borderSubtle',
      'borders.hairline',
    ],
    relatedComponents: <String>[
      'CharcoalList',
      'CharcoalGap',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'divider-rule',
        title: 'Rule between groups',
        description: 'A divider under a list before a footer line.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalFieldBox': ComponentMetadata(
    category: 'Layout',
    summary: 'Gives a field (text field, dropdown, search field) a width class so form rows align without hard-coded widths.',
    keywords: <String>[
      'field width',
      'form width',
      'field box',
      'input width',
    ],
    useWhen: <String>[
      'A field should be compact, standard or full width relative to its form, not as wide as the page.',
      'Several fields in a form need consistent widths.',
    ],
    avoidWhen: <String>[
      'The field is already inside a CharcoalFormField that stretches it; do not constrain it twice.',
      'A control is not a field (button, switch); size it with its own API.',
    ],
    accessibility: <String>[
      'The box does not change semantics; the wrapped field keeps its label, value and focus.',
      'Make sure the compact width still fits the field label and value at large text scales.',
    ],
    responsiveBehavior: <String>[
      'Width classes cap at the container width; on narrow screens every class falls back to full width.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the width classes (CharcoalFieldWidth) and their narrow-screen fallback.',
      'The caller owns which class fits the data being entered.',
    ],
    tokenRoles: <String>[
      'sizes.controlLg',
    ],
    relatedComponents: <String>[
      'CharcoalTextField',
      'CharcoalDropdown',
      'CharcoalFormField',
    ],
    companionDeclarations: <String>[
      'CharcoalFieldWidth',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'field-box-width',
        title: 'Field width class',
        description: 'A compact field box inside a layout.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalGap': ComponentMetadata(
    category: 'Layout',
    summary: 'An empty box of one spacing step along the main axis of its parent Row or Column.',
    keywords: <String>[
      'gap',
      'spacing',
      'space',
      'spacer',
      'margin',
    ],
    useWhen: <String>[
      'Siblings in a Row or Column need breathing room that matches the theme scale.',
      'A page-level layout needs vertical rhythm without writing a number.',
    ],
    avoidWhen: <String>[
      'Space must surround one widget on several sides; use CharcoalPadding.',
      'Gaps would need to flex; use Spacer or Expanded.',
    ],
    accessibility: <String>[
      'A gap is excluded from semantics and focus.',
    ],
    responsiveBehavior: <String>[
      'The step is resolved from the active pack, so spacing follows density changes; it does not scale with text.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the mapping from step to logical pixels.',
      'The caller owns where rhythm changes.',
    ],
    tokenRoles: <String>[
      'space.xxs',
      'space.xs',
      'space.sm',
      'space.md',
      'space.lg',
      'space.xl',
      'space.xxl',
      'space.xxxl',
    ],
    relatedComponents: <String>[
      'CharcoalPadding',
      'CharcoalWrap',
    ],
    companionDeclarations: <String>[
      'CharcoalSpace',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'gap-steps',
        title: 'Gap steps',
        description: 'Gaps between a header, a card and a list.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalPadding': ComponentMetadata(
    category: 'Layout',
    summary: 'Padding whose insets are spacing steps of the active theme (CharcoalInset), the app-level replacement for EdgeInsets.',
    keywords: <String>[
      'padding',
      'inset',
      'margin',
      'spacing',
    ],
    useWhen: <String>[
      'A widget needs space on one or more sides expressed as theme steps.',
      'A page body needs horizontal and vertical insets that match the library.',
    ],
    avoidWhen: <String>[
      'Only a gap between siblings is needed; use CharcoalGap.',
      'The inset is zero; omit the padding.',
    ],
    accessibility: <String>[
      'Padding is invisible to semantics and does not change focus order.',
    ],
    responsiveBehavior: <String>[
      'Insets use theme steps, so a different pack changes spacing everywhere at once.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns resolving CharcoalInset steps to pixels.',
      'The caller owns which steps fit the content.',
    ],
    tokenRoles: <String>[
      'space.xxs',
      'space.xs',
      'space.sm',
      'space.md',
      'space.lg',
      'space.xl',
      'space.xxl',
      'space.xxxl',
    ],
    relatedComponents: <String>[
      'CharcoalGap',
      'CharcoalWrap',
    ],
    companionDeclarations: <String>[
      'CharcoalInset',
      'CharcoalSpace',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'padding-inset',
        title: 'Symmetric inset',
        description: 'A caption row padded with a vertical spacing step.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalWrap': ComponentMetadata(
    category: 'Layout',
    summary: 'A Wrap whose gaps are spacing steps of the active theme; lays out chips, tags or tiles that flow onto several lines.',
    keywords: <String>[
      'wrap',
      'flow',
      'chips',
      'tags',
      'tiles',
    ],
    useWhen: <String>[
      'A set of small controls or chips should flow to a new line when the row is full.',
      'Action tiles sit side by side on wide screens and stack on narrow ones.',
    ],
    avoidWhen: <String>[
      'Items form a strict grid or table; use a Row/Column layout.',
      'A single-line scroller is intended; use a horizontal list.',
    ],
    accessibility: <String>[
      'Reading and focus order follow the children order; place the most important item first.',
    ],
    responsiveBehavior: <String>[
      'Wrapping depends on available width and text scale; test narrow widths and 200% text.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the theme-step spacing between items and runs.',
      'The caller owns the items and their order.',
    ],
    tokenRoles: <String>[
      'space.sm',
      'space.md',
    ],
    relatedComponents: <String>[
      'CharcoalGap',
      'CharcoalChip',
      'CharcoalTagItem',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'wrap-tiles',
        title: 'Wrapping action tiles',
        description: 'Action tiles that reflow under a narrow width.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalAvatar': ComponentMetadata(
    category: 'Layout',
    summary: 'A square or circular avatar showing the first letter of a name or address, or given initials, on a neutral or toned fill.',
    keywords: <String>[
      'avatar',
      'initial',
      'user',
      'profile picture',
      'account',
    ],
    useWhen: <String>[
      'A list row, account tile or comment needs a compact identity mark without a photo.',
      'Only a name or email is known.',
      'People or accounts should be told apart at a glance; give each a CharcoalTone and two-letter initials.',
    ],
    avoidWhen: <String>[
      'A real photo must be shown; use an image widget inside the owning component.',
      'The identity is decorative next to the name already shown; keep it excluded from semantics.',
    ],
    accessibility: <String>[
      'The letter is decorative; the row or tile must expose the full name as its label.',
    ],
    responsiveBehavior: <String>[
      'Four sizes (CharcoalAvatarSize, extraLarge for a profile header); the glyph scales with text.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns letter extraction, size classes, shape and colour, including the solid fill and on-colour of each tone.',
      'The caller owns the identity string, optional initials and the tone chosen for the person.',
    ],
    tokenRoles: <String>[
      'colors.surfaceTertiary',
      'colors.textSecondary',
      'colors.primary',
      'colors.negative',
      'colors.notice',
      'colors.positive',
      'sizes.avatarXl',
      'radius.md',
      'radius.pill',
    ],
    relatedComponents: <String>[
      'CharcoalListRow',
      'CharcoalSidebar',
    ],
    companionDeclarations: <String>[
      'CharcoalAvatarSize',
      'CharcoalTone',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'avatar-row',
        title: 'Circular avatar in a row',
        description: 'Members listed with circular avatars.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
      ExampleMetadata(
        id: 'avatar-toned-initials',
        title: 'Toned avatar with initials',
        description: 'An author header with a toned two-letter avatar.',
        sourcePath: 'example/lib/agent_examples/social_content_example.dart',
      ),
    ],
  ),
  'CharcoalActionTile': ComponentMetadata(
    category: 'Actions',
    summary: 'An outlined tile with a leading icon and a one-line label for a quick action.',
    keywords: <String>[
      'quick action',
      'tile',
      'shortcut',
      'outlined button',
    ],
    useWhen: <String>[
      'Two to four quick actions are offered side by side on a dashboard or card.',
      'The action is recognised by an icon plus a short label.',
    ],
    avoidWhen: <String>[
      'The action is the primary call to action; use CharcoalButton.',
      'The label needs more than one line; use a CharcoalListRow.',
    ],
    accessibility: <String>[
      'The label is the spoken name; the icon is decorative.',
      'A null onPressed removes interaction and exposes the disabled state.',
    ],
    responsiveBehavior: <String>[
      'Tiles keep a stable size class and wrap with CharcoalWrap on narrow screens.',
    ],
    interactionStates: <String>[
      'idle',
      'hovered',
      'focused',
      'pressed',
      'disabled',
    ],
    feedbackResponsibilities: <String>[
      'Owns outline, hover, focus and pressed presentation.',
      'The caller owns what the action does and its result feedback.',
    ],
    tokenRoles: <String>[
      'colors.border',
      'colors.pressOverlay',
      'radius.sm',
    ],
    relatedComponents: <String>[
      'CharcoalButton',
      'CharcoalListRow',
      'CharcoalWrap',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'action-tile',
        title: 'Invite and settings tiles',
        description: 'Two quick actions on a card.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalText': ComponentMetadata(
    category: 'Content',
    summary: 'A run of text in a Charcoal type role and semantic tone; the one place applications read typography from.',
    keywords: <String>[
      'text',
      'typography',
      'heading',
      'label',
      'caption',
      'tone',
    ],
    useWhen: <String>[
      'Any visible string in application code: titles, labels, captions, paragraphs.',
      'Colour must change with meaning (secondary, negative, on primary); pass a CharcoalTextTone.',
    ],
    avoidWhen: <String>[
      'A numeric component label that follows a reviewed component spec; use CharcoalTypography inside the library.',
      'Plain Text is acceptable only inside a Charcoal component slot (a child label), where the component supplies the style.',
    ],
    accessibility: <String>[
      'Text scales with the system setting; do not clamp it.',
      'Use semanticLabel only to add spoken context; never to replace meaningful visible text.',
    ],
    responsiveBehavior: <String>[
      'Roles carry size and a line-height ratio so wrapped lines stay balanced under text scale.',
      'Use maxLines with overflow rather than fixed heights.',
    ],
    interactionStates: <String>[
      'regular',
      'bold',
      'mono',
      'toned',
    ],
    feedbackResponsibilities: <String>[
      'Owns the role, weight, family and colour resolution from the theme.',
      'The caller owns the string, its localisation and the role choice.',
    ],
    tokenRoles: <String>[
      'typography.roles.body.fontSize',
      'colors.text',
      'colors.textSecondary',
    ],
    relatedComponents: <String>[
      'CharcoalTypography',
      'CharcoalTextEllipsis',
      'CharcoalSectionHeader',
    ],
    companionDeclarations: <String>[
      'CharcoalTextRole',
      'CharcoalTextTone',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'text-tones',
        title: 'Roles and tones',
        description: 'Caption text in secondary tone beside an icon.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalIconView': ComponentMetadata(
    category: 'Content',
    summary: 'A Charcoal icon glyph painted in a semantic tone and size of the active theme.',
    keywords: <String>[
      'icon',
      'glyph',
      'tone',
      'symbol',
    ],
    useWhen: <String>[
      'An icon must follow meaning (secondary, negative, on primary) without naming a colour.',
      'The icon size should follow the theme scale.',
    ],
    avoidWhen: <String>[
      'An icon inside a Charcoal component slot already gets its style from the component.',
      'The glyph is the only label; add semanticLabel or use an icon button.',
    ],
    accessibility: <String>[
      'Decorative icons are excluded from semantics; supply semanticLabel when the icon carries meaning alone.',
    ],
    responsiveBehavior: <String>[
      'Sizes come from CharcoalIconSize and do not shrink with text scale; pair with labelled text.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns tone-to-colour resolution and size classes.',
      'The caller owns the glyph choice and its meaning.',
    ],
    tokenRoles: <String>[
      'colors.icon',
      'colors.iconSecondary',
      'sizes.iconMd',
    ],
    relatedComponents: <String>[
      'CharcoalIconButton',
      'CharcoalText',
    ],
    companionDeclarations: <String>[
      'CharcoalIconTone',
      'CharcoalIconSize',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'icon-view',
        title: 'Toned icon beside text',
        description: 'A secondary info icon before a caption.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalGrid': ComponentMetadata(
    category: 'Layout',
    summary: 'A grid of equal-width cells whose column count follows the layout class (wide or compact), with theme-step gaps.',
    keywords: <String>[
      'grid',
      'columns',
      'cards',
      'dashboard',
      'responsive grid',
    ],
    useWhen: <String>[
      'Cards or tiles of the same kind should sit in rows on wide layouts and stack on compact ones.',
      'Cells in a row should be the same height (stat cards, summary cards).',
    ],
    avoidWhen: <String>[
      'Content flows freely at its own width; use CharcoalWrap.',
      'A cell contains a LayoutBuilder; equal row heights measure intrinsic height and cannot support it.',
    ],
    accessibility: <String>[
      'Reading and focus order follow the children order row by row; put the most important cell first.',
    ],
    responsiveBehavior: <String>[
      'Columns come from CharcoalGridColumns for the enclosing admin shell layout, or the grid width against the sidebar breakpoint outside a shell; the count never exceeds the number of children.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns column counts, gaps, equal row heights and padding of the last row.',
      'The caller owns the cells and their content.',
    ],
    tokenRoles: <String>[
      'space.md',
      'sizes.sidebarBreakpoint',
    ],
    relatedComponents: <String>[
      'CharcoalWrap',
      'CharcoalCard',
      'CharcoalStatCard',
    ],
    companionDeclarations: <String>[
      'CharcoalGridColumns',
      'CharcoalGridRowHeight',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'grid-cells',
        title: 'Two-column summary cells',
        description: 'Cards laid out by a grid with equal heights.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalSelectable': ComponentMetadata(
    category: 'Content',
    summary: 'Makes the text below it selectable and copyable with pointer and keyboard, without platform handles or toolbar.',
    keywords: <String>[
      'selectable',
      'copy',
      'select text',
      'identifier',
    ],
    useWhen: <String>[
      'Identifiers, keys and values in dense admin views should be copyable.',
    ],
    avoidWhen: <String>[
      'The text is inside an editable field; fields already handle selection.',
      'Touch-first reading screens that need platform selection handles.',
    ],
    accessibility: <String>[
      'Selection is exposed through the platform selection region; keep the visible text the copied text.',
    ],
    responsiveBehavior: <String>[
      'No layout of its own.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the selection region.',
      'The caller owns what is selectable.',
    ],
    tokenRoles: <String>[],
    relatedComponents: <String>[
      'CharcoalInfoRows',
      'CharcoalCodeBlock',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'selectable-value',
        title: 'Copyable value',
        description: 'A selectable member count.',
        sourcePath: 'example/lib/agent_examples/layout_example.dart',
      ),
    ],
  ),
  'CharcoalPlaceholderArtwork': ComponentMetadata(
    category: 'Layout',
    summary: 'Abstract placeholder artwork drawn from the pack colours for a post, product, story or cover that has no image yet.',
    keywords: <String>[
      'placeholder image',
      'artwork',
      'cover',
      'media placeholder',
      'demo image',
    ],
    useWhen: <String>[
      'A post, product or story needs visible media and no image exists yet, as in a simulation or an empty draft.',
      'Several items need distinct but stable artwork; give each its own seed.',
    ],
    avoidWhen: <String>[
      'A real image is available; show the image.',
      'The area is loading; use CharcoalLoadingState or a skeleton instead of decorative art.',
    ],
    accessibility: <String>[
      'The artwork is announced as an image named semanticLabel; describe what it stands for.',
      'It is not interactive; wrap it in CharcoalClickable with CharcoalPressFeedback when tapping opens the item.',
    ],
    responsiveBehavior: <String>[
      'Fills a bounded parent (a grid tile, an Expanded story area); in a scrolling column it takes metrics.artwork.height.',
      'The composition is anchored to the start and end corners and mirrors in right-to-left layouts.',
    ],
    interactionStates: <String>[
      'static',
      'rounded',
    ],
    feedbackResponsibilities: <String>[
      'Owns the gradient, shapes, colours, default height and optional corner clip.',
      'The caller owns the seed, the description and the surrounding card or tile.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.negative',
      'colors.notice',
      'colors.positive',
      'radius.md',
    ],
    relatedComponents: <String>[
      'CharcoalCard',
      'CharcoalPressFeedback',
      'CharcoalCarousel',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'placeholder-artwork-post',
        title: 'Post media without an image',
        description: 'Fills the media slot of a raised post card with seeded placeholder artwork.',
        sourcePath: 'example/lib/agent_examples/social_content_example.dart',
      ),
    ],
  ),
  'CharcoalMessageBubble': ComponentMetadata(
    category: 'Layout',
    summary: 'One message of a conversation: primary-filled when the current person sent it, outlined when it was received.',
    keywords: <String>[
      'chat',
      'message',
      'bubble',
      'conversation',
      'direct message',
    ],
    useWhen: <String>[
      'A conversation shows messages from the current person and from others.',
    ],
    avoidWhen: <String>[
      'The text is a comment or a post in a feed; use a card with CharcoalText.',
      'The message is system feedback; use CharcoalBanner or a toast.',
    ],
    accessibility: <String>[
      'The text is read as is; put the sender name and delivery status next to the bubble as text so they are announced.',
    ],
    responsiveBehavior: <String>[
      'Grows with its text up to sizes.messageBubbleMaxWidth, then wraps; the caller aligns it to the end (outgoing) or start (incoming).',
    ],
    interactionStates: <String>[
      'incoming',
      'outgoing',
    ],
    feedbackResponsibilities: <String>[
      'Owns the fill, outline, radius, padding, text role and maximum width.',
      'The caller owns alignment, sender names, timestamps and delivery status.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.textOnPrimary',
      'colors.background',
      'colors.borderSubtle',
      'radius.md',
      'space.sm',
    ],
    relatedComponents: <String>[
      'CharcoalBottomBar',
      'CharcoalLoadingSpinner',
      'CharcoalText',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'message-bubble-conversation',
        title: 'A short conversation',
        description: 'Aligns incoming and outgoing bubbles above a reply bar.',
        sourcePath: 'example/lib/agent_examples/social_content_example.dart',
      ),
    ],
  ),
  'CharcoalProgressBar': ComponentMetadata(
    category: 'Layout',
    summary: 'A thin bar filled to a fraction: story progress, an upload, a quota.',
    keywords: <String>[
      'progress',
      'progress bar',
      'story progress',
      'upload progress',
      'quota bar',
    ],
    useWhen: <String>[
      'The share of a known whole is complete and a thin bar is enough to show it.',
    ],
    avoidWhen: <String>[
      'The duration is unknown; use CharcoalLoadingSpinner or CharcoalLoadingState.',
      'A quota needs a label and a figure on a card; use CharcoalMeter.',
    ],
    accessibility: <String>[
      'With semanticLabel the bar announces its label and percentage; without one it is decorative.',
    ],
    responsiveBehavior: <String>[
      'Fills the width its parent gives it; the value is clamped to 0..1.',
    ],
    interactionStates: <String>[
      'empty',
      'partial',
      'full',
    ],
    feedbackResponsibilities: <String>[
      'Owns the track height, colours and corner radius.',
      'The caller owns the value and the label.',
    ],
    tokenRoles: <String>[
      'sizes.meterTrack',
      'colors.surfaceTertiary',
      'colors.primary',
      'radius.xs',
    ],
    relatedComponents: <String>[
      'CharcoalMeter',
      'CharcoalLoadingSpinner',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'progress-bar-story',
        title: 'Story progress',
        description: 'Shows how far through a set of stories the viewer is.',
        sourcePath: 'example/lib/agent_examples/social_content_example.dart',
      ),
    ],
  ),
  'CharcoalBottomBar': ComponentMetadata(
    category: 'Layout',
    summary: 'A page-coloured bar with a top rule pinned under scrolling content, for a reply composer or a page action.',
    keywords: <String>[
      'bottom bar',
      'reply bar',
      'composer bar',
      'footer',
      'action bar',
    ],
    useWhen: <String>[
      'A conversation, comment thread or story needs a reply field pinned below the content.',
      'A grey page needs one pinned bottom surface that reads as separate from the content.',
    ],
    avoidWhen: <String>[
      'The bar switches top-level destinations; use CharcoalTabBar.',
      'A dialog needs actions; use the dialog or modal actions.',
    ],
    accessibility: <String>[
      'Adds no semantics; the field and buttons inside keep their own labels.',
    ],
    responsiveBehavior: <String>[
      'Fills the width; as CharcoalScaffold.bottomBar it stays above the keyboard and the bottom inset.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns the fill, the top rule and the padding.',
      'The caller owns the field, the actions and what sending does.',
    ],
    tokenRoles: <String>[
      'colors.background',
      'colors.borderSubtle',
      'borders.hairline',
      'space.sm',
    ],
    relatedComponents: <String>[
      'CharcoalScaffold',
      'CharcoalTextField',
      'CharcoalMessageBubble',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'bottom-bar-reply',
        title: 'Reply bar under a conversation',
        description: 'Pins a reply action under the message list.',
        sourcePath: 'example/lib/agent_examples/social_content_example.dart',
      ),
    ],
  ),
};
