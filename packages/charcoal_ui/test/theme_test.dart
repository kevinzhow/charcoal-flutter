import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('maybeOf distinguishes an unthemed subtree', (tester) async {
    CharcoalThemeData? resolved;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            resolved = CharcoalTheme.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved, isNull);
  });

  testWidgets('captured overlays retain the exact scoped theme', (
    tester,
  ) async {
    final theme = CharcoalThemeData.dark();
    Widget? captured;
    CharcoalThemeData? resolved;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CharcoalTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              captured = InheritedTheme.captureAll(
                context,
                Builder(
                  builder: (context) {
                    resolved = CharcoalTheme.of(context);
                    return const SizedBox.shrink();
                  },
                ),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: captured!,
      ),
    );

    expect(identical(resolved, theme), isTrue);
  });

  testWidgets('dependents rebuild when scoped theme data changes', (
    tester,
  ) async {
    final light = CharcoalThemeData.light();
    final theme = ValueNotifier<CharcoalThemeData>(light);
    var builds = 0;
    addTearDown(theme.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ValueListenableBuilder<CharcoalThemeData>(
          valueListenable: theme,
          builder: (context, data, child) => CharcoalTheme(
            data: data,
            child: Builder(
              builder: (context) {
                builds++;
                return Text(CharcoalTheme.of(context).brightness.name);
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('light'), findsOneWidget);
    final initialBuilds = builds;

    theme.value = CharcoalThemeData.dark();
    await tester.pump();

    expect(find.text('dark'), findsOneWidget);
    expect(builds, greaterThan(initialBuilds));
  });
}
