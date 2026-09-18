# Platform behavior

Charcoal uses Flutter's Widgets/services layer for editing and platform behavior.
It does not import Material or Cupertino. Visual source parity alone is not an
acceptance test for these capabilities.

## Ownership

| Capability | Owner | Contract |
| --- | --- | --- |
| Edge-to-edge / immersive display mode | Host bootstrap | Call `configureCharcoalSystemUi()` after initializing the binding. An optional `SystemUiMode` requests immersive display where the OS permits it. Android target SDK rules remain authoritative. |
| System bar appearance | `CharcoalScaffold` | Transparent bars with icon contrast derived from the page background, or an explicit `systemOverlayStyle`. Routing restores the revealed page's annotated style. |
| Safe areas | `CharcoalScaffold` | Full-window background; safe navigation, content and bottom controls. Descendants receive consumed insets so nested SafeAreas do not double-pad. |
| Keyboard avoidance | `CharcoalScaffold`, `CharcoalDialog` | Shrink content above the keyboard, keep bottom actions reachable, and remove consumed viewInsets. Scrollable form bodies remain an application responsibility. |
| Full-bleed content | Page | Set `bodySafeArea: false`. Protect interactive controls with SafeArea. `extendBodyBehindNavigationBar` exposes the covered top extent through the body's MediaQuery padding for scrollable content. |
| Selection gestures | Shared internal editor | Flutter's `TextSelectionGestureDetectorBuilder` owns platform taps, long presses, floating cursor, double/triple taps and pointer dragging. |
| Selection UI | Shared internal editor | Charcoal handles and magnifier; native iOS editing menu where supported, localized Charcoal toolbar elsewhere. Flutter determines permitted clipboard actions, including password/read-only restrictions. |
| Editing extensions | Field / area API | `contextMenuBuilder`, `enableInteractiveSelection`, `autofillHints`, `inputFormatters`, `scrollPadding`, and `undoController`. Pass null to disable the menu. |
| Character count | Field / area | Grapheme clusters, matching Flutter's length limiter for emoji and combining sequences. |
| Desktop native caption | Host runner | Preserve OS window buttons, drag, zoom, and fullscreen. This cannot be implemented by a page navigation bar. |

`CharcoalNavigationBar` implements `PreferredSizeWidget` for use as the scaffold's
navigation bar. Keep one scaffold per actual page, rather than wrapping each
component or list section.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCharcoalSystemUi();
  runApp(CharcoalApp(home: CharcoalScaffold(
    navigationBar: const CharcoalNavigationBar(title: Text('Profile')),
    body: ListView(children: const [
      CharcoalTextField(label: 'Name', showLabel: true),
    ]),
  )));
}
```

Use `GlobalWidgetsLocalizations.delegate` from Flutter's localization package in
`CharcoalApp.localizationsDelegates` for localized editing labels. The default
Widgets localization is English. Custom menu items should carry their own labels.
Clipboard permissions on Web and system menu availability remain platform-owned.

## macOS host

The Showcase opts into `fullSizeContentView` with a transparent native titlebar.
`MainFlutterWindow` reports the actual caption inset from `contentLayoutRect`
through `dev.charcoal.showcase/window`; `ShowcaseWindow` applies it above the
Navigator so every route can consume it. Resize/fullscreen notifications update
the inset, and theme changes update only the window's native appearance. Native
traffic lights and titlebar hit testing remain owned by AppKit.

Background development launches can set `CHARCOAL_BACKGROUND=1`; deferred window
presentation then orders behind other windows without taking focus while the app
is inactive. Normal interactive launches retain standard presentation behavior.

Other desktop hosts retain their native frames. Applications replacing a Windows
or Linux caption must supply host-specific hit testing and window actions; mobile
and browser layouts must not simulate desktop window controls.

## Verification contract

- Text field and text area: Android long-press/drag selection and menu copy;
  focused iOS caret movement and magnifier lifecycle; desktop double click and
  drag; read-only, disabled and password behavior; grapheme count/length limit.
- Pages: safe insets exactly once, navigation and bottom controls, keyboard show/
  hide, resize opt-out, full bleed and system-bar contrast.
- Dialogs: scrolling and safe placement with a keyboard and constrained height.
- Runtime: isolated `platform_previews.dart` first, then the real Showcase for
  native caption and navigation integration. Widget platform variants prove
  framework behavior, not native OS menu, IME or window-manager integration.

See `packages/charcoal_ui/test/text_editing_test.dart`, `scaffold_test.dart`, and
`example/lib/agent_examples/previews/platform_previews.dart` for executable cases.
