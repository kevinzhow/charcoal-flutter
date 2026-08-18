import 'dart:io' show Platform;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' show vg;
import 'package:flutter_test/flutter_test.dart';

const _goldenKey = ValueKey<String>('golden-surface');
// Ahem fixes text metrics; host-specific baselines isolate rasterizer output.
const _goldenFontFamily = 'Ahem';
final _goldenHostPlatform = switch (Platform.operatingSystem) {
  'linux' => 'linux',
  'macos' => 'macos',
  final platform => throw UnsupportedError(
    'Visual golden baselines are not available for $platform.',
  ),
};

enum _Destination { home, discover, messages, profile }

void main() {
  for (final mode in <({String name, CharcoalThemeData theme})>[
    (name: 'light', theme: CharcoalThemeData.light()),
    (name: 'dark', theme: CharcoalThemeData.dark()),
  ]) {
    testWidgets('navigation geometry remains stable in ${mode.name}', (tester) async {
      await _expectGoldenSurface(
        tester,
        size: const Size(840, 480),
        theme: mode.theme,
        child: const _NavigationGoldenSurface(),
        fileName: 'goldens/$_goldenHostPlatform/navigation.${mode.name}.png',
      );
    });

    testWidgets('form validation remains stable in ${mode.name}', (tester) async {
      await _expectGoldenSurface(
        tester,
        size: const Size(420, 520),
        theme: mode.theme,
        child: const _FormGoldenSurface(),
        fileName: 'goldens/$_goldenHostPlatform/form_validation.${mode.name}.png',
      );
    });

    testWidgets('selection controls remain stable in ${mode.name}', (
      tester,
    ) async {
      await _expectGoldenSurface(
        tester,
        size: const Size(420, 520),
        theme: mode.theme,
        child: const _SelectionControlsGoldenSurface(),
        fileName: 'goldens/$_goldenHostPlatform/selection_controls.${mode.name}.png',
      );
    });

    testWidgets('multi-select states remain stable in ${mode.name}', (
      tester,
    ) async {
      await _expectGoldenSurface(
        tester,
        size: const Size(420, 400),
        theme: mode.theme,
        child: const _MultiSelectGoldenSurface(),
        fileName: 'goldens/$_goldenHostPlatform/multi_select.${mode.name}.png',
      );
    });

    testWidgets('action controls remain stable in ${mode.name}', (
      tester,
    ) async {
      await _expectGoldenSurface(
        tester,
        size: const Size(520, 360),
        theme: mode.theme,
        child: const _ActionControlsGoldenSurface(),
        fileName: 'goldens/$_goldenHostPlatform/action_controls.${mode.name}.png',
      );
    });
  }
}

Future<void> _expectGoldenSurface(
  WidgetTester tester, {
  required Size size,
  required CharcoalThemeData theme,
  required Widget child,
  required String fileName,
}) async {
  final originalPlatform = debugDefaultTargetPlatformOverride;
  debugDefaultTargetPlatformOverride = TargetPlatform.linux;
  try {
    await _pumpGoldenSurface(
      tester,
      size: size,
      theme: theme,
      child: child,
    );
    await expectLater(find.byKey(_goldenKey), matchesGoldenFile(fileName));
  } finally {
    debugDefaultTargetPlatformOverride = originalPlatform;
  }
}

Future<void> _pumpGoldenSurface(
  WidgetTester tester, {
  required Size size,
  required CharcoalThemeData theme,
  required Widget child,
}) async {
  final goldenTheme = theme.copyWith(
    typography: theme.typography.copyWith(
      fontFamily: theme.typography.fontFamily.copyWith(
        sans: _goldenFontFamily,
      ),
    ),
  );

  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    CharcoalApp(
      darkTheme: goldenTheme,
      theme: goldenTheme,
      themeMode: CharcoalThemeMode.light,
      home: Builder(
        builder: (context) {
          final media = MediaQuery.of(context).copyWith(
            accessibleNavigation: false,
            boldText: false,
            disableAnimations: true,
            highContrast: false,
            textScaler: TextScaler.noScaling,
          );
          return MediaQuery(
            data: media,
            child: RepaintBoundary(
              key: _goldenKey,
              child: SizedBox.expand(child: child),
            ),
          );
        },
      ),
    ),
  );
  await tester.runAsync(() => vg.waitForPendingDecodes());
  await tester.pumpAndSettle();
}

final class _NavigationGoldenSurface extends StatelessWidget {
  const _NavigationGoldenSurface();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ColoredBox(
      color: theme.colors.backgroundDefault,
      child: Padding(
        padding: EdgeInsets.all(theme.dimensions.space.layout40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                  color: theme.colors.containerSecondaryDefaultA,
                ),
                child: Padding(
                  padding: EdgeInsets.all(theme.dimensions.space.component40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Workspace', style: theme.textStyles.headingS),
                      SizedBox(height: theme.dimensions.space.component40),
                      CharcoalNavigationItem(
                        leading: const CharcoalIcon(CharcoalIcons.home),
                        onPressed: _ignore,
                        selected: true,
                        child: const Text('Overview'),
                      ),
                      SizedBox(height: theme.dimensions.space.component20),
                      CharcoalNavigationItem(
                        leading: const CharcoalIcon(CharcoalIcons.compass),
                        onPressed: _ignore,
                        child: const Text('Discover'),
                      ),
                      SizedBox(height: theme.dimensions.space.component20),
                      CharcoalNavigationItem(
                        leading: const CharcoalIcon(CharcoalIcons.calendar),
                        onPressed: _ignore,
                        trailing: const Text('12'),
                        child: const Text('Settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: theme.dimensions.space.layout40),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colors.borderSecondary),
                  borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                  color: theme.colors.backgroundDefault,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CharcoalNavigationBar(
                        leading: CharcoalIconButton(
                          icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
                          onPressed: _ignore,
                          semanticLabel: 'Back',
                          size: CharcoalIconButtonSize.small,
                        ),
                        title: const Text('Overview'),
                        trailing: CharcoalIconButton(
                          icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),
                          onPressed: _ignore,
                          semanticLabel: 'More actions',
                          size: CharcoalIconButtonSize.small,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Stable destination content',
                            style: theme.textStyles.body,
                          ),
                        ),
                      ),
                      CharcoalTabBar<_Destination>(
                        items: const <CharcoalTabItem<_Destination>>[
                          CharcoalTabItem<_Destination>(
                            icon: CharcoalIcon(CharcoalIcons.home),
                            label: 'Home',
                            value: _Destination.home,
                          ),
                          CharcoalTabItem<_Destination>(
                            icon: CharcoalIcon(CharcoalIcons.compass),
                            label: 'Discover',
                            value: _Destination.discover,
                          ),
                          CharcoalTabItem<_Destination>(
                            badge: '3',
                            icon: CharcoalIcon(CharcoalIcons.message),
                            label: 'Messages',
                            semanticLabel: 'Messages, 3 unread',
                            value: _Destination.messages,
                          ),
                          CharcoalTabItem<_Destination>(
                            icon: CharcoalIcon(CharcoalIcons.personCircle),
                            label: 'Profile',
                            value: _Destination.profile,
                          ),
                        ],
                        onChanged: _ignoreDestination,
                        semanticLabel: 'Primary destinations',
                        value: _Destination.home,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _FormGoldenSurface extends StatelessWidget {
  const _FormGoldenSurface();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ColoredBox(
      color: theme.colors.backgroundDefault,
      child: Padding(
        padding: EdgeInsets.all(theme.dimensions.space.layout40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const CharcoalTextField(
              assistiveText: 'Use at least 3 characters.',
              invalid: true,
              label: 'Display name',
              placeholder: 'Enter a name',
              required: true,
              showLabel: true,
            ),
            SizedBox(height: theme.dimensions.space.layout40),
            const CharcoalTextArea(
              assistiveText: 'Describe the expected result.',
              invalid: true,
              label: 'Description',
              placeholder: 'Add context',
              required: true,
              rows: 3,
              showLabel: true,
            ),
            SizedBox(height: theme.dimensions.space.layout40),
            const CharcoalDropdown<String>(
              assistiveText: 'Choose a visibility.',
              invalid: true,
              label: 'Visibility',
              onChanged: _ignoreString,
              options: <CharcoalDropdownOption<String>>[
                CharcoalDropdownOption<String>(value: 'public', label: 'Public'),
                CharcoalDropdownOption<String>(value: 'private', label: 'Private'),
              ],
              placeholder: 'Choose one',
              required: true,
              showLabel: true,
              value: null,
            ),
          ],
        ),
      ),
    );
  }
}

final class _SelectionControlsGoldenSurface extends StatefulWidget {
  const _SelectionControlsGoldenSurface();

  @override
  State<_SelectionControlsGoldenSurface> createState() => _SelectionControlsGoldenSurfaceState();
}

final class _SelectionControlsGoldenSurfaceState extends State<_SelectionControlsGoldenSurface> {
  final WidgetStatesController _focused = WidgetStatesController(
    <WidgetState>{WidgetState.focused},
  );

  @override
  void dispose() {
    _focused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return ColoredBox(
      color: theme.colors.backgroundDefault,
      child: Padding(
        padding: EdgeInsets.all(space.layout40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Selection controls', style: theme.textStyles.headingS),
            SizedBox(height: space.layout40),
            CharcoalCheckbox(
              value: true,
              onChanged: _ignoreBool,
              statesController: _focused,
              label: const Text('Focused and selected'),
            ),
            SizedBox(height: space.component40),
            const CharcoalCheckbox(
              value: false,
              invalid: true,
              onChanged: _ignoreBool,
              label: Text('Invalid required choice'),
            ),
            SizedBox(height: space.component40),
            const CharcoalCheckbox(
              value: true,
              onChanged: null,
              label: Text('Disabled selection'),
            ),
            SizedBox(height: space.layout40),
            const CharcoalRadio<String>(
              value: 'public',
              groupValue: 'public',
              onChanged: _ignoreString,
              label: Text('Selected option'),
            ),
            SizedBox(height: space.component40),
            const CharcoalRadio<String>(
              value: 'private',
              groupValue: 'public',
              invalid: true,
              onChanged: _ignoreString,
              label: Text('Invalid option'),
            ),
            SizedBox(height: space.layout40),
            const CharcoalSwitch(
              value: true,
              onChanged: _ignoreBool,
              label: Text('Enabled setting'),
            ),
            SizedBox(height: space.component40),
            const CharcoalSwitch(
              value: false,
              onChanged: null,
              label: Text('Disabled setting'),
            ),
          ],
        ),
      ),
    );
  }
}

final class _MultiSelectGoldenSurface extends StatelessWidget {
  const _MultiSelectGoldenSurface();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return ColoredBox(
      color: theme.colors.backgroundDefault,
      child: Padding(
        padding: EdgeInsets.all(space.layout40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Multi-select states', style: theme.textStyles.headingS),
            SizedBox(height: space.layout40),
            const CharcoalMultiSelect(
              label: Text('Selected option'),
              onChanged: _ignoreBool,
              selected: true,
            ),
            SizedBox(height: space.component40),
            const CharcoalMultiSelect(
              invalid: true,
              label: Text('Invalid option'),
              onChanged: _ignoreBool,
              selected: false,
            ),
            SizedBox(height: space.component40),
            const CharcoalMultiSelect(
              invalid: true,
              label: Text('Disabled invalid option'),
              onChanged: null,
              selected: false,
            ),
            SizedBox(height: space.layout40),
            Text('Media overlay', style: theme.textStyles.bodyBold),
            SizedBox(height: space.component20),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                  gradient: LinearGradient(
                    colors: <Color>[
                      theme.colors.containerPrimaryDefault,
                      theme.colors.containerNeutralDefault,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(space.component40),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CharcoalMultiSelect(
                        onChanged: _ignoreBool,
                        selected: true,
                        semanticLabel: 'Selected featured media',
                        variant: CharcoalMultiSelectVariant.overlay,
                      ),
                      CharcoalMultiSelect(
                        onChanged: _ignoreBool,
                        selected: false,
                        semanticLabel: 'Unselected featured media',
                        variant: CharcoalMultiSelectVariant.overlay,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ActionControlsGoldenSurface extends StatelessWidget {
  const _ActionControlsGoldenSurface();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return ColoredBox(
      color: theme.colors.backgroundDefault,
      child: Padding(
        padding: EdgeInsets.all(space.layout40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Action controls', style: theme.textStyles.headingS),
            SizedBox(height: space.layout40),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: space.component40,
              runSpacing: space.component40,
              children: <Widget>[
                for (final size in CharcoalIconButtonSize.values)
                  CharcoalIconButton(
                    icon: const CharcoalIcon(CharcoalIcons.add),
                    onPressed: _ignore,
                    semanticLabel: '${size.name} add',
                    size: size,
                  ),
                const CharcoalIconButton(
                  icon: CharcoalIcon(CharcoalIcons.bookmark),
                  onPressed: _ignore,
                  selected: false,
                  semanticLabel: 'Save item',
                ),
                const CharcoalIconButton(
                  icon: CharcoalIcon(CharcoalIcons.bookmark),
                  onPressed: _ignore,
                  selected: true,
                  semanticLabel: 'Remove saved item',
                ),
                const CharcoalIconButton(
                  icon: CharcoalIcon(CharcoalIcons.x),
                  onPressed: null,
                  semanticLabel: 'Disabled action',
                ),
                SizedBox.square(
                  dimension: 48,
                  child: ColoredBox(
                    color: theme.colors.containerHudDefault,
                    child: const Center(
                      child: CharcoalIconButton(
                        icon: CharcoalIcon(CharcoalIcons.dotsHorizontal),
                        onPressed: _ignore,
                        semanticLabel: 'Overlay action',
                        size: CharcoalIconButtonSize.small,
                        variant: CharcoalIconButtonVariant.overlay,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: space.layout40),
            const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  onPressed: _ignore,
                  child: Text('Regular action'),
                ),
                CharcoalButton(
                  onPressed: _ignore,
                  selected: false,
                  child: Text('Toggle off'),
                ),
                CharcoalButton(
                  onPressed: _ignore,
                  selected: true,
                  child: Text('Toggle on'),
                ),
              ],
            ),
            SizedBox(height: space.layout40),
            const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalLinkButton(
                  onPressed: _ignore,
                  child: Text('Clear filters'),
                ),
                CharcoalLinkButton(
                  onPressed: null,
                  child: Text('Unavailable'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _ignore() {}

void _ignoreBool(bool value) {}

void _ignoreDestination(_Destination value) {}

void _ignoreString(String? value) {}
