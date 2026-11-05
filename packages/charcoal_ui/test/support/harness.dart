import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Sets the test window to [size] at device pixel ratio 1 and resets it after the test.
void useWindow(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Mounts [home] in a [CharcoalApp] with the pack of [brightness] (or [pack]).
///
/// [home] sits inside a transparent [Material] so ink-based widgets have the ancestor a page
/// would provide. [boundaryKey] wraps the whole app for pixel capture.
Future<void> pumpCharcoal(
  WidgetTester tester,
  Widget home, {
  Brightness brightness = Brightness.light,
  CharcoalThemePack? pack,
  Size? size,
  double textScale = 1,
  Key? boundaryKey,
  bool settle = true,
}) async {
  if (size != null) useWindow(tester, size);
  final effective = pack ?? (brightness == Brightness.dark ? charcoalDarkPack : charcoalLightPack);
  await tester.pumpWidget(
    RepaintBoundary(
      key: boundaryKey,
      child: CharcoalApp(
        lightPack: effective,
        darkPack: effective,
        themeMode: effective.brightness == Brightness.dark
            ? CharcoalThemeMode.dark
            : CharcoalThemeMode.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Material(type: MaterialType.transparency, child: home),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
