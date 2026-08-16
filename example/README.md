# Charcoal UI V2 Showcase

This Flutter app is the exhaustive Charcoal V2 visual catalog for generated colors, typography,
dimensions, every generated icon asset, component variants, interaction states, and overlays. It is
built from `charcoal_ui`, `charcoal_icons`, and Flutter's Widgets layer, and intentionally imports
neither Material nor Cupertino.

Run it from the repository root:

```sh
fvm flutter run -d macos -t example/lib/main.dart
fvm flutter run -d <android-device-id> -t example/lib/main.dart
fvm flutter run -d <ios-device-id> -t example/lib/main.dart
```

The shell switches from a persistent desktop sidebar to a touch-oriented mobile navigation panel
when the available window width is below 1024 logical pixels. The mobile layout honors system safe
areas and supports both portrait and landscape without locking orientation.

The Showcase includes a separate, debug-only Flutter Skill entrypoint for fast E2E inspection.
Keeping the bridge out of the default entrypoint avoids opening its local automation server during
a normal Showcase run. Start the bridge entrypoint, then connect Flutter Skill to the VM Service URI
printed by Flutter:

```sh
cd example
fvm flutter run -d chrome -t lib/main_flutter_skill.dart --vm-service-port=50000
flutter-skill inspect 'ws://127.0.0.1:50000/<session>/ws'
```

The bridge belongs to the example app only; `charcoal_ui` has no runtime dependency on
`flutter_skill`.

Each Showcase destination owns its scroll lifecycle. Switching destinations preserves their scroll
positions and uses an opaque shared-axis transition, so the outgoing page is never reset or faded
through the background before the incoming page is ready.
