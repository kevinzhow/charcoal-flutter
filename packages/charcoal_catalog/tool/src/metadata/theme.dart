import 'index.dart';

/// Catalog metadata fragment: theme.
const Map<String, ComponentMetadata> themeMetadata = <String, ComponentMetadata>{
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
    interactionStates: <String>['light', 'dark', 'restoring'],
    feedbackResponsibilities: <String>[
      'Owns the effective theme, root scroll policy, Hero controller, locale, shortcuts, and restoration scope.',
      'The application owns route definitions, deep-link parsing, durable destination state, and product localization resources.',
    ],
    tokenRoles: <String>[
      'backgroundDefault',
      'containerPrimaryDefault',
      'textDefault',
    ],
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
};
