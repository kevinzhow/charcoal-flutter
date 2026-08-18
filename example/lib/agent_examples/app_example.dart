import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Hosts a declarative router inside Charcoal's complete application boundary.
final class AgentCharcoalAppExample extends StatelessWidget {
  const AgentCharcoalAppExample({
    required this.routerConfig,
    required this.localizationsDelegates,
    required this.supportedLocales,
    super.key,
  });

  final RouterConfig<Object> routerConfig;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) => CharcoalApp.router(
    routerConfig: routerConfig,
    localizationsDelegates: localizationsDelegates,
    supportedLocales: supportedLocales,
    restorationScopeId: 'charcoal-example-app',
    title: 'Charcoal',
  );
}
