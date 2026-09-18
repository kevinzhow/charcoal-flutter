import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/scaffold_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/previews/platform_previews.dart';
import 'package:charcoal_ui_showcase/showcase_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'profile editor saves session state and clears confirmation after editing',
    (tester) async {
      for (final size in [const Size(320, 640), const Size(390, 844)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          CharcoalApp(home: AgentScaffoldExample(key: ValueKey(size))),
        );
        await tester.enterText(find.byType(EditableText).first, 'New name');
        await tester.tap(find.text('Save profile'));
        await tester.pump();
        expect(find.text('Saved for this session.'), findsOneWidget);
        await tester.enterText(find.byType(EditableText).first, 'Another name');
        await tester.pump();
        expect(find.text('Saved for this session.'), findsNothing);
        expect(tester.takeException(), isNull);
      }
      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'platform previews render real page states under compact constraints and large text',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final preview in [
        scaffoldPreview,
        scaffoldKeyboardPreview,
        fullBleedPagePreview,
      ]) {
        await tester.pumpWidget(
          CharcoalApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(2.5),
              ),
              child: Builder(builder: (_) => preview()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(CharcoalScaffold), findsOneWidget);
      }
    },
  );

  testWidgets(
    'native caption metrics are applied above routed content and update safely',
    (tester) async {
      const channel = MethodChannel('dev.charcoal.showcase/window');
      final appearances = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'getMetrics') return {'captionHeight': 28.0};
            if (call.method == 'setBrightness') {
              appearances.add(call.arguments as String);
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      await tester.pumpWidget(
        CharcoalApp(
          builder: (context, child) =>
              ShowcaseWindow(brightness: Brightness.dark, child: child!),
          home: const CharcoalScaffold(
            body: SizedBox.expand(key: ValueKey('content')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(const ValueKey('content'))).dy, 28);
      expect(appearances, contains('dark'));
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        channel.name,
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('metrics', {'captionHeight': 0.0}),
        ),
        (_) {},
      );
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(const ValueKey('content'))).dy, 0);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );
}
