import 'index.dart';

/// Catalog metadata fragment: feedback states and status marks.
const Map<String, ComponentMetadata> feedbackMetadata = <String, ComponentMetadata>{
  'CharcoalBanner': ComponentMetadata(
    category: 'Feedback',
    summary:
        'An inline banner with a tone icon, message, optional title and optional trailing action.',
    keywords: <String>[
      'banner',
      'alert',
      'notice',
      'inline message',
      'warning',
    ],
    useWhen: <String>[
      'A page or form needs a persistent message tied to its content, such as a pause, warning or error summary.',
      'The message may offer one recovery action.',
    ],
    avoidWhen: <String>[
      'The feedback is transient confirmation; use CharcoalToast or CharcoalSnackBar.',
      'An error blocks only one field; use the field assistive text.',
    ],
    accessibility: <String>[
      'The title and message are announced together as one live message; keep them concise.',
      'The tone icon is decorative; the message must state the meaning in words.',
    ],
    responsiveBehavior: <String>[
      'The message wraps; the action moves below the text on narrow widths.',
    ],
    interactionStates: <String>[
      'static',
      'with action',
    ],
    feedbackResponsibilities: <String>[
      'Owns tone presentation, icon, layout and the action slot.',
      'The caller owns when it appears, the wording and the action result.',
    ],
    tokenRoles: <String>[
      'colors.noticeSurface',
      'colors.textNotice',
      'colors.iconNotice',
    ],
    relatedComponents: <String>[
      'CharcoalErrorState',
      'CharcoalToast',
      'CharcoalChip',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'banner-notice',
        title: 'Notice banner',
        description: 'A notice banner at the top of a status panel.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
  'CharcoalModeBar': ComponentMetadata(
    category: 'Feedback',
    summary: 'A full-width bar across the top edge of the app that marks a special mode: tone icon, bold title, optional message and trailing actions such as the way out, on the tone\'s solid fill.',
    keywords: <String>[
      'mode bar',
      'super user',
      'break-glass',
      'impersonation',
      'environment bar',
      'caution bar',
    ],
    useWhen: <String>[
      'The whole app is in a special mode the user must not forget, such as acting as a shared super user or as another account; put the bar above the page and offer the exit as an action.',
      'A sign-in card belongs to that mode; put a title-only bar first in a flush, untitled CharcoalSectionCard as its head.',
      'The page under the bar should read as the same mode; give the CharcoalScaffold background: CharcoalPageBackground.notice.',
    ],
    avoidWhen: <String>[
      'A message about the content of one page or form; use CharcoalBanner.',
      'Transient confirmation; use CharcoalToast or CharcoalSnackBar.',
    ],
    accessibility: <String>[
      'The bar is one container whose label is the title; the message and the actions are read and focused inside it.',
      'The icon is decorative; the title must name the mode in words.',
    ],
    responsiveBehavior: <String>[
      'Spans its parent edge to edge with no radius; the horizontal inset is space.xl, or space.lg below sizes.sidebarBreakpoint, like a section card.',
      'On a narrow bar the message wraps under the title; the actions stay at the end.',
    ],
    interactionStates: <String>[
      'static',
      'with actions',
    ],
    feedbackResponsibilities: <String>[
      'Owns the fill, the colours on it, the icon, the insets and the layout.',
      'The caller owns entering and leaving the mode and the action results.',
    ],
    tokenRoles: <String>[
      'colors.notice',
      'colors.textOnNotice',
      'colors.iconOnNotice',
      'colors.noticeSurface',
      'space.xl',
      'space.lg',
      'space.md',
      'sizes.rowMinHeightCompact',
    ],
    relatedComponents: <String>[
      'CharcoalBanner',
      'CharcoalScaffold',
      'CharcoalSectionCard',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'mode-bar-super-user',
        title: 'Super-user mode',
        description: 'A sign-in card headed by a title-only mode bar; in the mode, a notice page under a full-width bar whose action leaves the mode.',
        sourcePath: 'example/lib/agent_examples/mode_bar_example.dart',
      ),
    ],
  ),
  'CharcoalEmptyState': ComponentMetadata(
    category: 'Feedback',
    summary: 'A centred empty state: a muted icon, an optional title, a message, optional actions and optional numbered steps that explain how the place fills up.',
    keywords: <String>[
      'empty',
      'no results',
      'blank slate',
      'zero state',
    ],
    useWhen: <String>[
      'A list, search or page region has no content and should say why and what to do next.',
      'A first-run screen needs one clear next step.',
      'A new feature starts empty and two or three numbered steps (CharcoalEmptyStateStep) explain how to put it to use.',
    ],
    avoidWhen: <String>[
      'The region failed to load; use CharcoalErrorState.',
      'Content is loading; use CharcoalLoadingState.',
    ],
    accessibility: <String>[
      'The title is a heading; the message and the steps are the spoken content; the icon is decorative.',
      'Actions keep their own labels and focus order.',
    ],
    responsiveBehavior: <String>[
      'It centres within the space it is given and wraps the message on narrow widths.',
      'Steps sit in a centred row, each sizes.fieldWidthCompact wide, and stack where the row does not fit.',
    ],
    interactionStates: <String>[
      'static',
      'with action',
      'with steps',
    ],
    feedbackResponsibilities: <String>[
      'Owns icon, message layout and spacing.',
      'The caller owns the wording, the actions and the path out of emptiness.',
    ],
    tokenRoles: <String>[
      'colors.iconTertiary',
      'colors.textSecondary',
      'space.lg',
    ],
    relatedComponents: <String>[
      'CharcoalErrorState',
      'CharcoalLoadingState',
      'CharcoalSectionCard',
    ],
    companionDeclarations: <String>['CharcoalEmptyStateStep'],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'empty-state',
        title: 'Empty region',
        description: 'A folder icon and a no-jobs message.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
      ExampleMetadata(
        id: 'admin-sections',
        title: 'Detail page in section cards',
        description: 'A members section that turns into an empty state with a title and numbered steps when the last member is removed.',
        sourcePath: 'example/lib/agent_examples/admin_sections_example.dart',
      ),
    ],
  ),
  'CharcoalErrorState': ComponentMetadata(
    category: 'Feedback',
    summary: 'An error message for a failed page region with a retry affordance.',
    keywords: <String>[
      'error',
      'failed to load',
      'retry',
      'error state',
    ],
    useWhen: <String>[
      'A region could not load and the user can retry.',
      'A recoverable failure needs both an explanation and an action.',
    ],
    avoidWhen: <String>[
      'The error is a form validation message; use CharcoalFormField assistive text.',
      'A short confirmation after an action; use CharcoalToast.',
    ],
    accessibility: <String>[
      'The message is announced as it appears; keep it specific and free of codes the user cannot act on.',
      'The retry action is a labelled button and receives focus order after the message.',
    ],
    responsiveBehavior: <String>[
      'It fills the width given and wraps long messages.',
    ],
    interactionStates: <String>[
      'static',
      'retryable',
    ],
    feedbackResponsibilities: <String>[
      'Owns tone, icon and retry button presentation.',
      'The caller owns the cause, wording and the retry result.',
    ],
    tokenRoles: <String>[
      'colors.negativeSurface',
      'colors.textNegative',
      'colors.iconNegative',
    ],
    relatedComponents: <String>[
      'CharcoalBanner',
      'CharcoalEmptyState',
      'CharcoalLoadingState',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'error-state',
        title: 'Retryable error',
        description: 'A failed list with a retry that returns to ready.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
  'CharcoalLoadingState': ComponentMetadata(
    category: 'Feedback',
    summary: 'A centred spinner for a loading page region.',
    keywords: <String>[
      'loading',
      'spinner',
      'busy',
      'progress',
    ],
    useWhen: <String>[
      'A region fetches its first content and has nothing to show yet.',
      'The wait is short and indeterminate.',
    ],
    avoidWhen: <String>[
      'The whole page is blocked by a running action; use CharcoalSpinnerOverlay.',
      'Progress is known; show a meter or progress text.',
    ],
    accessibility: <String>[
      'Provide semanticLabel so the busy state is announced; update to a result when loading ends.',
    ],
    responsiveBehavior: <String>[
      'It centres in the space given; give the region a stable minimum height to avoid layout jumps.',
    ],
    interactionStates: <String>[
      'loading',
    ],
    feedbackResponsibilities: <String>[
      'Owns the spinner and its centring.',
      'The caller owns when loading starts, ends or fails.',
    ],
    tokenRoles: <String>[
      'colors.primary',
    ],
    relatedComponents: <String>[
      'CharcoalSpinnerOverlay',
      'CharcoalLoadingSpinner',
      'CharcoalEmptyState',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'loading-state',
        title: 'Loading region',
        description: 'A loading region swapped with ready, empty and failed.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
  'CharcoalBadge': ComponentMetadata(
    category: 'Status',
    summary: 'A small solid label: a count, a role or a "new" marker.',
    keywords: <String>[
      'badge',
      'count',
      'role',
      'new',
      'label',
    ],
    useWhen: <String>[
      'A short label or count must stand out next to a title or avatar.',
      'A role (Owner, Editor) is shown in a row.',
    ],
    avoidWhen: <String>[
      'The status is a state of an item with a dot; use CharcoalChip or CharcoalStatusDot.',
      'The label is long; use text.',
    ],
    accessibility: <String>[
      'The label is read as text; for a count describe what it counts in the surrounding label.',
    ],
    responsiveBehavior: <String>[
      'It keeps one line; very long labels are not supported.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns fill, shape and text styling for each tone.',
      'The caller owns the label and meaning.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.negative',
      'colors.positive',
      'colors.textOnPrimary',
    ],
    relatedComponents: <String>[
      'CharcoalChip',
      'CharcoalStatusDot',
      'CharcoalTagItem',
    ],
    companionDeclarations: <String>[
      'CharcoalBadgeTone',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'badge-count',
        title: 'Count and role badges',
        description: 'A negative count badge among chips.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
  'CharcoalChip': ComponentMetadata(
    category: 'Status',
    summary: 'A small status chip: caption text on a pale tone surface.',
    keywords: <String>[
      'chip',
      'status',
      'tone',
      'label',
      'state',
    ],
    useWhen: <String>[
      'A record has a status (Synced, Retrying) that should be scannable in a list.',
      'An identifier is shown in monospace beside other metadata.',
    ],
    avoidWhen: <String>[
      'The item must be selected or filtered by the user; use CharcoalTagItem.',
      'A count needs emphasis; use CharcoalBadge.',
    ],
    accessibility: <String>[
      'Colour is never the only signal; the label states the status in words.',
    ],
    responsiveBehavior: <String>[
      'Chips keep one line and wrap in CharcoalWrap when several sit together.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns tone surface, text and shape.',
      'The caller owns the status vocabulary and its mapping to tone.',
    ],
    tokenRoles: <String>[
      'colors.positiveSurface',
      'colors.noticeSurface',
      'colors.textPositive',
    ],
    relatedComponents: <String>[
      'CharcoalStatusDot',
      'CharcoalBadge',
      'CharcoalTagItem',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'chip-status',
        title: 'Status chips',
        description: 'Synced, retrying and monospace chips.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
  'CharcoalStatusDot': ComponentMetadata(
    category: 'Status',
    summary: 'A leading dot that marks row status with a semantic tone.',
    keywords: <String>[
      'dot',
      'status',
      'indicator',
      'presence',
    ],
    useWhen: <String>[
      'A row or label needs an at-a-glance status marker alongside text.',
      'A list row uses a dot instead of a selection box outside selection mode.',
    ],
    avoidWhen: <String>[
      'The status must be understood without colour; add a word or use CharcoalChip.',
    ],
    accessibility: <String>[
      'The dot is decorative; the row must state the status in its label.',
    ],
    responsiveBehavior: <String>[
      'It is a fixed size and does not scale with text.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns dot size and tone colour.',
      'The caller owns the status meaning.',
    ],
    tokenRoles: <String>[
      'colors.positive',
      'colors.negative',
      'colors.neutral',
    ],
    relatedComponents: <String>[
      'CharcoalChip',
      'CharcoalListRow',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'status-dot',
        title: 'Status dot',
        description: 'A positive dot beside chips.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
  'CharcoalCodeBlock': ComponentMetadata(
    category: 'Content',
    summary:
        'A block of monospace text on a secondary surface: a log excerpt, JSON payload or key.',
    keywords: <String>[
      'code',
      'log',
      'json',
      'monospace',
      'snippet',
    ],
    useWhen: <String>[
      'A machine-readable value or log excerpt should be shown verbatim and optionally copied.',
      'Several lines of output need a scrollable region.',
    ],
    avoidWhen: <String>[
      'The text is prose; use CharcoalText.',
      'The user edits the text; use CharcoalTextArea.',
    ],
    accessibility: <String>[
      'Enable selectable so users can copy; long text stays reachable by scrolling and keyboard.',
    ],
    responsiveBehavior: <String>[
      'Long lines scroll horizontally or wrap per the scrollable option; maxLines limits height.',
    ],
    interactionStates: <String>[
      'static',
      'selectable',
    ],
    feedbackResponsibilities: <String>[
      'Owns monospace styling, surface and selection.',
      'The caller owns the content and truncation policy.',
    ],
    tokenRoles: <String>[
      'colors.backgroundSecondary',
      'colors.text',
    ],
    relatedComponents: <String>[
      'CharcoalText',
      'CharcoalTextArea',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'code-block',
        title: 'Log excerpt',
        description: 'A two-line selectable code block.',
        sourcePath: 'example/lib/agent_examples/status_example.dart',
      ),
    ],
  ),
};
