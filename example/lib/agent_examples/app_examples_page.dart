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

  _ExampleDestination _destination = _ExampleDestination.studio;
  _ProjectFilter _projectFilter = _ProjectFilter.all;
  _WorkspaceVisibility? _visibility = _WorkspaceVisibility.team;
  final GlobalKey _exampleBodyKey = GlobalKey();
  AgentMobileApp? _selectedMobileApp;
  bool _asterSelected = false;
  bool _mobileNavigationOpen = false;
  bool _productUpdates = true;
  bool _settingsSaved = false;
  bool _weeklyDigest = true;
  String _projectSearch = '';

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final sectionGap = theme.dimensions.space.layout40;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'AGENT READY · GENERATED SHOWCASE',
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textInfoDefault,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component20),
        Text(
          'Agent Ready app examples',
          style: theme.textStyles.headingL.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component20),
        Text(
          'Every interface on this page was composed through the Agent Ready catalog, public Charcoal APIs, and semantic design tokens.',
          style: theme.textStyles.body.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
        ),
        SizedBox(height: sectionGap),
        const _AgentReadyProductionBanner(),
        SizedBox(height: theme.dimensions.space.layout50),
        SizedBox(key: _exampleBodyKey, height: theme.dimensions.borderWidth.m),
        AnimatedSwitcher(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.standard,
          ),
          switchInCurve: CharcoalMotion.emphasizedCurve,
          switchOutCurve: CharcoalMotion.standardCurve,
          child: _hasSelectedApp
              ? _buildSelectedApp(theme, sectionGap)
              : _buildAppCatalog(theme, sectionGap),
        ),
      ],
    );
  }

  bool get _hasSelectedApp => _asterSelected || _selectedMobileApp != null;

  Widget _buildAppCatalog(CharcoalThemeData theme, double sectionGap) => Column(
    key: const ValueKey<String>('agent-app-catalog'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _SectionHeading(
        eyebrow: 'FIVE INDEPENDENT SIMULATIONS',
        title: 'Choose an Agent Ready app to open',
      ),
      SizedBox(height: theme.dimensions.space.component20),
      Text(
        'Each tile opens its own live simulation. The previews are only entry points; state and interactions live inside each app.',
        style: theme.textStyles.body.copyWith(
          color: theme.colors.textSecondaryDefault,
        ),
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

  Widget _buildSelectedApp(CharcoalThemeData theme, double sectionGap) {
    final mobileApp = _selectedMobileApp;
    final title = _asterSelected ? 'Aster' : mobileApp!.title;
    final type = _asterSelected ? 'CREATIVE WORKSPACE' : mobileApp!.type;
    final description = _asterSelected
        ? 'A responsive creative workspace with studio, project, and account flows.'
        : mobileApp!.description;
    final interactionSummary = _asterSelected
        ? 'Navigate pages, search projects, edit profile fields, and save settings.'
        : mobileApp!.interactionSummary;
    return Column(
      key: ValueKey<String>(
        _asterSelected
            ? 'agent-app-detail-aster'
            : 'agent-app-detail-${mobileApp!.keyName}',
      ),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _SimulationHeader(
          description: description,
          interactionSummary: interactionSummary,
          onBack: _closeSelectedApp,
          title: title,
          type: type,
        ),
        SizedBox(height: sectionGap),
        if (_asterSelected)
          _buildAsterSimulation(theme, sectionGap)
        else
          AgentMobileAppSimulator(app: mobileApp!),
      ],
    );
  }

  Widget _buildAsterSimulation(CharcoalThemeData theme, double sectionGap) =>
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
            page: _buildDestination(),
          ),
          SizedBox(height: theme.dimensions.space.component30),
          Wrap(
            spacing: theme.dimensions.space.component20,
            runSpacing: theme.dimensions.space.component20,
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
        curve: CharcoalMotion.emphasizedCurve,
        duration: CharcoalMotion.resolveDuration(
          context,
          CharcoalMotion.routeForward,
        ),
      );
    });
  }

  Widget _buildDestination() => switch (_destination) {
    _ExampleDestination.studio => _StudioPage(
      key: const ValueKey<String>('agent-example-studio'),
      onOpenProjects: () => _selectDestination(_ExampleDestination.projects),
    ),
    _ExampleDestination.projects => _ProjectsPage(
      key: const ValueKey<String>('agent-example-projects'),
      filter: _projectFilter,
      onFilterChanged: (value) => setState(() => _projectFilter = value),
      onSearchChanged: (value) => setState(() => _projectSearch = value),
      searchQuery: _projectSearch,
    ),
    _ExampleDestination.settings => _SettingsPage(
      key: const ValueKey<String>('agent-example-settings'),
      bioController: _bioController,
      displayNameController: _displayNameController,
      emailController: _emailController,
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
}

final class _SimulationHeader extends StatelessWidget {
  const _SimulationHeader({
    required this.description,
    required this.interactionSummary,
    required this.onBack,
    required this.title,
    required this.type,
  });

  final String description;
  final String interactionSummary;
  final VoidCallback onBack;
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: theme.dimensions.space.component20,
          runSpacing: theme.dimensions.space.component20,
          children: <Widget>[
            CharcoalButton(
              key: const ValueKey<String>('agent-app-back'),
              leading: const CharcoalIcon(CharcoalIcons.chevronLeft),
              onPressed: onBack,
              semanticLabel: 'Return to all Agent Ready apps',
              size: CharcoalButtonSize.small,
              child: const Text('All apps'),
            ),
            const _AgentReadyMiniBadge(),
          ],
        ),
        SizedBox(height: theme.dimensions.space.layout40),
        Text(
          '$title · $type',
          style: theme.textStyles.headingL.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component20),
        Text(
          description,
          style: theme.textStyles.body.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component30),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            color: theme.colors.containerSecondaryDefault,
          ),
          child: Padding(
            padding: EdgeInsets.all(theme.dimensions.space.component30),
            child: Row(
              children: <Widget>[
                CharcoalIcon(
                  CharcoalIcons.click,
                  color: theme.colors.iconDefault,
                ),
                SizedBox(width: theme.dimensions.space.component20),
                Expanded(
                  child: Text(
                    'LIVE SIMULATION · $interactionSummary',
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final class _AsterAppTile extends StatelessWidget {
  const _AsterAppTile({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
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
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.fast,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: active
                  ? theme.colors.borderDefault
                  : theme.colors.borderSecondary,
            ),
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            color: states.contains(WidgetState.pressed)
                ? theme.colors.containerSecondaryDefaultA
                : theme.colors.backgroundDefault,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 210, child: _AsterTileArtwork()),
                SizedBox(
                  height: theme.dimensions.borderWidth.m,
                  child: ColoredBox(color: theme.colors.borderSecondary),
                ),
                Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.component30),
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
                          SizedBox(width: theme.dimensions.space.component20),
                          Text(
                            '05',
                            style: theme.textStyles.captionSmall.copyWith(
                              color: theme.colors.textTertiaryDefault,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: theme.dimensions.space.component20),
                      Text(
                        'Aster · CREATIVE WORKSPACE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      SizedBox(height: theme.dimensions.space.component10),
                      Text(
                        'Responsive studio, projects, and profile settings',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
                      ),
                      SizedBox(height: theme.dimensions.space.component25),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Open simulation',
                              style: theme.textStyles.captionSmall.copyWith(
                                color: theme.colors.textInfoDefault,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CharcoalIcon(
                            CharcoalIcons.chevronRight,
                            color: theme.colors.iconDefault,
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
    final onColor = theme.colors.textOnPrimaryDefault;
    return DecoratedBox(
      decoration: BoxDecoration(
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
        padding: EdgeInsets.all(theme.dimensions.space.component30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.m,
                    ),
                    color: theme.colors.backgroundDefault.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Center(
                      child: Text(
                        'A',
                        style: theme.textStyles.bodyBold.copyWith(
                          color: onColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: theme.dimensions.space.component20),
                Expanded(
                  child: Text(
                    'Aster creative cloud',
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: onColor,
                    ),
                  ),
                ),
                CharcoalIcon(
                  CharcoalIcons.layout,
                  color: theme.colors.iconOnPrimaryDefault,
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
                SizedBox(width: theme.dimensions.space.component20),
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
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.backgroundDefault.withValues(alpha: 0.18),
      ),
      child: SizedBox(
        height: 92,
        child: Padding(
          padding: EdgeInsets.all(theme.dimensions.space.component20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CharcoalIcon(icon, color: theme.colors.iconOnPrimaryDefault),
              SizedBox(height: theme.dimensions.space.component20),
              Text(
                label,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textOnPrimaryDefault,
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
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component20,
          vertical: theme.dimensions.space.component10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.check,
              color: theme.colors.iconOnPrimaryDefault,
              size: 12,
            ),
            SizedBox(width: theme.dimensions.space.component10),
            Text(
              'MADE WITH AGENT READY',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textOnPrimaryDefault,
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
        borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
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
        padding: EdgeInsets.all(theme.dimensions.space.layout40),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 620;
            final mark = DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: theme.colors.backgroundDefault.withValues(alpha: 0.18),
              ),
              child: SizedBox.square(
                dimension: 52,
                child: Center(
                  child: CharcoalIcon(
                    CharcoalIcons.checkCircle,
                    color: theme.colors.iconOnPrimaryDefault,
                  ),
                ),
              ),
            );
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'MADE WITH AGENT READY',
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textOnPrimaryDefault.withValues(
                      alpha: 0.76,
                    ),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component20),
                Text(
                  'Discovered, composed, and verified by an agent.',
                  style: theme.textStyles.headingXs.copyWith(
                    color: theme.colors.textOnPrimaryDefault,
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component20),
                Text(
                  'No private recipes or copied showcase internals: only indexed public components, semantic tokens, responsive rules, and device verification.',
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textOnPrimaryDefault.withValues(
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
                  SizedBox(height: theme.dimensions.space.component30),
                  copy,
                ],
              );
            }
            return Row(
              children: <Widget>[
                mark,
                SizedBox(width: theme.dimensions.space.layout40),
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
    required this.page,
  });

  final _ExampleDestination destination;
  final bool mobileNavigationOpen;
  final ValueChanged<_ExampleDestination> onDestinationChanged;
  final VoidCallback onMobileNavigationToggle;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      key: const ValueKey<String>('agent-app-preview'),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
        color: theme.colors.backgroundDefault,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.l),
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
                    duration: CharcoalMotion.resolveDuration(
                      context,
                      CharcoalMotion.standard,
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
                  child: ColoredBox(color: theme.colors.backgroundDefault),
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
                      width: theme.dimensions.borderWidth.m,
                      child: const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const _AppTopBar(compact: false),
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
                  width: theme.dimensions.borderWidth.m,
                  child: ColoredBox(color: theme.colors.borderSecondary),
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
        duration: CharcoalMotion.resolveDuration(
          context,
          CharcoalMotion.standard,
        ),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: FractionalTranslation(
            translation: Offset(0, 0.015 * (1 - animation.value)),
            child: child,
          ),
        ),
        child: child,
      ),
    );
  }
}

final class _AppTopBar extends StatelessWidget {
  const _AppTopBar({
    required this.compact,
    this.menuOpen = false,
    this.onMenuPressed,
  });

  final bool compact;
  final bool menuOpen;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component30,
          vertical: theme.dimensions.space.component20,
        ),
        child: Row(
          children: <Widget>[
            if (compact) ...<Widget>[
              const _BrandMark(size: 34),
              SizedBox(width: theme.dimensions.space.component20),
              Expanded(
                child: Text(
                  'Aster',
                  style: theme.textStyles.bodyBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
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
                  style: theme.textStyles.captionMedium.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
              ),
              CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.search),
                onPressed: () {},
                semanticLabel: 'Search workspace',
                size: CharcoalIconButtonSize.small,
              ),
              SizedBox(width: theme.dimensions.space.component20),
              CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.bell),
                onPressed: () {},
                semanticLabel: 'Notifications',
                size: CharcoalIconButtonSize.small,
              ),
              SizedBox(width: theme.dimensions.space.component20),
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
      color: theme.colors.backgroundDefault,
      child: Padding(
        padding: EdgeInsets.all(theme.dimensions.space.component30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.dimensions.space.component20,
              ),
              child: Row(
                children: <Widget>[
                  const _BrandMark(size: 38),
                  SizedBox(width: theme.dimensions.space.component20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Aster',
                          style: theme.textStyles.bodyBold.copyWith(
                            color: theme.colors.textDefault,
                          ),
                        ),
                        Text(
                          'CREATIVE CLOUD',
                          style: theme.textStyles.captionSmall.copyWith(
                            color: theme.colors.textTertiaryDefault,
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
            SizedBox(height: theme.dimensions.space.layout40),
            ..._navigationItems(destination: destination, onChanged: onChanged),
            SizedBox(height: theme.dimensions.space.layout50),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                color: theme.colors.containerDiscoveryDefault,
              ),
              child: Padding(
                padding: EdgeInsets.all(theme.dimensions.space.component30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CharcoalIcon(
                      CharcoalIcons.bulbShine,
                      color: theme.colors.iconOnPrimaryDefault,
                    ),
                    SizedBox(height: theme.dimensions.space.component25),
                    Text(
                      'Make room for more ideas',
                      style: theme.textStyles.captionMediumBold.copyWith(
                        color: theme.colors.textOnDiscoveryDefault,
                      ),
                    ),
                    SizedBox(height: theme.dimensions.space.component10),
                    Text(
                      '12 GB of 20 GB used',
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textOnDiscoveryDefault.withValues(
                          alpha: 0.76,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: theme.dimensions.space.layout40),
            Row(
              children: <Widget>[
                const _Avatar(initials: 'MA', size: 34),
                SizedBox(width: theme.dimensions.space.component20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Mina Aoki',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                      Text(
                        'Pro plan',
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textSecondaryDefault,
                        ),
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
        border: Border(bottom: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          theme.dimensions.space.component30,
          theme.dimensions.space.component20,
          theme.dimensions.space.component30,
          theme.dimensions.space.component30,
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
    final pagePadding = theme.dimensions.space.layout40;
    return Padding(
      padding: EdgeInsets.all(pagePadding),
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
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textOnPrimaryDefault.withValues(
                        alpha: 0.72,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: theme.dimensions.space.component25),
                  Text(
                    'Make something only you could imagine.',
                    style:
                        (compact
                                ? theme.textStyles.headingM
                                : theme.textStyles.headingL)
                            .copyWith(color: theme.colors.textOnPrimaryDefault),
                  ),
                  SizedBox(height: theme.dimensions.space.component20),
                  Text(
                    'Your canvas is ready, and yesterday’s ideas are right where you left them.',
                    style: theme.textStyles.captionMedium.copyWith(
                      color: theme.colors.textOnPrimaryDefault.withValues(
                        alpha: 0.82,
                      ),
                    ),
                  ),
                  SizedBox(height: theme.dimensions.space.component40),
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
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.l,
                  ),
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
                  padding: EdgeInsets.all(
                    compact
                        ? theme.dimensions.space.component30
                        : theme.dimensions.space.layout40,
                  ),
                  child: compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            copy,
                            SizedBox(
                              height: theme.dimensions.space.component40,
                            ),
                            art,
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(flex: 5, child: copy),
                            SizedBox(width: theme.dimensions.space.layout40),
                            Expanded(flex: 4, child: art),
                          ],
                        ),
                ),
              );
            },
          ),
          SizedBox(height: theme.dimensions.space.layout40),
          const _SectionHeading(
            eyebrow: 'AT A GLANCE',
            title: 'Your creative rhythm',
          ),
          SizedBox(height: theme.dimensions.space.component30),
          const _MetricGrid(),
          SizedBox(height: theme.dimensions.space.layout40),
          _SectionHeading(
            action: CharcoalLinkButton(
              onPressed: onOpenProjects,
              child: const Text('View all'),
            ),
            eyebrow: 'RECENT WORK',
            title: 'Pick up where you left off',
          ),
          SizedBox(height: theme.dimensions.space.component30),
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
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.backgroundDefault.withValues(alpha: 0.16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -28,
                    top: -34,
                    child: _ArtCircle(
                      color: theme.colors.containerNoticeDefault,
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
                          borderRadius: BorderRadius.circular(
                            theme.dimensions.radius.l,
                          ),
                          color: theme.colors.containerPositiveDefault,
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
                        color: theme.colors.backgroundDefault.withValues(
                          alpha: 0.86,
                        ),
                      ),
                      child: SizedBox(height: compact ? 126 : 166),
                    ),
                  ),
                  Positioned(
                    bottom: theme.dimensions.space.component30,
                    left: theme.dimensions.space.component30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: theme.colors.containerOnImgDefault,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.dimensions.space.component25,
                          vertical: theme.dimensions.space.component20,
                        ),
                        child: Text(
                          'DAYBREAK · 04',
                          style: theme.textStyles.captionSmall.copyWith(
                            color: theme.colors.textOnOnImgDefault,
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
    final gap = theme.dimensions.space.component30;
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
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerSecondaryDefault,
            ),
            child: SizedBox.square(
              dimension: theme.dimensions.space.targetL,
              child: Center(
                child: CharcoalIcon(icon, color: theme.colors.iconDefault),
              ),
            ),
          ),
          SizedBox(width: theme.dimensions.space.component25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: theme.textStyles.headingXs.copyWith(
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
    );
  }
}

final class _ProjectsPage extends StatelessWidget {
  const _ProjectsPage({
    required this.filter,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.searchQuery,
    super.key,
  });

  final _ProjectFilter filter;
  final ValueChanged<_ProjectFilter> onFilterChanged;
  final ValueChanged<String> onSearchChanged;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final visibleProjects = _allProjects
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
    return Padding(
      padding: EdgeInsets.all(theme.dimensions.space.layout40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _AdaptivePageHeading(
            action: CharcoalButton(
              leading: const CharcoalIcon(CharcoalIcons.add),
              onPressed: () {},
              variant: CharcoalButtonVariant.primary,
              child: const Text('New project'),
            ),
            description:
                'Everything you are making, from first sketch to final export.',
            eyebrow: 'LIBRARY',
            title: 'Projects',
          ),
          SizedBox(height: theme.dimensions.space.layout40),
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
                    SizedBox(height: theme.dimensions.space.component30),
                    filters,
                  ],
                );
              }
              return Row(
                children: <Widget>[
                  Expanded(child: search),
                  SizedBox(width: theme.dimensions.space.component30),
                  filters,
                ],
              );
            },
          ),
          SizedBox(height: theme.dimensions.space.layout40),
          _SectionHeading(
            eyebrow: '${visibleProjects.length} ITEMS',
            title: switch (filter) {
              _ProjectFilter.all => 'Current work',
              _ProjectFilter.shared => 'Shared with others',
              _ProjectFilter.archived => 'Archive',
            },
          ),
          SizedBox(height: theme.dimensions.space.component30),
          if (visibleProjects.isEmpty)
            _EmptyProjects(query: searchQuery)
          else
            _ProjectGrid(projects: visibleProjects),
          SizedBox(height: theme.dimensions.space.layout40),
          LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth < 520
                ? CharcoalButton(
                    fullWidth: true,
                    onPressed: visibleProjects.isEmpty ? null : () {},
                    child: const Text('Load more'),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: CharcoalPagination(
                      currentPage: 1,
                      onPageChanged: (_) {},
                      pageCount: 4,
                      semanticLabel: 'Project pages',
                      size: CharcoalPaginationSize.small,
                    ),
                  ),
          ),
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
    return Padding(
      padding: EdgeInsets.all(theme.dimensions.space.layout40),
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
          SizedBox(height: theme.dimensions.space.layout40),
          _Surface(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.layout40),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 520;
                      final identity = Column(
                        crossAxisAlignment: compact
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Mina Aoki',
                            textAlign: compact ? TextAlign.center : null,
                            style: theme.textStyles.headingXs.copyWith(
                              color: theme.colors.textDefault,
                            ),
                          ),
                          SizedBox(height: theme.dimensions.space.component10),
                          Text(
                            '@mina.draws · Tokyo, Japan',
                            textAlign: compact ? TextAlign.center : null,
                            style: theme.textStyles.captionMedium.copyWith(
                              color: theme.colors.textSecondaryDefault,
                            ),
                          ),
                        ],
                      );
                      final avatar = DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: theme.colors.containerDiscoveryDefault,
                        ),
                        child: SizedBox.square(
                          dimension: compact ? 72 : 80,
                          child: Center(
                            child: Text(
                              'MA',
                              style: theme.textStyles.headingS.copyWith(
                                color: theme.colors.textOnDiscoveryDefault,
                              ),
                            ),
                          ),
                        ),
                      );
                      final changePhoto = CharcoalButton(
                        onPressed: () {},
                        size: CharcoalButtonSize.small,
                        child: const Text('Change photo'),
                      );
                      if (compact) {
                        return Column(
                          children: <Widget>[
                            avatar,
                            SizedBox(
                              height: theme.dimensions.space.component30,
                            ),
                            identity,
                            SizedBox(
                              height: theme.dimensions.space.component30,
                            ),
                            changePhoto,
                          ],
                        );
                      }
                      return Row(
                        children: <Widget>[
                          avatar,
                          SizedBox(width: theme.dimensions.space.component30),
                          Expanded(child: identity),
                          SizedBox(width: theme.dimensions.space.component30),
                          changePhoto,
                        ],
                      );
                    },
                  ),
                ),
                _SurfaceDivider(color: theme.colors.borderSecondary),
                Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.layout40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _SectionHeading(
                        eyebrow: 'PUBLIC PROFILE',
                        title: 'About you',
                      ),
                      SizedBox(height: theme.dimensions.space.component30),
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
                                SizedBox(
                                  height: theme.dimensions.space.component30,
                                ),
                                email,
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(child: name),
                              SizedBox(
                                width: theme.dimensions.space.component30,
                              ),
                              Expanded(child: email),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: theme.dimensions.space.component30),
                      CharcoalTextArea(
                        controller: bioController,
                        label: 'Bio',
                        maxLength: 120,
                        rows: 3,
                        showCount: true,
                        showLabel: true,
                      ),
                      SizedBox(height: theme.dimensions.space.component30),
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
                _SurfaceDivider(color: theme.colors.borderSecondary),
                Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.layout40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _SectionHeading(
                        eyebrow: 'NOTIFICATIONS',
                        title: 'Stay in the loop',
                      ),
                      SizedBox(height: theme.dimensions.space.component30),
                      _PreferenceRow(
                        description:
                            'A calm summary of views, saves, and comments.',
                        onChanged: onWeeklyDigestChanged,
                        title: 'Weekly studio digest',
                        value: weeklyDigest,
                      ),
                      SizedBox(height: theme.dimensions.space.component30),
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
    final copy = Column(
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
        SizedBox(height: theme.dimensions.space.component20),
        Text(
          title,
          style: theme.textStyles.headingM.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        SizedBox(height: theme.dimensions.space.component20),
        Text(
          description,
          style: theme.textStyles.captionMedium.copyWith(
            color: theme.colors.textSecondaryDefault,
          ),
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
              SizedBox(height: theme.dimensions.space.component30),
              action,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(child: copy),
            SizedBox(width: theme.dimensions.space.layout40),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eyebrow,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textTertiaryDefault,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),
              SizedBox(height: theme.dimensions.space.component10),
              Text(
                title,
                style: theme.textStyles.headingXxs.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
            ],
          ),
        ),
        if (action != null) ...<Widget>[
          SizedBox(width: theme.dimensions.space.component20),
          action!,
        ],
      ],
    );
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
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.dimensions.space.component30),
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
    height: CharcoalTheme.of(context).dimensions.borderWidth.m,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.textStyles.captionMediumBold.copyWith(
                  color: theme.colors.textDefault,
                ),
              ),
              SizedBox(height: theme.dimensions.space.component10),
              Text(
                description,
                style: theme.textStyles.captionSmall.copyWith(
                  color: theme.colors.textSecondaryDefault,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: theme.dimensions.space.component20),
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
  const _ProjectGrid({required this.projects});

  final List<_ProjectData> projects;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final gap = theme.dimensions.space.component30;
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
                child: _ProjectCard(project: project),
              ),
          ],
        );
      },
    );
  }
}

final class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final _ProjectData project;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return _Surface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _ProjectArtwork(tone: project.tone),
          Padding(
            padding: EdgeInsets.all(theme.dimensions.space.component30),
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
                        style: theme.textStyles.captionMediumBold.copyWith(
                          color: theme.colors.textDefault,
                        ),
                      ),
                    ),
                    CharcoalIconButton(
                      icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),
                      onPressed: () {},
                      semanticLabel: 'More actions for ${project.title}',
                      size: CharcoalIconButtonSize.extraSmall,
                    ),
                  ],
                ),
                SizedBox(height: theme.dimensions.space.component10),
                Text(
                  project.details,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
                SizedBox(height: theme.dimensions.space.component25),
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
      0 => (
        theme.colors.containerPrimaryDefault,
        theme.colors.containerNoticeDefault,
        theme.colors.containerDiscoveryDefault,
      ),
      1 => (
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerPositiveDefault,
        theme.colors.backgroundDefault,
      ),
      2 => (
        theme.colors.containerNoticeDefault,
        theme.colors.containerPrimaryDefault,
        theme.colors.containerNegativeDefault,
      ),
      _ => (
        theme.colors.containerPositiveDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNeutralDefault,
      ),
    };
    return Semantics(
      image: true,
      label: 'Project artwork thumbnail',
      child: ExcludeSemantics(
        child: SizedBox(
          height: 148,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(theme.dimensions.radius.m),
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
                          borderRadius: BorderRadius.circular(
                            theme.dimensions.radius.m,
                          ),
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
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: positive
            ? theme.colors.containerPositiveDefault.withValues(alpha: 0.18)
            : theme.colors.containerSecondaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component20,
          vertical: theme.dimensions.space.component10,
        ),
        child: Text(
          label,
          style: theme.textStyles.captionSmall.copyWith(
            color: positive
                ? theme.colors.textPositiveDefault
                : theme.colors.textSecondaryDefault,
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
        padding: EdgeInsets.symmetric(
          vertical: theme.dimensions.space.layout40,
        ),
        child: Column(
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.search,
              color: theme.colors.iconSecondaryDefault,
            ),
            SizedBox(height: theme.dimensions.space.component20),
            Text(
              query.trim().isEmpty
                  ? 'No projects in this view'
                  : 'No results for “${query.trim()}”',
              textAlign: TextAlign.center,
              style: theme.textStyles.captionMediumBold.copyWith(
                color: theme.colors.textDefault,
              ),
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
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.dimensions.space.component25,
          vertical: theme.dimensions.space.component20,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalIcon(
              CharcoalIcons.checkCircle,
              color: theme.colors.iconPositiveDefault,
              size: 16,
            ),
            SizedBox(width: theme.dimensions.space.component20),
            Text(
              label,
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textSecondaryDefault,
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
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: theme.colors.containerPrimaryDefault,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            'A',
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textOnPrimaryDefault,
            ),
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
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerNoticeDefault,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            initials,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textOnNoticeDefault,
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
