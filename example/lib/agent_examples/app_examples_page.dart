import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mobile_app_gallery.dart';

/// Complete responsive app compositions produced through the Agent Ready
/// discovery workflow.
final class AgentAppExamplesPage extends StatefulWidget {
  const AgentAppExamplesPage({super.key});

  @override
  State<AgentAppExamplesPage> createState() => _AgentAppExamplesPageState();
}

enum _ExampleDestination { studio, projects, settings }

enum _ProjectFilter { all, shared, archived }

enum _WorkspaceVisibility { private, team, public }

final class _AgentAppExamplesPageState extends State<AgentAppExamplesPage> {
  final TextEditingController _displayNameController = TextEditingController(
    text: 'Mina Aoki',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'mina@aster.studio',
  );
  final TextEditingController _bioController = TextEditingController(
    text: 'Illustrator, color collector, and quiet-world builder.',
  );
  final List<_ProjectData> _projects = List<_ProjectData>.of(_allProjects);

  _ExampleDestination _destination = _ExampleDestination.studio;
  _ProjectFilter _projectFilter = _ProjectFilter.all;
  _WorkspaceVisibility? _visibility = _WorkspaceVisibility.team;
  final GlobalKey _exampleBodyKey = GlobalKey();
  AgentMobileApp? _selectedMobileApp;
  bool _asterSelected = false;
  bool _mobileNavigationOpen = false;
  bool _newProjectOpen = false;
  bool _productUpdates = true;
  bool _settingsSaved = false;
  bool _weeklyDigest = true;
  int _projectPage = 1;
  String _newProjectName = '';
  String? _projectStatus;
  String _projectSearch = '';

  @override
  void initState() {
    super.initState();
    _displayNameController.addListener(_onProfileFieldChanged);
    _emailController.addListener(_onProfileFieldChanged);
    _bioController.addListener(_onProfileFieldChanged);
  }

  @override
  void dispose() {
    _displayNameController.removeListener(_onProfileFieldChanged);
    _emailController.removeListener(_onProfileFieldChanged);
    _bioController.removeListener(_onProfileFieldChanged);
    _displayNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final sectionGap = space.xl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'AGENT READY · GENERATED SHOWCASE',
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(
                color: theme.colors.textInfo,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
        ),
        SizedBox(height: space.sm),
        Text(
          'Agent Ready app examples',
          style: theme
              .style(CharcoalTextRole.headingL)
              .copyWith(color: theme.colors.text),
        ),
        SizedBox(height: space.sm),
        Text(
          'Every interface on this page was composed through the Agent Ready catalog, public Charcoal APIs, and semantic design tokens.',
          style: theme
              .style(CharcoalTextRole.bodyLarge)
              .copyWith(color: theme.colors.textSecondary),
        ),
        SizedBox(height: sectionGap),
        const _AgentReadyProductionBanner(),
        SizedBox(height: space.xxl),
        SizedBox(key: _exampleBodyKey, height: theme.borders.hairline),
        _GalleryContextControls(
          inSimulation: _hasSelectedApp,
          onAllAppsPressed: _closeSelectedApp,
        ),
        SizedBox(height: space.xl),
        AnimatedSwitcher(
          duration: CharcoalTheme.of(context)
              .duration(context, CharcoalTheme.of(context).motion.standard),
          layoutBuilder: _singleLayerSwitcherLayout,
          switchInCurve: CharcoalTheme.of(context).motion.emphasizedCurve,
          switchOutCurve: CharcoalTheme.of(context).motion.curve,
          transitionBuilder: _routeTransition,
          child: _hasSelectedApp
              ? _buildSelectedApp(theme, sectionGap)
              : _buildAppCatalog(theme, sectionGap),
        ),
      ],
    );
  }

  bool get _hasSelectedApp => _asterSelected || _selectedMobileApp != null;

  Widget _buildAppCatalog(CharcoalTheme theme, double sectionGap) => Column(
    key: const ValueKey<String>('agent-app-catalog'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _SectionHeading(
        eyebrow: 'FIVE INDEPENDENT SIMULATIONS',
        title: 'Choose an Agent Ready app to open',
      ),
      SizedBox(height: theme.space.sm),
      Text(
        'Each tile opens its own live simulation. The previews are only entry points; state and interactions live inside each app.',
        style: theme
            .style(CharcoalTextRole.bodyLarge)
            .copyWith(color: theme.colors.textSecondary),
      ),
      SizedBox(height: sectionGap),
      AgentExampleTileGrid(
        children: <Widget>[
          for (final app in AgentMobileApp.values)
            AgentMobileAppTile(app: app, onPressed: () => _openMobileApp(app)),
          _AsterAppTile(onPressed: _openAster),
        ],
      ),
    ],
  );

  Widget _buildSelectedApp(CharcoalTheme theme, double sectionGap) {
    final mobileApp = _selectedMobileApp;
    return Column(
      key: ValueKey<String>(
        _asterSelected
            ? 'agent-app-detail-aster'
            : 'agent-app-detail-${mobileApp!.keyName}',
      ),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_asterSelected)
          _buildAsterSimulation(theme, sectionGap)
        else
          AgentMobileAppSimulator(app: mobileApp!),
      ],
    );
  }

  Widget _buildAsterSimulation(CharcoalTheme theme, double sectionGap) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 680;
              return CharcoalSegmentedControl<_ExampleDestination>(
                key: const ValueKey<String>('agent-example-selector'),
                fullWidth: compact,
                onChanged: _selectDestination,
                segments: const <CharcoalSegment<_ExampleDestination>>[
                  CharcoalSegment(
                    value: _ExampleDestination.studio,
                    child: Text('Studio'),
                  ),
                  CharcoalSegment(
                    value: _ExampleDestination.projects,
                    child: Text('Projects'),
                  ),
                  CharcoalSegment(
                    value: _ExampleDestination.settings,
                    child: Text('Settings'),
                  ),
                ],
                semanticLabel: 'Aster example page',
                value: _destination,
              );
            },
          ),
          SizedBox(height: sectionGap),
          _AppPreviewFrame(
            destination: _destination,
            mobileNavigationOpen: _mobileNavigationOpen,
            onDestinationChanged: _selectDestination,
            onMobileNavigationToggle: () =>
                setState(() => _mobileNavigationOpen = !_mobileNavigationOpen),
            onNotifications: () => showCharcoalToast(
              context: context,
              message: 'You are caught up on Aster notifications.',
            ),
            onSearch: () => _selectDestination(_ExampleDestination.projects),
            page: _buildDestination(),
          ),
          SizedBox(height: theme.space.lg),
          Wrap(
            spacing: theme.space.sm,
            runSpacing: theme.space.sm,
            children: const <Widget>[
              _CapabilityPill(label: 'Responsive layout'),
              _CapabilityPill(label: 'Keyboard + touch'),
              _CapabilityPill(label: 'Semantic tokens'),
              _CapabilityPill(label: 'Public APIs only'),
            ],
          ),
        ],
      );

  void _openMobileApp(AgentMobileApp app) {
    setState(() {
      _asterSelected = false;
      _selectedMobileApp = app;
    });
    _revealExampleBody();
  }

  void _openAster() {
    setState(() {
      _asterSelected = true;
      _selectedMobileApp = null;
    });
    _revealExampleBody();
  }

  void _closeSelectedApp() {
    setState(() {
      _asterSelected = false;
      _selectedMobileApp = null;
      _mobileNavigationOpen = false;
    });
    _revealExampleBody();
  }

  void _revealExampleBody() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bodyContext = _exampleBodyKey.currentContext;
      if (bodyContext == null) return;
      Scrollable.ensureVisible(
        bodyContext,
        alignment: 0.12,
        curve: CharcoalTheme.of(context).motion.emphasizedCurve,
        duration: CharcoalTheme.of(context)
            .duration(context, CharcoalTheme.of(context).motion.routeForward),
      );
    });
  }

  Widget _buildDestination() => switch (_destination) {
    _ExampleDestination.studio => _StudioPage(
      key: const ValueKey<String>('agent-example-studio'),
      onOpenProjects: _startCreating,
    ),
    _ExampleDestination.projects => _ProjectsPage(
      key: const ValueKey<String>('agent-example-projects'),
      filter: _projectFilter,
      newProjectName: _newProjectName,
      newProjectOpen: _newProjectOpen,
      onCreateProject: _createProject,
      onFilterChanged: (value) => setState(() {
        _projectFilter = value;
        _projectPage = 1;
      }),
      onNewProjectNameChanged: (value) =>
          setState(() => _newProjectName = value),
      onNewProjectToggle: () =>
          setState(() => _newProjectOpen = !_newProjectOpen),
      onPageChanged: (value) => setState(() => _projectPage = value),
      onProjectArchiveToggle: _toggleProjectArchive,
      onSearchChanged: (value) => setState(() {
        _projectSearch = value;
        _projectPage = 1;
      }),
      page: _projectPage,
      projectStatus: _projectStatus,
      projects: _projects,
      searchQuery: _projectSearch,
    ),
    _ExampleDestination.settings => _SettingsPage(
      key: const ValueKey<String>('agent-example-settings'),
      bioController: _bioController,
      displayNameController: _displayNameController,
      emailController: _emailController,
      onChangePhoto: () => showCharcoalToast(
        context: context,
        message: 'Profile photo picker opened for this simulation.',
      ),
      onProductUpdatesChanged: (value) => setState(() {
        _productUpdates = value;
        _settingsSaved = false;
      }),
      onSave: () => setState(() => _settingsSaved = true),
      onVisibilityChanged: (value) => setState(() {
        _visibility = value;
        _settingsSaved = false;
      }),
      onWeeklyDigestChanged: (value) => setState(() {
        _weeklyDigest = value;
        _settingsSaved = false;
      }),
      productUpdates: _productUpdates,
      saved: _settingsSaved,
      visibility: _visibility,
      weeklyDigest: _weeklyDigest,
    ),
  };

  void _selectDestination(_ExampleDestination value) {
    if (_destination == value && !_mobileNavigationOpen) return;
    setState(() {
      _destination = value;
      _mobileNavigationOpen = false;
    });
  }

  void _onProfileFieldChanged() {
    if (!mounted) return;
    setState(() => _settingsSaved = false);
  }

  void _startCreating() {
    setState(() {
      _destination = _ExampleDestination.projects;
      _mobileNavigationOpen = false;
      _newProjectOpen = true;
      _projectStatus = 'Name your new project to create a working draft.';
    });
  }

  void _createProject() {
    final name = _newProjectName.trim();
    if (name.isEmpty) return;
    setState(() {
      _projects.insert(
        0,
        _ProjectData(
          archived: false,
          details: 'Created just now · Empty canvas',
          shared: false,
          title: name,
          tone: _projects.length % 4,
        ),
      );
      _newProjectName = '';
      _newProjectOpen = false;
      _projectFilter = _ProjectFilter.all;
      _projectPage = 1;
      _projectSearch = '';
      _projectStatus = '“$name” is ready to edit.';
    });
  }

  void _toggleProjectArchive(_ProjectData project) {
    final index = _projects.indexOf(project);
    if (index < 0) return;
    final archived = !project.archived;
    setState(() {
      _projects[index] = project.copyWith(archived: archived);
      _projectStatus = archived
          ? '“${project.title}” moved to the archive.'
          : '“${project.title}” restored to current work.';
    });
  }
}

final class _GalleryContextControls extends StatelessWidget {
  const _GalleryContextControls({
    required this.inSimulation,
    required this.onAllAppsPressed,
  });

  final bool inSimulation;
  final VoidCallback onAllAppsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return SizedBox(
      key: const ValueKey<String>('agent-app-persistent-navigation'),
      width: double.infinity,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: space.sm,
        runSpacing: space.sm,
        children: <Widget>[
          CharcoalButton(
            key: const ValueKey<String>('agent-app-back'),
            leading: const CharcoalIcon(CharcoalIcons.chevronLeft),
            onPressed: inSimulation ? onAllAppsPressed : null,
            selected: !inSimulation,
            semanticLabel: inSimulation
                ? 'Return to all Agent Ready apps'
                : 'All Agent Ready apps',
            size: CharcoalButtonSize.small,
            child: const Text('All apps'),
          ),
          const _AgentReadyMiniBadge(),
        ],
      ),
    );
  }
}

final class _AsterAppTile extends StatelessWidget {
  const _AsterAppTile({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return CharcoalClickable(
      key: const ValueKey<String>('agent-app-tile-aster'),
      onPressed: onPressed,
      semanticLabel: 'Open Aster simulation',
      builder: (context, states) {
        final active =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed);
        return AnimatedContainer(
          duration: CharcoalTheme.of(context)
              .duration(context, CharcoalTheme.of(context).motion.fast),
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? theme.colors.border : theme.colors.borderSubtle,
            ),
            borderRadius: BorderRadius.circular(theme.radius.lg),
            color: states.contains(WidgetState.pressed)
                ? theme.colors.fillSecondary
                : theme.colors.background,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.radius.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 210, child: _AsterTileArtwork()),
                SizedBox(
                  height: theme.borders.hairline,
                  child: ColoredBox(color: theme.colors.borderSubtle),
                ),
                Padding(
                  padding: EdgeInsets.all(space.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _AgentReadyMiniBadge(),
                              ),
                            ),
                          ),
                          SizedBox(width: space.sm),
                          Text(
                            '05',
                            style: theme
                                .style(CharcoalTextRole.caption)
                                .copyWith(
                                  color: theme.colors.textTertiary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: space.sm),
                      Text(
                        'Aster · CREATIVE WORKSPACE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme
                            .style(CharcoalTextRole.captionMediumBold)
                            .copyWith(color: theme.colors.text),
                      ),
                      SizedBox(height: space.xs),
                      Text(
                        'Responsive studio, projects, and profile settings',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme
                            .style(CharcoalTextRole.caption)
                            .copyWith(color: theme.colors.textSecondary),
                      ),
                      SizedBox(height: space.md),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Open simulation',
                              style: theme
                                  .style(CharcoalTextRole.caption)
                                  .copyWith(
                                    color: theme.colors.textInfo,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          CharcoalIcon(
                            CharcoalIcons.chevronRight,
                            color: theme.colors.icon,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _AsterTileArtwork extends StatelessWidget {
  const _AsterTileArtwork();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final onColor = theme.colors.textOnPrimary;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[theme.colors.primary, theme.colors.negative],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.radius.md),
                    color: theme.colors.background.withValues(alpha: 0.2),
                  ),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Center(
                      child: Text(
                        'A',
                        style: theme
                            .style(CharcoalTextRole.bodyLargeBold)
                            .copyWith(color: onColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: theme.space.sm),
                Expanded(
                  child: Text(
                    'Aster creative cloud',
                    style: theme
                        .style(CharcoalTextRole.captionMediumBold)
                        .copyWith(color: onColor),
                  ),
                ),
                CharcoalIcon(
                  CharcoalIcons.layout,
                  color: theme.colors.iconOnPrimary,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: _AsterMiniPane(
                    icon: CharcoalIcons.image,
                    label: 'Studio',
                  ),
                ),
                SizedBox(width: theme.space.sm),
                const Expanded(
                  child: _AsterMiniPane(
                    icon: CharcoalIcons.folder,
                    label: 'Projects',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _AsterMiniPane extends StatelessWidget {
  const _AsterMiniPane({required this.icon, required this.label});

  final CharcoalIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: theme.colors.background.withValues(alpha: 0.18),
      ),
      child: SizedBox(
        height: 92,
        child: Padding(
          padding: EdgeInsets.all(theme.space.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CharcoalIcon(icon, color: theme.colors.iconOnPrimary),
              SizedBox(height: theme.space.sm),
              Text(
                label,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(
                      color: theme.colors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _AgentReadyMiniBadge extends StatelessWidget {
  const _AgentReadyMiniBadge();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: theme.colors.primary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.sm,
          vertical: theme.space.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.check,
              color: theme.colors.iconOnPrimary,
              size: 12,
            ),
            SizedBox(width: theme.space.xs),
            Text(
              'MADE WITH AGENT READY',
              style: theme
                  .style(CharcoalTextRole.caption)
                  .copyWith(
                    color: theme.colors.textOnPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AgentReadyProductionBanner extends StatelessWidget {
  const _AgentReadyProductionBanner();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      key: const ValueKey<String>('agent-ready-production-banner'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[theme.colors.primary, theme.colors.negative],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.space.xl),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 620;
            final mark = DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.radius.md),
                color: theme.colors.background.withValues(alpha: 0.18),
              ),
              child: SizedBox.square(
                dimension: 52,
                child: Center(
                  child: CharcoalIcon(
                    CharcoalIcons.checkCircle,
                    color: theme.colors.iconOnPrimary,
                  ),
                ),
              ),
            );
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'MADE WITH AGENT READY',
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(
                        color: theme.colors.textOnPrimary.withValues(
                          alpha: 0.76,
                        ),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                ),
                SizedBox(height: theme.space.sm),
                Text(
                  'Discovered, composed, and verified by an agent.',
                  style: theme
                      .style(CharcoalTextRole.headingXs)
                      .copyWith(color: theme.colors.textOnPrimary),
                ),
                SizedBox(height: theme.space.sm),
                Text(
                  'No private recipes or copied showcase internals: only indexed public components, semantic tokens, responsive rules, and device verification.',
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(
                        color: theme.colors.textOnPrimary.withValues(
                          alpha: 0.84,
                        ),
                      ),
                ),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  mark,
                  SizedBox(height: theme.space.lg),
                  copy,
                ],
              );
            }
            return Row(
              children: <Widget>[
                mark,
                SizedBox(width: theme.space.xl),
                Expanded(child: copy),
              ],
            );
          },
        ),
      ),
    );
  }
}

final class _AppPreviewFrame extends StatelessWidget {
  const _AppPreviewFrame({
    required this.destination,
    required this.mobileNavigationOpen,
    required this.onDestinationChanged,
    required this.onMobileNavigationToggle,
    required this.onNotifications,
    required this.onSearch,
    required this.page,
  });

  final _ExampleDestination destination;
  final bool mobileNavigationOpen;
  final ValueChanged<_ExampleDestination> onDestinationChanged;
  final VoidCallback onMobileNavigationToggle;
  final VoidCallback onNotifications;
  final VoidCallback onSearch;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      key: const ValueKey<String>('agent-app-preview'),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSubtle),
        borderRadius: BorderRadius.circular(theme.radius.lg),
        color: theme.colors.background,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radius.lg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _AppTopBar(
                    compact: true,
                    menuOpen: mobileNavigationOpen,
                    onMenuPressed: onMobileNavigationToggle,
                  ),
                  AnimatedSwitcher(
                    duration: CharcoalTheme.of(context).duration(
                      context,
                      CharcoalTheme.of(context).motion.standard,
                    ),
                    child: mobileNavigationOpen
                        ? _CompactAppNavigation(
                            key: const ValueKey<String>(
                              'agent-example-mobile-navigation',
                            ),
                            destination: destination,
                            onChanged: onDestinationChanged,
                          )
                        : const SizedBox.shrink(
                            key: ValueKey<String>(
                              'agent-example-mobile-navigation-closed',
                            ),
                          ),
                  ),
                  _AnimatedExamplePage(child: page),
                ],
              );
            }
            return Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  left: 0,
                  top: 0,
                  width: 208,
                  child: ColoredBox(color: theme.colors.background),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 208,
                      child: _AppSidebar(
                        destination: destination,
                        onChanged: onDestinationChanged,
                      ),
                    ),
                    SizedBox(
                      width: theme.borders.hairline,
                      child: const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _AppTopBar(
                            compact: false,
                            onNotifications: onNotifications,
                            onSearch: onSearch,
                          ),
                          _AnimatedExamplePage(child: page),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 208,
                  top: 0,
                  width: theme.borders.hairline,
                  child: ColoredBox(color: theme.colors.borderSubtle),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

final class _AnimatedExamplePage extends StatelessWidget {
  const _AnimatedExamplePage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ColoredBox(
      color: theme.colors.backgroundSecondary,
      child: AnimatedSwitcher(
        duration: CharcoalTheme.of(context)
            .duration(context, CharcoalTheme.of(context).motion.standard),
        layoutBuilder: _singleLayerSwitcherLayout,
        switchInCurve: CharcoalTheme.of(context).motion.emphasizedCurve,
        transitionBuilder: _routeTransition,
        child: child,
      ),
    );
  }
}

Widget _singleLayerSwitcherLayout(
  Widget? currentChild,
  List<Widget> previousChildren,
) => currentChild ?? const SizedBox.shrink();

Widget _routeTransition(Widget child, Animation<double> animation) =>
    FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.015),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );

final class _AppTopBar extends StatelessWidget {
  const _AppTopBar({
    required this.compact,
    this.menuOpen = false,
    this.onMenuPressed,
    this.onNotifications,
    this.onSearch,
  });

  final bool compact;
  final bool menuOpen;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotifications;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSubtle)),
        color: theme.colors.background,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.lg,
          vertical: theme.space.sm,
        ),
        child: Row(
          children: <Widget>[
            if (compact) ...<Widget>[
              const _BrandMark(size: 34),
              SizedBox(width: theme.space.sm),
              Expanded(
                child: Text(
                  'Aster',
                  style: theme
                      .style(CharcoalTextRole.bodyLargeBold)
                      .copyWith(color: theme.colors.text),
                ),
              ),
              CharcoalIconButton(
                key: const ValueKey<String>('agent-example-menu-button'),
                icon: CharcoalIcon(
                  menuOpen ? CharcoalIcons.x : CharcoalIcons.list,
                ),
                onPressed: onMenuPressed,
                selected: menuOpen,
                semanticLabel: menuOpen
                    ? 'Close example navigation'
                    : 'Open example navigation',
                size: CharcoalIconButtonSize.small,
              ),
            ] else ...<Widget>[
              Expanded(
                child: Text(
                  'Creator workspace',
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(color: theme.colors.textSecondary),
                ),
              ),
              CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.search),
                onPressed: onSearch,
                semanticLabel: 'Search workspace',
                size: CharcoalIconButtonSize.small,
              ),
              SizedBox(width: theme.space.sm),
              CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.bell),
                onPressed: onNotifications,
                semanticLabel: 'Notifications',
                size: CharcoalIconButtonSize.small,
              ),
              SizedBox(width: theme.space.sm),
              const _Avatar(initials: 'MA', size: 36),
            ],
          ],
        ),
      ),
    );
  }
}

final class _AppSidebar extends StatelessWidget {
  const _AppSidebar({required this.destination, required this.onChanged});

  final _ExampleDestination destination;
  final ValueChanged<_ExampleDestination> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: Padding(
        padding: EdgeInsets.all(theme.space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.space.sm),
              child: Row(
                children: <Widget>[
                  const _BrandMark(size: 38),
                  SizedBox(width: theme.space.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Aster',
                          style: theme
                              .style(CharcoalTextRole.bodyLargeBold)
                              .copyWith(color: theme.colors.text),
                        ),
                        Text(
                          'CREATIVE CLOUD',
                          style: theme
                              .style(CharcoalTextRole.caption)
                              .copyWith(
                                color: theme.colors.textTertiary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: theme.space.xl),
            ..._navigationItems(destination: destination, onChanged: onChanged),
            SizedBox(height: theme.space.xxl),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.radius.md),
                color: theme.colors.negative,
              ),
              child: Padding(
                padding: EdgeInsets.all(theme.space.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CharcoalIcon(
                      CharcoalIcons.bulbShine,
                      color: theme.colors.iconOnPrimary,
                    ),
                    SizedBox(height: theme.space.md),
                    Text(
                      'Make room for more ideas',
                      style: theme
                          .style(CharcoalTextRole.captionMediumBold)
                          .copyWith(color: theme.colors.textOnNegative),
                    ),
                    SizedBox(height: theme.space.xs),
                    Text(
                      '12 GB of 20 GB used',
                      style: theme
                          .style(CharcoalTextRole.caption)
                          .copyWith(
                            color: theme.colors.textOnNegative.withValues(
                              alpha: 0.76,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: theme.space.xl),
            Row(
              children: <Widget>[
                const _Avatar(initials: 'MA', size: 34),
                SizedBox(width: theme.space.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Mina Aoki',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme
                            .style(CharcoalTextRole.captionMediumBold)
                            .copyWith(color: theme.colors.text),
                      ),
                      Text(
                        'Pro plan',
                        style: theme
                            .style(CharcoalTextRole.caption)
                            .copyWith(color: theme.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _CompactAppNavigation extends StatelessWidget {
  const _CompactAppNavigation({
    required this.destination,
    required this.onChanged,
    super.key,
  });

  final _ExampleDestination destination;
  final ValueChanged<_ExampleDestination> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSubtle)),
        color: theme.colors.background,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          theme.space.lg,
          theme.space.sm,
          theme.space.lg,
          theme.space.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _navigationItems(
            destination: destination,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

List<Widget> _navigationItems({
  required _ExampleDestination destination,
  required ValueChanged<_ExampleDestination> onChanged,
}) {
  const items = <(_ExampleDestination, String, CharcoalIconData)>[
    (_ExampleDestination.studio, 'Studio', CharcoalIcons.home),
    (_ExampleDestination.projects, 'Projects', CharcoalIcons.projects),
    (_ExampleDestination.settings, 'Settings', CharcoalIcons.setting),
  ];
  return <Widget>[
    for (final item in items) ...<Widget>[
      CharcoalNavigationItem(
        key: ValueKey<String>('agent-example-nav-${item.$1.name}'),
        leading: CharcoalIcon(item.$3),
        onPressed: () => onChanged(item.$1),
        selected: destination == item.$1,
        trailing: destination == item.$1
            ? const CharcoalIcon(CharcoalIcons.chevronRight)
            : null,
        child: Text(item.$2),
      ),
      const SizedBox(height: 4),
    ],
  ];
}

final class _StudioPage extends StatelessWidget {
  const _StudioPage({required this.onOpenProjects, super.key});

  final VoidCallback onOpenProjects;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return _ExamplePagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'MONDAY, AUGUST 17',
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(
                          color: theme.colors.textOnPrimary.withValues(
                            alpha: 0.72,
                          ),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                  ),
                  SizedBox(height: space.md),
                  Text(
                    'Make something only you could imagine.',
                    style:
                        (compact
                                ? theme.style(CharcoalTextRole.headingM)
                                : theme.style(CharcoalTextRole.headingL))
                            .copyWith(color: theme.colors.textOnPrimary),
                  ),
                  SizedBox(height: space.sm),
                  Text(
                    'Your canvas is ready, and yesterday’s ideas are right where you left them.',
                    style: theme
                        .style(CharcoalTextRole.captionMedium)
                        .copyWith(
                          color: theme.colors.textOnPrimary.withValues(
                            alpha: 0.82,
                          ),
                        ),
                  ),
                  SizedBox(height: space.xl),
                  CharcoalButton(
                    fullWidth: compact,
                    leading: const CharcoalIcon(CharcoalIcons.penAdd),
                    onPressed: onOpenProjects,
                    variant: CharcoalButtonVariant.overlay,
                    child: const Text('Start creating'),
                  ),
                ],
              );
              final art = _HeroArtwork(compact: compact);
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.radius.lg),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      theme.colors.primary,
                      theme.colors.negative,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(compact ? space.lg : space.xl),
                  child: compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            copy,
                            SizedBox(height: theme.space.xl),
                            art,
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(flex: 5, child: copy),
                            SizedBox(width: space.xl),
                            Expanded(flex: 4, child: art),
                          ],
                        ),
                ),
              );
            },
          ),
          SizedBox(height: space.xl),
          const _SectionHeading(
            eyebrow: 'AT A GLANCE',
            title: 'Your creative rhythm',
          ),
          SizedBox(height: space.lg),
          const _MetricGrid(),
          SizedBox(height: space.xl),
          _SectionHeading(
            action: CharcoalLinkButton(
              onPressed: onOpenProjects,
              child: const Text('View all'),
            ),
            eyebrow: 'RECENT WORK',
            title: 'Pick up where you left off',
          ),
          SizedBox(height: space.lg),
          const _ProjectGrid(projects: _recentProjects),
        ],
      ),
    );
  }
}

final class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Semantics(
      image: true,
      label: 'Abstract landscape artwork preview',
      child: ExcludeSemantics(
        child: SizedBox(
          height: compact ? 180 : 236,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.md),
              color: theme.colors.background.withValues(alpha: 0.16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(theme.radius.md),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -28,
                    top: -34,
                    child: _ArtCircle(
                      color: theme.colors.notice,
                      size: compact ? 122 : 154,
                    ),
                  ),
                  Positioned(
                    right: -20,
                    top: 28,
                    child: Transform.rotate(
                      angle: 0.35,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(theme.radius.lg),
                          color: theme.colors.positive,
                        ),
                        child: SizedBox(
                          height: compact ? 108 : 142,
                          width: compact ? 108 : 142,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -68,
                    left: 28,
                    right: 28,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: theme.colors.background.withValues(alpha: 0.86),
                      ),
                      child: SizedBox(height: compact ? 126 : 166),
                    ),
                  ),
                  Positioned(
                    bottom: theme.space.lg,
                    left: theme.space.lg,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: theme.colors.fillOnImage,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.space.md,
                          vertical: theme.space.sm,
                        ),
                        child: Text(
                          'DAYBREAK · 04',
                          style: theme
                              .style(CharcoalTextRole.caption)
                              .copyWith(
                                color: theme.colors.textOnImage,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _ArtCircle extends StatelessWidget {
  const _ArtCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: color,
    ),
    child: SizedBox.square(dimension: size),
  );
}

final class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final gap = theme.space.lg;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620
            ? 3
            : constraints.maxWidth >= 380
            ? 2
            : 1;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            SizedBox(
              width: width,
              child: const _MetricCard(
                icon: CharcoalIcons.penDraw,
                label: 'Active drafts',
                value: '12',
              ),
            ),
            SizedBox(
              width: width,
              child: const _MetricCard(
                icon: CharcoalIcons.heart,
                label: 'New appreciations',
                value: '248',
              ),
            ),
            SizedBox(
              width: width,
              child: const _MetricCard(
                icon: CharcoalIcons.persons,
                label: 'Studio visitors',
                value: '2.4k',
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final CharcoalIconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _Surface(
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.md),
              color: theme.colors.surfaceSecondary,
            ),
            child: SizedBox.square(
              dimension: theme.sizes.controlLg,
              child: Center(
                child: CharcoalIcon(icon, color: theme.colors.icon),
              ),
            ),
          ),
          SizedBox(width: theme.space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: theme
                      .style(CharcoalTextRole.headingXs)
                      .copyWith(color: theme.colors.text),
                ),
                Text(
                  label,
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(color: theme.colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProjectsPage extends StatelessWidget {
  const _ProjectsPage({
    required this.filter,
    required this.newProjectName,
    required this.newProjectOpen,
    required this.onCreateProject,
    required this.onFilterChanged,
    required this.onNewProjectNameChanged,
    required this.onNewProjectToggle,
    required this.onPageChanged,
    required this.onProjectArchiveToggle,
    required this.onSearchChanged,
    required this.page,
    required this.projectStatus,
    required this.projects,
    required this.searchQuery,
    super.key,
  });

  final _ProjectFilter filter;
  final String newProjectName;
  final bool newProjectOpen;
  final VoidCallback onCreateProject;
  final ValueChanged<_ProjectFilter> onFilterChanged;
  final ValueChanged<String> onNewProjectNameChanged;
  final VoidCallback onNewProjectToggle;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<_ProjectData> onProjectArchiveToggle;
  final ValueChanged<String> onSearchChanged;
  final int page;
  final String? projectStatus;
  final List<_ProjectData> projects;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final visibleProjects = projects
        .where((project) {
          final matchesQuery = project.title.toLowerCase().contains(
            searchQuery.trim().toLowerCase(),
          );
          final matchesFilter = switch (filter) {
            _ProjectFilter.all => !project.archived,
            _ProjectFilter.shared => project.shared && !project.archived,
            _ProjectFilter.archived => project.archived,
          };
          return matchesQuery && matchesFilter;
        })
        .toList(growable: false);
    const pageSize = 4;
    final pageCount = ((visibleProjects.length + pageSize - 1) ~/ pageSize)
        .clamp(1, 999);
    final safePage = page.clamp(1, pageCount);
    final pageProjects = visibleProjects
        .skip((safePage - 1) * pageSize)
        .take(pageSize)
        .toList(growable: false);
    return Padding(
      padding: EdgeInsets.all(space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _AdaptivePageHeading(
            action: CharcoalButton(
              key: const ValueKey<String>('agent-project-new'),
              leading: CharcoalIcon(
                newProjectOpen ? CharcoalIcons.x : CharcoalIcons.add,
              ),
              onPressed: onNewProjectToggle,
              selected: newProjectOpen,
              variant: CharcoalButtonVariant.primary,
              child: Text(newProjectOpen ? 'Cancel' : 'New project'),
            ),
            description:
                'Everything you are making, from first sketch to final export.',
            eyebrow: 'LIBRARY',
            title: 'Projects',
          ),
          if (newProjectOpen) ...<Widget>[
            SizedBox(height: space.lg),
            _Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _SectionHeading(
                    eyebrow: 'NEW DRAFT',
                    title: 'Name your next idea',
                  ),
                  SizedBox(height: space.lg),
                  CharcoalTextField(
                    key: const ValueKey<String>('agent-project-new-name'),
                    autofocus: true,
                    label: 'Project name',
                    onChanged: onNewProjectNameChanged,
                    onSubmitted: (_) => newProjectName.trim().isEmpty
                        ? null
                        : onCreateProject(),
                    placeholder: 'e.g. August light studies',
                    showLabel: true,
                  ),
                  SizedBox(height: space.sm),
                  CharcoalButton(
                    key: const ValueKey<String>('agent-project-create'),
                    fullWidth: true,
                    onPressed: newProjectName.trim().isEmpty
                        ? null
                        : onCreateProject,
                    variant: CharcoalButtonVariant.primary,
                    child: const Text('Create project'),
                  ),
                ],
              ),
            ),
          ],
          if (projectStatus != null) ...<Widget>[
            SizedBox(height: space.lg),
            CharcoalHintText(
              alignment: Alignment.centerLeft,
              icon: const CharcoalIcon(CharcoalIcons.checkCircle),
              child: Text(projectStatus!),
            ),
          ],
          SizedBox(height: space.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              final search = CharcoalTextField(
                key: const ValueKey<String>('agent-project-search'),
                onChanged: onSearchChanged,
                placeholder: 'Search projects',
                prefix: const CharcoalIcon(CharcoalIcons.search),
              );
              final filters = CharcoalSegmentedControl<_ProjectFilter>(
                key: const ValueKey<String>('agent-project-filter'),
                fullWidth: compact,
                onChanged: onFilterChanged,
                segments: const <CharcoalSegment<_ProjectFilter>>[
                  CharcoalSegment(
                    value: _ProjectFilter.all,
                    child: Text('All'),
                  ),
                  CharcoalSegment(
                    value: _ProjectFilter.shared,
                    child: Text('Shared'),
                  ),
                  CharcoalSegment(
                    value: _ProjectFilter.archived,
                    child: Text('Archived'),
                  ),
                ],
                semanticLabel: 'Project filter',
                value: filter,
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    search,
                    SizedBox(height: space.lg),
                    filters,
                  ],
                );
              }
              return Row(
                children: <Widget>[
                  Expanded(child: search),
                  SizedBox(width: space.lg),
                  filters,
                ],
              );
            },
          ),
          SizedBox(height: space.xl),
          _SectionHeading(
            eyebrow: '${visibleProjects.length} ITEMS',
            title: switch (filter) {
              _ProjectFilter.all => 'Current work',
              _ProjectFilter.shared => 'Shared with others',
              _ProjectFilter.archived => 'Archive',
            },
          ),
          SizedBox(height: space.lg),
          if (visibleProjects.isEmpty)
            _EmptyProjects(query: searchQuery)
          else
            _ProjectGrid(
              onArchiveToggle: onProjectArchiveToggle,
              projects: pageProjects,
            ),
          if (pageCount > 1) ...<Widget>[
            SizedBox(height: space.xl),
            LayoutBuilder(
              builder: (context, constraints) => constraints.maxWidth < 520
                  ? CharcoalButton(
                      fullWidth: true,
                      onPressed: safePage < pageCount
                          ? () => onPageChanged(safePage + 1)
                          : null,
                      child: Text(
                        safePage < pageCount ? 'Next page' : 'All loaded',
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: CharcoalPagination(
                        currentPage: safePage,
                        onPageChanged: onPageChanged,
                        pageCount: pageCount,
                        semanticLabel: 'Project pages',
                        size: CharcoalPaginationSize.small,
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _SettingsPage extends StatelessWidget {
  const _SettingsPage({
    required this.bioController,
    required this.displayNameController,
    required this.emailController,
    required this.onChangePhoto,
    required this.onProductUpdatesChanged,
    required this.onSave,
    required this.onVisibilityChanged,
    required this.onWeeklyDigestChanged,
    required this.productUpdates,
    required this.saved,
    required this.visibility,
    required this.weeklyDigest,
    super.key,
  });

  final TextEditingController bioController;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final VoidCallback onChangePhoto;
  final ValueChanged<bool> onProductUpdatesChanged;
  final VoidCallback onSave;
  final ValueChanged<_WorkspaceVisibility?> onVisibilityChanged;
  final ValueChanged<bool> onWeeklyDigestChanged;
  final bool productUpdates;
  final bool saved;
  final _WorkspaceVisibility? visibility;
  final bool weeklyDigest;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return _ExamplePagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _AdaptivePageHeading(
            action: CharcoalButton(
              key: const ValueKey<String>('agent-settings-save'),
              leading: CharcoalIcon(
                saved ? CharcoalIcons.check : CharcoalIcons.save,
              ),
              onPressed: onSave,
              variant: CharcoalButtonVariant.primary,
              child: Text(saved ? 'Saved' : 'Save changes'),
            ),
            description:
                'Shape how your profile appears and how Aster keeps in touch.',
            eyebrow: 'ACCOUNT',
            title: 'Profile settings',
          ),
          SizedBox(height: space.xl),
          _Surface(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(theme.space.xl),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 520;
                      final identity = Column(
                        crossAxisAlignment: compact
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            displayNameController.text.trim().isEmpty
                                ? 'Unnamed creator'
                                : displayNameController.text.trim(),
                            textAlign: compact ? TextAlign.center : null,
                            style: theme
                                .style(CharcoalTextRole.headingXs)
                                .copyWith(color: theme.colors.text),
                          ),
                          SizedBox(height: theme.space.xs),
                          Text(
                            emailController.text.trim().isEmpty
                                ? 'Add an email address'
                                : emailController.text.trim(),
                            textAlign: compact ? TextAlign.center : null,
                            style: theme
                                .style(CharcoalTextRole.captionMedium)
                                .copyWith(color: theme.colors.textSecondary),
                          ),
                        ],
                      );
                      final avatar = DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: theme.colors.negative,
                        ),
                        child: SizedBox.square(
                          dimension: compact ? 72 : 80,
                          child: Center(
                            child: Text(
                              'MA',
                              style: theme
                                  .style(CharcoalTextRole.headingS)
                                  .copyWith(color: theme.colors.textOnNegative),
                            ),
                          ),
                        ),
                      );
                      final changePhoto = CharcoalButton(
                        onPressed: onChangePhoto,
                        size: CharcoalButtonSize.small,
                        child: const Text('Change photo'),
                      );
                      if (compact) {
                        return Column(
                          children: <Widget>[
                            avatar,
                            SizedBox(height: theme.space.lg),
                            identity,
                            SizedBox(height: theme.space.lg),
                            changePhoto,
                          ],
                        );
                      }
                      return Row(
                        children: <Widget>[
                          avatar,
                          SizedBox(width: theme.space.lg),
                          Expanded(child: identity),
                          SizedBox(width: theme.space.lg),
                          changePhoto,
                        ],
                      );
                    },
                  ),
                ),
                _SurfaceDivider(color: theme.colors.borderSubtle),
                Padding(
                  padding: EdgeInsets.all(theme.space.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _SectionHeading(
                        eyebrow: 'PUBLIC PROFILE',
                        title: 'About you',
                      ),
                      SizedBox(height: space.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 560;
                          final name = CharcoalTextField(
                            controller: displayNameController,
                            label: 'Display name',
                            required: true,
                            showLabel: true,
                            textInputAction: TextInputAction.next,
                          );
                          final email = CharcoalTextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email address',
                            required: true,
                            showLabel: true,
                            textInputAction: TextInputAction.next,
                          );
                          if (compact) {
                            return Column(
                              children: <Widget>[
                                name,
                                SizedBox(height: space.lg),
                                email,
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(child: name),
                              SizedBox(width: space.lg),
                              Expanded(child: email),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: space.lg),
                      CharcoalTextArea(
                        controller: bioController,
                        label: 'Bio',
                        maxLength: 120,
                        rows: 3,
                        showCount: true,
                        showLabel: true,
                      ),
                      SizedBox(height: space.lg),
                      CharcoalDropdown<_WorkspaceVisibility>(
                        label: 'Default project visibility',
                        onChanged: onVisibilityChanged,
                        options:
                            const <
                              CharcoalDropdownOption<_WorkspaceVisibility>
                            >[
                              CharcoalDropdownOption(
                                value: _WorkspaceVisibility.private,
                                label: 'Only me',
                                secondary: 'Private until you publish',
                              ),
                              CharcoalDropdownOption(
                                value: _WorkspaceVisibility.team,
                                label: 'Studio members',
                                secondary: 'Visible to your workspace',
                              ),
                              CharcoalDropdownOption(
                                value: _WorkspaceVisibility.public,
                                label: 'Everyone',
                                secondary: 'Visible on your public profile',
                              ),
                            ],
                        showLabel: true,
                        value: visibility,
                      ),
                    ],
                  ),
                ),
                _SurfaceDivider(color: theme.colors.borderSubtle),
                Padding(
                  padding: EdgeInsets.all(theme.space.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _SectionHeading(
                        eyebrow: 'NOTIFICATIONS',
                        title: 'Stay in the loop',
                      ),
                      SizedBox(height: space.lg),
                      _PreferenceRow(
                        description:
                            'A calm summary of views, saves, and comments.',
                        onChanged: onWeeklyDigestChanged,
                        title: 'Weekly studio digest',
                        value: weeklyDigest,
                      ),
                      SizedBox(height: space.lg),
                      _PreferenceRow(
                        description:
                            'Occasional release notes and feature previews.',
                        onChanged: onProductUpdatesChanged,
                        title: 'Product updates',
                        value: productUpdates,
                      ),
                    ],
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

final class _AdaptivePageHeading extends StatelessWidget {
  const _AdaptivePageHeading({
    required this.action,
    required this.description,
    required this.eyebrow,
    required this.title,
  });

  final Widget action;
  final String description;
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow,
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(
                color: theme.colors.textInfo,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
        ),
        SizedBox(height: space.sm),
        Text(
          title,
          style: theme
              .style(CharcoalTextRole.headingM)
              .copyWith(color: theme.colors.text),
        ),
        SizedBox(height: space.sm),
        Text(
          description,
          style: theme
              .style(CharcoalTextRole.captionMedium)
              .copyWith(color: theme.colors.textSecondary),
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              copy,
              SizedBox(height: space.lg),
              action,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(child: copy),
            SizedBox(width: space.xl),
            action,
          ],
        );
      },
    );
  }
}

final class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    this.action,
  });

  final Widget? action;
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eyebrow,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(
                      color: theme.colors.textTertiary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                    ),
              ),
              SizedBox(height: space.xs),
              Text(
                title,
                style: theme
                    .style(CharcoalTextRole.headingXxs)
                    .copyWith(color: theme.colors.text),
              ),
            ],
          ),
        ),
        if (action != null) ...<Widget>[SizedBox(width: space.sm), action!],
      ],
    );
  }
}

final class _ExamplePagePadding extends StatelessWidget {
  const _ExamplePagePadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).space;
    return Padding(padding: EdgeInsets.all(space.xl), child: child);
  }
}

final class _Surface extends StatelessWidget {
  const _Surface({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSubtle),
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: theme.colors.background,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.space.lg),
        child: child,
      ),
    );
  }
}

final class _SurfaceDivider extends StatelessWidget {
  const _SurfaceDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: CharcoalTheme.of(context).borders.hairline,
    child: ColoredBox(color: color),
  );
}

final class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.description,
    required this.onChanged,
    required this.title,
    required this.value,
  });

  final String description;
  final ValueChanged<bool> onChanged;
  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme
                    .style(CharcoalTextRole.captionMediumBold)
                    .copyWith(color: theme.colors.text),
              ),
              SizedBox(height: space.xs),
              Text(
                description,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(color: theme.colors.textSecondary),
              ),
            ],
          ),
        ),
        SizedBox(width: space.sm),
        CharcoalSwitch(
          onChanged: onChanged,
          semanticLabel: title,
          value: value,
        ),
      ],
    );
  }
}

final class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({required this.projects, this.onArchiveToggle});

  final ValueChanged<_ProjectData>? onArchiveToggle;
  final List<_ProjectData> projects;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final gap = theme.space.lg;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760
            ? 3
            : constraints.maxWidth >= 480
            ? 2
            : 1;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final project in projects)
              SizedBox(
                width: width,
                child: _ProjectCard(
                  onArchiveToggle: onArchiveToggle == null
                      ? null
                      : () => onArchiveToggle!(project),
                  project: project,
                ),
              ),
          ],
        );
      },
    );
  }
}

final class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.onArchiveToggle, required this.project});

  final VoidCallback? onArchiveToggle;
  final _ProjectData project;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return _Surface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _ProjectArtwork(tone: project.tone),
          Padding(
            padding: EdgeInsets.all(space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme
                            .style(CharcoalTextRole.captionMediumBold)
                            .copyWith(color: theme.colors.text),
                      ),
                    ),
                    if (onArchiveToggle != null)
                      CharcoalIconButton(
                        icon: const CharcoalIcon(CharcoalIcons.archive),
                        onPressed: onArchiveToggle,
                        selected: project.archived,
                        semanticLabel: project.archived
                            ? 'Restore ${project.title}'
                            : 'Archive ${project.title}',
                        size: CharcoalIconButtonSize.extraSmall,
                      ),
                  ],
                ),
                SizedBox(height: space.xs),
                Text(
                  project.details,
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(color: theme.colors.textSecondary),
                ),
                SizedBox(height: space.md),
                _StatusPill(
                  label: project.archived
                      ? 'Archived'
                      : project.shared
                      ? 'Shared'
                      : 'Private',
                  positive: project.shared && !project.archived,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProjectArtwork extends StatelessWidget {
  const _ProjectArtwork({required this.tone});

  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final palette = switch (tone % 4) {
      0 => (theme.colors.primary, theme.colors.notice, theme.colors.negative),
      1 => (
        theme.colors.negative,
        theme.colors.positive,
        theme.colors.background,
      ),
      2 => (theme.colors.notice, theme.colors.primary, theme.colors.negative),
      _ => (theme.colors.positive, theme.colors.negative, theme.colors.neutral),
    };
    return Semantics(
      image: true,
      label: 'Project artwork thumbnail',
      child: ExcludeSemantics(
        child: SizedBox(
          height: 148,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(theme.radius.md),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[palette.$1, palette.$2],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -24,
                    bottom: -42,
                    child: _ArtCircle(color: palette.$3, size: 132),
                  ),
                  Positioned(
                    right: 20,
                    top: 22,
                    child: Transform.rotate(
                      angle: -0.32,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(theme.radius.md),
                          color: palette.$3.withValues(alpha: 0.78),
                        ),
                        child: const SizedBox.square(dimension: 72),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.positive});

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: positive
            ? theme.colors.positive.withValues(alpha: 0.18)
            : theme.colors.surfaceSecondary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.sm,
          vertical: theme.space.xs,
        ),
        child: Text(
          label,
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(
                color: positive
                    ? theme.colors.textPositive
                    : theme.colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

final class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _Surface(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: theme.space.xl),
        child: Column(
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.search,
              color: theme.colors.iconSecondary,
            ),
            SizedBox(height: theme.space.sm),
            Text(
              query.trim().isEmpty
                  ? 'No projects in this view'
                  : 'No results for “${query.trim()}”',
              textAlign: TextAlign.center,
              style: theme
                  .style(CharcoalTextRole.captionMediumBold)
                  .copyWith(color: theme.colors.text),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CapabilityPill extends StatelessWidget {
  const _CapabilityPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSubtle),
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: theme.colors.background,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.md,
          vertical: theme.space.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.checkCircle,
              color: theme.colors.iconPositive,
              size: 16,
            ),
            SizedBox(width: theme.space.sm),
            Text(
              label,
              style: theme
                  .style(CharcoalTextRole.caption)
                  .copyWith(
                    color: theme.colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: theme.colors.primary,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            'A',
            style: theme
                .style(CharcoalTextRole.captionMediumBold)
                .copyWith(color: theme.colors.textOnPrimary),
          ),
        ),
      ),
    );
  }
}

final class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.pill),
        color: theme.colors.notice,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            initials,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(
                  color: theme.colors.text,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

final class _ProjectData {
  const _ProjectData({
    required this.archived,
    required this.details,
    required this.shared,
    required this.title,
    required this.tone,
  });

  final bool archived;
  final String details;
  final bool shared;
  final String title;
  final int tone;

  _ProjectData copyWith({bool? archived}) => _ProjectData(
    archived: archived ?? this.archived,
    details: details,
    shared: shared,
    title: title,
    tone: tone,
  );
}

const _recentProjects = <_ProjectData>[
  _ProjectData(
    archived: false,
    details: 'Edited 18 minutes ago · 24 layers',
    shared: true,
    title: 'Quiet morning',
    tone: 0,
  ),
  _ProjectData(
    archived: false,
    details: 'Edited yesterday · 16 layers',
    shared: false,
    title: 'Garden studies',
    tone: 1,
  ),
];

const _allProjects = <_ProjectData>[
  ..._recentProjects,
  _ProjectData(
    archived: false,
    details: 'Edited 3 days ago · 31 layers',
    shared: true,
    title: 'City after rain',
    tone: 2,
  ),
  _ProjectData(
    archived: false,
    details: 'Edited last week · 8 layers',
    shared: false,
    title: 'Soft creatures',
    tone: 3,
  ),
  _ProjectData(
    archived: true,
    details: 'Archived July 28 · 12 layers',
    shared: false,
    title: 'Summer postcards',
    tone: 0,
  ),
  _ProjectData(
    archived: true,
    details: 'Archived June 12 · 19 layers',
    shared: true,
    title: 'Night garden',
    tone: 1,
  ),
];
