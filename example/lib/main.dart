import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() => runCharcoalShowcase();

void runCharcoalShowcase() => runApp(const CharcoalShowcaseApp());

final class CharcoalShowcaseApp extends StatefulWidget {
  const CharcoalShowcaseApp({super.key});

  @override
  State<CharcoalShowcaseApp> createState() => _CharcoalShowcaseAppState();
}

final class _CharcoalShowcaseAppState extends State<CharcoalShowcaseApp> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) => CharcoalApp(
    title: 'Charcoal UI V2 Showcase',
    themeMode: _darkMode ? CharcoalThemeMode.dark : CharcoalThemeMode.light,
    home: _ShowcasePage(
      darkMode: _darkMode,
      onDarkModeChanged: (value) => setState(() => _darkMode = value),
    ),
  );
}

final class _ShowcasePage extends StatefulWidget {
  const _ShowcasePage({
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<_ShowcasePage> createState() => _ShowcasePageState();
}

final class _ShowcasePageState extends State<_ShowcasePage> {
  static const _desktopLayoutMinWidth = 1024.0;
  static const _navigationOrder = <String>[
    'Overview',
    'Colors',
    'Typography',
    'Dimensions',
    'Icons',
    'Buttons',
    'Selection',
    'Fields',
    'Navigation',
    'Content',
    'Feedback',
    'Token pipeline',
  ];

  final Map<String, double> _scrollOffsets = <String, double>{};
  final Set<ScrollController> _retiredScrollControllers = <ScrollController>{};
  ScrollController _scrollController = ScrollController();

  bool _includeOriginals = true;
  bool _receiveUpdates = true;
  bool _showNotifications = true;
  int _currentPage = 3;
  String _layout = 'grid';
  bool _mobileNavigationOpen = false;
  String _navItem = 'Overview';
  double _pageTransitionDirection = 1;
  String _privacy = 'public';
  String? _workType = 'illustration';

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _retiredScrollControllers) {
      controller.dispose();
    }
    _retiredScrollControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final systemOverlayStyle =
        (theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
              statusBarColor: theme.colors.backgroundDefault,
              systemNavigationBarColor: theme.colors.backgroundDefault,
              systemNavigationBarDividerColor: theme.colors.borderSecondary,
            );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: ColoredBox(
        color: theme.colors.backgroundDefault,
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= _desktopLayoutMinWidth
              ? _buildDesktopShell(context, theme)
              : _buildMobileShell(context, theme),
        ),
      ),
    );
  }

  Widget _buildDesktopShell(BuildContext context, CharcoalThemeData theme) =>
      ColoredBox(
        key: const ValueKey<String>('showcase-desktop-shell'),
        color: theme.colors.backgroundSecondary,
        child: Row(
          children: <Widget>[
            _Sidebar(selected: _navItem, onSelected: _selectNavigation),
            const _SidebarDivider(),
            Expanded(
              child: Column(
                children: <Widget>[
                  _Header(
                    darkMode: widget.darkMode,
                    onDarkModeChanged: widget.onDarkModeChanged,
                    title: _navItem,
                  ),
                  Expanded(child: _buildPageSwitcher(context, compact: false)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildMobileShell(BuildContext context, CharcoalThemeData theme) =>
      PopScope<void>(
        canPop: !_mobileNavigationOpen,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _mobileNavigationOpen) {
            setState(() => _mobileNavigationOpen = false);
          }
        },
        child: SafeArea(
          child: ColoredBox(
            key: const ValueKey<String>('showcase-mobile-shell'),
            color: theme.colors.backgroundSecondary,
            child: Column(
              children: <Widget>[
                _MobileHeader(
                  darkMode: widget.darkMode,
                  navigationOpen: _mobileNavigationOpen,
                  onDarkModeChanged: widget.onDarkModeChanged,
                  onNavigationToggle: () => setState(
                    () => _mobileNavigationOpen = !_mobileNavigationOpen,
                  ),
                  title: _navItem,
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ExcludeSemantics(
                        excluding: _mobileNavigationOpen,
                        child: IgnorePointer(
                          ignoring: _mobileNavigationOpen,
                          child: _buildPageSwitcher(context, compact: true),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: CharcoalMotion.resolveDuration(
                          context,
                          CharcoalMotion.standard,
                        ),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(-0.04, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: CharcoalMotion.emphasizedCurve,
                                  ),
                                ),
                            child: child,
                          ),
                        ),
                        child: _mobileNavigationOpen
                            ? _MobileNavigationPanel(
                                key: const ValueKey<String>(
                                  'showcase-mobile-navigation',
                                ),
                                onSelected: _selectNavigation,
                                selected: _navItem,
                              )
                            : const SizedBox.shrink(
                                key: ValueKey<String>(
                                  'showcase-mobile-navigation-closed',
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildPageSwitcher(BuildContext context, {required bool compact}) =>
      ClipRect(
        key: const ValueKey<String>('showcase-page-viewport-clip'),
        child: AnimatedSwitcher(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.standard,
          ),
          layoutBuilder: (currentChild, previousChildren) => Stack(
            fit: StackFit.expand,
            children: <Widget>[...previousChildren, ?currentChild],
          ),
          transitionBuilder: (child, animation) => _DirectionalPageTransition(
            animation: animation,
            direction: _pageTransitionDirection,
            child: child,
          ),
          child: _ShowcasePageViewport(
            key: ValueKey<String>('page-$_navItem'),
            compact: compact,
            controller: _scrollController,
            page: _navItem,
            child: _buildSelectedPage(),
          ),
        ),
      );

  void _selectNavigation(String value) {
    if (value == _navItem) {
      if (_mobileNavigationOpen) {
        setState(() => _mobileNavigationOpen = false);
      }
      return;
    }
    if (_scrollController.hasClients) {
      _scrollOffsets[_navItem] = _scrollController.offset;
    }
    final outgoingController = _scrollController;
    final previousIndex = _navigationOrder.indexOf(_navItem);
    final nextIndex = _navigationOrder.indexOf(value);
    final nextController = ScrollController(
      initialScrollOffset: _scrollOffsets[value] ?? 0,
    );
    setState(() {
      _mobileNavigationOpen = false;
      _navItem = value;
      _pageTransitionDirection = nextIndex >= previousIndex ? 1 : -1;
      _scrollController = nextController;
    });
    _retiredScrollControllers.add(outgoingController);
    const transitionDuration = CharcoalMotion.standard;
    Future<void>.delayed(
      transitionDuration + const Duration(milliseconds: 50),
      () {
        if (_retiredScrollControllers.remove(outgoingController)) {
          outgoingController.dispose();
        }
      },
    );
  }

  Widget _buildSelectedPage() => switch (_navItem) {
    'Colors' => const _ColorsPage(),
    'Typography' => const _TypographyPage(),
    'Dimensions' => const _DimensionsPage(),
    'Icons' => const _IconsPage(),
    'Buttons' => const _ButtonsPage(),
    'Selection' => _buildSelectionPage(),
    'Fields' => _buildFieldsPage(),
    'Navigation' => _buildNavigationPage(),
    'Content' => const _ContentPage(),
    'Feedback' => _buildFeedbackPage(),
    'Token pipeline' => const _TokenPipelinePage(),
    _ => _OverviewPage(onSelected: _selectNavigation),
  };

  Widget _buildSelectionPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _PageIntro(
        description: 'Checkbox, MultiSelect, Radio, and Switch shown across variants, validation, and disabled states.',
        eyebrow: 'COMPONENTS · SELECTION',
        title: 'Selection controls',
      ),
      const SizedBox(height: 24),
      _CatalogGrid(
        children: <Widget>[
          _ShowcaseCard(
            description: 'Square, rounded, invalid, selected, and disabled.',
            eyebrow: 'CHECKBOX',
            title: 'Checkbox',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalCheckbox(
                  key: const ValueKey<String>('receive-updates-checkbox'),
                  label: const Text('Receive product updates'),
                  onChanged: (value) => setState(() => _receiveUpdates = value),
                  value: _receiveUpdates,
                ),
                const SizedBox(height: 16),
                CharcoalCheckbox(
                  label: const Text('Rounded selection'),
                  onChanged: (value) =>
                      setState(() => _includeOriginals = value),
                  rounded: true,
                  value: _includeOriginals,
                ),
                const SizedBox(height: 16),
                CharcoalCheckbox(
                  invalid: true,
                  label: const Text('Invalid selection'),
                  onChanged: (value) =>
                      setState(() => _includeOriginals = value),
                  value: false,
                ),
                const SizedBox(height: 16),
                const CharcoalCheckbox(
                  label: Text('Disabled selected'),
                  onChanged: null,
                  value: true,
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'Normal and overlay indicators with controlled state.',
            eyebrow: 'MULTI SELECT',
            title: 'MultiSelect',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalMultiSelect(
                  label: const Text('Include original files'),
                  onChanged: (value) =>
                      setState(() => _includeOriginals = value),
                  selected: _includeOriginals,
                ),
                const SizedBox(height: 16),
                CharcoalMultiSelect(
                  label: const Text('Overlay variant'),
                  onChanged: (value) => setState(() => _receiveUpdates = value),
                  selected: _receiveUpdates,
                  variant: CharcoalMultiSelectVariant.overlay,
                ),
                const SizedBox(height: 16),
                const CharcoalMultiSelect(
                  label: Text('Disabled'),
                  onChanged: null,
                  selected: false,
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'Mutually exclusive values with an invalid example.',
            eyebrow: 'RADIO',
            title: 'Radio group',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final option in <String>[
                  'public',
                  'private',
                  'followers',
                ]) ...<Widget>[
                  CharcoalRadio<String>(
                    groupValue: _privacy,
                    invalid: option == 'followers',
                    label: Text(option[0].toUpperCase() + option.substring(1)),
                    onChanged: (value) => setState(() => _privacy = value),
                    value: option,
                  ),
                  const SizedBox(height: 14),
                ],
                const CharcoalRadio<String>(
                  groupValue: 'disabled',
                  label: Text('Disabled'),
                  onChanged: null,
                  value: 'disabled',
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'On, off, and disabled switch states.',
            eyebrow: 'SWITCH',
            title: 'Switch',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalSwitch(
                  label: const Text('Show notifications'),
                  onChanged: (value) =>
                      setState(() => _showNotifications = value),
                  value: _showNotifications,
                ),
                const SizedBox(height: 18),
                CharcoalSwitch(
                  label: const Text('Receive updates'),
                  onChanged: (value) => setState(() => _receiveUpdates = value),
                  value: _receiveUpdates,
                ),
                const SizedBox(height: 18),
                const CharcoalSwitch(
                  label: Text('Disabled'),
                  onChanged: null,
                  value: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildFieldsPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _PageIntro(
        description: 'Labels, single-line and multiline inputs, validation, counters, disabled states, and dropdown menus.',
        eyebrow: 'COMPONENTS · FIELDS',
        title: 'Fields and menus',
      ),
      const SizedBox(height: 24),
      _CatalogGrid(
        children: <Widget>[
          _ShowcaseCard(
            description:
                'Label, required marker, and trailing sub-label composition.',
            eyebrow: 'FIELD LABEL',
            title: 'FieldLabel',
            child: Column(
              children: <Widget>[
                CharcoalFieldLabel(label: 'Display name'),
                SizedBox(height: 18),
                CharcoalFieldLabel(
                  label: 'Description',
                  required: true,
                  subLabel: Text('0/500'),
                ),
              ],
            ),
          ),
          const _ShowcaseCard(
            description: 'Default, invalid, and disabled single-line states.',
            eyebrow: 'TEXT FIELD',
            title: 'TextField',
            child: Column(
              children: <Widget>[
                CharcoalTextField(
                  key: ValueKey<String>('display-name-field'),
                  assistiveText: 'Use 3–20 characters',
                  label: 'Display name',
                  maxLength: 20,
                  placeholder: 'pixiv user',
                  required: true,
                  showCount: true,
                  showLabel: true,
                ),
                SizedBox(height: 22),
                CharcoalTextField(
                  assistiveText: 'This value is required',
                  invalid: true,
                  label: 'Invalid field',
                  placeholder: 'Required',
                  showLabel: true,
                ),
                SizedBox(height: 22),
                CharcoalTextField(
                  assistiveText: 'Editing is unavailable',
                  disabled: true,
                  label: 'Disabled field',
                  placeholder: 'Disabled',
                  showLabel: true,
                ),
              ],
            ),
          ),
          const _ShowcaseCard(
            description: 'Multiline editing follows the source row, label, and counter metrics.',
            eyebrow: 'TEXT AREA',
            title: 'TextArea',
            child: Column(
              children: <Widget>[
                CharcoalTextArea(
                  assistiveText: 'Markdown is supported',
                  label: 'Description',
                  maxLength: 500,
                  placeholder: 'Write a description',
                  required: true,
                  rows: 4,
                  showCount: true,
                  showLabel: true,
                ),
                SizedBox(height: 22),
                CharcoalTextArea(
                  assistiveText: 'Description is too short',
                  invalid: true,
                  label: 'Invalid description',
                  placeholder: 'Add more detail',
                  rows: 3,
                  showLabel: true,
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description:
                'Selected, placeholder, disabled option, and field metadata.',
            eyebrow: 'DROPDOWN',
            title: 'Dropdown',
            child: Column(
              children: <Widget>[
                CharcoalDropdown<String>(
                  key: const ValueKey<String>('work-type-dropdown'),
                  assistiveText: 'Choose the format of your work',
                  label: 'Work type',
                  onChanged: (value) => setState(() => _workType = value),
                  options: const <CharcoalDropdownOption<String>>[
                    CharcoalDropdownOption<String>(
                      label: 'Illustration',
                      value: 'illustration',
                    ),
                    CharcoalDropdownOption<String>(
                      label: 'Manga',
                      secondary: 'A work with multiple pages',
                      value: 'manga',
                    ),
                    CharcoalDropdownOption<String>(
                      label: 'Novel',
                      value: 'novel',
                    ),
                    CharcoalDropdownOption<String>(
                      enabled: false,
                      label: 'Animation (unavailable)',
                      value: 'animation',
                    ),
                  ],
                  placeholder: 'Choose a type',
                  required: true,
                  showLabel: true,
                  value: _workType,
                ),
                const SizedBox(height: 22),
                const CharcoalDropdown<String>(
                  disabled: true,
                  label: 'Disabled menu',
                  onChanged: null,
                  options: <CharcoalDropdownOption<String>>[
                    CharcoalDropdownOption<String>(
                      label: 'Illustration',
                      value: 'illustration',
                    ),
                  ],
                  showLabel: true,
                  value: 'illustration',
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildNavigationPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _PageIntro(
        description: 'Segmented selection, small and medium pagination, and both carousel presentation modes.',
        eyebrow: 'COMPONENTS · NAVIGATION',
        title: 'Navigation and paging',
      ),
      const SizedBox(height: 24),
      _CatalogGrid(
        children: <Widget>[
          _ShowcaseCard(
            description: 'Intrinsic and full-width arrangements with a disabled segment.',
            eyebrow: 'SEGMENTED CONTROL',
            title: 'SegmentedControl',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalSegmentedControl<String>(
                  value: _layout,
                  onChanged: (value) => setState(() => _layout = value),
                  segments: const <CharcoalSegment<String>>[
                    CharcoalSegment<String>(child: Text('Grid'), value: 'grid'),
                    CharcoalSegment<String>(child: Text('List'), value: 'list'),
                  ],
                ),
                const SizedBox(height: 18),
                CharcoalSegmentedControl<String>(
                  fullWidth: true,
                  value: _layout,
                  onChanged: (value) => setState(() => _layout = value),
                  segments: const <CharcoalSegment<String>>[
                    CharcoalSegment<String>(child: Text('Grid'), value: 'grid'),
                    CharcoalSegment<String>(child: Text('List'), value: 'list'),
                    CharcoalSegment<String>(
                      child: Text('Compact'),
                      enabled: false,
                      value: 'compact',
                    ),
                  ],
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description:
                'Page windows, ellipsis behavior, and disabled edge actions.',
            eyebrow: 'PAGINATION',
            title: 'Pagination',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxVisiblePages = constraints.maxWidth < 300 ? 3 : 5;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CharcoalPagination(
                      currentPage: _currentPage,
                      maxVisiblePages: maxVisiblePages,
                      onPageChanged: (value) =>
                          setState(() => _currentPage = value),
                      pageCount: 12,
                      size: CharcoalPaginationSize.small,
                    ),
                    const SizedBox(height: 20),
                    CharcoalPagination(
                      currentPage: _currentPage,
                      maxVisiblePages: maxVisiblePages,
                      onPageChanged: (value) =>
                          setState(() => _currentPage = value),
                      pageCount: 12,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      const _CarouselGallery(),
    ],
  );

  Widget _buildFeedbackPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _PageIntro(
        description: 'Hints, tooltips, balloons, live-region toasts, loading presentations, and modal surfaces.',
        eyebrow: 'COMPONENTS · FEEDBACK',
        title: 'Feedback and overlays',
      ),
      const SizedBox(height: 24),
      _CatalogGrid(
        children: <Widget>[
          _ShowcaseCard(
            description: 'Text, subtitle, info icon, visibility, alignment, and action slots.',
            eyebrow: 'HINT TEXT',
            title: 'HintText',
            child: const Column(
              children: <Widget>[
                CharcoalHintText(
                  action: CharcoalButton(
                    onPressed: _noop,
                    size: CharcoalButtonSize.small,
                    variant: CharcoalButtonVariant.primary,
                    child: Text('Review'),
                  ),
                  subtitle: Text('You can change this later.'),
                  child: Text('Changes are saved automatically.'),
                ),
                SizedBox(height: 16),
                CharcoalHintText(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  child: Text('This message applies to the whole page.'),
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'Click, tap, hover, or focus a trigger. Automatic collision handling follows the anchor.',
            eyebrow: 'TOOLTIP',
            title: 'Tooltip positions',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                for (final position in CharcoalOverlayPosition.values)
                  CharcoalTooltip(
                    message: '${_displayTokenName(position.name)} tooltip',
                    position: position,
                    child: CharcoalButton(
                      key: ValueKey<String>('tooltip-${position.name}'),
                      onPressed: _noop,
                      size: CharcoalButtonSize.small,
                      child: Text(_displayTokenName(position.name)),
                    ),
                  ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'A continuous outlined path plus the interactive anchored iOS presentation.',
            eyebrow: 'BALLOON',
            title: 'Balloon directions',
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final position in CharcoalOverlayPosition.values)
                  CharcoalBalloon(
                    key: ValueKey<String>('balloon-${position.name}'),
                    position: position,
                    child: Text('Balloon'),
                  ),
                CharcoalAnchoredBalloon(
                  anchor: CharcoalButton(
                    key: const ValueKey<String>('anchored-balloon-trigger'),
                    onPressed: _noop,
                    size: CharcoalButtonSize.small,
                    child: const Text('Anchored balloon'),
                  ),
                  dismissIcon: const CharcoalIcon(CharcoalIcons20.x),
                  message: 'A controlled Charcoal balloon',
                  action: const Text('Learn more'),
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description:
                'Success and error capsules animate from either screen edge.',
            eyebrow: 'TOAST',
            title: 'Toasts',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  key: const ValueKey<String>('show-default-toast'),
                  onPressed: () => showCharcoalToast(
                    context: context,
                    message: 'Your changes were saved.',
                    variant: CharcoalToastVariant.success,
                  ),
                  size: CharcoalButtonSize.small,
                  child: const Text('Default toast'),
                ),
                CharcoalButton(
                  key: const ValueKey<String>('show-negative-toast'),
                  onPressed: () => showCharcoalToast(
                    context: context,
                    message: 'The upload could not be completed.',
                    variant: CharcoalToastVariant.error,
                  ),
                  size: CharcoalButtonSize.small,
                  variant: CharcoalButtonVariant.danger,
                  child: const Text('Error toast'),
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'Bordered messages support a 64px thumbnail, action, edge placement, and swipe-to-dismiss.',
            eyebrow: 'SNACKBAR',
            title: 'Snackbars',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  key: const ValueKey<String>('show-bottom-snackbar'),
                  onPressed: () => showCharcoalSnackBar(
                    context: context,
                    message: 'Bookmarked',
                    action: const CharcoalButton(
                      onPressed: _noop,
                      size: CharcoalButtonSize.small,
                      child: Text('Edit'),
                    ),
                  ),
                  size: CharcoalButtonSize.small,
                  child: const Text('Bottom snackbar'),
                ),
                CharcoalButton(
                  key: const ValueKey<String>('show-top-snackbar'),
                  onPressed: () => showCharcoalSnackBar(
                    context: context,
                    edge: CharcoalPopupEdge.top,
                    message: 'Preview generated',
                    thumbnail: const ColoredBox(
                      color: Color(0xFF0096FA),
                      child: Center(child: CharcoalIcon(CharcoalIcons.image)),
                    ),
                  ),
                  size: CharcoalButtonSize.small,
                  child: const Text('Top with thumbnail'),
                ),
              ],
            ),
          ),
          const _ShowcaseCard(
            description: '48px expanding circles, custom sizes, transparent surfaces, and blocking overlays.',
            eyebrow: 'LOADING',
            title: 'LoadingSpinner',
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 18,
              runSpacing: 18,
              children: <Widget>[
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-default'),
                ),
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-small'),
                  size: 32,
                  padding: 14,
                ),
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-transparent'),
                  transparent: true,
                ),
                CharcoalLoadingSpinner(
                  key: ValueKey<String>('spinner-large'),
                  size: 64,
                ),
                SizedBox(
                  width: 112,
                  height: 96,
                  child: CharcoalSpinnerOverlay(
                    interactionPassthrough: true,
                    visible: true,
                    child: ColoredBox(
                      color: Color(0x0C000000),
                      child: Center(child: Text('Overlay')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _ShowcaseCard(
            description: 'Centered and bottom-sheet presentations with matching motion and close behavior.',
            eyebrow: 'MODAL',
            title: 'Modals',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final style in CharcoalModalStyle.values)
                  CharcoalButton(
                    key: ValueKey<String>('show-modal-${style.name}'),
                    onPressed: () => _showDialog(context, style: style),
                    size: CharcoalButtonSize.small,
                    child: Text(_displayTokenName(style.name)),
                  ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  // Kept as a compact specimen used while comparing the expanded catalog.
  // ignore: unused_element
  Widget _buildComponentsPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _PageIntro(
        eyebrow: 'COMPONENTS',
        title: 'Composable V2 widgets',
        description: 'Every control below is implemented directly on Flutter Widgets from pinned Charcoal source references.',
      ),
      const SizedBox(height: 24),
      LayoutBuilder(
        builder: (context, constraints) {
          final twoColumns = constraints.maxWidth >= 760;
          final cardWidth = twoColumns
              ? (constraints.maxWidth - 20) / 2
              : constraints.maxWidth;
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: <Widget>[
              SizedBox(width: cardWidth, child: _buildButtonsCard()),
              SizedBox(width: cardWidth, child: _buildSelectionCard()),
              SizedBox(width: cardWidth, child: _buildFormCard()),
              SizedBox(width: cardWidth, child: _buildNavigationCard()),
              SizedBox(width: cardWidth, child: _buildTagsCard()),
              SizedBox(width: cardWidth, child: _buildFeedbackCard()),
            ],
          );
        },
      ),
      const SizedBox(height: 20),
      const _CarouselCard(),
    ],
  );

  Widget _buildButtonsCard() => _ShowcaseCard(
    eyebrow: 'ACTIONS',
    title: 'Buttons',
    description: 'Variants and sizing follow the source component; semantic colors come from V2 foundations.',
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        CharcoalButton(
          variant: CharcoalButtonVariant.primary,
          onPressed: () {},
          child: const Text('Publish work'),
        ),
        CharcoalButton(onPressed: () {}, child: const Text('Save draft')),
        CharcoalButton(
          variant: CharcoalButtonVariant.danger,
          onPressed: () {},
          child: const Text('Delete'),
        ),
        const CharcoalButton(onPressed: null, child: Text('Disabled')),
      ],
    ),
  );

  Widget _buildSelectionCard() => _ShowcaseCard(
    eyebrow: 'INPUTS',
    title: 'Selection controls',
    description:
        'Controlled widgets expose native keyboard and pointer interactions.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CharcoalCheckbox(
          value: _receiveUpdates,
          onChanged: (value) => setState(() => _receiveUpdates = value),
          label: const Text('Receive product updates'),
        ),
        const SizedBox(height: 16),
        CharcoalMultiSelect(
          selected: _includeOriginals,
          onChanged: (value) => setState(() => _includeOriginals = value),
          label: const Text('Include original files'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: <Widget>[
            CharcoalRadio<String>(
              value: 'public',
              groupValue: _privacy,
              onChanged: (value) => setState(() => _privacy = value),
              label: const Text('Public'),
            ),
            CharcoalRadio<String>(
              value: 'private',
              groupValue: _privacy,
              onChanged: (value) => setState(() => _privacy = value),
              label: const Text('Private'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CharcoalSwitch(
          value: _showNotifications,
          onChanged: (value) => setState(() => _showNotifications = value),
          label: const Text('Show notifications'),
        ),
      ],
    ),
  );

  Widget _buildFormCard() => _ShowcaseCard(
    eyebrow: 'FORMS',
    title: 'Fields and menus',
    description:
        'EditableText and OverlayPortal power the controls without Material.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const CharcoalTextField(
          assistiveText: 'Use 3–20 characters',
          label: 'Display name',
          maxLength: 20,
          placeholder: 'pixiv user',
          required: true,
          showCount: true,
          showLabel: true,
        ),
        const SizedBox(height: 20),
        CharcoalDropdown<String>(
          assistiveText: 'Choose the format of your work',
          label: 'Work type',
          onChanged: (value) => setState(() => _workType = value),
          options: const <CharcoalDropdownOption<String>>[
            CharcoalDropdownOption<String>(
              value: 'illustration',
              label: 'Illustration',
            ),
            CharcoalDropdownOption<String>(
              value: 'manga',
              label: 'Manga',
              secondary: 'A work with multiple pages',
            ),
            CharcoalDropdownOption<String>(value: 'novel', label: 'Novel'),
          ],
          placeholder: 'Choose a type',
          required: true,
          showLabel: true,
          value: _workType,
        ),
      ],
    ),
  );

  Widget _buildNavigationCard() => _ShowcaseCard(
    eyebrow: 'NAVIGATION',
    title: 'View and pagination',
    description: 'Responsive controls preserve the same token-driven interaction states.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CharcoalSegmentedControl<String>(
          fullWidth: true,
          value: _layout,
          onChanged: (value) => setState(() => _layout = value),
          segments: const <CharcoalSegment<String>>[
            CharcoalSegment<String>(value: 'grid', child: Text('Grid')),
            CharcoalSegment<String>(value: 'list', child: Text('List')),
            CharcoalSegment<String>(value: 'compact', child: Text('Compact')),
          ],
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: CharcoalPagination(
            currentPage: _currentPage,
            maxVisiblePages: 5,
            onPageChanged: (value) => setState(() => _currentPage = value),
            pageCount: 12,
            size: CharcoalPaginationSize.small,
          ),
        ),
      ],
    ),
  );

  Widget _buildTagsCard() => _ShowcaseCard(
    eyebrow: 'METADATA',
    title: 'Tag items',
    description: 'Normal, selected, translated, inactive, and disabled states.',
    child: Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        CharcoalTagItem(label: '#landscape', onPressed: () {}),
        CharcoalTagItem(
          label: '#original',
          onPressed: () {},
          status: CharcoalTagItemStatus.active,
        ),
        CharcoalTagItem(
          label: '#創作',
          onPressed: () {},
          translatedLabel: 'original work',
        ),
        CharcoalTagItem(
          label: '#inactive',
          onPressed: () {},
          status: CharcoalTagItemStatus.inactive,
        ),
        const CharcoalTagItem(label: '#disabled', onPressed: null),
      ],
    ),
  );

  Widget _buildFeedbackCard() => _ShowcaseCard(
    eyebrow: 'FEEDBACK',
    title: 'Hints, loading, and dialogs',
    description:
        'Overlay surfaces and motion are composed from the Widgets layer.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const CharcoalHintText(
          icon: CharcoalIcon(CharcoalIcons.infoCircle),
          child: Text('Changes are saved automatically.'),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            const CharcoalLoadingSpinner(size: 18, padding: 8),
            const SizedBox(width: 16),
            Expanded(
              child: CharcoalButton(
                fullWidth: true,
                variant: CharcoalButtonVariant.primary,
                onPressed: () => _showDialog(context),
                child: const Text('Open Charcoal dialog'),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  void _showDialog(
    BuildContext context, {
    CharcoalDialogSize size = CharcoalDialogSize.medium,
    CharcoalModalStyle style = CharcoalModalStyle.center,
  }) {
    showCharcoalDialog<void>(
      context: context,
      style: style,
      builder: (dialogContext) => CharcoalDialog(
        closeIcon: const CharcoalIcon(CharcoalIcons.x),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        onDismiss: () => Navigator.of(dialogContext).pop(),
        showCloseButton: true,
        size: size,
        style: style,
        title: 'Ready to publish?',
        actions: <Widget>[
          CharcoalButton(
            key: const ValueKey<String>('modal-publish'),
            fullWidth: true,
            variant: CharcoalButtonVariant.primary,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Publish'),
          ),
          CharcoalButton(
            key: const ValueKey<String>('modal-cancel'),
            fullWidth: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
        child: const Text(
          'This dialog is built without Material or Cupertino dependencies.',
        ),
      ),
    );
  }
}

final class _DirectionalPageTransition extends StatelessWidget {
  const _DirectionalPageTransition({
    required this.animation,
    required this.child,
    required this.direction,
  });

  final Animation<double> animation;
  final Widget child;
  final double direction;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (context, child) {
      final progress = CharcoalMotion.emphasizedCurve.transform(
        animation.value,
      );
      final exiting = animation.status == AnimationStatus.reverse;
      final distance = exiting ? -0.006 : 0.012;
      return FractionalTranslation(
        translation: Offset(direction * distance * (1 - progress), 0),
        child: child,
      );
    },
  );
}

final class _ShowcasePageViewport extends StatelessWidget {
  const _ShowcasePageViewport({
    required this.child,
    required this.compact,
    required this.controller,
    required this.page,
    super.key,
  });

  final Widget child;
  final bool compact;
  final ScrollController controller;
  final String page;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return RepaintBoundary(
      child: ColoredBox(
        color: theme.colors.backgroundSecondary,
        child: RawScrollbar(
          controller: controller,
          crossAxisMargin: compact ? 2 : 4,
          fadeDuration: CharcoalMotion.standard,
          interactive: !compact,
          radius: Radius.circular(theme.dimensions.radius.oval),
          thickness: compact ? 3 : 6,
          thumbColor: theme.colors.containerTertiaryDefault,
          child: SingleChildScrollView(
            key: ValueKey<String>('page-scroll-$page'),
            controller: controller,
            padding: compact
                ? const EdgeInsets.fromLTRB(16, 20, 16, 32)
                : const EdgeInsets.fromLTRB(32, 30, 32, 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _Header extends StatelessWidget {
  const _Header({
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.title,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: <Widget>[
              Text(
                title,
                style: theme.textStyles.headingXxs.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              const Spacer(),
              CharcoalSwitch(
                key: const ValueKey<String>('dark-mode-switch'),
                value: darkMode,
                onChanged: onDarkModeChanged,
                label: const Text('Dark mode'),
              ),
              const SizedBox(width: 20),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colors.containerDiscoveryDefault,
                ),
                child: SizedBox.square(
                  dimension: 36,
                  child: Center(
                    child: Text(
                      'V2',
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textOnDiscoveryDefault,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _MobileHeader extends StatelessWidget {
  const _MobileHeader({
    required this.darkMode,
    required this.navigationOpen,
    required this.onDarkModeChanged,
    required this.onNavigationToggle,
    required this.title,
  });

  final bool darkMode;
  final bool navigationOpen;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onNavigationToggle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: <Widget>[
              SizedBox.square(
                dimension: 48,
                child: CharcoalIconButton(
                  key: const ValueKey<String>(
                    'showcase-mobile-navigation-toggle',
                  ),
                  icon: CharcoalIcon(
                    navigationOpen ? CharcoalIcons.x : CharcoalIcons.list,
                  ),
                  onPressed: onNavigationToggle,
                  selected: navigationOpen,
                  semanticLabel: navigationOpen
                      ? 'Close navigation'
                      : 'Open navigation',
                  size: CharcoalIconButtonSize.medium,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  key: const ValueKey<String>('showcase-mobile-title'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.bodyBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox.square(
                dimension: 48,
                child: CharcoalIconButton(
                  key: const ValueKey<String>('showcase-mobile-dark-mode'),
                  icon: const CharcoalIcon(CharcoalIcons.sun),
                  onPressed: () => onDarkModeChanged(!darkMode),
                  selected: darkMode,
                  semanticLabel: darkMode ? 'Use light mode' : 'Use dark mode',
                  size: CharcoalIconButtonSize.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _MobileNavigationPanel extends StatelessWidget {
  const _MobileNavigationPanel({
    required this.onSelected,
    required this.selected,
    super.key,
  });

  final ValueChanged<String> onSelected;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Showcase navigation',
      child: ColoredBox(
        color: theme.colors.backgroundDefault,
        child: SingleChildScrollView(
          key: const ValueKey<String>('showcase-mobile-navigation-scroll'),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colors.containerPrimaryDefault,
                      ),
                      child: SizedBox.square(
                        dimension: 40,
                        child: Center(
                          child: Text(
                            'C',
                            style: theme.textStyles.headingXxs.copyWith(
                              color: theme.colors.textOnPrimaryDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Charcoal UI',
                            style: theme.textStyles.bodyBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                          Text(
                            'Flutter · V2 Showcase',
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              for (final section in _Sidebar._sections) ...<Widget>[
                if (section.$1.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 15, 12, 7),
                    child: Text(
                      section.$1,
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textTertiaryDefault,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                for (final item in section.$2) ...<Widget>[
                  SizedBox(
                    height: 48,
                    child: CharcoalNavigationItem(
                      key: ValueKey<String>('nav-${item.$1}'),
                      leading: CharcoalIcon(item.$2),
                      onPressed: () => onSelected(item.$1),
                      selected: selected == item.$1,
                      semanticLabel: item.$1,
                      trailing: selected == item.$1
                          ? const CharcoalIcon(CharcoalIcons.check)
                          : null,
                      child: Text(item.$1),
                    ),
                  ),
                  SizedBox(height: theme.dimensions.space.component10),
                ],
              ],
              const SizedBox(height: 14),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colors.containerSecondaryDefault,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: theme.colors.containerPositiveDefault,
                        ),
                        child: const SizedBox.square(dimension: 8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tokens synchronized from Charcoal V2',
                          style: theme.textStyles.captionMediumBold.copyWith(
                            color: theme.colors.textDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selected, required this.onSelected});

  static const _sections = <(String, List<(String, CharcoalIconData)>)>[
    ('', <(String, CharcoalIconData)>[('Overview', CharcoalIcons.home)]),
    (
      'FOUNDATION',
      <(String, CharcoalIconData)>[
        ('Colors', CharcoalIcons.color),
        ('Typography', CharcoalIcons.text),
        ('Dimensions', CharcoalIcons.ruler),
        ('Icons', CharcoalIcons.images),
      ],
    ),
    (
      'COMPONENTS',
      <(String, CharcoalIconData)>[
        ('Buttons', CharcoalIcons.click),
        ('Selection', CharcoalIcons.checkCircle),
        ('Fields', CharcoalIcons.penText),
        ('Navigation', CharcoalIcons.compass),
        ('Content', CharcoalIcons.image),
        ('Feedback', CharcoalIcons.alert),
      ],
    ),
    (
      'SYSTEM',
      <(String, CharcoalIconData)>[('Token pipeline', CharcoalIcons.syncIcon)],
    ),
  ];

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 247,
      child: DecoratedBox(
        decoration: BoxDecoration(color: theme.colors.backgroundDefault),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colors.containerPrimaryDefault,
                      ),
                      child: SizedBox.square(
                        dimension: 40,
                        child: Center(
                          child: Text(
                            'C',
                            style: theme.textStyles.headingXxs.copyWith(
                              color: theme.colors.textOnPrimaryDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Charcoal UI',
                            style: theme.textStyles.bodyBold.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                          Text(
                            'Flutter · V2',
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      for (final section in _sections) ...<Widget>[
                        if (section.$1.isNotEmpty) ...<Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 13, 12, 7),
                            child: Text(
                              section.$1,
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textTertiaryDefault,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                        for (final item in section.$2) ...<Widget>[
                          CharcoalNavigationItem(
                            key: ValueKey<String>('nav-${item.$1}'),
                            leading: CharcoalIcon(item.$2),
                            selected: selected == item.$1,
                            semanticLabel: item.$1,
                            onPressed: () => onSelected(item.$1),
                            child: Text(item.$1),
                          ),
                          SizedBox(height: theme.dimensions.space.component10),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colors.containerSecondaryDefault,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: theme.colors.containerPositiveDefault,
                            ),
                            child: const SizedBox.square(dimension: 8),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tokens synchronized',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textStyles.captionMediumBold
                                  .copyWith(color: theme.colors.textDefault),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Generated from Charcoal V2 source files.',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _SidebarDivider extends StatelessWidget {
  const _SidebarDivider();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return RepaintBoundary(
      key: const ValueKey<String>('showcase-sidebar-divider'),
      child: SizedBox(
        width: 1,
        height: double.infinity,
        child: ColoredBox(color: theme.colors.borderSecondary),
      ),
    );
  }
}

final class _OverviewPage extends StatelessWidget {
  const _OverviewPage({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _Hero(),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final metricWidth = constraints.maxWidth >= 720
                ? (constraints.maxWidth - 40) / 3
                : constraints.maxWidth;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: <Widget>[
                _OverviewMetric(
                  accent: theme.colors.containerPrimaryDefault,
                  label: 'Compatibility layers',
                  value: '0',
                  width: metricWidth,
                ),
                _OverviewMetric(
                  accent: theme.colors.containerDiscoveryDefault,
                  label: 'Theme modes',
                  value: '2',
                  width: metricWidth,
                ),
                _OverviewMetric(
                  accent: theme.colors.containerPositiveDefault,
                  label: 'Token source',
                  value: 'V2',
                  width: metricWidth,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        _ShowcaseCard(
          eyebrow: 'EXPLORE',
          title: 'Inside the system',
          description: 'Each destination now has its own content and can be opened from here or the sidebar.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final linkWidth = constraints.maxWidth >= 720
                  ? (constraints.maxWidth - 24) / 3
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _OverviewLink(
                    description: 'Interactive controls and composed surfaces',
                    icon: CharcoalIcons.gridview,
                    onPressed: () => onSelected('Buttons'),
                    title: 'Components',
                    width: linkWidth,
                  ),
                  _OverviewLink(
                    description: 'Color, type, spacing, and radius tokens',
                    icon: CharcoalIcons.palette,
                    onPressed: () => onSelected('Colors'),
                    title: 'Foundation',
                    width: linkWidth,
                  ),
                  _OverviewLink(
                    description: 'Sync, generate, diff, and CI checks',
                    icon: CharcoalIcons.syncIcon,
                    onPressed: () => onSelected('Token pipeline'),
                    title: 'Token pipeline',
                    width: linkWidth,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

final class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.accent,
    required this.label,
    required this.value,
    required this.width,
  });

  final Color accent;
  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(16),
          color: theme.colors.backgroundDefault,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: accent,
                ),
                child: const SizedBox.square(dimension: 12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      value,
                      style: theme.textStyles.headingS.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                    Text(
                      label,
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textSecondaryDefault,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _OverviewLink extends StatelessWidget {
  const _OverviewLink({
    required this.description,
    required this.icon,
    required this.onPressed,
    required this.title,
    required this.width,
  });

  final String description;
  final CharcoalIconData icon;
  final VoidCallback onPressed;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: width,
      child: CharcoalClickable(
        onPressed: onPressed,
        semanticLabel: 'Open $title',
        builder: (context, states) {
          final pressed = states.contains(WidgetState.pressed);
          final hovered = states.contains(WidgetState.hovered);
          final background = pressed
              ? theme.colors.containerSecondaryPress
              : hovered
              ? theme.colors.containerSecondaryHover
              : theme.colors.containerSecondaryDefault;
          return AnimatedContainer(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              CharcoalMotion.standard,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: background,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CharcoalIcon(
                  icon,
                  color: theme.colors.iconNoticeDefault,
                  size: theme.dimensions.space.component40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: theme.textStyles.bodyBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
                CharcoalIcon(
                  CharcoalIcons.arrowRight,
                  color: theme.colors.iconTertiaryDefault,
                  size: theme.dimensions.space.component30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _PageIntro extends StatelessWidget {
  const _PageIntro({
    required this.description,
    required this.eyebrow,
    required this.title,
  });

  final String description;
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final eyebrowText = Text(
          eyebrow,
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textInfoDefault,
            letterSpacing: 1.2,
          ),
        );
        final badge = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: theme.colors.containerDiscoveryDefault,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              'V2',
              style: theme.textStyles.captionMediumBold.copyWith(
                color: theme.colors.textOnDiscoveryDefault,
              ),
            ),
          ),
        );
        final titleAndDescription = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style:
                  (compact
                          ? theme.textStyles.headingS
                          : theme.textStyles.headingM)
                      .copyWith(color: theme.colors.textDefault),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textStyles.body.copyWith(
                color: theme.colors.textSecondaryDefault,
              ),
            ),
          ],
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.borderSecondary),
            borderRadius: BorderRadius.circular(18),
            color: theme.colors.backgroundDefault,
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 20 : 28),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: eyebrowText),
                          const SizedBox(width: 12),
                          badge,
                        ],
                      ),
                      const SizedBox(height: 12),
                      titleAndDescription,
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            eyebrowText,
                            const SizedBox(height: 9),
                            titleAndDescription,
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      badge,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

final class _CatalogGrid extends StatelessWidget {
  const _CatalogGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final twoColumns = constraints.maxWidth >= 760;
      final cardWidth = twoColumns
          ? (constraints.maxWidth - 20) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          for (final child in children)
            SizedBox(width: cardWidth, child: child),
        ],
      );
    },
  );
}

final class _ColorsPage extends StatefulWidget {
  const _ColorsPage();

  @override
  State<_ColorsPage> createState() => _ColorsPageState();
}

final class _ColorsPageState extends State<_ColorsPage> {
  String _catalog = 'applied';

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final entries = switch (_catalog) {
      'primitive' => CharcoalPrimitiveColors.entries,
      'brand' => CharcoalBrandColors.entries,
      _ => theme.colors.entries,
    };
    final groups = _group(entries);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'The complete generated V2 palette. Applied colors follow the active light or dark theme.',
          eyebrow: 'FOUNDATION · COLOR',
          title: 'Color catalog',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) => Align(
            alignment: Alignment.centerLeft,
            child: CharcoalSegmentedControl<String>(
              fullWidth: constraints.maxWidth < 420,
              onChanged: (value) => setState(() => _catalog = value),
              segments: const <CharcoalSegment<String>>[
                CharcoalSegment<String>(
                  child: Text('Applied'),
                  value: 'applied',
                ),
                CharcoalSegment<String>(
                  child: Text('Primitive'),
                  value: 'primitive',
                ),
                CharcoalSegment<String>(child: Text('Brand'), value: 'brand'),
              ],
              semanticLabel: 'Color catalog kind',
              value: _catalog,
            ),
          ),
        ),
        const SizedBox(height: 20),
        for (final group in groups.entries) ...<Widget>[
          _ShowcaseCard(
            description: '${group.value.length} generated V2 color tokens.',
            eyebrow: _catalog.toUpperCase(),
            title: _displayTokenName(group.key),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final entry in group.value) _ColorTokenTile(entry: entry),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Map<String, List<CharcoalColorTokenEntry>> _group(
    List<CharcoalColorTokenEntry> entries,
  ) {
    final groups = <String, List<CharcoalColorTokenEntry>>{};
    for (final entry in entries) {
      final withoutCategory = entry.path.substring(entry.path.indexOf('.') + 1);
      final group = withoutCategory.split('/').first;
      groups.putIfAbsent(group, () => <CharcoalColorTokenEntry>[]).add(entry);
    }
    final keys = groups.keys.toList()..sort();
    return <String, List<CharcoalColorTokenEntry>>{
      for (final key in keys) key: groups[key]!,
    };
  }
}

final class _ColorTokenTile extends StatelessWidget {
  const _ColorTokenTile({required this.entry});

  final CharcoalColorTokenEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final shortPath = entry.path.substring(entry.path.indexOf('.') + 1);
    final argb = entry.value
        .toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase();
    return Semantics(
      label: 'Color token ${entry.path}',
      child: SizedBox(
        width: 180,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.borderSecondary),
            borderRadius: BorderRadius.circular(10),
            color: theme.colors.backgroundDefault,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.borderSecondary),
                    borderRadius: BorderRadius.circular(8),
                    color: entry.value,
                  ),
                  child: const SizedBox.square(dimension: 38),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        shortPath,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textDefault,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#$argb',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textTertiaryDefault,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _displayTokenName(String value) => value
    .split(RegExp('[-_/]'))
    .where((part) => part.isNotEmpty)
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join(' ');

final class _TypographyPage extends StatelessWidget {
  const _TypographyPage();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final fontSizes = theme.typography.fontSize.entries.toList()
      ..sort((left, right) {
        final sizeOrder = right.value.compareTo(left.value);
        return sizeOrder == 0 ? left.path.compareTo(right.path) : sizeOrder;
      });
    final lineHeights = <String, double>{
      for (final entry in theme.typography.lineHeight.entries)
        entry.path.substring('text.line-height/'.length): entry.value,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'Every generated V2 semantic text size, line height, family, and weight. The specimens update with the token pipeline.',
          eyebrow: 'FOUNDATION · TYPOGRAPHY',
          title: 'Typography catalog',
        ),
        const SizedBox(height: 24),
        _CatalogGrid(
          children: <Widget>[
            _ShowcaseCard(
              description: 'Generated family and weight primitives used by component typography.',
              eyebrow: 'TYPE PRIMITIVES',
              title: 'Font contract',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _TypographyMetadataRow(
                    label: 'Family',
                    token: theme.typography.fontFamily.entries.single.path,
                    value: theme.typography.fontFamily.sans,
                  ),
                  const SizedBox(height: 14),
                  for (final entry
                      in theme.typography.fontWeight.entries) ...<Widget>[
                    _TypographyMetadataRow(
                      label: _displayTokenName(
                        entry.path.substring('text.font-weight/'.length),
                      ),
                      token: entry.path,
                      value: 'w${entry.value.value}',
                    ),
                    if (entry != theme.typography.fontWeight.entries.last)
                      const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
            _ShowcaseCard(
              description: 'The public iOS 10/12/14/16/20 family, including regular, bold, and monospaced styles.',
              eyebrow: 'IOS PARITY',
              title: 'Component type scale',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final size in CharcoalTypographySize.values) ...<Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 58,
                          child: Text(
                            size.name.replaceFirst('size', ''),
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        Expanded(
                          child: CharcoalTypography(
                            size: size,
                            child: const Text('Regular typography'),
                          ),
                        ),
                        CharcoalTypography(
                          monospace: true,
                          size: size,
                          weight: CharcoalTypographyWeight.bold,
                          child: const Text('0123'),
                        ),
                      ],
                    ),
                    if (size != CharcoalTypographySize.values.last)
                      const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _CatalogGrid(
          children: <Widget>[
            for (final entry in fontSizes)
              _TypographyTokenCard(
                fontFamily: theme.typography.fontFamily.sans,
                fontSize: entry.value,
                lineHeight:
                    lineHeights[entry.path.substring(
                      'text.font-size/'.length,
                    )] ??
                    entry.value,
                path: entry.path,
                regularWeight: theme.typography.fontWeight.regular,
                boldWeight: theme.typography.fontWeight.bold,
              ),
          ],
        ),
      ],
    );
  }
}

final class _TypographyMetadataRow extends StatelessWidget {
  const _TypographyMetadataRow({
    required this.label,
    required this.token,
    required this.value,
  });

  final String label;
  final String token;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              Text(
                token,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textTertiaryDefault,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: theme.textStyles.captionMedium.copyWith(
            color: theme.colors.textSecondaryDefault,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

final class _TypographyTokenCard extends StatelessWidget {
  const _TypographyTokenCard({
    required this.boldWeight,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.path,
    required this.regularWeight,
  });

  final FontWeight boldWeight;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final String path;
  final FontWeight regularWeight;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final semanticName = path.substring('text.font-size/'.length);
    final baseStyle = TextStyle(
      color: theme.colors.textDefault,
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      leadingDistribution: TextLeadingDistribution.even,
    );
    return _ShowcaseCard(
      description:
          '${_number(fontSize)} px size · ${_number(lineHeight)} px line height',
      eyebrow: 'TEXT STYLE',
      title: _displayTokenName(semanticName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Design with shared decisions',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: baseStyle.copyWith(fontWeight: regularWeight),
          ),
          const SizedBox(height: 12),
          Text(
            'Design with shared decisions',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: baseStyle.copyWith(fontWeight: boldWeight),
          ),
          const SizedBox(height: 14),
          Text(
            '$path  ·  text.line-height/$semanticName',
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

String _number(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(2);

enum _DimensionKind { borderWidth, paragraphWidth, radius, space }

final class _DimensionsPage extends StatelessWidget {
  const _DimensionsPage();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'All generated V2 geometry values: spacing, radii, borders, targets, and readable paragraph widths.',
          eyebrow: 'FOUNDATION · DIMENSIONS',
          title: 'Dimension catalog',
        ),
        const SizedBox(height: 24),
        _CatalogGrid(
          children: <Widget>[
            _DimensionCatalog(
              description: 'Component, layout, padding, and target values.',
              entries: theme.dimensions.space.entries,
              kind: _DimensionKind.space,
              title: 'Space',
            ),
            _DimensionCatalog(
              description: 'Corner geometry including the oval primitive.',
              entries: theme.dimensions.radius.entries,
              kind: _DimensionKind.radius,
              title: 'Radius',
            ),
            _DimensionCatalog(
              description: 'Standard and focus-ring stroke widths.',
              entries: theme.dimensions.borderWidth.entries,
              kind: _DimensionKind.borderWidth,
              title: 'Border width',
            ),
            _DimensionCatalog(
              description: 'Compact, regular, and cozy reading measures.',
              entries: theme.dimensions.paragraphWidth.entries,
              kind: _DimensionKind.paragraphWidth,
              title: 'Paragraph width',
            ),
          ],
        ),
      ],
    );
  }
}

final class _DimensionCatalog extends StatelessWidget {
  const _DimensionCatalog({
    required this.description,
    required this.entries,
    required this.kind,
    required this.title,
  });

  final String description;
  final List<CharcoalDimensionTokenEntry> entries;
  final _DimensionKind kind;
  final String title;

  @override
  Widget build(BuildContext context) => _ShowcaseCard(
    description: '$description ${entries.length} generated tokens.',
    eyebrow: 'DIMENSION',
    title: title,
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final entry in entries)
          _DimensionTokenTile(entry: entry, kind: kind),
      ],
    ),
  );
}

final class _DimensionTokenTile extends StatelessWidget {
  const _DimensionTokenTile({required this.entry, required this.kind});

  final CharcoalDimensionTokenEntry entry;
  final _DimensionKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 180,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(10),
          color: theme.colors.backgroundDefault,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 58,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _visual(theme),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.path,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_number(entry.value)} px',
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _visual(CharcoalThemeData theme) => switch (kind) {
    _DimensionKind.radius => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSelected),
        borderRadius: BorderRadius.circular(entry.value.clamp(0, 28)),
        color: theme.colors.containerSecondaryDefaultA,
      ),
      child: const SizedBox(width: 72, height: 48),
    ),
    _DimensionKind.borderWidth => SizedBox(
      width: 112,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colors.borderSelected,
              width: entry.value.clamp(1, 12),
            ),
          ),
        ),
      ),
    ),
    _DimensionKind.paragraphWidth => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: theme.colors.containerDiscoveryDefault,
      ),
      child: SizedBox(width: (entry.value / 5).clamp(24, 150), height: 14),
    ),
    _DimensionKind.space => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: SizedBox(width: (entry.value * 2).clamp(2, 150), height: 14),
    ),
  };
}

enum _IconCatalogKind { regular, solid, compact, color }

final class _IconsPage extends StatefulWidget {
  const _IconsPage();

  @override
  State<_IconsPage> createState() => _IconsPageState();
}

final class _IconsPageState extends State<_IconsPage> {
  _IconCatalogKind _kind = _IconCatalogKind.regular;

  List<CharcoalIconData> get _icons => switch (_kind) {
    _IconCatalogKind.regular => CharcoalIcons.values,
    _IconCatalogKind.solid => CharcoalSolidIcons.values,
    _IconCatalogKind.compact => <CharcoalIconData>[
      ...CharcoalIcons16.values,
      ...CharcoalSolidIcons16.values,
      ...CharcoalIcons20.values,
      ...CharcoalSolidIcons20.values,
    ],
    _IconCatalogKind.color => CharcoalColorIcons.values,
  };

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final icons = _icons;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'The complete generated Charcoal Icons V2 package: regular, solid, compact, and authored-color SVG sources.',
          eyebrow: 'FOUNDATION · ICONS',
          title: 'Icon catalog',
        ),
        SizedBox(height: theme.dimensions.space.layout40),
        LayoutBuilder(
          builder: (context, constraints) {
            final canFitFourUniformSegments = constraints.maxWidth >= 320;
            final useUniformMobileLayout =
                canFitFourUniformSegments && constraints.maxWidth < 620;
            final control = CharcoalSegmentedControl<_IconCatalogKind>(
              fullWidth: useUniformMobileLayout,
              onChanged: (value) => setState(() => _kind = value),
              semanticLabel: 'Icon catalog style',
              value: _kind,
              segments: const <CharcoalSegment<_IconCatalogKind>>[
                CharcoalSegment(
                  value: _IconCatalogKind.regular,
                  child: Text(
                    'Regular 24',
                    key: ValueKey<String>('icon-catalog-regular'),
                  ),
                ),
                CharcoalSegment(
                  value: _IconCatalogKind.solid,
                  child: Text(
                    'Solid 24',
                    key: ValueKey<String>('icon-catalog-solid'),
                  ),
                ),
                CharcoalSegment(
                  value: _IconCatalogKind.compact,
                  child: Text(
                    '16 + 20',
                    key: ValueKey<String>('icon-catalog-compact'),
                  ),
                ),
                CharcoalSegment(
                  value: _IconCatalogKind.color,
                  child: Text(
                    'Color',
                    key: ValueKey<String>('icon-catalog-color'),
                  ),
                ),
              ],
            );
            return canFitFourUniformSegments
                ? Align(alignment: Alignment.centerLeft, child: control)
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: control,
                  );
          },
        ),
        SizedBox(height: theme.dimensions.space.layout30),
        Text(
          '${icons.length} generated assets',
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component30),
        Wrap(
          spacing: theme.dimensions.space.component25,
          runSpacing: theme.dimensions.space.component25,
          children: <Widget>[
            for (final icon in icons) _IconCatalogTile(icon: icon),
          ],
        ),
      ],
    );
  }
}

final class _IconCatalogTile extends StatelessWidget {
  const _IconCatalogTile({required this.icon});

  final CharcoalIconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 156,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
          color: theme.colors.backgroundDefault,
        ),
        child: Padding(
          padding: EdgeInsets.all(theme.dimensions.space.component25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: theme.dimensions.space.targetL,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CharcoalIcon(
                    icon,
                    color: icon.style == CharcoalIconStyle.color
                        ? null
                        : theme.colors.iconDefault,
                    size: theme.dimensions.space.component50,
                  ),
                ),
              ),
              SizedBox(height: theme.dimensions.space.component20),
              Text(
                icon.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              Text(
                '${_number(icon.nativeSize)} px · ${icon.style.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textTertiaryDefault,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ButtonsPage extends StatelessWidget {
  const _ButtonsPage();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _PageIntro(
        description: 'Every V2 button and icon-button variant, size, content slot, selected state, and disabled state.',
        eyebrow: 'COMPONENTS · ACTIONS',
        title: 'Buttons',
      ),
      const SizedBox(height: 24),
      _CatalogGrid(
        children: <Widget>[
          for (final variant in CharcoalButtonVariant.values)
            _ButtonVariantCard(variant: variant),
        ],
      ),
      const SizedBox(height: 20),
      const _ShowcaseCard(
        description: 'Leading, trailing, selected, and full-width composition.',
        eyebrow: 'BUTTON CONTENT',
        title: 'Content slots',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  leading: CharcoalIcon(CharcoalIcons.add),
                  onPressed: _noop,
                  child: Text('Create'),
                ),
                CharcoalButton(
                  onPressed: _noop,
                  trailing: CharcoalIcon(CharcoalIcons.arrowRight),
                  child: Text('Continue'),
                ),
                CharcoalButton(
                  onPressed: _noop,
                  selected: true,
                  child: Text('Selected'),
                ),
                CharcoalLinkButton(
                  onPressed: _noop,
                  child: Text('Link button'),
                ),
                _SwitchingButtonSample(),
              ],
            ),
            SizedBox(height: 14),
            CharcoalButton(
              fullWidth: true,
              onPressed: _noop,
              variant: CharcoalButtonVariant.primary,
              child: Text('Full-width primary action'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _CatalogGrid(
        children: <Widget>[
          for (final variant in CharcoalIconButtonVariant.values)
            _IconButtonVariantCard(variant: variant),
          const _ClickableCard(),
        ],
      ),
    ],
  );
}

void _noop() {}

final class _SwitchingButtonSample extends StatefulWidget {
  const _SwitchingButtonSample();

  @override
  State<_SwitchingButtonSample> createState() => _SwitchingButtonSampleState();
}

final class _SwitchingButtonSampleState extends State<_SwitchingButtonSample> {
  bool _following = false;

  @override
  Widget build(BuildContext context) => CharcoalSwitchingButton(
    isOn: _following,
    onButton: CharcoalButton(
      key: const ValueKey<String>('switching-button-following'),
      onPressed: () => setState(() => _following = false),
      child: const Text('Following'),
    ),
    offButton: CharcoalButton(
      key: const ValueKey<String>('switching-button-follow'),
      onPressed: () => setState(() => _following = true),
      variant: CharcoalButtonVariant.primary,
      child: const Text('Follow'),
    ),
  );
}

final class _ButtonVariantCard extends StatelessWidget {
  const _ButtonVariantCard({required this.variant});

  final CharcoalButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final onImage =
        variant == CharcoalButtonVariant.overlay ||
        variant == CharcoalButtonVariant.navigation;
    final content = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final size in CharcoalButtonSize.values)
          CharcoalButton(
            onPressed: _noop,
            size: size,
            variant: variant,
            child: Text(_displayTokenName(size.name)),
          ),
        CharcoalButton(
          onPressed: null,
          variant: variant,
          child: const Text('Disabled'),
        ),
      ],
    );
    return _ShowcaseCard(
      description: 'Small, medium, and disabled states.',
      eyebrow: 'BUTTON VARIANT',
      title: _displayTokenName(variant.name),
      child: onImage
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: <Color>[
                    theme.colors.containerDiscoveryDefault,
                    theme.colors.containerPrimaryDefault,
                  ],
                ),
              ),
              child: Padding(padding: const EdgeInsets.all(20), child: content),
            )
          : content,
    );
  }
}

final class _IconButtonVariantCard extends StatelessWidget {
  const _IconButtonVariantCard({required this.variant});

  final CharcoalIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final content = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 14,
      runSpacing: 14,
      children: <Widget>[
        for (final size in CharcoalIconButtonSize.values)
          CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons.add),
            onPressed: _noop,
            semanticLabel: '${size.name} add',
            size: size,
            variant: variant,
          ),
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.check),
          onPressed: _noop,
          selected: true,
          semanticLabel: 'Selected',
          variant: variant,
        ),
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.x),
          onPressed: null,
          semanticLabel: 'Disabled',
          variant: variant,
        ),
      ],
    );
    return _ShowcaseCard(
      description: 'Extra-small, small, medium, selected, and disabled.',
      eyebrow: 'ICON BUTTON',
      title: _displayTokenName(variant.name),
      child: variant == CharcoalIconButtonVariant.overlay
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colors.containerDiscoveryDefault,
              ),
              child: Padding(padding: const EdgeInsets.all(20), child: content),
            )
          : content,
    );
  }
}

final class _ClickableCard extends StatelessWidget {
  const _ClickableCard();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _ShowcaseCard(
      description: 'The Widgets-layer primitive exposes hover, focus, press, and disabled states.',
      eyebrow: 'PRIMITIVE',
      title: 'Clickable',
      child: CharcoalClickable(
        onPressed: _noop,
        semanticLabel: 'Interactive surface',
        builder: (context, states) {
          final pressed = states.contains(WidgetState.pressed);
          final hovered = states.contains(WidgetState.hovered);
          final label = pressed
              ? 'Pressed'
              : hovered
              ? 'Hovered'
              : 'Interactive surface';
          return AnimatedContainer(
            duration: CharcoalMotion.standard,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.borderSecondary),
              borderRadius: BorderRadius.circular(12),
              color: pressed
                  ? theme.colors.containerSecondaryPress
                  : hovered
                  ? theme.colors.containerSecondaryHover
                  : theme.colors.containerSecondaryDefault,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textStyles.bodyBold.copyWith(
                color: theme.colors.textDefault,
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _ContentPage extends StatelessWidget {
  const _ContentPage();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'Tag metadata and explicit text truncation across all public V2 sizes and states.',
          eyebrow: 'COMPONENTS · CONTENT',
          title: 'Content presentation',
        ),
        const SizedBox(height: 24),
        _CatalogGrid(
          children: <Widget>[
            _ShowcaseCard(
              description:
                  'Small and medium sizing with a custom semantic background.',
              eyebrow: 'TAG ITEM',
              title: 'Sizes',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  for (final size in CharcoalTagItemSize.values)
                    CharcoalTagItem(
                      label: '#${size.name}',
                      onPressed: _noop,
                      size: size,
                    ),
                  CharcoalTagItem(
                    backgroundColor: theme.colors.containerDiscoveryDefault,
                    label: '#discovery',
                    onPressed: _noop,
                  ),
                ],
              ),
            ),
            const _ShowcaseCard(
              description:
                  'Normal, active, inactive, translated, and disabled states.',
              eyebrow: 'TAG ITEM',
              title: 'States',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  CharcoalTagItem(label: '#landscape', onPressed: _noop),
                  CharcoalTagItem(
                    label: '#original',
                    onPressed: _noop,
                    status: CharcoalTagItemStatus.active,
                  ),
                  CharcoalTagItem(
                    label: '#創作',
                    onPressed: _noop,
                    translatedLabel: 'original work',
                  ),
                  CharcoalTagItem(
                    label: '#inactive',
                    onPressed: _noop,
                    status: CharcoalTagItemStatus.inactive,
                  ),
                  CharcoalTagItem(label: '#disabled', onPressed: null),
                ],
              ),
            ),
            _ShowcaseCard(
              description:
                  'Single-line truncation with a separate semantic label.',
              eyebrow: 'TEXT ELLIPSIS',
              title: 'One line',
              child: SizedBox(
                width: 280,
                child: CharcoalTextEllipsis(
                  'A deliberately long artwork title that cannot fit in one line',
                  semanticLabel: 'Full artwork title',
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
              ),
            ),
            _ShowcaseCard(
              description:
                  'Two-line truncation for longer descriptions and metadata.',
              eyebrow: 'TEXT ELLIPSIS',
              title: 'Multiple lines',
              child: SizedBox(
                width: 280,
                child: CharcoalTextEllipsis(
                  'Charcoal keeps overflow behavior explicit so content layouts remain predictable across compact and wide surfaces.',
                  maxLines: 2,
                  style: theme.textStyles.paragraph.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _CarouselGallery extends StatelessWidget {
  const _CarouselGallery();

  @override
  Widget build(BuildContext context) => _ShowcaseCard(
    description: 'Small carousels use full-page slides and indicators; medium carousels preview the next slide and expose navigation actions.',
    eyebrow: 'CAROUSEL',
    title: 'Carousel sizes',
    child: _CatalogGrid(
      children: const <Widget>[
        _CarouselExample(size: CharcoalCarouselSize.small),
        _CarouselExample(size: CharcoalCarouselSize.medium),
      ],
    ),
  );
}

final class _CarouselExample extends StatelessWidget {
  const _CarouselExample({required this.size});

  final CharcoalCarouselSize size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          _displayTokenName(size.name),
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: CharcoalCarousel(
            semanticLabel: '${size.name} artwork carousel',
            size: size,
            children: const <Widget>[
              _CarouselSlide(index: 1),
              _CarouselSlide(index: 2),
              _CarouselSlide(index: 3),
            ],
          ),
        ),
      ],
    );
  }
}

final class _CarouselSlide extends StatelessWidget {
  const _CarouselSlide({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = <Color>[
      theme.colors.containerPrimaryDefault,
      theme.colors.containerDiscoveryDefault,
      theme.colors.containerPositiveDefault,
    ];
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: colors[index - 1],
        ),
        child: Center(
          child: Text(
            'Artwork $index',
            style: theme.textStyles.headingXs.copyWith(
              color: theme.colors.textOnPrimaryDefault,
            ),
          ),
        ),
      ),
    );
  }
}

// Kept as a compact specimen used while comparing the expanded catalog.
// ignore: unused_element
final class _FoundationPage extends StatelessWidget {
  const _FoundationPage();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'Generated semantic tokens form the stable contract between upstream design decisions and Flutter components.',
          eyebrow: 'FOUNDATION',
          title: 'Tokens you can see',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 760;
            final cardWidth = twoColumns
                ? (constraints.maxWidth - 20) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: <Widget>[
                SizedBox(
                  width: cardWidth,
                  child: _ShowcaseCard(
                    description: 'Semantic roles stay stable while their generated values change.',
                    eyebrow: 'COLOR',
                    title: 'Color roles',
                    child: Column(
                      children: <Widget>[
                        _ColorSwatch(
                          color: theme.colors.containerPrimaryDefault,
                          label: 'Primary',
                          token: 'containerPrimaryDefault',
                        ),
                        _ColorSwatch(
                          color: theme.colors.containerDiscoveryDefault,
                          label: 'Discovery',
                          token: 'containerDiscoveryDefault',
                        ),
                        _ColorSwatch(
                          color: theme.colors.containerPositiveDefault,
                          label: 'Positive',
                          token: 'containerPositiveDefault',
                        ),
                        _ColorSwatch(
                          color: theme.colors.containerNoticeDefault,
                          label: 'Notice',
                          token: 'containerNoticeDefault',
                        ),
                        _ColorSwatch(
                          color: theme.colors.containerNegativeDefault,
                          label: 'Negative',
                          token: 'containerNegativeDefault',
                          last: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _ShowcaseCard(
                    description: 'Font metrics are composed from generated V2 typography tokens.',
                    eyebrow: 'TYPE',
                    title: 'Typography scale',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _TypeSpecimen(
                          label: 'Heading M',
                          style: theme.textStyles.headingM,
                        ),
                        _TypeSpecimen(
                          label: 'Heading S',
                          style: theme.textStyles.headingS,
                        ),
                        _TypeSpecimen(
                          label: 'Body',
                          style: theme.textStyles.body,
                        ),
                        _TypeSpecimen(
                          label: 'Caption M',
                          style: theme.textStyles.captionMedium,
                          last: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        _ShowcaseCard(
          description: 'Layout primitives are typed values, not duplicated component constants.',
          eyebrow: 'GEOMETRY',
          title: 'Spacing and radius',
          child: Wrap(
            spacing: 28,
            runSpacing: 24,
            children: <Widget>[
              _GeometryToken(label: 'component10', radius: 2, value: 4),
              _GeometryToken(label: 'component20', radius: 4, value: 8),
              _GeometryToken(label: 'component30', radius: 8, value: 16),
              _GeometryToken(label: 'component40', radius: 12, value: 24),
              _GeometryToken(
                label: 'radius.xl',
                radius: theme.dimensions.radius.xl,
                value: 48,
              ),
              _GeometryToken(
                label: 'radius.xxl',
                radius: theme.dimensions.radius.xxl,
                value: 48,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
    required this.token,
    this.last = false,
  });

  final Color color;
  final String label;
  final bool last;
  final String token;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.borderSecondary),
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: const SizedBox.square(dimension: 44),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textStyles.captionMediumBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                Text(
                  token,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textTertiaryDefault,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _TypeSpecimen extends StatelessWidget {
  const _TypeSpecimen({
    required this.label,
    required this.style,
    this.last = false,
  });

  final String label;
  final bool last;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Design with shared decisions',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(color: theme.colors.textDefault),
          ),
        ],
      ),
    );
  }
}

final class _GeometryToken extends StatelessWidget {
  const _GeometryToken({
    required this.label,
    required this.radius,
    required this.value,
  });

  final String label;
  final double radius;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 52,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: theme.colors.containerPrimaryDefault,
                ),
                child: SizedBox(width: value, height: value.clamp(8, 48)),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            label,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

final class _TokenPipelinePage extends StatelessWidget {
  const _TokenPipelinePage();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PageIntro(
          description: 'A deterministic script transaction turns upstream Charcoal JSON into typed Flutter foundation tokens.',
          eyebrow: 'AUTOMATION',
          title: 'V2 token pipeline',
        ),
        const SizedBox(height: 24),
        _ShowcaseCard(
          description: 'The checked-in manifest pins the resolved upstream commit and source hashes.',
          eyebrow: 'STATUS',
          title: 'Source is synchronized',
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colors.containerPositiveDefault,
                ),
                child: const SizedBox.square(dimension: 12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'tokens/upstream/*.json',
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textDefault,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const _ShowcaseCard(
          description: 'Run one update command when the pinned upstream foundation changes.',
          eyebrow: 'FLOW',
          title: 'From source to Flutter',
          child: Column(
            children: <Widget>[
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart sync --ref main',
                description: 'Resolve a ref to an exact commit, validate the bundle, and update the manifest.',
                number: '1',
                title: 'Acquire V2 sources',
              ),
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart generate',
                description: 'Emit typed light/dark foundations, snapshots, and the semantic diff.',
                number: '2',
                title: 'Generate Dart artifacts',
              ),
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart diff',
                description: 'Review the semantic impact before accepting a visual-system update.',
                number: '3',
                title: 'Review the change',
              ),
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart check',
                description: 'Reproduce every generated file and fail CI when source or output drifts.',
                last: true,
                number: '4',
                title: 'Enforce determinism',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const CharcoalHintText(
          alignment: Alignment.centerLeft,
          maxWidth: double.infinity,
          child: Text(
            'Use “update” to run sync + generate and produce tokens/diff.md in one transaction.',
          ),
        ),
      ],
    );
  }
}

final class _PipelineStep extends StatelessWidget {
  const _PipelineStep({
    required this.command,
    required this.description,
    required this.number,
    required this.title,
    this.last = false,
  });

  final String command;
  final String description;
  final bool last;
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: theme.colors.containerPrimaryDefault,
            ),
            child: SizedBox.square(
              dimension: 36,
              child: Center(
                child: Text(
                  number,
                  style: theme.textStyles.captionMediumBold.copyWith(
                    color: theme.colors.textOnPrimaryDefault,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textStyles.bodyBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colors.containerSecondaryDefault,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Text(
                      command,
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textDefault,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CHARCOAL UI · FLUTTER',
              style: theme.textStyles.captionMediumBold.copyWith(
                color: theme.colors.textOnPrimaryDefault,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Source-backed components,\npowered by shared foundations.',
              style:
                  (compact
                          ? theme.textStyles.headingS
                          : theme.textStyles.headingM)
                      .copyWith(color: theme.colors.textOnPrimaryDefault),
            ),
            const SizedBox(height: 12),
            Text(
              'Pure Flutter Widgets. No Material or Cupertino dependency.',
              style: theme.textStyles.body.copyWith(
                color: theme.colors.textOnPrimaryDefault.withValues(
                  alpha: 0.82,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _HeroPill(label: 'V2 only'),
                _HeroPill(label: 'Pinned sources'),
                _HeroPill(label: 'Light + dark'),
              ],
            ),
          ],
        );
        final mark = DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colors.textOnPrimaryDefault.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(20),
            color: theme.colors.textOnPrimaryDefault.withValues(alpha: 0.1),
          ),
          child: SizedBox.square(
            dimension: 130,
            child: Center(
              child: Text(
                'V2',
                style: theme.textStyles.headingXxl.copyWith(
                  color: theme.colors.textOnPrimaryDefault,
                ),
              ),
            ),
          ),
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                theme.colors.containerPrimaryDefault,
                theme.colors.containerDiscoveryDefault,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 20 : 30),
            child: compact
                ? content
                : Row(
                    children: <Widget>[
                      Expanded(child: content),
                      const SizedBox(width: 24),
                      mark,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

final class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colors.textOnPrimaryDefault.withValues(alpha: 0.14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textOnPrimaryDefault,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

final class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderSecondary),
          borderRadius: BorderRadius.circular(16),
          color: theme.colors.backgroundDefault,
        ),
        child: Padding(
          padding: EdgeInsets.all(constraints.maxWidth < 420 ? 20 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eyebrow,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textInfoDefault,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                style: theme.textStyles.headingXs.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                description,
                style: theme.textStyles.captionMedium.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
              const SizedBox(height: 22),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

final class _CarouselCard extends StatelessWidget {
  const _CarouselCard();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final slides = <(String, String, Color)>[
      ('01', 'Foundation tokens', theme.colors.containerPrimaryDefault),
      ('02', 'Composable components', theme.colors.containerDiscoveryDefault),
      ('03', 'Automated updates', theme.colors.containerPositiveDefault),
    ];
    return _ShowcaseCard(
      eyebrow: 'CONTENT',
      title: 'Carousel',
      description: 'Keyboard, pointer, page indicators, and overlay navigation are included.',
      child: SizedBox(
        height: 220,
        child: CharcoalCarousel(
          gap: 16,
          semanticLabel: 'Charcoal capabilities',
          showIndicators: true,
          children: <Widget>[
            for (final slide in slides)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: slide.$3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        slide.$1,
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textOnPrimaryDefault.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        slide.$2,
                        style: theme.textStyles.headingS.copyWith(
                          color: theme.colors.textOnPrimaryDefault,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
