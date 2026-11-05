import 'index.dart';

/// Catalog metadata fragment: admin console pieces (package:charcoal_ui/admin.dart).
const Map<String, ComponentMetadata> adminMetadata = <String, ComponentMetadata>{
  'CharcoalAdminShell': ComponentMetadata(
    category: 'Admin',
    summary: 'The responsive frame of an admin app: a permanent sidebar at or above the breakpoint, otherwise the body above a bottom tab bar.',
    keywords: <String>[
      'admin',
      'shell',
      'sidebar',
      'layout',
      'console',
    ],
    useWhen: <String>[
      'An admin or dashboard app has destinations that fit a sidebar on desktop and a tab bar on phones.',
      'The layout should follow the width of the pane, not the window.',
    ],
    avoidWhen: <String>[
      'A simple linear flow with a single page; use CharcoalScaffold.',
      'More than five phone destinations; reduce or restructure first.',
    ],
    accessibility: <String>[
      'Sidebar and tab bar are two views of one selection; update both from one state owner in the same frame.',
      'Landmarks: each navigation is exposed as navigation with its own label.',
    ],
    responsiveBehavior: <String>[
      'The decision follows the width the shell receives at sizes.sidebarBreakpoint; body keeps its state across layouts.',
    ],
    interactionStates: <String>[
      'wide',
      'compact',
    ],
    feedbackResponsibilities: <String>[
      'Owns the breakpoint decision and arrangement of sidebar, body and bottom bar.',
      'The caller owns the destinations, selection and routing.',
    ],
    tokenRoles: <String>[
      'colors.background',
      'sizes.sidebarBreakpoint',
    ],
    relatedComponents: <String>[
      'CharcoalSidebar',
      'CharcoalTabBar',
      'CharcoalPage',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'admin-shell',
        title: 'Console frame',
        description: 'Shell with sidebar, tab bar and a page.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalSidebar': ComponentMetadata(
    category: 'Admin',
    summary: 'The fixed-width sidebar of an admin shell: a brand header, a scrolling list of grouped destinations and an optional pinned footer.',
    keywords: <String>[
      'sidebar',
      'navigation',
      'menu',
      'console',
    ],
    useWhen: <String>[
      'A wide layout needs permanent destinations.',
      'An account tile should stay pinned at the bottom.',
    ],
    avoidWhen: <String>[
      'A phone layout; use CharcoalTabBar in the shell bottom bar.',
    ],
    accessibility: <String>[
      'Destinations are navigation items; exactly one is selected at a time.',
    ],
    responsiveBehavior: <String>[
      'Width comes from the theme; the middle section scrolls when the window is short.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns width, divider, scroll behaviour and brand/footer placement.',
      'The caller owns the destinations and selection.',
    ],
    tokenRoles: <String>[
      'colors.background',
      'colors.borderSubtle',
      'sizes.sidebarWidth',
    ],
    relatedComponents: <String>[
      'CharcoalSidebarBrand',
      'CharcoalSidebarGroup',
      'CharcoalNavigationItem',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'sidebar',
        title: 'Console sidebar',
        description: 'Two destinations in a group under a brand.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalSidebarBrand': ComponentMetadata(
    category: 'Admin',
    summary: 'The brand header of a CharcoalSidebar: a primary-coloured mark with one letter and the product name.',
    keywords: <String>[
      'brand',
      'logo',
      'sidebar header',
    ],
    useWhen: <String>[
      'A sidebar needs the product identity at the top.',
    ],
    avoidWhen: <String>[
      'A standalone logo; use CharcoalBrandMark.',
    ],
    accessibility: <String>[
      'The title is exposed as text; the mark letter is decorative.',
    ],
    responsiveBehavior: <String>[
      'Long names ellipsize within the sidebar width.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns mark and title layout.',
      'The caller owns the name and letter.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.textOnPrimary',
      'sizes.brandMark',
    ],
    relatedComponents: <String>[
      'CharcoalSidebar',
      'CharcoalBrandMark',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'sidebar-brand',
        title: 'Sidebar brand',
        description: 'The brand header of the console sidebar.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalSidebarGroup': ComponentMetadata(
    category: 'Admin',
    summary: 'A titled group of sidebar destinations with the design tight gap between items.',
    keywords: <String>[
      'sidebar group',
      'menu group',
      'section',
    ],
    useWhen: <String>[
      'Sidebar destinations fall into named groups such as Operations.',
    ],
    avoidWhen: <String>[
      'Only one short list of destinations; omit the title.',
    ],
    accessibility: <String>[
      'The group title labels the items that follow; keep it short.',
    ],
    responsiveBehavior: <String>[
      'Items stack with theme gaps; the group grows with text scale.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns title styling and item gap.',
      'The caller owns the items.',
    ],
    tokenRoles: <String>[
      'colors.textTertiary',
      'space.xxs',
    ],
    relatedComponents: <String>[
      'CharcoalSidebar',
      'CharcoalNavigationItem',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'sidebar-group',
        title: 'Sidebar group',
        description: 'A group of destination items.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalBrandMark': ComponentMetadata(
    category: 'Admin',
    summary: 'The product mark: a primary-coloured square with one letter.',
    keywords: <String>[
      'brand',
      'logo',
      'mark',
      'product',
    ],
    useWhen: <String>[
      'A header or sign-in needs the product mark at the standard size.',
    ],
    avoidWhen: <String>[
      'A custom logo image is required; render the image inside the owning layout.',
    ],
    accessibility: <String>[
      'The letter is decorative; pair with the product name as text.',
    ],
    responsiveBehavior: <String>[
      'Fixed size from the theme.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns size, fill and letter styling.',
      'The caller owns the letter.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.textOnPrimary',
      'sizes.brandMark',
    ],
    relatedComponents: <String>[
      'CharcoalSidebarBrand',
      'CharcoalPage',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'brand-mark',
        title: 'Page header mark',
        description: 'The brand mark beside the page title.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalPage': ComponentMetadata(
    category: 'Admin',
    summary: 'The chrome and content column of one admin page: back link, title, subtitle, actions, optional banner and a busy overlay.',
    keywords: <String>[
      'page',
      'admin page',
      'header',
      'title',
      'content column',
    ],
    useWhen: <String>[
      'An admin destination needs a titled page with actions and a width-limited content column.',
      'A busy action should block the page and announce progress.',
    ],
    avoidWhen: <String>[
      'A mobile app page with a navigation bar; use CharcoalScaffold and CharcoalNavigationBar.',
    ],
    accessibility: <String>[
      'The title is a heading; busyLabel is announced while busy; the back control is labelled with backLabel.',
    ],
    responsiveBehavior: <String>[
      'maxWidth chooses standard, wide or full; compact mode moves actions to the title row end.',
    ],
    interactionStates: <String>[
      'idle',
      'busy',
    ],
    feedbackResponsibilities: <String>[
      'Owns title block, content width, scrolling and busy blocking.',
      'The caller owns the content, actions and the busy state.',
    ],
    tokenRoles: <String>[
      'space.xl',
      'colors.background',
    ],
    relatedComponents: <String>[
      'CharcoalAdminShell',
      'CharcoalSectionHeader',
      'CharcoalBanner',
    ],
    companionDeclarations: <String>[
      'CharcoalPageWidth',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'admin-page',
        title: 'Overview page',
        description: 'A titled page with a brand header, stat card and meter.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalStatCard': ComponentMetadata(
    category: 'Admin',
    summary: 'A stat tile: small label, large value, optional status, footnote and action.',
    keywords: <String>[
      'stat',
      'metric',
      'kpi',
      'dashboard',
      'card',
    ],
    useWhen: <String>[
      'A dashboard shows a headline number with context.',
      'A change in the value needs a toned status.',
    ],
    avoidWhen: <String>[
      'A quota with a fraction; use CharcoalMeter.',
      'A series of values; use a table.',
    ],
    accessibility: <String>[
      'Label, value and status are read together; write the status in words.',
    ],
    responsiveBehavior: <String>[
      'Cards fill the width given; arrange them in a CharcoalWrap or grid.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns label/value hierarchy, status tone and layout.',
      'The caller owns the numbers, their period and formatting.',
    ],
    tokenRoles: <String>[
      'colors.surfaceSecondary',
      'colors.textPositive',
      'typography.roles.headingS.fontSize',
    ],
    relatedComponents: <String>[
      'CharcoalMeter',
      'CharcoalCard',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'stat-card',
        title: 'Requests stat',
        description: 'A requests stat with a positive status.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalMeter': ComponentMetadata(
    category: 'Admin',
    summary: 'A labelled progress meter on a card, such as a quota report.',
    keywords: <String>[
      'meter',
      'quota',
      'progress',
      'usage',
    ],
    useWhen: <String>[
      'A usage against a limit should be visible as a bar.',
    ],
    avoidWhen: <String>[
      'Unknown progress; use CharcoalLoadingSpinner.',
      'Exact values matter more than proportion; add them as text.',
    ],
    accessibility: <String>[
      'The label and value text carry the meaning; the bar is decorative.',
    ],
    responsiveBehavior: <String>[
      'The bar fills the card width; the fraction is clamped to 0 to 1.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns bar rendering and fraction clamping.',
      'The caller owns the label, value text and fraction.',
    ],
    tokenRoles: <String>[
      'colors.primary',
      'colors.fillSecondary',
    ],
    relatedComponents: <String>[
      'CharcoalStatCard',
      'CharcoalCard',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'meter',
        title: 'Quota meter',
        description: 'A monthly quota meter.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalInfoRows': ComponentMetadata(
    category: 'Admin',
    summary: 'A key/value table: a tertiary label and a selectable value per ruled row.',
    keywords: <String>[
      'info',
      'key value',
      'details',
      'properties',
      'table',
    ],
    useWhen: <String>[
      'The facts of one record are shown as label/value pairs.',
    ],
    avoidWhen: <String>[
      'Many records of the same shape; use CharcoalList.',
    ],
    accessibility: <String>[
      'Values are selectable so users can copy; each label is read before its value.',
    ],
    responsiveBehavior: <String>[
      'labelWidth chooses narrow, regular or wide; values wrap.',
    ],
    interactionStates: <String>[
      'static',
    ],
    feedbackResponsibilities: <String>[
      'Owns rows, rules and label/value layout.',
      'The caller owns the pairs.',
    ],
    tokenRoles: <String>[
      'colors.textTertiary',
      'colors.borderSubtle',
    ],
    relatedComponents: <String>[
      'CharcoalList',
      'CharcoalCard',
    ],
    companionDeclarations: <String>[
      'CharcoalInfoLabelWidth',
    ],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'info-rows',
        title: 'Plan details',
        description: 'Two key/value rows.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
  'CharcoalBatchBar': ComponentMetadata(
    category: 'Admin',
    summary:
        'The toolbar above a batch-selectable list: select mode toggle, selected count and delete.',
    keywords: <String>[
      'batch',
      'bulk',
      'selection mode',
      'delete',
      'toolbar',
    ],
    useWhen: <String>[
      'A list supports selecting several records and acting on them.',
    ],
    avoidWhen: <String>[
      'A single-record action; use a button in the row.',
    ],
    accessibility: <String>[
      'Toggling mode and the selected count are announced; destructive delete is a labelled button.',
    ],
    responsiveBehavior: <String>[
      'Actions collapse to the available width; labels are localised through parameters.',
    ],
    interactionStates: <String>[
      'browsing',
      'selecting',
    ],
    feedbackResponsibilities: <String>[
      'Owns the bar layout and mode presentation.',
      'The caller owns the selection state, deletion and its result.',
    ],
    tokenRoles: <String>[
      'colors.surfaceSecondary',
      'space.md',
    ],
    relatedComponents: <String>[
      'CharcoalList',
      'CharcoalSelectionBox',
    ],
    companionDeclarations: <String>[],
    examples: <ExampleMetadata>[
      ExampleMetadata(
        id: 'batch-bar',
        title: 'Batch toolbar',
        description: 'Toggle select mode and delete.',
        sourcePath: 'example/lib/agent_examples/admin_example.dart',
      ),
    ],
  ),
};
